-- Disable the AmountOutstanding calculation trigger
DISABLE TRIGGER trg_SupplierInvoices_CalculateOutstanding ON SupplierInvoices;

PRINT 'Disabled trg_SupplierInvoices_CalculateOutstanding trigger'
PRINT 'Invoice capture should now work'
PRINT 'AmountOutstanding will need to be calculated manually or via stored procedure'
