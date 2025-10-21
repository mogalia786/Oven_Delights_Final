-- Create Suppliers table in Azure database with proper structure
-- This fixes the missing supplier data for InvoiceCaptureForm

-- Check if Suppliers table exists and has correct structure
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Suppliers')
BEGIN
    CREATE TABLE Suppliers (
        SupplierID INT IDENTITY(1,1) PRIMARY KEY,
        SupplierCode NVARCHAR(50),
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
        ModifiedDate DATETIME NULL
    )
    
    CREATE INDEX IX_Suppliers_Company ON Suppliers (CompanyName)
    CREATE INDEX IX_Suppliers_Active ON Suppliers (IsActive)
    
    PRINT 'Suppliers table created successfully'
END

-- Add missing columns if they don't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'CompanyName')
BEGIN
    ALTER TABLE Suppliers ADD CompanyName NVARCHAR(255) NOT NULL DEFAULT 'Unknown Company'
    PRINT 'CompanyName column added to Suppliers table'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'IsActive')
BEGIN
    ALTER TABLE Suppliers ADD IsActive BIT DEFAULT 1
    PRINT 'IsActive column added to Suppliers table'
END

-- Update existing records with proper data
UPDATE Suppliers SET 
    CompanyName = CASE 
        WHEN SupplierCode = 'UL10001' THEN 'ABC Raw Materials Ltd'
        WHEN SupplierCode = 'SUP003' THEN 'Premium Ingredients Co'
        ELSE 'Supplier ' + CAST(SupplierID AS NVARCHAR(10))
    END,
    IsActive = 1
WHERE CompanyName IS NULL OR CompanyName = ''

-- Insert additional test suppliers if needed
IF (SELECT COUNT(*) FROM Suppliers WHERE IsActive = 1) < 3
BEGIN
    INSERT INTO Suppliers (SupplierCode, CompanyName, ContactPerson, Phone, Email, IsActive)
    VALUES 
    ('SUP001', 'Quality Foods Suppliers', 'Mike Wilson', '031-555-0123', 'mike@qualityfoods.co.za', 1),
    ('SUP002', 'Fresh Produce Direct', 'Lisa Brown', '012-444-5678', 'lisa@freshproduce.co.za', 1),
    ('SUP004', 'Bulk Ingredients Inc', 'David Lee', '011-777-8888', 'david@bulkingredients.com', 1)
    
    PRINT 'Additional test suppliers inserted'
END

PRINT 'Suppliers table setup completed'
