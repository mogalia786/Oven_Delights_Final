-- =============================================
-- SIMPLIFIED RECIPE SYSTEM (No Nodes!)
-- Simple recipe card approach for Build My Product
-- =============================================

PRINT '🔧 Creating Simplified Recipe System...';
PRINT '';

-- =============================================
-- Recipe Header Table
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Recipe')
BEGIN
    CREATE TABLE dbo.Recipe (
        RecipeID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        RecipeName NVARCHAR(200) NOT NULL,
        BatchYield DECIMAL(18,4) NOT NULL DEFAULT 1, -- How many units this recipe makes
        BatchYieldUoM NVARCHAR(20) NULL, -- Unit of measure for batch (ea, kg, etc)
        Method NVARCHAR(MAX) NULL, -- Cooking/preparation instructions
        PrepTime INT NULL, -- Minutes
        CookTime INT NULL, -- Minutes
        IsActive BIT NOT NULL DEFAULT 1,
        Version INT NOT NULL DEFAULT 1,
        CreatedBy NVARCHAR(100) NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ModifiedBy NVARCHAR(100) NULL,
        ModifiedDate DATETIME NULL,
        Notes NVARCHAR(MAX) NULL,
        CONSTRAINT FK_Recipe_Product FOREIGN KEY (ProductID) 
            REFERENCES dbo.Demo_Retail_Product(ProductID)
    );
    
    CREATE INDEX IX_Recipe_ProductID ON dbo.Recipe(ProductID);
    CREATE INDEX IX_Recipe_IsActive ON dbo.Recipe(IsActive);
    
    PRINT '✅ Created Recipe table';
END
ELSE
BEGIN
    PRINT '⚠️  Recipe table already exists';
END

-- =============================================
-- Recipe Ingredients Table (Simple Grid)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'RecipeIngredient')
BEGIN
    CREATE TABLE dbo.RecipeIngredient (
        RecipeIngredientID INT IDENTITY(1,1) PRIMARY KEY,
        RecipeID INT NOT NULL,
        LineNumber INT NOT NULL DEFAULT 0,
        IngredientType NVARCHAR(20) NOT NULL, -- 'RawMaterial', 'SubAssembly', 'Other'
        MaterialID INT NULL, -- FK to RawMaterials
        SubAssemblyProductID INT NULL, -- FK to Demo_Retail_Product (for sub-assemblies)
        IngredientName NVARCHAR(200) NULL, -- For 'Other' type or display override
        Quantity DECIMAL(18,4) NOT NULL,
        UoM NVARCHAR(20) NULL,
        Notes NVARCHAR(500) NULL,
        CONSTRAINT FK_RecipeIngredient_Recipe FOREIGN KEY (RecipeID) 
            REFERENCES dbo.Recipe(RecipeID) ON DELETE CASCADE,
        CONSTRAINT FK_RecipeIngredient_Material FOREIGN KEY (MaterialID) 
            REFERENCES dbo.RawMaterials(MaterialID),
        CONSTRAINT FK_RecipeIngredient_SubAssembly FOREIGN KEY (SubAssemblyProductID) 
            REFERENCES dbo.Demo_Retail_Product(ProductID)
    );
    
    CREATE INDEX IX_RecipeIngredient_RecipeID ON dbo.RecipeIngredient(RecipeID);
    CREATE INDEX IX_RecipeIngredient_MaterialID ON dbo.RecipeIngredient(MaterialID);
    
    PRINT '✅ Created RecipeIngredient table';
END
ELSE
BEGIN
    PRINT '⚠️  RecipeIngredient table already exists';
END

-- =============================================
-- Migration: Convert existing RecipeNode to new system
-- =============================================
PRINT '';
PRINT '=== Migrating existing recipes from RecipeNode ===';

-- Migrate recipes
INSERT INTO dbo.Recipe (ProductID, RecipeName, BatchYield, IsActive, CreatedDate, Notes)
SELECT DISTINCT
    rn.ProductID,
    p.Name + ' Recipe',
    1.0, -- Default batch yield
    1,
    GETDATE(),
    'Migrated from RecipeNode'
FROM dbo.RecipeNode rn
INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = rn.ProductID
WHERE rn.ParentNodeID IS NULL -- Only root nodes
  AND NOT EXISTS (SELECT 1 FROM dbo.Recipe r WHERE r.ProductID = rn.ProductID);

DECLARE @MigratedRecipes INT = @@ROWCOUNT;
PRINT '✅ Migrated ' + CAST(@MigratedRecipes AS VARCHAR) + ' recipe headers';

-- Migrate ingredients (with validation for foreign keys)
INSERT INTO dbo.RecipeIngredient (RecipeID, LineNumber, IngredientType, MaterialID, SubAssemblyProductID, IngredientName, Quantity, UoM)
SELECT 
    r.RecipeID,
    ROW_NUMBER() OVER (PARTITION BY r.RecipeID ORDER BY ISNULL(rn.SortOrder, 0), rn.NodeID),
    CASE 
        WHEN rn.MaterialID IS NOT NULL AND EXISTS (SELECT 1 FROM dbo.RawMaterials WHERE MaterialID = rn.MaterialID) THEN 'RawMaterial'
        WHEN rn.SubAssemblyProductID IS NOT NULL AND EXISTS (SELECT 1 FROM dbo.Demo_Retail_Product WHERE ProductID = rn.SubAssemblyProductID) THEN 'SubAssembly'
        ELSE 'Other'
    END,
    CASE 
        WHEN rn.MaterialID IS NOT NULL AND EXISTS (SELECT 1 FROM dbo.RawMaterials WHERE MaterialID = rn.MaterialID) THEN rn.MaterialID
        ELSE NULL
    END,
    CASE 
        WHEN rn.SubAssemblyProductID IS NOT NULL AND EXISTS (SELECT 1 FROM dbo.Demo_Retail_Product WHERE ProductID = rn.SubAssemblyProductID) THEN rn.SubAssemblyProductID
        ELSE NULL
    END,
    CASE 
        WHEN rn.MaterialID IS NOT NULL THEN (SELECT MaterialName FROM dbo.RawMaterials WHERE MaterialID = rn.MaterialID)
        WHEN rn.SubAssemblyProductID IS NOT NULL THEN (SELECT Name FROM dbo.Demo_Retail_Product WHERE ProductID = rn.SubAssemblyProductID)
        ELSE rn.ItemName
    END,
    ISNULL(rn.Qty, 0),
    u.UoMCode
FROM dbo.RecipeNode rn
INNER JOIN dbo.Recipe r ON r.ProductID = rn.ProductID
LEFT JOIN dbo.UoM u ON u.UoMID = rn.UoMID
WHERE rn.ParentNodeID IS NOT NULL
  AND (rn.MaterialID IS NOT NULL OR rn.SubAssemblyProductID IS NOT NULL OR rn.ItemName IS NOT NULL)
  AND NOT EXISTS (
      SELECT 1 FROM dbo.RecipeIngredient ri 
      WHERE ri.RecipeID = r.RecipeID 
        AND ISNULL(ri.MaterialID, 0) = ISNULL(rn.MaterialID, 0)
        AND ISNULL(ri.SubAssemblyProductID, 0) = ISNULL(rn.SubAssemblyProductID, 0)
  );

DECLARE @MigratedIngredients INT = @@ROWCOUNT;
PRINT '✅ Migrated ' + CAST(@MigratedIngredients AS VARCHAR) + ' recipe ingredients';

-- =============================================
-- Create View for Easy Querying
-- =============================================
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_RecipeDetails')
    DROP VIEW dbo.vw_RecipeDetails;
GO

CREATE VIEW dbo.vw_RecipeDetails
AS
SELECT 
    r.RecipeID,
    r.ProductID,
    p.SKU AS ProductSKU,
    p.Name AS ProductName,
    r.RecipeName,
    r.BatchYield,
    r.BatchYieldUoM,
    r.Method,
    r.PrepTime,
    r.CookTime,
    ri.RecipeIngredientID,
    ri.LineNumber,
    ri.IngredientType,
    CASE 
        WHEN ri.IngredientType = 'RawMaterial' THEN rm.MaterialName
        WHEN ri.IngredientType = 'SubAssembly' THEN sp.Name
        ELSE ri.IngredientName
    END AS IngredientName,
    CASE 
        WHEN ri.IngredientType = 'RawMaterial' THEN rm.MaterialCode
        WHEN ri.IngredientType = 'SubAssembly' THEN sp.SKU
        ELSE NULL
    END AS IngredientCode,
    ri.Quantity,
    ri.UoM,
    ri.MaterialID,
    ri.SubAssemblyProductID,
    ri.Notes AS IngredientNotes,
    r.IsActive
FROM dbo.Recipe r
INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = r.ProductID
LEFT JOIN dbo.RecipeIngredient ri ON ri.RecipeID = r.RecipeID
LEFT JOIN dbo.RawMaterials rm ON rm.MaterialID = ri.MaterialID
LEFT JOIN dbo.Demo_Retail_Product sp ON sp.ProductID = ri.SubAssemblyProductID;
GO

PRINT '✅ Created vw_RecipeDetails view';
PRINT '';

-- =============================================
-- Sample Query: Calculate ingredients for order
-- =============================================
PRINT '=== Sample: Calculate ingredients for 120 units ===';
PRINT '';

DECLARE @OrderQty DECIMAL(18,4) = 120;
DECLARE @SampleProductID INT = (SELECT TOP 1 ProductID FROM dbo.Recipe WHERE IsActive = 1);

IF @SampleProductID IS NOT NULL
BEGIN
    SELECT 
        p.Name AS Product,
        r.BatchYield,
        @OrderQty AS OrderQuantity,
        CEILING(@OrderQty / r.BatchYield) AS BatchesNeeded,
        ri.LineNumber,
        CASE 
            WHEN ri.IngredientType = 'RawMaterial' THEN rm.MaterialName
            WHEN ri.IngredientType = 'SubAssembly' THEN sp.Name
            ELSE ri.IngredientName
        END AS Ingredient,
        ri.Quantity AS QtyPerBatch,
        ri.Quantity * CEILING(@OrderQty / r.BatchYield) AS TotalQtyNeeded,
        ri.UoM
    FROM dbo.Recipe r
    INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = r.ProductID
    INNER JOIN dbo.RecipeIngredient ri ON ri.RecipeID = r.RecipeID
    LEFT JOIN dbo.RawMaterials rm ON rm.MaterialID = ri.MaterialID
    LEFT JOIN dbo.Demo_Retail_Product sp ON sp.ProductID = ri.SubAssemblyProductID
    WHERE r.ProductID = @SampleProductID
      AND r.IsActive = 1
    ORDER BY ri.LineNumber;
END

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ SIMPLIFIED RECIPE SYSTEM CREATED!';
PRINT '';
PRINT '📋 New Tables:';
PRINT '  - Recipe (header with batch yield)';
PRINT '  - RecipeIngredient (simple grid of ingredients)';
PRINT '  - vw_RecipeDetails (easy query view)';
PRINT '';
PRINT '🎯 Next Steps:';
PRINT '  1. Update BOMEditorForm to use Recipe table';
PRINT '  2. Create new simplified Build My Product form';
PRINT '  3. Test with existing migrated recipes';
PRINT '═══════════════════════════════════════════════';
