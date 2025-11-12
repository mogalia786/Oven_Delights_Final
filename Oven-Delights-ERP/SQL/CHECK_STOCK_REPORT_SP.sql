-- Check the sp_Report_StockLevels stored procedure definition
SELECT OBJECT_DEFINITION(OBJECT_ID('dbo.sp_Report_StockLevels')) AS ProcedureDefinition;

-- Also check what tables have stock data
SELECT 'Retail_Stock' AS TableName, COUNT(*) AS RecordCount FROM dbo.Retail_Stock;
SELECT 'ProductInventory' AS TableName, COUNT(*) AS RecordCount FROM dbo.ProductInventory;

-- Check if these tables exist
IF OBJECT_ID('dbo.StockroomStock', 'U') IS NOT NULL
    SELECT 'StockroomStock' AS TableName, COUNT(*) AS RecordCount FROM dbo.StockroomStock;
    
IF OBJECT_ID('dbo.ManufacturingStock', 'U') IS NOT NULL
    SELECT 'ManufacturingStock' AS TableName, COUNT(*) AS RecordCount FROM dbo.ManufacturingStock;
    
IF OBJECT_ID('dbo.RetailStock', 'U') IS NOT NULL
    SELECT 'RetailStock' AS TableName, COUNT(*) AS RecordCount FROM dbo.RetailStock;
