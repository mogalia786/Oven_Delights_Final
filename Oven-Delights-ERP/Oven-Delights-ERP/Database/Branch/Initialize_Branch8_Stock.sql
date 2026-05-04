-- =============================================
-- Initialize Stock Records for Branch 8
-- This should have been done by sp_InitializeBranchProducts but let's verify and fix
-- =============================================

DECLARE @BranchID INT = 8;

-- 1. Check current state
SELECT 'Current State for Branch 8' AS Status;

SELECT 
    'Prices' AS TableName,
    COUNT(*) AS RecordCount,
    SUM(CASE WHEN SellingPrice > 0 THEN 1 ELSE 0 END) AS ValidPrices
FROM Demo_Retail_Price
WHERE BranchID = @BranchID;

SELECT 
    'Stock' AS TableName,
    COUNT(*) AS RecordCount
FROM RetailStock
WHERE BranchID = @BranchID;

-- 2. If stock records don't exist, create them
IF NOT EXISTS (SELECT 1 FROM RetailStock WHERE BranchID = @BranchID)
BEGIN
    PRINT 'Creating stock records for Branch ' + CAST(@BranchID AS VARCHAR);
    
    BEGIN TRANSACTION;
    
    INSERT INTO RetailStock (ProductID, BranchID, Quantity, StockType, LastUpdated, UpdatedBy)
    SELECT 
        drp.ProductID,
        @BranchID,
        0 AS Quantity,
        drp.ProductType AS StockType,
        GETDATE() AS LastUpdated,
        'System' AS UpdatedBy
    FROM Demo_Retail_Product drp
    WHERE drp.IsActive = 1
      AND (drp.ProductType = 'External' OR drp.ProductType = 'Internal')
      AND EXISTS (
          SELECT 1 FROM Demo_Retail_Price 
          WHERE ProductID = drp.ProductID AND BranchID = @BranchID
      )
      AND NOT EXISTS (
          SELECT 1 FROM RetailStock 
          WHERE ProductID = drp.ProductID AND BranchID = @BranchID
      );
    
    PRINT 'Stock records created: ' + CAST(@@ROWCOUNT AS VARCHAR);
    
    COMMIT TRANSACTION;
END
ELSE
BEGIN
    PRINT 'Stock records already exist for Branch ' + CAST(@BranchID AS VARCHAR);
END

-- 3. Verify the result
SELECT 
    'Final State for Branch 8' AS Status,
    (SELECT COUNT(*) FROM Demo_Retail_Price WHERE BranchID = @BranchID) AS PriceRecords,
    (SELECT COUNT(*) FROM RetailStock WHERE BranchID = @BranchID) AS StockRecords,
    (SELECT COUNT(*) FROM Demo_Retail_Price WHERE BranchID = @BranchID AND SellingPrice > 0) AS ValidPrices;

-- 4. Show sample data
SELECT TOP 10
    drp.ProductID,
    drp.SKU AS ProductCode,
    drp.Name AS ProductName,
    price.SellingPrice,
    stock.Quantity,
    stock.StockType
FROM Demo_Retail_Product drp
INNER JOIN Demo_Retail_Price price ON price.ProductID = drp.ProductID AND price.BranchID = @BranchID
LEFT JOIN RetailStock stock ON stock.ProductID = drp.ProductID AND stock.BranchID = @BranchID
WHERE drp.IsActive = 1
  AND price.SellingPrice > 0
ORDER BY drp.SKU;

PRINT 'Branch 8 initialization complete!';
