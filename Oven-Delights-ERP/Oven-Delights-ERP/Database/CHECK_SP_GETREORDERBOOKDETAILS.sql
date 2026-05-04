-- Check what sp_GetReOrderBookDetails returns for order 70
EXEC sp_GetReOrderBookDetails @ReOrderBookID = 70

-- Also check the actual status in the table
SELECT ReOrderBookID, ReOrderNumber, Status, TotalQuantity
FROM ReOrderBooks
WHERE ReOrderBookID = 70
