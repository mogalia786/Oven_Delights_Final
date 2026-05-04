-- Check for triggers on SupplierInvoices and drop them
SELECT 
    name AS TriggerName,
    is_disabled AS IsDisabled,
    OBJECT_DEFINITION(object_id) AS TriggerDefinition
FROM sys.triggers
WHERE parent_id = OBJECT_ID('SupplierInvoices');

-- Drop any triggers on SupplierInvoices
DECLARE @sql NVARCHAR(MAX) = '';
SELECT @sql += 'DROP TRIGGER IF EXISTS ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.triggers
WHERE parent_id = OBJECT_ID('SupplierInvoices');

IF @sql <> ''
BEGIN
    EXEC sp_executesql @sql;
    PRINT 'Dropped all triggers on SupplierInvoices';
END
ELSE
BEGIN
    PRINT 'No triggers found on SupplierInvoices';
END
