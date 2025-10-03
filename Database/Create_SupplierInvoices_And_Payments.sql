-- =============================================
-- Supplier Invoices and Payments Tables
-- =============================================

-- Supplier Invoices Table
IF OBJECT_ID('dbo.SupplierInvoices','U') IS NULL
BEGIN
    CREATE TABLE dbo.SupplierInvoices (
        InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
        InvoiceNumber NVARCHAR(50) NOT NULL,
        SupplierID INT NOT NULL,
        BranchID INT NOT NULL,
        PurchaseOrderID INT NULL,
        InvoiceDate DATETIME NOT NULL,
        DueDate DATETIME NULL,
        SubTotal DECIMAL(18,4) NOT NULL,
        VATAmount DECIMAL(18,4) NOT NULL,
        TotalAmount DECIMAL(18,4) NOT NULL,
        AmountPaid DECIMAL(18,4) NOT NULL DEFAULT(0),
        AmountOutstanding AS (TotalAmount - AmountPaid) PERSISTED,
        Status NVARCHAR(20) NOT NULL DEFAULT('Unpaid'), -- Unpaid, PartiallyPaid, Paid, Cancelled
        Reference NVARCHAR(200) NULL,
        Notes NVARCHAR(500) NULL,
        CreatedBy INT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT(GETDATE()),
        ModifiedBy INT NULL,
        ModifiedDate DATETIME NULL,
        CONSTRAINT FK_SupplierInvoices_Supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
        CONSTRAINT FK_SupplierInvoices_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
        CONSTRAINT FK_SupplierInvoices_PO FOREIGN KEY (PurchaseOrderID) REFERENCES PurchaseOrders(PurchaseOrderID)
    );
    
    CREATE INDEX IX_SupplierInvoices_Supplier ON dbo.SupplierInvoices(SupplierID);
    CREATE INDEX IX_SupplierInvoices_Branch ON dbo.SupplierInvoices(BranchID);
    CREATE INDEX IX_SupplierInvoices_Status ON dbo.SupplierInvoices(Status);
    CREATE INDEX IX_SupplierInvoices_Date ON dbo.SupplierInvoices(InvoiceDate);
    CREATE UNIQUE INDEX UQ_SupplierInvoices_Number ON dbo.SupplierInvoices(InvoiceNumber, SupplierID);
    
    PRINT 'Created table: SupplierInvoices';
END
ELSE
BEGIN
    PRINT 'Table SupplierInvoices already exists';
END
GO

-- Supplier Invoice Lines Table
IF OBJECT_ID('dbo.SupplierInvoiceLines','U') IS NULL
BEGIN
    CREATE TABLE dbo.SupplierInvoiceLines (
        InvoiceLineID INT IDENTITY(1,1) PRIMARY KEY,
        InvoiceID INT NOT NULL,
        ItemID INT NOT NULL,
        ItemSource NVARCHAR(10) NOT NULL, -- 'RM' (RawMaterial) or 'PR' (Product)
        Description NVARCHAR(200) NULL,
        Quantity DECIMAL(18,4) NOT NULL,
        UnitCost DECIMAL(18,4) NOT NULL,
        LineTotal DECIMAL(18,4) NOT NULL,
        CONSTRAINT FK_SupplierInvoiceLines_Invoice FOREIGN KEY (InvoiceID) REFERENCES SupplierInvoices(InvoiceID) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_SupplierInvoiceLines_Invoice ON dbo.SupplierInvoiceLines(InvoiceID);
    
    PRINT 'Created table: SupplierInvoiceLines';
END
ELSE
BEGIN
    PRINT 'Table SupplierInvoiceLines already exists';
END
GO

-- Supplier Payments Table
IF OBJECT_ID('dbo.SupplierPayments','U') IS NULL
BEGIN
    CREATE TABLE dbo.SupplierPayments (
        PaymentID INT IDENTITY(1,1) PRIMARY KEY,
        PaymentNumber NVARCHAR(50) NOT NULL UNIQUE,
        SupplierID INT NOT NULL,
        BranchID INT NOT NULL,
        PaymentDate DATETIME NOT NULL,
        PaymentMethod NVARCHAR(20) NOT NULL, -- Cash, BankTransfer, Check, CreditNote
        PaymentAmount DECIMAL(18,4) NOT NULL,
        Reference NVARCHAR(200) NULL,
        CheckNumber NVARCHAR(50) NULL,
        BankAccount NVARCHAR(100) NULL,
        Notes NVARCHAR(500) NULL,
        CreatedBy INT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT(GETDATE()),
        CONSTRAINT FK_SupplierPayments_Supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
        CONSTRAINT FK_SupplierPayments_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    );
    
    CREATE INDEX IX_SupplierPayments_Supplier ON dbo.SupplierPayments(SupplierID);
    CREATE INDEX IX_SupplierPayments_Branch ON dbo.SupplierPayments(BranchID);
    CREATE INDEX IX_SupplierPayments_Date ON dbo.SupplierPayments(PaymentDate);
    
    PRINT 'Created table: SupplierPayments';
END
ELSE
BEGIN
    PRINT 'Table SupplierPayments already exists';
END
GO

-- Supplier Payment Allocations (Link payments to invoices)
IF OBJECT_ID('dbo.SupplierPaymentAllocations','U') IS NULL
BEGIN
    CREATE TABLE dbo.SupplierPaymentAllocations (
        AllocationID INT IDENTITY(1,1) PRIMARY KEY,
        PaymentID INT NOT NULL,
        InvoiceID INT NOT NULL,
        AllocatedAmount DECIMAL(18,4) NOT NULL,
        AllocationDate DATETIME NOT NULL DEFAULT(GETDATE()),
        CONSTRAINT FK_PaymentAllocations_Payment FOREIGN KEY (PaymentID) REFERENCES SupplierPayments(PaymentID) ON DELETE CASCADE,
        CONSTRAINT FK_PaymentAllocations_Invoice FOREIGN KEY (InvoiceID) REFERENCES SupplierInvoices(InvoiceID)
    );
    
    CREATE INDEX IX_PaymentAllocations_Payment ON dbo.SupplierPaymentAllocations(PaymentID);
    CREATE INDEX IX_PaymentAllocations_Invoice ON dbo.SupplierPaymentAllocations(InvoiceID);
    
    PRINT 'Created table: SupplierPaymentAllocations';
END
ELSE
BEGIN
    PRINT 'Table SupplierPaymentAllocations already exists';
END
GO

PRINT '';
PRINT '========================================';
PRINT 'Supplier Invoices and Payments created';
PRINT '========================================';
PRINT '';
PRINT 'TABLES CREATED:';
PRINT '1. SupplierInvoices - Invoice headers';
PRINT '2. SupplierInvoiceLines - Invoice line items';
PRINT '3. SupplierPayments - Payment records';
PRINT '4. SupplierPaymentAllocations - Link payments to invoices';
PRINT '';
PRINT 'FEATURES:';
PRINT '- Track supplier invoices per branch';
PRINT '- Link invoices to purchase orders';
PRINT '- Track payment status (Unpaid, PartiallyPaid, Paid)';
PRINT '- Multiple payment methods supported';
PRINT '- Payment allocation to specific invoices';
PRINT '- Automatic outstanding amount calculation';
GO
