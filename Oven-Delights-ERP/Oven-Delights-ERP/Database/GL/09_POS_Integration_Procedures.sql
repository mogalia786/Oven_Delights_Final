-- =============================================
-- POS Integration - GL Posting Procedures
-- =============================================

-- =============================================
-- sp_POS_PostSaleToGL - Post POS sale to General Ledger
-- =============================================
CREATE OR ALTER PROCEDURE sp_POS_PostSaleToGL
    @InvoiceNumber NVARCHAR(50),
    @SaleDate DATE,
    @BranchID INT,
    @CashierID INT,
    @Subtotal DECIMAL(18,2),
    @TaxAmount DECIMAL(18,2),
    @TotalAmount DECIMAL(18,2),
    @CashAmount DECIMAL(18,2),
    @CardAmount DECIMAL(18,2),
    @TotalCost DECIMAL(18,2),
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @BankAccountID INT
        DECLARE @CashAccountID INT
        DECLARE @SalesAccountID INT
        DECLARE @VATAccountID INT
        DECLARE @COGSAccountID INT
        DECLARE @InventoryAccountID INT
        
        -- Get Account IDs
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @CashAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1030' AND IsActive = 1
        SELECT @SalesAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '4010' AND IsActive = 1
        SELECT @VATAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2020' AND IsActive = 1
        SELECT @COGSAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '5010' AND IsActive = 1
        SELECT @InventoryAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1220' AND IsActive = 1
        
        -- Generate journal number (shortened to fit 20-char limit)
        -- Handle both formats: "INV-PH-TILL-01-000056" and "620061"
        DECLARE @SequenceNumber NVARCHAR(10)
        IF CHARINDEX('-', @InvoiceNumber) > 0
            SET @SequenceNumber = RIGHT(@InvoiceNumber, CHARINDEX('-', REVERSE(@InvoiceNumber)) - 1)
        ELSE
            SET @SequenceNumber = @InvoiceNumber
        SET @JournalNumber = 'POS-' + @SequenceNumber
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @SaleDate,
            @InvoiceNumber,
            'POS Sale - Invoice ' + @InvoiceNumber,
            dbo.fn_GetCurrentFiscalPeriodID(@SaleDate),
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        DECLARE @LineNumber INT = 1
        
        -- Debit: Bank (Card payment)
        IF @CardAmount > 0
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1
            )
            VALUES (
                @JournalID, @LineNumber, @BankAccountID, @CardAmount, 0,
                'Card Payment', @InvoiceNumber
            )
            SET @LineNumber = @LineNumber + 1
        END
        
        -- Debit: Cash (Cash payment)
        IF @CashAmount > 0
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1
            )
            VALUES (
                @JournalID, @LineNumber, @CashAccountID, @CashAmount, 0,
                'Cash Payment', @InvoiceNumber
            )
            SET @LineNumber = @LineNumber + 1
        END
        
        -- Credit: Sales Revenue
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1
        )
        VALUES (
            @JournalID, @LineNumber, @SalesAccountID, 0, @Subtotal,
            'Sales Revenue', @InvoiceNumber
        )
        SET @LineNumber = @LineNumber + 1
        
        -- Credit: VAT Payable
        IF @TaxAmount > 0
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1
            )
            VALUES (
                @JournalID, @LineNumber, @VATAccountID, 0, @TaxAmount,
                'VAT on Sales', @InvoiceNumber
            )
            SET @LineNumber = @LineNumber + 1
        END
        
        -- Debit: Cost of Goods Sold
        IF @TotalCost > 0
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1
            )
            VALUES (
                @JournalID, @LineNumber, @COGSAccountID, @TotalCost, 0,
                'Cost of Goods Sold', @InvoiceNumber
            )
            SET @LineNumber = @LineNumber + 1
            
            -- Credit: Inventory
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1
            )
            VALUES (
                @JournalID, @LineNumber, @InventoryAccountID, 0, @TotalCost,
                'Inventory Reduction', @InvoiceNumber
            )
        END
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, 'POS sale posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Don't throw error - sale is more important than GL posting
        -- Just log the error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        PRINT 'GL Posting Error: ' + @ErrorMessage
        SELECT 0 AS JournalID, 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

-- =============================================
-- sp_POS_PostRefundToGL - Post POS refund to General Ledger
-- =============================================
CREATE OR ALTER PROCEDURE sp_POS_PostRefundToGL
    @InvoiceNumber NVARCHAR(50),
    @RefundDate DATE,
    @BranchID INT,
    @CashierID INT,
    @Subtotal DECIMAL(18,2),
    @TaxAmount DECIMAL(18,2),
    @TotalAmount DECIMAL(18,2),
    @RefundMethod NVARCHAR(20),
    @TotalCost DECIMAL(18,2),
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @BankAccountID INT
        DECLARE @CashAccountID INT
        DECLARE @SalesAccountID INT
        DECLARE @VATAccountID INT
        DECLARE @COGSAccountID INT
        DECLARE @InventoryAccountID INT
        
        -- Get Account IDs
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @CashAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1030' AND IsActive = 1
        SELECT @SalesAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '4010' AND IsActive = 1
        SELECT @VATAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2020' AND IsActive = 1
        SELECT @COGSAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '5010' AND IsActive = 1
        SELECT @InventoryAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1220' AND IsActive = 1
        
        -- Generate journal number (shortened to fit 20-char limit)
        -- Handle both formats: "RET-PH-TILL-01-000123" and "620061"
        DECLARE @SequenceNumber NVARCHAR(10)
        IF CHARINDEX('-', @InvoiceNumber) > 0
            SET @SequenceNumber = RIGHT(@InvoiceNumber, CHARINDEX('-', REVERSE(@InvoiceNumber)) - 1)
        ELSE
            SET @SequenceNumber = @InvoiceNumber
        SET @JournalNumber = 'REF-' + @SequenceNumber
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @RefundDate,
            @InvoiceNumber,
            'POS Refund - Invoice ' + @InvoiceNumber,
            dbo.fn_GetCurrentFiscalPeriodID(@RefundDate),
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        DECLARE @LineNumber INT = 1
        
        -- REVERSE THE SALE ENTRIES
        
        -- Debit: Sales Revenue (reverse)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1
        )
        VALUES (
            @JournalID, @LineNumber, @SalesAccountID, @Subtotal, 0,
            'Refund - Sales Reversal', @InvoiceNumber
        )
        SET @LineNumber = @LineNumber + 1
        
        -- Debit: VAT Payable (reverse)
        IF @TaxAmount > 0
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1
            )
            VALUES (
                @JournalID, @LineNumber, @VATAccountID, @TaxAmount, 0,
                'Refund - VAT Reversal', @InvoiceNumber
            )
            SET @LineNumber = @LineNumber + 1
        END
        
        -- Credit: Bank or Cash (refund payment)
        IF @RefundMethod = 'Card'
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1
            )
            VALUES (
                @JournalID, @LineNumber, @BankAccountID, 0, @TotalAmount,
                'Card Refund', @InvoiceNumber
            )
        END
        ELSE
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1
            )
            VALUES (
                @JournalID, @LineNumber, @CashAccountID, 0, @TotalAmount,
                'Cash Refund', @InvoiceNumber
            )
        END
        SET @LineNumber = @LineNumber + 1
        
        -- Debit: Inventory (restore stock)
        IF @TotalCost > 0
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1
            )
            VALUES (
                @JournalID, @LineNumber, @InventoryAccountID, @TotalCost, 0,
                'Inventory Restoration', @InvoiceNumber
            )
            SET @LineNumber = @LineNumber + 1
            
            -- Credit: COGS (reverse)
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1
            )
            VALUES (
                @JournalID, @LineNumber, @COGSAccountID, 0, @TotalCost,
                'COGS Reversal', @InvoiceNumber
            )
        END
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, 'POS refund posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        PRINT 'GL Posting Error: ' + @ErrorMessage
        SELECT 0 AS JournalID, 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT 'POS Integration procedures created successfully'
GO
