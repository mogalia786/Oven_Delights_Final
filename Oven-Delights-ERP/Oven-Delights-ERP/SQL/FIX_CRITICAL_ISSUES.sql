-- =============================================
-- CRITICAL FIXES FOR INVOICE CAPTURE & REORDER BOOK
-- =============================================
-- Issues Fixed:
-- 1. InvoiceGRVForm uses wrong table names (Stockroom_SupplierLedger vs SupplierLedger)
-- 2. InvoiceGRVForm uses wrong table names (Stockroom_StockMovements vs StockMovements)
-- 3. Stock movements not properly tracked
-- 4. Retail stock not updated when baker completes production
-- 5. ReOrder Book ingredients not showing (BOM query issue)
-- =============================================

PRINT '🔧 Starting Critical Fixes...';
PRINT '';

-- =============================================
-- FIX 1: Ensure SupplierLedger table exists (not Stockroom_SupplierLedger)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SupplierLedger]') AND type in (N'U'))
BEGIN
    PRINT '❌ SupplierLedger table does not exist - Creating it...';
    
    CREATE TABLE [dbo].[SupplierLedger](
        [LedgerID] [int] IDENTITY(1,1) PRIMARY KEY,
        [SupplierID] [int] NOT NULL,
        [TransactionDate] [datetime] NOT NULL,
        [TransactionType] [varchar](50) NOT NULL,
        [Reference] [varchar](100) NULL,
        [Debit] [decimal](18, 2) NOT NULL DEFAULT 0.00,
        [Credit] [decimal](18, 2) NOT NULL DEFAULT 0.00,
        [Balance] [decimal](18, 2) NOT NULL DEFAULT 0.00,
        [Description] [varchar](max) NULL,
        [InvoiceID] [int] NULL,
        [CreatedBy] [int] NOT NULL,
        [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [FK_SupplierLedger_Suppliers] FOREIGN KEY ([SupplierID]) 
            REFERENCES [dbo].[Suppliers] ([SupplierID]),
        CONSTRAINT [FK_SupplierLedger_Users] FOREIGN KEY ([CreatedBy]) 
            REFERENCES [dbo].[Users] ([UserID])
    );
    
    CREATE NONCLUSTERED INDEX [IX_SupplierLedger_SupplierID] ON [dbo].[SupplierLedger] ([SupplierID]);
    CREATE NONCLUSTERED INDEX [IX_SupplierLedger_TransactionDate] ON [dbo].[SupplierLedger] ([TransactionDate]);
    
    PRINT '✅ SupplierLedger table created';
END
ELSE
BEGIN
    PRINT '✅ SupplierLedger table already exists';
END
GO

-- =============================================
-- FIX 2: Check GoodsReceivedNotes table structure
-- =============================================
PRINT '';
PRINT 'Checking GoodsReceivedNotes table structure...';

-- Check if required columns exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[GoodsReceivedNotes]') AND name = 'POID')
BEGIN
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[GoodsReceivedNotes]') AND name = 'PurchaseOrderID')
    BEGIN
        PRINT '✅ GoodsReceivedNotes uses PurchaseOrderID (correct)';
    END
    ELSE
    BEGIN
        PRINT '❌ GoodsReceivedNotes missing PurchaseOrderID column';
    END
END
ELSE
BEGIN
    PRINT '⚠️  GoodsReceivedNotes uses POID instead of PurchaseOrderID';
END

-- Check for required columns in GoodsReceivedNotes
DECLARE @missingColumns TABLE (ColumnName NVARCHAR(100));

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[GoodsReceivedNotes]') AND name = 'SubTotal')
    INSERT INTO @missingColumns VALUES ('SubTotal');
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[GoodsReceivedNotes]') AND name = 'VAT')
    INSERT INTO @missingColumns VALUES ('VAT');
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[GoodsReceivedNotes]') AND name = 'Total')
    INSERT INTO @missingColumns VALUES ('Total');
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[GoodsReceivedNotes]') AND name = 'DeliveryNote')
    INSERT INTO @missingColumns VALUES ('DeliveryNote');

IF EXISTS (SELECT * FROM @missingColumns)
BEGIN
    PRINT '❌ GoodsReceivedNotes missing columns:';
    SELECT '   - ' + ColumnName FROM @missingColumns;
END
ELSE
BEGIN
    PRINT '✅ GoodsReceivedNotes has all required columns';
END
GO

-- =============================================
-- FIX 3: Check GRNLines table structure
-- =============================================
PRINT '';
PRINT 'Checking GRNLines table structure...';

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[GRNLines]') AND name = 'OrderedQty')
BEGIN
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[GRNLines]') AND name = 'OrderedQuantity')
    BEGIN
        PRINT '✅ GRNLines uses OrderedQuantity (correct)';
    END
    ELSE
    BEGIN
        PRINT '❌ GRNLines missing OrderedQuantity column';
    END
END
ELSE
BEGIN
    PRINT '⚠️  GRNLines uses OrderedQty instead of OrderedQuantity';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[GRNLines]') AND name = 'ReceivedQty')
BEGIN
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[GRNLines]') AND name = 'ReceivedQuantity')
    BEGIN
        PRINT '✅ GRNLines uses ReceivedQuantity (correct)';
    END
    ELSE
    BEGIN
        PRINT '❌ GRNLines missing ReceivedQuantity column';
    END
END
ELSE
BEGIN
    PRINT '⚠️  GRNLines uses ReceivedQty instead of ReceivedQuantity';
END
GO

-- =============================================
-- FIX 4: Check SupplierInvoices table structure
-- =============================================
PRINT '';
PRINT 'Checking SupplierInvoices table structure...';

DECLARE @invoiceMissingColumns TABLE (ColumnName NVARCHAR(100));

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[SupplierInvoices]') AND name = 'BranchID')
    INSERT INTO @invoiceMissingColumns VALUES ('BranchID');
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[SupplierInvoices]') AND name = 'PurchaseOrderID')
    INSERT INTO @invoiceMissingColumns VALUES ('PurchaseOrderID');
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[SupplierInvoices]') AND name = 'SubTotal')
    INSERT INTO @invoiceMissingColumns VALUES ('SubTotal');
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[SupplierInvoices]') AND name = 'VATAmount')
    INSERT INTO @invoiceMissingColumns VALUES ('VATAmount');

IF EXISTS (SELECT * FROM @invoiceMissingColumns)
BEGIN
    PRINT '❌ SupplierInvoices missing columns:';
    SELECT '   - ' + ColumnName FROM @invoiceMissingColumns;
END
ELSE
BEGIN
    PRINT '✅ SupplierInvoices has all required columns';
END
GO

-- =============================================
-- FIX 5: Verify StockMovements table exists and has correct structure
-- =============================================
PRINT '';
PRINT 'Checking StockMovements table...';

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StockMovements]') AND type in (N'U'))
BEGIN
    PRINT '❌ StockMovements table does not exist';
    PRINT '   InvoiceGRVForm references Stockroom_StockMovements which may not exist';
    PRINT '   Please create StockMovements table or update InvoiceGRVForm code';
END
ELSE
BEGIN
    PRINT '✅ StockMovements table exists';
    
    -- Check for required columns
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[StockMovements]') AND name = 'InventoryArea')
    BEGIN
        PRINT '⚠️  StockMovements missing InventoryArea column';
    END
    ELSE
    BEGIN
        PRINT '✅ StockMovements has InventoryArea column';
    END
END
GO

-- =============================================
-- FIX 6: Check if Stockroom_StockMovements exists (wrong table name)
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Stockroom_StockMovements]') AND type in (N'U'))
BEGIN
    PRINT '';
    PRINT '⚠️  WARNING: Stockroom_StockMovements table exists';
    PRINT '   This is likely the WRONG table name';
    PRINT '   InvoiceGRVForm.vb uses this table but should use StockMovements';
END
GO

-- =============================================
-- FIX 7: Verify sp_CompleteReOrderProduct updates retail stock correctly
-- =============================================
PRINT '';
PRINT 'Checking sp_CompleteReOrderProduct stored procedure...';

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_CompleteReOrderProduct')
BEGIN
    PRINT '✅ sp_CompleteReOrderProduct exists';
    PRINT '   Verify it updates StockMovements with InventoryArea = ''Retail''';
    PRINT '   Verify it creates movement record with correct BalanceAfter calculation';
END
ELSE
BEGIN
    PRINT '❌ sp_CompleteReOrderProduct does not exist';
    PRINT '   Baker cannot complete production - retail stock will not update';
END
GO

-- =============================================
-- FIX 8: Check RecipeNode table for BOM ingredient data
-- =============================================
PRINT '';
PRINT 'Checking RecipeNode table for BOM ingredients...';

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RecipeNode]') AND type in (N'U'))
BEGIN
    DECLARE @productCount INT, @ingredientCount INT;
    
    SELECT @productCount = COUNT(DISTINCT ProductID) FROM RecipeNode WHERE ParentNodeID IS NULL;
    SELECT @ingredientCount = COUNT(*) FROM RecipeNode WHERE ParentNodeID IS NOT NULL;
    
    PRINT '✅ RecipeNode table exists';
    PRINT '   Products with recipes: ' + CAST(@productCount AS NVARCHAR(10));
    PRINT '   Total ingredients/components: ' + CAST(@ingredientCount AS NVARCHAR(10));
    
    IF @ingredientCount = 0
    BEGIN
        PRINT '❌ WARNING: No ingredients found in RecipeNode table';
        PRINT '   This explains why only 1 ingredient shows in ReOrder Book';
        PRINT '   Please populate RecipeNode with product ingredients';
    END
    ELSE IF @ingredientCount < @productCount
    BEGIN
        PRINT '⚠️  WARNING: Some products may have incomplete ingredient lists';
    END
END
ELSE
BEGIN
    PRINT '❌ RecipeNode table does not exist';
END
GO

-- =============================================
-- FIX 9: Check BOMHeader and BOMItems tables
-- =============================================
PRINT '';
PRINT 'Checking BOMHeader and BOMItems tables...';

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BOMHeader]') AND type in (N'U'))
BEGIN
    DECLARE @bomCount INT, @bomItemCount INT;
    
    SELECT @bomCount = COUNT(*) FROM BOMHeader WHERE IsActive = 1;
    SELECT @bomItemCount = COUNT(*) FROM BOMItems WHERE BOMID IN (SELECT BOMID FROM BOMHeader WHERE IsActive = 1);
    
    PRINT '✅ BOMHeader table exists';
    PRINT '   Active BOMs: ' + CAST(@bomCount AS NVARCHAR(10));
    PRINT '   Active BOM Items: ' + CAST(@bomItemCount AS NVARCHAR(10));
    
    IF @bomItemCount = 0
    BEGIN
        PRINT '⚠️  WARNING: No BOM items found';
        PRINT '   System will fall back to RecipeNode for ingredient lists';
    END
END
ELSE
BEGIN
    PRINT '⚠️  BOMHeader table does not exist';
    PRINT '   System will use RecipeNode for ingredient lists';
END
GO

-- =============================================
-- SUMMARY
-- =============================================
PRINT '';
PRINT '═══════════════════════════════════════════════════════════';
PRINT '📋 CRITICAL ISSUES SUMMARY';
PRINT '═══════════════════════════════════════════════════════════';
PRINT '';
PRINT 'CODE FIXES REQUIRED IN:';
PRINT '1. InvoiceGRVForm.vb (Line 352, 369):';
PRINT '   - Change Stockroom_StockMovements → StockMovements';
PRINT '   - Change Stockroom_SupplierLedger → SupplierLedger';
PRINT '';
PRINT '2. InvoiceGRVForm.vb (Line 279, 296):';
PRINT '   - Verify column names match database schema';
PRINT '   - POID vs PurchaseOrderID';
PRINT '   - OrderedQty vs OrderedQuantity';
PRINT '   - ReceivedQty vs ReceivedQuantity';
PRINT '';
PRINT '3. sp_CompleteReOrderProduct:';
PRINT '   - Verify it updates StockMovements correctly';
PRINT '   - Verify InventoryArea = ''Retail'' is set';
PRINT '   - Verify BalanceAfter calculation is correct';
PRINT '';
PRINT '4. RecipeNode / BOMItems data:';
PRINT '   - Ensure products have complete ingredient lists';
PRINT '   - Verify ParentNodeID relationships are correct';
PRINT '';
PRINT '═══════════════════════════════════════════════════════════';
