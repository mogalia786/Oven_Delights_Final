-- Fix ReOrderBooks Status CHECK constraint to allow 'Draft', 'Posted', 'Pending', 'Completed'

USE OvenDelightsERP
GO

PRINT 'Fixing ReOrderBooks Status CHECK constraint...'
GO

-- Find and drop existing CHECK constraint on Status column
DECLARE @ConstraintName NVARCHAR(200)

SELECT @ConstraintName = name 
FROM sys.check_constraints 
WHERE parent_object_id = OBJECT_ID('ReOrderBooks') 
  AND OBJECT_NAME(parent_object_id) = 'ReOrderBooks'
  AND definition LIKE '%Status%'

IF @ConstraintName IS NOT NULL
BEGIN
    PRINT 'Dropping existing constraint: ' + @ConstraintName
    DECLARE @SQL NVARCHAR(500)
    SET @SQL = 'ALTER TABLE ReOrderBooks DROP CONSTRAINT ' + @ConstraintName
    EXEC sp_executesql @SQL
    PRINT '✓ Old constraint dropped'
END

-- Check and update existing Status values that don't match the new constraint
PRINT 'Checking existing Status values...'

-- Show current status values
SELECT DISTINCT Status, COUNT(*) AS RecordCount
FROM ReOrderBooks
GROUP BY Status

-- Update any invalid status values to 'Draft'
UPDATE ReOrderBooks
SET Status = 'Draft'
WHERE Status NOT IN ('Draft', 'Posted', 'Pending', 'Completed', 'Cancelled')

PRINT '✓ Updated invalid Status values to Draft'

-- Add new CHECK constraint that allows Draft, Posted, Pending, Completed
ALTER TABLE ReOrderBooks 
ADD CONSTRAINT CK_ReOrderBooks_Status 
CHECK (Status IN ('Draft', 'Posted', 'Pending', 'Completed', 'Cancelled'))

PRINT '✓ New Status constraint added (allows: Draft, Posted, Pending, Completed, Cancelled)'
PRINT ''
PRINT '========================================='
PRINT '✓ Status constraint updated successfully!'
PRINT '========================================='
GO
