-- Check what's actually saved in the database for INV-TEST700
SELECT 
    InvoiceID,
    InvoiceNumber,
    SubTotal,
    VATAmount,
    TotalAmount,
    DiscountAmount,
    DiscountPercent
FROM SupplierInvoices
WHERE InvoiceNumber = 'INV-TEST700'

-- Check the invoice lines
SELECT 
    sil.InvoiceLineID,
    sil.Description,
    sil.Quantity,
    sil.UnitPrice,
    sil.LineTotal,
    p.IsVatable
FROM SupplierInvoiceLines sil
LEFT JOIN Demo_Retail_Product p ON sil.ItemID = p.ProductID
WHERE sil.InvoiceID IN (SELECT InvoiceID FROM SupplierInvoices WHERE InvoiceNumber = 'INV-TEST700')
