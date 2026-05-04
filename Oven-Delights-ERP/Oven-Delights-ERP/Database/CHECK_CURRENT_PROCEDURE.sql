-- Check which version of sp_CompleteReOrderProduct is deployed
SELECT 
    OBJECT_DEFINITION(OBJECT_ID('sp_CompleteReOrderProduct')) AS ProcedureDefinition
