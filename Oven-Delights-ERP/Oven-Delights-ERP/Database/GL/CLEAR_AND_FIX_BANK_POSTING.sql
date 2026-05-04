-- =============================================
-- COMPLETE BANK POSTING FIX
-- 1. Clear all existing postings
-- 2. Fix posting procedures to use mapping rules
-- 3. Ready for reposting
-- =============================================

PRINT '========================================='
PRINT 'STEP 1: CLEAR ALL BANK POSTINGS'
PRINT '========================================='
PRINT ''

-- Clear GeneralLedger entries from bank posting
DELETE FROM GeneralLedger 
WHERE JournalEntryNumber LIKE 'BANK-%'
PRINT '✓ Cleared GeneralLedger bank entries'

-- Clear JournalDetails for bank journals
DELETE FROM JournalDetails 
WHERE JournalID IN (SELECT JournalID FROM Journals WHERE JournalNumber LIKE 'BANK-%')
PRINT '✓ Cleared JournalDetails bank entries'

-- Clear Journals
DELETE FROM Journals 
WHERE JournalNumber LIKE 'BANK-%'
PRINT '✓ Cleared Journals bank entries'

-- Reset AP_StatementTransactions reconciliation flags
UPDATE AP_StatementTransactions
SET IsReconciled = 0,
    ReconciledDate = NULL,
    ReconciledBy = NULL,
    IsMapped = 0,
    MappedDate = NULL,
    AccountCode = NULL,
    SupplierID = NULL,
    MappingType = NULL
PRINT '✓ Reset AP_StatementTransactions flags'

PRINT ''
PRINT '========================================='
PRINT 'STEP 2: DROP OLD PROCEDURES'
PRINT '========================================='
PRINT ''

IF OBJECT_ID('sp_BankStatement_CompletePayment', 'P') IS NOT NULL
    DROP PROCEDURE sp_BankStatement_CompletePayment
PRINT '✓ Dropped sp_BankStatement_CompletePayment'

IF OBJECT_ID('sp_BankStatement_CompleteReceipt', 'P') IS NOT NULL
    DROP PROCEDURE sp_BankStatement_CompleteReceipt
PRINT '✓ Dropped sp_BankStatement_CompleteReceipt'

PRINT ''
PRINT '========================================='
PRINT 'STEP 3: CREATE NEW SMART POSTING PROCEDURE'
PRINT '========================================='
PRINT ''

GO

CREATE PROCEDURE sp_BankStatement_PostTransaction
    @TransactionID INT,
    @PostedBy INT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @Amount DECIMAL(18,2)
        DECLARE @TransactionDate DATE
        DECLARE @Description NVARCHAR(500)
        DECLARE @Reference NVARCHAR(200)
        DECLARE @CreditDebitIndicator NVARCHAR(10)
        DECLARE @BranchID INT = 1
        
        DECLARE @BankAccountID INT
        DECLARE @ContraAccountID INT
        DECLARE @ContraAccountCode NVARCHAR(20)
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @MappingType NVARCHAR(50)
        
        -- Get transaction details
        SELECT 
            @Amount = Amount,
            @TransactionDate = TransactionDate,
            @Description = Description,
            @Reference = Reference,
            @CreditDebitIndicator = CreditDebitIndicator
        FROM AP_StatementTransactions
        WHERE TransactionID = @TransactionID
        
        -- Get Bank account (1010)
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        
        IF @BankAccountID IS NULL
        BEGIN
            RAISERROR('Bank account (1010) not found', 16, 1)
            RETURN
        END
        
        -- =============================================
        -- USE MAPPING RULES TO DETERMINE CONTRA ACCOUNT
        -- =============================================
        
        -- Check mapping rules in priority order
        SELECT TOP 1 
            @ContraAccountCode = AccountCode,
            @MappingType = TransactionType
        FROM BankTransactionMappingRules
        WHERE IsActive = 1
            AND (
                (MatchType = 'Prefix' AND @Description LIKE MatchValue + '%') OR
                (MatchType = 'Contains' AND @Description LIKE '%' + MatchValue + '%') OR
                (MatchType = 'Suffix' AND @Description LIKE '%' + MatchValue) OR
                (MatchType = 'Exact' AND @Description = MatchValue)
            )
        ORDER BY Priority ASC
        
        -- If no mapping rule found, use defaults based on transaction type
        IF @ContraAccountCode IS NULL
        BEGIN
            IF @CreditDebitIndicator IN ('Credit', 'CRDT')
            BEGIN
                -- Money IN - default to Cash on Hand (deposits from till)
                SET @ContraAccountCode = '1030'
                SET @MappingType = 'CashDeposit'
            END
            ELSE
            BEGIN
                -- Money OUT - default to Accounts Payable (supplier payments)
                SET @ContraAccountCode = '2100'
                SET @MappingType = 'SupplierPayment'
            END
        END
        
        -- Get contra account ID
        SELECT @ContraAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = @ContraAccountCode AND IsActive = 1
        
        IF @ContraAccountID IS NULL
        BEGIN
            RAISERROR('Contra account not found: %s', 16, 1, @ContraAccountCode)
            RETURN
        END
        
        -- =============================================
        -- CREATE JOURNAL ENTRY
        -- =============================================
        
        SET @JournalNumber = 'BANK-' + FORMAT(@TransactionID, '000000')
        
        INSERT INTO Journals (JournalNumber, JournalDate, Description, BranchID, CreatedBy, CreatedAt)
        VALUES (@JournalNumber, @TransactionDate, @Description, @BranchID, @PostedBy, GETDATE())
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- =============================================
        -- POST BASED ON TRANSACTION TYPE
        -- =============================================
        
        IF @CreditDebitIndicator IN ('Credit', 'CRDT')
        BEGIN
            -- MONEY IN (Receipt/Deposit)
            -- DR Bank (increase asset)
            -- CR Contra Account (decrease asset or liability)
            
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, 1, @BankAccountID, @Amount, 0, @Description)
            
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, 2, @ContraAccountID, 0, @Amount, @Description)
            
            INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
            VALUES (@JournalNumber, @BankAccountID, @TransactionDate, @Description, @Amount, 0, @Reference, @PostedBy, GETDATE(), 0)
            
            INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
            VALUES (@JournalNumber, @ContraAccountID, @TransactionDate, @Description, 0, @Amount, @Reference, @PostedBy, GETDATE(), 0)
        END
        ELSE
        BEGIN
            -- MONEY OUT (Payment)
            -- DR Contra Account (decrease liability or increase expense)
            -- CR Bank (decrease asset)
            
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, 1, @ContraAccountID, @Amount, 0, @Description)
            
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, 2, @BankAccountID, 0, @Amount, @Description)
            
            INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
            VALUES (@JournalNumber, @ContraAccountID, @TransactionDate, @Description, @Amount, 0, @Reference, @PostedBy, GETDATE(), 0)
            
            INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
            VALUES (@JournalNumber, @BankAccountID, @TransactionDate, @Description, 0, @Amount, @Reference, @PostedBy, GETDATE(), 0)
        END
        
        -- Update transaction as reconciled and mapped
        UPDATE AP_StatementTransactions
        SET IsReconciled = 1,
            ReconciledDate = GETDATE(),
            ReconciledBy = @PostedBy,
            IsMapped = 1,
            MappedDate = GETDATE(),
            AccountCode = @ContraAccountCode,
            MappingType = @MappingType
        WHERE TransactionID = @TransactionID
        
        COMMIT TRANSACTION
        
        PRINT 'Posted Transaction ' + CAST(@TransactionID AS NVARCHAR) + ': ' + @Description + ' → Account ' + @ContraAccountCode
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

PRINT '✓ Created sp_BankStatement_PostTransaction'
PRINT ''

PRINT '========================================='
PRINT 'STEP 4: VERIFY MAPPING RULES'
PRINT '========================================='
PRINT ''

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'BankTransactionMappingRules')
BEGIN
    PRINT '✗ BankTransactionMappingRules table does NOT exist'
    PRINT 'ACTION REQUIRED: Run CREATE_BANK_TRANSACTION_MAPPING_FIXED.sql first'
END
ELSE
BEGIN
    PRINT '✓ BankTransactionMappingRules table exists'
    PRINT ''
    PRINT 'Active Mapping Rules:'
    SELECT 
        RuleID,
        RuleName,
        MatchType,
        MatchValue,
        TransactionType,
        AccountCode,
        Priority
    FROM BankTransactionMappingRules
    WHERE IsActive = 1
    ORDER BY Priority
END

PRINT ''
PRINT '========================================='
PRINT 'COMPLETE - READY TO REPOST'
PRINT '========================================='
PRINT ''
PRINT 'To post transactions, run:'
PRINT 'EXEC sp_BankStatement_PostTransaction @TransactionID = [ID], @PostedBy = 1'
PRINT ''
PRINT 'Or use the Auto-Process button in the ERP application'
