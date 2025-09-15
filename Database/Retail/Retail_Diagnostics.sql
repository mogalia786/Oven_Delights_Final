-- Retail Diagnostics: verify BranchID columns and view existence
SET NOCOUNT ON;

PRINT '== Column existence check (BranchID vs BranchId) ==';
SELECT 'Retail_Price' AS TableName,
       COL_LENGTH('dbo.Retail_Price','BranchID')  AS BranchID,
       COL_LENGTH('dbo.Retail_Price','BranchId')  AS BranchId;
SELECT 'Retail_Stock' AS TableName,
       COL_LENGTH('dbo.Retail_Stock','BranchID')  AS BranchID,
       COL_LENGTH('dbo.Retail_Stock','BranchId')  AS BranchId;
SELECT 'Retail_StockMovements' AS TableName,
       COL_LENGTH('dbo.Retail_StockMovements','BranchID')  AS BranchID,
       COL_LENGTH('dbo.Retail_StockMovements','BranchId')  AS BranchId;

PRINT '== Retail tables ==';
SELECT name FROM sys.tables WHERE name LIKE 'Retail_%' ORDER BY name;

PRINT '== Retail views ==';
SELECT name FROM sys.views WHERE name LIKE 'v_Retail_%' ORDER BY name;
