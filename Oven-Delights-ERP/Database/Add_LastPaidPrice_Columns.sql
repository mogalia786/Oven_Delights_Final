-- Add LastPaidPrice and LastPurchaseDate columns to RawMaterials table
-- This allows tracking of the last price paid for each raw material

USE [OvenDelightsERP]
GO

-- Add LastPaidPrice column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.RawMaterials') AND name = 'LastPaidPrice')
BEGIN
    ALTER TABLE dbo.RawMaterials
    ADD LastPaidPrice DECIMAL(18,4) NULL;
    PRINT 'Added LastPaidPrice column to RawMaterials table';
END
ELSE
BEGIN
    PRINT 'LastPaidPrice column already exists in RawMaterials table';
END
GO

-- Add LastPurchaseDate column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.RawMaterials') AND name = 'LastPurchaseDate')
BEGIN
    ALTER TABLE dbo.RawMaterials
    ADD LastPurchaseDate DATETIME NULL;
    PRINT 'Added LastPurchaseDate column to RawMaterials table';
END
ELSE
BEGIN
    PRINT 'LastPurchaseDate column already exists in RawMaterials table';
END
GO

PRINT 'Schema update completed successfully!';
PRINT 'The LastPaidPrice feature is now ready to use.';
GO
