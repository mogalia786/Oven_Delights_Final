-- Check where component costs should come from for ingredients with POs/Invoices

DECLARE @ComponentName VARCHAR(100) = 'Flour'; -- Change to your component name

PRINT '=== Step 1: Check component in Demo_Retail_Product ==='
SELECT ProductID, Name, AverageCost, LastPaidPrice, BranchID
FROM Demo_Retail_Product
WHERE Name LIKE '%' + @ComponentName + '%'
ORDER BY BranchID;

PRINT ''
PRINT '=== Step 2: Check if component has purchase invoices ==='
SELECT TOP 10 
    si.InvoiceID,
    si.SupplierName,
    si.InvoiceDate,
    si.TotalAmount,
    sid.ProductID,
    p.Name AS ProductName,
    sid.Quantity,
    sid.UnitPrice,
    sid.TotalPrice
FROM SupplierInvoices si
INNER JOIN SupplierInvoiceDetails sid ON sid.InvoiceID = si.InvoiceID
INNER JOIN Demo_Retail_Product p ON p.ProductID = sid.ProductID
WHERE p.Name LIKE '%' + @ComponentName + '%'
ORDER BY si.InvoiceDate DESC;

PRINT ''
PRINT '=== Step 3: Check latest purchase price from invoices ==='
SELECT 
    p.ProductID,
    p.Name,
    MAX(si.InvoiceDate) AS LatestInvoiceDate,
    (SELECT TOP 1 sid2.UnitPrice 
     FROM SupplierInvoiceDetails sid2
     INNER JOIN SupplierInvoices si2 ON si2.InvoiceID = sid2.InvoiceID
     WHERE sid2.ProductID = p.ProductID
     ORDER BY si2.InvoiceDate DESC) AS LatestUnitPrice
FROM Demo_Retail_Product p
LEFT JOIN SupplierInvoiceDetails sid ON sid.ProductID = p.ProductID
LEFT JOIN SupplierInvoices si ON si.InvoiceID = sid.InvoiceID
WHERE p.Name LIKE '%' + @ComponentName + '%'
GROUP BY p.ProductID, p.Name;

PRINT ''
PRINT '=== Step 4: Check if SupplierInvoiceDetails table exists ==='
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SupplierInvoiceDetails'
ORDER BY ORDINAL_POSITION;
