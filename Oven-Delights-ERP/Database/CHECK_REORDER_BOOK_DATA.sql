-- Check re-order book data for ReOrderBookID 80
SELECT 
    rob.ReOrderBookID,
    rob.Status,
    rob.FulfilledDate,
    rob.FulfilledBy,
    rob.TotalProducts,
    rob.TotalQuantity
FROM ReOrderBooks rob
WHERE rob.ReOrderBookID = 80

-- Check re-order book lines
SELECT 
    rol.LineNumber,
    rol.ProductName,
    rol.QuantityOrdered,
    rol.LineStatus
FROM ReOrderBookLines rol
WHERE rol.ReOrderBookID = 80
ORDER BY rol.LineNumber

-- Check BOM requisition fulfillment
SELECT 
    f.IngredientName,
    f.QuantityRequired,
    f.QuantityFulfilled,
    f.FulfilledDate,
    f.FulfilledBy
FROM BOMRequisitionFulfillment f
WHERE f.ReOrderBookID = 80
ORDER BY f.IngredientName
