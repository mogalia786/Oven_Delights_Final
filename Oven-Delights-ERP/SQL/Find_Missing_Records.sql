-- Check total records imported vs expected
SELECT 
    'Expected from CSV' AS Source,
    'OD200' AS Branch,
    1378 AS Count
UNION ALL
SELECT 
    'Actually imported' AS Source,
    'OD200' AS Branch,
    COUNT(*) AS Count
FROM Demo_Retail_Product
WHERE Code LIKE 'AC%'
UNION ALL
SELECT 
    'Expected from CSV' AS Source,
    'OD400' AS Branch,
    1355 AS Count
UNION ALL
SELECT 
    'Actually imported' AS Source,
    'OD400' AS Branch,
    COUNT(*) AS Count
FROM Demo_Retail_Product
WHERE Code LIKE 'UM%';

-- Check if records went to RawMaterials or Subassemblies instead
SELECT 
    'RawMaterials (AC prefix)' AS Table_Name,
    COUNT(*) AS Count
FROM RawMaterials
WHERE MaterialCode LIKE 'AC%'
UNION ALL
SELECT 
    'RawMaterials (UM prefix)' AS Table_Name,
    COUNT(*) AS Count
FROM RawMaterials
WHERE MaterialCode LIKE 'UM%'
UNION ALL
SELECT 
    'Subassemblies (AC prefix)' AS Table_Name,
    COUNT(*) AS Count
FROM Subassemblies
WHERE SubAssemblyCode LIKE 'AC%'
UNION ALL
SELECT 
    'Subassemblies (UM prefix)' AS Table_Name,
    COUNT(*) AS Count
FROM Subassemblies
WHERE SubAssemblyCode LIKE 'UM%';

-- Total across all tables
SELECT 
    'Total AC products across all tables' AS Summary,
    (SELECT COUNT(*) FROM Demo_Retail_Product WHERE Code LIKE 'AC%') +
    (SELECT COUNT(*) FROM RawMaterials WHERE MaterialCode LIKE 'AC%') +
    (SELECT COUNT(*) FROM Subassemblies WHERE SubAssemblyCode LIKE 'AC%') AS Count
UNION ALL
SELECT 
    'Total UM products across all tables' AS Summary,
    (SELECT COUNT(*) FROM Demo_Retail_Product WHERE Code LIKE 'UM%') +
    (SELECT COUNT(*) FROM RawMaterials WHERE MaterialCode LIKE 'UM%') +
    (SELECT COUNT(*) FROM Subassemblies WHERE SubAssemblyCode LIKE 'UM%') AS Count;

-- Check for duplicates that might have been filtered
SELECT 
    'Duplicate ItemCodes in CSV' AS Issue,
    'Check Combined_Inventory.csv for duplicates' AS Action;
