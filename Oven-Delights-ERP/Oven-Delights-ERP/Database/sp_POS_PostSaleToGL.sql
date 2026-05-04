-- =============================================
-- POS Sale to General Ledger Posting
-- Posts cash sales to proper GL accounts
-- IMPORTANT: This procedure does NOT create its own transaction
-- It expects to be called within an existing transaction from POS
-- =============================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_POS_PostSaleToGL]') AND type in (N'P'))
    DROP PROCEDURE [dbo].[sp_POS_PostSaleToGL]
GO

CREATE PROCEDURE [dbo].[sp_POS_PostSaleToGL]
    @InvoiceNumber NVARCHAR(50),
    @SaleDate DATE,
    @BranchID INT,
    @CashierID INT,
    @Subtotal DECIMAL(18,2),
    @TaxAmount DECIMAL(18,2),
    @TotalAmount DECIMAL(18,2),
    @CashAmount DECIMAL(18,2),
    @CardAmount DECIMAL(18,2),
    @EFTAmount DECIMAL(18,2),
    @TotalCost DECIMAL(18,2),
    @CreatedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @JournalNumber NVARCHAR(50) = 'SALE-' + @InvoiceNumber
    DECLARE @GrossProfitAmount DECIMAL(18,2) = @Subtotal - @TotalCost
    
    -- =============================================
    -- 1. DEBIT: Cash on Hand / Bank (Asset increases)
    -- =============================================
    
    -- Cash sales go to Cash on Hand (1110)
    IF @CashAmount > 0
    BEGIN
        INSERT INTO GeneralLedger (
            JournalEntryNumber, TransactionDate, AccountID, DebitAmount, CreditAmount,
            Description, ReferenceType, ReferenceID, BranchID, CreatedBy
        )
        SELECT 
            @JournalNumber, 
            @SaleDate, 
            AccountID, 
            @CashAmount, 
            0,
            'Cash sale - Invoice ' + @InvoiceNumber,
            'Sale',
            @InvoiceNumber,
            @BranchID,
            @CreatedBy
        FROM ChartOfAccounts
        WHERE AccountCode = '1110' -- Cash on Hand
        
        -- Record in Cash Register
        INSERT INTO CashRegister (
            BranchID, TillPointID, TransactionDate, TransactionType, Amount,
            PaymentMethod, ReferenceNumber, Description, CashierID, CashierName
        )
        VALUES (
            @BranchID, 1, @SaleDate, 'Sale', @CashAmount,
            'Cash', @InvoiceNumber, 'Cash sale', @CashierID, @CreatedBy
        )
    END
    
    -- Card sales go to Bank (1120)
    IF @CardAmount > 0
    BEGIN
        INSERT INTO GeneralLedger (
            JournalEntryNumber, TransactionDate, AccountID, DebitAmount, CreditAmount,
            Description, ReferenceType, ReferenceID, BranchID, CreatedBy
        )
        SELECT 
            @JournalNumber, 
            @SaleDate, 
            AccountID, 
            @CardAmount, 
            0,
            'Card sale - Invoice ' + @InvoiceNumber,
            'Sale',
            @InvoiceNumber,
            @BranchID,
            @CreatedBy
        FROM ChartOfAccounts
        WHERE AccountCode = '1120' -- Bank
    END
    
    -- EFT sales go to Bank (1120)
    IF @EFTAmount > 0
    BEGIN
        INSERT INTO GeneralLedger (
            JournalEntryNumber, TransactionDate, AccountID, DebitAmount, CreditAmount,
            Description, ReferenceType, ReferenceID, BranchID, CreatedBy
        )
        SELECT 
            @JournalNumber, 
            @SaleDate, 
            AccountID, 
            @EFTAmount, 
            0,
            'EFT sale - Invoice ' + @InvoiceNumber,
            'Sale',
            @InvoiceNumber,
            @BranchID,
            @CreatedBy
        FROM ChartOfAccounts
        WHERE AccountCode = '1120' -- Bank
    END
    
    -- =============================================
    -- 2. CREDIT: Sales Revenue (Income increases)
    -- =============================================
    INSERT INTO GeneralLedger (
        JournalEntryNumber, TransactionDate, AccountID, DebitAmount, CreditAmount,
        Description, ReferenceType, ReferenceID, BranchID, CreatedBy
    )
    SELECT 
        @JournalNumber, 
        @SaleDate, 
        AccountID, 
        0, 
        @Subtotal,
        'Sales revenue - Invoice ' + @InvoiceNumber,
        'Sale',
        @InvoiceNumber,
        @BranchID,
        @CreatedBy
    FROM ChartOfAccounts
    WHERE AccountCode = '4100' -- Sales Revenue
    
    -- =============================================
    -- 3. CREDIT: VAT Payable (Liability increases)
    -- =============================================
    IF @TaxAmount > 0
    BEGIN
        INSERT INTO GeneralLedger (
            JournalEntryNumber, TransactionDate, AccountID, DebitAmount, CreditAmount,
            Description, ReferenceType, ReferenceID, BranchID, CreatedBy
        )
        SELECT 
            @JournalNumber, 
            @SaleDate, 
            AccountID, 
            0, 
            @TaxAmount,
            'VAT on sale - Invoice ' + @InvoiceNumber,
            'Sale',
            @InvoiceNumber,
            @BranchID,
            @CreatedBy
        FROM ChartOfAccounts
        WHERE AccountCode = '2110' -- VAT Payable
    END
    
    -- =============================================
    -- 4. DEBIT: Cost of Goods Sold (Expense increases)
    -- =============================================
    IF @TotalCost > 0
    BEGIN
        INSERT INTO GeneralLedger (
            JournalEntryNumber, TransactionDate, AccountID, DebitAmount, CreditAmount,
            Description, ReferenceType, ReferenceID, BranchID, CreatedBy
        )
        SELECT 
            @JournalNumber, 
            @SaleDate, 
            AccountID, 
            @TotalCost, 
            0,
            'Cost of goods sold - Invoice ' + @InvoiceNumber,
            'Sale',
            @InvoiceNumber,
            @BranchID,
            @CreatedBy
        FROM ChartOfAccounts
        WHERE AccountCode = '5100' -- Cost of Goods Sold
        
        -- =============================================
        -- 5. CREDIT: Inventory (Asset decreases)
        -- =============================================
        INSERT INTO GeneralLedger (
            JournalEntryNumber, TransactionDate, AccountID, DebitAmount, CreditAmount,
            Description, ReferenceType, ReferenceID, BranchID, CreatedBy
        )
        SELECT 
            @JournalNumber, 
            @SaleDate, 
            AccountID, 
            0, 
            @TotalCost,
            'Inventory reduction - Invoice ' + @InvoiceNumber,
            'Sale',
            @InvoiceNumber,
            @BranchID,
            @CreatedBy
        FROM ChartOfAccounts
        WHERE AccountCode = '1300' -- Inventory
    END
    
    RETURN 0
END
GO

PRINT 'sp_POS_PostSaleToGL created successfully'
PRINT 'This procedure posts POS sales to General Ledger without creating nested transactions'
GO
