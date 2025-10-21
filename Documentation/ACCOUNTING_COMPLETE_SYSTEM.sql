-- =============================================
-- COMPLETE ACCOUNTING SYSTEM
-- Cash Book, Payroll, Bank Reconciliation, All Ledgers
-- Based on SAGE Accounting Structure
-- Date: 2025-10-04 05:30
-- =============================================

SET NOCOUNT ON;
PRINT '========================================='
PRINT 'ACCOUNTING SYSTEM - COMPLETE SETUP'
PRINT 'Time: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT '========================================='
PRINT ''

-- =============================================
-- PART 1: EXPENSE CATEGORIES (SAGE Standard)
-- =============================================
PRINT '=== PART 1: Expense Categories ==='

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ExpenseCategories')
BEGIN
    CREATE TABLE ExpenseCategories (
        CategoryID INT IDENTITY(1,1) PRIMARY KEY,
        CategoryCode NVARCHAR(20) NOT NULL UNIQUE,
        CategoryName NVARCHAR(100) NOT NULL,
        ParentCategoryID INT NULL,
        AccountNumber NVARCHAR(20),
        IsActive BIT DEFAULT 1,
        CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_ExpenseCategories_Parent FOREIGN KEY (ParentCategoryID) REFERENCES ExpenseCategories(CategoryID)
    );
    
    CREATE INDEX IX_ExpenseCategories_Code ON ExpenseCategories(CategoryCode);
    CREATE INDEX IX_ExpenseCategories_Parent ON ExpenseCategories(ParentCategoryID);
    
    PRINT '✓ ExpenseCategories table created'
END
ELSE
BEGIN
    PRINT 'ExpenseCategories table exists'
END
GO

-- Insert SAGE Standard Expense Categories
IF NOT EXISTS (SELECT * FROM ExpenseCategories WHERE CategoryCode = 'OFFICE')
BEGIN
    INSERT INTO ExpenseCategories (CategoryCode, CategoryName, AccountNumber) VALUES
    -- Office Expenses (5000-5099)
    ('OFFICE', 'Office Expenses', '5000'),
    ('RENT', 'Rent & Lease Payments', '5010'),
    ('UTILITIES', 'Utilities', '5020'),
    ('OFFICE_SUPPLIES', 'Office Supplies', '5030'),
    ('EQUIPMENT', 'Equipment & Maintenance', '5040'),
    ('INSURANCE', 'Insurance', '5050'),
    ('LEGAL', 'Legal & Professional Fees', '5060'),
    ('TAXES', 'Business Taxes & Licenses', '5070'),
    
    -- Utilities (5100-5199)
    ('ELECTRICITY', 'Electricity', '5100'),
    ('WATER', 'Water & Sewerage', '5110'),
    ('GAS', 'Gas', '5120'),
    ('INTERNET', 'Internet & Telecommunications', '5130'),
    ('PHONE', 'Phone Services', '5140'),
    
    -- Travel & Transport (5200-5299)
    ('TRAVEL', 'Travel Expenses', '5200'),
    ('AIRFARE', 'Airfare', '5210'),
    ('ACCOMMODATION', 'Accommodation', '5220'),
    ('MEALS_TRAVEL', 'Meals & Entertainment (Travel)', '5230'),
    ('VEHICLE', 'Vehicle Expenses', '5240'),
    ('FUEL', 'Fuel & Oil', '5250'),
    ('VEHICLE_MAINTENANCE', 'Vehicle Maintenance', '5260'),
    
    -- Marketing & Advertising (5300-5399)
    ('MARKETING', 'Marketing & Advertising', '5300'),
    ('ADVERTISING', 'Advertising Campaigns', '5310'),
    ('PROMOTIONS', 'Promotions & Sponsorships', '5320'),
    ('WEBSITE', 'Website & Digital Marketing', '5330'),
    ('PRINT_MARKETING', 'Print Marketing Materials', '5340'),
    
    -- Employee Expenses (5400-5499)
    ('WAGES', 'Wages & Salaries', '5400'),
    ('PAYROLL_TAXES', 'Payroll Taxes', '5410'),
    ('BENEFITS', 'Employee Benefits', '5420'),
    ('TRAINING', 'Training & Development', '5430'),
    ('UNIFORMS', 'Uniforms & Safety Equipment', '5440'),
    
    -- Cost of Goods Sold (5500-5599)
    ('COGS', 'Cost of Goods Sold', '5500'),
    ('RAW_MATERIALS', 'Raw Materials', '5510'),
    ('DIRECT_LABOR', 'Direct Labor', '5520'),
    ('MANUFACTURING_OVERHEAD', 'Manufacturing Overhead', '5530'),
    ('FREIGHT_IN', 'Freight & Shipping (Inbound)', '5540'),
    
    -- Operating Expenses (5600-5699)
    ('BANK_CHARGES', 'Bank Charges & Fees', '5600'),
    ('CREDIT_CARD_FEES', 'Credit Card Processing Fees', '5610'),
    ('INTEREST_EXPENSE', 'Interest Expense', '5620'),
    ('DEPRECIATION', 'Depreciation', '5630'),
    ('BAD_DEBT', 'Bad Debt Expense', '5640'),
    ('REPAIRS', 'Repairs & Maintenance', '5650'),
    ('CLEANING', 'Cleaning & Janitorial', '5660'),
    ('SECURITY', 'Security Services', '5670'),
    
    -- Other Expenses (5700-5799)
    ('DONATIONS', 'Charitable Donations', '5700'),
    ('SUBSCRIPTIONS', 'Subscriptions & Memberships', '5710'),
    ('LICENSES', 'Licenses & Permits', '5720'),
    ('CONSULTING', 'Consulting Services', '5730'),
    ('IT_SERVICES', 'IT Services & Software', '5740'),
    ('MISC_EXPENSE', 'Miscellaneous Expenses', '5790');
    
    PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' expense categories created'
END
GO

-- =============================================
-- PART 2: INCOME CATEGORIES (SAGE Standard)
-- =============================================
PRINT ''
PRINT '=== PART 2: Income Categories ==='

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'IncomeCategories')
BEGIN
    CREATE TABLE IncomeCategories (
        CategoryID INT IDENTITY(1,1) PRIMARY KEY,
        CategoryCode NVARCHAR(20) NOT NULL UNIQUE,
        CategoryName NVARCHAR(100) NOT NULL,
        ParentCategoryID INT NULL,
        AccountNumber NVARCHAR(20),
        IsActive BIT DEFAULT 1,
        CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_IncomeCategories_Parent FOREIGN KEY (ParentCategoryID) REFERENCES IncomeCategories(CategoryID)
    );
    
    CREATE INDEX IX_IncomeCategories_Code ON IncomeCategories(CategoryCode);
    CREATE INDEX IX_IncomeCategories_Parent ON IncomeCategories(ParentCategoryID);
    
    PRINT '✓ IncomeCategories table created'
END
ELSE
BEGIN
    PRINT 'IncomeCategories table exists'
END
GO

-- Insert SAGE Standard Income Categories
IF NOT EXISTS (SELECT * FROM IncomeCategories WHERE CategoryCode = 'SALES')
BEGIN
    INSERT INTO IncomeCategories (CategoryCode, CategoryName, AccountNumber) VALUES
    -- Sales Revenue (4000-4099)
    ('SALES', 'Sales Revenue', '4000'),
    ('RETAIL_SALES', 'Retail Sales', '4010'),
    ('WHOLESALE_SALES', 'Wholesale Sales', '4020'),
    ('ONLINE_SALES', 'Online Sales', '4030'),
    ('SERVICE_REVENUE', 'Service Revenue', '4040'),
    ('CONSULTING_REVENUE', 'Consulting Revenue', '4050'),
    
    -- Other Income (4100-4199)
    ('OTHER_INCOME', 'Other Income', '4100'),
    ('INTEREST_INCOME', 'Interest Income', '4110'),
    ('DIVIDEND_INCOME', 'Dividend Income', '4120'),
    ('RENTAL_INCOME', 'Rental Income', '4130'),
    ('COMMISSION_INCOME', 'Commission Income', '4140'),
    ('ROYALTY_INCOME', 'Royalty Income', '4150'),
    
    -- Gains (4200-4299)
    ('GAINS', 'Gains', '4200'),
    ('FOREX_GAIN', 'Foreign Exchange Gain', '4210'),
    ('ASSET_DISPOSAL_GAIN', 'Gain on Asset Disposal', '4220'),
    ('INVESTMENT_GAIN', 'Investment Gains', '4230'),
    
    -- Discounts & Refunds (4300-4399)
    ('DISCOUNT_RECEIVED', 'Discounts Received', '4300'),
    ('REBATES', 'Rebates & Incentives', '4310');
    
    PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' income categories created'
END
GO

-- =============================================
-- PART 3: CASH BOOK JOURNAL
-- =============================================
PRINT ''
PRINT '=== PART 3: Cash Book Journal ==='

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CashBook')
BEGIN
    CREATE TABLE CashBook (
        CashBookID INT IDENTITY(1,1) PRIMARY KEY,
        TransactionDate DATE NOT NULL,
        TransactionType NVARCHAR(20) NOT NULL, -- Receipt, Payment
        ReferenceNumber NVARCHAR(50),
        Description NVARCHAR(200) NOT NULL,
        AccountID INT, -- Link to GL Account
        CategoryID INT, -- Link to Income/Expense Category
        Amount DECIMAL(18,2) NOT NULL,
        CashAmount DECIMAL(18,2) DEFAULT 0,
        BankAmount DECIMAL(18,2) DEFAULT 0,
        DiscountAmount DECIMAL(18,2) DEFAULT 0,
        PaymentMethod NVARCHAR(50), -- Cash, Cheque, EFT, Card
        BankAccountID INT,
        BranchID INT,
        IsReconciled BIT DEFAULT 0,
        ReconciledDate DATETIME2,
        CreatedBy INT,
        CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_CashBook_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
        CONSTRAINT CK_CashBook_Type CHECK (TransactionType IN ('Receipt', 'Payment'))
    );
    
    CREATE INDEX IX_CashBook_Date ON CashBook(TransactionDate DESC);
    CREATE INDEX IX_CashBook_Type ON CashBook(TransactionType);
    CREATE INDEX IX_CashBook_Branch ON CashBook(BranchID);
    CREATE INDEX IX_CashBook_Reconciled ON CashBook(IsReconciled);
    
    PRINT '✓ CashBook table created'
END
ELSE
BEGIN
    PRINT 'CashBook table exists'
    
    -- Add missing columns if table exists
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CashBook' AND COLUMN_NAME = 'BranchID')
    BEGIN
        ALTER TABLE CashBook ADD BranchID INT;
        ALTER TABLE CashBook ADD CONSTRAINT FK_CashBook_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID);
        PRINT '✓ Added BranchID to CashBook'
    END
END
GO

-- =============================================
-- PART 4: PAYROLL SYSTEM
-- =============================================
PRINT ''
PRINT '=== PART 4: Payroll System ==='

-- Employees Table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Employees')
BEGIN
    CREATE TABLE Employees (
        EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
        EmployeeNumber NVARCHAR(20) NOT NULL UNIQUE,
        FirstName NVARCHAR(50) NOT NULL,
        LastName NVARCHAR(50) NOT NULL,
        Email NVARCHAR(100),
        Phone NVARCHAR(20),
        Address NVARCHAR(200),
        City NVARCHAR(100),
        Province NVARCHAR(100),
        PostalCode NVARCHAR(20),
        IDNumber NVARCHAR(20),
        TaxNumber NVARCHAR(20),
        BankName NVARCHAR(100),
        BranchCode NVARCHAR(20),
        AccountNumber NVARCHAR(50),
        HourlyRate DECIMAL(18,2) DEFAULT 0,
        SalaryAmount DECIMAL(18,2) DEFAULT 0,
        PaymentType NVARCHAR(20), -- Hourly, Salary, Commission
        BranchID INT,
        DepartmentID INT,
        PositionTitle NVARCHAR(100),
        HireDate DATE,
        TerminationDate DATE,
        IsActive BIT DEFAULT 1,
        CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Employees_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
        CONSTRAINT CK_Employees_PaymentType CHECK (PaymentType IN ('Hourly', 'Salary', 'Commission'))
    );
    
    CREATE INDEX IX_Employees_Number ON Employees(EmployeeNumber);
    CREATE INDEX IX_Employees_Branch ON Employees(BranchID);
    CREATE INDEX IX_Employees_Active ON Employees(IsActive);
    
    PRINT '✓ Employees table created'
END
ELSE
BEGIN
    PRINT 'Employees table exists'
    
    -- Add missing columns
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'HourlyRate')
    BEGIN
        ALTER TABLE Employees ADD HourlyRate DECIMAL(18,2) DEFAULT 0;
        PRINT '✓ Added HourlyRate'
    END
    
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees' AND COLUMN_NAME = 'PaymentType')
    BEGIN
        ALTER TABLE Employees ADD PaymentType NVARCHAR(20);
        ALTER TABLE Employees ADD CONSTRAINT CK_Employees_PaymentType CHECK (PaymentType IN ('Hourly', 'Salary', 'Commission'));
        PRINT '✓ Added PaymentType'
    END
END
GO

-- Timesheet Table
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
        Notes NVARCHAR(200),
        ApprovedBy INT,
        ApprovedDate DATETIME2,
        Status NVARCHAR(20) DEFAULT 'Pending', -- Pending, Approved, Rejected
        CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Timesheets_Employee FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
        CONSTRAINT CK_Timesheets_Status CHECK (Status IN ('Pending', 'Approved', 'Rejected'))
    );
    
    CREATE INDEX IX_Timesheets_Employee ON Timesheets(EmployeeID);
    CREATE INDEX IX_Timesheets_Date ON Timesheets(WorkDate DESC);
    CREATE INDEX IX_Timesheets_Status ON Timesheets(Status);
    
    PRINT '✓ Timesheets table created'
END
ELSE
BEGIN
    PRINT 'Timesheets table exists'
END
GO

-- Payroll Runs Table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PayrollRuns')
BEGIN
    CREATE TABLE PayrollRuns (
        PayrollRunID INT IDENTITY(1,1) PRIMARY KEY,
        PayrollNumber NVARCHAR(50) NOT NULL UNIQUE,
        PayPeriodStart DATE NOT NULL,
        PayPeriodEnd DATE NOT NULL,
        PaymentDate DATE NOT NULL,
        TotalGrossPay DECIMAL(18,2) DEFAULT 0,
        TotalDeductions DECIMAL(18,2) DEFAULT 0,
        TotalNetPay DECIMAL(18,2) DEFAULT 0,
        Status NVARCHAR(20) DEFAULT 'Draft', -- Draft, Approved, Paid
        BranchID INT,
        CreatedBy INT,
        CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),
        ApprovedBy INT,
        ApprovedDate DATETIME2,
        CONSTRAINT FK_PayrollRuns_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
        CONSTRAINT CK_PayrollRuns_Status CHECK (Status IN ('Draft', 'Approved', 'Paid'))
    );
    
    CREATE INDEX IX_PayrollRuns_Period ON PayrollRuns(PayPeriodStart, PayPeriodEnd);
    CREATE INDEX IX_PayrollRuns_Status ON PayrollRuns(Status);
    CREATE INDEX IX_PayrollRuns_Branch ON PayrollRuns(BranchID);
    
    PRINT '✓ PayrollRuns table created'
END
ELSE
BEGIN
    PRINT 'PayrollRuns table exists'
END
GO

-- Payroll Details Table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PayrollDetails')
BEGIN
    CREATE TABLE PayrollDetails (
        PayrollDetailID INT IDENTITY(1,1) PRIMARY KEY,
        PayrollRunID INT NOT NULL,
        EmployeeID INT NOT NULL,
        HoursWorked DECIMAL(5,2) DEFAULT 0,
        OvertimeHours DECIMAL(5,2) DEFAULT 0,
        HourlyRate DECIMAL(18,2) DEFAULT 0,
        OvertimeRate DECIMAL(18,2) DEFAULT 0,
        GrossPay DECIMAL(18,2) DEFAULT 0,
        TaxAmount DECIMAL(18,2) DEFAULT 0,
        UIF DECIMAL(18,2) DEFAULT 0,
        OtherDeductions DECIMAL(18,2) DEFAULT 0,
        NetPay DECIMAL(18,2) DEFAULT 0,
        PaymentMethod NVARCHAR(50),
        Notes NVARCHAR(200),
        CONSTRAINT FK_PayrollDetails_Run FOREIGN KEY (PayrollRunID) REFERENCES PayrollRuns(PayrollRunID),
        CONSTRAINT FK_PayrollDetails_Employee FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
    );
    
    CREATE INDEX IX_PayrollDetails_Run ON PayrollDetails(PayrollRunID);
    CREATE INDEX IX_PayrollDetails_Employee ON PayrollDetails(EmployeeID);
    
    PRINT '✓ PayrollDetails table created'
END
ELSE
BEGIN
    PRINT 'PayrollDetails table exists'
END
GO

-- =============================================
-- PART 5: BANK STATEMENT IMPORT
-- =============================================
PRINT ''
PRINT '=== PART 5: Bank Statement Import ==='

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'BankAccounts')
BEGIN
    CREATE TABLE BankAccounts (
        BankAccountID INT IDENTITY(1,1) PRIMARY KEY,
        AccountName NVARCHAR(100) NOT NULL,
        BankName NVARCHAR(100),
        AccountNumber NVARCHAR(50) NOT NULL,
        BranchCode NVARCHAR(20),
        AccountType NVARCHAR(50), -- Current, Savings, Credit Card
        Currency NVARCHAR(3) DEFAULT 'ZAR',
        OpeningBalance DECIMAL(18,2) DEFAULT 0,
        CurrentBalance DECIMAL(18,2) DEFAULT 0,
        BranchID INT,
        GLAccountID INT, -- Link to GL Account
        IsActive BIT DEFAULT 1,
        CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_BankAccounts_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    );
    
    CREATE INDEX IX_BankAccounts_Number ON BankAccounts(AccountNumber);
    CREATE INDEX IX_BankAccounts_Branch ON BankAccounts(BranchID);
    
    PRINT '✓ BankAccounts table created'
END
ELSE
BEGIN
    PRINT 'BankAccounts table exists'
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'BankStatementImports')
BEGIN
    CREATE TABLE BankStatementImports (
        ImportID INT IDENTITY(1,1) PRIMARY KEY,
        BankAccountID INT NOT NULL,
        ImportDate DATETIME2 DEFAULT SYSUTCDATETIME(),
        StatementDate DATE,
        FileName NVARCHAR(200),
        TotalTransactions INT DEFAULT 0,
        TotalMatched INT DEFAULT 0,
        TotalUnmatched INT DEFAULT 0,
        Status NVARCHAR(20) DEFAULT 'Pending', -- Pending, Matched, Completed
        ImportedBy INT,
        CONSTRAINT FK_BankImports_Account FOREIGN KEY (BankAccountID) REFERENCES BankAccounts(BankAccountID),
        CONSTRAINT CK_BankImports_Status CHECK (Status IN ('Pending', 'Matched', 'Completed'))
    );
    
    CREATE INDEX IX_BankImports_Account ON BankStatementImports(BankAccountID);
    CREATE INDEX IX_BankImports_Date ON BankStatementImports(ImportDate DESC);
    
    PRINT '✓ BankStatementImports table created'
END
ELSE
BEGIN
    PRINT 'BankStatementImports table exists'
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'BankTransactions')
BEGIN
    CREATE TABLE BankTransactions (
        BankTransactionID INT IDENTITY(1,1) PRIMARY KEY,
        ImportID INT,
        BankAccountID INT NOT NULL,
        TransactionDate DATE NOT NULL,
        ValueDate DATE,
        Description NVARCHAR(200),
        Reference NVARCHAR(100),
        Amount DECIMAL(18,2) NOT NULL,
        Balance DECIMAL(18,2),
        TransactionType NVARCHAR(20), -- Debit, Credit
        IsReconciled BIT DEFAULT 0,
        CashBookID INT, -- Link to matched CashBook entry
        MatchedBy INT,
        MatchedDate DATETIME2,
        Notes NVARCHAR(200),
        CONSTRAINT FK_BankTransactions_Import FOREIGN KEY (ImportID) REFERENCES BankStatementImports(ImportID),
        CONSTRAINT FK_BankTransactions_Account FOREIGN KEY (BankAccountID) REFERENCES BankAccounts(BankAccountID),
        CONSTRAINT FK_BankTransactions_CashBook FOREIGN KEY (CashBookID) REFERENCES CashBook(CashBookID)
    );
    
    CREATE INDEX IX_BankTransactions_Import ON BankTransactions(ImportID);
    CREATE INDEX IX_BankTransactions_Account ON BankTransactions(BankAccountID);
    CREATE INDEX IX_BankTransactions_Date ON BankTransactions(TransactionDate DESC);
    CREATE INDEX IX_BankTransactions_Reconciled ON BankTransactions(IsReconciled);
    
    PRINT '✓ BankTransactions table created'
END
ELSE
BEGIN
    PRINT 'BankTransactions table exists'
END
GO

-- =============================================
-- PART 6: VERIFICATION
-- =============================================
PRINT ''
PRINT '=== PART 6: Verification ==='
PRINT ''

PRINT 'Accounting Tables Created:'
SELECT 
    TABLE_NAME,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = t.TABLE_NAME) AS ColumnCount
FROM INFORMATION_SCHEMA.TABLES t
WHERE TABLE_NAME IN (
    'ExpenseCategories',
    'IncomeCategories',
    'CashBook',
    'Employees',
    'Timesheets',
    'PayrollRuns',
    'PayrollDetails',
    'BankAccounts',
    'BankStatementImports',
    'BankTransactions'
)
ORDER BY TABLE_NAME;

PRINT ''
PRINT '========================================='
PRINT 'ACCOUNTING SYSTEM SETUP COMPLETE!'
PRINT '========================================='
PRINT ''
PRINT 'Created:'
PRINT '  ✓ Expense Categories (SAGE standard)'
PRINT '  ✓ Income Categories (SAGE standard)'
PRINT '  ✓ Cash Book Journal (3-column format)'
PRINT '  ✓ Payroll System (weekly/hourly)'
PRINT '  ✓ Bank Statement Import & Reconciliation'
PRINT ''
PRINT 'Next: Run reports and test money trail'
PRINT ''
GO
