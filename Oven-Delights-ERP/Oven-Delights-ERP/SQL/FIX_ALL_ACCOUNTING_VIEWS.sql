-- Fix All Accounting Forms and Views
-- ====================================
-- This script ensures all required tables and views exist for accounting forms

PRINT '========================================';
PRINT 'FIXING ACCOUNTING TABLES AND VIEWS';
PRINT '========================================';
PRINT '';

-- 1. Ensure GeneralJournal table exists
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'GeneralJournal')
BEGIN
    PRINT '1. Creating GeneralJournal table...';
    CREATE TABLE GeneralJournal (
        JournalID INT IDENTITY(1,1) PRIMARY KEY,
        TransactionDate DATETIME NOT NULL DEFAULT GETDATE(),
        JournalType NVARCHAR(50),
        Reference NVARCHAR(100),
        LedgerID INT,
        AccountCode NVARCHAR(20),
        AccountName NVARCHAR(200),
        Debit DECIMAL(18,2) DEFAULT 0,
        Credit DECIMAL(18,2) DEFAULT 0,
        Description NVARCHAR(500),
        BranchID INT,
        CreatedBy NVARCHAR(100),
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
    );
    CREATE INDEX IX_GeneralJournal_Date ON GeneralJournal(TransactionDate);
    CREATE INDEX IX_GeneralJournal_Reference ON GeneralJournal(Reference);
    PRINT '✓ GeneralJournal created';
END
ELSE
BEGIN
    PRINT '✓ GeneralJournal exists';
END
GO

-- 2. Ensure Ledgers table exists
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Ledgers')
BEGIN
    PRINT '2. Creating Ledgers table...';
    CREATE TABLE Ledgers (
        LedgerID INT IDENTITY(1,1) PRIMARY KEY,
        LedgerName NVARCHAR(200) NOT NULL,
        LedgerType NVARCHAR(50),
        AccountCode NVARCHAR(20),
        ParentLedgerID INT NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy NVARCHAR(100),
        ModifiedDate DATETIME,
        ModifiedBy NVARCHAR(100)
    );
    
    -- Insert default ledgers
    INSERT INTO Ledgers (LedgerName, LedgerType, AccountCode, IsActive, CreatedBy)
    VALUES 
    ('Cash', 'Asset', '1100', 1, 'SYSTEM'),
    ('Accounts Receivable', 'Asset', '1200', 1, 'SYSTEM'),
    ('Inventory', 'Asset', '1300', 1, 'SYSTEM'),
    ('Accounts Payable', 'Liability', '2000', 1, 'SYSTEM'),
    ('VAT Output', 'Liability', '2100', 1, 'SYSTEM'),
    ('Sales Revenue', 'Revenue', '4000', 1, 'SYSTEM'),
    ('Cost of Sales', 'Expense', '5000', 1, 'SYSTEM');
    
    PRINT '✓ Ledgers created with default accounts';
END
ELSE
BEGIN
    PRINT '✓ Ledgers exists';
END
GO

-- 3. Ensure SupplierLedger table/view exists
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'SupplierLedger')
    AND NOT EXISTS (SELECT * FROM sys.views WHERE name = 'SupplierLedger')
BEGIN
    PRINT '3. Creating SupplierLedger view...';
    EXEC('
    CREATE VIEW SupplierLedger AS
    SELECT 
        ROW_NUMBER() OVER (ORDER BY s.SupplierID, COALESCE(po.OrderDate, si.InvoiceDate, sp.PaymentDate)) AS LedgerID,
        s.SupplierID,
        s.SupplierName,
        COALESCE(po.OrderDate, si.InvoiceDate, sp.PaymentDate) AS TransactionDate,
        CASE 
            WHEN po.PurchaseOrderID IS NOT NULL THEN ''Purchase Order''
            WHEN si.InvoiceID IS NOT NULL THEN ''Invoice''
            WHEN sp.PaymentID IS NOT NULL THEN ''Payment''
        END AS TransactionType,
        COALESCE(po.OrderNumber, si.InvoiceNumber, CAST(sp.PaymentID AS NVARCHAR)) AS Reference,
        COALESCE(po.TotalAmount, si.TotalAmount, 0) AS Debit,
        COALESCE(sp.AmountPaid, 0) AS Credit,
        COALESCE(po.TotalAmount, si.TotalAmount, 0) - COALESCE(sp.AmountPaid, 0) AS Balance
    FROM Suppliers s
    LEFT JOIN PurchaseOrders po ON s.SupplierID = po.SupplierID
    LEFT JOIN SupplierInvoices si ON s.SupplierID = si.SupplierID
    LEFT JOIN SupplierPayments sp ON s.SupplierID = sp.SupplierID
    WHERE s.IsActive = 1
    ');
    PRINT '✓ SupplierLedger view created';
END
ELSE
BEGIN
    PRINT '✓ SupplierLedger exists';
END
GO

-- 4. Ensure ChartOfAccounts exists
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ChartOfAccounts')
BEGIN
    PRINT '4. Creating ChartOfAccounts table...';
    CREATE TABLE ChartOfAccounts (
        AccountID INT IDENTITY(1,1) PRIMARY KEY,
        AccountCode NVARCHAR(20) NOT NULL UNIQUE,
        AccountName NVARCHAR(200) NOT NULL,
        AccountType NVARCHAR(50) NOT NULL,
        ParentAccountID INT NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy NVARCHAR(100),
        ModifiedDate DATETIME,
        ModifiedBy NVARCHAR(100)
    );
    
    -- Insert default chart of accounts
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, CreatedBy)
    VALUES 
    ('1000', 'Assets', 'Asset', 1, 'SYSTEM'),
    ('1100', 'Cash and Bank', 'Asset', 1, 'SYSTEM'),
    ('1200', 'Accounts Receivable', 'Asset', 1, 'SYSTEM'),
    ('1300', 'Inventory', 'Asset', 1, 'SYSTEM'),
    ('2000', 'Liabilities', 'Liability', 1, 'SYSTEM'),
    ('2100', 'Accounts Payable', 'Liability', 1, 'SYSTEM'),
    ('2200', 'VAT Payable', 'Liability', 1, 'SYSTEM'),
    ('3000', 'Equity', 'Equity', 1, 'SYSTEM'),
    ('4000', 'Revenue', 'Revenue', 1, 'SYSTEM'),
    ('4100', 'Sales Revenue', 'Revenue', 1, 'SYSTEM'),
    ('5000', 'Expenses', 'Expense', 1, 'SYSTEM'),
    ('5100', 'Cost of Sales', 'Expense', 1, 'SYSTEM'),
    ('5200', 'Operating Expenses', 'Expense', 1, 'SYSTEM');
    
    PRINT '✓ ChartOfAccounts created';
END
ELSE
BEGIN
    PRINT '✓ ChartOfAccounts exists';
    
    -- Add missing columns if table exists
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
                   WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'CreatedBy')
    BEGIN
        ALTER TABLE ChartOfAccounts ADD CreatedBy NVARCHAR(100) NULL;
        PRINT '  ✓ Added CreatedBy column';
    END
    
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
                   WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'CreatedDate')
    BEGIN
        ALTER TABLE ChartOfAccounts ADD CreatedDate DATETIME NULL DEFAULT GETDATE();
        PRINT '  ✓ Added CreatedDate column';
    END
    
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
                   WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'ModifiedBy')
    BEGIN
        ALTER TABLE ChartOfAccounts ADD ModifiedBy NVARCHAR(100) NULL;
        PRINT '  ✓ Added ModifiedBy column';
    END
    
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
                   WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'ModifiedDate')
    BEGIN
        ALTER TABLE ChartOfAccounts ADD ModifiedDate DATETIME NULL;
        PRINT '  ✓ Added ModifiedDate column';
    END
    
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
                   WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'IsActive')
    BEGIN
        ALTER TABLE ChartOfAccounts ADD IsActive BIT NOT NULL DEFAULT 1;
        PRINT '  ✓ Added IsActive column';
    END
END
GO

-- 5. Ensure TrialBalance view exists
IF NOT EXISTS (SELECT * FROM sys.views WHERE name = 'vw_TrialBalance')
BEGIN
    PRINT '5. Creating TrialBalance view...';
    EXEC('
    CREATE VIEW vw_TrialBalance AS
    SELECT 
        COALESCE(gj.AccountCode, l.AccountCode) AS AccountCode,
        COALESCE(gj.AccountName, l.LedgerName) AS AccountName,
        l.LedgerType AS AccountType,
        SUM(ISNULL(gj.Debit, 0)) AS TotalDebit,
        SUM(ISNULL(gj.Credit, 0)) AS TotalCredit,
        SUM(ISNULL(gj.Debit, 0)) - SUM(ISNULL(gj.Credit, 0)) AS Balance
    FROM Ledgers l
    LEFT JOIN GeneralJournal gj ON l.AccountCode = gj.AccountCode
    WHERE l.IsActive = 1
    GROUP BY COALESCE(gj.AccountCode, l.AccountCode), COALESCE(gj.AccountName, l.LedgerName), l.LedgerType
    ');
    PRINT '✓ TrialBalance view created';
END
ELSE
BEGIN
    PRINT '✓ TrialBalance view exists';
END
GO

-- 6. Check for missing columns and add them
PRINT '6. Checking for missing columns...';

-- Add AccountCode to Ledgers if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Ledgers' AND COLUMN_NAME = 'AccountCode')
BEGIN
    ALTER TABLE Ledgers ADD AccountCode NVARCHAR(20) NULL;
    PRINT '✓ Added AccountCode to Ledgers';
END
GO

-- Add AccountCode to GeneralJournal if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'GeneralJournal' AND COLUMN_NAME = 'AccountCode')
BEGIN
    ALTER TABLE GeneralJournal ADD AccountCode NVARCHAR(20) NULL;
    PRINT '✓ Added AccountCode to GeneralJournal';
END
GO

-- Add AccountName to GeneralJournal if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'GeneralJournal' AND COLUMN_NAME = 'AccountName')
BEGIN
    ALTER TABLE GeneralJournal ADD AccountName NVARCHAR(200) NULL;
    PRINT '✓ Added AccountName to GeneralJournal';
END
GO

PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION';
PRINT '========================================';

-- Show table counts
PRINT 'Table counts:';
SELECT 'GeneralJournal' AS TableName, COUNT(*) AS RecordCount FROM GeneralJournal
UNION ALL
SELECT 'Ledgers', COUNT(*) FROM Ledgers
UNION ALL
SELECT 'ChartOfAccounts', COUNT(*) FROM ChartOfAccounts;

PRINT '';
PRINT '✓ ALL ACCOUNTING TABLES FIXED!';
PRINT '';
PRINT 'You can now open:';
PRINT '- General Journal Viewer';
PRINT '- Ledgers';
PRINT '- Chart of Accounts';
PRINT '- Trial Balance';
PRINT '- Supplier Ledger';
PRINT '- Income Statement';
GO
