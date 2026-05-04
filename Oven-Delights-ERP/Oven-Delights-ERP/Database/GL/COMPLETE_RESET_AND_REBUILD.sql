-- =============================================
-- COMPLETE RESET AND REBUILD
-- Removes all bank statement GL postings and procedures
-- Rebuilds with clean, simple logic
-- =============================================

PRINT '========================================='
PRINT 'STEP 1: DELETE ALL BANK STATEMENT GL ENTRIES'
PRINT '========================================='

-- Delete all GeneralLedger entries related to bank statements
DELETE FROM GeneralLedger
WHERE JournalEntryNumber LIKE 'JE-%'
   OR Description LIKE '%Bank Deposit%'
   OR Description LIKE '%Bank Payment%'
   OR Description LIKE '%EFT Payment%'
   OR Description LIKE '%Supplier Payment%'
   OR Description LIKE '%Customer Payment%'
   OR Description LIKE '%Cash Deposit%';

PRINT 'Deleted ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' GL entries';
PRINT '';

PRINT '========================================='
PRINT 'STEP 2: RESET AP_STATEMENT_TRANSACTIONS'
PRINT '========================================='

-- Reset all bank statement transactions
UPDATE AP_StatementTransactions
SET IsReconciled = 0,
    ReconciledDate = NULL,
    ReconciledBy = NULL,
    IsMapped = 0,
    MappedLedgerAccount = NULL,
    MappedDate = NULL,
    MappedBy = NULL;

PRINT 'Reset ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' transactions';
PRINT '';

PRINT '========================================='
PRINT 'STEP 3: DROP ALL OLD POSTING PROCEDURES'
PRINT '========================================='

IF OBJECT_ID('sp_PostCreditTransactionsToLedgers', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE sp_PostCreditTransactionsToLedgers;
    PRINT 'Dropped sp_PostCreditTransactionsToLedgers';
END

IF OBJECT_ID('sp_PostDebitTransactionsToLedgers', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE sp_PostDebitTransactionsToLedgers;
    PRINT 'Dropped sp_PostDebitTransactionsToLedgers';
END

PRINT '';
PRINT '========================================='
PRINT 'STEP 4: CREATE CLEAN POSTING PROCEDURES'
PRINT '========================================='
GO

-- =============================================
-- POST CREDIT TRANSACTIONS (Money INTO bank)
-- DEBIT Bank / CREDIT Source
-- =============================================
CREATE PROCEDURE sp_PostCreditTransactionsToLedgers
    @TransactionID INT,
    @PostedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Amount DECIMAL(18,2);
    DECLARE @Description NVARCHAR(500);
    DECLARE @TransactionDate DATE;
    DECLARE @Reference NVARCHAR(200);
    DECLARE @ContraAccount NVARCHAR(10);
    DECLARE @JournalEntryNumber NVARCHAR(50);
    
    SELECT @Amount = Amount, @Description = Description, @TransactionDate = TransactionDate, @Reference = Reference
    FROM AP_StatementTransactions WHERE TransactionID = @TransactionID;
    
    -- Find matching keyword (highest priority first)
    SELECT TOP 1 @ContraAccount = AccountCode
    FROM BankStatementKeywordMapping
    WHERE TransactionType = 'Credit' AND IsActive = 1
        AND (@Description LIKE '%' + Keyword + '%' OR @Reference LIKE '%' + Keyword + '%')
    ORDER BY Priority ASC;
    
    IF @ContraAccount IS NULL SET @ContraAccount = '1200'; -- Default to AR
    
    SET @JournalEntryNumber = 'JE-' + CONVERT(VARCHAR(8), @TransactionDate, 112) + '-' + CAST(@TransactionID AS VARCHAR(10));
    
    BEGIN TRANSACTION;
    BEGIN TRY
        -- DEBIT Bank (money IN)
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalEntryNumber, '1120', @TransactionDate, 'Bank Deposit: ' + @Description, @Amount, 0, @Reference, @PostedBy, GETDATE(), 0);
        
        -- CREDIT Source
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalEntryNumber, @ContraAccount, @TransactionDate, @Description, 0, @Amount, @Reference, @PostedBy, GETDATE(), 0);
        
        UPDATE AP_StatementTransactions SET IsReconciled = 1, ReconciledDate = GETDATE(), ReconciledBy = @PostedBy, MappedLedgerAccount = @ContraAccount WHERE TransactionID = @TransactionID;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

-- =============================================
-- POST DEBIT TRANSACTIONS (Money OUT of bank)
-- DEBIT Expense/Supplier / CREDIT Bank
-- =============================================
CREATE PROCEDURE sp_PostDebitTransactionsToLedgers
    @TransactionID INT,
    @PostedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Amount DECIMAL(18,2);
    DECLARE @Description NVARCHAR(500);
    DECLARE @TransactionDate DATE;
    DECLARE @Reference NVARCHAR(200);
    DECLARE @ContraAccount NVARCHAR(10);
    DECLARE @JournalEntryNumber NVARCHAR(50);
    
    SELECT @Amount = Amount, @Description = Description, @TransactionDate = TransactionDate, @Reference = Reference
    FROM AP_StatementTransactions WHERE TransactionID = @TransactionID;
    
    -- Try supplier subsidiary ledger first
    IF @Description LIKE '%INV%' OR @Reference LIKE '%INV%'
    BEGIN
        SELECT TOP 1 @ContraAccount = coa.AccountCode
        FROM AP_Invoices ap
        INNER JOIN ChartOfAccounts coa ON ap.BeneficiaryID = coa.SupplierID AND coa.IsSubsidiaryLedger = 1
        WHERE (ap.InvoiceNumber LIKE '%' + REPLACE(@Description, 'INV-', '') + '%' OR ap.Reference LIKE '%' + REPLACE(@Description, 'INV-', '') + '%')
            AND ap.Status IN ('Pending', 'Overdue') AND ABS(ap.TotalAmount - @Amount) < 5.00
        ORDER BY ap.InvoiceDate DESC;
    END
    
    -- If no supplier match, use keyword mapping
    IF @ContraAccount IS NULL
    BEGIN
        SELECT TOP 1 @ContraAccount = AccountCode
        FROM BankStatementKeywordMapping
        WHERE TransactionType = 'Debit' AND IsActive = 1
            AND (@Description LIKE '%' + Keyword + '%' OR @Reference LIKE '%' + Keyword + '%')
        ORDER BY Priority ASC;
    END
    
    IF @ContraAccount IS NULL SET @ContraAccount = '2100'; -- Default to AP
    
    SET @JournalEntryNumber = 'JE-' + CONVERT(VARCHAR(8), @TransactionDate, 112) + '-' + CAST(@TransactionID AS VARCHAR(10));
    
    BEGIN TRANSACTION;
    BEGIN TRY
        -- DEBIT Expense/Supplier (money OUT reduces liability or increases expense)
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalEntryNumber, @ContraAccount, @TransactionDate, @Description, @Amount, 0, @Reference, @PostedBy, GETDATE(), 0);
        
        -- CREDIT Bank (money OUT)
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalEntryNumber, '1120', @TransactionDate, 'Bank Payment: ' + @Description, 0, @Amount, @Reference, @PostedBy, GETDATE(), 0);
        
        UPDATE AP_StatementTransactions SET IsReconciled = 1, ReconciledDate = GETDATE(), ReconciledBy = @PostedBy, MappedLedgerAccount = @ContraAccount WHERE TransactionID = @TransactionID;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMsg, 16, 1);
    END CATCH
END
GO

PRINT 'Clean posting procedures created';
PRINT '';
PRINT '========================================='
PRINT 'RESET COMPLETE - READY FOR TESTING'
PRINT '========================================='
PRINT '';
PRINT 'Next steps:';
PRINT '1. Rebuild application';
PRINT '2. Run Auto-Map All Transactions';
PRINT '3. Verify ledgers show correct debit/credit entries';
GO
