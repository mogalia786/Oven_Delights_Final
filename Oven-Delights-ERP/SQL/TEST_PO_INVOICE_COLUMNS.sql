-- =============================================
-- TEST PO AND INVOICE CAPTURE COLUMNS
-- =============================================
-- This script tests that ALL required columns are present
-- for BOTH raw materials AND sub-recipes
-- =============================================

-- Step 1: Create a test PO with both raw materials and sub-recipes
PRINT '=== STEP 1: CREATE TEST PO ==='

DECLARE @TestSupplierID INT = (SELECT TOP 1 SupplierID FROM Suppliers WHERE IsActive = 1)
DECLARE @TestBranchID INT = (SELECT TOP 1 BranchID FROM Branches)
DECLARE @TestPOID INT

-- Create test PO header
INSERT INTO PurchaseOrders (PONumber, SupplierID, BranchID, OrderDate, Status, SubTotal, VATAmount, CreatedDate, CreatedBy)
VALUES ('TEST-PO-001', @TestSupplierID, @TestBranchID, GETDATE(), 'Draft', 0, 0, GETDATE(), 1)

SET @TestPOID = SCOPE_IDENTITY()
PRINT 'Created Test PO ID: ' + CAST(@TestPOID AS VARCHAR)

-- Add a raw material line
DECLARE @RawMaterialID INT = (SELECT TOP 1 MaterialID FROM RawMaterials WHERE MaterialType = 'Raw' OR MaterialType = 'Ingredient')
IF @RawMaterialID IS NOT NULL
BEGIN
    INSERT INTO PurchaseOrderLines (PurchaseOrderID, MaterialID, ProductID, ItemSource, OrderedQuantity, UnitCost)
    VALUES (@TestPOID, @RawMaterialID, NULL, 'RM', 10, 5.00)
    PRINT 'Added Raw Material Line: MaterialID = ' + CAST(@RawMaterialID AS VARCHAR)
END

-- Add a sub-recipe line
DECLARE @SubRecipeID INT = (SELECT TOP 1 MaterialID FROM RawMaterials WHERE MaterialType LIKE '%recipe%' OR MaterialType LIKE '%sub%')
IF @SubRecipeID IS NOT NULL
BEGIN
    INSERT INTO PurchaseOrderLines (PurchaseOrderID, MaterialID, ProductID, ItemSource, OrderedQuantity, UnitCost)
    VALUES (@TestPOID, @SubRecipeID, NULL, 'RM', 5, 10.00)
    PRINT 'Added Sub-Recipe Line: MaterialID = ' + CAST(@SubRecipeID AS VARCHAR)
END
ELSE
BEGIN
    PRINT 'WARNING: No sub-recipes found in RawMaterials table!'
END

GO

-- Step 2: Test GetPurchaseOrderLines query (simulate what InvoiceCaptureForm sees)
PRINT ''
PRINT '=== STEP 2: SIMULATE GETPURCHASEORDERLINES QUERY ==='

DECLARE @TestPOID2 INT = (SELECT TOP 1 PurchaseOrderID FROM PurchaseOrders WHERE PONumber = 'TEST-PO-001')

SELECT 
    pol.MaterialID,
    pol.ProductID,
    CASE 
      WHEN rm.MaterialID IS NOT NULL THEN rm.MaterialCode 
      WHEN p.ProductID IS NOT NULL THEN p.SKU 
      ELSE COALESCE(CAST(pol.MaterialID AS NVARCHAR(20)), CAST(pol.ProductID AS NVARCHAR(20))) 
    END AS ProductCode,
    CASE 
      WHEN rm.MaterialID IS NOT NULL THEN rm.MaterialName 
      WHEN p.ProductID IS NOT NULL THEN p.Name 
      ELSE 'Unknown Item' 
    END AS ProductName,
    pol.OrderedQuantity AS OrderQuantity,
    ISNULL(pol.ReceivedQuantity, 0) AS ReceivedQuantity,
    pol.UnitCost,
    0 AS ReceiveNow,
    CASE 
      WHEN rm.MaterialID IS NOT NULL THEN 'Raw Material' 
      WHEN p.ProductID IS NOT NULL THEN 'Product' 
      ELSE 'Unknown Type' 
    END AS ProductType,
    rm.MaterialCode AS RawMaterialCode,
    rm.MaterialName AS RawMaterialName,
    rm.MaterialType,
    pol.ItemSource,
    -- Validation columns
    CASE WHEN pol.MaterialID IS NULL THEN '❌ NULL' ELSE '✅ OK' END AS MaterialID_Status,
    CASE WHEN rm.MaterialName IS NULL THEN '❌ NULL' ELSE '✅ OK' END AS MaterialName_Status,
    CASE WHEN rm.MaterialType IS NULL THEN '❌ NULL' ELSE '✅ OK' END AS MaterialType_Status
FROM PurchaseOrderLines pol 
LEFT JOIN RawMaterials rm ON pol.MaterialID = rm.MaterialID 
LEFT JOIN Demo_Retail_Product p ON pol.ProductID = p.ProductID 
WHERE pol.PurchaseOrderID = @TestPOID2

PRINT 'Check the results above:'
PRINT '- MaterialID should have values (not NULL)'
PRINT '- MaterialName should show actual names (not NULL or "Unknown Item")'
PRINT '- MaterialType should show "Raw", "Sub Recipe", etc.'
PRINT '- All Status columns should show ✅ OK'

GO

-- Step 3: Check what columns InvoiceCaptureForm will actually see
PRINT ''
PRINT '=== STEP 3: VERIFY REQUIRED COLUMNS FOR INVOICE CAPTURE ==='

DECLARE @TestPOID3 INT = (SELECT TOP 1 PurchaseOrderID FROM PurchaseOrders WHERE PONumber = 'TEST-PO-001')

-- This is what the DataGridView will show
SELECT 
    'MaterialID' AS ColumnName,
    CASE WHEN COUNT(CASE WHEN pol.MaterialID IS NOT NULL THEN 1 END) = COUNT(*) 
         THEN '✅ ALL ROWS HAVE VALUES' 
         ELSE '❌ SOME ROWS ARE NULL' 
    END AS Status,
    COUNT(*) AS TotalRows,
    COUNT(CASE WHEN pol.MaterialID IS NOT NULL THEN 1 END) AS RowsWithValue
FROM PurchaseOrderLines pol 
WHERE pol.PurchaseOrderID = @TestPOID3

UNION ALL

SELECT 
    'ProductName' AS ColumnName,
    CASE WHEN COUNT(CASE WHEN rm.MaterialName IS NOT NULL THEN 1 END) = COUNT(*) 
         THEN '✅ ALL ROWS HAVE VALUES' 
         ELSE '❌ SOME ROWS ARE NULL' 
    END AS Status,
    COUNT(*) AS TotalRows,
    COUNT(CASE WHEN rm.MaterialName IS NOT NULL THEN 1 END) AS RowsWithValue
FROM PurchaseOrderLines pol 
LEFT JOIN RawMaterials rm ON pol.MaterialID = rm.MaterialID
WHERE pol.PurchaseOrderID = @TestPOID3

UNION ALL

SELECT 
    'MaterialType' AS ColumnName,
    CASE WHEN COUNT(CASE WHEN rm.MaterialType IS NOT NULL THEN 1 END) = COUNT(*) 
         THEN '✅ ALL ROWS HAVE VALUES' 
         ELSE '❌ SOME ROWS ARE NULL' 
    END AS Status,
    COUNT(*) AS TotalRows,
    COUNT(CASE WHEN rm.MaterialType IS NOT NULL THEN 1 END) AS RowsWithValue
FROM PurchaseOrderLines pol 
LEFT JOIN RawMaterials rm ON pol.MaterialID = rm.MaterialID
WHERE pol.PurchaseOrderID = @TestPOID3

GO

-- Step 4: Simulate stock update logic
PRINT ''
PRINT '=== STEP 4: SIMULATE STOCK UPDATE LOGIC ==='

DECLARE @TestPOID4 INT = (SELECT TOP 1 PurchaseOrderID FROM PurchaseOrders WHERE PONumber = 'TEST-PO-001')
DECLARE @TestBranchID2 INT = (SELECT TOP 1 BranchID FROM Branches)

SELECT 
    pol.MaterialID,
    rm.MaterialName,
    rm.MaterialType,
    pol.OrderedQuantity,
    CASE 
        WHEN pol.MaterialID IS NULL THEN '❌ WILL FAIL - MaterialID is NULL'
        WHEN rm.MaterialName IS NULL THEN '❌ WILL FAIL - MaterialName is NULL (JOIN failed)'
        WHEN pol.MaterialID > 0 THEN '✅ WILL UPDATE StockroomStock'
        ELSE '❌ WILL FAIL - Invalid MaterialID'
    END AS StockUpdateStatus,
    'UPDATE StockroomStock SET Quantity = Quantity + ' + CAST(pol.OrderedQuantity AS VARCHAR) + 
    ' WHERE ProductID = ' + CAST(ISNULL(pol.MaterialID, 0) AS VARCHAR) + 
    ' AND BranchID = ' + CAST(@TestBranchID2 AS VARCHAR) AS SQLCommand
FROM PurchaseOrderLines pol 
LEFT JOIN RawMaterials rm ON pol.MaterialID = rm.MaterialID
WHERE pol.PurchaseOrderID = @TestPOID4

GO

-- Step 5: Cleanup test data
PRINT ''
PRINT '=== STEP 5: CLEANUP TEST DATA ==='

DECLARE @TestPOID5 INT = (SELECT TOP 1 PurchaseOrderID FROM PurchaseOrders WHERE PONumber = 'TEST-PO-001')

DELETE FROM PurchaseOrderLines WHERE PurchaseOrderID = @TestPOID5
DELETE FROM PurchaseOrders WHERE PurchaseOrderID = @TestPOID5

PRINT 'Test PO cleaned up'

GO

PRINT ''
PRINT '============================================='
PRINT 'TEST COMPLETE!'
PRINT '============================================='
PRINT ''
PRINT 'WHAT TO CHECK:'
PRINT '1. All MaterialID values should be populated (not NULL)'
PRINT '2. All MaterialName values should show actual names'
PRINT '3. MaterialType should show "Raw", "Sub Recipe", etc.'
PRINT '4. Stock update status should show ✅ for all rows'
PRINT ''
PRINT 'IF ANY CHECKS FAIL:'
PRINT '- The JOIN in GetPurchaseOrderLines is broken'
PRINT '- Sub-recipes are not in RawMaterials table'
PRINT '- ItemSource condition is blocking the JOIN'
