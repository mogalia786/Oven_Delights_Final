-- =============================================
-- COMPREHENSIVE STOCKROOM MODULE DATABASE SCHEMA
-- Oven Delights ERP - Azure SQL Server
-- =============================================

-- USE [OvenDelightsERP] -- disabled for Azure SQL (Msg 40508)
-- GO

-- =============================================
-- 1. SUPPLIERS TABLE
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Suppliers' AND xtype='U')
CREATE TABLE [dbo].[Suppliers] (
    [SupplierID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [SupplierCode] [nvarchar](20) NOT NULL UNIQUE,
    [CompanyName] [nvarchar](100) NOT NULL,
    [ContactPerson] [nvarchar](100) NULL,
    [Email] [nvarchar](100) NULL,
    [Phone] [nvarchar](20) NULL,
    [AddressLine1] [nvarchar](100) NULL,
    [City] [nvarchar](50) NULL,
    [Province] [nvarchar](50) NULL,
    [PostalCode] [nvarchar](10) NULL,
    [PaymentTerms] [int] NOT NULL DEFAULT 30,
    [CreditLimit] [decimal](18,2) NULL DEFAULT 0.00,
    [TaxNumber] [nvarchar](20) NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1,
    [Rating] [int] NULL CHECK ([Rating] >= 1 AND [Rating] <= 5),
    [Notes] [nvarchar](500) NULL,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
    [CreatedBy] [int] NOT NULL,
    [ModifiedDate] [datetime] NULL,
    [ModifiedBy] [int] NULL,
    [AccountsPayableAccountID] [int] NULL,
    [DefaultExpenseAccountID] [int] NULL,
    
    CONSTRAINT [FK_Suppliers_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [FK_Suppliers_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [Users]([UserID])
)
GO

CREATE NONCLUSTERED INDEX [IX_Suppliers_SupplierCode] ON [dbo].[Suppliers] ([SupplierCode])
CREATE NONCLUSTERED INDEX [IX_Suppliers_CompanyName] ON [dbo].[Suppliers] ([CompanyName])
CREATE NONCLUSTERED INDEX [IX_Suppliers_IsActive] ON [dbo].[Suppliers] ([IsActive])
GO

-- =============================================
-- 2. RAW MATERIALS TABLE
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='RawMaterials' AND xtype='U')
CREATE TABLE [dbo].[RawMaterials] (
    [MaterialID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [MaterialCode] [nvarchar](20) NOT NULL UNIQUE,
    [MaterialName] [nvarchar](100) NOT NULL,
    [Description] [nvarchar](500) NULL,
    [Category] [nvarchar](50) NULL,
    [UnitOfMeasure] [nvarchar](20) NOT NULL,
    [ReorderLevel] [decimal](18,3) NOT NULL DEFAULT 0.000,
    [ReorderQuantity] [decimal](18,3) NOT NULL DEFAULT 0.000,
    [StandardCost] [decimal](18,4) NOT NULL DEFAULT 0.0000,
    [LastPurchaseCost] [decimal](18,4) NULL,
    [AverageCost] [decimal](18,4) NOT NULL DEFAULT 0.0000,
    [CostingMethod] [nvarchar](10) NOT NULL DEFAULT 'FIFO',
    [ShelfLifeDays] [int] NULL,
    [PreferredSupplierID] [int] NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1,
    [IsPerishable] [bit] NOT NULL DEFAULT 0,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
    [CreatedBy] [int] NOT NULL,
    [ModifiedDate] [datetime] NULL,
    [ModifiedBy] [int] NULL,
    [InventoryAccountID] [int] NULL,
    [COGSAccountID] [int] NULL,
    [VarianceAccountID] [int] NULL,
    
    CONSTRAINT [FK_RawMaterials_PreferredSupplier] FOREIGN KEY ([PreferredSupplierID]) REFERENCES [Suppliers]([SupplierID]),
    CONSTRAINT [FK_RawMaterials_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [FK_RawMaterials_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [Users]([UserID])
)
GO

CREATE NONCLUSTERED INDEX [IX_RawMaterials_MaterialCode] ON [dbo].[RawMaterials] ([MaterialCode])
CREATE NONCLUSTERED INDEX [IX_RawMaterials_MaterialName] ON [dbo].[RawMaterials] ([MaterialName])
CREATE NONCLUSTERED INDEX [IX_RawMaterials_Category] ON [dbo].[RawMaterials] ([Category])
CREATE NONCLUSTERED INDEX [IX_RawMaterials_IsActive] ON [dbo].[RawMaterials] ([IsActive])
GO

-- =============================================
-- 3. PURCHASE ORDERS TABLE
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PurchaseOrders' AND xtype='U')
CREATE TABLE [dbo].[PurchaseOrders] (
    [PurchaseOrderID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [PONumber] [nvarchar](20) NOT NULL UNIQUE,
    [SupplierID] [int] NOT NULL,
    [BranchID] [int] NULL,
    [OrderDate] [datetime] NOT NULL DEFAULT GETDATE(),
    [RequiredDate] [datetime] NULL,
    [ExpectedDeliveryDate] [datetime] NULL,
    [Status] [nvarchar](20) NOT NULL DEFAULT 'Draft',
    [SubTotal] [decimal](18,2) NOT NULL DEFAULT 0.00,
    [DiscountPercentage] [decimal](5,2) NOT NULL DEFAULT 0.00,
    [DiscountAmount] [decimal](18,2) NOT NULL DEFAULT 0.00,
    [TaxPercentage] [decimal](5,2) NOT NULL DEFAULT 15.00,
    [VATAmount] [decimal](18,2) NOT NULL DEFAULT 0.00,
    [TotalAmount] [decimal](18,2) NOT NULL DEFAULT 0.00,
    [Notes] [nvarchar](1000) NULL,
    [PaymentTerms] [int] NULL,
    [ApprovedBy] [int] NULL,
    [ApprovedDate] [datetime] NULL,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
    [CreatedBy] [int] NOT NULL,
    [ModifiedDate] [datetime] NULL,
    [ModifiedBy] [int] NULL,
    [JournalEntryID] [int] NULL,
    [IsPosted] [bit] NOT NULL DEFAULT 0,
    [PostedDate] [datetime] NULL,
    [PostedBy] [int] NULL,
    
    CONSTRAINT [FK_PurchaseOrders_Supplier] FOREIGN KEY ([SupplierID]) REFERENCES [Suppliers]([SupplierID]),
    CONSTRAINT [FK_PurchaseOrders_Branch] FOREIGN KEY ([BranchID]) REFERENCES [Branches]([ID]),
    CONSTRAINT [FK_PurchaseOrders_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [FK_PurchaseOrders_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [FK_PurchaseOrders_ApprovedBy] FOREIGN KEY ([ApprovedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [FK_PurchaseOrders_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [Users]([UserID])
)
GO

CREATE NONCLUSTERED INDEX [IX_PurchaseOrders_PONumber] ON [dbo].[PurchaseOrders] ([PONumber])
CREATE NONCLUSTERED INDEX [IX_PurchaseOrders_Supplier] ON [dbo].[PurchaseOrders] ([SupplierID])
CREATE NONCLUSTERED INDEX [IX_PurchaseOrders_Status] ON [dbo].[PurchaseOrders] ([Status])
CREATE NONCLUSTERED INDEX [IX_PurchaseOrders_OrderDate] ON [dbo].[PurchaseOrders] ([OrderDate])
GO

-- =============================================
-- 4. PURCHASE ORDER ITEMS TABLE
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PurchaseOrderLines' AND xtype='U')
CREATE TABLE [dbo].[PurchaseOrderLines] (
    [PurchaseOrderLineID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [PurchaseOrderID] [int] NOT NULL,
    [MaterialID] [int] NOT NULL,
    [LineNumber] [int] NOT NULL,
    [OrderedQuantity] [decimal](18,3) NOT NULL,
    [ReceivedQuantity] [decimal](18,3) NOT NULL DEFAULT 0.000,
    [UnitOfMeasure] [nvarchar](20) NOT NULL,
    [UnitPrice] [decimal](18,4) NOT NULL,
    [DiscountPercentage] [decimal](5,2) NOT NULL DEFAULT 0.00,
    [LineTotal] [decimal](18,2) NOT NULL,
    [Status] [nvarchar](20) NOT NULL DEFAULT 'Ordered',
    [RequiredDate] [datetime] NULL,
    [Notes] [nvarchar](500) NULL,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
    [CreatedBy] [int] NOT NULL,
    [ModifiedDate] [datetime] NULL,
    [ModifiedBy] [int] NULL,
    
    CONSTRAINT [FK_PurchaseOrderLines_Order] FOREIGN KEY ([PurchaseOrderID]) REFERENCES [PurchaseOrders]([PurchaseOrderID]) ON DELETE CASCADE,
    CONSTRAINT [FK_PurchaseOrderLines_Material] FOREIGN KEY ([MaterialID]) REFERENCES [RawMaterials]([MaterialID]),
    CONSTRAINT [FK_PurchaseOrderLines_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [FK_PurchaseOrderLines_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [UK_PurchaseOrderLines_OrderLine] UNIQUE ([PurchaseOrderID], [LineNumber])
)
GO

CREATE NONCLUSTERED INDEX [IX_PurchaseOrderLines_Order] ON [dbo].[PurchaseOrderLines] ([PurchaseOrderID])
CREATE NONCLUSTERED INDEX [IX_PurchaseOrderLines_Material] ON [dbo].[PurchaseOrderLines] ([MaterialID])
GO

-- =============================================
-- 5. INVENTORY TABLE
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Inventory' AND xtype='U')
CREATE TABLE [dbo].[Inventory] (
    [InventoryID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [MaterialID] [int] NOT NULL,
    [BranchID] [int] NULL,
    [Location] [nvarchar](50) NOT NULL DEFAULT 'MAIN',
    [Batch] [nvarchar](50) NULL,
    [QuantityOnHand] [decimal](18,3) NOT NULL DEFAULT 0.000,
    [QuantityAllocated] [decimal](18,3) NOT NULL DEFAULT 0.000,
    [QuantityAvailable] AS ([QuantityOnHand] - [QuantityAllocated]) PERSISTED,
    [UnitCost] [decimal](18,4) NOT NULL DEFAULT 0.0000,
    [TotalCost] AS ([QuantityOnHand] * [UnitCost]) PERSISTED,
    [LastReceived] [datetime] NULL,
    [LastIssued] [datetime] NULL,
    [LastUpdated] [datetime] NOT NULL DEFAULT GETDATE(),
    [ExpiryDate] [datetime] NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
    [CreatedBy] [int] NOT NULL,
    [ModifiedDate] [datetime] NULL,
    [ModifiedBy] [int] NULL,
    
    CONSTRAINT [FK_Inventory_Material] FOREIGN KEY ([MaterialID]) REFERENCES [RawMaterials]([MaterialID]),
    CONSTRAINT [FK_Inventory_Branch] FOREIGN KEY ([BranchID]) REFERENCES [Branches]([ID]),
    CONSTRAINT [FK_Inventory_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [FK_Inventory_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [UK_Inventory_MaterialLocationBatch] UNIQUE ([MaterialID], [BranchID], [Location], [Batch])
)
GO

CREATE NONCLUSTERED INDEX [IX_Inventory_Material] ON [dbo].[Inventory] ([MaterialID])
CREATE NONCLUSTERED INDEX [IX_Inventory_Branch] ON [dbo].[Inventory] ([BranchID])
CREATE NONCLUSTERED INDEX [IX_Inventory_Location] ON [dbo].[Inventory] ([Location])
CREATE NONCLUSTERED INDEX [IX_Inventory_ExpiryDate] ON [dbo].[Inventory] ([ExpiryDate])
GO

-- =============================================
-- 6. INVENTORY TRANSACTIONS TABLE
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='InventoryTransactions' AND xtype='U')
CREATE TABLE [dbo].[InventoryTransactions] (
    [InventoryTransactionID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [MaterialID] [int] NOT NULL,
    [BranchID] [int] NULL,
    [Location] [nvarchar](50) NOT NULL,
    [TransactionType] [nvarchar](20) NOT NULL,
    [TransactionDate] [datetime] NOT NULL DEFAULT GETDATE(),
    [ReferenceType] [nvarchar](20) NULL,
    [ReferenceID] [int] NULL,
    [ReferenceNumber] [nvarchar](50) NULL,
    [Quantity] [decimal](18,3) NOT NULL,
    [UnitCost] [decimal](18,4) NOT NULL DEFAULT 0.0000,
    [TotalCost] [decimal](18,2) NOT NULL DEFAULT 0.00,
    [RunningBalance] [decimal](18,3) NOT NULL,
    [Notes] [nvarchar](500) NULL,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
    [CreatedBy] [int] NOT NULL,
    [JournalEntryID] [int] NULL,
    [IsPosted] [bit] NOT NULL DEFAULT 0,
    [PostedDate] [datetime] NULL,
    [PostedBy] [int] NULL,
    
    CONSTRAINT [FK_InventoryTransactions_Material] FOREIGN KEY ([MaterialID]) REFERENCES [RawMaterials]([MaterialID]),
    CONSTRAINT [FK_InventoryTransactions_Branch] FOREIGN KEY ([BranchID]) REFERENCES [Branches]([ID]),
    CONSTRAINT [FK_InventoryTransactions_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [FK_InventoryTransactions_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [Users]([UserID])
)
GO

CREATE NONCLUSTERED INDEX [IX_InventoryTransactions_Material] ON [dbo].[InventoryTransactions] ([MaterialID])
CREATE NONCLUSTERED INDEX [IX_InventoryTransactions_TransactionDate] ON [dbo].[InventoryTransactions] ([TransactionDate])
CREATE NONCLUSTERED INDEX [IX_InventoryTransactions_TransactionType] ON [dbo].[InventoryTransactions] ([TransactionType])
GO

-- =============================================
-- ACCOUNTING INTEGRATION VIEWS
-- =============================================

-- View for Purchase Order Accounting
CREATE OR ALTER VIEW [dbo].[vw_PurchaseOrderAccounting] AS
SELECT 
    po.PurchaseOrderID AS PurchaseOrderID,
    po.PONumber AS PONumber,
    po.SupplierID,
    s.CompanyName AS SupplierName,
    po.TotalAmount AS TotalAmount,
    po.VATAmount AS VATAmount,
    ISNULL(po.IsPosted, 0) AS IsPosted,
    s.AccountsPayableAccountID,
    s.DefaultExpenseAccountID
FROM dbo.PurchaseOrders po
INNER JOIN dbo.Suppliers s ON po.SupplierID = s.SupplierID
WHERE ISNULL(po.IsPosted, 0) = 0
GO

-- View for Inventory Valuation
CREATE OR ALTER VIEW [dbo].[vw_InventoryValuation] AS
SELECT 
    rm.MaterialID AS MaterialID,
    rm.MaterialCode AS MaterialCode,
    rm.MaterialName AS MaterialName,
    rm.Category AS Category,
    SUM(ISNULL(i.QuantityOnHand, 0)) AS TotalQuantity,
    AVG(ISNULL(i.UnitCost, 0)) AS AverageUnitCost,
    SUM(ISNULL(i.TotalCost, ISNULL(i.QuantityOnHand, 0) * ISNULL(i.UnitCost, 0))) AS TotalValue,
    rm.InventoryAccountID,
    rm.COGSAccountID
FROM dbo.RawMaterials rm
LEFT JOIN dbo.Inventory i ON rm.MaterialID = i.MaterialID
WHERE ISNULL(rm.IsActive, 1) = 1 AND (ISNULL(i.IsActive, 1) = 1 OR i.IsActive IS NULL)
GROUP BY rm.MaterialID, rm.MaterialCode, rm.MaterialName, rm.Category, rm.InventoryAccountID, rm.COGSAccountID
GO

-- =============================================
-- SAMPLE DATA INSERTS
-- =============================================

-- Insert sample suppliers
INSERT INTO Suppliers (SupplierCode, CompanyName, ContactPerson, Email, Phone, PaymentTerms, CreatedBy)
VALUES 
('SUP001', 'Premium Flour Mills', 'John Smith', 'orders@premiumflour.co.za', '011-123-4567', 30, 1),
('SUP002', 'Fresh Dairy Supplies', 'Mary Johnson', 'sales@freshdairy.co.za', '021-987-6543', 15, 1),
('SUP003', 'Sugar & Spice Co', 'Peter Brown', 'info@sugarspice.co.za', '031-555-0123', 30, 1)
GO

-- Insert sample raw materials
INSERT INTO RawMaterials (MaterialCode, MaterialName, Description, Category, UnitOfMeasure, ReorderLevel, StandardCost, CostingMethod, PreferredSupplierID, CreatedBy)
VALUES 
('RM001', 'Bread Flour', 'High quality bread flour', 'Flour', 'kg', 100.000, 12.50, 'FIFO', 1, 1),
('RM002', 'Fresh Milk', 'Full cream fresh milk', 'Dairy', 'liters', 50.000, 18.75, 'FIFO', 2, 1),
('RM003', 'Caster Sugar', 'Fine caster sugar', 'Sugar', 'kg', 75.000, 22.00, 'FIFO', 3, 1),
('RM004', 'Butter', 'Salted butter', 'Dairy', 'kg', 25.000, 85.00, 'FIFO', 2, 1),
('RM005', 'Eggs', 'Fresh large eggs', 'Dairy', 'dozen', 20.000, 35.00, 'FIFO', 2, 1)
GO

PRINT 'Stockroom Module Database Schema Created Successfully!'
PRINT 'Tables Created: Suppliers, RawMaterials, PurchaseOrders, PurchaseOrderLines, Inventory, InventoryTransactions'
PRINT 'Accounting Integration: Views and foreign keys for journal entry integration'
PRINT 'Sample Data: Basic suppliers and raw materials inserted'
GO
