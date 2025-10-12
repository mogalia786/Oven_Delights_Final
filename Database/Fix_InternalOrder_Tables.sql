-- Fix InternalOrder tables for BOM fulfillment

-- 1. Add BranchID to InternalOrderHeader
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.InternalOrderHeader') AND name = 'BranchID')
BEGIN
    ALTER TABLE dbo.InternalOrderHeader
    ADD BranchID INT NULL;
    
    PRINT 'Added BranchID to InternalOrderHeader';
END
ELSE
    PRINT 'InternalOrderHeader.BranchID already exists';
GO

-- Update existing records with default branch (separate batch)
UPDATE dbo.InternalOrderHeader
SET BranchID = 1
WHERE BranchID IS NULL;
PRINT 'Updated existing InternalOrderHeader records with default BranchID';
GO

-- 2. Add MaterialID to InternalOrderLines (computed from RawMaterialID)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.InternalOrderLines') AND name = 'MaterialID')
BEGIN
    ALTER TABLE dbo.InternalOrderLines
    ADD MaterialID AS (RawMaterialID) PERSISTED;
    
    PRINT 'Added MaterialID computed column to InternalOrderLines';
END
ELSE
    PRINT 'InternalOrderLines.MaterialID already exists';
GO

PRINT 'InternalOrder tables are ready for BOM fulfillment';
