-- =============================================
-- STOCKROOM MODULE - REQUIRED DATABASE SCRIPTS
-- Run these scripts in order
-- Date: 2025-10-03
-- =============================================

-- =============================================
-- SCRIPT 1: Ensure Retail_Variant Table Exists
-- =============================================
PRINT '=== SCRIPT 1: Creating Retail_Variant Table ==='

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Retail_Variant')
BEGIN
    PRINT 'Creating Retail_Variant table...'
    
    CREATE TABLE Retail_Variant (
        VariantID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        Barcode NVARCHAR(50),
        AttributesJson NVARCHAR(MAX),
        IsActive BIT DEFAULT 1,
        CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME(),
        UpdatedAt DATETIME2 DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Retail_Variant_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
    );
    
    CREATE UNIQUE INDEX IX_Retail_Variant_ProductID ON Retail_Variant(ProductID) WHERE IsActive = 1;
    CREATE INDEX IX_Retail_Variant_Barcode ON Retail_Variant(Barcode) WHERE Barcode IS NOT NULL;
    
    PRINT 'Retail_Variant table created successfully.'
END
ELSE
BEGIN
    PRINT 'Retail_Variant table already exists.'
END
GO

-- =============================================
-- SCRIPT 2: Ensure Retail_StockMovements Table Exists
-- =============================================
PRINT '=== SCRIPT 2: Creating Retail_StockMovements Table ==='

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Retail_StockMovements')
BEGIN
    PRINT 'Creating Retail_StockMovements table...'
    
    CREATE TABLE Retail_StockMovements (
        MovementID INT IDENTITY(1,1) PRIMARY KEY,
        VariantID INT NOT NULL,
        BranchID INT,
        QtyDelta DECIMAL(18,3) NOT NULL,
        Reason NVARCHAR(100),
        Ref1 NVARCHAR(100),
        Ref2 NVARCHAR(100),
        CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME(),
        CreatedBy INT,
        CONSTRAINT FK_StockMovements_Variant FOREIGN KEY (VariantID) REFERENCES Retail_Variant(VariantID),
        CONSTRAINT FK_StockMovements_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    );
    
    CREATE INDEX IX_StockMovements_VariantBranch ON Retail_StockMovements(VariantID, BranchID);
    CREATE INDEX IX_StockMovements_CreatedAt ON Retail_StockMovements(CreatedAt DESC);
    CREATE INDEX IX_StockMovements_Reason ON Retail_StockMovements(Reason);
    
    PRINT 'Retail_StockMovements table created successfully.'
END
ELSE
BEGIN
    PRINT 'Retail_StockMovements table already exists.'
END
GO

-- =============================================
-- SCRIPT 3: Ensure Products.ItemType Column Exists
-- =============================================
PRINT '=== SCRIPT 3: Adding ItemType Column to Products ==='

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME = 'ItemType')
BEGIN
    PRINT 'Adding ItemType column to Products table...'
    
    ALTER TABLE Products ADD ItemType NVARCHAR(20) DEFAULT 'External';
    
    -- Add constraint
    ALTER TABLE Products ADD CONSTRAINT CK_Products_ItemType 
    CHECK (ItemType IN ('External', 'Manufactured', 'RawMaterial'));
    
    PRINT 'ItemType column added successfully.'
    
    -- Update existing products based on their usage
    PRINT 'Updating existing products ItemType...'
    
    -- Set RawMaterial for products in RawMaterials table
    UPDATE p
    SET p.ItemType = 'RawMaterial'
    FROM Products p
    INNER JOIN RawMaterials rm ON p.ProductID = rm.MaterialID;
    
    PRINT 'ItemType updated for existing products.'
END
ELSE
BEGIN
    PRINT 'ItemType column already exists.'
END
GO

-- =============================================
-- SCRIPT 4: Create Performance Indexes
-- =============================================
PRINT '=== SCRIPT 4: Creating Performance Indexes ==='

-- PurchaseOrders indexes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_PurchaseOrders_BranchID_Status')
BEGIN
    PRINT 'Creating index on PurchaseOrders...'
    CREATE INDEX IX_PurchaseOrders_BranchID_Status ON PurchaseOrders(BranchID, Status) INCLUDE (POID, SupplierID, OrderDate);
    PRINT 'PurchaseOrders index created.'
END

-- Retail_Stock indexes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Retail_Stock_BranchVariant')
BEGIN
    PRINT 'Creating index on Retail_Stock...'
    CREATE INDEX IX_Retail_Stock_BranchVariant ON Retail_Stock(BranchID, VariantID) INCLUDE (QtyOnHand, UpdatedAt);
    PRINT 'Retail_Stock index created.'
END

-- SupplierInvoices indexes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_SupplierInvoices_BranchStatus')
BEGIN
    PRINT 'Creating index on SupplierInvoices...'
    CREATE INDEX IX_SupplierInvoices_BranchStatus ON SupplierInvoices(BranchID, Status) INCLUDE (SupplierID, TotalAmount, InvoiceDate);
    PRINT 'SupplierInvoices index created.'
END

-- InterBranchTransfers indexes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_InterBranchTransfers_Branches')
BEGIN
    PRINT 'Creating index on InterBranchTransfers...'
    CREATE INDEX IX_InterBranchTransfers_Branches ON InterBranchTransfers(FromBranchID, ToBranchID) INCLUDE (TransferDate, Status);
    PRINT 'InterBranchTransfers index created.'
END

PRINT 'All performance indexes created successfully.'
GO

-- =============================================
-- SCRIPT 5: Populate Retail_Variant for Existing Products
-- =============================================
PRINT '=== SCRIPT 5: Populating Retail_Variant for Existing Products ==='

-- Create variants for products that don't have them yet
INSERT INTO Retail_Variant (ProductID, Barcode, IsActive, CreatedAt, UpdatedAt)
SELECT 
    p.ProductID,
    p.SKU AS Barcode,
    p.IsActive,
    SYSUTCDATETIME(),
    SYSUTCDATETIME()
FROM Products p
WHERE NOT EXISTS (
    SELECT 1 FROM Retail_Variant rv WHERE rv.ProductID = p.ProductID
)
AND p.ItemType IN ('External', 'Manufactured');  -- Only retail products

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' variants created for existing products.'
GO

-- =============================================
-- SCRIPT 6: Verify Data Integrity
-- =============================================
PRINT '=== SCRIPT 6: Verifying Data Integrity ==='

-- Check for products without variants
DECLARE @ProductsWithoutVariants INT
SELECT @ProductsWithoutVariants = COUNT(*)
FROM Products p
WHERE p.ItemType IN ('External', 'Manufactured')
AND NOT EXISTS (SELECT 1 FROM Retail_Variant rv WHERE rv.ProductID = p.ProductID);

IF @ProductsWithoutVariants > 0
BEGIN
    PRINT 'WARNING: ' + CAST(@ProductsWithoutVariants AS VARCHAR) + ' products without variants found.'
END
ELSE
BEGIN
    PRINT 'All retail products have variants. ✓'
END

-- Check for Retail_Stock without variants
DECLARE @StockWithoutVariants INT
SELECT @StockWithoutVariants = COUNT(*)
FROM Retail_Stock rs
WHERE NOT EXISTS (SELECT 1 FROM Retail_Variant rv WHERE rv.VariantID = rs.VariantID);

IF @StockWithoutVariants > 0
BEGIN
    PRINT 'WARNING: ' + CAST(@StockWithoutVariants AS VARCHAR) + ' stock records with invalid VariantID found.'
END
ELSE
BEGIN
    PRINT 'All stock records have valid variants. ✓'
END

-- Check for PurchaseOrders without BranchID
DECLARE @POsWithoutBranch INT
SELECT @POsWithoutBranch = COUNT(*)
FROM PurchaseOrders
WHERE BranchID IS NULL;

IF @POsWithoutBranch > 0
BEGIN
    PRINT 'WARNING: ' + CAST(@POsWithoutBranch AS VARCHAR) + ' purchase orders without BranchID found.'
    PRINT 'These should be assigned to a branch manually.'
END
ELSE
BEGIN
    PRINT 'All purchase orders have BranchID. ✓'
END

GO

-- =============================================
-- SCRIPT 7: Summary Report
-- =============================================
PRINT '=== SCRIPT 7: Summary Report ==='
PRINT ''
PRINT '========================================='
PRINT 'STOCKROOM DATABASE SCRIPTS - SUMMARY'
PRINT '========================================='
PRINT ''

-- Products summary
DECLARE @TotalProducts INT, @ExternalProducts INT, @ManufacturedProducts INT, @RawMaterials INT
SELECT @TotalProducts = COUNT(*) FROM Products WHERE IsActive = 1
SELECT @ExternalProducts = COUNT(*) FROM Products WHERE ItemType = 'External' AND IsActive = 1
SELECT @ManufacturedProducts = COUNT(*) FROM Products WHERE ItemType = 'Manufactured' AND IsActive = 1
SELECT @RawMaterials = COUNT(*) FROM Products WHERE ItemType = 'RawMaterial' AND IsActive = 1

PRINT 'PRODUCTS:'
PRINT '  Total Active Products: ' + CAST(@TotalProducts AS VARCHAR)
PRINT '  External Products: ' + CAST(@ExternalProducts AS VARCHAR)
PRINT '  Manufactured Products: ' + CAST(@ManufacturedProducts AS VARCHAR)
PRINT '  Raw Materials: ' + CAST(@RawMaterials AS VARCHAR)
PRINT ''

-- Variants summary
DECLARE @TotalVariants INT
SELECT @TotalVariants = COUNT(*) FROM Retail_Variant WHERE IsActive = 1
PRINT 'RETAIL VARIANTS:'
PRINT '  Total Active Variants: ' + CAST(@TotalVariants AS VARCHAR)
PRINT ''

-- Stock summary by branch
PRINT 'STOCK BY BRANCH:'
SELECT 
    b.BranchName,
    COUNT(DISTINCT rs.VariantID) AS UniqueProducts,
    SUM(rs.QtyOnHand) AS TotalQuantity
FROM Retail_Stock rs
INNER JOIN Branches b ON rs.BranchID = b.BranchID
GROUP BY b.BranchName
ORDER BY b.BranchName;
PRINT ''

-- Purchase Orders summary
DECLARE @TotalPOs INT, @PendingPOs INT
SELECT @TotalPOs = COUNT(*) FROM PurchaseOrders
SELECT @PendingPOs = COUNT(*) FROM PurchaseOrders WHERE Status = 'Pending'

PRINT 'PURCHASE ORDERS:'
PRINT '  Total POs: ' + CAST(@TotalPOs AS VARCHAR)
PRINT '  Pending POs: ' + CAST(@PendingPOs AS VARCHAR)
PRINT ''

-- Supplier Invoices summary
DECLARE @TotalInvoices INT, @UnpaidInvoices INT, @UnpaidAmount DECIMAL(18,2)
SELECT @TotalInvoices = COUNT(*) FROM SupplierInvoices
SELECT @UnpaidInvoices = COUNT(*), @UnpaidAmount = ISNULL(SUM(AmountOutstanding), 0) 
FROM SupplierInvoices WHERE Status = 'Unpaid'

PRINT 'SUPPLIER INVOICES:'
PRINT '  Total Invoices: ' + CAST(@TotalInvoices AS VARCHAR)
PRINT '  Unpaid Invoices: ' + CAST(@UnpaidInvoices AS VARCHAR)
PRINT '  Unpaid Amount: R ' + CAST(@UnpaidAmount AS VARCHAR)
PRINT ''

-- Inter-Branch Transfers summary
DECLARE @TotalTransfers INT
SELECT @TotalTransfers = COUNT(*) FROM InterBranchTransfers

PRINT 'INTER-BRANCH TRANSFERS:'
PRINT '  Total Transfers: ' + CAST(@TotalTransfers AS VARCHAR)
PRINT ''

PRINT '========================================='
PRINT 'DATABASE SETUP COMPLETE!'
PRINT '========================================='
PRINT ''
PRINT 'Next Steps:'
PRINT '1. Apply code fixes from STOCKROOM_AUDIT_REPORT.md'
PRINT '2. Test Purchase Order → Invoice Capture workflow'
PRINT '3. Test Inter-Branch Transfer workflow'
PRINT '4. Verify stock levels are correct per branch'
PRINT ''
GO
