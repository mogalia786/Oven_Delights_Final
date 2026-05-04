-- Check if CurrentStock has a default constraint
SELECT 
    c.name AS ColumnName,
    dc.name AS DefaultConstraintName,
    dc.definition AS DefaultValue
FROM sys.columns c
LEFT JOIN sys.default_constraints dc ON c.default_object_id = dc.object_id
WHERE c.object_id = OBJECT_ID('Demo_Retail_Product')
    AND c.name = 'CurrentStock';

-- Try inserting with DEFAULT keyword
BEGIN TRANSACTION
INSERT INTO Demo_Retail_Product (
    SKU, Name, Category, CategoryID, SubcategoryID,
    ProductType, BranchID, CurrentStock, IsActive,
    Description, CreatedAt, UpdatedAt, Is_VTable, IsVatable
)
VALUES (
    'TEST-DEFAULT',
    'TEST DEFAULT KEYWORD',
    'Test',
    22,
    0,
    'Internal',
    1,
    DEFAULT,
    1,
    '',
    GETDATE(),
    GETDATE(),
    0,
    1
);

SELECT * FROM Demo_Retail_Product WHERE Name = 'TEST DEFAULT KEYWORD';
ROLLBACK TRANSACTION;
