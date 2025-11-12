-- Fix the foreign key constraint on ReOrderBookLines to point to Demo_Retail_Product

-- Step 1: Check current foreign key
SELECT 
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS TableName,
    COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ColumnName,
    OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable,
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS ReferencedColumn
FROM sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fc ON fk.object_id = fc.constraint_object_id
WHERE fk.name LIKE '%ReOrderBookLines%Product%'
ORDER BY TableName;

-- Step 2: Drop the old foreign key
DECLARE @FKName NVARCHAR(255);
SELECT @FKName = fk.name
FROM sys.foreign_keys AS fk
WHERE fk.parent_object_id = OBJECT_ID('ReOrderBookLines')
AND fk.name LIKE '%Product%';

IF @FKName IS NOT NULL
BEGIN
    DECLARE @DropSQL NVARCHAR(500) = 'ALTER TABLE ReOrderBookLines DROP CONSTRAINT ' + @FKName;
    EXEC sp_executesql @DropSQL;
    PRINT 'Dropped foreign key: ' + @FKName;
END

-- Step 3: Check for orphaned records (ProductIDs that don't exist in Demo_Retail_Product)
SELECT 
    rol.ReOrderLineID,
    rol.ProductID,
    rol.ProductName
FROM ReOrderBookLines rol
WHERE rol.ProductID IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM Demo_Retail_Product p WHERE p.ProductID = rol.ProductID);

-- Step 4: Option 1 - Delete orphaned records (RECOMMENDED)
-- Uncomment the next line if you want to delete orphaned records
-- DELETE FROM ReOrderBookLines WHERE ProductID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Demo_Retail_Product p WHERE p.ProductID = ReOrderBookLines.ProductID);

-- Step 5: Option 2 - Create FK with NOCHECK (allows existing bad data but validates new inserts)
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys 
    WHERE name = 'FK_ReOrderBookLines_Demo_Retail_Product'
)
BEGIN
    ALTER TABLE ReOrderBookLines WITH NOCHECK
    ADD CONSTRAINT FK_ReOrderBookLines_Demo_Retail_Product
    FOREIGN KEY (ProductID) REFERENCES Demo_Retail_Product(ProductID);
    
    PRINT 'Created new foreign key with NOCHECK: FK_ReOrderBookLines_Demo_Retail_Product';
    PRINT 'WARNING: Existing orphaned records remain. New inserts will be validated.';
END
ELSE
BEGIN
    PRINT 'Foreign key FK_ReOrderBookLines_Demo_Retail_Product already exists';
END

-- Verify the change
SELECT 
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS TableName,
    COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ColumnName,
    OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable,
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS ReferencedColumn
FROM sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fc ON fk.object_id = fc.constraint_object_id
WHERE OBJECT_NAME(fk.parent_object_id) = 'ReOrderBookLines'
AND COL_NAME(fc.parent_object_id, fc.parent_column_id) = 'ProductID';
