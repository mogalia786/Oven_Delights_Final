-- Count products in Demo_Retail_Product by branch
SELECT 
    'Demo_Retail_Product' AS TableName,
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

-- Count stock records in Demo_Retail_Stock by branch
SELECT 
    'Demo_Retail_Stock' AS TableName,
    BranchID,
    CASE 
        WHEN BranchID = 6 THEN 'OD200 - Avondale'
        WHEN BranchID = 4 THEN 'OD400 - Umhlanga'
        ELSE 'Unknown Branch'
    END AS BranchName,
    COUNT(*) AS StockRecords
FROM Demo_Retail_Stock
GROUP BY BranchID
ORDER BY BranchID;

-- Count by Code prefix (AC/UM) vs BranchID
SELECT 
    'Products by Code Prefix' AS Summary,
    CASE 
        WHEN Code LIKE 'AC%' THEN 'AC (OD200)'
        WHEN Code LIKE 'UM%' THEN 'UM (OD400)'
        ELSE 'Other'
    END AS CodePrefix,
    BranchID,
    COUNT(*) AS Count
FROM Demo_Retail_Product
GROUP BY 
    CASE 
        WHEN Code LIKE 'AC%' THEN 'AC (OD200)'
        WHEN Code LIKE 'UM%' THEN 'UM (OD400)'
        ELSE 'Other'
    END,
    BranchID
ORDER BY CodePrefix, BranchID;

-- Summary
SELECT 
    'Expected OD200' AS Branch, 1378 AS Expected, 
    (SELECT COUNT(*) FROM Demo_Retail_Product WHERE Code LIKE 'AC%') AS Actual,
    1378 - (SELECT COUNT(*) FROM Demo_Retail_Product WHERE Code LIKE 'AC%') AS Difference
UNION ALL
SELECT 
    'Expected OD400', 1355,
    (SELECT COUNT(*) FROM Demo_Retail_Product WHERE Code LIKE 'UM%'),
    1355 - (SELECT COUNT(*) FROM Demo_Retail_Product WHERE Code LIKE 'UM%');
