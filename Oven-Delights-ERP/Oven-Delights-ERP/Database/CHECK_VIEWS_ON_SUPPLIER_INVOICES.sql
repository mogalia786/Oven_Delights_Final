-- Check for views that reference SupplierInvoices
SELECT 
    v.name AS ViewName,
    m.definition AS ViewDefinition
FROM sys.views v
INNER JOIN sys.sql_modules m ON v.object_id = m.object_id
WHERE m.definition LIKE '%SupplierInvoices%'
ORDER BY v.name;

-- Check for indexed views specifically
SELECT 
    OBJECT_NAME(i.object_id) AS ViewName,
    i.name AS IndexName,
    i.type_desc AS IndexType
FROM sys.indexes i
INNER JOIN sys.views v ON i.object_id = v.object_id
WHERE EXISTS (
    SELECT 1 FROM sys.sql_modules m 
    WHERE m.object_id = v.object_id 
    AND m.definition LIKE '%SupplierInvoices%'
);
