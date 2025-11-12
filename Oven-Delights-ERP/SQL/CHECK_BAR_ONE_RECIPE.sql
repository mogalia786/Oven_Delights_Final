-- Check if Bar One Slice has a recipe
DECLARE @ProductID INT = 56082;

-- Check Recipe table structure first
SELECT 'Recipe Columns' AS Info, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Recipe'
ORDER BY ORDINAL_POSITION;

-- Check Recipe table
SELECT 'Recipe' AS Info, *
FROM dbo.Recipe
WHERE ProductID = @ProductID;

-- Check RecipeIngredients
SELECT 'RecipeIngredients' AS Info, 
    ri.RecipeIngredientID,
    ri.IngredientType,
    CASE 
        WHEN ri.IngredientType = 'RawMaterial' THEN rm.MaterialName
        WHEN ri.IngredientType = 'SubAssembly' THEN p.Name
        ELSE ri.IngredientName
    END AS IngredientName,
    ri.Quantity,
    ri.UoM
FROM dbo.RecipeIngredients ri
LEFT JOIN dbo.RawMaterials rm ON rm.MaterialID = ri.MaterialID
LEFT JOIN dbo.Demo_Retail_Product p ON p.ProductID = ri.SubAssemblyProductID
WHERE ri.RecipeID IN (SELECT RecipeID FROM dbo.Recipe WHERE ProductID = @ProductID);

-- Check RecipeNode (old structure)
SELECT 'RecipeNode' AS Info, NodeID, ProductID, ItemName, Qty, MaterialID
FROM dbo.RecipeNode
WHERE ProductID = @ProductID;
