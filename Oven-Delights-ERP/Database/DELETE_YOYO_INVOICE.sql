-- Delete YOYO test invoice
DELETE FROM SupplierInvoiceLines WHERE InvoiceID IN (SELECT InvoiceID FROM SupplierInvoices WHERE InvoiceNumber = 'YOYO')
DELETE FROM SupplierInvoices WHERE InvoiceNumber = 'YOYO'
DELETE FROM GoodsReceivedNotes WHERE DeliveryNote = 'YOYO'

-- Verify deletion
SELECT * FROM SupplierInvoices WHERE InvoiceNumber = 'YOYO'
SELECT * FROM GoodsReceivedNotes WHERE DeliveryNote = 'YOYO'
