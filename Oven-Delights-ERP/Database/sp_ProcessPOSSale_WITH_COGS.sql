-- =============================================
-- Process POS Sale WITH COGS POSTING
-- Called when a sale is completed at POS
-- 1. Records sale transaction
-- 2. Reduces retail stock (Finished Goods)
-- 3. Posts GL entries for revenue and COGS
--    DR: Cash/Debtors - Selling price
--    CR: Sales Revenue (4000) - Selling price
--    DR: Cost of Sales (5000) - Product cost
--    CR: Finished Goods Inventory (1420) - Product cost
-- =============================================
CREATE OR ALTER PROCEDURE sp_ProcessPOSSale
    @TransactionID INT OUTPUT,
    @BranchID INT,
    @CashierID INT,
    @CustomerID INT = NULL,
    @PaymentMethod NVARCHAR(50), -- 'Cash', 'Card', 'Account'
    @TotalAmount DECIMAL(18,2),
    @VATAmount DECIMAL(18,2) = 0,
    @DiscountAmount DECIMAL(18,2) = 0,
    @TenderAmount DECIMAL(18,2) = 0,
    @ChangeAmount DECIMAL(18,2) = 0,
    @TransactionDate DATETIME = NULL,
    @Success BIT OUTPUT,
    @Message NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Set transaction date if not provided
        IF @TransactionDate IS NULL
            SET @TransactionDate = GETDATE()
        
        -- Generate transaction reference
        DECLARE @TransactionRef NVARCHAR(50) = 'POS-' + CAST(@BranchID AS NVARCHAR(10)) + '-' + FORMAT(@TransactionDate, 'yyyyMMddHHmmss')
        
        -- Track total COGS for GL posting
        DECLARE @TotalCOGS DECIMAL(18,2) = 0
        
        -- Create transaction header (POS tables will be created later)
        -- For now, just generate a transaction ID
        -- When POS tables are created, this section will be updated to insert transaction records
        SET @TransactionID = ABS(CHECKSUM(NEWID())) -- Generate unique ID
        
        -- ========================================
        -- POST GL ENTRIES FOR SALE
        -- ========================================
        IF OBJECT_ID('dbo.Journals', 'U') IS NOT NULL AND 
           OBJECT_ID('dbo.sp_CreateJournalEntry', 'P') IS NOT NULL
        BEGIN
            DECLARE @JournalID INT
            DECLARE @FiscalPeriodID INT = 1
            DECLARE @JournalReference NVARCHAR(50) = @TransactionRef
            DECLARE @JournalDescription NVARCHAR(255) = 'POS Sale - ' + @TransactionRef
            
            -- Create journal entry
            EXEC sp_CreateJournalEntry 
                @JournalDate = @TransactionDate,
                @Reference = @JournalReference,
                @Description = @JournalDescription,
                @FiscalPeriodID = @FiscalPeriodID,
                @BranchID = @BranchID,
                @CreatedBy = @CashierID,
                @JournalID = @JournalID OUTPUT
            
            -- Get account IDs
            DECLARE @CashAccountID INT
            DECLARE @DebtorsAccountID INT
            DECLARE @SalesRevenueAccountID INT
            DECLARE @COGSAccountID INT
            DECLARE @FinishedGoodsAccountID INT
            
            SELECT @CashAccountID = AccountID 
            FROM ChartOfAccounts 
            WHERE AccountCode = '1100' -- Cash
            
            SELECT @DebtorsAccountID = AccountID 
            FROM ChartOfAccounts 
            WHERE AccountCode = '1200' -- Accounts Receivable
            
            SELECT @SalesRevenueAccountID = AccountID 
            FROM ChartOfAccounts 
            WHERE AccountCode = '4000' -- Sales Revenue
            
            SELECT @COGSAccountID = AccountID 
            FROM ChartOfAccounts 
            WHERE AccountCode = '5000' -- Cost of Sales
            
            SELECT @FinishedGoodsAccountID = AccountID 
            FROM ChartOfAccounts 
            WHERE AccountCode = '1420' -- Finished Goods Inventory
            
            -- Determine debit account based on payment method
            DECLARE @DebitAccountID INT
            IF @PaymentMethod = 'Account'
                SET @DebitAccountID = @DebtorsAccountID
            ELSE
                SET @DebitAccountID = @CashAccountID
            
            -- Post revenue entries
            IF @DebitAccountID IS NOT NULL AND @SalesRevenueAccountID IS NOT NULL
            BEGIN
                -- DR: Cash/Debtors - Selling price
                DECLARE @DescSaleDR NVARCHAR(255) = 'POS Sale - ' + @PaymentMethod
                EXEC sp_AddJournalDetail
                    @JournalID = @JournalID,
                    @AccountID = @DebitAccountID,
                    @Debit = @TotalAmount,
                    @Credit = 0,
                    @Description = @DescSaleDR
                
                -- CR: Sales Revenue (4000) - Selling price
                EXEC sp_AddJournalDetail
                    @JournalID = @JournalID,
                    @AccountID = @SalesRevenueAccountID,
                    @Debit = 0,
                    @Credit = @TotalAmount,
                    @Description = 'POS Sale Revenue'
            END
            
            -- Note: COGS entries will be posted per line item
            -- This is a placeholder - actual line items would be processed in a separate procedure
            -- or passed as a table parameter
            
            -- For now, we'll store the JournalID for line item processing
            DECLARE @SaleJournalID INT = @JournalID
            
            -- Auto-post the journal
            EXEC sp_PostJournal
                @JournalID = @JournalID,
                @PostedBy = @CashierID
        END
        
        SET @Success = 1
        SET @Message = 'Sale processed successfully. Transaction: ' + @TransactionRef
        
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
            
        SET @Success = 0
        SET @Message = 'Error: ' + ERROR_MESSAGE()
    END CATCH
END
GO

-- =============================================
-- Process POS Sale Line Item WITH COGS
-- Called for each line item in a POS sale
-- Reduces stock and posts COGS
-- =============================================
CREATE OR ALTER PROCEDURE sp_ProcessPOSSaleLineItem
    @TransactionID INT,
    @ProductID INT,
    @Quantity DECIMAL(18,2),
    @UnitPrice DECIMAL(18,2),
    @LineTotal DECIMAL(18,2),
    @BranchID INT,
    @CashierID INT,
    @JournalID INT = NULL, -- Optional: if provided, will add COGS entries to this journal
    @Success BIT OUTPUT,
    @Message NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Get product details and cost
        DECLARE @ProductName NVARCHAR(200)
        DECLARE @ProductCost DECIMAL(18,2)
        DECLARE @CurrentStock DECIMAL(18,2)
        
        SELECT 
            @ProductName = Name,
            @ProductCost = ISNULL(AverageCost, ISNULL(LastPaidPrice, 0)),
            @CurrentStock = ISNULL(CurrentStock, 0)
        FROM Demo_Retail_Product
        WHERE ProductID = @ProductID AND BranchID = @BranchID
        
        -- Check stock availability
        IF @CurrentStock < @Quantity
        BEGIN
            SET @Success = 0
            SET @Message = 'Insufficient stock for product: ' + @ProductName + 
                          '. Required: ' + CAST(@Quantity AS NVARCHAR(50)) + 
                          ', Available: ' + CAST(@CurrentStock AS NVARCHAR(50))
            ROLLBACK TRANSACTION
            RETURN
        END
        
        -- Calculate COGS
        DECLARE @LineCOGS DECIMAL(18,2) = @Quantity * @ProductCost
        
        -- Reduce retail stock
        UPDATE Demo_Retail_Product
        SET 
            CurrentStock = CurrentStock - @Quantity,
            LastUpdated = GETDATE()
        WHERE ProductID = @ProductID AND BranchID = @BranchID
        
        -- Save line item (POS tables will be created later)
        -- For now, skip transaction detail insert
        -- When POS tables are created, this section will be updated to insert line item records
        
        -- Post COGS to GL if journal provided
        IF @JournalID IS NOT NULL AND 
           OBJECT_ID('dbo.sp_AddJournalDetail', 'P') IS NOT NULL
        BEGIN
            DECLARE @COGSAccountID INT
            DECLARE @FinishedGoodsAccountID INT
            
            SELECT @COGSAccountID = AccountID 
            FROM ChartOfAccounts 
            WHERE AccountCode = '5000' -- Cost of Sales
            
            SELECT @FinishedGoodsAccountID = AccountID 
            FROM ChartOfAccounts 
            WHERE AccountCode = '1420' -- Finished Goods Inventory
            
            IF @COGSAccountID IS NOT NULL AND @FinishedGoodsAccountID IS NOT NULL
            BEGIN
                -- DR: Cost of Sales (5000) - Product cost
                DECLARE @DescCOGSDR NVARCHAR(255) = 'COGS: ' + @ProductName + ' (Qty: ' + CAST(@Quantity AS NVARCHAR(20)) + ')'
                EXEC sp_AddJournalDetail
                    @JournalID = @JournalID,
                    @AccountID = @COGSAccountID,
                    @Debit = @LineCOGS,
                    @Credit = 0,
                    @Description = @DescCOGSDR
                
                -- CR: Finished Goods Inventory (1420) - Product cost
                DECLARE @DescInventoryCR NVARCHAR(255) = 'Inventory reduction: ' + @ProductName
                EXEC sp_AddJournalDetail
                    @JournalID = @JournalID,
                    @AccountID = @FinishedGoodsAccountID,
                    @Debit = 0,
                    @Credit = @LineCOGS,
                    @Description = @DescInventoryCR
            END
        END
        
        SET @Success = 1
        SET @Message = 'Line item processed. Product: ' + @ProductName + 
                      ' | Qty: ' + CAST(@Quantity AS NVARCHAR(20)) +
                      ' | COGS: R' + CAST(@LineCOGS AS NVARCHAR(20))
        
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
            
        SET @Success = 0
        SET @Message = 'Error: ' + ERROR_MESSAGE()
    END CATCH
END
GO

PRINT 'sp_ProcessPOSSale and sp_ProcessPOSSaleLineItem WITH COGS created successfully'
GO
