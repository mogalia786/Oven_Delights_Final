-- =============================================
-- COMPREHENSIVE ACCOUNTING SYSTEM FIX
-- Based on proper accounting principles
-- =============================================

/*
PROBLEM ANALYSIS:
1. Bank statement posting creates NEW GL entries instead of MATCHING existing ones
2. This causes duplicate postings and incorrect ledger balances
3. Operational transactions (POS, Cake Orders, PO, Payments) should post to GL immediately
4. Bank reconciliation should MATCH these entries, not create new ones

CORRECT FLOW:
--------------
OPERATIONAL TRANSACTIONS → GL ENTRY → Cash on Hand / AP / AR updated
END OF DAY → Cash Deposit → GL ENTRY: DR Bank / CR Cash on Hand
BANK RECONCILIATION → MATCH deposits to cash deposit entries
                   → MATCH payments to supplier payment entries
                   → POST ONLY unmatched items (bank charges, interest)

CURRENT ISSUES:
--------------
1. IsMapped column missing in AP_StatementTransactions
2. Bank posting procedures using account CODES instead of account IDs
3. Bank posting creating duplicate entries for operational transactions
4. No matching logic to link bank transactions to existing GL entries
5. Chart of Accounts missing required accounts or accounts not active

SOLUTION STEPS:
--------------
*/

-- =============================================
-- STEP 1: FIX ISMAPPED COLUMN ERROR
-- =============================================
PRINT '========================================='
PRINT 'STEP 1: CHECKING ISMAPPED COLUMN'
PRINT '========================================='
PRINT ''

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'IsMapped')
BEGIN
    PRINT '✗ IsMapped column MISSING'
    PRINT 'ACTION REQUIRED: Run ALTER_AP_STATEMENT_TRANSACTIONS_ADD_MAPPING.sql'
    PRINT ''
END
ELSE
BEGIN
    PRINT '✓ IsMapped column EXISTS'
    PRINT ''
END

-- =============================================
-- STEP 2: VERIFY CHART OF ACCOUNTS
-- =============================================
PRINT '========================================='
PRINT 'STEP 2: VERIFYING CHART OF ACCOUNTS'
PRINT '========================================='
PRINT ''

DECLARE @MissingAccounts TABLE (AccountCode NVARCHAR(20), AccountName NVARCHAR(200), AccountType NVARCHAR(50))

-- Check critical accounts
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1110' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('1110', 'Cash on Hand', 'Asset')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1120' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('1120', 'Bank Account - FNB', 'Asset')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1200' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('1200', 'Accounts Receivable', 'Asset')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2100' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('2100', 'Accounts Payable', 'Liability')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2120' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('2120', 'Customer Deposits', 'Liability')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4100' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('4100', 'Retail Sales Revenue', 'Revenue')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4110' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('4110', 'Cake Sales Revenue', 'Revenue')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5100' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('5100', 'Cost of Goods Sold', 'Expense')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6080' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('6080', 'Bank Charges', 'Expense')

IF EXISTS (SELECT 1 FROM @MissingAccounts)
BEGIN
    PRINT '✗ MISSING OR INACTIVE ACCOUNTS:'
    SELECT * FROM @MissingAccounts
    PRINT ''
    PRINT 'ACTION REQUIRED: Run FIX_CHART_OF_ACCOUNTS.sql'
    PRINT ''
END
ELSE
BEGIN
    PRINT '✓ All critical accounts exist and are active'
    PRINT ''
END

-- =============================================
-- STEP 3: AUDIT EXISTING GL POSTING PROCEDURES
-- =============================================
PRINT '========================================='
PRINT 'STEP 3: AUDITING GL POSTING PROCEDURES'
PRINT '========================================='
PRINT ''

PRINT 'Checking for POS GL procedures...'
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_POS_PostSaleToGL' AND type = 'P')
    PRINT '✓ sp_POS_PostSaleToGL exists'
ELSE
    PRINT '✗ sp_POS_PostSaleToGL MISSING'

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_POS_PostOrderDepositToGL' AND type = 'P')
    PRINT '✓ sp_POS_PostOrderDepositToGL exists'
ELSE
    PRINT '✗ sp_POS_PostOrderDepositToGL MISSING'

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_POS_PostOrderCollectionToGL' AND type = 'P')
    PRINT '✓ sp_POS_PostOrderCollectionToGL exists'
ELSE
    PRINT '✗ sp_POS_PostOrderCollectionToGL MISSING'

PRINT ''
PRINT 'Checking for AP GL procedures...'
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_AP_PostInvoiceToGL' AND type = 'P')
    PRINT '✓ sp_AP_PostInvoiceToGL exists'
ELSE
    PRINT '✗ sp_AP_PostInvoiceToGL MISSING'

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_AP_PostPaymentToGL' AND type = 'P')
    PRINT '✓ sp_AP_PostPaymentToGL exists'
ELSE
    PRINT '✗ sp_AP_PostPaymentToGL MISSING'

PRINT ''
PRINT 'Checking for Bank Statement procedures...'
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_PostCreditTransactionsToLedgers' AND type = 'P')
    PRINT '✓ sp_PostCreditTransactionsToLedgers exists (NEEDS REDESIGN)'
ELSE
    PRINT '✗ sp_PostCreditTransactionsToLedgers MISSING'

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_PostDebitTransactionsToLedgers' AND type = 'P')
    PRINT '✓ sp_PostDebitTransactionsToLedgers exists (NEEDS REDESIGN)'
ELSE
    PRINT '✗ sp_PostDebitTransactionsToLedgers MISSING'

PRINT ''

-- =============================================
-- STEP 4: CHECK GENERALLEDGER TABLE STRUCTURE
-- =============================================
PRINT '========================================='
PRINT 'STEP 4: CHECKING GENERALLEDGER STRUCTURE'
PRINT '========================================='
PRINT ''

DECLARE @AccountIDType NVARCHAR(50)
SELECT @AccountIDType = t.name 
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('GeneralLedger') AND c.name = 'AccountID'

IF @AccountIDType = 'int'
    PRINT '✓ GeneralLedger.AccountID is INT (correct)'
ELSE
    PRINT '✗ GeneralLedger.AccountID is ' + @AccountIDType + ' (WRONG - should be INT)'

PRINT ''

-- =============================================
-- RECOMMENDED ACTIONS
-- =============================================
PRINT '========================================='
PRINT 'RECOMMENDED ACTIONS'
PRINT '========================================='
PRINT ''
PRINT '1. Fix IsMapped column:'
PRINT '   Run: ALTER_AP_STATEMENT_TRANSACTIONS_ADD_MAPPING.sql'
PRINT ''
PRINT '2. Fix Chart of Accounts:'
PRINT '   Run: FIX_CHART_OF_ACCOUNTS.sql'
PRINT ''
PRINT '3. Review existing POS GL procedures:'
PRINT '   File: 10_POS_GL_COMPLETE_INTEGRATION.sql'
PRINT '   Verify: POS sales posting correctly to GL'
PRINT '   Verify: Cake order deposits going to Customer Deposits (2120)'
PRINT '   Verify: Cake order completion posting to Cake Sales Revenue (4110)'
PRINT ''
PRINT '4. REDESIGN bank reconciliation:'
PRINT '   Current: Bank posting creates NEW GL entries'
PRINT '   Correct: Bank reconciliation should MATCH existing GL entries'
PRINT '   Action: Create new sp_ReconcileBankStatement procedure'
PRINT ''
PRINT '5. Create cash deposit procedure:'
PRINT '   When: End of day cash deposited to bank'
PRINT '   Entry: DR Bank (1120) / CR Cash on Hand (1110)'
PRINT '   Action: Create sp_PostCashDeposit procedure'
PRINT ''
PRINT '6. Test each transaction type end-to-end:'
PRINT '   - POS sale → GL entry → Cash on Hand updated'
PRINT '   - Cake deposit → GL entry → Customer Deposits updated'
PRINT '   - Cake completion → GL entry → Revenue recognized'
PRINT '   - PO receipt → GL entry → Inventory & AP updated'
PRINT '   - Supplier payment → GL entry → AP reduced, Bank reduced'
PRINT '   - Cash deposit → GL entry → Bank increased, Cash reduced'
PRINT '   - Bank reconciliation → Match entries, mark reconciled'
PRINT ''
PRINT '========================================='
PRINT 'END OF ANALYSIS'
PRINT '========================================='
GO
