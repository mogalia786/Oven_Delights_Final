-- Test script to verify LastPaidPrice is being updated correctly

-- 1. Check if LastPaidPrice and LastPurchaseDate columns exist
SELECT 
    COLUMN_NAME, 
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'RawMaterials' 
AND COLUMN_NAME IN ('LastPaidPrice', 'LastPurchaseDate')
GO

-- 2. Check current LastPaidPrice values for all materials
SELECT 
    MaterialID,
    MaterialCode,
    MaterialName,
    LastPaidPrice,
    LastPurchaseDate,
    LastCost,
    AverageCost
FROM RawMaterials
WHERE MaterialID IN (SELECT TOP 10 MaterialID FROM RawMaterials ORDER BY MaterialName)
ORDER BY MaterialName
GO

-- 3. Manually update a test material to verify the column works
-- UNCOMMENT AND MODIFY THE MaterialID to test:
-- UPDATE RawMaterials 
-- SET LastPaidPrice = 99.99, LastPurchaseDate = GETDATE() 
-- WHERE MaterialID = 1
-- GO

-- 4. Verify the update worked
-- SELECT MaterialID, MaterialCode, MaterialName, LastPaidPrice, LastPurchaseDate
-- FROM RawMaterials 
-- WHERE MaterialID = 1
-- GO
