-- =============================================
-- FIX PURCHASE ORDER TABLES FOR INVOICE CAPTURE
-- =============================================

-- Add missing columns to Stockroom_PurchaseOrders
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Stockroom_PurchaseOrders') AND name = 'BranchID')
BEGIN
    ALTER TABLE Stockroom_PurchaseOrders ADD BranchID INT NULL;
    PRINT '✅ BranchID added to Stockroom_PurchaseOrders';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Stockroom_PurchaseOrders') AND name = 'SADStar')
BEGIN
    ALTER TABLE Stockroom_PurchaseOrders ADD SADStar NVARCHAR(50) NULL;
    PRINT '✅ SADStar added to Stockroom_PurchaseOrders';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Stockroom_PurchaseOrders') AND name = 'SDAmount')
BEGIN
    ALTER TABLE Stockroom_PurchaseOrders ADD SDAmount DECIMAL(18,2) NULL DEFAULT 0;
    PRINT '✅ SDAmount added to Stockroom_PurchaseOrders';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Stockroom_PurchaseOrders') AND name = 'GBVID')
BEGIN
    ALTER TABLE Stockroom_PurchaseOrders ADD GBVID NVARCHAR(50) NULL;
    PRINT '✅ GBVID added to Stockroom_PurchaseOrders';
END
GO

-- Add missing columns to Stockroom_PurchaseOrderLines
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Stockroom_PurchaseOrderLines') AND name = 'ReceivedNow')
BEGIN
    ALTER TABLE Stockroom_PurchaseOrderLines ADD ReceivedNow DECIMAL(18,3) NULL DEFAULT 0;
    PRINT '✅ ReceivedNow added to Stockroom_PurchaseOrderLines';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Stockroom_PurchaseOrderLines') AND name = 'ReturnQty')
BEGIN
    ALTER TABLE Stockroom_PurchaseOrderLines ADD ReturnQty DECIMAL(18,3) NULL DEFAULT 0;
    PRINT '✅ ReturnQty added to Stockroom_PurchaseOrderLines';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Stockroom_PurchaseOrderLines') AND name = 'CreditReason')
BEGIN
    ALTER TABLE Stockroom_PurchaseOrderLines ADD CreditReason NVARCHAR(200) NULL;
    PRINT '✅ CreditReason added to Stockroom_PurchaseOrderLines';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Stockroom_PurchaseOrderLines') AND name = 'CreditComment')
BEGIN
    ALTER TABLE Stockroom_PurchaseOrderLines ADD CreditComment NVARCHAR(500) NULL;
    PRINT '✅ CreditComment added to Stockroom_PurchaseOrderLines';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Stockroom_PurchaseOrderLines') AND name = 'ProductType')
BEGIN
    ALTER TABLE Stockroom_PurchaseOrderLines ADD ProductType NVARCHAR(20) NULL;
    PRINT '✅ ProductType added to Stockroom_PurchaseOrderLines';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Stockroom_PurchaseOrderLines') AND name = 'RawMaterialID')
BEGIN
    ALTER TABLE Stockroom_PurchaseOrderLines ADD RawMaterialID INT NULL;
    PRINT '✅ RawMaterialID added to Stockroom_PurchaseOrderLines';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Stockroom_PurchaseOrderLines') AND name = 'RawMaterialCode')
BEGIN
    ALTER TABLE Stockroom_PurchaseOrderLines ADD RawMaterialCode NVARCHAR(50) NULL;
    PRINT '✅ RawMaterialCode added to Stockroom_PurchaseOrderLines';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Stockroom_PurchaseOrderLines') AND name = 'RawMaterialName')
BEGIN
    ALTER TABLE Stockroom_PurchaseOrderLines ADD RawMaterialName NVARCHAR(200) NULL;
    PRINT '✅ RawMaterialName added to Stockroom_PurchaseOrderLines';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Stockroom_PurchaseOrderLines') AND name = 'ProductCode')
BEGIN
    ALTER TABLE Stockroom_PurchaseOrderLines ADD ProductCode NVARCHAR(50) NULL;
    PRINT '✅ ProductCode added to Stockroom_PurchaseOrderLines';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Stockroom_PurchaseOrderLines') AND name = 'ProductName')
BEGIN
    ALTER TABLE Stockroom_PurchaseOrderLines ADD ProductName NVARCHAR(200) NULL;
    PRINT '✅ ProductName added to Stockroom_PurchaseOrderLines';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Stockroom_PurchaseOrderLines') AND name = 'AmountOutstanding')
BEGIN
    ALTER TABLE Stockroom_PurchaseOrderLines ADD AmountOutstanding DECIMAL(18,2) NULL DEFAULT 0;
    PRINT '✅ AmountOutstanding added to Stockroom_PurchaseOrderLines';
END
GO

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ PURCHASE ORDER TABLES FIXED FOR INVOICE CAPTURE!';
PRINT '═══════════════════════════════════════════════';
