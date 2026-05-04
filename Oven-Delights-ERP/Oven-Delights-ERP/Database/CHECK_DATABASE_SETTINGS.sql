-- Check table creation settings
SELECT 
    OBJECT_NAME(object_id) AS TableName,
    uses_ansi_nulls AS UsesAnsiNulls
FROM sys.tables
WHERE name = 'SupplierInvoices';

-- Check if any indexes exist
SELECT 
    i.name AS IndexName,
    i.type_desc AS IndexType,
    i.is_unique AS IsUnique
FROM sys.indexes i
WHERE i.object_id = OBJECT_ID('SupplierInvoices');
