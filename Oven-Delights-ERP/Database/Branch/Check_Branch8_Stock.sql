-- =============================================
-- Check stock initialization for Branch 8
-- =============================================

-- 1. Check if Branch 8 exists in RetailStock table
SELECT 'RetailStock for Branch 8' AS TableName, COUNT(*) AS RecordCount
FROM RetailStock
WHERE BranchID = 8;

SELECT TOP 10 *
FROM RetailStock
WHERE BranchID = 8
ORDER BY ProductID;

-- 2. Check if Branch 8 exists in Demo_Retail_Stock (if this table exists)
IF OBJECT_ID('Demo_Retail_Stock', 'U') IS NOT NULL
BEGIN
    SELECT 'Demo_Retail_Stock for Branch 8' AS TableName, COUNT(*) AS RecordCount
    FROM Demo_Retail_Stock
    WHERE BranchID = 8;
    
    SELECT TOP 10 *
    FROM Demo_Retail_Stock
    WHERE BranchID = 8
    ORDER BY ProductID;
END
ELSE
BEGIN
    SELECT 'Demo_Retail_Stock table does NOT exist' AS Status;
END

-- 3. Check what the POS view is using
IF OBJECT_ID('POS_ProductView', 'V') IS NOT NULL
BEGIN
    SELECT 'POS_ProductView Definition' AS Info;
    EXEC sp_helptext 'POS_ProductView';
END

-- 4. Check prices for Branch 8
SELECT 'Demo_Retail_Price for Branch 8' AS TableName, COUNT(*) AS RecordCount
FROM Demo_Retail_Price
WHERE BranchID = 8;

SELECT TOP 10 
    drp.ProductID,
    drp.SellingPrice,
    drp.CostPrice,
    drp.BranchID
FROM Demo_Retail_Price drp
WHERE drp.BranchID = 8
ORDER BY drp.ProductID;

-- 5. Check what products would show for Branch 8 in POS
SELECT 
    drp.ProductID,
    drp.SKU AS ProductCode,
    drp.Name AS ProductName,
    price.SellingPrice,
    stock.Quantity,
    stock.StockType
FROM Demo_Retail_Product drp
LEFT JOIN Demo_Retail_Price price ON price.ProductID = drp.ProductID AND price.BranchID = 8
LEFT JOIN RetailStock stock ON stock.ProductID = drp.ProductID AND stock.BranchID = 8
WHERE drp.IsActive = 1
  AND (drp.ProductType = 'External' OR drp.ProductType = 'Internal')
  AND price.SellingPrice > 0
ORDER BY drp.ProductID;

-- 6. Summary
SELECT 
    'Branch 8 Summary' AS Report,
    (SELECT COUNT(*) FROM Demo_Retail_Price WHERE BranchID = 8) AS PriceRecords,
    (SELECT COUNT(*) FROM RetailStock WHERE BranchID = 8) AS StockRecords,
    (SELECT COUNT(*) FROM Demo_Retail_Price WHERE BranchID = 8 AND SellingPrice > 0) AS ValidPrices;
