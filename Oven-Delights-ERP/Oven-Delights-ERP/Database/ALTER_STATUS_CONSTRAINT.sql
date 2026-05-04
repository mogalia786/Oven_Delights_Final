-- Add new constraint with more statuses (no existing constraint to drop)
ALTER TABLE ReOrderBooks
ADD CONSTRAINT CHK_ReOrderBooks_Status 
CHECK ([Status] IN ('Pending', 'Posted', 'BOM Fulfilled', 'In Production', 'Completed', 'Cancelled'))
