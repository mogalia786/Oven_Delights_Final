-- Check if CategoryID in Demo_Retail_Product allows NULL
SELECT 
    COLUMN_NAME,
    IS_NULLABLE,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Retail_Product'
    AND COLUMN_NAME = 'CategoryID';

-- Check existing categories in ProductCategories table
SELECT CategoryID, CategoryName 
FROM ProductCategories
ORDER BY CategoryName;

-- Check what categories are in the staging data
SELECT DISTINCT Category, COUNT(*) AS Count
FROM #StagingImport
WHERE TreatmentType IN ('FinishedProduct', 'Accessory')
GROUP BY Category
ORDER BY Category;
