-- =============================================
-- CONSOLIDATED ALL DATABASE FIXES IN ONE SCRIPT
-- Run this single script to apply everything
-- Date: 2025-10-06 10:30
-- =============================================

SET NOCOUNT ON;
PRINT '========================================='
PRINT 'CONSOLIDATED DATABASE FIXES - STARTING'
PRINT 'Time: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT '========================================='
PRINT ''

-- =============================================
-- PART 1: OVERNIGHT FIXES (Stockroom/Manufacturing/Retail)
-- =============================================
PRINT '=== PART 1: Overnight Fixes ==='

-- InterBranchTransfers
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'InterBranchTransfers' AND COLUMN_NAME = 'CreatedDate')
BEGIN
    ALTER TABLE InterBranchTransfers ADD CreatedDate DATETIME NOT NULL DEFAULT(GETDATE());
    ALTER TABLE InterBranchTransfers ADD CreatedBy INT NULL;
    ALTER TABLE InterBranchTransfers ADD Reference NVARCHAR(200) NULL;
    ALTER TABLE InterBranchTransfers ADD UnitCost DECIMAL(18,4) DEFAULT 0;
    ALTER TABLE InterBranchTransfers ADD TotalValue DECIMAL(18,4) DEFAULT 0;
    ALTER TABLE InterBranchTransfers ADD CompletedBy INT NULL;
    ALTER TABLE InterBranchTransfers ADD CompletedDate DATETIME NULL;
    PRINT '✓ InterBranchTransfers fixed'
END

-- GoodsReceivedNotes
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GoodsReceivedNotes' AND COLUMN_NAME = 'BranchID')
BEGIN
    ALTER TABLE GoodsReceivedNotes ADD BranchID INT NULL;
    ALTER TABLE GoodsReceivedNotes ADD DeliveryNoteNumber NVARCHAR(50) NULL;
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Branches')
        ALTER TABLE GoodsReceivedNotes ADD CONSTRAINT FK_GRV_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID);
    PRINT '✓ GoodsReceivedNotes fixed'
END

-- Suppliers
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'Address')
BEGIN
    ALTER TABLE Suppliers ADD Address NVARCHAR(200) NULL;
    ALTER TABLE Suppliers ADD City NVARCHAR(100) NULL;
    ALTER TABLE Suppliers ADD Province NVARCHAR(100) NULL;
    ALTER TABLE Suppliers ADD PostalCode NVARCHAR(20) NULL;
    ALTER TABLE Suppliers ADD Country NVARCHAR(100) NULL;
    ALTER TABLE Suppliers ADD BankName NVARCHAR(100) NULL;
    ALTER TABLE Suppliers ADD BranchCode NVARCHAR(20) NULL;
    ALTER TABLE Suppliers ADD AccountNumber NVARCHAR(50) NULL;
    ALTER TABLE Suppliers ADD VATNumber NVARCHAR(50) NULL;
    ALTER TABLE Suppliers ADD PaymentTerms NVARCHAR(50) NULL;
    ALTER TABLE Suppliers ADD CreditLimit DECIMAL(18,2) NULL;
    ALTER TABLE Suppliers ADD IsActive BIT DEFAULT 1;
    ALTER TABLE Suppliers ADD Notes NVARCHAR(500) NULL;
    PRINT '✓ Suppliers fixed'
END

-- Products
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME = 'ItemType')
BEGIN
    ALTER TABLE Products ADD ItemType NVARCHAR(20) DEFAULT 'External';
    ALTER TABLE Products ADD CONSTRAINT CK_Products_ItemType CHECK (ItemType IN ('External', 'Manufactured', 'RawMaterial'));
    PRINT '✓ Products ItemType added'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME = 'SKU')
    ALTER TABLE Products ADD SKU NVARCHAR(50) NULL;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME = 'IsActive')
    ALTER TABLE Products ADD IsActive BIT DEFAULT 1;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME = 'ProductCode')
    ALTER TABLE Products ADD ProductCode NVARCHAR(50) NULL;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME = 'LastPaidPrice')
    ALTER TABLE Products ADD LastPaidPrice DECIMAL(18,4) DEFAULT 0;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME = 'AverageCost')
    ALTER TABLE Products ADD AverageCost DECIMAL(18,4) DEFAULT 0;

PRINT '✓ Products fixed'

-- PurchaseOrders
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PurchaseOrders' AND COLUMN_NAME = 'BranchID')
BEGIN
    ALTER TABLE PurchaseOrders ADD BranchID INT NULL;
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Branches')
        ALTER TABLE PurchaseOrders ADD CONSTRAINT FK_PO_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID);
    PRINT '✓ PurchaseOrders BranchID added'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PurchaseOrders' AND COLUMN_NAME = 'OrderDate')
    ALTER TABLE PurchaseOrders ADD OrderDate DATETIME NOT NULL DEFAULT(GETDATE());

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PurchaseOrders' AND COLUMN_NAME = 'Status')
    ALTER TABLE PurchaseOrders ADD Status NVARCHAR(20) DEFAULT 'Pending';

PRINT '✓ PurchaseOrders fixed'

-- Retail_Stock
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Retail_Stock' AND COLUMN_NAME = 'UpdatedAt')
    ALTER TABLE Retail_Stock ADD UpdatedAt DATETIME2 DEFAULT SYSUTCDATETIME();

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Retail_Stock' AND COLUMN_NAME = 'AverageCost')
    ALTER TABLE Retail_Stock ADD AverageCost DECIMAL(18,4) DEFAULT 0;

PRINT '✓ Retail_Stock fixed'

-- CreditNotes
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CreditNotes')
BEGIN
    CREATE TABLE CreditNotes (
        CreditNoteID INT IDENTITY(1,1) PRIMARY KEY,
        CreditNoteNumber NVARCHAR(50) NOT NULL UNIQUE,
        CreditDate DATE NOT NULL,
        SupplierID INT,
        BranchID INT,
        GRVID INT,
        CreditType NVARCHAR(50),
        CreditReason NVARCHAR(200),
        TotalAmount DECIMAL(18,2) NOT NULL,
        Status NVARCHAR(20) DEFAULT 'Pending',
        CreatedBy INT,
        CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_CreditNotes_Supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
        CONSTRAINT FK_CreditNotes_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    );
    PRINT '✓ CreditNotes table created'
END

-- SupplierInvoices
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SupplierInvoices')
BEGIN
    CREATE TABLE SupplierInvoices (
        InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
        InvoiceNumber NVARCHAR(50) NOT NULL,
        SupplierID INT NOT NULL,
        BranchID INT,
        InvoiceDate DATE NOT NULL,
        DueDate DATE,
        TotalAmount DECIMAL(18,2) NOT NULL,
        AmountPaid DECIMAL(18,2) DEFAULT 0,
        AmountOutstanding DECIMAL(18,2) DEFAULT 0,
        Status NVARCHAR(20) DEFAULT 'Unpaid',
        CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_SupplierInvoices_Supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
        CONSTRAINT FK_SupplierInvoices_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    );
    PRINT '✓ SupplierInvoices table created'
END

PRINT ''
PRINT '=== PART 1 COMPLETE ==='
PRINT ''
GO

-- =============================================
-- PART 2: ACCOUNTING SYSTEM
-- =============================================
PRINT '=== PART 2: Accounting System ==='

-- ExpenseCategories
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ExpenseCategories')
BEGIN
    CREATE TABLE ExpenseCategories (
        CategoryID INT IDENTITY(1,1) PRIMARY KEY,
        CategoryCode NVARCHAR(20) NOT NULL UNIQUE,
        CategoryName NVARCHAR(100) NOT NULL,
        AccountNumber NVARCHAR(20),
        IsActive BIT DEFAULT 1,
        CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME()
    );
    
    INSERT INTO ExpenseCategories (CategoryCode, CategoryName, AccountNumber) VALUES
    ('RENT', 'Rent & Lease Payments', '5010'),
    ('UTILITIES', 'Utilities', '5020'),
    ('WAGES', 'Wages & Salaries', '5400'),
    ('ELECTRICITY', 'Electricity', '5100'),
    ('WATER', 'Water & Sewerage', '5110'),
    ('PHONE', 'Phone Services', '5140'),
    ('FUEL', 'Fuel & Oil', '5250'),
    ('MARKETING', 'Marketing & Advertising', '5300'),
    ('BANK_CHARGES', 'Bank Charges & Fees', '5600'),
    ('REPAIRS', 'Repairs & Maintenance', '5650');
    
    PRINT '✓ ExpenseCategories created with 10 categories'
END

-- IncomeCategories
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'IncomeCategories')
BEGIN
    CREATE TABLE IncomeCategories (
        CategoryID INT IDENTITY(1,1) PRIMARY KEY,
        CategoryCode NVARCHAR(20) NOT NULL UNIQUE,
        CategoryName NVARCHAR(100) NOT NULL,
        AccountNumber NVARCHAR(20),
        IsActive BIT DEFAULT 1,
        CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME()
    );
    
    INSERT INTO IncomeCategories (CategoryCode, CategoryName, AccountNumber) VALUES
    ('RETAIL_SALES', 'Retail Sales', '4010'),
    ('WHOLESALE_SALES', 'Wholesale Sales', '4020'),
    ('SERVICE_REVENUE', 'Service Revenue', '4040'),
    ('INTEREST_INCOME', 'Interest Income', '4110'),
    ('OTHER_INCOME', 'Other Income', '4100');
    
    PRINT '✓ IncomeCategories created with 5 categories'
END

-- CashBook
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CashBook')
BEGIN
    CREATE TABLE CashBook (
        CashBookID INT IDENTITY(1,1) PRIMARY KEY,
        TransactionDate DATE NOT NULL,
        TransactionType NVARCHAR(20) NOT NULL,
        Description NVARCHAR(200) NOT NULL,
        Amount DECIMAL(18,2) NOT NULL,
        CashAmount DECIMAL(18,2) DEFAULT 0,
        BankAmount DECIMAL(18,2) DEFAULT 0,
        PaymentMethod NVARCHAR(50),
        BranchID INT,
        IsReconciled BIT DEFAULT 0,
        CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_CashBook_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
        CONSTRAINT CK_CashBook_Type CHECK (TransactionType IN ('Receipt', 'Payment'))
    );
    PRINT '✓ CashBook table created'
END

-- Employees enhancements
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Employees')
BEGIN
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'HourlyRate')
    BEGIN
        ALTER TABLE Employees ADD HourlyRate DECIMAL(18,2) DEFAULT 0;
        PRINT '✓ Added HourlyRate to Employees'
    END
    
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'PaymentType')
    BEGIN
        ALTER TABLE Employees ADD PaymentType NVARCHAR(20);
        PRINT '✓ Added PaymentType to Employees'
    END
    PRINT '✓ Employees enhanced'
END
GO

-- Add constraint separately after column exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'PaymentType')
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_Employees_PaymentType')
    BEGIN
        ALTER TABLE Employees ADD CONSTRAINT CK_Employees_PaymentType CHECK (PaymentType IN ('Hourly', 'Salary', 'Commission'));
        PRINT '✓ Added PaymentType constraint'
    END
END
GO

-- Timesheets
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Timesheets')
BEGIN
    CREATE TABLE Timesheets (
        TimesheetID INT IDENTITY(1,1) PRIMARY KEY,
        EmployeeID INT NOT NULL,
        WorkDate DATE NOT NULL,
        ClockIn DATETIME2,
        ClockOut DATETIME2,
        HoursWorked DECIMAL(5,2) DEFAULT 0,
        OvertimeHours DECIMAL(5,2) DEFAULT 0,
        Status NVARCHAR(20) DEFAULT 'Pending',
        CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Timesheets_Employee FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
    );
    PRINT '✓ Timesheets table created'
END

-- BankAccounts
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'BankAccounts')
BEGIN
    CREATE TABLE BankAccounts (
        BankAccountID INT IDENTITY(1,1) PRIMARY KEY,
        AccountName NVARCHAR(100) NOT NULL,
        BankName NVARCHAR(100),
        AccountNumber NVARCHAR(50) NOT NULL,
        CurrentBalance DECIMAL(18,2) DEFAULT 0,
        BranchID INT,
        IsActive BIT DEFAULT 1,
        CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_BankAccounts_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    );
    PRINT '✓ BankAccounts table created'
END

PRINT ''
PRINT '=== PART 2 COMPLETE ==='
PRINT ''
GO

-- =============================================
-- VERIFICATION
-- =============================================
PRINT '=== VERIFICATION ==='
PRINT ''

SELECT 'Tables Created/Fixed:' AS Status, COUNT(*) AS Count
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME IN (
    'InterBranchTransfers', 'GoodsReceivedNotes', 'Suppliers', 'Products',
    'PurchaseOrders', 'Retail_Stock', 'CreditNotes', 'SupplierInvoices',
    'ExpenseCategories', 'IncomeCategories', 'CashBook', 'Employees',
    'Timesheets', 'BankAccounts'
);

PRINT ''
PRINT '========================================='
PRINT 'ALL FIXES APPLIED SUCCESSFULLY!'
PRINT '========================================='
PRINT ''
GO
