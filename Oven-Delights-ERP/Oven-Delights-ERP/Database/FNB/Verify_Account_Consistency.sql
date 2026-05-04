-- =============================================
-- COMPLETE ACCOUNT CONSISTENCY CHECK
-- =============================================

PRINT '=============================================='
PRINT 'FNB ACCOUNT VERIFICATION'
PRINT '=============================================='
PRINT ''

PRINT 'FNB Provided Accounts:'
PRINT 'Debtor Accounts (Business - Send Payments):'
PRINT '  - 63001723469'
PRINT '  - 63001731248'
PRINT 'Creditor Accounts (Beneficiaries - Receive Collections):'
PRINT '  - 63001730117'
PRINT '  - 63001731222'
PRINT ''

PRINT '=============================================='
PRINT '1. CREDENTIALS TABLE - What account is configured?'
SELECT 
    CredentialID,
    Environment,
    DebtorAccountNumber AS ConfiguredAccount,
    DebtorBranchID,
    IsActive,
    ClientID
FROM FNB_APICredentials
WHERE IsActive = 1
GO

PRINT ''
PRINT '=============================================='
PRINT '2. PAYMENT BATCHES - What account are payments sent from?'
SELECT DISTINCT 
    DebtorAccountNumber AS PaymentFromAccount,
    COUNT(*) AS BatchCount,
    SUM(TotalControlSum) AS TotalAmount,
    MIN(RequestedExecutionDate) AS FirstPayment,
    MAX(RequestedExecutionDate) AS LastPayment
FROM FNB_PaymentBatches
GROUP BY DebtorAccountNumber
GO

PRINT ''
PRINT '=============================================='
PRINT '3. STATEMENT VIEWER - What account will be used?'
PRINT 'BankStatementViewerForm.vb queries:'
PRINT 'SELECT TOP 1 DebtorAccountNumber FROM FNB_APICredentials'
PRINT 'WHERE IsActive = 1 AND Environment = ''Sandbox'''
PRINT ''
SELECT TOP 1 
    DebtorAccountNumber AS StatementAccountWillBe,
    Environment
FROM FNB_APICredentials 
WHERE IsActive = 1 AND Environment = 'Sandbox'
GO

PRINT ''
PRINT '=============================================='
PRINT '4. VALIDATION CHECK'
PRINT ''

DECLARE @ConfiguredAccount NVARCHAR(20)
DECLARE @PaymentAccount NVARCHAR(20)
DECLARE @IsValid BIT = 1

SELECT TOP 1 @ConfiguredAccount = DebtorAccountNumber 
FROM FNB_APICredentials 
WHERE IsActive = 1 AND Environment = 'Sandbox'

SELECT TOP 1 @PaymentAccount = DebtorAccountNumber 
FROM FNB_PaymentBatches 
ORDER BY CreatedDate DESC

IF @ConfiguredAccount = @PaymentAccount
BEGIN
    PRINT '✓ PASS: Payment account matches configured account'
    PRINT '  Account: ' + @ConfiguredAccount
END
ELSE
BEGIN
    PRINT '✗ FAIL: Account mismatch detected!'
    PRINT '  Configured: ' + ISNULL(@ConfiguredAccount, 'NULL')
    PRINT '  Payments from: ' + ISNULL(@PaymentAccount, 'NULL')
    SET @IsValid = 0
END

PRINT ''

-- Check if using correct debtor account
IF @ConfiguredAccount IN ('63001723469', '63001731248')
BEGIN
    PRINT '✓ PASS: Using a valid DEBTOR account (business account)'
END
ELSE IF @ConfiguredAccount IN ('63001730117', '63001731222')
BEGIN
    PRINT '✗ FAIL: Using a CREDITOR account (beneficiary account)!'
    PRINT '  This is for RECEIVING collections, not SENDING payments'
    SET @IsValid = 0
END
ELSE
BEGIN
    PRINT '⚠ WARNING: Account not in FNB provided list'
    PRINT '  Verify this is correct with FNB'
END

PRINT ''
PRINT '=============================================='
IF @IsValid = 1
BEGIN
    PRINT 'RESULT: Configuration is CORRECT'
    PRINT ''
    PRINT 'Next steps:'
    PRINT '1. Open Bank Statement Viewer'
    PRINT '2. Verify account shows: ' + @ConfiguredAccount
    PRINT '3. Select any date in January 2026'
    PRINT '4. Fetch statement (will return full month)'
    PRINT '5. Look for debits matching payment amounts'
END
ELSE
BEGIN
    PRINT 'RESULT: Configuration has ERRORS - Fix required'
    PRINT ''
    PRINT 'Action required:'
    PRINT '1. Update FNB_APICredentials to use correct debtor account'
    PRINT '2. Re-submit batch payments'
    PRINT '3. Fetch statements from correct account'
END
PRINT '=============================================='
GO
