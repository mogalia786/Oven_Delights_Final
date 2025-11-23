-- =============================================
-- IMPORT PRICES FROM Combined_Inventory.CSV
-- =============================================

PRINT '========================================';
PRINT 'IMPORTING PRICES FROM CSV';
PRINT '========================================';
PRINT '';

-- Create temp table for CSV import
IF OBJECT_ID('tempdb..#TempPrices', 'U') IS NOT NULL
    DROP TABLE #TempPrices;

CREATE TABLE #TempPrices (
    ItemCode NVARCHAR(100),
    BARCODE NVARCHAR(100),
    ITEM_DESCRIPTION NVARCHAR(500),
    CATERGORY NVARCHAR(100),
    item_catergory NVARCHAR(100),
    Ingredients NVARCHAR(MAX),
    Item_Description NVARCHAR(500),
    Whse NVARCHAR(50),
    Cost NVARCHAR(50),
    Incl_Price NVARCHAR(50),
    Extra NVARCHAR(50)
);

PRINT 'Step 1: Created temp table';
PRINT '';
PRINT 'Step 2: MANUAL ACTION REQUIRED:';
PRINT '----------------------------------------';
PRINT '1. Open SQL Server Management Studio';
PRINT '2. Right-click on Oven_Delights_Main database';
PRINT '3. Tasks → Import Data';
PRINT '4. Source: Flat File Source';
PRINT '5. File: c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\StockItems with Prices and descriptions\Combined_Inventory.csv';
PRINT '6. Destination: SQL Server Native Client';
PRINT '7. Table: tempdb..#TempPrices';
PRINT '8. Click Finish';
PRINT '';
PRINT 'OR use BULK INSERT (if file path is accessible):';
PRINT '';
PRINT 'BULK INSERT #TempPrices';
PRINT 'FROM ''c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\StockItems with Prices and descriptions\Combined_Inventory.csv''';
PRINT 'WITH (';
PRINT '    FIRSTROW = 2,';
PRINT '    FIELDTERMINATOR = '','',';
PRINT '    ROWTERMINATOR = ''\n'',';
PRINT '    TABLOCK';
PRINT ');';
PRINT '';
PRINT 'After importing, run the UPDATE section below...';
PRINT '========================================';

-- Uncomment and run this AFTER importing CSV data:
/*
PRINT '';
PRINT 'Step 3: Updating Products table with prices from CSV';
PRINT '';

BEGIN TRANSACTION;

UPDATE p
SET 
    p.RecommendedSellingPrice = TRY_CAST(REPLACE(REPLACE(tmp.Incl_Price, ',', ''), ' ', '') AS DECIMAL(18,2)),
    p.LastPaidPrice = TRY_CAST(REPLACE(REPLACE(tmp.Incl_Price, ',', ''), ' ', '') AS DECIMAL(18,2)),
    p.AverageCost = TRY_CAST(REPLACE(REPLACE(tmp.Cost, ',', ''), ' ', '') AS DECIMAL(18,2))
FROM Products p
INNER JOIN #TempPrices tmp ON tmp.ItemCode = p.ProductCode
WHERE tmp.Incl_Price IS NOT NULL
    AND tmp.Incl_Price <> ''
    AND TRY_CAST(REPLACE(REPLACE(tmp.Incl_Price, ',', ''), ' ', '') AS DECIMAL(18,2)) > 0;

DECLARE @UpdatedCount INT = @@ROWCOUNT;

COMMIT TRANSACTION;

PRINT 'Updated ' + CAST(@UpdatedCount AS NVARCHAR(10)) + ' products with prices from CSV';

-- Verify
SELECT 
    'Products with prices (after import)' AS Info,
    COUNT(*) AS TotalProducts,
    SUM(CASE WHEN RecommendedSellingPrice > 0 THEN 1 ELSE 0 END) AS WithPrice,
    SUM(CASE WHEN RecommendedSellingPrice IS NULL OR RecommendedSellingPrice = 0 THEN 1 ELSE 0 END) AS WithoutPrice
FROM Products
WHERE IsActive = 1
    AND ItemType IN ('internal', 'external', 'Manufactured');

DROP TABLE #TempPrices;

PRINT '';
PRINT '✅ PRICE IMPORT COMPLETE!';
PRINT '';
PRINT 'NEXT STEP: Update existing branches with new prices';
PRINT 'Run: UPDATE Demo_Retail_Price SET SellingPrice = p.RecommendedSellingPrice FROM Products p...';
*/
