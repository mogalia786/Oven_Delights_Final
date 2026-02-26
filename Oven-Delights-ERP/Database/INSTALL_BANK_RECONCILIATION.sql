-- =============================================
-- BANK RECONCILIATION SYSTEM - COMPLETE INSTALLATION
-- Execute this script in SQL Server Management Studio
-- =============================================

USE OvenDelightsERP
GO

PRINT '========================================='
PRINT 'BANK RECONCILIATION SYSTEM INSTALLATION'
PRINT 'Started: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT '========================================='
GO

-- =============================================
-- STEP 1: Create GLBatches table
-- =============================================
PRINT ''
PRINT 'STEP 1: Creating GLBatches table...'
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GLBatches]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[GLBatches] (
        BatchID INT IDENTITY(1,1) PRIMARY KEY,
        BatchNumber NVARCHAR(50) UNIQUE NOT NULL,
        BatchDate DATE NOT NULL,
        Description NVARCHAR(500),
        TotalDebits DECIMAL(18,2) DEFAULT 0,
        TotalCredits DECIMAL(18,2) DEFAULT 0,
        Status NVARCHAR(50) DEFAULT 'Draft',
        CreatedBy NVARCHAR(100),
        CreatedDate DATETIME DEFAULT GETDATE(),
        PostedBy NVARCHAR(100),
        PostedDate DATETIME,
        ReversedBy NVARCHAR(100),
        ReversedDate DATETIME,
        Notes NVARCHAR(MAX)
    )
    PRINT '✓ GLBatches table created'
END
ELSE
BEGIN
    PRINT '✓ GLBatches table already exists'
END
GO

-- =============================================
-- STEP 2: Create Bank Reconciliation tables
-- =============================================
PRINT ''
PRINT 'STEP 2: Creating Bank Reconciliation tables...'
PRINT 'NOTE: Please execute CREATE_BANK_RECONCILIATION_SYSTEM.sql separately first'
PRINT 'Then execute sp_GeneratePaymentReference.sql'
PRINT 'Then execute sp_AutoMatchBankTransactions.sql'
PRINT 'Then execute sp_PostBankTransactionsToGL.sql'
PRINT 'Then run this installation script again to validate'
GO

-- Check if tables exist
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'Beneficiaries')
    PRINT '✓ Bank Reconciliation tables found'
ELSE
    PRINT '⚠ Bank Reconciliation tables not found - execute CREATE_BANK_RECONCILIATION_SYSTEM.sql first'
GO

-- =============================================
-- STEP 3: Check stored procedures
-- =============================================
PRINT ''
PRINT 'STEP 3: Checking stored procedures...'
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_GeneratePaymentReference' AND type = 'P')
    PRINT '✓ sp_GeneratePaymentReference found'
ELSE
    PRINT '⚠ sp_GeneratePaymentReference not found - execute sp_GeneratePaymentReference.sql'

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_AutoMatchBankTransactions' AND type = 'P')
    PRINT '✓ sp_AutoMatchBankTransactions found'
ELSE
    PRINT '⚠ sp_AutoMatchBankTransactions not found - execute sp_AutoMatchBankTransactions.sql'

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_PostBankTransactionsToGL' AND type = 'P')
    PRINT '✓ sp_PostBankTransactionsToGL found'
ELSE
    PRINT '⚠ sp_PostBankTransactionsToGL not found - execute sp_PostBankTransactionsToGL.sql'
GO

-- =============================================
-- STEP 4: Create sample data (optional)
-- =============================================
PRINT ''
PRINT 'STEP 4: Creating sample data...'
GO

-- Sample Bank Account
IF NOT EXISTS (SELECT * FROM BankAccounts WHERE AccountNumber = '62123456789')
BEGIN
    INSERT INTO BankAccounts (AccountName, BankName, AccountNumber, BranchCode, AccountType, Currency, IsActive, IsPrimaryAccount, FNBAccountID)
    VALUES ('Main Business Account', 'FNB', '62123456789', '250655', 'Cheque', 'ZAR', 1, 1, 'FNB-ACC-001')
    PRINT '✓ Sample bank account created'
END
ELSE
BEGIN
    PRINT '✓ Sample bank account already exists'
END
GO

-- Sample Beneficiary Categories
IF NOT EXISTS (SELECT * FROM Beneficiaries WHERE BeneficiaryName = 'Mr. Pillay')
BEGIN
    INSERT INTO Beneficiaries (BeneficiaryName, BeneficiaryType, Category, BankName, AccountNumber, BranchCode, AccountType, IsActive, CreatedBy, CreatedDate)
    VALUES 
    ('Mr. Pillay', 'Individual', 'Rent', 'FNB', '62111111111', '250655', 'Cheque', 1, 'System', GETDATE()),
    ('Mr. Kajee', 'Individual', 'Rent', 'Standard Bank', '12222222222', '051001', 'Cheque', 1, 'System', GETDATE()),
    ('Ayesha Centre', 'Company', 'Electricity', 'FNB', '62333333333', '250655', 'Cheque', 1, 'System', GETDATE()),
    ('City Council', 'Government', 'Water', 'FNB', '62444444444', '250655', 'Cheque', 1, 'System', GETDATE())
    PRINT '✓ Sample beneficiaries created'
END
ELSE
BEGIN
    PRINT '✓ Sample beneficiaries already exist'
END
GO

-- =============================================
-- STEP 5: Validation Tests
-- =============================================
PRINT ''
PRINT 'STEP 5: Running validation tests...'
GO

-- Test 1: Check all tables exist
DECLARE @MissingTables TABLE (TableName NVARCHAR(100))

INSERT INTO @MissingTables (TableName)
SELECT 'Beneficiaries' WHERE NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'Beneficiaries')
UNION ALL
SELECT 'BeneficiaryPayments' WHERE NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'BeneficiaryPayments')
UNION ALL
SELECT 'PaymentBatches' WHERE NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'PaymentBatches')
UNION ALL
SELECT 'PaymentBatchItems' WHERE NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'PaymentBatchItems')
UNION ALL
SELECT 'BankAccounts' WHERE NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'BankAccounts')
UNION ALL
SELECT 'BankStatementTransactions' WHERE NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'BankStatementTransactions')
UNION ALL
SELECT 'BankStatementImportLog' WHERE NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'BankStatementImportLog')
UNION ALL
SELECT 'SupplierInvoices' WHERE NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'SupplierInvoices')
UNION ALL
SELECT 'GLBatches' WHERE NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'GLBatches')

IF EXISTS (SELECT * FROM @MissingTables)
BEGIN
    PRINT '✗ ERROR: Missing tables:'
    SELECT TableName FROM @MissingTables
END
ELSE
BEGIN
    PRINT '✓ All tables created successfully'
END
GO

-- Test 2: Check all stored procedures exist
DECLARE @MissingProcs TABLE (ProcName NVARCHAR(100))

INSERT INTO @MissingProcs (ProcName)
SELECT 'sp_GeneratePaymentReference' WHERE NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_GeneratePaymentReference' AND type = 'P')
UNION ALL
SELECT 'sp_AutoMatchBankTransactions' WHERE NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_AutoMatchBankTransactions' AND type = 'P')
UNION ALL
SELECT 'sp_PostBankTransactionsToGL' WHERE NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_PostBankTransactionsToGL' AND type = 'P')

IF EXISTS (SELECT * FROM @MissingProcs)
BEGIN
    PRINT '✗ ERROR: Missing stored procedures:'
    SELECT ProcName FROM @MissingProcs
END
ELSE
BEGIN
    PRINT '✓ All stored procedures created successfully'
END
GO

-- Test 3: Test payment reference generation
DECLARE @TestRef NVARCHAR(50)
EXEC sp_GeneratePaymentReference 'Supplier', @TestRef OUTPUT
IF @TestRef LIKE 'SUP-____-______'
    PRINT '✓ Payment reference generation working: ' + @TestRef
ELSE
    PRINT '✗ ERROR: Payment reference generation failed'
GO

-- =============================================
-- STEP 6: Display Summary
-- =============================================
PRINT ''
PRINT '========================================='
PRINT 'INSTALLATION SUMMARY'
PRINT '========================================='
GO

SELECT 
    'Tables Created' AS Component,
    COUNT(*) AS Count
FROM sys.objects 
WHERE type = 'U' 
AND name IN ('Beneficiaries', 'BeneficiaryPayments', 'PaymentBatches', 'PaymentBatchItems', 
             'BankAccounts', 'BankStatementTransactions', 'BankStatementImportLog', 
             'SupplierInvoices', 'GLBatches')

UNION ALL

SELECT 
    'Stored Procedures Created' AS Component,
    COUNT(*) AS Count
FROM sys.objects 
WHERE type = 'P' 
AND name IN ('sp_GeneratePaymentReference', 'sp_AutoMatchBankTransactions', 'sp_PostBankTransactionsToGL')

UNION ALL

SELECT 
    'Bank Accounts' AS Component,
    COUNT(*) AS Count
FROM BankAccounts
WHERE IsActive = 1

UNION ALL

SELECT 
    'Beneficiaries' AS Component,
    COUNT(*) AS Count
FROM Beneficiaries
WHERE IsActive = 1
GO

PRINT ''
PRINT '========================================='
PRINT 'INSTALLATION COMPLETED SUCCESSFULLY'
PRINT 'Completed: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT '========================================='
PRINT ''
PRINT 'NEXT STEPS:'
PRINT '1. Configure FNB API credentials in App.config'
PRINT '2. Map bank accounts to GL accounts'
PRINT '3. Open ERP → Accounting → Bank Reconciliation'
PRINT '4. Test CSV import or FNB download'
PRINT '5. Run auto-match and post to GL'
PRINT ''
PRINT 'See BANK_RECONCILIATION_USER_GUIDE.md for details'
PRINT '========================================='
GO
