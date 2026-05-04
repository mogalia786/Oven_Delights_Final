-- Check all foreign key constraints referencing SupplierPayments
SELECT 
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS ReferencingTable,
    OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable
FROM sys.foreign_keys fk
WHERE OBJECT_NAME(fk.referenced_object_id) IN ('SupplierPayments', 'SupplierInvoices')
ORDER BY ReferencedTable, ReferencingTable;
