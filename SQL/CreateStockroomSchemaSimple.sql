-- =============================================
-- Oven Delights ERP - Stockroom Module Database Schema (Working Version)
-- Simple Schema Without Complex Dependencies
-- =============================================

-- Drop existing tables if they exist (in reverse dependency order)
IF OBJECT_ID('StockMovements', 'U') IS NOT NULL DROP TABLE StockMovements;
IF OBJECT_ID('PurchaseOrderLines', 'U') IS NOT NULL DROP TABLE PurchaseOrderLines;
IF OBJECT_ID('PurchaseOrders', 'U') IS NOT NULL DROP TABLE PurchaseOrders;
IF OBJECT_ID('RawMaterials', 'U') IS NOT NULL DROP TABLE RawMaterials;
IF OBJECT_ID('ProductCategories', 'U') IS NOT NULL DROP TABLE ProductCategories;
IF OBJECT_ID('Suppliers', 'U') IS NOT NULL DROP TABLE Suppliers;
IF OBJECT_ID('ChartOfAccounts', 'U') IS NOT NULL DROP TABLE ChartOfAccounts;

-- Chart of Accounts (Simplified)
CREATE TABLE ChartOfAccounts (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    AccountCode NVARCHAR(20) NOT NULL UNIQUE,
    AccountName NVARCHAR(100) NOT NULL,
    AccountType NVARCHAR(50) NOT NULL, -- Asset, Liability, Equity, Revenue, Expense
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE()
);

-- Suppliers Master (Simplified)
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierCode NVARCHAR(20) NOT NULL UNIQUE,
    CompanyName NVARCHAR(100) NOT NULL,
    ContactPerson NVARCHAR(100),
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    Mobile NVARCHAR(20),
    
    -- Address Information
    PhysicalAddress NVARCHAR(255),
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
    
    -- Status
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE()
);

-- Product Categories (Simplified)
CREATE TABLE ProductCategories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryCode NVARCHAR(20) NOT NULL UNIQUE,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE()
);

-- Raw Materials/Products Master (Simplified)
CREATE TABLE RawMaterials (
    MaterialID INT IDENTITY(1,1) PRIMARY KEY,
    MaterialCode NVARCHAR(20) NOT NULL UNIQUE,
    MaterialName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    CategoryID INT NOT NULL,
    
    -- Units of Measure
    BaseUnit NVARCHAR(20) NOT NULL, -- kg, liters, pieces, etc.
    
    -- Stock Levels
    CurrentStock DECIMAL(18,4) DEFAULT 0,
    ReorderLevel DECIMAL(18,4) DEFAULT 0,
    MaxStockLevel DECIMAL(18,4) DEFAULT 0,
    
    -- Costing
    StandardCost DECIMAL(18,4) DEFAULT 0,
    LastCost DECIMAL(18,4) DEFAULT 0,
    AverageCost DECIMAL(18,4) DEFAULT 0,
    
    -- Supplier Information
    PreferredSupplierID INT,
    
    -- Status
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    
    FOREIGN KEY (CategoryID) REFERENCES ProductCategories(CategoryID),
    FOREIGN KEY (PreferredSupplierID) REFERENCES Suppliers(SupplierID)
);

-- Purchase Orders Header (Simplified)
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
    
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Purchase Order Line Items (Simplified)
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

-- Stock Movements (Simplified)
CREATE TABLE StockMovements (
    MovementID INT IDENTITY(1,1) PRIMARY KEY,
    MaterialID INT NOT NULL,
    
    -- Movement Details
    MovementType NVARCHAR(20) NOT NULL, -- Purchase, Sale, Transfer, Adjustment
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
    
    -- Additional Information
    Notes NVARCHAR(255),
    
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    
    FOREIGN KEY (MaterialID) REFERENCES RawMaterials(MaterialID)
);

-- Insert Default Chart of Accounts
INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType) VALUES
-- Assets
('1100', 'Raw Materials Inventory', 'Asset'),
('1110', 'Flour Inventory', 'Asset'),
('1120', 'Sugar Inventory', 'Asset'),
('1130', 'Dairy Inventory', 'Asset'),
('1140', 'Other Ingredients Inventory', 'Asset'),

-- Liabilities
('2100', 'Accounts Payable - Trade Creditors', 'Liability'),
('2110', 'VAT Payable', 'Liability'),

-- Expenses
('5100', 'Cost of Goods Sold - Raw Materials', 'Expense'),
('5200', 'Inventory Adjustments', 'Expense'),
('5300', 'Stock Loss/Shrinkage', 'Expense');

-- Insert Sample Product Categories
INSERT INTO ProductCategories (CategoryCode, CategoryName, Description) VALUES
('FLOUR', 'Flour & Grains', 'All types of flour and grain products'),
('SUGAR', 'Sugar & Sweeteners', 'Sugar, honey, and other sweetening agents'),
('DAIRY', 'Dairy Products', 'Milk, butter, cream, eggs, and dairy products'),
('OTHER', 'Other Ingredients', 'Spices, extracts, and miscellaneous ingredients');

-- Insert Sample Suppliers
INSERT INTO Suppliers (SupplierCode, CompanyName, ContactPerson, Email, Phone, PhysicalAddress, City, Province, VATNumber, PaymentTerms, CreditLimit) VALUES
('SUP001', 'ABC Ingredients Ltd', 'John Smith', 'john@abc.com', '011-123-4567', '123 Industrial Road', 'Johannesburg', 'Gauteng', '4123456789', 30, 50000.00),
('SUP002', 'Fresh Foods Supply', 'Mary Johnson', 'mary@fresh.com', '021-987-6543', '456 Market Street', 'Cape Town', 'Western Cape', '4987654321', 30, 75000.00),
('SUP003', 'Quality Bakery Supplies', 'David Wilson', 'david@quality.com', '031-555-1234', '789 Supply Avenue', 'Durban', 'KwaZulu-Natal', '4555123456', 30, 60000.00);

-- Insert Sample Raw Materials
INSERT INTO RawMaterials (MaterialCode, MaterialName, Description, CategoryID, BaseUnit, CurrentStock, ReorderLevel, StandardCost, LastCost, AverageCost, PreferredSupplierID) VALUES
('RM001', 'All Purpose Flour', 'High quality all-purpose flour for baking', 1, 'kg', 500.00, 100.00, 12.50, 12.75, 12.60, 1),
('RM002', 'Granulated Sugar', 'Fine granulated white sugar', 2, 'kg', 250.00, 50.00, 18.75, 19.00, 18.85, 2),
('RM003', 'Butter - Unsalted', 'Premium unsalted butter for baking', 3, 'kg', 75.00, 25.00, 85.00, 87.50, 86.20, 2),
('RM004', 'Fresh Eggs', 'Grade A large fresh eggs', 3, 'dozen', 200.00, 50.00, 35.00, 36.00, 35.50, 2),
('RM005', 'Vanilla Extract', 'Pure vanilla extract', 4, 'ml', 15.00, 100.00, 0.25, 0.26, 0.255, 3);

-- Insert Sample Purchase Orders
INSERT INTO PurchaseOrders (PONumber, SupplierID, OrderDate, RequiredDate, Status, SubTotal, VATAmount, TotalAmount, Reference) VALUES
('PO-2024-001', 1, DATEADD(day, -5, GETDATE()), DATEADD(day, 2, GETDATE()), 'Sent', 1304.35, 195.65, 1500.00, 'Monthly Flour Order'),
('PO-2024-002', 2, DATEADD(day, -3, GETDATE()), DATEADD(day, 4, GETDATE()), 'Received', 695.65, 104.35, 800.00, 'Sugar & Dairy Restock'),
('PO-2024-003', 3, DATEADD(day, -1, GETDATE()), DATEADD(day, 7, GETDATE()), 'Draft', 434.78, 65.22, 500.00, 'Vanilla Extract Order');

-- Insert Sample Purchase Order Lines
INSERT INTO PurchaseOrderLines (PurchaseOrderID, MaterialID, OrderedQuantity, ReceivedQuantity, UnitCost, LineTotal, LineStatus) VALUES
(1, 1, 100.00, 0.00, 12.75, 1275.00, 'Pending'),
(1, 5, 50.00, 0.00, 0.26, 13.00, 'Pending'),
(2, 2, 25.00, 25.00, 19.00, 475.00, 'Received'),
(2, 3, 5.00, 5.00, 87.50, 437.50, 'Received'),
(3, 5, 200.00, 0.00, 0.26, 52.00, 'Pending');

-- Create Indexes for Performance
CREATE INDEX IX_StockMovements_MaterialID_Date ON StockMovements(MaterialID, MovementDate);
CREATE INDEX IX_PurchaseOrders_SupplierID_Date ON PurchaseOrders(SupplierID, OrderDate);
CREATE INDEX IX_RawMaterials_CategoryID ON RawMaterials(CategoryID);
CREATE INDEX IX_Suppliers_SupplierCode ON Suppliers(SupplierCode);

PRINT 'Stockroom Database Schema Created Successfully!'
