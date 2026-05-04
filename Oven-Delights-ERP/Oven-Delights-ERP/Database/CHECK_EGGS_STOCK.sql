-- =====================================================
-- CHECK EGGS INVENTORY AND INVOICE CAPTURE ISSUE
-- Run this in Azure Data Studio or Azure Portal
-- =====================================================

PRINT '=== 1. EGGS IN Demo_Retail_Product (Retail/External Products) ==='
SELECT 
    ProductID,
    Name,
    ProductType,
    Category,
    CurrentStock,
    BranchID,
    IsActive
FROM Demo_Retail_Product
WHERE Name LIKE '%egg%'
ORDER BY ProductID, BranchID;

PRINT ''
PRINT '=== 2. EGGS IN RawMaterials (Ingredients) ==='
SELECT 
    MaterialID,
    MaterialName,
    MaterialCode,
    Category,
    CurrentStock,
    UnitOfMeasure,
    LastPaidPrice,
    LastPurchaseDate
FROM RawMaterials
WHERE MaterialName LIKE '%egg%'
ORDER BY MaterialID;

PRINT ''
PRINT '=== 3. RECENT PURCHASE ORDERS FOR EGGS ==='
SELECT TOP 20
    po.PONumber,
    po.Status AS POStatus,
    pol.ProductName,
    pol.ProductType,
    pol.MaterialID,
    pol.ProductID,
    pol.Quantity AS OrderedQty,
    pol.UnitCost,
    po.OrderDate,
    po.BranchID
FROM PurchaseOrderLines pol
INNER JOIN PurchaseOrders po ON pol.POID = po.POID
WHERE pol.ProductName LIKE '%egg%'
ORDER BY po.OrderDate DESC, pol.POLineID DESC;

PRINT ''
PRINT '=== 4. RECENT SUPPLIER INVOICES FOR EGGS ==='
SELECT TOP 20
    si.InvoiceNumber,
    si.InvoiceDate,
    si.SupplierID,
    s.CompanyName AS SupplierName,
    sil.Description,
    sil.Quantity,
    sil.UnitPrice,
    sil.LineTotal,
    si.BranchID
FROM SupplierInvoices si
INNER JOIN SupplierInvoiceLines sil ON si.InvoiceID = sil.InvoiceID
LEFT JOIN Suppliers s ON si.SupplierID = s.SupplierID
WHERE sil.Description LIKE '%egg%'
ORDER BY si.InvoiceDate DESC;

PRINT ''
PRINT '=== 5. EGGS PRICING IN Demo_Retail_Price ==='
SELECT 
    drp.ProductID,
    dp.Name AS ProductName,
    drp.BranchID,
    drp.CostPrice,
    drp.SellingPrice,
    drp.EffectiveFrom,
    drp.CreatedAt
FROM Demo_Retail_Price drp
INNER JOIN Demo_Retail_Product dp ON drp.ProductID = dp.ProductID
WHERE dp.Name LIKE '%egg%'
ORDER BY drp.ProductID, drp.BranchID;

PRINT ''
PRINT '=== DIAGNOSIS ==='
PRINT 'If eggs shows 0 stock in Demo_Retail_Product but you captured an invoice:'
PRINT '1. Check ProductType - should be "External" for retail products'
PRINT '2. Check if ProductID matches between PO lines and Demo_Retail_Product'
PRINT '3. Check if BranchID matches your current branch'
PRINT '4. If ProductType is "Ingredient" or contains "Material", stock goes to RawMaterials table instead'
PRINT '5. Invoice capture updates Demo_Retail_Product.CurrentStock for External products'
PRINT '6. Invoice capture updates RawMaterials.CurrentStock for Ingredients/Materials'
