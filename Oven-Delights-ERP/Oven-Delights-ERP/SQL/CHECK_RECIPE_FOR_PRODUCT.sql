-- =============================================
-- CHECK RECIPE FOR SPECIFIC PRODUCT
-- Run this to see what's in RecipeNode for your product
-- =============================================

-- CHANGE THIS TO YOUR PRODUCT ID OR NAME
DECLARE @ProductName NVARCHAR(200) = 'Apple Tartlet'; -- Change this to your product name
DECLARE @ProductID INT = NULL; -- Or set this to specific ProductID

-- Get ProductID if name is provided
IF @ProductID IS NULL
BEGIN
    SELECT @ProductID = ProductID 
    FROM dbo.Demo_Retail_Product 
    WHERE Name LIKE '%' + @ProductName + '%' 
      AND ProductType = 'Internal'
      AND ISNULL(IsActive, 1) = 1;
END

IF @ProductID IS NULL
BEGIN
    PRINT '❌ Product not found!';
    PRINT 'Available Internal Products:';
    SELECT ProductID, SKU, Name 
    FROM dbo.Demo_Retail_Product 
    WHERE ProductType = 'Internal' 
      AND ISNULL(IsActive, 1) = 1
    ORDER BY Name;
    RETURN;
END

PRINT '═══════════════════════════════════════════════';
PRINT 'Checking Recipe for ProductID: ' + CAST(@ProductID AS VARCHAR);
SELECT @ProductName = Name FROM dbo.Demo_Retail_Product WHERE ProductID = @ProductID;
PRINT 'Product Name: ' + @ProductName;
PRINT '═══════════════════════════════════════════════';
PRINT '';

-- Check ALL RecipeNodes for this product
PRINT '=== ALL RecipeNodes for this Product ===';
SELECT 
    NodeID,
    ParentNodeID,
    Level,
    NodeKind,
    ItemType,
    ItemName,
    MaterialID,
    SubAssemblyProductID,
    Qty,
    UoMID,
    SortOrder,
    CASE 
        WHEN ParentNodeID IS NULL THEN '❌ Root Node (will be excluded)'
        WHEN MaterialID IS NULL AND SubAssemblyProductID IS NULL AND ItemName IS NULL THEN '❌ No Material/SubAssembly/ItemName'
        ELSE '✅ Valid Component'
    END AS ValidationStatus
FROM dbo.RecipeNode
WHERE ProductID = @ProductID
ORDER BY Level, ISNULL(SortOrder, 0), NodeID;

PRINT '';
PRINT '=== Valid Components (What BOM Generate will see) ===';
SELECT 
    ROW_NUMBER() OVER (ORDER BY ISNULL(rn.SortOrder,0), rn.NodeID) AS LineNumber,
    ISNULL(rn.ItemName, 'Component') AS ComponentName,
    ISNULL(rn.Qty, 0) AS QuantityPerBatch,
    ISNULL(u.UoMCode, '') AS UoM,
    rn.MaterialID AS RawMaterialID,
    rn.NodeKind,
    rn.ParentNodeID
FROM dbo.RecipeNode rn
LEFT JOIN dbo.UoM u ON u.UoMID = rn.UoMID
WHERE rn.ProductID = @ProductID
  AND rn.ParentNodeID IS NOT NULL
  AND (rn.MaterialID IS NOT NULL OR rn.SubAssemblyProductID IS NOT NULL OR rn.ItemName IS NOT NULL)
ORDER BY ISNULL(rn.SortOrder,0), rn.NodeID;

DECLARE @ValidCount INT = @@ROWCOUNT;

PRINT '';
PRINT '═══════════════════════════════════════════════';
IF @ValidCount = 0
BEGIN
    PRINT '❌ NO VALID COMPONENTS FOUND!';
    PRINT '';
    PRINT 'Possible Issues:';
    PRINT '1. All nodes have ParentNodeID = NULL (root nodes only)';
    PRINT '2. No MaterialID, SubAssemblyProductID, or ItemName set';
    PRINT '';
    PRINT '✅ SOLUTION:';
    PRINT '1. Go to Manufacturing > Build My Product';
    PRINT '2. Open the product: ' + @ProductName;
    PRINT '3. Ensure you have added ingredients/components as CHILD nodes';
    PRINT '4. Save the recipe again';
    PRINT '5. Try BOM Generate again';
END
ELSE
BEGIN
    PRINT '✅ Found ' + CAST(@ValidCount AS VARCHAR) + ' valid component(s)!';
    PRINT '';
    PRINT 'BOM Generate should work now.';
    PRINT 'If it still shows "No Recipe", close and reopen the BOM form.';
END
PRINT '═══════════════════════════════════════════════';
