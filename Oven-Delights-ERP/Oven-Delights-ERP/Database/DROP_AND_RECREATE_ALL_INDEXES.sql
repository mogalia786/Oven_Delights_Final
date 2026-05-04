-- DROP and RECREATE all indexes with QUOTED_IDENTIFIER ON
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

PRINT 'Dropping and recreating all non-primary key indexes...';

-- Drop all non-clustered indexes on SupplierInvoices (keep primary key)
DROP INDEX IF EXISTS IX_SupplierInvoices_Branch ON SupplierInvoices;
DROP INDEX IF EXISTS IX_SupplierInvoices_Date ON SupplierInvoices;
DROP INDEX IF EXISTS IX_SupplierInvoices_Status ON SupplierInvoices;
DROP INDEX IF EXISTS IX_SupplierInvoices_Supplier ON SupplierInvoices;
DROP INDEX IF EXISTS UQ_SupplierInvoices_Number ON SupplierInvoices;

-- Drop all non-clustered indexes on SupplierLedger (keep primary key)
DROP INDEX IF EXISTS IX_SupplierLedger_Date ON SupplierLedger;
DROP INDEX IF EXISTS IX_SupplierLedger_Supplier ON SupplierLedger;
DROP INDEX IF EXISTS IX_SupplierLedger_Type ON SupplierLedger;

-- Drop all non-clustered indexes on GeneralLedger (keep primary key)
DROP INDEX IF EXISTS IX_GeneralLedger_Account ON GeneralLedger;
DROP INDEX IF EXISTS IX_GeneralLedger_Date ON GeneralLedger;
DROP INDEX IF EXISTS IX_GeneralLedger_JournalEntry ON GeneralLedger;
DROP INDEX IF EXISTS IX_GeneralLedger_Reference ON GeneralLedger;

-- Drop all non-clustered indexes on StockMovements (keep primary key)
DROP INDEX IF EXISTS IX_StockMovements_Area_Material ON StockMovements;
DROP INDEX IF EXISTS IX_StockMovements_MaterialID_Date ON StockMovements;
DROP INDEX IF EXISTS IX_StockMovements_ReceivedBy ON StockMovements;
DROP INDEX IF EXISTS IX_StockMovements_RequestedBy ON StockMovements;

-- Drop all non-clustered indexes on GoodsReceivedNotes (keep primary key)
DROP INDEX IF EXISTS IX_GoodsRecNotes_Branch ON GoodsReceivedNotes;

PRINT 'All non-primary key indexes dropped';

-- Recreate indexes with QUOTED_IDENTIFIER ON
PRINT 'Recreating indexes with QUOTED_IDENTIFIER ON...';

-- SupplierInvoices indexes
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_SupplierInvoices_Branch' AND object_id = OBJECT_ID('SupplierInvoices'))
    CREATE NONCLUSTERED INDEX IX_SupplierInvoices_Branch ON SupplierInvoices(BranchID);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_SupplierInvoices_Date' AND object_id = OBJECT_ID('SupplierInvoices'))
    CREATE NONCLUSTERED INDEX IX_SupplierInvoices_Date ON SupplierInvoices(InvoiceDate);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_SupplierInvoices_Status' AND object_id = OBJECT_ID('SupplierInvoices'))
    CREATE NONCLUSTERED INDEX IX_SupplierInvoices_Status ON SupplierInvoices(Status);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_SupplierInvoices_Supplier' AND object_id = OBJECT_ID('SupplierInvoices'))
    CREATE NONCLUSTERED INDEX IX_SupplierInvoices_Supplier ON SupplierInvoices(SupplierID);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_SupplierInvoices_Number' AND object_id = OBJECT_ID('SupplierInvoices'))
    CREATE NONCLUSTERED INDEX IX_SupplierInvoices_Number ON SupplierInvoices(InvoiceNumber);
PRINT 'SupplierInvoices indexes recreated';

-- SupplierLedger indexes
CREATE NONCLUSTERED INDEX IX_SupplierLedger_Date ON SupplierLedger(TransactionDate);
CREATE NONCLUSTERED INDEX IX_SupplierLedger_Supplier ON SupplierLedger(SupplierID);
CREATE NONCLUSTERED INDEX IX_SupplierLedger_Type ON SupplierLedger(TransactionType);
PRINT 'SupplierLedger indexes recreated';

-- GeneralLedger indexes
CREATE NONCLUSTERED INDEX IX_GeneralLedger_Account ON GeneralLedger(AccountID);
CREATE NONCLUSTERED INDEX IX_GeneralLedger_Date ON GeneralLedger(TransactionDate);
CREATE NONCLUSTERED INDEX IX_GeneralLedger_Reference ON GeneralLedger(ReferenceID);
PRINT 'GeneralLedger indexes recreated';

-- StockMovements indexes
CREATE NONCLUSTERED INDEX IX_StockMovements_Area_Material ON StockMovements(InventoryArea, MaterialID);
CREATE NONCLUSTERED INDEX IX_StockMovements_MaterialID_Date ON StockMovements(MaterialID, MovementDate);
CREATE NONCLUSTERED INDEX IX_StockMovements_ReceivedBy ON StockMovements(ReceivedBy);
CREATE NONCLUSTERED INDEX IX_StockMovements_RequestedBy ON StockMovements(RequestedBy);
PRINT 'StockMovements indexes recreated';

-- GoodsReceivedNotes indexes
CREATE NONCLUSTERED INDEX IX_GoodsRecNotes_Branch ON GoodsReceivedNotes(BranchID);
PRINT 'GoodsReceivedNotes indexes recreated';

PRINT '';
PRINT 'ALL INDEXES DROPPED AND RECREATED WITH QUOTED_IDENTIFIER ON';
