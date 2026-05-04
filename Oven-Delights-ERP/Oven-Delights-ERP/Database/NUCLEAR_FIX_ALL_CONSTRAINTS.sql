-- NUCLEAR OPTION: Drop and recreate ALL default constraints on ALL tables with QUOTED_IDENTIFIER ON
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

PRINT 'Starting comprehensive constraint rebuild...';

-- Drop ALL default constraints on transaction tables
DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + 
               QUOTENAME(OBJECT_NAME(parent_object_id)) + 
               ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.default_constraints
WHERE OBJECT_NAME(parent_object_id) IN (
    'SupplierInvoices', 
    'SupplierInvoiceLines',
    'StockMovements', 
    'GoodsReceivedNotes', 
    'GoodsReceivedNoteLines',
    'SupplierLedger', 
    'GeneralLedger',
    'Demo_Retail_Product',
    'Demo_Retail_Price'
);

IF @sql <> ''
BEGIN
    PRINT 'Dropping all default constraints...';
    EXEC sp_executesql @sql;
    PRINT 'All default constraints dropped';
END

-- Recreate constraints with QUOTED_IDENTIFIER ON
PRINT 'Recreating constraints with QUOTED_IDENTIFIER ON...';

-- SupplierInvoices
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name = 'DF_SupplierInvoices_AmountPaid')
    ALTER TABLE SupplierInvoices ADD CONSTRAINT DF_SupplierInvoices_AmountPaid DEFAULT (0) FOR AmountPaid;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name = 'DF_SupplierInvoices_CreatedDate')
    ALTER TABLE SupplierInvoices ADD CONSTRAINT DF_SupplierInvoices_CreatedDate DEFAULT (GETDATE()) FOR CreatedDate;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name = 'DF_SupplierInvoices_Status')
    ALTER TABLE SupplierInvoices ADD CONSTRAINT DF_SupplierInvoices_Status DEFAULT ('Unpaid') FOR Status;
PRINT 'SupplierInvoices constraints created';

-- StockMovements
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name = 'DF_StockMovements_CreatedDate')
    ALTER TABLE StockMovements ADD CONSTRAINT DF_StockMovements_CreatedDate DEFAULT (GETDATE()) FOR CreatedDate;
PRINT 'StockMovements constraints created';

-- GoodsReceivedNotes
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name = 'DF_GoodsReceivedNotes_CreatedDate')
    ALTER TABLE GoodsReceivedNotes ADD CONSTRAINT DF_GoodsReceivedNotes_CreatedDate DEFAULT (GETDATE()) FOR CreatedDate;
PRINT 'GoodsReceivedNotes constraints created';

-- SupplierLedger
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name = 'DF_SupplierLedger_IsReversed')
    ALTER TABLE SupplierLedger ADD CONSTRAINT DF_SupplierLedger_IsReversed DEFAULT (0) FOR IsReversed;
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name = 'DF_SupplierLedger_CreatedDate')
    ALTER TABLE SupplierLedger ADD CONSTRAINT DF_SupplierLedger_CreatedDate DEFAULT (GETDATE()) FOR CreatedDate;
PRINT 'SupplierLedger constraints created';

-- GeneralLedger
IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE name = 'DF_GeneralLedger_CreatedDate')
    ALTER TABLE GeneralLedger ADD CONSTRAINT DF_GeneralLedger_CreatedDate DEFAULT (GETDATE()) FOR CreatedDate;
PRINT 'GeneralLedger constraints created';

PRINT '';
PRINT 'COMPREHENSIVE CONSTRAINT REBUILD COMPLETED';
PRINT 'All constraints now use QUOTED_IDENTIFIER ON';
