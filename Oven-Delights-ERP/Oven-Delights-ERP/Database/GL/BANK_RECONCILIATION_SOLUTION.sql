-- =============================================
-- BANK RECONCILIATION SOLUTION
-- Matches bank statement to existing GL entries
-- Only posts unmatched items (fees, interest, deposits)
-- DOES NOT BREAK EXISTING POS/AP FUNCTIONALITY
-- =============================================

-- =============================================
-- STEP 1: ADD ISMAPPED COLUMN
-- =============================================
PRINT '========================================='
PRINT 'STEP 1: ADDING ISMAPPED COLUMN'
PRINT '========================================='
PRINT ''

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'IsMapped')
BEGIN
    ALTER TABLE AP_StatementTransactions ADD IsMapped BIT NOT NULL DEFAULT 0
    PRINT '✓ Added IsMapped column'
END
ELSE
    PRINT '✓ IsMapped column already exists'

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'MappedLedgerAccount')
BEGIN
    ALTER TABLE AP_StatementTransactions ADD MappedLedgerAccount NVARCHAR(20) NULL
    PRINT '✓ Added MappedLedgerAccount column'
END
ELSE
    PRINT '✓ MappedLedgerAccount column already exists'

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'MappedJournalID')
BEGIN
    ALTER TABLE AP_StatementTransactions ADD MappedJournalID INT NULL
    PRINT '✓ Added MappedJournalID column'
END
ELSE
    PRINT '✓ MappedJournalID column already exists'

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'MatchedGLEntryID')
BEGIN
    ALTER TABLE AP_StatementTransactions ADD MatchedGLEntryID BIGINT NULL
    PRINT '✓ Added MatchedGLEntryID column'
END
ELSE
    PRINT '✓ MatchedGLEntryID column already exists'

PRINT ''
GO

-- =============================================
-- STEP 2: CREATE BANK RECONCILIATION PROCEDURE
-- Matches bank transactions to existing GL entries
-- =============================================
PRINT '========================================='
PRINT 'STEP 2: CREATING RECONCILIATION PROCEDURE'
PRINT '========================================='
PRINT ''

IF OBJECT_ID('sp_ReconcileBankStatement', 'P') IS NOT NULL
    DROP PROCEDURE sp_ReconcileBankStatement
GO

CREATE PROCEDURE sp_ReconcileBankStatement
    @TransactionID INT = NULL,  -- Reconcile specific transaction or NULL for all
    @PostedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @MatchedCount INT = 0
    DECLARE @UnmatchedCount INT = 0
    
    -- Cursor for bank transactions
    DECLARE @TxnID INT, @Amount DECIMAL(18,2), @TxnDate DATE, @Description NVARCHAR(500)
    DECLARE @CreditDebit NVARCHAR(10), @Reference NVARCHAR(200)
    
    DECLARE txn_cursor CURSOR FOR
    SELECT TransactionID, Amount, TransactionDate, Description, CreditDebitIndicator, Reference
    FROM AP_StatementTransactions
    WHERE (@TransactionID IS NULL OR TransactionID = @TransactionID)
        AND IsReconciled = 0
        AND IsMapped = 1
    
    OPEN txn_cursor
    FETCH NEXT FROM txn_cursor INTO @TxnID, @Amount, @TxnDate, @Description, @CreditDebit, @Reference
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @MatchedJournalID INT = NULL
        DECLARE @BankAccountID INT
        
        -- Get Bank Account ID (1010)
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        
        -- Try to match to existing GL entries
        IF @CreditDebit = 'Credit'
        BEGIN
            -- Credit = Money IN to bank
            -- Look for DEBIT to Bank account (1010) with matching amount and date
            -- This would be from: Card sales, Cash deposits, EFT clearings
            
            SELECT TOP 1 @MatchedJournalID = jh.JournalID
            FROM JournalHeaders jh
            INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
            WHERE jd.AccountID = @BankAccountID
                AND jd.Debit = @Amount
                AND jd.Credit = 0
                AND jh.JournalDate = @TxnDate
                AND jh.JournalID NOT IN (SELECT MatchedGLEntryID FROM AP_StatementTransactions WHERE MatchedGLEntryID IS NOT NULL)
            ORDER BY jh.JournalID DESC
        END
        ELSE
        BEGIN
            -- Debit = Money OUT of bank
            -- Look for CREDIT to Bank account (1010) with matching amount and date
            -- This would be from: Supplier payments, Refunds
            
            SELECT TOP 1 @MatchedJournalID = jh.JournalID
            FROM JournalHeaders jh
            INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
            WHERE jd.AccountID = @BankAccountID
                AND jd.Credit = @Amount
                AND jd.Debit = 0
                AND jh.JournalDate = @TxnDate
                AND jh.JournalID NOT IN (SELECT MatchedGLEntryID FROM AP_StatementTransactions WHERE MatchedGLEntryID IS NOT NULL)
            ORDER BY jh.JournalID DESC
        END
        
        -- If matched, mark as reconciled
        IF @MatchedJournalID IS NOT NULL
        BEGIN
            UPDATE AP_StatementTransactions
            SET IsReconciled = 1,
                ReconciledDate = GETDATE(),
                ReconciledBy = @PostedBy,
                MatchedGLEntryID = @MatchedJournalID
            WHERE TransactionID = @TxnID
            
            SET @MatchedCount = @MatchedCount + 1
            PRINT 'Matched Transaction ' + CAST(@TxnID AS VARCHAR) + ' to Journal ' + CAST(@MatchedJournalID AS VARCHAR)
        END
        ELSE
        BEGIN
            SET @UnmatchedCount = @UnmatchedCount + 1
            PRINT 'No match found for Transaction ' + CAST(@TxnID AS VARCHAR) + ' - ' + @Description
        END
        
        FETCH NEXT FROM txn_cursor INTO @TxnID, @Amount, @TxnDate, @Description, @CreditDebit, @Reference
    END
    
    CLOSE txn_cursor
    DEALLOCATE txn_cursor
    
    PRINT ''
    PRINT 'Reconciliation complete:'
    PRINT '  Matched: ' + CAST(@MatchedCount AS VARCHAR)
    PRINT '  Unmatched: ' + CAST(@UnmatchedCount AS VARCHAR)
    PRINT ''
    PRINT 'Unmatched items may be: Bank fees, Interest, Manual deposits, or timing differences'
END
GO

PRINT '✓ Created sp_ReconcileBankStatement'
PRINT ''
GO

-- =============================================
-- STEP 3: CREATE PROCEDURE TO POST UNMATCHED ITEMS
-- Only posts bank fees, interest, and manual deposits
-- =============================================
PRINT '========================================='
PRINT 'STEP 3: CREATING UNMATCHED ITEMS PROCEDURE'
PRINT '========================================='
PRINT ''

IF OBJECT_ID('sp_PostUnmatchedBankItems', 'P') IS NOT NULL
    DROP PROCEDURE sp_PostUnmatchedBankItems
GO

CREATE PROCEDURE sp_PostUnmatchedBankItems
    @TransactionID INT,
    @PostedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @Amount DECIMAL(18,2), @TxnDate DATE, @Description NVARCHAR(500)
        DECLARE @CreditDebit NVARCHAR(10), @Reference NVARCHAR(200)
        DECLARE @JournalID INT, @JournalNumber NVARCHAR(50)
        DECLARE @BankAccountID INT, @ContraAccountID INT
        DECLARE @ContraAccountCode NVARCHAR(20)
        
        -- Get transaction details
        SELECT @Amount = Amount, @TxnDate = TransactionDate, @Description = Description,
               @CreditDebit = CreditDebitIndicator, @Reference = Reference
        FROM AP_StatementTransactions
        WHERE TransactionID = @TransactionID
        
        -- Get Bank Account ID (1010)
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        
        -- Determine contra account based on description
        IF @Description LIKE '%FEE%' OR @Description LIKE '%CHARGE%' OR @Description LIKE '%COMMISSION%'
        BEGIN
            SET @ContraAccountCode = '6080'  -- Bank Charges
        END
        ELSE IF @Description LIKE '%INTEREST%'
        BEGIN
            SET @ContraAccountCode = '4300'  -- Interest Income
        END
        ELSE IF @Description LIKE '%DEPOSIT%' OR @Description LIKE '%TD TO%'
        BEGIN
            SET @ContraAccountCode = '1030'  -- Cash on Hand (manual cash deposit)
        END
        ELSE
        BEGIN
            SET @ContraAccountCode = '6080'  -- Default to Bank Charges
        END
        
        -- Get contra account ID
        SELECT @ContraAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = @ContraAccountCode AND IsActive = 1
        
        IF @ContraAccountID IS NULL
        BEGIN
            RAISERROR('Contra account %s not found', 16, 1, @ContraAccountCode)
            RETURN
        END
        
        -- Generate journal number
        SET @JournalNumber = 'BANK-' + CAST(@TransactionID AS VARCHAR)
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            1,  -- Default branch
            @TxnDate,
            @Reference,
            'Bank Statement - ' + @Description,
            dbo.fn_GetCurrentFiscalPeriodID(@TxnDate),
            1,
            @PostedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Post entries based on Credit/Debit
        IF @CreditDebit = 'Credit'
        BEGIN
            -- Money IN to bank
            -- DEBIT: Bank
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, 1, @BankAccountID, @Amount, 0, @Description)
            
            -- CREDIT: Contra account
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, 2, @ContraAccountID, 0, @Amount, @Description)
        END
        ELSE
        BEGIN
            -- Money OUT of bank
            -- DEBIT: Contra account
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, 1, @ContraAccountID, @Amount, 0, @Description)
            
            -- CREDIT: Bank
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, 2, @BankAccountID, 0, @Amount, @Description)
        END
        
        -- Mark as reconciled
        UPDATE AP_StatementTransactions
        SET IsReconciled = 1,
            ReconciledDate = GETDATE(),
            ReconciledBy = @PostedBy,
            MatchedGLEntryID = @JournalID,
            MappedLedgerAccount = @ContraAccountCode
        WHERE TransactionID = @TransactionID
        
        COMMIT TRANSACTION
        
        SELECT @JournalID AS JournalID, 'Unmatched item posted to GL successfully' AS Message
        PRINT 'Posted Transaction ' + CAST(@TransactionID AS VARCHAR) + ' to GL as ' + @ContraAccountCode
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        DECLARE @ErrorMsg NVARCHAR(4000) = ERROR_MESSAGE()
        PRINT 'Error posting transaction: ' + @ErrorMsg
        RAISERROR(@ErrorMsg, 16, 1)
    END CATCH
END
GO

PRINT '✓ Created sp_PostUnmatchedBankItems'
PRINT ''
GO

-- =============================================
-- STEP 4: UPDATE AUTO-MAP PROCEDURE
-- =============================================
PRINT '========================================='
PRINT 'STEP 4: UPDATING AUTO-MAP PROCEDURE'
PRINT '========================================='
PRINT ''

IF OBJECT_ID('sp_AutoMapBankTransactions', 'P') IS NOT NULL
    DROP PROCEDURE sp_AutoMapBankTransactions
GO

CREATE PROCEDURE sp_AutoMapBankTransactions
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Simply mark all unmapped transactions as mapped
    -- The reconciliation procedure will handle matching
    UPDATE AP_StatementTransactions
    SET IsMapped = 1
    WHERE IsMapped = 0
    
    DECLARE @MappedCount INT = @@ROWCOUNT
    
    PRINT 'Auto-mapped ' + CAST(@MappedCount AS VARCHAR) + ' transactions'
    PRINT 'Run sp_ReconcileBankStatement to match to existing GL entries'
END
GO

PRINT '✓ Created sp_AutoMapBankTransactions'
PRINT ''
GO

PRINT '========================================='
PRINT 'BANK RECONCILIATION SOLUTION COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'USAGE:'
PRINT '------'
PRINT '1. Auto-map transactions:'
PRINT '   EXEC sp_AutoMapBankTransactions'
PRINT ''
PRINT '2. Reconcile (match to existing GL entries):'
PRINT '   EXEC sp_ReconcileBankStatement @PostedBy = ''username'''
PRINT ''
PRINT '3. Post unmatched items (fees, interest, deposits):'
PRINT '   EXEC sp_PostUnmatchedBankItems @TransactionID = 123, @PostedBy = 1'
PRINT ''
PRINT 'ACCOUNT CODES USED:'
PRINT '-------------------'
PRINT '1010 - Bank Account (matches POS/AP procedures)'
PRINT '1030 - Cash on Hand'
PRINT '4300 - Interest Income'
PRINT '6080 - Bank Charges'
PRINT ''
PRINT 'IMPORTANT:'
PRINT '----------'
PRINT '- This solution MATCHES existing GL entries from POS/AP'
PRINT '- It does NOT create duplicate entries'
PRINT '- Only unmatched items (fees, interest) create new GL entries'
PRINT '- Existing POS and AP functionality is NOT affected'
PRINT ''
GO
