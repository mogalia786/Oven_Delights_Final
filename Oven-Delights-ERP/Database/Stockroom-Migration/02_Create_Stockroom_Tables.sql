-- Step 2 — Create canonical Stockroom tables

-- Suppliers
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Suppliers' AND xtype='U')
CREATE TABLE [dbo].[Suppliers] (
    [SupplierID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [SupplierCode] NVARCHAR(20) NOT NULL UNIQUE,
    [CompanyName] NVARCHAR(100) NOT NULL,
    [ContactPerson] NVARCHAR(100) NULL,
    [Email] NVARCHAR(100) NULL,
    [Phone] NVARCHAR(20) NULL,
    [AddressLine1] NVARCHAR(100) NULL,
    [City] NVARCHAR(50) NULL,
    [Province] NVARCHAR(50) NULL,
    [PostalCode] NVARCHAR(10) NULL,
    [PaymentTerms] INT NOT NULL DEFAULT 30,
    [CreditLimit] DECIMAL(18,2) NULL DEFAULT 0.00,
    [TaxNumber] NVARCHAR(20) NULL,
    [IsActive] BIT NOT NULL DEFAULT 1,
    [Rating] INT NULL CHECK ([Rating] BETWEEN 1 AND 5),
    [Notes] NVARCHAR(500) NULL,
    [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
    [CreatedBy] INT NOT NULL,
    [ModifiedDate] DATETIME NULL,
    [ModifiedBy] INT NULL,
    [AccountsPayableAccountID] INT NULL,
    [DefaultExpenseAccountID] INT NULL,
    CONSTRAINT [FK_Suppliers_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [FK_Suppliers_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [Users]([UserID])
);
CREATE NONCLUSTERED INDEX [IX_Suppliers_SupplierCode] ON [dbo].[Suppliers] ([SupplierCode]);
CREATE NONCLUSTERED INDEX [IX_Suppliers_CompanyName] ON [dbo].[Suppliers] ([CompanyName]);
CREATE NONCLUSTERED INDEX [IX_Suppliers_IsActive] ON [dbo].[Suppliers] ([IsActive]);

-- RawMaterials
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='RawMaterials' AND xtype='U')
CREATE TABLE [dbo].[RawMaterials] (
    [MaterialID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [MaterialCode] NVARCHAR(20) NOT NULL UNIQUE,
    [MaterialName] NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(500) NULL,
    [Category] NVARCHAR(50) NULL,
    [UnitOfMeasure] NVARCHAR(20) NOT NULL,
    [ReorderLevel] DECIMAL(18,3) NOT NULL DEFAULT 0.000,
    [ReorderQuantity] DECIMAL(18,3) NOT NULL DEFAULT 0.000,
    [StandardCost] DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    [LastPurchaseCost] DECIMAL(18,4) NULL,
    [AverageCost] DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    [CostingMethod] NVARCHAR(10) NOT NULL DEFAULT 'FIFO',
    [ShelfLifeDays] INT NULL,
    [PreferredSupplierID] INT NULL,
    [IsActive] BIT NOT NULL DEFAULT 1,
    [IsPerishable] BIT NOT NULL DEFAULT 0,
    [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
    [CreatedBy] INT NOT NULL,
    [ModifiedDate] DATETIME NULL,
    [ModifiedBy] INT NULL,
    [InventoryAccountID] INT NULL,
    [COGSAccountID] INT NULL,
    [VarianceAccountID] INT NULL,
    CONSTRAINT [FK_RawMaterials_PreferredSupplier] FOREIGN KEY ([PreferredSupplierID]) REFERENCES [Suppliers]([SupplierID]),
    CONSTRAINT [FK_RawMaterials_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [FK_RawMaterials_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [Users]([UserID])
);
CREATE NONCLUSTERED INDEX [IX_RawMaterials_MaterialCode] ON [dbo].[RawMaterials] ([MaterialCode]);
CREATE NONCLUSTERED INDEX [IX_RawMaterials_MaterialName] ON [dbo].[RawMaterials] ([MaterialName]);
CREATE NONCLUSTERED INDEX [IX_RawMaterials_Category] ON [dbo].[RawMaterials] ([Category]);
CREATE NONCLUSTERED INDEX [IX_RawMaterials_IsActive] ON [dbo].[RawMaterials] ([IsActive]);

-- PurchaseOrders
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PurchaseOrders' AND xtype='U')
CREATE TABLE [dbo].[PurchaseOrders] (
    [PurchaseOrderID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [PONumber] NVARCHAR(20) NOT NULL UNIQUE,
    [SupplierID] INT NOT NULL,
    [BranchID] INT NULL,
    [OrderDate] DATETIME NOT NULL DEFAULT GETDATE(),
    [RequiredDate] DATETIME NULL,
    [ExpectedDeliveryDate] DATETIME NULL,
    [Status] NVARCHAR(20) NOT NULL DEFAULT 'Draft',
    [SubTotal] DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    [DiscountPercentage] DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    [DiscountAmount] DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    [TaxPercentage] DECIMAL(5,2) NOT NULL DEFAULT 15.00,
    [VATAmount] DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    [TotalAmount] DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    [Notes] NVARCHAR(1000) NULL,
    [PaymentTerms] INT NULL,
    [ApprovedBy] INT NULL,
    [ApprovedDate] DATETIME NULL,
    [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
    [CreatedBy] INT NOT NULL,
    [ModifiedDate] DATETIME NULL,
    [ModifiedBy] INT NULL,
    [JournalEntryID] INT NULL,
    [IsPosted] BIT NOT NULL DEFAULT 0,
    [PostedDate] DATETIME NULL,
    [PostedBy] INT NULL,
    CONSTRAINT [FK_PurchaseOrders_Supplier] FOREIGN KEY ([SupplierID]) REFERENCES [Suppliers]([SupplierID]),
    CONSTRAINT [FK_PurchaseOrders_Branch] FOREIGN KEY ([BranchID]) REFERENCES [Branches]([ID]),
    CONSTRAINT [FK_PurchaseOrders_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [FK_PurchaseOrders_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [FK_PurchaseOrders_ApprovedBy] FOREIGN KEY ([ApprovedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [FK_PurchaseOrders_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [Users]([UserID])
);
CREATE NONCLUSTERED INDEX [IX_PurchaseOrders_PONumber] ON [dbo].[PurchaseOrders] ([PONumber]);
CREATE NONCLUSTERED INDEX [IX_PurchaseOrders_Supplier] ON [dbo].[PurchaseOrders] ([SupplierID]);
CREATE NONCLUSTERED INDEX [IX_PurchaseOrders_Status] ON [dbo].[PurchaseOrders] ([Status]);
CREATE NONCLUSTERED INDEX [IX_PurchaseOrders_OrderDate] ON [dbo].[PurchaseOrders] ([OrderDate]);

-- PurchaseOrderLines (renamed from PurchaseOrderItems)
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PurchaseOrderLines' AND xtype='U')
CREATE TABLE [dbo].[PurchaseOrderLines] (
    [PurchaseOrderLineID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [PurchaseOrderID] INT NOT NULL,
    [MaterialID] INT NOT NULL,
    [LineNumber] INT NOT NULL,
    [OrderedQuantity] DECIMAL(18,3) NOT NULL,
    [ReceivedQuantity] DECIMAL(18,3) NOT NULL DEFAULT 0.000,
    [UnitOfMeasure] NVARCHAR(20) NOT NULL,
    [UnitPrice] DECIMAL(18,4) NOT NULL,
    [DiscountPercentage] DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    [LineTotal] DECIMAL(18,2) NOT NULL,
    [Status] NVARCHAR(20) NOT NULL DEFAULT 'Ordered',
    [RequiredDate] DATETIME NULL,
    [Notes] NVARCHAR(500) NULL,
    [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
    [CreatedBy] INT NOT NULL,
    [ModifiedDate] DATETIME NULL,
    [ModifiedBy] INT NULL,
    CONSTRAINT [FK_PurchaseOrderLines_Order] FOREIGN KEY ([PurchaseOrderID]) REFERENCES [PurchaseOrders]([PurchaseOrderID]) ON DELETE CASCADE,
    CONSTRAINT [FK_PurchaseOrderLines_Material] FOREIGN KEY ([MaterialID]) REFERENCES [RawMaterials]([MaterialID]),
    CONSTRAINT [FK_PurchaseOrderLines_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [FK_PurchaseOrderLines_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [UK_PurchaseOrderLines_OrderLine] UNIQUE ([PurchaseOrderID], [LineNumber])
);
CREATE NONCLUSTERED INDEX [IX_PurchaseOrderLines_Order] ON [dbo].[PurchaseOrderLines] ([PurchaseOrderID]);
CREATE NONCLUSTERED INDEX [IX_PurchaseOrderLines_Material] ON [dbo].[PurchaseOrderLines] ([MaterialID]);

-- Inventory
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Inventory' AND xtype='U')
CREATE TABLE [dbo].[Inventory] (
    [InventoryID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [MaterialID] INT NOT NULL,
    [BranchID] INT NULL,
    [Location] NVARCHAR(50) NOT NULL DEFAULT 'MAIN',
    [Batch] NVARCHAR(50) NULL,
    [QuantityOnHand] DECIMAL(18,3) NOT NULL DEFAULT 0.000,
    [QuantityAllocated] DECIMAL(18,3) NOT NULL DEFAULT 0.000,
    [QuantityAvailable] AS ([QuantityOnHand] - [QuantityAllocated]) PERSISTED,
    [UnitCost] DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    [TotalCost] AS ([QuantityOnHand] * [UnitCost]) PERSISTED,
    [LastReceived] DATETIME NULL,
    [LastIssued] DATETIME NULL,
    [LastUpdated] DATETIME NOT NULL DEFAULT GETDATE(),
    [ExpiryDate] DATETIME NULL,
    [IsActive] BIT NOT NULL DEFAULT 1,
    [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
    [CreatedBy] INT NOT NULL,
    [ModifiedDate] DATETIME NULL,
    [ModifiedBy] INT NULL,
    CONSTRAINT [FK_Inventory_Material] FOREIGN KEY ([MaterialID]) REFERENCES [RawMaterials]([MaterialID]),
    CONSTRAINT [FK_Inventory_Branch] FOREIGN KEY ([BranchID]) REFERENCES [Branches]([ID]),
    CONSTRAINT [FK_Inventory_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [FK_Inventory_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [UK_Inventory_MaterialLocationBatch] UNIQUE ([MaterialID], [BranchID], [Location], [Batch])
);
CREATE NONCLUSTERED INDEX [IX_Inventory_Material] ON [dbo].[Inventory] ([MaterialID]);
CREATE NONCLUSTERED INDEX [IX_Inventory_Branch] ON [dbo].[Inventory] ([BranchID]);
CREATE NONCLUSTERED INDEX [IX_Inventory_Location] ON [dbo].[Inventory] ([Location]);
CREATE NONCLUSTERED INDEX [IX_Inventory_ExpiryDate] ON [dbo].[Inventory] ([ExpiryDate]);

-- InventoryTransactions
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='InventoryTransactions' AND xtype='U')
CREATE TABLE [dbo].[InventoryTransactions] (
    [InventoryTransactionID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [MaterialID] INT NOT NULL,
    [BranchID] INT NULL,
    [Location] NVARCHAR(50) NOT NULL,
    [TransactionType] NVARCHAR(20) NOT NULL,
    [TransactionDate] DATETIME NOT NULL DEFAULT GETDATE(),
    [ReferenceType] NVARCHAR(20) NULL,
    [ReferenceID] INT NULL,
    [ReferenceNumber] NVARCHAR(50) NULL,
    [Quantity] DECIMAL(18,3) NOT NULL,
    [UnitCost] DECIMAL(18,4) NOT NULL DEFAULT 0.0000,
    [TotalCost] DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    [RunningBalance] DECIMAL(18,3) NOT NULL,
    [Notes] NVARCHAR(500) NULL,
    [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
    [CreatedBy] INT NOT NULL,
    [JournalEntryID] INT NULL,
    [IsPosted] BIT NOT NULL DEFAULT 0,
    [PostedDate] DATETIME NULL,
    [PostedBy] INT NULL,
    CONSTRAINT [FK_InventoryTransactions_Material] FOREIGN KEY ([MaterialID]) REFERENCES [RawMaterials]([MaterialID]),
    CONSTRAINT [FK_InventoryTransactions_Branch] FOREIGN KEY ([BranchID]) REFERENCES [Branches]([ID]),
    CONSTRAINT [FK_InventoryTransactions_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users]([UserID]),
    CONSTRAINT [FK_InventoryTransactions_PostedBy] FOREIGN KEY ([PostedBy]) REFERENCES [Users]([UserID])
);
CREATE NONCLUSTERED INDEX [IX_InventoryTransactions_Material] ON [dbo].[InventoryTransactions] ([MaterialID]);
CREATE NONCLUSTERED INDEX [IX_InventoryTransactions_TransactionDate] ON [dbo].[InventoryTransactions] ([TransactionDate]);
CREATE NONCLUSTERED INDEX [IX_InventoryTransactions_TransactionType] ON [dbo].[InventoryTransactions] ([TransactionType]);
