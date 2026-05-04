-- First, set a default value for IsReversed column
ALTER TABLE SupplierLedger 
DROP CONSTRAINT IF EXISTS DF_SupplierLedger_IsReversed;

ALTER TABLE SupplierLedger 
ADD CONSTRAINT DF_SupplierLedger_IsReversed DEFAULT (0) FOR IsReversed;

PRINT 'Added default constraint for IsReversed column';

-- Now get the definitions of the stored procedures to fix them
SELECT 
    OBJECT_NAME(object_id) AS ProcedureName,
    OBJECT_DEFINITION(object_id) AS Definition
FROM sys.objects
WHERE type = 'P'
    AND OBJECT_NAME(object_id) IN ('sp_PostSupplierLedger', 'sp_Bank_Statement_PostToGL');
