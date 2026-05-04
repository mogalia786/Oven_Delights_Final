-- =============================================
-- Add ItemType column to ReOrderBookLines table
-- To distinguish between Product and SubRecipe requests
-- =============================================

-- Check if column exists, if not add it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.columns 
    WHERE object_id = OBJECT_ID('ReOrderBookLines') 
    AND name = 'ItemType'
)
BEGIN
    ALTER TABLE ReOrderBookLines
    ADD ItemType NVARCHAR(20) NULL DEFAULT 'Product'
    
    PRINT 'ItemType column added to ReOrderBookLines table'
END
ELSE
BEGIN
    PRINT 'ItemType column already exists in ReOrderBookLines table'
END
GO

-- Update existing records to have ItemType = 'Product'
UPDATE ReOrderBookLines
SET ItemType = 'Product'
WHERE ItemType IS NULL
GO

-- Make column NOT NULL after updating existing records
ALTER TABLE ReOrderBookLines
ALTER COLUMN ItemType NVARCHAR(20) NOT NULL
GO

PRINT 'ReOrderBookLines table updated successfully'
GO
