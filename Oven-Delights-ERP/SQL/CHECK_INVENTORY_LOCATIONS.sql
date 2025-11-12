-- Check what inventory locations exist
SELECT * FROM InventoryLocations ORDER BY LocationCode;

-- Check if STOCKROOM and MFG exist
SELECT LocationCode, LocationName, IsActive 
FROM InventoryLocations 
WHERE LocationCode IN ('STOCKROOM', 'MFG', 'Stockroom', 'Manufacturing');
