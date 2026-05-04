-- =============================================
-- CONSOLIDATE BANK ACCOUNTS 1120 → 1010
-- =============================================
-- You have TWO bank accounts (1010 and 1120)
-- This script consolidates all 1120 transactions into 1010
-- and deactivates 1120
-- =============================================

PRINT ''
PRINT '========================================='
PRINT 'CONSOLIDATING BANK ACCOUNTS'
PRINT '========================================='
PRINT ''

BEGIN TRANSACTION

BEGIN TRY
    -- Step 1: Check both accounts exist
    DECLARE @Account1010ID INT
    DECLARE @Account1120ID INT
    
    SELECT @Account1010ID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010'
    SELECT @Account1120ID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1120'
    
    IF @Account1010ID IS NULL
    BEGIN
        PRINT '✗ ERROR: Account 1010 does not exist'
        ROLLBACK TRANSACTION
        RETURN
    END
    
    IF @Account1120ID IS NULL
    BEGIN
        PRINT '✓ Account 1120 does not exist - nothing to consolidate'
        ROLLBACK TRANSACTION
        RETURN
    END
    
    PRINT '✓ Found Account 1010 (ID: ' + CAST(@Account1010ID AS VARCHAR) + ')'
    PRINT '✓ Found Account 1120 (ID: ' + CAST(@Account1120ID AS VARCHAR) + ')'
    PRINT ''
    
    -- Step 2: Move all JournalDetails from 1120 to 1010
    DECLARE @JournalDetailsCount INT
    SELECT @JournalDetailsCount = COUNT(*) FROM JournalDetails WHERE AccountID = @Account1120ID
    
    IF @JournalDetailsCount > 0
    BEGIN
        PRINT 'Moving ' + CAST(@JournalDetailsCount AS VARCHAR) + ' JournalDetails entries from 1120 to 1010...'
        UPDATE JournalDetails SET AccountID = @Account1010ID WHERE AccountID = @Account1120ID
        PRINT '✓ JournalDetails updated'
    END
    ELSE
        PRINT '  No JournalDetails entries to move'
    
    -- Step 3: Move all GeneralLedger entries from 1120 to 1010
    DECLARE @GeneralLedgerCount INT
    SELECT @GeneralLedgerCount = COUNT(*) FROM GeneralLedger WHERE AccountID = @Account1120ID
    
    IF @GeneralLedgerCount > 0
    BEGIN
        PRINT 'Moving ' + CAST(@GeneralLedgerCount AS VARCHAR) + ' GeneralLedger entries from 1120 to 1010...'
        UPDATE GeneralLedger SET AccountID = @Account1010ID WHERE AccountID = @Account1120ID
        PRINT '✓ GeneralLedger updated'
    END
    ELSE
        PRINT '  No GeneralLedger entries to move'
    
    -- Step 4: Calculate balances from actual transactions (no CurrentBalance column)
    DECLARE @Balance1120 DECIMAL(18,2)
    DECLARE @Balance1010 DECIMAL(18,2)
    
    -- Calculate 1120 balance from JournalDetails
    SELECT @Balance1120 = ISNULL(SUM(Debit - Credit), 0) 
    FROM JournalDetails 
    WHERE AccountID = @Account1120ID
    
    -- Calculate 1010 balance from JournalDetails
    SELECT @Balance1010 = ISNULL(SUM(Debit - Credit), 0) 
    FROM JournalDetails 
    WHERE AccountID = @Account1010ID
    
    PRINT '  Account 1120 balance (from JournalDetails): R' + CAST(@Balance1120 AS VARCHAR)
    PRINT '  Account 1010 balance (from JournalDetails): R' + CAST(@Balance1010 AS VARCHAR)
    PRINT '  Note: Balances already consolidated via JournalDetails update'
    
    -- Step 5: Deactivate account 1120
    PRINT 'Deactivating account 1120...'
    UPDATE ChartOfAccounts 
    SET IsActive = 0,
        AccountName = AccountName + ' (CONSOLIDATED INTO 1010)'
    WHERE AccountID = @Account1120ID
    PRINT '✓ Account 1120 deactivated'
    
    PRINT ''
    PRINT '========================================='
    PRINT 'CONSOLIDATION COMPLETE'
    PRINT '========================================='
    PRINT ''
    PRINT 'Summary:'
    PRINT '  JournalDetails moved: ' + CAST(@JournalDetailsCount AS VARCHAR)
    PRINT '  GeneralLedger moved: ' + CAST(@GeneralLedgerCount AS VARCHAR)
    PRINT '  Balance transferred: R' + CAST(@Balance1120 AS VARCHAR)
    PRINT '  Account 1120: DEACTIVATED'
    PRINT '  Account 1010: ACTIVE (all transactions consolidated)'
    PRINT ''
    
    COMMIT TRANSACTION
    
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT ''
    PRINT '✗ ERROR: ' + ERROR_MESSAGE()
    PRINT ''
END CATCH
