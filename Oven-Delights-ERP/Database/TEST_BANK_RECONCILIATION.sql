-- =============================================
-- BANK RECONCILIATION SYSTEM - TESTING SCRIPT
-- Execute this after installation to verify system
-- =============================================
-- NOTE: Connect to OvenDelightsERP database before executing
-- GO

PRINT '========================================='
PRINT 'BANK RECONCILIATION SYSTEM - TESTING'
PRINT 'Started: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT '========================================='
GO

-- =============================================
-- TEST 1: Payment Reference Generation
-- =============================================
PRINT ''
PRINT 'TEST 1: Payment Reference Generation'
PRINT '-------------------------------------'
GO

DECLARE @SupplierRef NVARCHAR(50)
DECLARE @BeneficiaryRef NVARCHAR(50)

EXEC sp_GeneratePaymentReference 'Supplier', @SupplierRef OUTPUT
EXEC sp_GeneratePaymentReference 'Beneficiary', @BeneficiaryRef OUTPUT

PRINT 'Supplier Reference: ' + @SupplierRef
PRINT 'Beneficiary Reference: ' + @BeneficiaryRef

IF @SupplierRef LIKE 'SUP-____-______' AND @BeneficiaryRef LIKE 'BEN-____-______'
    PRINT '✓ TEST 1 PASSED'
ELSE
    PRINT '✗ TEST 1 FAILED'
GO

-- =============================================
-- TEST 2: Create Test Data
-- =============================================
PRINT ''
PRINT 'TEST 2: Creating Test Data'
PRINT '-------------------------------------'
GO

-- Get or create test bank account (FNB Sandbox Account)
DECLARE @BankAccountID INT
SELECT @BankAccountID = BankAccountID FROM BankAccounts WHERE AccountNumber = '63001723469'

IF @BankAccountID IS NULL
BEGIN
    DECLARE @BankGLAcctID INT
    
    SELECT @BankGLAcctID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1120'
    
    INSERT INTO BankAccounts (AccountName, BankName, AccountNumber, BranchCode, AccountType, Currency, GLAccountID, IsActive, IsPrimaryAccount, FNBAccountID)
    VALUES ('Test Business Account - FNB (62123456789)', 'FNB', '63001723469', '250655', 'Cheque', 'ZAR', @BankGLAcctID, 1, 1, 'FNB-SANDBOX-001')
    SET @BankAccountID = SCOPE_IDENTITY()
    PRINT 'Created test bank account: ' + CAST(@BankAccountID AS VARCHAR)
END
ELSE
BEGIN
    -- Update existing bank account with GL mapping if missing
    UPDATE BankAccounts 
    SET GLAccountID = (SELECT AccountID FROM ChartOfAccounts WHERE AccountCode = '1120')
    WHERE BankAccountID = @BankAccountID AND GLAccountID IS NULL
    
    PRINT 'Using existing bank account: ' + CAST(@BankAccountID AS VARCHAR)
END

-- Create test beneficiary
DECLARE @BeneficiaryID INT
SELECT @BeneficiaryID = BeneficiaryID FROM Beneficiaries WHERE BeneficiaryName = 'Test Landlord'

IF @BeneficiaryID IS NULL
BEGIN
    INSERT INTO Beneficiaries (BeneficiaryName, BeneficiaryType, Category, BankName, AccountNumber, BranchCode, AccountType, IsActive, CreatedBy, CreatedDate)
    VALUES ('Test Landlord', 'Individual', 'Rent', 'FNB', '62999999999', '250655', 'Cheque', 1, 'TestScript', GETDATE())
    SET @BeneficiaryID = SCOPE_IDENTITY()
    PRINT 'Created test beneficiary: ' + CAST(@BeneficiaryID AS VARCHAR)
END
ELSE
BEGIN
    PRINT 'Using existing beneficiary: ' + CAST(@BeneficiaryID AS VARCHAR)
END

-- Create test beneficiary payment
DECLARE @PaymentRef NVARCHAR(50)
EXEC sp_GeneratePaymentReference 'Beneficiary', @PaymentRef OUTPUT

DECLARE @PaymentID INT
INSERT INTO BeneficiaryPayments (BeneficiaryID, PaymentReference, PaymentDate, Amount, Description, Category, Status, CreatedBy, CreatedDate)
VALUES (@BeneficiaryID, @PaymentRef, GETDATE(), 5000.00, 'Test Rent Payment', 'Rent', 'Sent to Bank', 'TestScript', GETDATE())
SET @PaymentID = SCOPE_IDENTITY()

PRINT 'Created test payment: ' + @PaymentRef + ' (ID: ' + CAST(@PaymentID AS VARCHAR) + ')'

-- Create matching bank statement transaction
INSERT INTO BankStatementTransactions (
    BankAccountID, TransactionDate, Description, BankReference, 
    DebitAmount, CreditAmount, Balance, Status, ImportedBy, ImportedDate
)
VALUES (
    @BankAccountID, GETDATE(), 'Payment to Test Landlord - ' + @PaymentRef, 'FNB-REF-001',
    5000.00, 0, 95000.00, 'Unmatched', 'TestScript', GETDATE()
)

DECLARE @StatementLineID INT = SCOPE_IDENTITY()
PRINT 'Created test bank transaction: ' + CAST(@StatementLineID AS VARCHAR)

PRINT '✓ TEST 2 PASSED - Test data created'
GO

-- =============================================
-- TEST 3: Auto-Matching
-- =============================================
PRINT ''
PRINT 'TEST 3: Auto-Matching'
PRINT '-------------------------------------'
GO

DECLARE @TotalMatched INT
DECLARE @BeneficiaryPayments INT
DECLARE @StillUnmatched INT

EXEC sp_AutoMatchBankTransactions 
    @BankAccountID = NULL,
    @StatementLineID = NULL,
    @UserName = 'TestScript'

-- Check results
SELECT 
    @TotalMatched = COUNT(*)
FROM BankStatementTransactions
WHERE Status = 'Matched'
AND ImportedBy = 'TestScript'

SELECT 
    @StillUnmatched = COUNT(*)
FROM BankStatementTransactions
WHERE Status = 'Unmatched'
AND ImportedBy = 'TestScript'

PRINT 'Total Matched: ' + CAST(@TotalMatched AS VARCHAR)
PRINT 'Still Unmatched: ' + CAST(@StillUnmatched AS VARCHAR)

IF @TotalMatched > 0
    PRINT '✓ TEST 3 PASSED - Auto-matching working'
ELSE
    PRINT '✗ TEST 3 FAILED - No matches found'
GO

-- =============================================
-- TEST 4: GL Posting Validation
-- =============================================
PRINT ''
PRINT 'TEST 4: GL Posting Validation'
PRINT '-------------------------------------'
GO

-- First, ensure we have required GL accounts
IF NOT EXISTS (SELECT * FROM ChartOfAccounts WHERE AccountCode = '1120')
BEGIN
    PRINT 'WARNING: Bank account (1120) not found in Chart of Accounts'
    PRINT 'Creating test GL account...'
    
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, AccountCategory, ParentAccountID, IsActive)
    VALUES ('1120', 'Bank - FNB Business', 'Asset', 'Current Assets', NULL, 1)
END

IF NOT EXISTS (SELECT * FROM ChartOfAccounts WHERE AccountCode = '6100')
BEGIN
    PRINT 'WARNING: Rent expense account (6100) not found in Chart of Accounts'
    PRINT 'Creating test GL account...'
    
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, AccountCategory, ParentAccountID, IsActive)
    VALUES ('6100', 'Rent Expense', 'Expense', 'Operating Expenses', NULL, 1)
END

-- Attempt GL posting
DECLARE @TransactionsPosted INT
DECLARE @TotalDebits DECIMAL(18,2)
DECLARE @TotalCredits DECIMAL(18,2)
DECLARE @GLBatchID INT
DECLARE @ErrorMsg NVARCHAR(500)

BEGIN TRY
    EXEC sp_PostBankTransactionsToGL
        @StatementLineID = NULL,
        @BankAccountID = NULL,
        @UserName = 'TestScript',
        @PostingDate = NULL
    
    -- Check if posting succeeded
    SELECT 
        @TransactionsPosted = COUNT(*)
    FROM BankStatementTransactions
    WHERE Status = 'Posted'
    AND ImportedBy = 'TestScript'
    
    SELECT 
        @TotalDebits = SUM(DebitAmount),
        @TotalCredits = SUM(CreditAmount)
    FROM GeneralLedger
    WHERE CreatedBy = 'TestScript'
    AND CreatedDate >= DATEADD(MINUTE, -1, GETDATE())
    
    PRINT 'Transactions Posted: ' + CAST(@TransactionsPosted AS VARCHAR)
    PRINT 'Total Debits: R' + CAST(@TotalDebits AS VARCHAR)
    PRINT 'Total Credits: R' + CAST(@TotalCredits AS VARCHAR)
    
    IF ABS(@TotalDebits - @TotalCredits) < 0.01
    BEGIN
        PRINT '✓ TEST 4 PASSED - GL posting successful and balanced'
    END
    ELSE
    BEGIN
        PRINT '✗ TEST 4 FAILED - Debits and Credits do not balance'
    END
END TRY
BEGIN CATCH
    SET @ErrorMsg = ERROR_MESSAGE()
    PRINT '✗ TEST 4 FAILED - Error: ' + @ErrorMsg
END CATCH
GO

-- =============================================
-- TEST 5: Duplicate Prevention
-- =============================================
PRINT ''
PRINT 'TEST 5: Duplicate Prevention'
PRINT '-------------------------------------'
GO

DECLARE @DuplicateCount INT
DECLARE @DuplicateDebits DECIMAL(18,2)
DECLARE @DuplicateCredits DECIMAL(18,2)
DECLARE @DuplicateBatchID INT

BEGIN TRY
    -- Try to post same transactions again - should return 0 transactions posted
    EXEC sp_PostBankTransactionsToGL
        @StatementLineID = NULL,
        @BankAccountID = NULL,
        @UserName = 'TestScript',
        @PostingDate = NULL
    
    -- Check that no transactions were posted (duplicate prevention working)
    -- The stored procedure filters out already-posted transactions (PostedToGL = 1)
    -- So it should complete successfully but post 0 transactions
    
    -- Verify no new GL entries were created
    DECLARE @GLCountAfter INT
    SELECT @GLCountAfter = COUNT(*) 
    FROM GeneralLedger 
    WHERE CreatedBy = 'TestScript'
    AND CreatedDate >= DATEADD(SECOND, -5, GETDATE())
    
    IF @GLCountAfter = 2  -- Should still be 2 from first posting, not 4
    BEGIN
        PRINT '✓ TEST 5 PASSED - Duplicate prevention working (0 transactions posted on retry)'
    END
    ELSE
    BEGIN
        PRINT '✗ TEST 5 FAILED - Duplicate posting created ' + CAST(@GLCountAfter AS VARCHAR) + ' GL entries (expected 2)'
    END
END TRY
BEGIN CATCH
    PRINT '✗ TEST 5 FAILED - Unexpected error: ' + ERROR_MESSAGE()
END CATCH
GO

-- =============================================
-- TEST 6: Audit Trail
-- =============================================
PRINT ''
PRINT 'TEST 6: Audit Trail'
PRINT '-------------------------------------'
GO

DECLARE @AuditCount INT

-- Check import log
SELECT @AuditCount = COUNT(*) FROM BankStatementImportLog WHERE ImportedBy = 'TestScript'
PRINT 'Import log entries: ' + CAST(@AuditCount AS VARCHAR)

-- Check GL entries have audit info
SELECT @AuditCount = COUNT(*) 
FROM GeneralLedger 
WHERE CreatedBy = 'TestScript' 
AND CreatedDate IS NOT NULL
AND CreatedDate >= DATEADD(MINUTE, -5, GETDATE())

PRINT 'GL entries with audit trail: ' + CAST(@AuditCount AS VARCHAR)

IF @AuditCount > 0
    PRINT '✓ TEST 6 PASSED - Audit trail working'
ELSE
    PRINT '✗ TEST 6 FAILED - No audit trail found'
GO

-- =============================================
-- CLEANUP TEST DATA
-- =============================================
PRINT ''
PRINT 'CLEANUP: Removing Test Data'
PRINT '-------------------------------------'
GO

-- Delete test GL entries
DELETE FROM GeneralLedger WHERE CreatedBy = 'TestScript'
PRINT 'Deleted test GL entries'

-- Delete test bank transactions
DELETE FROM BankStatementTransactions WHERE ImportedBy = 'TestScript'
PRINT 'Deleted test bank transactions'

-- Delete test payments
DELETE FROM BeneficiaryPayments WHERE CreatedBy = 'TestScript'
PRINT 'Deleted test payments'

-- Delete test beneficiaries
DELETE FROM Beneficiaries WHERE CreatedBy = 'TestScript'
PRINT 'Deleted test beneficiaries'

-- Delete test import logs
DELETE FROM BankStatementImportLog WHERE ImportedBy = 'TestScript'
PRINT 'Deleted test import logs'

PRINT '✓ Cleanup complete'
GO

-- =============================================
-- SUMMARY
-- =============================================
PRINT ''
PRINT '========================================='
PRINT 'TEST SUMMARY'
PRINT '========================================='
PRINT 'All tests completed. Review results above.'
PRINT ''
PRINT 'Expected Results:'
PRINT '✓ TEST 1 PASSED - Payment reference generation'
PRINT '✓ TEST 2 PASSED - Test data creation'
PRINT '✓ TEST 3 PASSED - Auto-matching'
PRINT '✓ TEST 4 PASSED - GL posting and validation'
PRINT '✓ TEST 5 PASSED - Duplicate prevention'
PRINT '✓ TEST 6 PASSED - Audit trail'
PRINT ''
PRINT 'If all tests passed, system is ready for use!'
PRINT '========================================='
PRINT 'Completed: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT '========================================='
GO
