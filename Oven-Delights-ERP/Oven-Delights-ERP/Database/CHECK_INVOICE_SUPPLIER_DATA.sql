-- Check actual invoice data for Eggs to see supplier information

PRINT '=== Check SupplierInvoiceLines for Eggs ==='
SELECT 
    sil.InvoiceLineID,
    sil.InvoiceID,
    sil.ItemID,
    sil.ItemSource,
    sil.Description,
    sil.Quantity,
    sil.UnitCost,
    si.InvoiceDate,
    si.SupplierID,
    s.SupplierName
FROM SupplierInvoiceLines sil
INNER JOIN SupplierInvoices si ON si.InvoiceID = sil.InvoiceID
INNER JOIN Suppliers s ON s.SupplierID = si.SupplierID
WHERE sil.ItemSource = 'PR'
  AND sil.ItemID IN (
      SELECT ProductID 
      FROM Demo_Retail_Product 
      WHERE Name = 'Eggs' AND BranchID = 6
  )
ORDER BY si.InvoiceDate DESC;

PRINT ''
PRINT '=== Check all invoice lines with suppliers ==='
SELECT TOP 20
    p.Name AS ProductName,
    sil.ItemID,
    si.InvoiceDate,
    si.SupplierID,
    s.SupplierName
FROM SupplierInvoiceLines sil
INNER JOIN SupplierInvoices si ON si.InvoiceID = sil.InvoiceID
INNER JOIN Suppliers s ON s.SupplierID = si.SupplierID
INNER JOIN Demo_Retail_Product p ON p.ProductID = sil.ItemID AND p.BranchID = 6
WHERE sil.ItemSource = 'PR'
ORDER BY si.InvoiceDate DESC;
