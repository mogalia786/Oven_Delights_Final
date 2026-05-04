-- =============================================
-- Create SupplierInvoicePayments Table
-- Tracks payments made against supplier invoices
-- =============================================

IF OBJECT_ID('dbo.SupplierInvoicePayments', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.SupplierInvoicePayments (
        PaymentID INT IDENTITY(1,1) PRIMARY KEY,
        InvoiceID INT NOT NULL,
        SupplierID INT NOT NULL,
        PaymentDate DATE NOT NULL,
        PaymentAmount DECIMAL(18,2) NOT NULL,
        PaymentMethod NVARCHAR(50) NOT NULL, -- EFT, Cash, Cheque, etc.
        Reference NVARCHAR(200) NULL,
        BankAccountCode NVARCHAR(20) NULL,
        BranchID INT NOT NULL,
        CreatedBy INT NOT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        
        CONSTRAINT FK_SupplierInvoicePayments_Supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
        CONSTRAINT FK_SupplierInvoicePayments_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    );
    
    CREATE INDEX IX_SupplierInvoicePayments_Invoice ON dbo.SupplierInvoicePayments(InvoiceID);
    CREATE INDEX IX_SupplierInvoicePayments_Supplier ON dbo.SupplierInvoicePayments(SupplierID);
    CREATE INDEX IX_SupplierInvoicePayments_Date ON dbo.SupplierInvoicePayments(PaymentDate);
    
    PRINT 'Created table: SupplierInvoicePayments';
END
ELSE
BEGIN
    PRINT 'Table SupplierInvoicePayments already exists';
END
GO
