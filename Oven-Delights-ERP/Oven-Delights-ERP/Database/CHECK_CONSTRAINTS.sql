-- Check for constraints on SupplierInvoices
SELECT 
    OBJECT_NAME(parent_object_id) AS TableName,
    name AS ConstraintName,
    type_desc AS ConstraintType,
    definition AS ConstraintDefinition
FROM sys.default_constraints
WHERE parent_object_id = OBJECT_ID('SupplierInvoices');

-- Check table metadata
SELECT 
    OBJECT_NAME(object_id) AS TableName,
    create_date AS CreatedDate,
    modify_date AS ModifiedDate
FROM sys.tables
WHERE name = 'SupplierInvoices';
