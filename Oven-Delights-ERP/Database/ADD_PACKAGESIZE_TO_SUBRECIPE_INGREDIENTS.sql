-- =============================================
-- Add PackageSize column to Demo_SubRecipe_Ingredients
-- This column is needed for proper cost calculations
-- =============================================

IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID('Demo_SubRecipe_Ingredients') 
    AND name = 'PackageSize'
)
BEGIN
    ALTER TABLE Demo_SubRecipe_Ingredients
    ADD PackageSize DECIMAL(18,4) NULL DEFAULT 1;
    
    PRINT '✓ Added PackageSize column to Demo_SubRecipe_Ingredients';
END
ELSE
BEGIN
    PRINT '⚠ PackageSize column already exists in Demo_SubRecipe_Ingredients';
END
GO

-- Update existing records to have PackageSize = 1 if NULL
UPDATE Demo_SubRecipe_Ingredients
SET PackageSize = 1
WHERE PackageSize IS NULL;

PRINT '✓ Updated existing records with default PackageSize = 1';
GO
