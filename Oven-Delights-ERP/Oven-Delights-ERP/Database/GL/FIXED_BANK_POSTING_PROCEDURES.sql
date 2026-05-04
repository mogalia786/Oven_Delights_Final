-- =============================================
-- FIXED BANK STATEMENT POSTING PROCEDURES
-- Correctly uses AccountID (INT) from ChartOfAccounts
-- =============================================

-- Drop existing procedures
IF OBJECT_ID('sp_PostCreditTransactionsToLedgers', 'P') IS NOT NULL
    DROP PROCEDURE sp_PostCreditTransactionsToLedgers;
GO

IF OBJECT_ID('sp_PostDebitTransactionsToLedgers', 'P') IS NOT NULL
    DROP PROCEDURE sp_PostDebitTransactionsToLedgers;
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
    DECLARE @ContraAccountCode NVARCHAR(20);
    DECLARE @ContraAccountID INT;
    DECLARE @BankAccountID INT;
    DECLARE @JournalEntryNumber NVARCHAR(50);
    
    -- Get transaction details
    SELECT @Amount = Amount, @Description = Description, @TransactionDate = TransactionDate, @Reference = Reference
    FROM AP_StatementTransactions WHERE TransactionID = @TransactionID;
    
    -- Get Bank Account ID (1120)
    SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1120' AND IsActive = 1;
    
    IF @BankAccountID IS NULL
    BEGIN
        RAISERROR('Bank account 1120 not found in ChartOfAccounts', 16, 1);
        RETURN;
    END
    
    -- Find matching keyword (highest priority first)
    SELECT TOP 1 @ContraAccountCode = AccountCode
    FROM BankStatementKeywordMapping
    WHERE TransactionType = 'Credit' AND IsActive = 1
        AND (@Description LIKE '%' + Keyword + '%' OR @Reference LIKE '%' + Keyword + '%')
    ORDER BY Priority ASC;
    
    -- Default to Accounts Receivable if no match
    IF @ContraAccountCode IS NULL SET @ContraAccountCode = '1200';
    
    -- Get ContraAccount ID from ChartOfAccounts
    SELECT @ContraAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = @ContraAccountCode AND IsActive = 1;
    
    IF @ContraAccountID IS NULL
    BEGIN
        RAISERROR('Contra account %s not found in ChartOfAccounts', 16, 1, @ContraAccountCode);
        RETURN;
    END
    
    SET @JournalEntryNumber = 'JE-' + CONVERT(VARCHAR(8), @TransactionDate, 112) + '-' + CAST(@TransactionID AS VARCHAR(10));
    
    BEGIN TRANSACTION;
    BEGIN TRY
        -- DEBIT Bank (money IN increases asset)
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalEntryNumber, @BankAccountID, @TransactionDate, 'Bank Deposit: ' + @Description, @Amount, 0, @Reference, @PostedBy, GETDATE(), 0);
        
        -- CREDIT Source (cash out, customer paid, income earned)
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalEntryNumber, @ContraAccountID, @TransactionDate, @Description, 0, @Amount, @Reference, @PostedBy, GETDATE(), 0);
        
        -- Mark as posted
        UPDATE AP_StatementTransactions 
        SET IsReconciled = 1, ReconciledDate = GETDATE(), ReconciledBy = @PostedBy, MappedLedgerAccount = @ContraAccountCode
        WHERE TransactionID = @TransactionID;
        
        COMMIT TRANSACTION;
        PRINT 'Credit posted: DR Bank(' + CAST(@BankAccountID AS VARCHAR) + ') / CR ' + @ContraAccountCode + '(' + CAST(@ContraAccountID AS VARCHAR) + ') - ' + @Description;
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
    DECLARE @ContraAccountCode NVARCHAR(20);
    DECLARE @ContraAccountID INT;
    DECLARE @BankAccountID INT;
    DECLARE @JournalEntryNumber NVARCHAR(50);
    DECLARE @SupplierAccountCode NVARCHAR(20);
    
    -- Get transaction details
    SELECT @Amount = Amount, @Description = Description, @TransactionDate = TransactionDate, @Reference = Reference
    FROM AP_StatementTransactions WHERE TransactionID = @TransactionID;
    
    -- Get Bank Account ID (1120)
    SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1120' AND IsActive = 1;
    
    IF @BankAccountID IS NULL
    BEGIN
        RAISERROR('Bank account 1120 not found in ChartOfAccounts', 16, 1);
        RETURN;
    END
    
    -- Try to match supplier subsidiary ledger first
    IF @Description LIKE '%INV%' OR @Reference LIKE '%INV%'
    BEGIN
        SELECT TOP 1 @SupplierAccountCode = coa.AccountCode
        FROM AP_Invoices ap
        INNER JOIN ChartOfAccounts coa ON ap.BeneficiaryID = coa.SupplierID 
            AND coa.IsSubsidiaryLedger = 1 AND coa.AccountType = 'Liability'
        WHERE (ap.InvoiceNumber LIKE '%' + REPLACE(@Description, 'INV-', '') + '%' 
               OR ap.Reference LIKE '%' + REPLACE(@Description, 'INV-', '') + '%')
            AND ap.Status IN ('Pending', 'Overdue')
            AND ABS(ap.TotalAmount - @Amount) < 5.00
        ORDER BY ap.InvoiceDate DESC;
        
        IF @SupplierAccountCode IS NOT NULL
            SET @ContraAccountCode = @SupplierAccountCode;
    END
    
    -- If no supplier match, use keyword mapping
    IF @ContraAccountCode IS NULL
    BEGIN
        SELECT TOP 1 @ContraAccountCode = AccountCode
        FROM BankStatementKeywordMapping
        WHERE TransactionType = 'Debit' AND IsActive = 1
            AND (@Description LIKE '%' + Keyword + '%' OR @Reference LIKE '%' + Keyword + '%')
        ORDER BY Priority ASC;
    END
    
    -- Default to Accounts Payable if no match
    IF @ContraAccountCode IS NULL SET @ContraAccountCode = '2100';
    
    -- Get ContraAccount ID from ChartOfAccounts
    SELECT @ContraAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = @ContraAccountCode AND IsActive = 1;
    
    IF @ContraAccountID IS NULL
    BEGIN
        RAISERROR('Contra account %s not found in ChartOfAccounts', 16, 1, @ContraAccountCode);
        RETURN;
    END
    
    SET @JournalEntryNumber = 'JE-' + CONVERT(VARCHAR(8), @TransactionDate, 112) + '-' + CAST(@TransactionID AS VARCHAR(10));
    
    BEGIN TRANSACTION;
    BEGIN TRY
        -- DEBIT Expense/Supplier (money OUT increases expense or reduces liability)
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalEntryNumber, @ContraAccountID, @TransactionDate, @Description, @Amount, 0, @Reference, @PostedBy, GETDATE(), 0);
        
        -- CREDIT Bank (money OUT decreases asset)
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalEntryNumber, @BankAccountID, @TransactionDate, 'Bank Payment: ' + @Description, 0, @Amount, @Reference, @PostedBy, GETDATE(), 0);
        
        -- Mark as posted
        UPDATE AP_StatementTransactions 
        SET IsReconciled = 1, ReconciledDate = GETDATE(), ReconciledBy = @PostedBy, MappedLedgerAccount = @ContraAccountCode
        WHERE TransactionID = @TransactionID;
        
        COMMIT TRANSACTION;
        PRINT 'Debit posted: DR ' + @ContraAccountCode + '(' + CAST(@ContraAccountID AS VARCHAR) + ') / CR Bank(' + CAST(@BankAccountID AS VARCHAR) + ') - ' + @Description;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMsg, 16, 1);
    END CATCH
END
GO

PRINT 'Fixed posting procedures created successfully';
PRINT 'Procedures now correctly use AccountID (INT) from ChartOfAccounts';
GO
