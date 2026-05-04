-- =============================================
-- SIMPLE Bank Statement Posting Procedures
-- Uses keyword mapping table for account assignment
-- Correct debit/credit logic
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
    DECLARE @ContraDescription NVARCHAR(500);
    DECLARE @JournalEntryNumber NVARCHAR(50);
    
    -- Get transaction details
    SELECT 
        @Amount = Amount,
        @Description = Description,
        @TransactionDate = TransactionDate,
        @Reference = Reference
    FROM AP_StatementTransactions
    WHERE TransactionID = @TransactionID;
    
    -- Find matching keyword (highest priority first)
    SELECT TOP 1 
        @ContraAccount = AccountCode,
        @ContraDescription = AccountName + ': ' + @Description
    FROM BankStatementKeywordMapping
    WHERE TransactionType = 'Credit'
        AND IsActive = 1
        AND (@Description LIKE '%' + Keyword + '%' OR @Reference LIKE '%' + Keyword + '%')
    ORDER BY Priority ASC;
    
    -- Default to Accounts Receivable if no match
    IF @ContraAccount IS NULL
    BEGIN
        SET @ContraAccount = '1200';
        SET @ContraDescription = 'Customer Receipt: ' + @Description;
    END
    
    -- Generate journal entry number
    SET @JournalEntryNumber = 'JE-' + CONVERT(VARCHAR(8), @TransactionDate, 112) + '-' + CAST(@TransactionID AS VARCHAR(10));
    
    BEGIN TRANSACTION;
    BEGIN TRY
        -- DEBIT Bank Account (money coming IN increases bank balance)
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalEntryNumber, '1120', @TransactionDate, 'Bank Deposit: ' + @Description, @Amount, 0, @Reference, @PostedBy, GETDATE(), 0);
        
        -- CREDIT Contra Account (source of money - cash, customer, income)
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalEntryNumber, @ContraAccount, @TransactionDate, @ContraDescription, 0, @Amount, @Reference, @PostedBy, GETDATE(), 0);
        
        -- Mark as posted
        UPDATE AP_StatementTransactions
        SET IsReconciled = 1,
            ReconciledDate = GETDATE(),
            ReconciledBy = @PostedBy,
            MappedLedgerAccount = @ContraAccount
        WHERE TransactionID = @TransactionID;
        
        COMMIT TRANSACTION;
        PRINT 'Credit posted: DR Bank 1120 / CR ' + @ContraAccount + ' - ' + @Description;
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
    DECLARE @ContraDescription NVARCHAR(500);
    DECLARE @JournalEntryNumber NVARCHAR(50);
    DECLARE @SupplierLedger NVARCHAR(50);
    
    -- Get transaction details
    SELECT 
        @Amount = Amount,
        @Description = Description,
        @TransactionDate = TransactionDate,
        @Reference = Reference
    FROM AP_StatementTransactions
    WHERE TransactionID = @TransactionID;
    
    -- Try to match supplier subsidiary ledger first
    IF @Description LIKE '%INV-%' OR @Description LIKE '%INV%' OR @Reference LIKE '%INV%'
    BEGIN
        SELECT TOP 1 @SupplierLedger = coa.AccountCode
        FROM AP_Invoices ap
        INNER JOIN ChartOfAccounts coa ON ap.BeneficiaryID = coa.SupplierID 
            AND coa.IsSubsidiaryLedger = 1
            AND coa.AccountType = 'Liability'
        WHERE (ap.InvoiceNumber LIKE '%' + REPLACE(REPLACE(@Description, 'INV-', ''), 'INV', '') + '%'
               OR ap.Reference LIKE '%' + REPLACE(REPLACE(@Description, 'INV-', ''), 'INV', '') + '%')
            AND ap.Status IN ('Pending', 'Overdue')
            AND ABS(ap.TotalAmount - @Amount) < 5.00
        ORDER BY ap.InvoiceDate DESC;
        
        IF @SupplierLedger IS NOT NULL
        BEGIN
            SET @ContraAccount = @SupplierLedger;
            SET @ContraDescription = 'Supplier Payment: ' + @Description;
        END
    END
    
    -- If no supplier match, use keyword mapping
    IF @ContraAccount IS NULL
    BEGIN
        SELECT TOP 1 
            @ContraAccount = AccountCode,
            @ContraDescription = AccountName + ': ' + @Description
        FROM BankStatementKeywordMapping
        WHERE TransactionType = 'Debit'
            AND IsActive = 1
            AND (@Description LIKE '%' + Keyword + '%' OR @Reference LIKE '%' + Keyword + '%')
        ORDER BY Priority ASC;
    END
    
    -- Default to Accounts Payable if no match
    IF @ContraAccount IS NULL
    BEGIN
        SET @ContraAccount = '2100';
        SET @ContraDescription = 'Supplier Payment: ' + @Description;
    END
    
    -- Generate journal entry number
    SET @JournalEntryNumber = 'JE-' + CONVERT(VARCHAR(8), @TransactionDate, 112) + '-' + CAST(@TransactionID AS VARCHAR(10));
    
    BEGIN TRANSACTION;
    BEGIN TRY
        -- DEBIT Contra Account (expense or reduce liability)
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalEntryNumber, @ContraAccount, @TransactionDate, @ContraDescription, @Amount, 0, @Reference, @PostedBy, GETDATE(), 0);
        
        -- CREDIT Bank Account (money going OUT decreases bank balance)
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalEntryNumber, '1120', @TransactionDate, 'Bank Payment: ' + @Description, 0, @Amount, @Reference, @PostedBy, GETDATE(), 0);
        
        -- Mark as posted
        UPDATE AP_StatementTransactions
        SET IsReconciled = 1,
            ReconciledDate = GETDATE(),
            ReconciledBy = @PostedBy,
            MappedLedgerAccount = @ContraAccount
        WHERE TransactionID = @TransactionID;
        
        COMMIT TRANSACTION;
        PRINT 'Debit posted: DR ' + @ContraAccount + ' / CR Bank 1120 - ' + @Description;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

PRINT 'Simple posting procedures created successfully';
PRINT '';
PRINT 'Credit transactions (deposits): DEBIT Bank 1120 / CREDIT source account';
PRINT 'Debit transactions (payments): DEBIT expense/supplier / CREDIT Bank 1120';
GO
