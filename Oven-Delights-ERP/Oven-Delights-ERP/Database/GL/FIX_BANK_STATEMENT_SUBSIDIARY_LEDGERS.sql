-- =============================================
-- FIX BANK STATEMENT POSTING TO SUBSIDIARY LEDGERS
-- Ensures Cash on Hand account exists and is properly configured
-- =============================================

SET NOCOUNT ON
GO

PRINT ''
PRINT '========================================='
PRINT 'FIXING BANK STATEMENT SUBSIDIARY LEDGERS'
PRINT '========================================='
PRINT ''

-- =============================================
-- 1. Ensure Cash on Hand account exists (1030)
-- =============================================
PRINT 'Step 1: Verifying Cash on Hand account...'

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1030')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, CreatedBy, CreatedDate)
    VALUES ('1030', 'Cash on Hand', 'Asset', 1, 1, GETDATE())
    PRINT '✓ Created 1030 - Cash on Hand'
END
ELSE
BEGIN
    -- Ensure it's active
    UPDATE ChartOfAccounts
    SET IsActive = 1, AccountType = 'Asset'
    WHERE AccountCode = '1030'
    PRINT '✓ 1030 - Cash on Hand verified and active'
END

PRINT ''

-- =============================================
-- 2. Verify Accounts Payable control account (2100)
-- =============================================
PRINT 'Step 2: Verifying Accounts Payable control account...'

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2100')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, CreatedBy, CreatedDate)
    VALUES ('2100', 'Accounts Payable', 'Liability', 1, 1, GETDATE())
    PRINT '✓ Created 2100 - Accounts Payable (Control)'
END
ELSE
BEGIN
    UPDATE ChartOfAccounts
    SET IsActive = 1, AccountType = 'Liability', AccountName = 'Accounts Payable'
    WHERE AccountCode = '2100'
    PRINT '✓ 2100 - Accounts Payable verified'
END

PRINT ''

-- =============================================
-- 3. Verify Accounts Receivable control account (1200)
-- =============================================
PRINT 'Step 3: Verifying Accounts Receivable control account...'

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1200')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, CreatedBy, CreatedDate)
    VALUES ('1200', 'Accounts Receivable', 'Asset', 1, 1, GETDATE())
    PRINT '✓ Created 1200 - Accounts Receivable (Control)'
END
ELSE
BEGIN
    UPDATE ChartOfAccounts
    SET IsActive = 1, AccountType = 'Asset', AccountName = 'Accounts Receivable'
    WHERE AccountCode = '1200'
    PRINT '✓ 1200 - Accounts Receivable verified'
END

PRINT ''

-- =============================================
-- 4. Add SupplierID and CustomerID columns if missing
-- =============================================
PRINT 'Step 4: Verifying ChartOfAccounts subsidiary ledger columns...'

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ChartOfAccounts') AND name = 'SupplierID')
BEGIN
    ALTER TABLE ChartOfAccounts ADD SupplierID INT NULL
    PRINT '✓ Added SupplierID column to ChartOfAccounts'
END
ELSE
    PRINT '✓ SupplierID column already exists'

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ChartOfAccounts') AND name = 'CustomerID')
BEGIN
    ALTER TABLE ChartOfAccounts ADD CustomerID INT NULL
    PRINT '✓ Added CustomerID column to ChartOfAccounts'
END
ELSE
    PRINT '✓ CustomerID column already exists'

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ChartOfAccounts') AND name = 'IsSubsidiaryLedger')
BEGIN
    ALTER TABLE ChartOfAccounts ADD IsSubsidiaryLedger BIT DEFAULT 0
    PRINT '✓ Added IsSubsidiaryLedger column to ChartOfAccounts'
END
ELSE
    PRINT '✓ IsSubsidiaryLedger column already exists'

PRINT ''

-- =============================================
-- 5. Verify BeneficiaryID column in AP_Invoices
-- =============================================
PRINT 'Step 5: Verifying AP_Invoices BeneficiaryID column...'

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('AP_Invoices') AND name = 'BeneficiaryID')
BEGIN
    ALTER TABLE AP_Invoices ADD BeneficiaryID INT NULL
    PRINT '✓ Added BeneficiaryID column to AP_Invoices'
END
ELSE
    PRINT '✓ BeneficiaryID column already exists in AP_Invoices'

PRINT ''

-- =============================================
-- 6. Verify AR_Invoices table exists
-- =============================================
PRINT 'Step 6: Verifying AR_Invoices table...'

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AR_Invoices')
BEGIN
    CREATE TABLE AR_Invoices (
        InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
        InvoiceNumber VARCHAR(50) NOT NULL,
        InvoiceDate DATE NOT NULL,
        CustomerID INT NOT NULL,
        TotalAmount DECIMAL(18,2) NOT NULL,
        PaymentStatus VARCHAR(20) DEFAULT 'Pending',
        CreatedBy VARCHAR(100),
        CreatedDate DATETIME DEFAULT GETDATE()
    )
    PRINT '✓ Created AR_Invoices table'
END
ELSE
    PRINT '✓ AR_Invoices table already exists'

PRINT ''

-- =============================================
-- SUMMARY
-- =============================================
PRINT '========================================='
PRINT 'BANK STATEMENT SUBSIDIARY LEDGER FIX COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'Configuration verified:'
PRINT '- 1030 - Cash on Hand (Asset)'
PRINT '- 2100 - Accounts Payable (Liability Control)'
PRINT '- 1200 - Accounts Receivable (Asset Control)'
PRINT '- ChartOfAccounts subsidiary ledger columns'
PRINT '- AP_Invoices BeneficiaryID column'
PRINT '- AR_Invoices table'
PRINT ''
PRINT 'Bank statement posting will now:'
PRINT '1. Match supplier payments to AP invoices'
PRINT '2. Post to supplier subsidiary ledgers (2100-XXX)'
PRINT '3. Match customer receipts to AR invoices'
PRINT '4. Post to customer subsidiary ledgers (1200-XXX)'
PRINT '5. Post cash deposits to Cash on Hand (1030)'
PRINT ''
PRINT 'Next: Test bank statement import and posting'
PRINT ''
