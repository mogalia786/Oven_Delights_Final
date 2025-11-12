-- Update all stock to have default quantity of 100
UPDATE Demo_Retail_Stock
SET QtyOnHand = 100,
    ReorderPoint = 10,
    UpdatedAt = GETDATE()
WHERE QtyOnHand = 0;

-- Check results
SELECT 
    BranchID,
    COUNT(*) AS StockRecords,
    AVG(QtyOnHand) AS AvgQty,
    MIN(QtyOnHand) AS MinQty,
    MAX(QtyOnHand) AS MaxQty
FROM Demo_Retail_Stock
GROUP BY BranchID;

PRINT 'Stock levels updated to 100 units per item';
