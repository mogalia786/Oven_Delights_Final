SET NOCOUNT ON;

/* =============================================================
   32_Categories_Subcategories_Expenses.sql
   Creates master data for Categories, Subcategories, ExpenseTypes, and Expenses
   - Safe to run multiple times (guards included)
   - Seeds common ExpenseTypes including Expense and Income groups
   ============================================================= */

-- ========== 1) Categories ==========
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name='Categories' AND schema_id=SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.Categories (
        CategoryID      INT IDENTITY(1,1) PRIMARY KEY,
        CategoryCode    VARCHAR(10)  NOT NULL,          -- e.g., 01, 02 ...
        CategoryName    NVARCHAR(100) NOT NULL,
        IsActive        BIT NOT NULL DEFAULT(1),
        CreatedDate     DATETIME NOT NULL DEFAULT(GETDATE()),
        ModifiedDate    DATETIME NULL,
        CONSTRAINT UQ_Categories_Code UNIQUE (CategoryCode),
        CONSTRAINT UQ_Categories_Name UNIQUE (CategoryName)
    );
END;
GO

-- ========== 2) Subcategories ==========
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name='Subcategories' AND schema_id=SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.Subcategories (
        SubcategoryID       INT IDENTITY(1,1) PRIMARY KEY,
        CategoryID          INT NOT NULL REFERENCES dbo.Categories(CategoryID),
        SubcategoryCode     VARCHAR(20) NOT NULL,       -- e.g., 01-01 (or any code format you prefer)
        SubcategoryName     NVARCHAR(100) NOT NULL,
        IsActive            BIT NOT NULL DEFAULT(1),
        CreatedDate         DATETIME NOT NULL DEFAULT(GETDATE()),
        ModifiedDate        DATETIME NULL,
        CONSTRAINT UQ_Subcategories_Code UNIQUE (SubcategoryCode),
        CONSTRAINT UQ_Subcategories_Name UNIQUE (SubcategoryName)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Subcategories_CategoryID' AND object_id=OBJECT_ID('dbo.Subcategories'))
    CREATE INDEX IX_Subcategories_CategoryID ON dbo.Subcategories(CategoryID);
GO

-- ========== 3) ExpenseTypes ==========
-- Includes a group to differentiate Expense vs Income vs Other
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name='ExpenseTypes' AND schema_id=SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.ExpenseTypes (
        ExpenseTypeID       INT IDENTITY(1,1) PRIMARY KEY,
        ExpenseTypeCode     VARCHAR(12) NOT NULL,        -- e.g., UTIL, PAYR, IINC (Interest Income)
        ExpenseTypeName     NVARCHAR(100) NOT NULL,      -- e.g., Utilities, Interest Income
        TypeGroup           VARCHAR(12) NOT NULL DEFAULT('Expense'), -- Expense | Income | Other
        IsActive            BIT NOT NULL DEFAULT(1),
        CreatedDate         DATETIME NOT NULL DEFAULT(GETDATE()),
        ModifiedDate        DATETIME NULL,
        CONSTRAINT UQ_ExpenseTypes_Code UNIQUE (ExpenseTypeCode),
        CONSTRAINT UQ_ExpenseTypes_Name UNIQUE (ExpenseTypeName)
    );
END;
GO

-- Seed common types if table is empty (both Expense and Income)
IF NOT EXISTS (SELECT 1 FROM dbo.ExpenseTypes)
BEGIN
    INSERT INTO dbo.ExpenseTypes (ExpenseTypeCode, ExpenseTypeName, TypeGroup) VALUES
        -- Expense group
        ('UTIL','Utilities','Expense'),
        ('RENT','Rent','Expense'),
        ('PAYR','Payroll','Expense'),
        ('TEL','Telephone','Expense'),
        ('INT','Internet','Expense'),
        ('ELEC','Electricity','Expense'),
        ('WATR','Water','Expense'),
        ('FUEL','Fuel','Expense'),
        ('INS','Insurance','Expense'),
        ('OFF','Office Supplies','Expense'),
        ('MKT','Marketing & Advertising','Expense'),
        ('TRAV','Travel','Expense'),
        ('MEAL','Meals & Entertainment','Expense'),
        ('PROF','Professional Fees','Expense'),
        ('BANK','Bank Charges','Expense'),
        ('DEPR','Depreciation','Expense'),
        ('LIC','Licenses & Permits','Expense'),
        ('TRNG','Training & Development','Expense'),
        ('MISC','Miscellaneous','Expense'),
        ('BINT','Bank Interest (Expense)','Expense'),
        -- Income group (for things like Interest Earned, Misc Income, etc.)
        ('REV','Revenue','Income'),
        ('IINC','Interest Income','Income'),
        ('MISCIN','Miscellaneous Income','Income'),
        ('RENTIN','Rental Income','Income');
END;
GO

-- ========== 4) Expenses ==========
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name='Expenses' AND schema_id=SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.Expenses (
        ExpenseID       INT IDENTITY(1,1) PRIMARY KEY,
        ExpenseCode     VARCHAR(20) NOT NULL,           -- e.g., EXP-0001
        ExpenseName     NVARCHAR(150) NOT NULL,         -- user-defined label
        ExpenseTypeID   INT NOT NULL REFERENCES dbo.ExpenseTypes(ExpenseTypeID),
        CategoryID      INT NULL REFERENCES dbo.Categories(CategoryID),
        SubcategoryID   INT NULL REFERENCES dbo.Subcategories(SubcategoryID),
        IsActive        BIT NOT NULL DEFAULT(1),
        Notes           NVARCHAR(255) NULL,
        CreatedDate     DATETIME NOT NULL DEFAULT(GETDATE()),
        ModifiedDate    DATETIME NULL,
        CONSTRAINT UQ_Expenses_Code UNIQUE (ExpenseCode)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Expenses_Type' AND object_id=OBJECT_ID('dbo.Expenses'))
    CREATE INDEX IX_Expenses_Type ON dbo.Expenses(ExpenseTypeID);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Expenses_Category' AND object_id=OBJECT_ID('dbo.Expenses'))
    CREATE INDEX IX_Expenses_Category ON dbo.Expenses(CategoryID, SubcategoryID);
GO

-- ========== Convenience Views (optional) ==========
IF OBJECT_ID('dbo.vw_Expenses_Detail') IS NULL
BEGIN
    EXEC('CREATE VIEW dbo.vw_Expenses_Detail AS
          SELECT e.ExpenseID, e.ExpenseCode, e.ExpenseName, e.IsActive, e.Notes,
                 et.ExpenseTypeID, et.ExpenseTypeCode, et.ExpenseTypeName, et.TypeGroup,
                 c.CategoryID, c.CategoryCode, c.CategoryName,
                 s.SubcategoryID, s.SubcategoryCode, s.SubcategoryName,
                 e.CreatedDate, e.ModifiedDate
          FROM dbo.Expenses e
          JOIN dbo.ExpenseTypes et ON et.ExpenseTypeID = e.ExpenseTypeID
          LEFT JOIN dbo.Categories c ON c.CategoryID = e.CategoryID
          LEFT JOIN dbo.Subcategories s ON s.SubcategoryID = e.SubcategoryID');
END;
GO

PRINT 'Categories/Subcategories/ExpenseTypes/Expenses master setup complete.';
