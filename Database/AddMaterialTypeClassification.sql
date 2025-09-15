-- Add Material Type classification to Stockroom_Product table
-- This allows differentiation between Raw Materials and Ready-Made Products

-- Add MaterialType field to Stockroom_Product table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Stockroom_Product' AND COLUMN_NAME = 'MaterialType')
BEGIN
    ALTER TABLE dbo.Stockroom_Product 
    ADD MaterialType NVARCHAR(20) NOT NULL DEFAULT 'Raw Material'
    
    PRINT 'Added MaterialType field to Stockroom_Product table'
END
ELSE
    PRINT 'MaterialType field already exists in Stockroom_Product table'
GO

-- Add check constraint to ensure valid material types
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_Stockroom_Product_MaterialType')
BEGIN
    ALTER TABLE dbo.Stockroom_Product
    ADD CONSTRAINT CK_Stockroom_Product_MaterialType 
    CHECK (MaterialType IN ('Raw Material', 'Ready-Made Product'))
    
    PRINT 'Added check constraint for MaterialType values'
END
ELSE
    PRINT 'MaterialType check constraint already exists'
GO

-- Add DestinationModule field to track where materials go
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Stockroom_Product' AND COLUMN_NAME = 'DestinationModule')
BEGIN
    ALTER TABLE dbo.Stockroom_Product 
    ADD DestinationModule NVARCHAR(20) NOT NULL DEFAULT 'Manufacturing'
    
    PRINT 'Added DestinationModule field to Stockroom_Product table'
END
ELSE
    PRINT 'DestinationModule field already exists in Stockroom_Product table'
GO

-- Add check constraint for destination modules
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_Stockroom_Product_DestinationModule')
BEGIN
    ALTER TABLE dbo.Stockroom_Product
    ADD CONSTRAINT CK_Stockroom_Product_DestinationModule 
    CHECK (DestinationModule IN ('Manufacturing', 'Retail', 'Both'))
    
    PRINT 'Added check constraint for DestinationModule values'
END
ELSE
    PRINT 'DestinationModule check constraint already exists'

PRINT 'Material Type classification system added to Stockroom_Product table!'
PRINT 'MaterialType options: Raw Material, Ready-Made Product'
PRINT 'DestinationModule options: Manufacturing, Retail, Both'
