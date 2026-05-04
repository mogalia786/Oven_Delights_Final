-- Check current BranchID distribution
SELECT BranchID, COUNT(*) AS ProductCount
FROM Demo_Retail_Product
GROUP BY BranchID;

-- Fix BranchID based on product Code prefix
-- AC prefix = BranchID 6 (OD200)
-- UM prefix = BranchID 4 (OD400)

UPDATE Demo_Retail_Product
SET BranchID = CASE 
    WHEN Code LIKE 'AC%' THEN 6
    WHEN Code LIKE 'UM%' THEN 4
    ELSE BranchID
END;

-- Verify the fix
SELECT BranchID, COUNT(*) AS ProductCount
FROM Demo_Retail_Product
GROUP BY BranchID
ORDER BY BranchID;

-- Show sample products
SELECT TOP 10 Code, Name, BranchID 
FROM Demo_Retail_Product 
WHERE Code LIKE 'AC%'
ORDER BY Code;

SELECT TOP 10 Code, Name, BranchID 
FROM Demo_Retail_Product 
WHERE Code LIKE 'UM%'
ORDER BY Code;

PRINT 'BranchID fixed based on product code prefix!';
