-- Create views for Material Flow Reporting across Stockroom, Manufacturing, and Retail
-- These views provide clear differentiation between Raw Materials and Ready-Made Products

-- 1. Stockroom Inventory Report View
CREATE OR ALTER VIEW vw_StockroomInventoryReport AS
SELECT 
    sp.ProductID,
    sp.SKU,
    sp.Code,
    sp.ProductName,
    sp.Category,
    sp.MaterialType,
    sp.DestinationModule,
    sp.StockQuantity,
    sp.ReorderPoint,
    sp.UnitPrice,
    CASE 
        WHEN sp.StockQuantity <= sp.ReorderPoint THEN 'Reorder Required'
        WHEN sp.StockQuantity <= (sp.ReorderPoint * 1.5) THEN 'Low Stock'
        ELSE 'Adequate Stock'
    END AS StockStatus,
    sp.BranchID,
    sp.IsActive,
    sp.CreatedDate,
    sp.ModifiedDate
FROM dbo.Stockroom_Product sp
WHERE sp.IsActive = 1
GO

-- 2. Raw Materials Report View (for Manufacturing)
CREATE OR ALTER VIEW vw_RawMaterialsReport AS
SELECT 
    sp.ProductID,
    sp.SKU,
    sp.Code,
    sp.ProductName,
    sp.Category,
    sp.StockQuantity,
    sp.ReorderPoint,
    sp.UnitPrice,
    CASE 
        WHEN sp.StockQuantity <= sp.ReorderPoint THEN 'Reorder Required'
        WHEN sp.StockQuantity <= (sp.ReorderPoint * 1.5) THEN 'Low Stock'
        ELSE 'Adequate Stock'
    END AS StockStatus,
    sp.BranchID,
    'Raw Material for Manufacturing' AS Purpose
FROM dbo.Stockroom_Product sp
WHERE sp.IsActive = 1 
    AND sp.MaterialType = 'Raw Material'
    AND sp.DestinationModule IN ('Manufacturing', 'Both')
GO

-- 3. Ready-Made Products Report View (for Retail)
CREATE OR ALTER VIEW vw_ReadyMadeProductsReport AS
SELECT 
    sp.ProductID,
    sp.SKU,
    sp.Code,
    sp.ProductName,
    sp.Category,
    sp.StockQuantity,
    sp.ReorderPoint,
    sp.UnitPrice,
    CASE 
        WHEN sp.StockQuantity <= sp.ReorderPoint THEN 'Reorder Required'
        WHEN sp.StockQuantity <= (sp.ReorderPoint * 1.5) THEN 'Low Stock'
        ELSE 'Adequate Stock'
    END AS StockStatus,
    sp.BranchID,
    'Ready-Made Product for Retail' AS Purpose
FROM dbo.Stockroom_Product sp
WHERE sp.IsActive = 1 
    AND sp.MaterialType = 'Ready-Made Product'
    AND sp.DestinationModule IN ('Retail', 'Both')
GO

-- 4. Manufacturing Products Report View
CREATE OR ALTER VIEW vw_ManufacturingProductsReport AS
SELECT 
    mp.ProductID,
    mp.SKU,
    mp.Code,
    mp.ProductName,
    mp.Category,
    mp.UnitCost,
    mp.ProductionTime,
    mp.BranchID,
    mp.IsActive,
    'Manufactured Product' AS ProductType,
    mp.CreatedDate,
    mp.ModifiedDate
FROM dbo.Manufacturing_Product mp
WHERE mp.IsActive = 1
GO

-- 5. Retail Products Report View
CREATE OR ALTER VIEW vw_RetailProductsReport AS
SELECT 
    rp.ProductID,
    rp.SKU,
    rp.Code,
    rp.Name AS ProductName,
    rp.Category,
    rpr.SellingPrice AS UnitPrice,
    rst.QtyOnHand AS StockQuantity,
    rst.ReorderPoint,
    CASE 
        WHEN EXISTS (SELECT 1 FROM dbo.Manufacturing_Product mp WHERE mp.SKU = rp.SKU)
        THEN 'Manufactured Product'
        ELSE 'Ready-Made Product'
    END AS ProductOrigin,
    CASE 
        WHEN rst.QtyOnHand <= rst.ReorderPoint THEN 'Reorder Required'
        WHEN rst.QtyOnHand <= (rst.ReorderPoint * 1.5) THEN 'Low Stock'
        ELSE 'Adequate Stock'
    END AS StockStatus,
    rpr.BranchID,
    rp.IsActive,
    rp.CreatedAt AS CreatedDate,
    rp.UpdatedAt AS ModifiedDate
FROM dbo.Retail_Product rp
LEFT JOIN dbo.Retail_Variant rv ON rv.ProductID = rp.ProductID AND rv.IsActive = 1
LEFT JOIN dbo.Retail_Stock rst ON rst.VariantID = rv.VariantID
LEFT JOIN dbo.Retail_Price rpr ON rpr.ProductID = rp.ProductID AND rpr.EffectiveTo IS NULL
WHERE rp.IsActive = 1
GO

-- 6. Complete Material Flow Report View
CREATE OR ALTER VIEW vw_MaterialFlowReport AS
SELECT 
    'Stockroom' AS Module,
    'Raw Material' AS ItemType,
    sp.ProductName,
    sp.SKU,
    sp.Code,
    sp.Category,
    sp.StockQuantity AS Quantity,
    sp.UnitPrice AS Price,
    'For Manufacturing' AS Purpose,
    sp.BranchID
FROM dbo.Stockroom_Product sp
WHERE sp.IsActive = 1 AND sp.MaterialType = 'Raw Material'

UNION ALL

SELECT 
    'Stockroom' AS Module,
    'Ready-Made Product' AS ItemType,
    sp.ProductName,
    sp.SKU,
    sp.Code,
    sp.Category,
    sp.StockQuantity AS Quantity,
    sp.UnitPrice AS Price,
    'For Retail' AS Purpose,
    sp.BranchID
FROM dbo.Stockroom_Product sp
WHERE sp.IsActive = 1 AND sp.MaterialType = 'Ready-Made Product'

UNION ALL

SELECT 
    'Manufacturing' AS Module,
    'Manufactured Product' AS ItemType,
    mp.ProductName,
    mp.SKU,
    mp.Code,
    mp.Category,
    NULL AS Quantity,
    mp.UnitCost AS Price,
    'For Retail' AS Purpose,
    mp.BranchID
FROM dbo.Manufacturing_Product mp
WHERE mp.IsActive = 1

UNION ALL

SELECT 
    'Retail' AS Module,
    CASE 
        WHEN EXISTS (SELECT 1 FROM dbo.Manufacturing_Product mp WHERE mp.SKU = rp.SKU)
        THEN 'Manufactured Product'
        ELSE 'Ready-Made Product'
    END AS ItemType,
    rp.Name AS ProductName,
    rp.SKU,
    rp.Code,
    rp.Category,
    rst.QtyOnHand AS Quantity,
    rpr.SellingPrice AS Price,
    'For Sale' AS Purpose,
    rpr.BranchID
FROM dbo.Retail_Product rp
LEFT JOIN dbo.Retail_Variant rv ON rv.ProductID = rp.ProductID AND rv.IsActive = 1
LEFT JOIN dbo.Retail_Stock rst ON rst.VariantID = rv.VariantID
LEFT JOIN dbo.Retail_Price rpr ON rpr.ProductID = rp.ProductID AND rpr.EffectiveTo IS NULL
WHERE rp.IsActive = 1
GO

PRINT 'Material Flow Reporting Views Created Successfully!'
PRINT 'Available Views:'
PRINT '- vw_StockroomInventoryReport: Complete stockroom inventory'
PRINT '- vw_RawMaterialsReport: Raw materials for manufacturing'
PRINT '- vw_ReadyMadeProductsReport: Ready-made products for retail'
PRINT '- vw_ManufacturingProductsReport: Manufactured products'
PRINT '- vw_RetailProductsReport: Retail products with origin classification'
PRINT '- vw_MaterialFlowReport: Complete material flow across all modules'
