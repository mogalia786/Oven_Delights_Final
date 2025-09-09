SET NOCOUNT ON;
/* =============================================================
   33_Accounting_Expenses_AlterAndView.sql
   Purpose: Fix invalid column errors by adding missing columns to existing
            tables and recreating the expenses detail view.
   Safe to run multiple times.
   ============================================================= */

-- ===== Ensure ExpenseTypes has required columns =====
IF COL_LENGTH('dbo.ExpenseTypes', 'ExpenseTypeCode') IS NULL
BEGIN
    ALTER TABLE dbo.ExpenseTypes ADD ExpenseTypeCode VARCHAR(12) NULL;
END;
IF COL_LENGTH('dbo.ExpenseTypes', 'ExpenseTypeName') IS NULL
BEGIN
    ALTER TABLE dbo.ExpenseTypes ADD ExpenseTypeName NVARCHAR(100) NULL;
END;
IF COL_LENGTH('dbo.ExpenseTypes', 'TypeGroup') IS NULL
BEGIN
    ALTER TABLE dbo.ExpenseTypes ADD TypeGroup VARCHAR(12) NULL;
    UPDATE dbo.ExpenseTypes SET TypeGroup = 'Expense' WHERE TypeGroup IS NULL;
END;

-- Make columns NOT NULL if possible (only if no NULLs remain)
IF COL_LENGTH('dbo.ExpenseTypes', 'ExpenseTypeCode') IS NOT NULL
   AND EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.ExpenseTypes') AND name='ExpenseTypeCode')
   AND NOT EXISTS (SELECT 1 FROM dbo.ExpenseTypes WHERE ExpenseTypeCode IS NULL)
BEGIN
    ALTER TABLE dbo.ExpenseTypes ALTER COLUMN ExpenseTypeCode VARCHAR(12) NOT NULL;
END;
IF COL_LENGTH('dbo.ExpenseTypes', 'ExpenseTypeName') IS NOT NULL
   AND EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.ExpenseTypes') AND name='ExpenseTypeName')
   AND NOT EXISTS (SELECT 1 FROM dbo.ExpenseTypes WHERE ExpenseTypeName IS NULL)
BEGIN
    ALTER TABLE dbo.ExpenseTypes ALTER COLUMN ExpenseTypeName NVARCHAR(100) NOT NULL;
END;
IF COL_LENGTH('dbo.ExpenseTypes', 'TypeGroup') IS NOT NULL
   AND EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.ExpenseTypes') AND name='TypeGroup')
   AND NOT EXISTS (SELECT 1 FROM dbo.ExpenseTypes WHERE TypeGroup IS NULL)
BEGIN
    ALTER TABLE dbo.ExpenseTypes ALTER COLUMN TypeGroup VARCHAR(12) NOT NULL;
END;

-- ===== Ensure Categories has CategoryCode =====
IF OBJECT_ID('dbo.Categories') IS NOT NULL AND COL_LENGTH('dbo.Categories', 'CategoryCode') IS NULL
BEGIN
    ALTER TABLE dbo.Categories ADD CategoryCode VARCHAR(10) NULL;
END;

-- ===== Ensure Subcategories has SubcategoryCode and CategoryID =====
IF OBJECT_ID('dbo.Subcategories') IS NOT NULL AND COL_LENGTH('dbo.Subcategories', 'SubcategoryCode') IS NULL
BEGIN
    ALTER TABLE dbo.Subcategories ADD SubcategoryCode VARCHAR(20) NULL;
END;
-- If older schema used a different FK name, ensure CategoryID exists (skip if present)
IF OBJECT_ID('dbo.Subcategories') IS NOT NULL AND COL_LENGTH('dbo.Subcategories', 'CategoryID') IS NULL
BEGIN
    ALTER TABLE dbo.Subcategories ADD CategoryID INT NULL;
END;

-- ===== Recreate view with defensive NULL-able columns =====
IF OBJECT_ID('dbo.vw_Expenses_Detail', 'V') IS NOT NULL
BEGIN
    DROP VIEW dbo.vw_Expenses_Detail;
END;
GO

CREATE VIEW dbo.vw_Expenses_Detail AS
SELECT 
    e.ExpenseID,
    e.ExpenseCode,
    e.ExpenseName,
    e.IsActive,
    e.Notes,
    et.ExpenseTypeID,
    et.ExpenseTypeCode,
    et.ExpenseTypeName,
    et.TypeGroup,
    c.CategoryID,
    c.CategoryCode,
    c.CategoryName,
    s.SubcategoryID,
    s.SubcategoryCode,
    s.SubcategoryName,
    e.CreatedDate,
    e.ModifiedDate
FROM dbo.Expenses e
JOIN dbo.ExpenseTypes et ON et.ExpenseTypeID = e.ExpenseTypeID
LEFT JOIN dbo.Categories c ON c.CategoryID = e.CategoryID
LEFT JOIN dbo.Subcategories s ON s.SubcategoryID = e.SubcategoryID;
GO

PRINT 'Altered tables and recreated vw_Expenses_Detail.';
