-- Create SupplierPaymentAllocations table to track which payments apply to which invoices

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'SupplierPaymentAllocations')
BEGIN
    CREATE TABLE dbo.SupplierPaymentAllocations (
        AllocationID INT IDENTITY(1,1) PRIMARY KEY,
        PaymentID INT NOT NULL,
        InvoiceID INT NOT NULL,
        AllocatedAmount DECIMAL(18,2) NOT NULL,
        AllocationDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_PaymentAlloc_Payment FOREIGN KEY (PaymentID) REFERENCES SupplierPayments(PaymentID),
        CONSTRAINT FK_PaymentAlloc_Invoice FOREIGN KEY (InvoiceID) REFERENCES SupplierInvoices(InvoiceID)
    );
    
    PRINT 'SupplierPaymentAllocations table created successfully!';
    
    -- Create indexes for fast lookups
    CREATE INDEX IX_PaymentAlloc_Payment ON dbo.SupplierPaymentAllocations(PaymentID);
    CREATE INDEX IX_PaymentAlloc_Invoice ON dbo.SupplierPaymentAllocations(InvoiceID);
    
    PRINT 'Indexes created on SupplierPaymentAllocations table.';
END
ELSE
BEGIN
    PRINT 'SupplierPaymentAllocations table already exists.';
END

GO

PRINT '';
PRINT 'SupplierPaymentAllocations table is ready!';
PRINT 'This table tracks which payments are allocated to which invoices.';
PRINT 'One payment can be split across multiple invoices.';
