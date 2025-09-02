SET NOCOUNT ON;
/* =============================================================
   34_Recreate_vw_Expenses_Detail_Compat.sql
   Purpose: Recreate vw_Expenses_Detail in a way that works even if some
            legacy databases are missing newer columns. The view will
            project NULLs for missing columns to keep compatibility.
   Safe to run multiple times.
   ============================================================= */

DECLARE @has_ET_Code BIT = CASE WHEN COL_LENGTH('dbo.ExpenseTypes','ExpenseTypeCode') IS NULL THEN 0 ELSE 1 END;
DECLARE @has_ET_Name BIT = CASE WHEN COL_LENGTH('dbo.ExpenseTypes','ExpenseTypeName') IS NULL THEN 0 ELSE 1 END;
DECLARE @has_ET_Group BIT = CASE WHEN COL_LENGTH('dbo.ExpenseTypes','TypeGroup') IS NULL THEN 0 ELSE 1 END;
DECLARE @has_Cat_Code BIT = CASE WHEN COL_LENGTH('dbo.Categories','CategoryCode') IS NULL THEN 0 ELSE 1 END;
DECLARE @has_Sub_Code BIT = CASE WHEN COL_LENGTH('dbo.Subcategories','SubcategoryCode') IS NULL THEN 0 ELSE 1 END;

DECLARE @sql NVARCHAR(MAX) = N'';

IF OBJECT_ID('dbo.vw_Expenses_Detail','V') IS NOT NULL
BEGIN
    DROP VIEW dbo.vw_Expenses_Detail;
END;

SET @sql = N'SELECT ' +
N'    e.ExpenseID,
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
N'    c.CategoryID,' +
CASE WHEN @has_Cat_Code = 1 THEN N'
    c.CategoryCode,' ELSE N'
    CAST(NULL AS VARCHAR(10)) AS CategoryCode,' END +
N'    c.CategoryName,
    s.SubcategoryID,' +
CASE WHEN @has_Sub_Code = 1 THEN N'
    s.SubcategoryCode,' ELSE N'
    CAST(NULL AS VARCHAR(20)) AS SubcategoryCode,' END +
N'    s.SubcategoryName,
    e.CreatedDate,
    e.ModifiedDate
FROM dbo.Expenses e
JOIN dbo.ExpenseTypes et ON et.ExpenseTypeID = e.ExpenseTypeID
LEFT JOIN dbo.Categories c ON c.CategoryID = e.CategoryID
LEFT JOIN dbo.Subcategories s ON s.SubcategoryID = e.SubcategoryID';

SET @sql = N'CREATE VIEW dbo.vw_Expenses_Detail AS
' + @sql + N';';

EXEC sys.sp_executesql @sql;

PRINT 'vw_Expenses_Detail recreated (compat mode).';
