-- Check sp_RecordProductPriceFromInvoice stored procedure definition
SELECT OBJECT_DEFINITION(OBJECT_ID('sp_RecordProductPriceFromInvoice')) AS ProcedureDefinition;

-- Check for any stored procedures that reference SupplierLedger
SELECT 
    OBJECT_NAME(object_id) AS ProcedureName,
    OBJECT_DEFINITION(object_id) AS Definition
FROM sys.objects
WHERE type = 'P'
    AND OBJECT_DEFINITION(object_id) LIKE '%SupplierLedger%'
ORDER BY name;
