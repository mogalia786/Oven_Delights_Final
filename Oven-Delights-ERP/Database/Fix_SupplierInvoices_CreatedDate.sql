-- Add CreatedDate column to SupplierInvoices if missing

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.SupplierInvoices') AND name = 'CreatedDate')
BEGIN
    ALTER TABLE dbo.SupplierInvoices
    ADD CreatedDate DATETIME NOT NULL DEFAULT(GETDATE());
    
    PRINT 'Added CreatedDate column to SupplierInvoices';
END
ELSE
BEGIN
    PRINT 'CreatedDate column already exists in SupplierInvoices';
END
GO

-- Also check GRVID column
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.SupplierInvoices') AND name = 'GRVID')
BEGIN
    ALTER TABLE dbo.SupplierInvoices
    ADD GRVID INT NULL;
    
    PRINT 'Added GRVID column to SupplierInvoices';
END
ELSE
BEGIN
    PRINT 'GRVID column already exists in SupplierInvoices';
END
GO

PRINT 'SupplierInvoices table is ready';
