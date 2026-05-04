-- =============================================
-- Inventory GL Integration
-- =============================================

-- =============================================
-- sp_INV_PostStockAdjustmentToGL - Post Stock Adjustment to GL
-- =============================================
CREATE OR ALTER PROCEDURE sp_INV_PostStockAdjustmentToGL
    @AdjustmentID INT,
    @AdjustmentNumber NVARCHAR(50),
    @AdjustmentDate DATE,
    @ProductName NVARCHAR(200),
    @BranchID INT,
    @AdjustmentType NVARCHAR(20), -- 'Increase' or 'Decrease'
    @Reason NVARCHAR(100), -- 'Count Variance', 'Damage', 'Theft', 'Found Stock', 'Expired'
    @AdjustmentValue DECIMAL(18,2),
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @InventoryAccountID INT
        DECLARE @StockLossAccountID INT
        DECLARE @OtherIncomeAccountID INT
        
        -- Get account IDs
        SELECT @InventoryAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1220' AND IsActive = 1
        SELECT @StockLossAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '6080' AND IsActive = 1
        SELECT @OtherIncomeAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '4030' AND IsActive = 1
        
        -- Validate accounts exist
        IF @InventoryAccountID IS NULL
            RAISERROR('Inventory account 1220 not found or inactive', 16, 1)
            
        IF @StockLossAccountID IS NULL
            RAISERROR('Stock Loss account 6080 not found or inactive', 16, 1)
            
        IF @OtherIncomeAccountID IS NULL
            RAISERROR('Other Income account 4030 not found or inactive', 16, 1)
        
        -- Generate journal number
        SET @JournalNumber = 'ADJ-' + @AdjustmentNumber
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @AdjustmentDate,
            @AdjustmentNumber,
            'Stock Adjustment - ' + @Reason + ' - ' + @ProductName,
            dbo.fn_GetCurrentFiscalPeriodID(@AdjustmentDate),
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Post based on adjustment type
        IF @AdjustmentType = 'Increase'
        BEGIN
            -- Stock found/added
            -- Debit: Inventory (Increase stock value)
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, 1, @InventoryAccountID, @AdjustmentValue, 0,
                'Stock Increase - ' + @Reason, @AdjustmentNumber, @ProductName
            )
            
            -- Credit: Other Income (Found stock)
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, 2, @OtherIncomeAccountID, 0, @AdjustmentValue,
                'Found Stock Income', @AdjustmentNumber, @ProductName
            )
        END
        ELSE IF @AdjustmentType = 'Decrease'
        BEGIN
            -- Stock loss/shrinkage
            -- Debit: Stock Loss/Shrinkage (Expense)
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, 1, @StockLossAccountID, @AdjustmentValue, 0,
                'Stock Loss - ' + @Reason, @AdjustmentNumber, @ProductName
            )
            
            -- Credit: Inventory (Reduce stock value)
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, 2, @InventoryAccountID, 0, @AdjustmentValue,
                'Stock Decrease - ' + @Reason, @AdjustmentNumber, @ProductName
            )
        END
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, 'Stock adjustment posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT 'Inventory GL Integration procedure created successfully'
GO
