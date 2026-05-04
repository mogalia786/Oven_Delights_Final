-- Check for indexed views
SELECT 
    OBJECT_SCHEMA_NAME(v.object_id) AS SchemaName,
    v.name AS ViewName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    m.uses_quoted_identifier AS UsesQuotedIdentifier
FROM sys.views v
INNER JOIN sys.indexes i ON v.object_id = i.object_id
LEFT JOIN sys.sql_modules m ON v.object_id = m.object_id
WHERE i.type > 0  -- Clustered or nonclustered indexes
ORDER BY v.name;

-- Check for filtered indexes on transaction tables
SELECT 
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    i.filter_definition AS FilterDefinition,
    i.has_filter AS HasFilter
FROM sys.indexes i
WHERE i.object_id IN (
    OBJECT_ID('SupplierInvoices'),
    OBJECT_ID('SupplierInvoiceLines'),
    OBJECT_ID('StockMovements'),
    OBJECT_ID('GoodsReceivedNotes'),
    OBJECT_ID('GoodsReceivedNoteLines'),
    OBJECT_ID('SupplierLedger'),
    OBJECT_ID('GeneralLedger'),
    OBJECT_ID('Demo_Retail_Product'),
    OBJECT_ID('Demo_Retail_Price')
)
AND (i.has_filter = 1 OR i.type > 0)
ORDER BY OBJECT_NAME(i.object_id), i.name;

-- Check for computed columns on transaction tables
SELECT 
    OBJECT_NAME(c.object_id) AS TableName,
    c.name AS ColumnName,
    c.is_computed AS IsComputed,
    cc.definition AS ComputedDefinition,
    cc.is_persisted AS IsPersisted
FROM sys.columns c
LEFT JOIN sys.computed_columns cc ON c.object_id = cc.object_id AND c.column_id = cc.column_id
WHERE c.object_id IN (
    OBJECT_ID('SupplierInvoices'),
    OBJECT_ID('SupplierInvoiceLines'),
    OBJECT_ID('StockMovements'),
    OBJECT_ID('GoodsReceivedNotes'),
    OBJECT_ID('GoodsReceivedNoteLines'),
    OBJECT_ID('SupplierLedger'),
    OBJECT_ID('GeneralLedger'),
    OBJECT_ID('Demo_Retail_Product'),
    OBJECT_ID('Demo_Retail_Price')
)
AND c.is_computed = 1
ORDER BY OBJECT_NAME(c.object_id), c.name;
