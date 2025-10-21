-- Update ItemType constraint to allow 'internal' and 'external' values

-- First, drop the existing constraint if it exists
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_Products_ItemType')
BEGIN
    ALTER TABLE dbo.Products DROP CONSTRAINT CK_Products_ItemType;
    PRINT 'Dropped existing CK_Products_ItemType constraint';
END

-- Create new constraint that allows 'internal', 'external', and 'Manufactured' (for backward compatibility)
ALTER TABLE dbo.Products
ADD CONSTRAINT CK_Products_ItemType 
CHECK (ItemType IN ('internal', 'external', 'Manufactured'));

PRINT 'Created new CK_Products_ItemType constraint with values: internal, external, Manufactured';
GO

-- Optional: Update existing 'Manufactured' values to 'internal'
-- Uncomment the line below if you want to migrate existing data
-- UPDATE dbo.Products SET ItemType = 'internal' WHERE ItemType = 'Manufactured';
