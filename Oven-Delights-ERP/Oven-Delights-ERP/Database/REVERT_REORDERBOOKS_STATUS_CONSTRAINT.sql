-- Revert ReOrderBooks Status CHECK constraint back to original values



PRINT 'Reverting ReOrderBooks Status CHECK constraint to original...'
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
    PRINT 'Dropping constraint: ' + @ConstraintName
    DECLARE @SQL NVARCHAR(500)
    SET @SQL = 'ALTER TABLE ReOrderBooks DROP CONSTRAINT ' + @ConstraintName
    EXEC sp_executesql @SQL
    PRINT '✓ Constraint dropped'
END

-- Update any 'Draft' or 'Cancelled' status to 'Pending'
UPDATE ReOrderBooks
SET Status = 'Pending'
WHERE Status IN ('Draft', 'Cancelled')

PRINT '✓ Updated invalid Status values to Pending'

-- Restore original CHECK constraint
ALTER TABLE ReOrderBooks 
ADD CONSTRAINT CK_ReOrderBooks_Status 
CHECK (Status IN ('Posted', 'Pending', 'Completed'))

PRINT '✓ Original Status constraint restored (allows: Posted, Pending, Completed)'
PRINT ''
PRINT '========================================='
PRINT '✓ Status constraint reverted successfully!'
PRINT '========================================='
GO
