-- =============================================
-- FIX INVENTORY LOCATIONS TABLE
-- =============================================

-- Check if LocationType column exists, if not add it
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('InventoryLocations') AND name = 'LocationType')
BEGIN
    ALTER TABLE InventoryLocations
    ADD LocationType NVARCHAR(20) NOT NULL DEFAULT 'STOCKROOM';
    
    PRINT '✅ LocationType column added to InventoryLocations';
END
ELSE
    PRINT '⚠️ LocationType column already exists';
GO

-- Update existing locations with proper types
UPDATE InventoryLocations
SET LocationType = CASE 
    WHEN LocationCode LIKE '%STOCK%' THEN 'STOCKROOM'
    WHEN LocationCode LIKE '%MFG%' OR LocationCode LIKE '%MANUF%' THEN 'MANUFACTURING'
    WHEN LocationCode LIKE '%RETAIL%' THEN 'RETAIL'
    ELSE 'STOCKROOM'
END
WHERE LocationType IS NULL OR LocationType = '';
GO

-- Ensure default locations exist
IF NOT EXISTS (SELECT * FROM InventoryLocations WHERE LocationCode = 'STOCKROOM')
BEGIN
    INSERT INTO InventoryLocations (LocationCode, LocationName, LocationType, BranchID)
    SELECT 'STOCKROOM', 'Stockroom', 'STOCKROOM', BranchID FROM Branches WHERE BranchID = 1;
    PRINT '✅ STOCKROOM location created';
END

IF NOT EXISTS (SELECT * FROM InventoryLocations WHERE LocationCode = 'MANUFACTURING')
BEGIN
    INSERT INTO InventoryLocations (LocationCode, LocationName, LocationType, BranchID)
    SELECT 'MANUFACTURING', 'Manufacturing', 'MANUFACTURING', BranchID FROM Branches WHERE BranchID = 1;
    PRINT '✅ MANUFACTURING location created';
END

IF NOT EXISTS (SELECT * FROM InventoryLocations WHERE LocationCode = 'RETAIL')
BEGIN
    INSERT INTO InventoryLocations (LocationCode, LocationName, LocationType, BranchID)
    SELECT 'RETAIL', 'Retail Floor', 'RETAIL', BranchID FROM Branches WHERE BranchID = 1;
    PRINT '✅ RETAIL location created';
END
GO

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ INVENTORY LOCATIONS FIXED!';
PRINT '═══════════════════════════════════════════════';

-- Show current locations
SELECT LocationID, LocationCode, LocationName, LocationType, BranchID, IsActive
FROM InventoryLocations
ORDER BY LocationID;
