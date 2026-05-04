-- =============================================
-- ENHANCE CHART OF ACCOUNTS FOR SUBSIDIARY LEDGERS
-- Adds columns to support subsidiary ledger system
-- =============================================
-- Run this script first before any other accounting scripts
-- =============================================

PRINT '=========================================='
PRINT 'ENHANCING CHART OF ACCOUNTS TABLE'
PRINT '=========================================='
PRINT ''

-- Add IsControlAccount column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'IsControlAccount')
BEGIN
    ALTER TABLE ChartOfAccounts ADD IsControlAccount BIT NOT NULL DEFAULT 0;
    PRINT '✓ Added IsControlAccount column';
END
ELSE
    PRINT '  IsControlAccount column already exists';

-- Add IsSubsidiaryLedger column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'IsSubsidiaryLedger')
BEGIN
    ALTER TABLE ChartOfAccounts ADD IsSubsidiaryLedger BIT NOT NULL DEFAULT 0;
    PRINT '✓ Added IsSubsidiaryLedger column';
END
ELSE
    PRINT '  IsSubsidiaryLedger column already exists';

-- Add ControlAccountID column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'ControlAccountID')
BEGIN
    ALTER TABLE ChartOfAccounts ADD ControlAccountID INT NULL;
    PRINT '✓ Added ControlAccountID column';
END
ELSE
    PRINT '  ControlAccountID column already exists';

-- Add SupplierID column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'SupplierID')
BEGIN
    ALTER TABLE ChartOfAccounts ADD SupplierID INT NULL;
    PRINT '✓ Added SupplierID column';
END
ELSE
    PRINT '  SupplierID column already exists';

-- Add CustomerID column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'CustomerID')
BEGIN
    ALTER TABLE ChartOfAccounts ADD CustomerID INT NULL;
    PRINT '✓ Added CustomerID column';
END
ELSE
    PRINT '  CustomerID column already exists';

-- Add NormalBalance column (DR or CR)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'NormalBalance')
BEGIN
    ALTER TABLE ChartOfAccounts ADD NormalBalance NVARCHAR(10) NULL;
    PRINT '✓ Added NormalBalance column';
END
ELSE
    PRINT '  NormalBalance column already exists';

-- Add Description column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'Description')
BEGIN
    ALTER TABLE ChartOfAccounts ADD Description NVARCHAR(500) NULL;
    PRINT '✓ Added Description column';
END
ELSE
    PRINT '  Description column already exists';

PRINT ''
PRINT '=========================================='
PRINT 'UPDATING EXISTING ACCOUNTS'
PRINT '=========================================='
PRINT ''

-- Update NormalBalance for existing accounts based on AccountType
UPDATE ChartOfAccounts
SET NormalBalance = CASE 
    WHEN AccountType IN ('Asset', 'Expense') THEN 'DR'
    WHEN AccountType IN ('Liability', 'Equity', 'Revenue') THEN 'CR'
    ELSE NULL
END
WHERE NormalBalance IS NULL;

PRINT '✓ Updated NormalBalance for existing accounts';

-- Mark Accounts Payable as control account
UPDATE ChartOfAccounts
SET IsControlAccount = 1,
    Description = 'Control account for all supplier balances'
WHERE AccountCode = '2100' 
  OR AccountName LIKE '%Accounts Payable%'
  OR AccountName LIKE '%Creditors%';

DECLARE @APUpdated INT = @@ROWCOUNT;
PRINT '✓ Marked ' + CAST(@APUpdated AS NVARCHAR(10)) + ' Accounts Payable account(s) as control account';

-- Mark Accounts Receivable as control account
UPDATE ChartOfAccounts
SET IsControlAccount = 1,
    Description = 'Control account for all customer balances'
WHERE AccountCode = '1200' 
  OR AccountCode = '1130'
  OR AccountName LIKE '%Accounts Receivable%'
  OR AccountName LIKE '%Debtors%';

DECLARE @ARUpdated INT = @@ROWCOUNT;
PRINT '✓ Marked ' + CAST(@ARUpdated AS NVARCHAR(10)) + ' Accounts Receivable account(s) as control account';

PRINT ''
PRINT '=========================================='
PRINT 'CREATING INDEXES'
PRINT '=========================================='
PRINT ''

-- Create index on SupplierID
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ChartOfAccounts_SupplierID')
BEGIN
    CREATE INDEX IX_ChartOfAccounts_SupplierID ON ChartOfAccounts(SupplierID)
    WHERE SupplierID IS NOT NULL;
    PRINT '✓ Created index on SupplierID';
END
ELSE
    PRINT '  Index on SupplierID already exists';

-- Create index on CustomerID
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ChartOfAccounts_CustomerID')
BEGIN
    CREATE INDEX IX_ChartOfAccounts_CustomerID ON ChartOfAccounts(CustomerID)
    WHERE CustomerID IS NOT NULL;
    PRINT '✓ Created index on CustomerID';
END
ELSE
    PRINT '  Index on CustomerID already exists';

-- Create index on IsSubsidiaryLedger
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ChartOfAccounts_IsSubsidiaryLedger')
BEGIN
    CREATE INDEX IX_ChartOfAccounts_IsSubsidiaryLedger ON ChartOfAccounts(IsSubsidiaryLedger)
    WHERE IsSubsidiaryLedger = 1;
    PRINT '✓ Created index on IsSubsidiaryLedger';
END
ELSE
    PRINT '  Index on IsSubsidiaryLedger already exists';

PRINT ''
PRINT '=========================================='
PRINT 'VERIFICATION'
PRINT '=========================================='
PRINT ''

-- Show control accounts
SELECT 
    AccountCode,
    AccountName,
    AccountType,
    IsControlAccount,
    Description
FROM ChartOfAccounts
WHERE IsControlAccount = 1
ORDER BY AccountCode;

PRINT ''
PRINT '=========================================='
PRINT 'CHART OF ACCOUNTS ENHANCEMENT COMPLETE!'
PRINT '=========================================='
PRINT ''
PRINT 'Next Steps:'
PRINT '1. Run 02_CREATE_SUPPLIER_LEDGER_ACCOUNTS.sql'
PRINT '2. Run 03_FIX_AP_INVOICES_TABLE.sql'
PRINT '3. Run 04_CREATE_RECONCILIATION_VIEWS.sql'
PRINT '4. Run 05_CREATE_ACCOUNTING_PROCEDURES.sql'
PRINT ''
