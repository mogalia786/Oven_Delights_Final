-- Create AccountsPayable table for supplier invoice management
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AccountsPayable')
BEGIN
    CREATE TABLE AccountsPayable (
        PayableID INT IDENTITY(1,1) PRIMARY KEY,
        InvoiceNumber NVARCHAR(50) NOT NULL,
        SupplierID INT NOT NULL,
        SupplierName NVARCHAR(255) NOT NULL,
        GLAccountCode NVARCHAR(20) NOT NULL,
        InvoiceDate DATE NOT NULL,
        DueDate DATE NOT NULL,
        Amount DECIMAL(18,2) NOT NULL,
        AmountPaid DECIMAL(18,2) DEFAULT 0,
        Description NVARCHAR(500),
        IsPaid BIT DEFAULT 0,
        PaidDate DATE NULL,
        Status NVARCHAR(20) DEFAULT 'Pending',
        CreatedBy INT NOT NULL,
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedBy INT NULL,
        ModifiedDate DATETIME NULL,
        
        INDEX IX_AccountsPayable_Supplier (SupplierID),
        INDEX IX_AccountsPayable_DueDate (DueDate),
        INDEX IX_AccountsPayable_Status (Status)
    )
    
    PRINT 'AccountsPayable table created successfully'
END
ELSE
BEGIN
    PRINT 'AccountsPayable table already exists'
END

-- Insert sample data for testing
IF NOT EXISTS (SELECT * FROM AccountsPayable)
BEGIN
    INSERT INTO AccountsPayable (InvoiceNumber, SupplierID, SupplierName, GLAccountCode, InvoiceDate, DueDate, Amount, Description, CreatedBy)
    VALUES 
    ('INV-001', 1, 'Test Supplier 1', '5000', '2024-01-01', '2024-01-31', 1500.00, 'Office supplies', 1),
    ('INV-002', 2, 'Test Supplier 2', '5100', '2024-01-15', '2024-02-14', 2500.00, 'Equipment rental', 1),
    ('INV-003', 1, 'Test Supplier 1', '5200', '2024-02-01', '2024-03-01', 750.00, 'Maintenance services', 1)
    
    PRINT 'Sample AccountsPayable data inserted'
END

-- Create APInvoices table if referenced in code
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'APInvoices')
BEGIN
    CREATE TABLE APInvoices (
        InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
        InvoiceNumber NVARCHAR(50) NOT NULL,
        SupplierID INT NOT NULL,
        GLAccountCode NVARCHAR(20) NOT NULL,
        InvoiceDate DATE NOT NULL,
        DueDate DATE NOT NULL,
        Amount DECIMAL(18,2) NOT NULL,
        Description NVARCHAR(500),
        IsPaid BIT DEFAULT 0,
        PaidDate DATE NULL,
        CreatedBy INT NOT NULL,
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedBy INT NULL,
        ModifiedDate DATETIME NULL
    )
    
    PRINT 'APInvoices table created successfully'
END

PRINT 'Accounts Payable database setup completed'
