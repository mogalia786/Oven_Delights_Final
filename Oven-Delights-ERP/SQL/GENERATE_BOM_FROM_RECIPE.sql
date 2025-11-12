-- Generate BOM for Americano from Recipe table
-- This will create BOMHeader with correct BatchYieldQty and BOMItems with ingredients

DECLARE @ProductID INT;
DECLARE @ProductName NVARCHAR(200);
DECLARE @RecipeID INT;
DECLARE @BatchYield DECIMAL(18,2);

-- Get Americano product (or any product with a recipe that has BatchYield = 60)
SELECT TOP 1 
    @ProductID = p.ProductID,
    @ProductName = p.Name
FROM dbo.Demo_Retail_Product p
INNER JOIN dbo.Recipe r ON r.ProductID = p.ProductID
WHERE r.BatchYield = 60 AND r.IsActive = 1
ORDER BY r.RecipeID DESC;

IF @ProductID IS NULL
BEGIN
    PRINT 'Americano product not found!';
    RETURN;
END

PRINT 'Found product: ' + @ProductName + ' (ProductID: ' + CAST(@ProductID AS VARCHAR) + ')';

-- Get Recipe
SELECT TOP 1
    @RecipeID = RecipeID,
    @BatchYield = BatchYield
FROM dbo.Recipe
WHERE ProductID = @ProductID AND IsActive = 1
ORDER BY RecipeID DESC;

IF @RecipeID IS NULL
BEGIN
    PRINT 'No recipe found for this product!';
    RETURN;
END

PRINT 'Found Recipe: RecipeID=' + CAST(@RecipeID AS VARCHAR) + ', BatchYield=' + CAST(@BatchYield AS VARCHAR);

-- Check if BOM already exists
DECLARE @ExistingBOMID INT;
SELECT @ExistingBOMID = BOMID
FROM dbo.BOMHeader
WHERE ProductID = @ProductID AND IsActive = 1;

IF @ExistingBOMID IS NOT NULL
BEGIN
    PRINT 'BOM already exists (BOMID=' + CAST(@ExistingBOMID AS VARCHAR) + '). Updating BatchYieldQty...';
    
    UPDATE dbo.BOMHeader
    SET BatchYieldQty = @BatchYield
    WHERE BOMID = @ExistingBOMID;
    
    PRINT 'Updated BatchYieldQty to ' + CAST(@BatchYield AS VARCHAR);
    
    -- Check if BOMItems exist
    DECLARE @ItemCount INT;
    SELECT @ItemCount = COUNT(*) FROM dbo.BOMItems WHERE BOMID = @ExistingBOMID;
    
    IF @ItemCount = 0
    BEGIN
        PRINT 'No BOMItems found. Creating from RecipeIngredient...';
        GOTO CREATE_ITEMS;
    END
    ELSE
    BEGIN
        PRINT 'BOM already has ' + CAST(@ItemCount AS VARCHAR) + ' items.';
        RETURN;
    END
END
ELSE
BEGIN
    PRINT 'Creating new BOM...';
    
    -- Get YieldUoM from Recipe
    DECLARE @YieldUoM NVARCHAR(50);
    SELECT @YieldUoM = BatchYieldUoM FROM dbo.Recipe WHERE RecipeID = @RecipeID;
    
    INSERT INTO dbo.BOMHeader (ProductID, BatchYieldQty, YieldUoM, IsActive, EffectiveFrom)
    VALUES (@ProductID, @BatchYield, ISNULL(@YieldUoM, 'ea'), 1, CAST(GETDATE() AS DATE));
    
    SET @ExistingBOMID = SCOPE_IDENTITY();
    PRINT 'Created BOMHeader with BOMID=' + CAST(@ExistingBOMID AS VARCHAR);
END

CREATE_ITEMS:

-- Create BOMItems from RecipeIngredient table
INSERT INTO dbo.BOMItems (BOMID, LineNumber, ComponentType, RawMaterialID, ComponentProductID, NonStockDesc, QuantityPerBatch, UoM)
SELECT 
    @ExistingBOMID,
    ROW_NUMBER() OVER (ORDER BY ri.RecipeIngredientID),
    CASE 
        WHEN ri.IngredientType = 'RawMaterial' THEN 'RawMaterial'
        WHEN ri.IngredientType = 'SubAssembly' THEN 'Product'
        ELSE 'Component'
    END,
    ri.MaterialID,
    ri.SubAssemblyProductID,
    CASE WHEN ri.MaterialID IS NULL AND ri.SubAssemblyProductID IS NULL THEN ri.IngredientName ELSE NULL END,
    ri.Quantity,
    ri.UoM
FROM dbo.RecipeIngredient ri
WHERE ri.RecipeID = @RecipeID;

DECLARE @ItemsCreated INT = @@ROWCOUNT;
PRINT 'Created ' + CAST(@ItemsCreated AS VARCHAR) + ' BOMItems';

-- Show the result
SELECT 'BOMHeader' AS Info, * FROM dbo.BOMHeader WHERE BOMID = @ExistingBOMID;
SELECT 'BOMItems' AS Info, * FROM dbo.BOMItems WHERE BOMID = @ExistingBOMID;
