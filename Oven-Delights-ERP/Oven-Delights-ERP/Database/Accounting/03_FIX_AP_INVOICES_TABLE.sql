-- =============================================
-- FIX AP_INVOICES TABLE
-- AP_Invoices uses BeneficiaryID to link to suppliers
-- This script adds LedgerAccountCode for supplier ledger mapping
-- =============================================
-- Run this AFTER 02_CREATE_SUPPLIER_LEDGER_ACCOUNTS.sql
-- =============================================

PRINT '=========================================='
PRINT 'FIXING AP_INVOICES TABLE'
PRINT '=========================================='
PRINT ''

-- Check if AP_Invoices table exists
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AP_Invoices')
BEGIN
    PRINT 'WARNING: AP_Invoices table does not exist!'
    PRINT 'This table may not be used in your system.'
    PRINT 'Skipping AP_Invoices modifications.'
    PRINT ''
    PRINT 'Note: SupplierInvoices table already has SupplierID column.'
    RETURN;
END

PRINT 'AP_Invoices table found'
PRINT 'Note: AP_Invoices uses BeneficiaryID to link to suppliers'
PRINT ''

-- Add LedgerAccountCode column to store the supplier's ledger account
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'AP_Invoices' AND COLUMN_NAME = 'LedgerAccountCode')
BEGIN
    ALTER TABLE AP_Invoices ADD LedgerAccountCode NVARCHAR(20) NULL;
    PRINT '✓ Added LedgerAccountCode column to AP_Invoices';
END
ELSE
BEGIN
    PRINT '  LedgerAccountCode column already exists in AP_Invoices';
END
GO

-- Add foreign key to ChartOfAccounts table
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_APInvoices_LedgerAccount')
BEGIN
    ALTER TABLE AP_Invoices 
    ADD CONSTRAINT FK_APInvoices_LedgerAccount 
    FOREIGN KEY (LedgerAccountCode) REFERENCES ChartOfAccounts(AccountCode);
    PRINT '✓ Added foreign key constraint to ChartOfAccounts table';
END
ELSE
BEGIN
    PRINT '  Foreign key constraint to ChartOfAccounts already exists';
END

-- Create index on BeneficiaryID
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_APInvoices_BeneficiaryID')
BEGIN
    CREATE INDEX IX_APInvoices_BeneficiaryID ON AP_Invoices(BeneficiaryID)
    WHERE BeneficiaryID IS NOT NULL;
    PRINT '✓ Created index on BeneficiaryID';
END
ELSE
BEGIN
    PRINT '  Index on BeneficiaryID already exists';
END

PRINT ''
PRINT '=========================================='
PRINT 'UPDATING LEDGER ACCOUNT CODES'
PRINT '=========================================='
PRINT ''

-- Update LedgerAccountCode for invoices with BeneficiaryID
UPDATE ai
SET ai.LedgerAccountCode = coa.AccountCode
FROM AP_Invoices ai
INNER JOIN ChartOfAccounts coa ON ai.BeneficiaryID = coa.SupplierID
WHERE ai.BeneficiaryID IS NOT NULL
  AND ai.LedgerAccountCode IS NULL
  AND coa.IsSubsidiaryLedger = 1;

DECLARE @Updated INT = @@ROWCOUNT;
PRINT '✓ Updated LedgerAccountCode for ' + CAST(@Updated AS NVARCHAR(10)) + ' invoices';

PRINT ''
PRINT '=========================================='
PRINT 'VERIFICATION'
PRINT '=========================================='
PRINT ''

-- Show invoice statistics
SELECT 
    'Total Invoices' AS Metric,
    COUNT(*) AS Count
FROM AP_Invoices
UNION ALL
SELECT 
    'Invoices with BeneficiaryID' AS Metric,
    COUNT(*) AS Count
FROM AP_Invoices
WHERE BeneficiaryID IS NOT NULL
UNION ALL
SELECT 
    'Invoices with LedgerAccountCode' AS Metric,
    COUNT(*) AS Count
FROM AP_Invoices
WHERE LedgerAccountCode IS NOT NULL
UNION ALL
SELECT 
    'Invoices needing manual assignment' AS Metric,
    COUNT(*) AS Count
FROM AP_Invoices
WHERE BeneficiaryID IS NULL;

PRINT ''
PRINT 'Sample invoices with supplier ledger accounts:'
PRINT ''

SELECT TOP 10
    ai.InvoiceID,
    ai.InvoiceNumber,
    ai.BeneficiaryID,
    s.CompanyName,
    ai.LedgerAccountCode,
    coa.AccountName AS LedgerAccountName,
    ai.TotalAmount
FROM AP_Invoices ai
LEFT JOIN Suppliers s ON ai.BeneficiaryID = s.SupplierID
LEFT JOIN ChartOfAccounts coa ON ai.LedgerAccountCode = coa.AccountCode
ORDER BY ai.InvoiceID DESC;

PRINT ''
PRINT '=========================================='
PRINT 'AP_INVOICES TABLE FIXED!'
PRINT '=========================================='
PRINT ''
PRINT 'Next Steps:'
PRINT '1. Manually assign BeneficiaryID to invoices without suppliers'
PRINT '2. Run 04_CREATE_RECONCILIATION_VIEWS.sql'
PRINT '3. Run 05_CREATE_ACCOUNTING_PROCEDURES.sql'
PRINT ''
