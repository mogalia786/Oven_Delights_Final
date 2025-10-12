-- Fix Database Schema Issues
-- This script fixes missing columns and schema problems causing application errors

USE [OvenDelightsERP]
GO

-- Fix Roles table - ensure Description and IsActive columns exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Roles') AND name = 'Description')
BEGIN
    ALTER TABLE Roles ADD Description NVARCHAR(255) NULL
    PRINT 'Added Description column to Roles table'
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Roles') AND name = 'IsActive')
BEGIN
    ALTER TABLE Roles ADD IsActive BIT NOT NULL DEFAULT 1
    PRINT 'Added IsActive column to Roles table'
END

-- Fix Users table - ensure all required columns exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Users') AND name = 'IsActive')
BEGIN
    ALTER TABLE Users ADD IsActive BIT NOT NULL DEFAULT 1
    PRINT 'Added IsActive column to Users table'
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Users') AND name = 'CreatedDate')
BEGIN
    ALTER TABLE Users ADD CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
    PRINT 'Added CreatedDate column to Users table'
END

-- Ensure AuditLog table exists with proper structure
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AuditLog')
BEGIN
    CREATE TABLE AuditLog (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        UserID INT NULL,
        Action NVARCHAR(100) NOT NULL,
        TableName NVARCHAR(50) NULL,
        RecordID INT NULL,
        OldValues NVARCHAR(MAX) NULL,
        NewValues NVARCHAR(MAX) NULL,
        Timestamp DATETIME NOT NULL DEFAULT GETDATE(),
        IPAddress NVARCHAR(45) NULL,
        Details NVARCHAR(500) NULL,
        CONSTRAINT FK_AuditLog_Users FOREIGN KEY (UserID) REFERENCES Users(UserID)
    )
    PRINT 'Created AuditLog table'
END

-- Ensure Stockroom inventory tables exist
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'StockroomInventory')
BEGIN
    CREATE TABLE StockroomInventory (
        ProductID INT IDENTITY(1,1) PRIMARY KEY,
        ProductCode NVARCHAR(50) NOT NULL UNIQUE,
        ProductName NVARCHAR(200) NOT NULL,
        Category NVARCHAR(100) NULL,
        Subcategory NVARCHAR(100) NULL,
        UnitOfMeasure NVARCHAR(20) NOT NULL,
        CostPrice DECIMAL(18,2) NOT NULL DEFAULT 0,
        SellingPrice DECIMAL(18,2) NOT NULL DEFAULT 0,
        ReorderLevel INT NOT NULL DEFAULT 0,
        MaxStockLevel INT NOT NULL DEFAULT 0,
        CurrentStock INT NOT NULL DEFAULT 0,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        ModifiedDate DATETIME NULL,
        ModifiedBy INT NULL,
        CONSTRAINT FK_StockroomInventory_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
        CONSTRAINT FK_StockroomInventory_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID)
    )
    PRINT 'Created StockroomInventory table'
END

-- Ensure RetailInventory table exists
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'RetailInventory')
BEGIN
    CREATE TABLE RetailInventory (
        ProductID INT IDENTITY(1,1) PRIMARY KEY,
        ProductCode NVARCHAR(50) NOT NULL UNIQUE,
        ProductName NVARCHAR(200) NOT NULL,
        Category NVARCHAR(100) NULL,
        UnitOfMeasure NVARCHAR(20) NOT NULL,
        SellingPrice DECIMAL(18,2) NOT NULL DEFAULT 0,
        CurrentStock INT NOT NULL DEFAULT 0,
        ReorderLevel INT NOT NULL DEFAULT 0,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        CONSTRAINT FK_RetailInventory_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
    )
    PRINT 'Created RetailInventory table'
END

-- Ensure InventoryAdjustments table exists
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'InventoryAdjustments')
BEGIN
    CREATE TABLE InventoryAdjustments (
        AdjustmentID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        AdjustmentType NVARCHAR(50) NOT NULL, -- 'Increase', 'Decrease', 'Count'
        Quantity INT NOT NULL,
        Reason NVARCHAR(500) NULL,
        AdjustmentDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NOT NULL,
        CONSTRAINT FK_InventoryAdjustments_Product FOREIGN KEY (ProductID) REFERENCES StockroomInventory(ProductID),
        CONSTRAINT FK_InventoryAdjustments_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
    )
    PRINT 'Created InventoryAdjustments table'
END

-- Insert sample data if tables are empty
IF NOT EXISTS (SELECT * FROM StockroomInventory)
BEGIN
    INSERT INTO StockroomInventory (ProductCode, ProductName, Category, UnitOfMeasure, CostPrice, SellingPrice, CurrentStock, ReorderLevel, MaxStockLevel)
    VALUES 
    ('FLOUR001', 'All Purpose Flour', 'Raw Materials', 'KG', 15.50, 18.00, 100, 20, 500),
    ('SUGAR001', 'White Sugar', 'Raw Materials', 'KG', 12.00, 14.50, 75, 15, 300),
    ('BUTTER001', 'Butter', 'Raw Materials', 'KG', 45.00, 52.00, 25, 10, 100),
    ('COKE001', 'Coca Cola 330ml', 'Ready-Made', 'UNIT', 8.50, 12.00, 150, 50, 500),
    ('CHIPS001', 'Potato Chips', 'Ready-Made', 'UNIT', 6.00, 9.50, 80, 20, 200)
    PRINT 'Inserted sample stockroom inventory data'
END

IF NOT EXISTS (SELECT * FROM RetailInventory)
BEGIN
    INSERT INTO RetailInventory (ProductCode, ProductName, Category, UnitOfMeasure, SellingPrice, CurrentStock, ReorderLevel)
    VALUES 
    ('CAKE001', 'Chocolate Cake', 'Bakery', 'UNIT', 85.00, 5, 2),
    ('BREAD001', 'White Bread', 'Bakery', 'UNIT', 12.50, 20, 5),
    ('MUFFIN001', 'Blueberry Muffin', 'Bakery', 'UNIT', 15.00, 12, 3),
    ('COKE001', 'Coca Cola 330ml', 'Beverages', 'UNIT', 12.00, 50, 10),
    ('CHIPS001', 'Potato Chips', 'Snacks', 'UNIT', 9.50, 30, 5)
    PRINT 'Inserted sample retail inventory data'
END

PRINT 'Database schema fixes completed successfully!'
