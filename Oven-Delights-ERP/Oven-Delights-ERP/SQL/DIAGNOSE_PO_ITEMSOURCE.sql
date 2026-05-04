-- =============================================
-- DIAGNOSE PO LINES ITEMSOURCE ISSUE
-- =============================================
-- Check if ItemSource is properly set for sub-recipes
-- =============================================

-- Step 1: Check if ItemSource column exists
PRINT '=== CHECKING PURCHASEORDERLINES STRUCTURE ==='
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'PurchaseOrderLines'
ORDER BY ORDINAL_POSITION
GO

-- Step 2: Check actual ItemSource values
PRINT ''
PRINT '=== ITEMSOURCE VALUES IN PURCHASEORDERLINES ==='
SELECT 
    ItemSource,
    COUNT(*) AS Count
FROM PurchaseOrderLines
GROUP BY ItemSource
GO

-- Step 3: Check for NULL ItemSource with MaterialID
PRINT ''
PRINT '=== PO LINES WITH NULL ITEMSOURCE BUT HAVE MATERIALID ==='
SELECT TOP 20
    pol.PurchaseOrderID,
    pol.MaterialID,
    pol.ProductID,
    pol.ItemSource,
    pol.OrderedQuantity,
    rm.MaterialName,
    rm.MaterialType
FROM PurchaseOrderLines pol
LEFT JOIN RawMaterials rm ON rm.MaterialID = pol.MaterialID
WHERE pol.MaterialID IS NOT NULL
AND (pol.ItemSource IS NULL OR pol.ItemSource = '')
ORDER BY pol.PurchaseOrderID DESC
GO

-- Step 4: Simulate GetPurchaseOrderLines for latest PO
PRINT ''
PRINT '=== SIMULATING GETPURCHASEORDERLINES QUERY ==='
DECLARE @TestPOID INT = (SELECT TOP 1 PurchaseOrderID FROM PurchaseOrderLines ORDER BY PurchaseOrderID DESC)

SELECT 
    pol.MaterialID,
    pol.ProductID,
    pol.ItemSource,
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
    rm.MaterialName AS RawMaterialName_Direct,
    rm.MaterialType,
    'JOIN FAILED!' AS Issue
FROM PurchaseOrderLines pol 
LEFT JOIN RawMaterials rm ON pol.ItemSource = 'RM' AND pol.MaterialID = rm.MaterialID 
LEFT JOIN Demo_Retail_Product p ON pol.ItemSource = 'PR' AND pol.ProductID = p.ProductID 
WHERE pol.PurchaseOrderID = @TestPOID
AND rm.MaterialID IS NULL  -- Show only rows where join failed
AND pol.MaterialID IS NOT NULL  -- But MaterialID exists

PRINT 'Testing PO ID: ' + CAST(@TestPOID AS VARCHAR)
GO

-- Step 5: Show what it SHOULD look like with fixed join
PRINT ''
PRINT '=== FIXED QUERY (WITHOUT ITEMSOURCE CONDITION) ==='
DECLARE @TestPOID2 INT = (SELECT TOP 1 PurchaseOrderID FROM PurchaseOrderLines ORDER BY PurchaseOrderID DESC)

SELECT 
    pol.MaterialID,
    pol.ProductID,
    pol.ItemSource,
    rm.MaterialCode AS ProductCode,
    rm.MaterialName AS ProductName,
    rm.MaterialType,
    'FIXED!' AS Status
FROM PurchaseOrderLines pol 
LEFT JOIN RawMaterials rm ON pol.MaterialID = rm.MaterialID  -- REMOVED ItemSource condition
LEFT JOIN Demo_Retail_Product p ON pol.ProductID = p.ProductID 
WHERE pol.PurchaseOrderID = @TestPOID2

PRINT 'Testing PO ID: ' + CAST(@TestPOID2 AS VARCHAR)
GO
