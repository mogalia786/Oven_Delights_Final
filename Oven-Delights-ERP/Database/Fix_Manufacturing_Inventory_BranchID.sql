-- Add BranchID to Manufacturing_Inventory table if missing
-- This fixes the BOM fulfillment error

IF OBJECT_ID('dbo.Manufacturing_Inventory','U') IS NULL
BEGIN
    -- Create table if it doesn't exist
    CREATE TABLE dbo.Manufacturing_Inventory (
        ManufacturingInventoryID INT IDENTITY(1,1) PRIMARY KEY,
        MaterialID INT NOT NULL,
        BranchID INT NOT NULL,
        QtyOnHand DECIMAL(18,4) NOT NULL DEFAULT 0,
        AverageCost DECIMAL(18,4) NOT NULL DEFAULT 0,
        LastUpdated DATETIME NOT NULL DEFAULT GETDATE(),
        UpdatedBy INT NULL
    );
    PRINT 'Created Manufacturing_Inventory table with BranchID';
END
ELSE
BEGIN
    -- Check if BranchID exists
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Manufacturing_Inventory') AND name = 'BranchID')
    BEGIN
        ALTER TABLE dbo.Manufacturing_Inventory
        ADD BranchID INT NOT NULL DEFAULT 1;
        
        PRINT 'Added BranchID column to Manufacturing_Inventory';
    END
    ELSE
    BEGIN
        PRINT 'BranchID column already exists in Manufacturing_Inventory';
    END
END
GO

PRINT 'Manufacturing_Inventory table is ready';
GO
