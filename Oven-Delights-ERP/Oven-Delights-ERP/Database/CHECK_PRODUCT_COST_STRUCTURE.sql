-- Check how product costs are stored

-- Check Demo_Product_Recipe_Master structure
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Product_Recipe_Master'
ORDER BY ORDINAL_POSITION;

-- Check actual data to see what's stored
SELECT TOP 5 
    ProductID,
    TotalCost,
    BatchQty,
    TotalCost / NULLIF(BatchQty, 0) AS CostPerUnit
FROM Demo_Product_Recipe_Master
WHERE TotalCost > 0;

-- Check Demo_Retail_Product to see if adhoc cost is stored there
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Retail_Product'
AND COLUMN_NAME LIKE '%cost%'
ORDER BY ORDINAL_POSITION;

-- Check actual retail product costs
SELECT TOP 5
    ProductID,
    AverageCost,
    LastPaidPrice
FROM Demo_Retail_Product
WHERE ProductID IN (SELECT ProductID FROM Demo_Product_Recipe_Master)
AND BranchID = 6;
