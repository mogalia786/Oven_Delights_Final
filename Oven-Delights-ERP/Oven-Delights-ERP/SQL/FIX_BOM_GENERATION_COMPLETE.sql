-- =============================================
-- COMPLETE FIX FOR BOM GENERATION ISSUES
-- This script fixes all common BOM generation problems
-- =============================================

PRINT '🔧 Starting Complete BOM Generation Fix...';
PRINT '';

-- =============================================
-- STEP 1: Fix Expired BOMs
-- =============================================
PRINT '=== STEP 1: Fixing Expired BOMs ===';

UPDATE dbo.BOMHeader
SET EffectiveTo = NULL
WHERE IsActive = 1
  AND EffectiveTo IS NOT NULL
  AND EffectiveTo < CAST(GETDATE() AS DATE);

DECLARE @ExpiredFixed INT = @@ROWCOUNT;
PRINT '✅ Fixed ' + CAST(@ExpiredFixed AS VARCHAR) + ' expired BOM(s) by removing EffectiveTo dates';

-- =============================================
-- STEP 2: Identify and Handle Duplicate Products
-- =============================================
PRINT '';
PRINT '=== STEP 2: Finding Duplicate Products ===';

-- Find duplicates (same Name and SKU)
IF OBJECT_ID('tempdb..#Duplicates') IS NOT NULL DROP TABLE #Duplicates;

SELECT 
    Name,
    SKU,
    COUNT(*) AS DuplicateCount,
    MIN(ProductID) AS KeepProductID,
    STRING_AGG(CAST(ProductID AS VARCHAR), ', ') AS AllProductIDs
INTO #Duplicates
FROM dbo.Demo_Retail_Product
WHERE ProductType = 'Internal'
  AND ISNULL(IsActive, 1) = 1
GROUP BY Name, SKU
HAVING COUNT(*) > 1;

DECLARE @DuplicateCount INT = (SELECT COUNT(*) FROM #Duplicates);

IF @DuplicateCount > 0
BEGIN
    PRINT '⚠️  Found ' + CAST(@DuplicateCount AS VARCHAR) + ' duplicate product(s):';
    
    SELECT 
        Name,
        SKU,
        DuplicateCount,
        KeepProductID AS 'Will Keep ProductID',
        AllProductIDs AS 'All Duplicate IDs'
    FROM #Duplicates;
    
    PRINT '';
    PRINT '🔧 Deactivating duplicate products (keeping the one with BOM or lowest ID)...';
    
    -- For each duplicate set, keep the one with BOM or lowest ProductID
    DECLARE @Name NVARCHAR(200), @SKU NVARCHAR(50), @KeepID INT;
    
    DECLARE dup_cursor CURSOR FOR 
    SELECT Name, SKU, KeepProductID FROM #Duplicates;
    
    OPEN dup_cursor;
    FETCH NEXT FROM dup_cursor INTO @Name, @SKU, @KeepID;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Check if any duplicate has a BOM
        DECLARE @ProductIDWithBOM INT = NULL;
        
        SELECT TOP 1 @ProductIDWithBOM = p.ProductID
        FROM dbo.Demo_Retail_Product p
        INNER JOIN dbo.BOMHeader bh ON bh.ProductID = p.ProductID AND bh.IsActive = 1
        WHERE p.Name = @Name AND p.SKU = @SKU
        ORDER BY bh.BOMID;
        
        -- If one has a BOM, keep that one; otherwise keep the lowest ID
        SET @KeepID = ISNULL(@ProductIDWithBOM, @KeepID);
        
        -- Deactivate all others
        UPDATE dbo.Demo_Retail_Product
        SET IsActive = 0
        WHERE Name = @Name 
          AND SKU = @SKU 
          AND ProductID <> @KeepID;
        
        PRINT '  ✅ Kept ProductID ' + CAST(@KeepID AS VARCHAR) + ' for "' + @Name + '" (' + @SKU + ')';
        
        FETCH NEXT FROM dup_cursor INTO @Name, @SKU, @KeepID;
    END;
    
    CLOSE dup_cursor;
    DEALLOCATE dup_cursor;
END
ELSE
BEGIN
    PRINT '✅ No duplicate products found';
END;

-- =============================================
-- STEP 3: Create BOMs from RecipeNode for products without BOM
-- =============================================
PRINT '';
PRINT '=== STEP 3: Creating BOMs from RecipeNode ===';

-- Find products with RecipeNode but no BOM
IF OBJECT_ID('tempdb..#NeedsBOM') IS NOT NULL DROP TABLE #NeedsBOM;

SELECT DISTINCT
    p.ProductID,
    p.Name,
    p.SKU
INTO #NeedsBOM
FROM dbo.Demo_Retail_Product p
INNER JOIN dbo.RecipeNode rn ON rn.ProductID = p.ProductID
LEFT JOIN dbo.BOMHeader bh ON bh.ProductID = p.ProductID AND bh.IsActive = 1
WHERE p.ProductType = 'Internal'
  AND ISNULL(p.IsActive, 1) = 1
  AND rn.ParentNodeID IS NOT NULL
  AND (rn.MaterialID IS NOT NULL OR rn.SubAssemblyProductID IS NOT NULL OR rn.ItemName IS NOT NULL)
  AND bh.BOMID IS NULL;

DECLARE @NeedsBOMCount INT = (SELECT COUNT(*) FROM #NeedsBOM);

IF @NeedsBOMCount > 0
BEGIN
    PRINT '🔧 Creating BOMs for ' + CAST(@NeedsBOMCount AS VARCHAR) + ' product(s) from RecipeNode...';
    
    DECLARE @ProdID INT, @ProdName NVARCHAR(200), @ProdSKU NVARCHAR(50);
    
    DECLARE bom_cursor CURSOR FOR 
    SELECT ProductID, Name, SKU FROM #NeedsBOM;
    
    OPEN bom_cursor;
    FETCH NEXT FROM bom_cursor INTO @ProdID, @ProdName, @ProdSKU;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Create BOMHeader
        INSERT INTO dbo.BOMHeader (ProductID, BatchYieldQty, IsActive, EffectiveFrom)
        VALUES (@ProdID, 1, 1, CAST(GETDATE() AS DATE));
        
        DECLARE @NewBOMID INT = SCOPE_IDENTITY();
        
        -- Create BOMItems from RecipeNode
        INSERT INTO dbo.BOMItems (BOMID, LineNumber, ComponentType, RawMaterialID, ComponentProductID, NonStockDesc, QuantityPerBatch, UoM)
        SELECT 
            @NewBOMID,
            ROW_NUMBER() OVER (ORDER BY ISNULL(rn.SortOrder, 0), rn.NodeID),
            CASE 
                WHEN rn.MaterialID IS NOT NULL THEN 'RawMaterial'
                WHEN rn.SubAssemblyProductID IS NOT NULL THEN 'SubAssembly'
                ELSE 'Component'
            END,
            rn.MaterialID,
            rn.SubAssemblyProductID,
            CASE WHEN rn.MaterialID IS NULL AND rn.SubAssemblyProductID IS NULL THEN rn.ItemName ELSE NULL END,
            ISNULL(rn.Qty, 0),
            ISNULL(u.UoMCode, '')
        FROM dbo.RecipeNode rn
        LEFT JOIN dbo.UoM u ON u.UoMID = rn.UoMID
        WHERE rn.ProductID = @ProdID
          AND rn.ParentNodeID IS NOT NULL
          AND (rn.MaterialID IS NOT NULL OR rn.SubAssemblyProductID IS NOT NULL OR rn.ItemName IS NOT NULL);
        
        DECLARE @ItemsCreated INT = @@ROWCOUNT;
        PRINT '  ✅ Created BOM ' + CAST(@NewBOMID AS VARCHAR) + ' for "' + @ProdName + '" with ' + CAST(@ItemsCreated AS VARCHAR) + ' items';
        
        FETCH NEXT FROM bom_cursor INTO @ProdID, @ProdName, @ProdSKU;
    END;
    
    CLOSE bom_cursor;
    DEALLOCATE bom_cursor;
END
ELSE
BEGIN
    PRINT '✅ All products with recipes already have BOMs';
END;

-- =============================================
-- STEP 4: Verify Fix Results
-- =============================================
PRINT '';
PRINT '=== STEP 4: Verification ===';

SELECT 
    p.ProductID,
    p.SKU,
    p.Name,
    p.IsActive,
    CASE 
        WHEN bh.BOMID IS NOT NULL AND bh.IsActive = 1 
             AND bh.EffectiveFrom <= CAST(GETDATE() AS DATE)
             AND (bh.EffectiveTo IS NULL OR bh.EffectiveTo >= CAST(GETDATE() AS DATE))
        THEN '✅ Has Active BOM'
        WHEN bh.BOMID IS NOT NULL THEN '⚠️ Has BOM but not active'
        WHEN rn.NodeID IS NOT NULL THEN '⚠️ Has Recipe but no BOM'
        ELSE '❌ No BOM or Recipe'
    END AS Status,
    bh.BOMID,
    (SELECT COUNT(*) FROM dbo.BOMItems bi WHERE bi.BOMID = bh.BOMID) AS BOMItemCount
FROM dbo.Demo_Retail_Product p
LEFT JOIN dbo.BOMHeader bh ON bh.ProductID = p.ProductID
LEFT JOIN dbo.RecipeNode rn ON rn.ProductID = p.ProductID AND rn.ParentNodeID IS NOT NULL
WHERE p.ProductType = 'Internal'
  AND ISNULL(p.IsActive, 1) = 1
GROUP BY p.ProductID, p.SKU, p.Name, p.IsActive, bh.BOMID, bh.IsActive, bh.EffectiveFrom, bh.EffectiveTo, rn.NodeID
ORDER BY p.Name;

-- =============================================
-- SUMMARY
-- =============================================
PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ FIX COMPLETE!';
PRINT '';
PRINT '📊 Summary:';
PRINT '  - Fixed ' + CAST(@ExpiredFixed AS VARCHAR) + ' expired BOM(s)';
PRINT '  - Handled ' + CAST(@DuplicateCount AS VARCHAR) + ' duplicate product set(s)';
PRINT '  - Created ' + CAST(@NeedsBOMCount AS VARCHAR) + ' new BOM(s) from recipes';
PRINT '';
PRINT '🎯 Next Steps:';
PRINT '  1. Close and reopen the BOM Create form';
PRINT '  2. Select a product';
PRINT '  3. Click Generate - items should now populate!';
PRINT '';
PRINT 'If issues persist, run DEBUG_BOM_GENERATION.sql for detailed diagnostics';
PRINT '═══════════════════════════════════════════════';

-- Cleanup
IF OBJECT_ID('tempdb..#Duplicates') IS NOT NULL DROP TABLE #Duplicates;
IF OBJECT_ID('tempdb..#NeedsBOM') IS NOT NULL DROP TABLE #NeedsBOM;
