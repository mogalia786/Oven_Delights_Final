-- Find all tables related to sub-recipes

SELECT 
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%SubRecipe%'
OR TABLE_NAME LIKE '%Sub_Recipe%'
ORDER BY TABLE_NAME;

-- Check if there's data in any of these tables
SELECT 'Demo_SubRecipe_Master' AS TableName, COUNT(*) AS Rows FROM Demo_SubRecipe_Master
UNION ALL
SELECT 'Demo_SubRecipe_BOM' AS TableName, COUNT(*) AS Rows FROM Demo_SubRecipe_BOM;

-- Check if there's a Demo_SubRecipe_Ingredients table
SELECT COUNT(*) AS TableExists FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Demo_SubRecipe_Ingredients';

-- If it exists, check its data
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Demo_SubRecipe_Ingredients')
BEGIN
    SELECT 'Demo_SubRecipe_Ingredients' AS Source, * FROM Demo_SubRecipe_Ingredients WHERE SubRecipeID IN (SELECT SubRecipeID FROM Demo_SubRecipe_Master WHERE Method LIKE '%batter%');
END
