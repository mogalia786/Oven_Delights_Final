-- Get the ACTUAL stored procedure definition from the database
SELECT OBJECT_DEFINITION(OBJECT_ID('sp_SaveProductToAllBranches')) AS StoredProcedureDefinition;
