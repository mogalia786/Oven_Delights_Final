-- Check if Apple Tart has a recipe/BOM

-- Find Apple Tart product
SELECT ProductID, Name, SKU, ProductType, BranchID, IsActive
FROM Demo_Retail_Product
WHERE Name LIKE '%Apple%Tart%' OR Name LIKE '%Tart%';

-- Check BOMHeader for Apple Tart (replace ProductID if different)
DECLARE @ProductID INT = (SELECT TOP 1 ProductID FROM Demo_Retail_Product WHERE Name LIKE '%Apple%Tart%');

SELECT 'BOMHeader' AS Source, *
FROM BOMHeader
WHERE ProductID = @ProductID;

-- Check BOMItems
SELECT 'BOMItems' AS Source, bi.*, rm.MaterialName, p.Name AS ComponentProductName
FROM BOMItems bi
LEFT JOIN RawMaterials rm ON rm.MaterialID = bi.RawMaterialID
LEFT JOIN Demo_Retail_Product p ON p.ProductID = bi.ComponentProductID
WHERE bi.BOMID IN (SELECT BOMID FROM BOMHeader WHERE ProductID = @ProductID);

-- Check RecipeNode
SELECT 'RecipeNode' AS Source, *
FROM RecipeNode
WHERE ProductID = @ProductID
ORDER BY SortOrder, NodeID;
