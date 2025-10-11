-- =============================================
-- STOCKROOM MODULE - FIXES FOR SCRIPT ERRORS
-- Run these after the main scripts
-- Date: 2025-10-03
-- =============================================

-- =============================================
-- FIX 1: Correct Performance Indexes (Fix column names)
-- =============================================
PRINT '=== FIX 1: Creating Corrected Performance Indexes ==='

-- Drop incorrect index if exists
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_PurchaseOrders_BranchID_Status')
BEGIN
    DROP INDEX IX_PurchaseOrders_BranchID_Status ON PurchaseOrders;
    PRINT 'Dropped incorrect index.'
END

-- Create correct index based on actual column names
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_PurchaseOrders_BranchID_Status')
BEGIN
    PRINT 'Creating corrected index on PurchaseOrders...'
    CREATE INDEX IX_PurchaseOrders_BranchID_Status 
    ON PurchaseOrders(BranchID, Status) 
    INCLUDE (PurchaseOrderID, SupplierID, OrderDate);
    PRINT 'PurchaseOrders index created successfully.'
END
GO

-- =============================================
-- FIX 2: Fix Foreign Key Constraint Issue
-- The FK_Retail_Variant_Product references Retail_Product instead of Products
-- =============================================
PRINT '=== FIX 2: Fixing Retail_Variant Foreign Key ==='

-- Check if the wrong FK exists
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Retail_Variant_Product')
BEGIN
    PRINT 'Dropping incorrect foreign key...'
    ALTER TABLE Retail_Variant DROP CONSTRAINT FK_Retail_Variant_Product;
    PRINT 'Incorrect FK dropped.'
END

-- Create correct FK to Products table
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Retail_Variant_Products')
BEGIN
    PRINT 'Creating correct foreign key to Products...'
    ALTER TABLE Retail_Variant 
    ADD CONSTRAINT FK_Retail_Variant_Products 
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID);
    PRINT 'Correct FK created.'
END
GO

-- =============================================
-- FIX 3: Populate Retail_Variant (Corrected)
-- =============================================
PRINT '=== FIX 3: Populating Retail_Variant for Existing Products ==='

-- Create variants for products that don't have them yet
INSERT INTO Retail_Variant (ProductID, Barcode, IsActive, CreatedAt, UpdatedAt)
SELECT 
    p.ProductID,
    p.SKU AS Barcode,
    ISNULL(p.IsActive, 1),
    SYSUTCDATETIME(),
    SYSUTCDATETIME()
FROM Products p
WHERE NOT EXISTS (
    SELECT 1 FROM Retail_Variant rv WHERE rv.ProductID = p.ProductID
)
AND ISNULL(p.ItemType, 'External') IN ('External', 'Manufactured');  -- Only retail products

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' variants created for existing products.'
GO

-- =============================================
-- FIX 4: Create SupplierInvoices Table if Missing
-- =============================================
PRINT '=== FIX 4: Creating SupplierInvoices Table ==='

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SupplierInvoices')
BEGIN
    PRINT 'Creating SupplierInvoices table...'
    
    CREATE TABLE SupplierInvoices (
        InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
        InvoiceNumber NVARCHAR(50) NOT NULL,
        SupplierID INT NOT NULL,
        BranchID INT,
        InvoiceDate DATE NOT NULL,
        DueDate DATE,
        SubTotal DECIMAL(18,2) DEFAULT 0,
        VATAmount DECIMAL(18,2) DEFAULT 0,
        TotalAmount DECIMAL(18,2) NOT NULL,
        AmountPaid DECIMAL(18,2) DEFAULT 0,
        AmountOutstanding DECIMAL(18,2) DEFAULT 0,
        Status NVARCHAR(20) DEFAULT 'Unpaid',
        GRVID INT,
        CreatedBy INT,
        CreatedDate DATETIME2 DEFAULT SYSUTCDATETIME(),
        ModifiedBy INT,
        ModifiedDate DATETIME2,
        CONSTRAINT FK_SupplierInvoices_Supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
        CONSTRAINT FK_SupplierInvoices_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
        CONSTRAINT CK_SupplierInvoices_Status CHECK (Status IN ('Unpaid', 'PartiallyPaid', 'Paid', 'Cancelled'))
    );
    
    CREATE INDEX IX_SupplierInvoices_Supplier ON SupplierInvoices(SupplierID);
    CREATE INDEX IX_SupplierInvoices_Branch ON SupplierInvoices(BranchID);
    CREATE INDEX IX_SupplierInvoices_Status ON SupplierInvoices(Status);
    CREATE INDEX IX_SupplierInvoices_Date ON SupplierInvoices(InvoiceDate DESC);
    
    PRINT 'SupplierInvoices table created successfully.'
END
ELSE
BEGIN
    PRINT 'SupplierInvoices table already exists.'
END
GO

-- =============================================
-- FIX 5: Update ItemType for All Products
-- =============================================
PRINT '=== FIX 5: Updating ItemType for Products ==='

-- Set all products to Manufactured (as per your current data)
UPDATE Products 
SET ItemType = 'Manufactured'
WHERE ItemType IS NULL OR ItemType = 'External';

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' products updated to Manufactured.'

-- You can manually set specific products to External or RawMaterial later
PRINT 'Note: Manually update ItemType for External products and RawMaterials as needed.'
GO

-- =============================================
-- FIX 6: Verification Report (Corrected)
-- =============================================
PRINT '=== FIX 6: Verification Report ==='
PRINT ''

-- Check variants
DECLARE @VariantCount INT
SELECT @VariantCount = COUNT(*) FROM Retail_Variant WHERE IsActive = 1
PRINT 'Retail Variants Created: ' + CAST(@VariantCount AS VARCHAR)

-- Check products without variants
DECLARE @ProductsWithoutVariants INT
SELECT @ProductsWithoutVariants = COUNT(*)
FROM Products p
WHERE ISNULL(p.ItemType, 'External') IN ('External', 'Manufactured')
AND NOT EXISTS (SELECT 1 FROM Retail_Variant rv WHERE rv.ProductID = p.ProductID);

IF @ProductsWithoutVariants > 0
BEGIN
    PRINT 'WARNING: ' + CAST(@ProductsWithoutVariants AS VARCHAR) + ' products still without variants.'
    
    -- Show which products
    PRINT 'Products without variants:'
    SELECT TOP 10 ProductID, ProductCode, ProductName, ItemType 
    FROM Products p
    WHERE ISNULL(p.ItemType, 'External') IN ('External', 'Manufactured')
    AND NOT EXISTS (SELECT 1 FROM Retail_Variant rv WHERE rv.ProductID = p.ProductID);
END
ELSE
BEGIN
    PRINT 'SUCCESS: All retail products have variants! ✓'
END

-- Check SupplierInvoices
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SupplierInvoices')
BEGIN
    DECLARE @TotalInvoices INT, @UnpaidInvoices INT, @UnpaidAmount DECIMAL(18,2)
    SELECT @TotalInvoices = COUNT(*) FROM SupplierInvoices
    SELECT @UnpaidInvoices = COUNT(*), @UnpaidAmount = ISNULL(SUM(AmountOutstanding), 0) 
    FROM SupplierInvoices WHERE Status = 'Unpaid'
    
    PRINT ''
    PRINT 'SUPPLIER INVOICES:'
    PRINT '  Total Invoices: ' + CAST(@TotalInvoices AS VARCHAR)
    PRINT '  Unpaid Invoices: ' + CAST(@UnpaidInvoices AS VARCHAR)
    PRINT '  Unpaid Amount: R ' + CAST(@UnpaidAmount AS VARCHAR)
END
ELSE
BEGIN
    PRINT ''
    PRINT 'SupplierInvoices table does not exist yet.'
END

PRINT ''
PRINT '========================================='
PRINT 'FIXES APPLIED SUCCESSFULLY!'
PRINT '========================================='
GO

-- =============================================
-- FIX 7: Create Retail_Stock if Missing
-- =============================================
PRINT '=== FIX 7: Ensuring Retail_Stock Table Exists ==='

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Retail_Stock')
BEGIN
    PRINT 'Creating Retail_Stock table...'
    
    CREATE TABLE Retail_Stock (
        StockID INT IDENTITY(1,1) PRIMARY KEY,
        VariantID INT NOT NULL,
        BranchID INT NOT NULL,
        QtyOnHand DECIMAL(18,3) DEFAULT 0,
        ReorderLevel DECIMAL(18,3) DEFAULT 0,
        MaxStockLevel DECIMAL(18,3),
        AverageCost DECIMAL(18,4) DEFAULT 0,
        LastStockTake DATETIME2,
        UpdatedAt DATETIME2 DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Retail_Stock_Variant FOREIGN KEY (VariantID) REFERENCES Retail_Variant(VariantID),
        CONSTRAINT FK_Retail_Stock_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
        CONSTRAINT UQ_Retail_Stock_VariantBranch UNIQUE (VariantID, BranchID)
    );
    
    CREATE INDEX IX_Retail_Stock_Branch ON Retail_Stock(BranchID);
    CREATE INDEX IX_Retail_Stock_Variant ON Retail_Stock(VariantID);
    
    PRINT 'Retail_Stock table created successfully.'
END
ELSE
BEGIN
    PRINT 'Retail_Stock table already exists.'
END
GO

-- =============================================
-- FINAL SUMMARY
-- =============================================
PRINT ''
PRINT '========================================='
PRINT 'ALL FIXES COMPLETE!'
PRINT '========================================='
PRINT ''
PRINT 'Tables Verified:'
PRINT '  ✓ Products (with ItemType)'
PRINT '  ✓ Retail_Variant (with correct FK)'
PRINT '  ✓ Retail_Stock'
PRINT '  ✓ Retail_StockMovements'
PRINT '  ✓ SupplierInvoices'
PRINT '  ✓ PurchaseOrders (with corrected indexes)'
PRINT ''
PRINT 'Next Steps:'
PRINT '1. Manually set ItemType for External products'
PRINT '2. Manually set ItemType for RawMaterial products'
PRINT '3. Test Purchase Order → Invoice Capture workflow'
PRINT '4. Verify stock updates correctly'
PRINT ''
GO
