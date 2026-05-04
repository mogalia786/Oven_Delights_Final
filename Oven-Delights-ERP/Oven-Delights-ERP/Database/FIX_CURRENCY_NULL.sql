-- Fix Currency NULL error when completing manufacturing
-- Set default Currency to 'R' (South African Rand symbol) for all Demo_Retail_Price records

-- Update existing NULL Currency values
UPDATE Demo_Retail_Price
SET Currency = 'R'
WHERE Currency IS NULL;

-- Verify the update
SELECT COUNT(*) AS UpdatedRecords
FROM Demo_Retail_Price
WHERE Currency = 'R';

PRINT 'Updated Currency to R for all NULL records in Demo_Retail_Price';

-- Add default constraint if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.default_constraints WHERE parent_object_id = OBJECT_ID('Demo_Retail_Price') AND COL_NAME(parent_object_id, parent_column_id) = 'Currency')
BEGIN
    ALTER TABLE Demo_Retail_Price ADD CONSTRAINT DF_Demo_Retail_Price_Currency DEFAULT 'R' FOR Currency;
    PRINT 'Added default constraint for Currency column';
END
ELSE
BEGIN
    PRINT 'Currency default constraint already exists';
END
GO
