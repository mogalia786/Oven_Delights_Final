-- Check for ALL triggers on SupplierInvoices with full definition
SELECT 
    t.name AS TriggerName,
    t.is_disabled AS IsDisabled,
    t.is_instead_of_trigger AS IsInsteadOf,
    OBJECT_DEFINITION(t.object_id) AS TriggerDefinition
FROM sys.triggers t
WHERE t.parent_id = OBJECT_ID('SupplierInvoices');

-- Also check for triggers on StockMovements
SELECT 
    t.name AS TriggerName,
    t.is_disabled AS IsDisabled,
    t.is_instead_of_trigger AS IsInsteadOf,
    OBJECT_DEFINITION(t.object_id) AS TriggerDefinition
FROM sys.triggers t
WHERE t.parent_id = OBJECT_ID('StockMovements');

-- Check for triggers on GoodsReceivedNotes
SELECT 
    t.name AS TriggerName,
    t.is_disabled AS IsDisabled,
    t.is_instead_of_trigger AS IsInsteadOf,
    OBJECT_DEFINITION(t.object_id) AS TriggerDefinition
FROM sys.triggers t
WHERE t.parent_id = OBJECT_ID('GoodsReceivedNotes');
