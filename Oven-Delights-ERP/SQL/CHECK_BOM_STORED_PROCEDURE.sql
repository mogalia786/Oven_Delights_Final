-- Check the stored procedure that creates BOM bundles
-- This is CRITICAL for showing all raw materials and sub-assemblies

-- First, check if the stored procedure exists
SELECT 
    OBJECT_NAME(object_id) AS ProcedureName,
    create_date,
    modify_date
FROM sys.procedures
WHERE name = 'sp_MO_CreateBundleFromBOM';

-- Get the stored procedure definition
EXEC sp_helptext 'sp_MO_CreateBundleFromBOM';
