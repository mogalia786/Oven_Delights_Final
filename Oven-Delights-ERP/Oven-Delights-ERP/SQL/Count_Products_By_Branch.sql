-- Count products by Code prefix (what was imported)
SELECT 
    CASE 
        WHEN Code LIKE 'AC%' THEN 'OD200 (AC prefix) - Should be BranchID 6'
        WHEN Code LIKE 'UM%' THEN 'OD400 (UM prefix) - Should be BranchID 4'
        ELSE 'Unknown prefix'
    END AS Branch,
    COUNT(*) AS ProductCount
FROM Demo_Retail_Product
GROUP BY 
    CASE 
        WHEN Code LIKE 'AC%' THEN 'OD200 (AC prefix) - Should be BranchID 6'
        WHEN Code LIKE 'UM%' THEN 'OD400 (UM prefix) - Should be BranchID 4'
        ELSE 'Unknown prefix'
    END;

-- Count products by actual BranchID (what's currently set)
SELECT 
    BranchID,
    CASE 
        WHEN BranchID = 6 THEN 'OD200 - Avondale'
        WHEN BranchID = 4 THEN 'OD400 - Umhlanga'
        ELSE 'Unknown Branch'
    END AS BranchName,
    COUNT(*) AS ProductCount
FROM Demo_Retail_Product
GROUP BY BranchID
ORDER BY BranchID;

-- Show mismatch between Code prefix and BranchID
SELECT 
    'Products with AC prefix but wrong BranchID' AS Issue,
    COUNT(*) AS Count
FROM Demo_Retail_Product
WHERE Code LIKE 'AC%' AND BranchID != 6
UNION ALL
SELECT 
    'Products with UM prefix but wrong BranchID' AS Issue,
    COUNT(*) AS Count
FROM Demo_Retail_Product
WHERE Code LIKE 'UM%' AND BranchID != 4;

-- Sample products showing the mismatch
SELECT TOP 10
    Code,
    Name,
    BranchID,
    CASE 
        WHEN Code LIKE 'AC%' THEN 6
        WHEN Code LIKE 'UM%' THEN 4
        ELSE NULL
    END AS ShouldBeBranchID
FROM Demo_Retail_Product
WHERE (Code LIKE 'AC%' AND BranchID != 6)
   OR (Code LIKE 'UM%' AND BranchID != 4)
ORDER BY Code;
