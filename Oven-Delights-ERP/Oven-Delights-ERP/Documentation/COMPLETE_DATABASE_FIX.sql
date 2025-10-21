-- =============================================
-- COMPLETE DATABASE SCHEMA FIX
-- Fixes ALL missing columns across all tables
-- Date: 2025-10-03 23:25
-- =============================================

PRINT '========================================='
PRINT 'COMPLETE DATABASE SCHEMA FIX - STARTING'
PRINT '========================================='
PRINT ''

-- =============================================
-- FIX 1: InterBranchTransfers Table
-- =============================================
PRINT '=== FIX 1: InterBranchTransfers Table ==='

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'InterBranchTransfers' AND COLUMN_NAME = 'CreatedDate')
BEGIN
    ALTER TABLE InterBranchTransfers ADD CreatedDate DATETIME NOT NULL DEFAULT(GETDATE());
    PRINT 'Added CreatedDate'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'InterBranchTransfers' AND COLUMN_NAME = 'CreatedBy')
BEGIN
    ALTER TABLE InterBranchTransfers ADD CreatedBy INT NULL;
    PRINT 'Added CreatedBy'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'InterBranchTransfers' AND COLUMN_NAME = 'Reference')
BEGIN
    ALTER TABLE InterBranchTransfers ADD Reference NVARCHAR(200) NULL;
    PRINT 'Added Reference'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'InterBranchTransfers' AND COLUMN_NAME = 'UnitCost')
BEGIN
    ALTER TABLE InterBranchTransfers ADD UnitCost DECIMAL(18,4) DEFAULT 0;
    PRINT 'Added UnitCost'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'InterBranchTransfers' AND COLUMN_NAME = 'TotalValue')
BEGIN
    ALTER TABLE InterBranchTransfers ADD TotalValue DECIMAL(18,4) DEFAULT 0;
    PRINT 'Added TotalValue'
END

PRINT 'InterBranchTransfers fixed ✓'
PRINT ''
GO

-- =============================================
-- FIX 2: GoodsReceivedNotes (GRV) Table
-- =============================================
PRINT '=== FIX 2: GoodsReceivedNotes Table ==='

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GoodsReceivedNotes' AND COLUMN_NAME = 'BranchID')
BEGIN
    ALTER TABLE GoodsReceivedNotes ADD BranchID INT NULL;
    PRINT 'Added BranchID'
    
    -- Add FK if Branches table exists
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Branches')
    BEGIN
        ALTER TABLE GoodsReceivedNotes 
        ADD CONSTRAINT FK_GRV_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID);
        PRINT 'Added FK to Branches'
    END
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GoodsReceivedNotes' AND COLUMN_NAME = 'DeliveryNoteNumber')
BEGIN
    ALTER TABLE GoodsReceivedNotes ADD DeliveryNoteNumber NVARCHAR(50) NULL;
    PRINT 'Added DeliveryNoteNumber'
END

PRINT 'GoodsReceivedNotes fixed ✓'
PRINT ''
GO

-- =============================================
-- FIX 3: Suppliers Table
-- =============================================
PRINT '=== FIX 3: Suppliers Table ==='

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'Address')
BEGIN
    ALTER TABLE Suppliers ADD Address NVARCHAR(200) NULL;
    PRINT 'Added Address'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'City')
BEGIN
    ALTER TABLE Suppliers ADD City NVARCHAR(100) NULL;
    PRINT 'Added City'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'Province')
BEGIN
    ALTER TABLE Suppliers ADD Province NVARCHAR(100) NULL;
    PRINT 'Added Province'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'PostalCode')
BEGIN
    ALTER TABLE Suppliers ADD PostalCode NVARCHAR(20) NULL;
    PRINT 'Added PostalCode'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'Country')
BEGIN
    ALTER TABLE Suppliers ADD Country NVARCHAR(100) NULL;
    PRINT 'Added Country'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'BankName')
BEGIN
    ALTER TABLE Suppliers ADD BankName NVARCHAR(100) NULL;
    PRINT 'Added BankName'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'BranchCode')
BEGIN
    ALTER TABLE Suppliers ADD BranchCode NVARCHAR(20) NULL;
    PRINT 'Added BranchCode'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'AccountNumber')
BEGIN
    ALTER TABLE Suppliers ADD AccountNumber NVARCHAR(50) NULL;
    PRINT 'Added AccountNumber'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'VATNumber')
BEGIN
    ALTER TABLE Suppliers ADD VATNumber NVARCHAR(50) NULL;
    PRINT 'Added VATNumber'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'PaymentTerms')
BEGIN
    ALTER TABLE Suppliers ADD PaymentTerms NVARCHAR(50) NULL;
    PRINT 'Added PaymentTerms'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'CreditLimit')
BEGIN
    ALTER TABLE Suppliers ADD CreditLimit DECIMAL(18,2) NULL;
    PRINT 'Added CreditLimit'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'IsActive')
BEGIN
    ALTER TABLE Suppliers ADD IsActive BIT DEFAULT 1;
    PRINT 'Added IsActive'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'Notes')
BEGIN
    ALTER TABLE Suppliers ADD Notes NVARCHAR(500) NULL;
    PRINT 'Added Notes'
END

PRINT 'Suppliers fixed ✓'
PRINT ''
GO

-- =============================================
-- FIX 4: CreditNotes Table
-- =============================================
PRINT '=== FIX 4: CreditNotes Table ==='

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CreditNotes')
BEGIN
    PRINT 'Creating CreditNotes table...'
    
    CREATE TABLE CreditNotes (
        CreditNoteID INT IDENTITY(1,1) PRIMARY KEY,
        CreditNoteNumber NVARCHAR(50) NOT NULL UNIQUE,
        CreditDate DATE NOT NULL,
        SupplierID INT,
        BranchID INT,
        GRVID INT,
        CreditType NVARCHAR(50),
        CreditReason NVARCHAR(200),
        TotalAmount DECIMAL(18,2) NOT NULL,
        Status NVARCHAR(20) DEFAULT 'Pending',
        CreatedBy INT,
        CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),
        ApprovedBy INT,
        ApprovedDate DATETIME2,
        CONSTRAINT FK_CreditNotes_Supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
        CONSTRAINT FK_CreditNotes_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    );
    
    CREATE INDEX IX_CreditNotes_Supplier ON CreditNotes(SupplierID);
    CREATE INDEX IX_CreditNotes_Branch ON CreditNotes(BranchID);
    CREATE INDEX IX_CreditNotes_Status ON CreditNotes(Status);
    
    PRINT 'CreditNotes table created ✓'
END
ELSE
BEGIN
    PRINT 'CreditNotes table already exists'
    
    -- Add missing columns if table exists
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CreditNotes' AND COLUMN_NAME = 'BranchID')
    BEGIN
        ALTER TABLE CreditNotes ADD BranchID INT NULL;
        ALTER TABLE CreditNotes ADD CONSTRAINT FK_CreditNotes_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID);
        PRINT 'Added BranchID to CreditNotes'
    END
END
PRINT ''
GO

-- =============================================
-- FIX 5: PurchaseOrders Table
-- =============================================
PRINT '=== FIX 5: PurchaseOrders Table ==='

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PurchaseOrders' AND COLUMN_NAME = 'BranchID')
BEGIN
    ALTER TABLE PurchaseOrders ADD BranchID INT NULL;
    PRINT 'Added BranchID'
    
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Branches')
    BEGIN
        ALTER TABLE PurchaseOrders ADD CONSTRAINT FK_PO_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID);
        PRINT 'Added FK to Branches'
    END
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PurchaseOrders' AND COLUMN_NAME = 'OrderDate')
BEGIN
    ALTER TABLE PurchaseOrders ADD OrderDate DATETIME NOT NULL DEFAULT(GETDATE());
    PRINT 'Added OrderDate'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PurchaseOrders' AND COLUMN_NAME = 'RequiredDate')
BEGIN
    ALTER TABLE PurchaseOrders ADD RequiredDate DATETIME NULL;
    PRINT 'Added RequiredDate'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PurchaseOrders' AND COLUMN_NAME = 'Status')
BEGIN
    ALTER TABLE PurchaseOrders ADD Status NVARCHAR(20) DEFAULT 'Pending';
    PRINT 'Added Status'
END

PRINT 'PurchaseOrders fixed ✓'
PRINT ''
GO

-- =============================================
-- FIX 6: Products Table
-- =============================================
PRINT '=== FIX 6: Products Table ==='

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME = 'ItemType')
BEGIN
    ALTER TABLE Products ADD ItemType NVARCHAR(20) DEFAULT 'External';
    ALTER TABLE Products ADD CONSTRAINT CK_Products_ItemType CHECK (ItemType IN ('External', 'Manufactured', 'RawMaterial'));
    PRINT 'Added ItemType'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME = 'SKU')
BEGIN
    ALTER TABLE Products ADD SKU NVARCHAR(50) NULL;
    PRINT 'Added SKU'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME = 'IsActive')
BEGIN
    ALTER TABLE Products ADD IsActive BIT DEFAULT 1;
    PRINT 'Added IsActive'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME = 'ProductCode')
BEGIN
    ALTER TABLE Products ADD ProductCode NVARCHAR(50) NULL;
    PRINT 'Added ProductCode'
END

PRINT 'Products fixed ✓'
PRINT ''
GO

-- =============================================
-- FIX 7: Retail_Stock Table
-- =============================================
PRINT '=== FIX 7: Retail_Stock Table ==='

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Retail_Stock' AND COLUMN_NAME = 'UpdatedAt')
BEGIN
    ALTER TABLE Retail_Stock ADD UpdatedAt DATETIME2 DEFAULT SYSUTCDATETIME();
    PRINT 'Added UpdatedAt'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Retail_Stock' AND COLUMN_NAME = 'AverageCost')
BEGIN
    ALTER TABLE Retail_Stock ADD AverageCost DECIMAL(18,4) DEFAULT 0;
    PRINT 'Added AverageCost'
END

PRINT 'Retail_Stock fixed ✓'
PRINT ''
GO

-- =============================================
-- FIX 8: Verification Report
-- =============================================
PRINT '=== VERIFICATION REPORT ==='
PRINT ''

-- Show all table columns
PRINT 'InterBranchTransfers columns:'
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'InterBranchTransfers' ORDER BY ORDINAL_POSITION;
PRINT ''

PRINT 'GoodsReceivedNotes columns:'
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GoodsReceivedNotes' ORDER BY ORDINAL_POSITION;
PRINT ''

PRINT 'Suppliers columns:'
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' ORDER BY ORDINAL_POSITION;
PRINT ''

PRINT 'CreditNotes columns:'
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CreditNotes' ORDER BY ORDINAL_POSITION;
PRINT ''

PRINT 'PurchaseOrders columns:'
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PurchaseOrders' ORDER BY ORDINAL_POSITION;
PRINT ''

PRINT '========================================='
PRINT 'COMPLETE DATABASE FIX FINISHED!'
PRINT '========================================='
PRINT ''
PRINT 'All missing columns have been added.'
PRINT 'Please test all features again:'
PRINT '  1. Inter-Branch Transfer'
PRINT '  2. GRV Management'
PRINT '  3. Credit Notes'
PRINT '  4. Supplier Management'
PRINT '  5. Purchase Orders'
PRINT ''
GO
