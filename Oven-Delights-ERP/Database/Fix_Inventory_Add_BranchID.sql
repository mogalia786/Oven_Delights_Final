-- Add BranchID to Inventory table
-- This fixes the BOM fulfillment error: "Invalid column name 'BranchID'"

IF OBJECT_ID('dbo.Inventory','U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Inventory') AND name = 'BranchID')
    BEGIN
        ALTER TABLE dbo.Inventory
        ADD BranchID INT NOT NULL DEFAULT 1;
        
        PRINT 'Added BranchID column to Inventory table';
    END
    ELSE
    BEGIN
        PRINT 'BranchID column already exists in Inventory table';
    END
END
ELSE
BEGIN
    PRINT 'Inventory table does not exist';
END
GO

PRINT 'Inventory table is ready for BOM fulfillment';
GO
