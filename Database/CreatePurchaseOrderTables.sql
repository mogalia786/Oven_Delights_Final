-- Create Purchase Order tables for Stockroom module
-- This fixes the "Invalid object name 'Stockroom_PurchaseOrders'" error

-- Create Stockroom_PurchaseOrders table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Stockroom_PurchaseOrders')
BEGIN
    CREATE TABLE Stockroom_PurchaseOrders (
        POID INT IDENTITY(1,1) PRIMARY KEY,
        PONumber NVARCHAR(50) NOT NULL UNIQUE,
        SupplierID INT NOT NULL,
        BranchID INT NULL,
        PODate DATE NOT NULL,
        RequiredDate DATE NULL,
        Status NVARCHAR(20) DEFAULT 'Draft',
        SubTotal DECIMAL(18,2) DEFAULT 0,
        VATAmount DECIMAL(18,2) DEFAULT 0,
        TotalAmount DECIMAL(18,2) DEFAULT 0,
        Notes NVARCHAR(500),
        CreatedBy INT NOT NULL,
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedBy INT NULL,
        ModifiedDate DATETIME NULL,
        ApprovedBy INT NULL,
        ApprovedDate DATETIME NULL,
        
        INDEX IX_Stockroom_PO_Supplier (SupplierID),
        INDEX IX_Stockroom_PO_Status (Status),
        INDEX IX_Stockroom_PO_Date (PODate)
    )
    
    PRINT 'Stockroom_PurchaseOrders table created successfully'
END
ELSE
BEGIN
    PRINT 'Stockroom_PurchaseOrders table already exists'
END

-- Create Stockroom_PurchaseOrderLines table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Stockroom_PurchaseOrderLines')
BEGIN
    CREATE TABLE Stockroom_PurchaseOrderLines (
        POLineID INT IDENTITY(1,1) PRIMARY KEY,
        POID INT NOT NULL,
        MaterialID INT NOT NULL,
        MaterialCode NVARCHAR(50),
        MaterialName NVARCHAR(255),
        OrderQuantity DECIMAL(18,3) NOT NULL,
        ReceivedQuantity DECIMAL(18,3) DEFAULT 0,
        UnitCost DECIMAL(18,4) NOT NULL,
        LineTotal DECIMAL(18,2) NOT NULL,
        Notes NVARCHAR(255),
        
        FOREIGN KEY (POID) REFERENCES Stockroom_PurchaseOrders(POID),
        INDEX IX_Stockroom_POLines_PO (POID),
        INDEX IX_Stockroom_POLines_Material (MaterialID)
    )
    
    PRINT 'Stockroom_PurchaseOrderLines table created successfully'
END
ELSE
BEGIN
    PRINT 'Stockroom_PurchaseOrderLines table already exists'
END

-- Create PurchaseOrders table (legacy compatibility)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PurchaseOrders')
BEGIN
    CREATE TABLE PurchaseOrders (
        PurchaseOrderID INT IDENTITY(1,1) PRIMARY KEY,
        PONumber NVARCHAR(50) NOT NULL UNIQUE,
        SupplierID INT NOT NULL,
        BranchID INT NULL,
        PODate DATE NOT NULL,
        RequiredDate DATE NULL,
        Status NVARCHAR(20) DEFAULT 'Draft',
        SubTotal DECIMAL(18,2) DEFAULT 0,
        VATAmount DECIMAL(18,2) DEFAULT 0,
        TotalAmount DECIMAL(18,2) DEFAULT 0,
        Notes NVARCHAR(500),
        CreatedBy INT NOT NULL,
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedBy INT NULL,
        ModifiedDate DATETIME NULL,
        
        INDEX IX_PO_Supplier (SupplierID),
        INDEX IX_PO_Status (Status)
    )
    
    PRINT 'PurchaseOrders table created successfully'
END

-- Insert sample data for testing
IF NOT EXISTS (SELECT * FROM Stockroom_PurchaseOrders)
BEGIN
    INSERT INTO Stockroom_PurchaseOrders (PONumber, SupplierID, PODate, Status, SubTotal, VATAmount, TotalAmount, CreatedBy)
    VALUES 
    ('PO-2024-001', 1, '2024-01-15', 'Approved', 5000.00, 750.00, 5750.00, 1),
    ('PO-2024-002', 2, '2024-02-01', 'Pending', 3200.00, 480.00, 3680.00, 1),
    ('PO-2024-003', 1, '2024-02-15', 'Draft', 1800.00, 270.00, 2070.00, 1)
    
    PRINT 'Sample Stockroom_PurchaseOrders data inserted'
END

IF NOT EXISTS (SELECT * FROM Stockroom_PurchaseOrderLines)
BEGIN
    INSERT INTO Stockroom_PurchaseOrderLines (POID, MaterialID, MaterialCode, MaterialName, OrderQuantity, UnitCost, LineTotal)
    VALUES 
    (1, 101, 'MAT-001', 'Raw Material A', 100.000, 25.00, 2500.00),
    (1, 102, 'MAT-002', 'Raw Material B', 50.000, 50.00, 2500.00),
    (2, 103, 'MAT-003', 'Raw Material C', 80.000, 40.00, 3200.00),
    (3, 101, 'MAT-001', 'Raw Material A', 72.000, 25.00, 1800.00)
    
    PRINT 'Sample Stockroom_PurchaseOrderLines data inserted'
END

PRINT 'Purchase Order database setup completed'
