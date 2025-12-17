-- Check where POS is actually getting the R 125.00 price from

PRINT '=== BC Chocolate Gateaux - ALL Price Sources ==='
PRINT ''

-- Check Demo_Retail_Product table
PRINT '1. Demo_Retail_Product table:'
SELECT 
    ProductID,
    SKU,
    Name,
    BranchID,
    CurrentStock,
    LastPaidPrice,
    AverageCost,
    ProductType
FROM Demo_Retail_Product
WHERE Name LIKE '%Chocolate Gateaux%'
  AND SKU LIKE '%BC%'
  AND BranchID = 6

PRINT ''
PRINT '2. Demo_Retail_Stock table:'
SELECT 
    VariantID,
    BranchID,
    QtyOnHand,
    AverageCost,
    LastPurchasePrice
FROM Demo_Retail_Stock
WHERE VariantID IN (
    SELECT ProductID FROM Demo_Retail_Product 
    WHERE Name LIKE '%Chocolate Gateaux%' AND SKU LIKE '%BC%'
)
AND BranchID = 6

PRINT ''
PRINT '3. Demo_Retail_Variant table:'
SELECT 
    VariantID,
    ProductID,
    VariantName,
    Price,
    Cost
FROM Demo_Retail_Variant
WHERE ProductID IN (
    SELECT ProductID FROM Demo_Retail_Product 
    WHERE Name LIKE '%Chocolate Gateaux%' AND SKU LIKE '%BC%'
)

PRINT ''
PRINT '=== DIAGNOSIS ==='
PRINT 'The POS is likely reading from one of these columns:'
PRINT '- Demo_Retail_Product.LastPaidPrice'
PRINT '- Demo_Retail_Product.AverageCost'
PRINT '- Demo_Retail_Stock.AverageCost'
PRINT '- Demo_Retail_Variant.Price'
PRINT ''
PRINT 'NOT from Demo_Retail_Price table!'
