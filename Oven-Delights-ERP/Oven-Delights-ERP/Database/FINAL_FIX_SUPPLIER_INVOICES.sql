-- FINAL FIX: Recreate SupplierInvoices table with QUOTED_IDENTIFIER ON
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

PRINT 'Starting final fix for SupplierInvoices table...'

-- 1. Backup existing data
IF OBJECT_ID('SupplierInvoices_FINAL_BACKUP', 'U') IS NOT NULL
    DROP TABLE SupplierInvoices_FINAL_BACKUP;

SELECT * INTO SupplierInvoices_FINAL_BACKUP FROM SupplierInvoices;
PRINT 'Backed up SupplierInvoices data'

IF OBJECT_ID('SupplierInvoiceLines_FINAL_BACKUP', 'U') IS NOT NULL
    DROP TABLE SupplierInvoiceLines_FINAL_BACKUP;

IF OBJECT_ID('SupplierInvoiceLines', 'U') IS NOT NULL
BEGIN
    SELECT * INTO SupplierInvoiceLines_FINAL_BACKUP FROM SupplierInvoiceLines;
    PRINT 'Backed up SupplierInvoiceLines data'
END
ELSE
BEGIN
    PRINT 'SupplierInvoiceLines table does not exist - skipping backup'
END

-- 2. Drop all foreign key constraints referencing SupplierInvoices
DECLARE @sql NVARCHAR(MAX) = '';
SELECT @sql += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
               ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.foreign_keys
WHERE referenced_object_id = OBJECT_ID('SupplierInvoices');

IF @sql <> ''
BEGIN
    EXEC sp_executesql @sql;
    PRINT 'Dropped all foreign key constraints referencing SupplierInvoices'
END

-- 3. Drop dependent objects
DROP TABLE IF EXISTS SupplierInvoiceLines;
PRINT 'Dropped SupplierInvoiceLines'

DROP TABLE IF EXISTS SupplierInvoices;
PRINT 'Dropped SupplierInvoices'

-- 4. Recreate SupplierInvoices with QUOTED_IDENTIFIER ON
CREATE TABLE SupplierInvoices (
    InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT NOT NULL,
    BranchID INT NOT NULL,
    PurchaseOrderID INT NULL,
    InvoiceNumber NVARCHAR(50) NOT NULL,
    InvoiceDate DATE NOT NULL,
    DueDate DATE NULL,
    SubTotal DECIMAL(18,2) NOT NULL,
    VATAmount DECIMAL(18,2) NOT NULL,
    TotalAmount DECIMAL(18,2) NOT NULL,
    AmountPaid DECIMAL(18,2) DEFAULT 0,
    AmountOutstanding DECIMAL(18,4) NULL,
    Status NVARCHAR(20) NOT NULL,
    CreatedBy NVARCHAR(100) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    GRVID INT NULL,
    Reference NVARCHAR(200) NULL,
    Notes NVARCHAR(500) NULL,
    DiscountAmount DECIMAL(18,4) NULL,
    DiscountPercent DECIMAL(5,2) NULL
);
PRINT 'Created SupplierInvoices table with QUOTED_IDENTIFIER ON'

-- 5. Recreate SupplierInvoiceLines
CREATE TABLE SupplierInvoiceLines (
    InvoiceLineID INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceID INT NOT NULL,
    LineNumber INT NULL,
    ItemID INT NULL,
    ItemSource NVARCHAR(50) NULL,
    ProductCode NVARCHAR(50) NULL,
    ProductName NVARCHAR(255) NULL,
    Description NVARCHAR(500) NULL,
    Quantity DECIMAL(18,2) NOT NULL,
    UnitPrice DECIMAL(18,2) NULL,
    UnitCost DECIMAL(18,2) NULL,
    LineTotal DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_SupplierInvoiceLines_Invoice FOREIGN KEY (InvoiceID) REFERENCES SupplierInvoices(InvoiceID) ON DELETE CASCADE
);
PRINT 'Created SupplierInvoiceLines table'

-- 6. Recreate indexes with QUOTED_IDENTIFIER ON
CREATE UNIQUE INDEX UQ_SupplierInvoices_Number ON SupplierInvoices(InvoiceNumber, SupplierID);
CREATE INDEX IX_SupplierInvoices_Supplier ON SupplierInvoices(SupplierID);
CREATE INDEX IX_SupplierInvoices_Branch ON SupplierInvoices(BranchID);
CREATE INDEX IX_SupplierInvoices_Status ON SupplierInvoices(Status);
CREATE INDEX IX_SupplierInvoices_Date ON SupplierInvoices(InvoiceDate);
PRINT 'Created indexes'

-- 7. Restore data
SET IDENTITY_INSERT SupplierInvoices ON;

INSERT INTO SupplierInvoices (
    InvoiceID, SupplierID, BranchID, PurchaseOrderID, InvoiceNumber, InvoiceDate, DueDate,
    SubTotal, VATAmount, TotalAmount, AmountPaid, AmountOutstanding, Status, CreatedBy, CreatedDate,
    GRVID, Reference, Notes, DiscountAmount, DiscountPercent
)
SELECT 
    InvoiceID, SupplierID, BranchID, PurchaseOrderID, InvoiceNumber, InvoiceDate, DueDate,
    SubTotal, VATAmount, TotalAmount, 
    ISNULL(AmountPaid, 0) AS AmountPaid,
    TotalAmount - ISNULL(AmountPaid, 0) AS AmountOutstanding,
    Status, CreatedBy, CreatedDate,
    GRVID, Reference, Notes, DiscountAmount, DiscountPercent
FROM SupplierInvoices_FINAL_BACKUP;

SET IDENTITY_INSERT SupplierInvoices OFF;
PRINT 'Restored SupplierInvoices data'

-- Check if SupplierInvoiceLines backup table exists and has data
IF OBJECT_ID('SupplierInvoiceLines_FINAL_BACKUP', 'U') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM SupplierInvoiceLines_FINAL_BACKUP)
    BEGIN
        SET IDENTITY_INSERT SupplierInvoiceLines ON;

        INSERT INTO SupplierInvoiceLines (InvoiceLineID, InvoiceID, LineNumber, ItemID, ItemSource, ProductCode, ProductName, Description, Quantity, UnitPrice, UnitCost, LineTotal)
        SELECT InvoiceLineID, InvoiceID, LineNumber, ItemID, ItemSource, ProductCode, ProductName, Description, Quantity, UnitPrice, UnitCost, LineTotal
        FROM SupplierInvoiceLines_FINAL_BACKUP;

        SET IDENTITY_INSERT SupplierInvoiceLines OFF;
        PRINT 'Restored SupplierInvoiceLines data'
    END
    ELSE
    BEGIN
        PRINT 'No SupplierInvoiceLines data to restore (backup was empty)'
    END
END
ELSE
BEGIN
    PRINT 'SupplierInvoiceLines backup table does not exist - no data to restore'
END

PRINT ''
PRINT 'FINAL FIX COMPLETED SUCCESSFULLY!'
PRINT 'SupplierInvoices table recreated with QUOTED_IDENTIFIER ON'
PRINT 'All data restored'
