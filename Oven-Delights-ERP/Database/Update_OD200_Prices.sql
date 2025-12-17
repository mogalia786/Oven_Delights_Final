-- Update Demo_Retail_Price for BranchID 6 (OD200) from CSV
-- This script updates CostPrice and RetailPrice based on SKU matching

-- First, let's create a temp table to hold CSV data
IF OBJECT_ID('tempdb..#OD200Prices') IS NOT NULL DROP TABLE #OD200Prices;

CREATE TABLE #OD200Prices (
    SKU NVARCHAR(50),
    Barcode NVARCHAR(50),
    ItemDescription NVARCHAR(255),
    Category NVARCHAR(100),
    ItemCategory NVARCHAR(100),
    Ingredients NVARCHAR(MAX),
    Description2 NVARCHAR(255),
    Warehouse NVARCHAR(50),
    CostPrice DECIMAL(18,2),
    InclPrice DECIMAL(18,2)
);

-- NOTE: You need to manually insert the CSV data here or use BULK INSERT
-- For now, I'll create a script that you can run after importing the CSV

-- Update existing products in Demo_Retail_Price
UPDATE drp
SET 
    drp.CostPrice = ROUND(tmp.CostPrice / 1.15, 2),  -- Convert Incl VAT to Excl VAT if needed
    drp.RetailPrice = tmp.InclPrice,
    drp.EffectiveFrom = GETDATE(),
    drp.CreatedAt = GETDATE()
FROM Demo_Retail_Price drp
INNER JOIN Demo_Retail_Product drprod ON drp.ProductID = drprod.ProductID AND drp.BranchID = drprod.BranchID
INNER JOIN #OD200Prices tmp ON drprod.SKU = tmp.SKU
WHERE drp.BranchID = 6;

-- Insert new products that don't exist in Demo_Retail_Price
INSERT INTO Demo_Retail_Price (ProductID, BranchID, CostPrice, RetailPrice, EffectiveFrom, CreatedAt)
SELECT 
    drprod.ProductID,
    6 AS BranchID,
    ROUND(tmp.CostPrice / 1.15, 2) AS CostPrice,  -- Convert Incl VAT to Excl VAT if needed
    tmp.InclPrice AS RetailPrice,
    GETDATE() AS EffectiveFrom,
    GETDATE() AS CreatedAt
FROM #OD200Prices tmp
INNER JOIN Demo_Retail_Product drprod ON tmp.SKU = drprod.SKU AND drprod.BranchID = 6
WHERE NOT EXISTS (
    SELECT 1 FROM Demo_Retail_Price drp 
    WHERE drp.ProductID = drprod.ProductID AND drp.BranchID = 6
);

-- Show results
SELECT 
    drprod.SKU,
    drprod.Name,
    drp.CostPrice,
    drp.RetailPrice,
    drp.EffectiveFrom
FROM Demo_Retail_Price drp
INNER JOIN Demo_Retail_Product drprod ON drp.ProductID = drprod.ProductID AND drp.BranchID = drprod.BranchID
WHERE drp.BranchID = 6
ORDER BY drprod.SKU;

-- Clean up
DROP TABLE #OD200Prices;
