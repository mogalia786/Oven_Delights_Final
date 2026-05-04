-- =============================================
-- Drop and recreate SupplierInvoices table
-- WARNING: This will delete all existing invoice data
-- =============================================

PRINT 'Dropping and recreating SupplierInvoices table...'
PRINT 'WARNING: All existing invoice data will be lost!'

-- Drop dependent objects first
IF OBJECT_ID('trg_SyncSupplierInvoiceToAP', 'TR') IS NOT NULL
    DROP TRIGGER trg_SyncSupplierInvoiceToAP;

IF OBJECT_ID('trg_SupplierInvoices_CalculateOutstanding', 'TR') IS NOT NULL
    DROP TRIGGER trg_SupplierInvoices_CalculateOutstanding;

-- Drop dependent tables first
DROP TABLE IF EXISTS SupplierInvoiceLines;
PRINT 'Dropped SupplierInvoiceLines table'

-- Drop foreign key from SupplierPaymentAllocations
ALTER TABLE SupplierPaymentAllocations DROP CONSTRAINT IF EXISTS FK_PaymentAllocations_Invoice;

-- Drop the main table
DROP TABLE IF EXISTS SupplierInvoices;
PRINT 'Dropped SupplierInvoices table'

-- Recreate the table WITHOUT computed column
CREATE TABLE SupplierInvoices (
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
    AmountOutstanding DECIMAL(18,4) NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT('Unpaid'),
    Reference NVARCHAR(200) NULL,
    Notes NVARCHAR(500) NULL,
    DiscountAmount DECIMAL(18,4) NULL DEFAULT 0,
    DiscountPercent DECIMAL(5,2) NULL DEFAULT 0,
    CreatedBy INT NULL,
    CreatedDate DATETIME NOT NULL DEFAULT(GETDATE()),
    ModifiedBy INT NULL,
    ModifiedDate DATETIME NULL,
    GRVID INT NULL,
    CONSTRAINT FK_SupplierInvoices_Supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    CONSTRAINT FK_SupplierInvoices_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
    CONSTRAINT FK_SupplierInvoices_PO FOREIGN KEY (PurchaseOrderID) REFERENCES PurchaseOrders(PurchaseOrderID)
);

PRINT 'Created SupplierInvoices table'

-- Recreate indexes
CREATE INDEX IX_SupplierInvoices_Supplier ON SupplierInvoices(SupplierID);
CREATE INDEX IX_SupplierInvoices_Branch ON SupplierInvoices(BranchID);
CREATE INDEX IX_SupplierInvoices_Status ON SupplierInvoices(Status);
CREATE INDEX IX_SupplierInvoices_Date ON SupplierInvoices(InvoiceDate);
CREATE UNIQUE INDEX UQ_SupplierInvoices_Number ON SupplierInvoices(InvoiceNumber, SupplierID);

PRINT 'Created indexes'

-- Recreate SupplierInvoiceLines table
CREATE TABLE SupplierInvoiceLines (
    InvoiceLineID INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceID INT NOT NULL,
    LineNumber INT NULL,
    ItemID INT NULL,
    ItemSource NVARCHAR(10) NULL,
    ProductCode NVARCHAR(50) NULL,
    ProductName NVARCHAR(200) NULL,
    Description NVARCHAR(200) NULL,
    Quantity DECIMAL(18,4) NOT NULL,
    UnitPrice DECIMAL(18,4) NOT NULL,
    UnitCost DECIMAL(18,4) NULL,
    LineTotal DECIMAL(18,4) NOT NULL,
    CONSTRAINT FK_SupplierInvoiceLines_Invoice 
    FOREIGN KEY (InvoiceID) REFERENCES SupplierInvoices(InvoiceID) ON DELETE CASCADE
);

CREATE INDEX IX_SupplierInvoiceLines_Invoice ON SupplierInvoiceLines(InvoiceID);

PRINT 'Created SupplierInvoiceLines table'

-- Recreate foreign keys for dependent tables

ALTER TABLE SupplierPaymentAllocations 
ADD CONSTRAINT FK_PaymentAllocations_Invoice 
FOREIGN KEY (InvoiceID) REFERENCES SupplierInvoices(InvoiceID);

PRINT 'Recreated foreign keys'
GO

-- Create trigger to auto-calculate AmountOutstanding
CREATE TRIGGER trg_SupplierInvoices_CalculateOutstanding
ON SupplierInvoices
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE si
    SET AmountOutstanding = si.TotalAmount - ISNULL(si.AmountPaid, 0)
    FROM SupplierInvoices si
    INNER JOIN inserted i ON si.InvoiceID = i.InvoiceID;
END
GO

PRINT 'Created trigger for AmountOutstanding calculation'
PRINT ''
PRINT 'Table recreated successfully!'
PRINT 'AmountOutstanding is now a regular column with automatic calculation via trigger'
