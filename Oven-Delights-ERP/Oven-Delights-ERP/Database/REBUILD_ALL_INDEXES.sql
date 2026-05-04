-- Rebuild ALL indexes on transaction tables with QUOTED_IDENTIFIER ON
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

PRINT 'Rebuilding all indexes on transaction tables...';

-- Rebuild SupplierInvoices indexes
ALTER INDEX ALL ON SupplierInvoices REBUILD WITH (ONLINE = OFF);
PRINT 'SupplierInvoices indexes rebuilt';

-- Rebuild SupplierInvoiceLines indexes
ALTER INDEX ALL ON SupplierInvoiceLines REBUILD WITH (ONLINE = OFF);
PRINT 'SupplierInvoiceLines indexes rebuilt';

-- Rebuild StockMovements indexes
ALTER INDEX ALL ON StockMovements REBUILD WITH (ONLINE = OFF);
PRINT 'StockMovements indexes rebuilt';

-- Rebuild GoodsReceivedNotes indexes
ALTER INDEX ALL ON GoodsReceivedNotes REBUILD WITH (ONLINE = OFF);
PRINT 'GoodsReceivedNotes indexes rebuilt';

-- Rebuild SupplierLedger indexes
ALTER INDEX ALL ON SupplierLedger REBUILD WITH (ONLINE = OFF);
PRINT 'SupplierLedger indexes rebuilt';

-- Rebuild GeneralLedger indexes
ALTER INDEX ALL ON GeneralLedger REBUILD WITH (ONLINE = OFF);
PRINT 'GeneralLedger indexes rebuilt';

-- Rebuild Demo_Retail_Product indexes
ALTER INDEX ALL ON Demo_Retail_Product REBUILD WITH (ONLINE = OFF);
PRINT 'Demo_Retail_Product indexes rebuilt';

-- Rebuild Demo_Retail_Price indexes
ALTER INDEX ALL ON Demo_Retail_Price REBUILD WITH (ONLINE = OFF);
PRINT 'Demo_Retail_Price indexes rebuilt';

PRINT '';
PRINT 'ALL INDEXES REBUILT WITH QUOTED_IDENTIFIER ON';
