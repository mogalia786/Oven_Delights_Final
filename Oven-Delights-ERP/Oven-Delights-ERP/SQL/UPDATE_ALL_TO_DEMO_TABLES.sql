-- =============================================
-- UPDATE ALL REFERENCES TO USE DEMO TABLES
-- =============================================
-- This script documents all table replacements needed
-- Execute Find & Replace in Visual Studio for each

/*
CRITICAL: ALL retail, sales, and stock operations MUST use Demo tables

FIND & REPLACE IN VISUAL STUDIO (Ctrl+Shift+H):
Look in: Entire Solution
Match case: Yes

1. Sales Tables:
   Find: FROM Sales 
   Replace: FROM dbo.Demo_Sales 
   
   Find: UPDATE Sales 
   Replace: UPDATE dbo.Demo_Sales 
   
   Find: INSERT INTO Sales 
   Replace: INSERT INTO dbo.Demo_Sales 
   
   Find: FROM SalesDetails
   Replace: FROM dbo.Demo_SalesDetails
   
   Find: UPDATE SalesDetails
   Replace: UPDATE dbo.Demo_SalesDetails
   
   Find: INSERT INTO SalesDetails
   Replace: INSERT INTO dbo.Demo_SalesDetails

2. Retail Stock Tables (ALREADY DONE):
   Find: FROM Retail_Stock
   Replace: FROM dbo.Demo_Retail_Stock
   
   Find: UPDATE Retail_Stock
   Replace: UPDATE dbo.Demo_Retail_Stock
   
   Find: INSERT INTO Retail_Stock
   Replace: INSERT INTO dbo.Demo_Retail_Stock
   
   Find: FROM Retail_StockMovements
   Replace: FROM dbo.Demo_Retail_StockMovements
   
   Find: INSERT INTO Retail_StockMovements
   Replace: INSERT INTO dbo.Demo_Retail_StockMovements

3. Retail Product Tables:
   Find: FROM Retail_Product
   Replace: FROM dbo.Demo_Retail_Product
   
   Find: UPDATE Retail_Product
   Replace: UPDATE dbo.Demo_Retail_Product

4. Payment Tables:
   Find: FROM Payments
   Replace: FROM dbo.Demo_Payments
   
   Find: INSERT INTO Payments
   Replace: INSERT INTO dbo.Demo_Payments

5. Returns Tables:
   Find: FROM Returns
   Replace: FROM dbo.Demo_Returns
   
   Find: INSERT INTO Returns
   Replace: INSERT INTO dbo.Demo_Returns
*/

-- =============================================
-- DEMO TABLES STRUCTURE
-- =============================================

/*
SALES:
- dbo.Demo_Sales (sales header)
- dbo.Demo_SalesDetails (sales line items)
- dbo.Demo_Payments (payment records)
- dbo.Demo_Returns (return records)

RETAIL:
- dbo.Demo_Retail_Product (products with branch-specific prices)
- dbo.Demo_Retail_Stock (branch-specific inventory)
- dbo.Demo_Retail_StockMovements (stock movement history)
- dbo.Demo_Retail_Variant (product variants)
- dbo.Demo_Retail_Price (pricing tiers)

STOCK MOVEMENTS:
- dbo.Demo_Retail_StockMovements (retail movements)
- RawMaterialMovements (stockroom movements - may not have Demo prefix)
- ManufacturingStockMovements (manufacturing movements - may not have Demo prefix)
*/

-- =============================================
-- VERIFY DEMO TABLES EXIST
-- =============================================

SELECT 
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE 'Demo_%'
ORDER BY TABLE_NAME;

-- =============================================
-- CHECK CURRENT SALES TABLE USAGE
-- =============================================

-- This will help identify which tables are currently being used
SELECT 
    OBJECT_NAME(object_id) AS TableName,
    name AS ColumnName,
    TYPE_NAME(user_type_id) AS DataType
FROM sys.columns
WHERE OBJECT_NAME(object_id) LIKE '%Sales%'
   OR OBJECT_NAME(object_id) LIKE '%Retail%'
ORDER BY TableName, column_id;
