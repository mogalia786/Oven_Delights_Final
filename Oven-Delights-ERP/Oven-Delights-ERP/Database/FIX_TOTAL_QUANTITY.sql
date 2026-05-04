-- Update TotalQuantity for ALL ReOrderBooks from their order lines
UPDATE rob
SET rob.TotalQuantity = ISNULL((
    SELECT SUM(rol.QuantityOrdered)
    FROM ReOrderBookLines rol
    WHERE rol.ReOrderBookID = rob.ReOrderBookID
), 0),
rob.TotalProducts = ISNULL((
    SELECT COUNT(*)
    FROM ReOrderBookLines rol
    WHERE rol.ReOrderBookID = rob.ReOrderBookID
), 0)
FROM ReOrderBooks rob
WHERE rob.TotalQuantity = 0 OR rob.TotalProducts = 0

-- Verify the fix
SELECT 
    rob.ReOrderBookID,
    rob.ReOrderNumber,
    rob.Status,
    rob.TotalProducts,
    rob.TotalQuantity,
    (SELECT SUM(rol.QuantityOrdered) FROM ReOrderBookLines rol WHERE rol.ReOrderBookID = rob.ReOrderBookID) AS CalculatedTotal
FROM ReOrderBooks rob
WHERE rob.ReOrderBookID IN (73, 81)
ORDER BY rob.ReOrderBookID
