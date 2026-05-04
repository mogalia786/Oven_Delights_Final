-- Add missing STOCKROOM locations for branches 4 and 6

-- Check current locations
SELECT LocationID, BranchID, LocationCode, LocationName 
FROM InventoryLocations 
WHERE LocationCode = 'STOCKROOM' 
ORDER BY BranchID;

-- Add STOCKROOM for Branch 4 (if not exists)
IF NOT EXISTS (SELECT 1 FROM InventoryLocations WHERE BranchID = 4 AND LocationCode = 'STOCKROOM')
BEGIN
    INSERT INTO InventoryLocations (BranchID, LocationCode, LocationName, IsActive, LocationType, CreatedDate)
    VALUES (4, 'STOCKROOM', 'Stockroom', 1, 'STOCKROOM', GETDATE());
    PRINT 'Added STOCKROOM for Branch 4';
END
ELSE
BEGIN
    PRINT 'STOCKROOM for Branch 4 already exists';
END

-- Add STOCKROOM for Branch 6 (if not exists)
IF NOT EXISTS (SELECT 1 FROM InventoryLocations WHERE BranchID = 6 AND LocationCode = 'STOCKROOM')
BEGIN
    INSERT INTO InventoryLocations (BranchID, LocationCode, LocationName, IsActive, LocationType, CreatedDate)
    VALUES (6, 'STOCKROOM', 'Stockroom', 1, 'STOCKROOM', GETDATE());
    PRINT 'Added STOCKROOM for Branch 6';
END
ELSE
BEGIN
    PRINT 'STOCKROOM for Branch 6 already exists';
END

-- Add MFG/MANUFACTURING for Branch 4 (if not exists)
IF NOT EXISTS (SELECT 1 FROM InventoryLocations WHERE BranchID = 4 AND LocationCode = 'MFG')
BEGIN
    INSERT INTO InventoryLocations (BranchID, LocationCode, LocationName, IsActive, LocationType, CreatedDate)
    VALUES (4, 'MFG', 'Manufacturing', 1, 'MANUFACTURING', GETDATE());
    PRINT 'Added MFG for Branch 4';
END

-- Add MFG/MANUFACTURING for Branch 6 (if not exists)
IF NOT EXISTS (SELECT 1 FROM InventoryLocations WHERE BranchID = 6 AND LocationCode = 'MFG')
BEGIN
    INSERT INTO InventoryLocations (BranchID, LocationCode, LocationName, IsActive, LocationType, CreatedDate)
    VALUES (6, 'MFG', 'Manufacturing', 1, 'MANUFACTURING', GETDATE());
    PRINT 'Added MFG for Branch 6';
END

-- Verify all branches now have STOCKROOM and MFG
SELECT BranchID, LocationCode, LocationName, IsActive 
FROM InventoryLocations 
WHERE LocationCode IN ('STOCKROOM', 'MFG')
ORDER BY BranchID, LocationCode;
