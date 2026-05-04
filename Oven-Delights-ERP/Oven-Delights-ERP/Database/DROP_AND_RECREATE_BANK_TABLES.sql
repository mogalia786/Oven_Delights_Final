-- =============================================
-- DROP AND RECREATE Bank Reconciliation Tables
-- Use this if tables were created incorrectly
-- =============================================
-- NOTE: Connect to OvenDelightsERP database before executing
-- WARNING: This will delete all data in these tables!
-- GO

PRINT '========================================='
PRINT 'DROPPING EXISTING BANK RECONCILIATION TABLES'
PRINT '========================================='
PRINT ''

-- Drop in reverse order of dependencies
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'BankStatementImportLog' AND type = 'U')
BEGIN
    DROP TABLE BankStatementImportLog
    PRINT '✓ Dropped BankStatementImportLog'
END

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'BankStatementTransactions' AND type = 'U')
BEGIN
    DROP TABLE BankStatementTransactions
    PRINT '✓ Dropped BankStatementTransactions'
END

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'PaymentBatchItems' AND type = 'U')
BEGIN
    DROP TABLE PaymentBatchItems
    PRINT '✓ Dropped PaymentBatchItems'
END

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'PaymentBatches' AND type = 'U')
BEGIN
    DROP TABLE PaymentBatches
    PRINT '✓ Dropped PaymentBatches'
END

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'BeneficiaryPayments' AND type = 'U')
BEGIN
    DROP TABLE BeneficiaryPayments
    PRINT '✓ Dropped BeneficiaryPayments'
END

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'BankAccounts' AND type = 'U')
BEGIN
    DROP TABLE BankAccounts
    PRINT '✓ Dropped BankAccounts'
END

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'Beneficiaries' AND type = 'U')
BEGIN
    DROP TABLE Beneficiaries
    PRINT '✓ Dropped Beneficiaries'
END

PRINT ''
PRINT '========================================='
PRINT 'TABLES DROPPED - NOW RUN CREATE_BANK_RECONCILIATION_SYSTEM.sql'
PRINT '========================================='
GO
