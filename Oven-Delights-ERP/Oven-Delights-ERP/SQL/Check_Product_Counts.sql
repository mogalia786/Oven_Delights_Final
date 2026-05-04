-- Check product counts in Demo_Retail_Product by BranchID
SELECT 
    BranchID,
    CASE 
        WHEN BranchID = 4 THEN 'OD400 - Umhlanga'
        WHEN BranchID = 6 THEN 'OD200 - Avondale'
        ELSE 'Unknown'
    END AS BranchName,
    COUNT(*) AS TotalProducts
FROM Demo_Retail_Product
GROUP BY BranchID
ORDER BY BranchID;

-- Check by category
SELECT 
    Category,
    BranchID,
    COUNT(*) AS ProductCount
FROM Demo_Retail_Product
GROUP BY Category, BranchID
ORDER BY BranchID, Category;
