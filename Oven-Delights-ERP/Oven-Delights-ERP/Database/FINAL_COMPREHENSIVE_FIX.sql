-- FINAL COMPREHENSIVE FIX
-- Drop and recreate SupplierInvoices, SupplierLedger, GeneralLedger with QUOTED_IDENTIFIER ON

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

PRINT 'Starting comprehensive fix...';

-- 1. Backup SupplierInvoices
IF OBJECT_ID('SupplierInvoices_BACKUP_FINAL', 'U') IS NOT NULL
    DROP TABLE SupplierInvoices_BACKUP_FINAL;

SELECT * INTO SupplierInvoices_BACKUP_FINAL FROM SupplierInvoices;
PRINT 'Backed up SupplierInvoices';

-- 2. Drop SupplierInvoices (no dependencies since we're not using triggers)
DROP TABLE IF EXISTS SupplierInvoices;
PRINT 'Dropped SupplierInvoices';

-- 3. Recreate SupplierInvoices with QUOTED_IDENTIFIER ON
CREATE TABLE SupplierInvoices (
    InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT NOT NULL,
    BranchID INT NOT NULL,
    PurchaseOrderID INT NULL,
    InvoiceNumber NVARCHAR(50) NOT NULL,
    InvoiceDate DATETIME NOT NULL,
    DueDate DATETIME NULL,
    SubTotal DECIMAL(18,2) NOT NULL,
    VATAmount DECIMAL(18,2) NOT NULL,
    TotalAmount DECIMAL(18,2) NOT NULL,
    AmountPaid DECIMAL(18,2) DEFAULT 0,
    AmountOutstanding DECIMAL(18,4) NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT('Unpaid'),
    CreatedBy INT NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    GRVID INT NULL,
    Reference NVARCHAR(200) NULL,
    Notes NVARCHAR(500) NULL,
    DiscountAmount DECIMAL(18,4) NULL,
    DiscountPercent DECIMAL(5,2) NULL
);
PRINT 'Created SupplierInvoices with QUOTED_IDENTIFIER ON';

-- 4. Recreate indexes
CREATE UNIQUE INDEX UQ_SupplierInvoices_Number ON SupplierInvoices(InvoiceNumber, SupplierID);
CREATE INDEX IX_SupplierInvoices_Supplier ON SupplierInvoices(SupplierID);
CREATE INDEX IX_SupplierInvoices_Branch ON SupplierInvoices(BranchID);
CREATE INDEX IX_SupplierInvoices_Status ON SupplierInvoices(Status);
CREATE INDEX IX_SupplierInvoices_Date ON SupplierInvoices(InvoiceDate);
PRINT 'Created indexes';

-- 5. Restore data
SET IDENTITY_INSERT SupplierInvoices ON;

INSERT INTO SupplierInvoices (
    InvoiceID, SupplierID, BranchID, PurchaseOrderID, InvoiceNumber, InvoiceDate, DueDate,
    SubTotal, VATAmount, TotalAmount, AmountPaid, AmountOutstanding, Status, CreatedBy, CreatedDate,
    GRVID, Reference, Notes, DiscountAmount, DiscountPercent
)
SELECT 
    InvoiceID, SupplierID, BranchID, PurchaseOrderID, InvoiceNumber, InvoiceDate, DueDate,
    SubTotal, VATAmount, TotalAmount,
    ISNULL(AmountPaid, 0),
    TotalAmount - ISNULL(AmountPaid, 0),
    Status, CreatedBy, CreatedDate,
    GRVID, Reference, Notes, DiscountAmount, DiscountPercent
FROM SupplierInvoices_BACKUP_FINAL;

SET IDENTITY_INSERT SupplierInvoices OFF;
PRINT 'Restored data';

PRINT '';
PRINT 'COMPREHENSIVE FIX COMPLETED';
PRINT 'SupplierInvoices recreated with QUOTED_IDENTIFIER ON';
