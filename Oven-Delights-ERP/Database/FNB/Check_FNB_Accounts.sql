-- =============================================
-- Check FNB Account Configuration
-- =============================================

PRINT '=============================================='
PRINT 'FNB API CREDENTIALS - ALL ACCOUNTS'
PRINT '=============================================='
PRINT ''

SELECT 
    CredentialID,
    Environment,
    DebtorAccountNumber AS BusinessAccount,
    DebtorBranchID,
    IsActive,
    IsSandbox,
    BaseURL
FROM FNB_APICredentials
ORDER BY Environment, CredentialID
GO

PRINT ''
PRINT '=============================================='
PRINT 'CRITICAL CHECK:'
PRINT 'FNB provides TWO accounts per environment:'
PRINT '1. Business Account - For SENDING payments (debtor)'
PRINT '2. Recipient Account - For RECEIVING collections (creditor)'
PRINT ''
PRINT 'You must:'
PRINT '- Send payments FROM Business Account'
PRINT '- Fetch statements FOR Business Account (same number)'
PRINT ''
PRINT 'Current payment account: Check DebtorAccountNumber above'
PRINT 'Current statement account: Check BankStatementViewerForm.vb line 67'
PRINT '=============================================='
GO

PRINT ''
PRINT 'Payments being sent from:'
SELECT DISTINCT DebtorAccountNumber 
FROM FNB_PaymentBatches
GO

PRINT ''
PRINT '=============================================='
PRINT 'ACTION REQUIRED:'
PRINT '1. Verify you have the correct Business Account number'
PRINT '2. Update BankStatementViewerForm.vb line 67 to match'
PRINT '3. Re-fetch statements using the Business Account number'
PRINT '=============================================='
GO
