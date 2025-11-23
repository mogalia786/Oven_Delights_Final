-- Restore Posted status for orders that have BOM requisitions
UPDATE rob
SET rob.Status = 'Posted'
FROM ReOrderBooks rob
INNER JOIN BOMRequisitionFulfillment brf ON rob.ReOrderBookID = brf.ReOrderBookID
WHERE rob.Status = 'Pending'
  AND brf.FulfilledDate IS NULL

-- Verify
SELECT 
    rob.ReOrderBookID,
    rob.ReOrderNumber,
    rob.Status,
    COUNT(brf.FulfillmentID) AS BOMItems,
    SUM(CASE WHEN brf.FulfilledDate IS NULL THEN 1 ELSE 0 END) AS UnfulfilledItems
FROM ReOrderBooks rob
LEFT JOIN BOMRequisitionFulfillment brf ON rob.ReOrderBookID = brf.ReOrderBookID
WHERE rob.ReOrderBookID IN (73, 81)
GROUP BY rob.ReOrderBookID, rob.ReOrderNumber, rob.Status
