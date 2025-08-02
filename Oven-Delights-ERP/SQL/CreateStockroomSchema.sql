-- =============================================
-- Oven Delights ERP - Stockroom Module Database Schema
-- Comprehensive Accounting-Integrated Stockroom Management
-- Pastel-Compatible Design with Full Audit Trail
-- =============================================

-- Chart of Accounts (GL Integration)
CREATE TABLE ChartOfAccounts (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    AccountCode NVARCHAR(20) NOT NULL UNIQUE,
    AccountName NVARCHAR(100) NOT NULL,
    AccountType NVARCHAR(50) NOT NULL, -- Asset, Liability, Equity, Revenue, Expense
    ParentAccountID INT NULL,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT NOT NULL,
    FOREIGN KEY (ParentAccountID) REFERENCES ChartOfAccounts(AccountID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- Suppliers Master (Creditors)
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierCode NVARCHAR(20) NOT NULL UNIQUE,
    CompanyName NVARCHAR(100) NOT NULL,
    ContactPerson NVARCHAR(100),
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    Mobile NVARCHAR(20),
    Fax NVARCHAR(20),
    Website NVARCHAR(100),
    
    -- Address Information
    PhysicalAddress NVARCHAR(255),
    PostalAddress NVARCHAR(255),
    City NVARCHAR(50),
    Province NVARCHAR(50),
    PostalCode NVARCHAR(10),
    Country NVARCHAR(50) DEFAULT 'South Africa',
    
    -- Tax Information
    VATNumber NVARCHAR(20),
    TaxRate DECIMAL(5,2) DEFAULT 15.00,
    
    -- Payment Terms
    PaymentTerms INT DEFAULT 30, -- Days
    CreditLimit DECIMAL(18,2) DEFAULT 0,
    CurrentBalance DECIMAL(18,2) DEFAULT 0,
    
    -- GL Integration
    CreditorAccountID INT NOT NULL,
    
    -- Status
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT NOT NULL,
    ModifiedDate DATETIME2,
    ModifiedBy INT,
    
    FOREIGN KEY (CreditorAccountID) REFERENCES ChartOfAccounts(AccountID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID)
);

-- Product Categories
CREATE TABLE ProductCategories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryCode NVARCHAR(20) NOT NULL UNIQUE,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    
    -- GL Integration
    InventoryAccountID INT NOT NULL,
    COGSAccountID INT NOT NULL,
    
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT NOT NULL,
    
    FOREIGN KEY (InventoryAccountID) REFERENCES ChartOfAccounts(AccountID),
    FOREIGN KEY (COGSAccountID) REFERENCES ChartOfAccounts(AccountID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- Raw Materials/Products Master
CREATE TABLE RawMaterials (
    MaterialID INT IDENTITY(1,1) PRIMARY KEY,
    MaterialCode NVARCHAR(20) NOT NULL UNIQUE,
    MaterialName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    CategoryID INT NOT NULL,
    
    -- Units of Measure
    BaseUnit NVARCHAR(20) NOT NULL, -- kg, liters, pieces, etc.
    PurchaseUnit NVARCHAR(20),
    
    -- Stock Levels
    CurrentStock DECIMAL(18,4) DEFAULT 0,
    ReorderLevel DECIMAL(18,4) DEFAULT 0,
    MaxStockLevel DECIMAL(18,4) DEFAULT 0,
    
    -- Costing (FIFO/LIFO/Weighted Average)
    CostingMethod NVARCHAR(20) DEFAULT 'WeightedAverage',
    StandardCost DECIMAL(18,4) DEFAULT 0,
    LastCost DECIMAL(18,4) DEFAULT 0,
    AverageCost DECIMAL(18,4) DEFAULT 0,
    
    -- GL Integration
    InventoryAccountID INT NOT NULL,
    COGSAccountID INT NOT NULL,
    
    -- Supplier Information
    PreferredSupplierID INT,
    
    -- Status
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT NOT NULL,
    ModifiedDate DATETIME2,
    ModifiedBy INT,
    
    FOREIGN KEY (CategoryID) REFERENCES ProductCategories(CategoryID),
    FOREIGN KEY (InventoryAccountID) REFERENCES ChartOfAccounts(AccountID),
    FOREIGN KEY (COGSAccountID) REFERENCES ChartOfAccounts(AccountID),
    FOREIGN KEY (PreferredSupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID)
);

-- Purchase Orders Header
CREATE TABLE PurchaseOrders (
    PurchaseOrderID INT IDENTITY(1,1) PRIMARY KEY,
    PONumber NVARCHAR(20) NOT NULL UNIQUE,
    SupplierID INT NOT NULL,
    
    -- Dates
    OrderDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    RequiredDate DATETIME2,
    DeliveryDate DATETIME2,
    
    -- Status
    Status NVARCHAR(20) DEFAULT 'Draft', -- Draft, Approved, Sent, Received, Cancelled
    
    -- Totals
    SubTotal DECIMAL(18,2) DEFAULT 0,
    VATAmount DECIMAL(18,2) DEFAULT 0,
    TotalAmount DECIMAL(18,2) DEFAULT 0,
    
    -- Additional Information
    Reference NVARCHAR(50),
    Notes NVARCHAR(500),
    
    -- Approval Workflow
    ApprovedBy INT,
    ApprovedDate DATETIME2,
    
    -- GL Integration
    JournalEntryID INT, -- Link to GL Journal Entry
    
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT NOT NULL,
    ModifiedDate DATETIME2,
    ModifiedBy INT,
    
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (ApprovedBy) REFERENCES Users(UserID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID)
);

-- Purchase Order Line Items
CREATE TABLE PurchaseOrderLines (
    POLineID INT IDENTITY(1,1) PRIMARY KEY,
    PurchaseOrderID INT NOT NULL,
    MaterialID INT NOT NULL,
    
    -- Quantities
    OrderedQuantity DECIMAL(18,4) NOT NULL,
    ReceivedQuantity DECIMAL(18,4) DEFAULT 0,
    
    -- Pricing
    UnitCost DECIMAL(18,4) NOT NULL,
    LineTotal DECIMAL(18,2) NOT NULL,
    
    -- Status
    LineStatus NVARCHAR(20) DEFAULT 'Pending', -- Pending, Received, Cancelled
    
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    
    FOREIGN KEY (PurchaseOrderID) REFERENCES PurchaseOrders(PurchaseOrderID),
    FOREIGN KEY (MaterialID) REFERENCES RawMaterials(MaterialID)
);

-- Goods Received Notes (GRN)
CREATE TABLE GoodsReceivedNotes (
    GRNID INT IDENTITY(1,1) PRIMARY KEY,
    GRNNumber NVARCHAR(20) NOT NULL UNIQUE,
    PurchaseOrderID INT NOT NULL,
    SupplierID INT NOT NULL,
    
    -- Dates
    ReceivedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    -- Totals
    TotalAmount DECIMAL(18,2) DEFAULT 0,
    
    -- Status
    Status NVARCHAR(20) DEFAULT 'Received', -- Received, Invoiced
    
    -- Additional Information
    DeliveryNote NVARCHAR(50),
    ReceivedBy INT NOT NULL,
    Notes NVARCHAR(500),
    
    -- GL Integration
    JournalEntryID INT, -- Link to GL Journal Entry
    
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT NOT NULL,
    
    FOREIGN KEY (PurchaseOrderID) REFERENCES PurchaseOrders(PurchaseOrderID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (ReceivedBy) REFERENCES Users(UserID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- GRN Line Items
CREATE TABLE GRNLines (
    GRNLineID INT IDENTITY(1,1) PRIMARY KEY,
    GRNID INT NOT NULL,
    POLineID INT NOT NULL,
    MaterialID INT NOT NULL,
    
    -- Quantities
    ReceivedQuantity DECIMAL(18,4) NOT NULL,
    
    -- Pricing
    UnitCost DECIMAL(18,4) NOT NULL,
    LineTotal DECIMAL(18,2) NOT NULL,
    
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    
    FOREIGN KEY (GRNID) REFERENCES GoodsReceivedNotes(GRNID),
    FOREIGN KEY (POLineID) REFERENCES PurchaseOrderLines(POLineID),
    FOREIGN KEY (MaterialID) REFERENCES RawMaterials(MaterialID)
);

-- Stock Movements (Comprehensive Audit Trail)
CREATE TABLE StockMovements (
    MovementID INT IDENTITY(1,1) PRIMARY KEY,
    MaterialID INT NOT NULL,
    
    -- Movement Details
    MovementType NVARCHAR(20) NOT NULL, -- Purchase, Sale, Transfer, Adjustment, Production
    MovementDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    -- Quantities
    QuantityIn DECIMAL(18,4) DEFAULT 0,
    QuantityOut DECIMAL(18,4) DEFAULT 0,
    BalanceAfter DECIMAL(18,4) NOT NULL,
    
    -- Costing
    UnitCost DECIMAL(18,4) NOT NULL,
    TotalValue DECIMAL(18,2) NOT NULL,
    
    -- Reference Information
    ReferenceType NVARCHAR(20), -- PO, GRN, Invoice, Adjustment, etc.
    ReferenceID INT,
    ReferenceNumber NVARCHAR(20),
    
    -- GL Integration
    JournalEntryID INT, -- Link to GL Journal Entry
    
    -- Additional Information
    Notes NVARCHAR(255),
    
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT NOT NULL,
    
    FOREIGN KEY (MaterialID) REFERENCES RawMaterials(MaterialID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- Stock Adjustments
CREATE TABLE StockAdjustments (
    AdjustmentID INT IDENTITY(1,1) PRIMARY KEY,
    AdjustmentNumber NVARCHAR(20) NOT NULL UNIQUE,
    
    -- Dates
    AdjustmentDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    -- Reason
    ReasonCode NVARCHAR(20) NOT NULL, -- Damage, Theft, Count, Obsolete, etc.
    Reason NVARCHAR(255),
    
    -- Approval
    ApprovedBy INT,
    ApprovedDate DATETIME2,
    
    -- Status
    Status NVARCHAR(20) DEFAULT 'Draft', -- Draft, Approved, Posted
    
    -- GL Integration
    JournalEntryID INT, -- Link to GL Journal Entry
    
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT NOT NULL,
    ModifiedDate DATETIME2,
    ModifiedBy INT,
    
    FOREIGN KEY (ApprovedBy) REFERENCES Users(UserID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID)
);

-- Stock Adjustment Lines
CREATE TABLE StockAdjustmentLines (
    AdjustmentLineID INT IDENTITY(1,1) PRIMARY KEY,
    AdjustmentID INT NOT NULL,
    MaterialID INT NOT NULL,
    
    -- Quantities
    SystemQuantity DECIMAL(18,4) NOT NULL,
    ActualQuantity DECIMAL(18,4) NOT NULL,
    AdjustmentQuantity AS (ActualQuantity - SystemQuantity),
    
    -- Costing
    UnitCost DECIMAL(18,4) NOT NULL,
    AdjustmentValue AS ((ActualQuantity - SystemQuantity) * UnitCost),
    
    -- Additional Information
    Notes NVARCHAR(255),
    
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    
    FOREIGN KEY (AdjustmentID) REFERENCES StockAdjustments(AdjustmentID),
    FOREIGN KEY (MaterialID) REFERENCES RawMaterials(MaterialID)
);

-- Stock Transfers (Between Locations/Branches)
CREATE TABLE StockTransfers (
    TransferID INT IDENTITY(1,1) PRIMARY KEY,
    TransferNumber NVARCHAR(20) NOT NULL UNIQUE,
    
    -- Transfer Details
    FromBranchID INT NOT NULL,
    ToBranchID INT NOT NULL,
    TransferDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    -- Status
    Status NVARCHAR(20) DEFAULT 'Draft', -- Draft, Sent, Received, Cancelled
    
    -- Additional Information
    Reference NVARCHAR(50),
    Notes NVARCHAR(500),
    
    -- Approval
    ApprovedBy INT,
    ApprovedDate DATETIME2,
    
    -- GL Integration
    JournalEntryID INT, -- Link to GL Journal Entry
    
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT NOT NULL,
    ModifiedDate DATETIME2,
    ModifiedBy INT,
    
    FOREIGN KEY (FromBranchID) REFERENCES Branches(BranchID),
    FOREIGN KEY (ToBranchID) REFERENCES Branches(BranchID),
    FOREIGN KEY (ApprovedBy) REFERENCES Users(UserID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID)
);

-- Stock Transfer Lines
CREATE TABLE StockTransferLines (
    TransferLineID INT IDENTITY(1,1) PRIMARY KEY,
    TransferID INT NOT NULL,
    MaterialID INT NOT NULL,
    
    -- Quantities
    TransferQuantity DECIMAL(18,4) NOT NULL,
    ReceivedQuantity DECIMAL(18,4) DEFAULT 0,
    
    -- Costing
    UnitCost DECIMAL(18,4) NOT NULL,
    LineTotal DECIMAL(18,2) NOT NULL,
    
    -- Status
    LineStatus NVARCHAR(20) DEFAULT 'Pending', -- Pending, Received
    
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    
    FOREIGN KEY (TransferID) REFERENCES StockTransfers(TransferID),
    FOREIGN KEY (MaterialID) REFERENCES RawMaterials(MaterialID)
);

-- General Ledger Journal Entries (For Full Accounting Integration)
CREATE TABLE JournalEntries (
    JournalEntryID INT IDENTITY(1,1) PRIMARY KEY,
    JournalNumber NVARCHAR(20) NOT NULL UNIQUE,
    
    -- Entry Details
    EntryDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    Period INT NOT NULL, -- YYYYMM format
    
    -- Source
    SourceType NVARCHAR(20) NOT NULL, -- PO, GRN, Adjustment, Transfer, etc.
    SourceID INT NOT NULL,
    SourceNumber NVARCHAR(20),
    
    -- Description
    Description NVARCHAR(255) NOT NULL,
    Reference NVARCHAR(50),
    
    -- Totals (Must Balance)
    TotalDebits DECIMAL(18,2) NOT NULL,
    TotalCredits DECIMAL(18,2) NOT NULL,
    
    -- Status
    Status NVARCHAR(20) DEFAULT 'Draft', -- Draft, Posted, Reversed
    
    -- Approval
    ApprovedBy INT,
    ApprovedDate DATETIME2,
    PostedBy INT,
    PostedDate DATETIME2,
    
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    CreatedBy INT NOT NULL,
    
    FOREIGN KEY (ApprovedBy) REFERENCES Users(UserID),
    FOREIGN KEY (PostedBy) REFERENCES Users(UserID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- Journal Entry Lines (Debits and Credits)
CREATE TABLE JournalEntryLines (
    JournalLineID INT IDENTITY(1,1) PRIMARY KEY,
    JournalEntryID INT NOT NULL,
    AccountID INT NOT NULL,
    
    -- Amounts
    DebitAmount DECIMAL(18,2) DEFAULT 0,
    CreditAmount DECIMAL(18,2) DEFAULT 0,
    
    -- Description
    Description NVARCHAR(255),
    Reference NVARCHAR(50),
    
    -- Additional Information
    AnalysisCode NVARCHAR(20), -- For reporting/analysis
    
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    
    FOREIGN KEY (JournalEntryID) REFERENCES JournalEntries(JournalEntryID),
    FOREIGN KEY (AccountID) REFERENCES ChartOfAccounts(AccountID)
);

-- Insert Default Chart of Accounts for Stockroom
INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, CreatedBy) VALUES
-- Assets
('1100', 'Raw Materials Inventory', 'Asset', 1),
('1110', 'Flour Inventory', 'Asset', 1),
('1120', 'Sugar Inventory', 'Asset', 1),
('1130', 'Dairy Inventory', 'Asset', 1),
('1140', 'Other Ingredients Inventory', 'Asset', 1),

-- Liabilities
('2100', 'Accounts Payable - Trade Creditors', 'Liability', 1),
('2110', 'VAT Payable', 'Liability', 1),

-- Expenses
('5100', 'Cost of Goods Sold - Raw Materials', 'Expense', 1),
('5200', 'Inventory Adjustments', 'Expense', 1),
('5300', 'Stock Loss/Shrinkage', 'Expense', 1);

-- Insert Sample Product Categories
INSERT INTO ProductCategories (CategoryCode, CategoryName, Description, InventoryAccountID, COGSAccountID, CreatedBy) VALUES
('FLOUR', 'Flour & Grains', 'All types of flour and grain products', 2, 6, 1),
('SUGAR', 'Sugar & Sweeteners', 'Sugar, honey, and other sweetening agents', 3, 6, 1),
('DAIRY', 'Dairy Products', 'Milk, butter, cream, eggs, and dairy products', 4, 6, 1),
('OTHER', 'Other Ingredients', 'Spices, extracts, and miscellaneous ingredients', 5, 6, 1);

-- Insert Sample Suppliers
INSERT INTO Suppliers (SupplierCode, CompanyName, ContactPerson, Email, Phone, PhysicalAddress, City, Province, VATNumber, PaymentTerms, CreditorAccountID, CreatedBy) VALUES
('SUP001', 'ABC Ingredients Ltd', 'John Smith', 'john@abc.com', '011-123-4567', '123 Industrial Road', 'Johannesburg', 'Gauteng', '4123456789', 30, 6, 1),
('SUP002', 'Fresh Foods Supply', 'Mary Johnson', 'mary@fresh.com', '021-987-6543', '456 Market Street', 'Cape Town', 'Western Cape', '4987654321', 30, 6, 1),
('SUP003', 'Quality Bakery Supplies', 'David Wilson', 'david@quality.com', '031-555-1234', '789 Supply Avenue', 'Durban', 'KwaZulu-Natal', '4555123456', 30, 6, 1);

-- Insert Sample Raw Materials
INSERT INTO RawMaterials (MaterialCode, MaterialName, Description, CategoryID, BaseUnit, CurrentStock, ReorderLevel, StandardCost, InventoryAccountID, COGSAccountID, PreferredSupplierID, CreatedBy) VALUES
('RM001', 'All Purpose Flour', 'High quality all-purpose flour for baking', 1, 'kg', 500.00, 100.00, 12.50, 2, 6, 1, 1),
('RM002', 'Granulated Sugar', 'Fine granulated white sugar', 2, 'kg', 250.00, 50.00, 18.75, 3, 6, 2, 1),
('RM003', 'Butter - Unsalted', 'Premium unsalted butter for baking', 3, 'kg', 75.00, 25.00, 85.00, 4, 6, 2, 1),
('RM004', 'Fresh Eggs', 'Grade A large fresh eggs', 3, 'dozen', 200.00, 50.00, 35.00, 4, 6, 2, 1),
('RM005', 'Vanilla Extract', 'Pure vanilla extract', 4, 'ml', 500.00, 100.00, 0.25, 5, 6, 3, 1);

-- Create Indexes for Performance
CREATE INDEX IX_StockMovements_MaterialID_Date ON StockMovements(MaterialID, MovementDate);
CREATE INDEX IX_PurchaseOrders_SupplierID_Date ON PurchaseOrders(SupplierID, OrderDate);
CREATE INDEX IX_JournalEntries_Period_Status ON JournalEntries(Period, Status);
CREATE INDEX IX_RawMaterials_CategoryID ON RawMaterials(CategoryID);
CREATE INDEX IX_Suppliers_SupplierCode ON Suppliers(SupplierCode);

PRINT 'Stockroom Database Schema Created Successfully with Full Accounting Integration!'
