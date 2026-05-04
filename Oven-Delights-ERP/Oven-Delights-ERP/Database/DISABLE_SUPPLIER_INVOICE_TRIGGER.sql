-- =============================================
-- Disable trg_SyncSupplierInvoiceToAP trigger temporarily
-- This allows invoice capture to work while we investigate
-- =============================================

PRINT 'Disabling trg_SyncSupplierInvoiceToAP trigger...'

IF OBJECT_ID('trg_SyncSupplierInvoiceToAP', 'TR') IS NOT NULL
BEGIN
    DISABLE TRIGGER trg_SyncSupplierInvoiceToAP ON SupplierInvoices;
    PRINT 'Trigger disabled successfully'
    PRINT 'Invoice capture should now work'
    PRINT ''
    PRINT 'NOTE: Supplier invoices will NOT auto-sync to AP_Invoices while trigger is disabled'
END
ELSE
BEGIN
    PRINT 'Trigger does not exist'
END
GO
