-- Check if CurrentStock is a computed column or has special constraints
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE,
    COLUMNPROPERTY(OBJECT_ID('Demo_Retail_Product'), COLUMN_NAME, 'IsComputed') AS IsComputed
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Retail_Product'
    AND COLUMN_NAME = 'CurrentStock';

-- Check for triggers on Demo_Retail_Product
SELECT 
    name AS TriggerName,
    OBJECT_NAME(parent_id) AS TableName,
    type_desc
FROM sys.triggers
WHERE parent_id = OBJECT_ID('Demo_Retail_Product');

-- Try a simple direct insert test
BEGIN TRANSACTION
INSERT INTO Demo_Retail_Product (
    SKU, Name, Category, CategoryID, SubcategoryID,
    ProductType, BranchID, CurrentStock, IsActive,
    Description, CreatedAt, UpdatedAt, Is_VTable, IsVatable
)
VALUES (
    'TEST-SKU-001',
    'DIRECT INSERT TEST',
    'Test Category',
    22,
    0,
    'Internal',
    1,
    CAST(0 AS DECIMAL(18,2)),
    1,
    '',
    GETDATE(),
    GETDATE(),
    0,
    1
);

SELECT 'Direct insert test result:' AS Info, * 
FROM Demo_Retail_Product 
WHERE Name = 'DIRECT INSERT TEST';

ROLLBACK TRANSACTION;
