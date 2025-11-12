-- Add RecipeMethod column to Products table to store recipe instructions

IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Products' 
    AND COLUMN_NAME = 'RecipeMethod'
)
BEGIN
    ALTER TABLE dbo.Products
    ADD RecipeMethod NVARCHAR(MAX) NULL;
    
    PRINT 'RecipeMethod column added to Products table';
END
ELSE
BEGIN
    PRINT 'RecipeMethod column already exists in Products table';
END
GO
