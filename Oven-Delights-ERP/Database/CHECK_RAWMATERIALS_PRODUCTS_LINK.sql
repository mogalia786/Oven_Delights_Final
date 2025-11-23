-- Check if RawMaterials has ProductID column
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'RawMaterials'
ORDER BY ORDINAL_POSITION

-- Check sample data
SELECT TOP 5 MaterialID, MaterialName, ProductID
FROM RawMaterials

-- Check if Products table has materials
SELECT TOP 5 ProductID, ProductName, ItemType
FROM Products
WHERE ItemType = 'RawMaterial'
