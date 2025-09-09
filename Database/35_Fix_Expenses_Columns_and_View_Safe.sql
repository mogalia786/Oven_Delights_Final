SET NOCOUNT ON;
/* =============================================================
   35_Fix_Expenses_Columns_and_View_Safe.sql
   Purpose: Safely add needed columns without querying them, then recreate
            vw_Expenses_Detail in compatibility mode (no hard dependency
            on new columns). Safe to run multiple times.
   ============================================================= */

-- ===== Ensure tables exist =====
IF OBJECT_ID('dbo.ExpenseTypes') IS NULL
BEGIN
    RAISERROR('Table dbo.ExpenseTypes does not exist. Run 32_Categories_Subcategories_Expenses.sql first.', 16, 1);
    RETURN;
END;
IF OBJECT_ID('dbo.Expenses') IS NULL
BEGIN
    RAISERROR('Table dbo.Expenses does not exist. Run 32_Categories_Subcategories_Expenses.sql first.', 16, 1);
    RETURN;
END;
IF OBJECT_ID('dbo.Categories') IS NULL
BEGIN
    PRINT 'Warning: dbo.Categories missing; Category columns in view will be NULL.';
END;
IF OBJECT_ID('dbo.Subcategories') IS NULL
BEGIN
    PRINT 'Warning: dbo.Subcategories missing; Subcategory columns in view will be NULL.';
END;

-- ===== Add missing columns (no queries that reference them) =====
IF COL_LENGTH('dbo.ExpenseTypes', 'ExpenseTypeCode') IS NULL
    ALTER TABLE dbo.ExpenseTypes ADD ExpenseTypeCode VARCHAR(12) NULL;
IF COL_LENGTH('dbo.ExpenseTypes', 'ExpenseTypeName') IS NULL
    ALTER TABLE dbo.ExpenseTypes ADD ExpenseTypeName NVARCHAR(100) NULL;
IF COL_LENGTH('dbo.ExpenseTypes', 'TypeGroup') IS NULL
    ALTER TABLE dbo.ExpenseTypes ADD TypeGroup VARCHAR(12) NULL;

IF OBJECT_ID('dbo.Categories') IS NOT NULL AND COL_LENGTH('dbo.Categories', 'CategoryCode') IS NULL
    ALTER TABLE dbo.Categories ADD CategoryCode VARCHAR(10) NULL;

IF OBJECT_ID('dbo.Subcategories') IS NOT NULL AND COL_LENGTH('dbo.Subcategories', 'SubcategoryCode') IS NULL
    ALTER TABLE dbo.Subcategories ADD SubcategoryCode VARCHAR(20) NULL;

-- ===== Recreate view in compatibility mode (dynamic SQL) =====
IF OBJECT_ID('dbo.vw_Expenses_Detail', 'V') IS NOT NULL
    DROP VIEW dbo.vw_Expenses_Detail;
GO

DECLARE @has_ET_Code BIT = CASE WHEN COL_LENGTH('dbo.ExpenseTypes','ExpenseTypeCode') IS NULL THEN 0 ELSE 1 END;
DECLARE @has_ET_Name BIT = CASE WHEN COL_LENGTH('dbo.ExpenseTypes','ExpenseTypeName') IS NULL THEN 0 ELSE 1 END;
DECLARE @has_ET_Group BIT = CASE WHEN COL_LENGTH('dbo.ExpenseTypes','TypeGroup') IS NULL THEN 0 ELSE 1 END;
DECLARE @has_Cat TABLE (HasTable BIT, HasCode BIT);
DECLARE @has_Sub TABLE (HasTable BIT, HasCode BIT);

INSERT INTO @has_Cat SELECT CASE WHEN OBJECT_ID('dbo.Categories') IS NULL THEN 0 ELSE 1 END, CASE WHEN COL_LENGTH('dbo.Categories','CategoryCode') IS NULL THEN 0 ELSE 1 END;
INSERT INTO @has_Sub SELECT CASE WHEN OBJECT_ID('dbo.Subcategories') IS NULL THEN 0 ELSE 1 END, CASE WHEN COL_LENGTH('dbo.Subcategories','SubcategoryCode') IS NULL THEN 0 ELSE 1 END;

DECLARE @has_CatTable BIT = (SELECT TOP 1 HasTable FROM @has_Cat);
DECLARE @has_CatCode  BIT = (SELECT TOP 1 HasCode  FROM @has_Cat);
DECLARE @has_SubTable BIT = (SELECT TOP 1 HasTable FROM @has_Sub);
DECLARE @has_SubCode  BIT = (SELECT TOP 1 HasCode  FROM @has_Sub);

DECLARE @sql NVARCHAR(MAX) = N'';

SET @sql = N'SELECT 
    e.ExpenseID,
    e.ExpenseCode,
    e.ExpenseName,
    e.IsActive,
    e.Notes,
    et.ExpenseTypeID,' +
CASE WHEN @has_ET_Code = 1 THEN N'
    et.ExpenseTypeCode,' ELSE N'
    CAST(NULL AS VARCHAR(12)) AS ExpenseTypeCode,' END +
CASE WHEN @has_ET_Name = 1 THEN N'
    et.ExpenseTypeName,' ELSE N'
    CAST(NULL AS NVARCHAR(100)) AS ExpenseTypeName,' END +
CASE WHEN @has_ET_Group = 1 THEN N'
    et.TypeGroup,' ELSE N'
    CAST(NULL AS VARCHAR(12)) AS TypeGroup,' END +
CASE WHEN @has_CatTable = 1 THEN N'
    c.CategoryID,' ELSE N'
    CAST(NULL AS INT) AS CategoryID,' END +
CASE WHEN @has_CatCode = 1 THEN N'
    c.CategoryCode,' ELSE N'
    CAST(NULL AS VARCHAR(10)) AS CategoryCode,' END +
CASE WHEN @has_CatTable = 1 THEN N'
    c.CategoryName,' ELSE N'
    CAST(NULL AS NVARCHAR(100)) AS CategoryName,' END +
CASE WHEN @has_SubTable = 1 THEN N'
    s.SubcategoryID,' ELSE N'
    CAST(NULL AS INT) AS SubcategoryID,' END +
CASE WHEN @has_SubCode = 1 THEN N'
    s.SubcategoryCode,' ELSE N'
    CAST(NULL AS VARCHAR(20)) AS SubcategoryCode,' END +
CASE WHEN @has_SubTable = 1 THEN N'
    s.SubcategoryName,' ELSE N'
    CAST(NULL AS NVARCHAR(100)) AS SubcategoryName,' END +
N'
    e.CreatedDate,
    e.ModifiedDate
FROM dbo.Expenses e
JOIN dbo.ExpenseTypes et ON et.ExpenseTypeID = e.ExpenseTypeID' +
CASE WHEN @has_CatTable = 1 THEN N'
LEFT JOIN dbo.Categories c ON c.CategoryID = e.CategoryID' ELSE N'' END +
CASE WHEN @has_SubTable = 1 THEN N'
LEFT JOIN dbo.Subcategories s ON s.SubcategoryID = e.SubcategoryID' ELSE N'' END;

SET @sql = N'CREATE VIEW dbo.vw_Expenses_Detail AS
' + @sql + N';';

EXEC sys.sp_executesql @sql;

PRINT 'Columns ensured and vw_Expenses_Detail recreated safely.';
