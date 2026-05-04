-- Check total products
SELECT COUNT(*) AS TotalProducts FROM Demo_Retail_Product;

-- Check by BranchID
SELECT BranchID, COUNT(*) AS ProductCount
FROM Demo_Retail_Product
GROUP BY BranchID
ORDER BY BranchID;

-- Check if products were deleted
SELECT 
    'Expected from import' AS Source,
    2597 AS Count
UNION ALL
SELECT 
    'Actually in database' AS Source,
    COUNT(*) AS Count
FROM Demo_Retail_Product;

-- Check if there's a stored procedure that initializes data
SELECT 
    ROUTINE_NAME,
    ROUTINE_TYPE,
    ROUTINE_DEFINITION
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_NAME LIKE '%Init%' 
   OR ROUTINE_NAME LIKE '%Seed%'
   OR ROUTINE_NAME LIKE '%Setup%'
   OR ROUTINE_DEFINITION LIKE '%Demo_Retail_Product%';
