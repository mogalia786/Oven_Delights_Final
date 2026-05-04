-- Check QUOTED_IDENTIFIER setting for ALL objects in the transaction chain
-- SupplierInvoices table
SELECT 
    'SupplierInvoices' AS ObjectName,
    'Table' AS ObjectType,
    uses_quoted_identifier AS UsesQuotedIdentifier
FROM sys.sql_modules
WHERE object_id = OBJECT_ID('SupplierInvoices');

-- Check all constraints on SupplierInvoices
SELECT 
    'SupplierInvoices - ' + name AS ObjectName,
    'Constraint' AS ObjectType,
    uses_quoted_identifier AS UsesQuotedIdentifier
FROM sys.sql_modules m
INNER JOIN sys.default_constraints dc ON m.object_id = dc.object_id
WHERE dc.parent_object_id = OBJECT_ID('SupplierInvoices');

-- Check StockMovements
SELECT 
    'StockMovements - ' + name AS ObjectName,
    'Constraint' AS ObjectType,
    uses_quoted_identifier AS UsesQuotedIdentifier
FROM sys.sql_modules m
INNER JOIN sys.default_constraints dc ON m.object_id = dc.object_id
WHERE dc.parent_object_id = OBJECT_ID('StockMovements');

-- Check GoodsReceivedNotes
SELECT 
    'GoodsReceivedNotes - ' + name AS ObjectName,
    'Constraint' AS ObjectType,
    uses_quoted_identifier AS UsesQuotedIdentifier
FROM sys.sql_modules m
INNER JOIN sys.default_constraints dc ON m.object_id = dc.object_id
WHERE dc.parent_object_id = OBJECT_ID('GoodsReceivedNotes');

-- Check SupplierLedger
SELECT 
    'SupplierLedger - ' + name AS ObjectName,
    'Constraint' AS ObjectType,
    uses_quoted_identifier AS UsesQuotedIdentifier
FROM sys.sql_modules m
INNER JOIN sys.default_constraints dc ON m.object_id = dc.object_id
WHERE dc.parent_object_id = OBJECT_ID('SupplierLedger');

-- Check GeneralLedger
SELECT 
    'GeneralLedger - ' + name AS ObjectName,
    'Constraint' AS ObjectType,
    uses_quoted_identifier AS UsesQuotedIdentifier
FROM sys.sql_modules m
INNER JOIN sys.default_constraints dc ON m.object_id = dc.object_id
WHERE dc.parent_object_id = OBJECT_ID('GeneralLedger');

-- Check all indexes on these tables
SELECT 
    OBJECT_NAME(object_id) AS TableName,
    name AS IndexName,
    uses_quoted_identifier AS UsesQuotedIdentifier
FROM sys.sql_modules m
WHERE object_id IN (
    OBJECT_ID('SupplierInvoices'),
    OBJECT_ID('StockMovements'),
    OBJECT_ID('GoodsReceivedNotes'),
    OBJECT_ID('SupplierLedger'),
    OBJECT_ID('GeneralLedger')
);
