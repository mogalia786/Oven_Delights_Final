-- Check if ingredients have purchase invoice data

PRINT '=== Check if SupplierInvoiceLines has data for ingredients ==='
SELECT TOP 20
    p.ProductID,
    p.Name,
    p.Category,
    sil.UnitCost,
    si.InvoiceDate,
    si.Status
FROM Demo_Retail_Product p
LEFT JOIN SupplierInvoiceLines sil ON sil.ItemID = p.ProductID
LEFT JOIN SupplierInvoices si ON si.InvoiceID = sil.InvoiceID
WHERE p.Category LIKE '%ingredient%' OR p.Category LIKE '%pack%'
ORDER BY p.Name, si.InvoiceDate DESC;

PRINT ''
PRINT '=== Check specific ingredients from your screenshot ==='
SELECT 
    p.ProductID,
    p.Name,
    p.Category,
    COUNT(sil.InvoiceLineID) AS InvoiceCount,
    MAX(si.InvoiceDate) AS LatestInvoiceDate,
    (SELECT TOP 1 sil2.UnitCost 
     FROM SupplierInvoiceLines sil2
     INNER JOIN SupplierInvoices si2 ON si2.InvoiceID = sil2.InvoiceID
     WHERE sil2.ItemID = p.ProductID AND si2.Status != 'Cancelled'
     ORDER BY si2.InvoiceDate DESC) AS LatestUnitCost
FROM Demo_Retail_Product p
LEFT JOIN SupplierInvoiceLines sil ON sil.ItemID = p.ProductID
LEFT JOIN SupplierInvoices si ON si.InvoiceID = sil.InvoiceID
WHERE p.Name IN ('5*7*3', 'Choc milk block', 'Label White Keep In Fridge', 'Sugar White Huletts')
GROUP BY p.ProductID, p.Name, p.Category;

PRINT ''
PRINT '=== Check Demo_Retail_Product costs for these ingredients ==='
SELECT ProductID, Name, AverageCost, LastPaidPrice, Category
FROM Demo_Retail_Product
WHERE Name IN ('5*7*3', 'Choc milk block', 'Label White Keep In Fridge', 'Sugar White Huletts');
