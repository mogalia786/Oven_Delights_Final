-- Check the latest re-order book and its BOM items
SELECT TOP 1 
    rob.ReOrderBookID,
    rob.ReOrderNumber,
    rob.Status,
    rob.TotalProducts,
    rob.TotalQuantity,
    rob.FulfilledDate,
    rob.FulfilledBy
FROM ReOrderBooks rob
ORDER BY rob.ReOrderBookID DESC

-- Get the ReOrderBookID from above and check BOM items
DECLARE @ReOrderBookID INT = (SELECT TOP 1 ReOrderBookID FROM ReOrderBooks ORDER BY ReOrderBookID DESC)

SELECT 
    FulfillmentID,
    IngredientName,
    QuantityRequired,
    QuantityFulfilled,
    FulfilledDate,
    FulfilledBy,
    CASE WHEN FulfilledDate IS NULL THEN 'NOT FULFILLED' ELSE 'FULFILLED' END AS Status
FROM BOMRequisitionFulfillment
WHERE ReOrderBookID = @ReOrderBookID
ORDER BY IngredientName

-- Count fulfilled vs unfulfilled
SELECT 
    COUNT(*) AS TotalItems,
    SUM(CASE WHEN FulfilledDate IS NULL THEN 1 ELSE 0 END) AS UnfulfilledItems,
    SUM(CASE WHEN FulfilledDate IS NOT NULL THEN 1 ELSE 0 END) AS FulfilledItems
FROM BOMRequisitionFulfillment
WHERE ReOrderBookID = @ReOrderBookID
