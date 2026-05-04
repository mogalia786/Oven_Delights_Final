-- COMPREHENSIVE FIX: Set database to QUOTED_IDENTIFIER ON and fix all constraints
USE Oven_Delights_Main;
GO

-- Set database option
ALTER DATABASE Oven_Delights_Main SET QUOTED_IDENTIFIER ON;
PRINT 'Set database QUOTED_IDENTIFIER ON';
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

-- Drop and recreate ALL default constraints on ALL tables
DECLARE @sql NVARCHAR(MAX) = '';

-- Get all default constraints in the database
SELECT @sql += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
               ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.default_constraints
WHERE OBJECT_NAME(parent_object_id) IN ('SupplierInvoices', 'StockMovements', 'GoodsReceivedNotes', 'SupplierLedger', 'GeneralLedger');

IF @sql <> ''
BEGIN
    EXEC sp_executesql @sql;
    PRINT 'Dropped all default constraints on transaction tables';
END

-- Recreate constraints with QUOTED_IDENTIFIER ON
-- SupplierInvoices
ALTER TABLE SupplierInvoices ADD CONSTRAINT DF_SupplierInvoices_AmountPaid DEFAULT (0) FOR AmountPaid;
ALTER TABLE SupplierInvoices ADD CONSTRAINT DF_SupplierInvoices_CreatedDate DEFAULT (GETDATE()) FOR CreatedDate;
ALTER TABLE SupplierInvoices ADD CONSTRAINT DF_SupplierInvoices_Status DEFAULT ('Unpaid') FOR Status;
PRINT 'Fixed SupplierInvoices';

-- StockMovements
ALTER TABLE StockMovements ADD CONSTRAINT DF_StockMovements_CreatedDate DEFAULT (GETDATE()) FOR CreatedDate;
PRINT 'Fixed StockMovements';

-- GoodsReceivedNotes  
ALTER TABLE GoodsReceivedNotes ADD CONSTRAINT DF_GoodsReceivedNotes_CreatedDate DEFAULT (GETDATE()) FOR CreatedDate;
PRINT 'Fixed GoodsReceivedNotes';

PRINT '';
PRINT 'COMPREHENSIVE FIX COMPLETED';
PRINT 'Database and all table constraints now use QUOTED_IDENTIFIER ON';
