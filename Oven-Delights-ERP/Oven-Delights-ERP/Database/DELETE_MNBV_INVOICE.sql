-- Delete mnbv test invoice
DELETE FROM SupplierInvoiceLines WHERE InvoiceID IN (SELECT InvoiceID FROM SupplierInvoices WHERE InvoiceNumber = 'mnbv')
DELETE FROM SupplierInvoices WHERE InvoiceNumber = 'mnbv'
DELETE FROM GoodsReceivedNotes WHERE DeliveryNote = 'mnbv'

-- Verify deletion
SELECT * FROM SupplierInvoices WHERE InvoiceNumber = 'mnbv'
SELECT * FROM GoodsReceivedNotes WHERE DeliveryNote = 'mnbv'
