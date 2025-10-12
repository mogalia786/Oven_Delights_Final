-- Create Suppliers table for Stockroom module
-- This fixes the missing Suppliers table error

-- Create Suppliers table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Suppliers')
BEGIN
    CREATE TABLE Suppliers (
        SupplierID INT IDENTITY(1,1) PRIMARY KEY,
        CompanyName NVARCHAR(255) NOT NULL,
        ContactPerson NVARCHAR(100),
        Phone NVARCHAR(20),
        Email NVARCHAR(100),
        Address NVARCHAR(500),
        City NVARCHAR(100),
        PostalCode NVARCHAR(20),
        Country NVARCHAR(100),
        VATNumber NVARCHAR(50),
        PaymentTerms NVARCHAR(100),
        CreditLimit DECIMAL(18,2) DEFAULT 0,
        IsActive BIT DEFAULT 1,
        CreatedBy INT NOT NULL DEFAULT 1,
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedBy INT NULL,
        ModifiedDate DATETIME NULL,
        
        INDEX IX_Suppliers_Company (CompanyName),
        INDEX IX_Suppliers_Active (IsActive)
    )
    
    PRINT 'Suppliers table created successfully'
END
ELSE
BEGIN
    PRINT 'Suppliers table already exists'
END

-- Insert sample suppliers for testing
IF NOT EXISTS (SELECT * FROM Suppliers)
BEGIN
    INSERT INTO Suppliers (CompanyName, ContactPerson, Phone, Email, Address, City, PostalCode, Country, PaymentTerms, CreditLimit)
    VALUES 
    ('ABC Raw Materials Ltd', 'John Smith', '011-123-4567', 'john@abcraw.com', '123 Industrial Ave', 'Johannesburg', '2001', 'South Africa', '30 Days', 50000.00),
    ('Premium Ingredients Co', 'Sarah Johnson', '021-987-6543', 'sarah@premium.co.za', '456 Supply Street', 'Cape Town', '8001', 'South Africa', '45 Days', 75000.00),
    ('Quality Foods Suppliers', 'Mike Wilson', '031-555-0123', 'mike@qualityfoods.co.za', '789 Food Park', 'Durban', '4001', 'South Africa', '30 Days', 60000.00),
    ('Fresh Produce Direct', 'Lisa Brown', '012-444-5678', 'lisa@freshproduce.co.za', '321 Market Road', 'Pretoria', '0001', 'South Africa', '15 Days', 25000.00),
    ('Bulk Ingredients Inc', 'David Lee', '011-777-8888', 'david@bulkingredients.com', '654 Warehouse Blvd', 'Johannesburg', '2094', 'South Africa', '60 Days', 100000.00)
    
    PRINT 'Sample Suppliers data inserted'
END

-- Create Materials table if it doesn't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Materials')
BEGIN
    CREATE TABLE Materials (
        MaterialID INT IDENTITY(1,1) PRIMARY KEY,
        MaterialCode NVARCHAR(50) NOT NULL UNIQUE,
        MaterialName NVARCHAR(255) NOT NULL,
        Category NVARCHAR(100),
        UnitOfMeasure NVARCHAR(20),
        StandardCost DECIMAL(18,4) DEFAULT 0,
        ReorderLevel DECIMAL(18,3) DEFAULT 0,
        MaxStockLevel DECIMAL(18,3) DEFAULT 0,
        SupplierID INT NULL,
        IsActive BIT DEFAULT 1,
        CreatedDate DATETIME DEFAULT GETDATE(),
        
        FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
        INDEX IX_Materials_Code (MaterialCode),
        INDEX IX_Materials_Supplier (SupplierID)
    )
    
    PRINT 'Materials table created successfully'
END

-- Insert sample materials
IF NOT EXISTS (SELECT * FROM Materials)
BEGIN
    INSERT INTO Materials (MaterialCode, MaterialName, Category, UnitOfMeasure, StandardCost, ReorderLevel, MaxStockLevel, SupplierID)
    VALUES 
    ('MAT-001', 'Flour - Bread Grade', 'Raw Materials', 'KG', 25.00, 100.000, 1000.000, 1),
    ('MAT-002', 'Sugar - White Refined', 'Raw Materials', 'KG', 50.00, 50.000, 500.000, 1),
    ('MAT-003', 'Butter - Unsalted', 'Dairy', 'KG', 40.00, 25.000, 200.000, 2),
    ('MAT-004', 'Eggs - Grade A Large', 'Dairy', 'DOZEN', 35.00, 20.000, 100.000, 4),
    ('MAT-005', 'Vanilla Extract', 'Flavoring', 'ML', 0.50, 500.000, 2000.000, 3)
    
    PRINT 'Sample Materials data inserted'
END

PRINT 'Suppliers and Materials database setup completed'
