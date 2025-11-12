-- =============================================
-- DEBUG PURCHASE ORDER LINES
-- =============================================
-- This script helps debug what's in your PO lines
-- =============================================

-- Step 1: Check PurchaseOrderLines structure
PRINT 'PurchaseOrderLines table columns:'
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'PurchaseOrderLines'
ORDER BY ORDINAL_POSITION
GO

-- Step 2: Check actual PO line data
PRINT 'Sample PurchaseOrderLines data:'
SELECT TOP 10
    PurchaseOrderID,
    MaterialID,
    ProductID,
    ItemSource,
    OrderedQuantity,
    UnitCost
FROM PurchaseOrderLines
ORDER BY PurchaseOrderID DESC
GO

-- Step 3: Check if MaterialID is NULL for raw materials
PRINT 'PO Lines with NULL MaterialID but ItemSource = RM:'
SELECT 
    pol.PurchaseOrderID,
    pol.MaterialID,
    pol.ProductID,
    pol.ItemSource,
    pol.OrderedQuantity
FROM PurchaseOrderLines pol
WHERE pol.ItemSource = 'RM'
AND pol.MaterialID IS NULL
GO

-- Step 4: Check RawMaterials with sub-recipes
PRINT 'Sub-recipes in RawMaterials:'
SELECT 
    MaterialID,
    MaterialCode,
    MaterialName,
    MaterialType,
    CurrentStock
FROM RawMaterials
WHERE MaterialType LIKE '%recipe%'
OR MaterialType LIKE '%sub%'
ORDER BY MaterialName
GO

-- Step 5: Simulate the GetPurchaseOrderLines query
PRINT 'Simulating GetPurchaseOrderLines query for latest PO:'
DECLARE @LatestPOID INT = (SELECT TOP 1 PurchaseOrderID FROM PurchaseOrderLines ORDER BY PurchaseOrderID DESC)

SELECT 
    pol.MaterialID,
    pol.ProductID,
    CASE 
      WHEN pol.ItemSource = 'RM' AND rm.MaterialID IS NOT NULL THEN rm.MaterialCode 
      WHEN pol.ItemSource = 'PR' AND p.ProductID IS NOT NULL THEN p.SKU 
      ELSE COALESCE(CAST(pol.MaterialID AS NVARCHAR(20)), CAST(pol.ProductID AS NVARCHAR(20))) 
    END AS ProductCode,
    CASE 
      WHEN pol.ItemSource = 'RM' AND rm.MaterialID IS NOT NULL THEN rm.MaterialName 
      WHEN pol.ItemSource = 'PR' AND p.ProductID IS NOT NULL THEN p.Name 
      ELSE 'Unknown Item' 
    END AS ProductName,
    pol.OrderedQuantity AS OrderQuantity,
    ISNULL(pol.ReceivedQuantity, 0) AS ReceivedQuantity,
    pol.UnitCost,
    CASE 
      WHEN pol.ItemSource = 'RM' THEN 'Raw Material' 
      WHEN pol.ItemSource = 'PR' THEN 'Product' 
      ELSE 'Unknown Type' 
    END AS ProductType,
    rm.MaterialType,
    pol.ItemSource
FROM PurchaseOrderLines pol 
LEFT JOIN RawMaterials rm ON pol.ItemSource = 'RM' AND pol.MaterialID = rm.MaterialID 
LEFT JOIN Demo_Retail_Product p ON pol.ItemSource = 'PR' AND pol.ProductID = p.ProductID 
WHERE pol.PurchaseOrderID = @LatestPOID

PRINT 'PO ID: ' + CAST(@LatestPOID AS VARCHAR)
GO
