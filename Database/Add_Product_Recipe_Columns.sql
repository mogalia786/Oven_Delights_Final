-- Add columns for Product Recipe and Image features
-- Run this script to add required columns to Products table

USE OvenDelightsERP;
GO

-- Add RecipeCreated column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'RecipeCreated')
BEGIN
    ALTER TABLE Products ADD RecipeCreated VARCHAR(10) DEFAULT 'No';
    PRINT 'Added RecipeCreated column';
END
ELSE
BEGIN
    PRINT 'RecipeCreated column already exists';
END
GO

-- Add RecipeMethod column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'RecipeMethod')
BEGIN
    ALTER TABLE Products ADD RecipeMethod TEXT NULL;
    PRINT 'Added RecipeMethod column';
END
ELSE
BEGIN
    PRINT 'RecipeMethod column already exists';
END
GO

-- Add ProductImage column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'ProductImage')
BEGIN
    ALTER TABLE Products ADD ProductImage VARBINARY(MAX) NULL;
    PRINT 'Added ProductImage column';
END
ELSE
BEGIN
    PRINT 'ProductImage column already exists';
END
GO

-- Update existing manufactured products to have RecipeCreated = 'No' if NULL
UPDATE Products 
SET RecipeCreated = 'No' 
WHERE ItemType = 'Manufactured' 
AND (RecipeCreated IS NULL OR RecipeCreated = '');
GO

PRINT 'Migration complete!';
GO
