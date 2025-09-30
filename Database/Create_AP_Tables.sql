-- Create Accounts Payable Tables
-- This script creates the necessary tables for the Accounts Payable module

-- APInvoices table for storing invoice information
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'APInvoices')
BEGIN
    CREATE TABLE APInvoices (
        InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
        InvoiceNumber NVARCHAR(50) NOT NULL UNIQUE,
        SupplierID INT NOT NULL,
        GLAccountCode NVARCHAR(20) NOT NULL,
        InvoiceDate DATE NOT NULL,
        DueDate DATE NOT NULL,
        Amount DECIMAL(18,2) NOT NULL,
        Description NVARCHAR(500),
        IsPaid BIT NOT NULL DEFAULT 0,
        PaidDate DATE NULL,
        CreatedBy INT NOT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ModifiedBy INT NULL,
        ModifiedDate DATETIME NULL,
        CONSTRAINT FK_APInvoices_Suppliers FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
        CONSTRAINT FK_APInvoices_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
        CONSTRAINT FK_APInvoices_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID)
    )
    
    PRINT 'APInvoices table created successfully'
END
ELSE
BEGIN
    PRINT 'APInvoices table already exists'
END

-- GLAccounts table for General Ledger accounts (if not exists)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'GLAccounts')
BEGIN
    CREATE TABLE GLAccounts (
        AccountCode NVARCHAR(20) PRIMARY KEY,
        AccountName NVARCHAR(100) NOT NULL,
        AccountType NVARCHAR(20) NOT NULL, -- Asset, Liability, Equity, Revenue, Expense
        ParentAccountCode NVARCHAR(20) NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_GLAccounts_Parent FOREIGN KEY (ParentAccountCode) REFERENCES GLAccounts(AccountCode)
    )
    
    PRINT 'GLAccounts table created successfully'
    
    -- Insert default GL accounts for AP
    INSERT INTO GLAccounts (AccountCode, AccountName, AccountType) VALUES
    ('2000', 'Accounts Payable', 'Liability'),
    ('5000', 'Cost of Goods Sold', 'Expense'),
    ('5100', 'Office Supplies', 'Expense'),
    ('5200', 'Utilities', 'Expense'),
    ('5300', 'Rent Expense', 'Expense'),
    ('5400', 'Insurance', 'Expense'),
    ('5500', 'Professional Services', 'Expense'),
    ('1200', 'Inventory', 'Asset'),
    ('1300', 'Equipment', 'Asset')
    
    PRINT 'Default GL accounts inserted'
END
ELSE
BEGIN
    PRINT 'GLAccounts table already exists'
END

-- Create indexes for better performance
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_APInvoices_SupplierID')
BEGIN
    CREATE INDEX IX_APInvoices_SupplierID ON APInvoices(SupplierID)
    PRINT 'Index IX_APInvoices_SupplierID created'
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_APInvoices_DueDate')
BEGIN
    CREATE INDEX IX_APInvoices_DueDate ON APInvoices(DueDate)
    PRINT 'Index IX_APInvoices_DueDate created'
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_APInvoices_IsPaid')
BEGIN
    CREATE INDEX IX_APInvoices_IsPaid ON APInvoices(IsPaid)
    PRINT 'Index IX_APInvoices_IsPaid created'
END

PRINT 'Accounts Payable database schema setup completed successfully!'
