-- =============================================
-- STOCKROOM MODULE - COMPLETE FIX
-- Fixes ALL missing columns and table issues
-- Date: 2025-10-03 23:16
-- =============================================

PRINT '========================================='
PRINT 'STOCKROOM COMPLETE FIX - STARTING'
PRINT '========================================='
PRINT ''

-- =============================================
-- FIX 1: Add Missing Columns to InterBranchTransfers
-- =============================================
PRINT '=== FIX 1: Checking InterBranchTransfers Table ==='

-- Add CreatedDate if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'InterBranchTransfers' AND COLUMN_NAME = 'CreatedDate')
BEGIN
    PRINT 'Adding CreatedDate column...'
    ALTER TABLE InterBranchTransfers ADD CreatedDate DATETIME NOT NULL DEFAULT(GETDATE());
    PRINT 'CreatedDate column added.'
END
ELSE
BEGIN
    PRINT 'CreatedDate column already exists.'
END

-- Add CreatedBy if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'InterBranchTransfers' AND COLUMN_NAME = 'CreatedBy')
BEGIN
    PRINT 'Adding CreatedBy column...'
    ALTER TABLE InterBranchTransfers ADD CreatedBy INT NULL;
    PRINT 'CreatedBy column added.'
END
ELSE
BEGIN
    PRINT 'CreatedBy column already exists.'
END

-- Add CompletedDate if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'InterBranchTransfers' AND COLUMN_NAME = 'CompletedDate')
BEGIN
    PRINT 'Adding CompletedDate column...'
    ALTER TABLE InterBranchTransfers ADD CompletedDate DATETIME NULL;
    PRINT 'CompletedDate column added.'
END
ELSE
BEGIN
    PRINT 'CompletedDate column already exists.'
END

-- Add CompletedBy if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'InterBranchTransfers' AND COLUMN_NAME = 'CompletedBy')
BEGIN
    PRINT 'Adding CompletedBy column...'
    ALTER TABLE InterBranchTransfers ADD CompletedBy INT NULL;
    PRINT 'CompletedBy column added.'
END
ELSE
BEGIN
    PRINT 'CompletedBy column already exists.'
END

-- Add Reference if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'InterBranchTransfers' AND COLUMN_NAME = 'Reference')
BEGIN
    PRINT 'Adding Reference column...'
    ALTER TABLE InterBranchTransfers ADD Reference NVARCHAR(200) NULL;
    PRINT 'Reference column added.'
END
ELSE
BEGIN
    PRINT 'Reference column already exists.'
END

-- Add UnitCost if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'InterBranchTransfers' AND COLUMN_NAME = 'UnitCost')
BEGIN
    PRINT 'Adding UnitCost column...'
    ALTER TABLE InterBranchTransfers ADD UnitCost DECIMAL(18,4) NOT NULL DEFAULT(0);
    PRINT 'UnitCost column added.'
END
ELSE
BEGIN
    PRINT 'UnitCost column already exists.'
END

-- Add TotalValue if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'InterBranchTransfers' AND COLUMN_NAME = 'TotalValue')
BEGIN
    PRINT 'Adding TotalValue column...'
    ALTER TABLE InterBranchTransfers ADD TotalValue DECIMAL(18,4) NOT NULL DEFAULT(0);
    PRINT 'TotalValue column added.'
END
ELSE
BEGIN
    PRINT 'TotalValue column already exists.'
END

PRINT 'InterBranchTransfers table structure verified.'
PRINT ''
GO

-- =============================================
-- FIX 2: Verify PurchaseOrders Table
-- =============================================
PRINT '=== FIX 2: Checking PurchaseOrders Table ==='

-- Add BranchID if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PurchaseOrders' AND COLUMN_NAME = 'BranchID')
BEGIN
    PRINT 'Adding BranchID column...'
    ALTER TABLE PurchaseOrders ADD BranchID INT NULL;
    PRINT 'BranchID column added.'
    
    -- Add FK constraint
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_PurchaseOrders_Branch')
    BEGIN
        ALTER TABLE PurchaseOrders 
        ADD CONSTRAINT FK_PurchaseOrders_Branch 
        FOREIGN KEY (BranchID) REFERENCES Branches(BranchID);
        PRINT 'FK constraint added.'
    END
END
ELSE
BEGIN
    PRINT 'BranchID column already exists.'
END

-- Add OrderDate if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PurchaseOrders' AND COLUMN_NAME = 'OrderDate')
BEGIN
    PRINT 'Adding OrderDate column...'
    ALTER TABLE PurchaseOrders ADD OrderDate DATETIME NOT NULL DEFAULT(GETDATE());
    PRINT 'OrderDate column added.'
END
ELSE
BEGIN
    PRINT 'OrderDate column already exists.'
END

PRINT 'PurchaseOrders table structure verified.'
PRINT ''
GO

-- =============================================
-- FIX 3: Verify Retail_Stock Table
-- =============================================
PRINT '=== FIX 3: Checking Retail_Stock Table ==='

-- Add UpdatedAt if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Retail_Stock' AND COLUMN_NAME = 'UpdatedAt')
BEGIN
    PRINT 'Adding UpdatedAt column...'
    ALTER TABLE Retail_Stock ADD UpdatedAt DATETIME2 DEFAULT SYSUTCDATETIME();
    PRINT 'UpdatedAt column added.'
END
ELSE
BEGIN
    PRINT 'UpdatedAt column already exists.'
END

-- Add AverageCost if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Retail_Stock' AND COLUMN_NAME = 'AverageCost')
BEGIN
    PRINT 'Adding AverageCost column...'
    ALTER TABLE Retail_Stock ADD AverageCost DECIMAL(18,4) DEFAULT 0;
    PRINT 'AverageCost column added.'
END
ELSE
BEGIN
    PRINT 'AverageCost column already exists.'
END

PRINT 'Retail_Stock table structure verified.'
PRINT ''
GO

-- =============================================
-- FIX 4: Verify Products Table
-- =============================================
PRINT '=== FIX 4: Checking Products Table ==='

-- Add ItemType if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME = 'ItemType')
BEGIN
    PRINT 'Adding ItemType column...'
    ALTER TABLE Products ADD ItemType NVARCHAR(20) DEFAULT 'External';
    PRINT 'ItemType column added.'
    
    -- Add constraint
    ALTER TABLE Products ADD CONSTRAINT CK_Products_ItemType 
    CHECK (ItemType IN ('External', 'Manufactured', 'RawMaterial'));
    PRINT 'ItemType constraint added.'
END
ELSE
BEGIN
    PRINT 'ItemType column already exists.'
END

-- Add SKU if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME = 'SKU')
BEGIN
    PRINT 'Adding SKU column...'
    ALTER TABLE Products ADD SKU NVARCHAR(50) NULL;
    PRINT 'SKU column added.'
END
ELSE
BEGIN
    PRINT 'SKU column already exists.'
END

-- Add IsActive if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME = 'IsActive')
BEGIN
    PRINT 'Adding IsActive column...'
    ALTER TABLE Products ADD IsActive BIT DEFAULT 1;
    PRINT 'IsActive column added.'
END
ELSE
BEGIN
    PRINT 'IsActive column already exists.'
END

PRINT 'Products table structure verified.'
PRINT ''
GO

-- =============================================
-- FIX 5: Show Current Table Structures
-- =============================================
PRINT '=== FIX 5: Current Table Structures ==='
PRINT ''

PRINT 'InterBranchTransfers Columns:'
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'InterBranchTransfers'
ORDER BY ORDINAL_POSITION;
PRINT ''

PRINT 'PurchaseOrders Columns:'
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'PurchaseOrders'
ORDER BY ORDINAL_POSITION;
PRINT ''

PRINT 'Retail_Stock Columns:'
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Retail_Stock'
ORDER BY ORDINAL_POSITION;
PRINT ''

PRINT 'Products Columns:'
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Products'
ORDER BY ORDINAL_POSITION;
PRINT ''

-- =============================================
-- FIX 6: Test Data Verification
-- =============================================
PRINT '=== FIX 6: Data Verification ==='
PRINT ''

-- Check branches
DECLARE @BranchCount INT
SELECT @BranchCount = COUNT(*) FROM Branches
PRINT 'Branches: ' + CAST(@BranchCount AS VARCHAR)

-- Check products
DECLARE @ProductCount INT
SELECT @ProductCount = COUNT(*) FROM Products WHERE ISNULL(IsActive, 1) = 1
PRINT 'Active Products: ' + CAST(@ProductCount AS VARCHAR)

-- Check variants
DECLARE @VariantCount INT
SELECT @VariantCount = COUNT(*) FROM Retail_Variant WHERE IsActive = 1
PRINT 'Active Variants: ' + CAST(@VariantCount AS VARCHAR)

-- Check stock
DECLARE @StockCount INT
SELECT @StockCount = COUNT(*) FROM Retail_Stock
PRINT 'Stock Records: ' + CAST(@StockCount AS VARCHAR)

-- Check transfers
DECLARE @TransferCount INT
SELECT @TransferCount = COUNT(*) FROM InterBranchTransfers
PRINT 'Inter-Branch Transfers: ' + CAST(@TransferCount AS VARCHAR)

PRINT ''
PRINT '========================================='
PRINT 'COMPLETE FIX FINISHED!'
PRINT '========================================='
PRINT ''
PRINT 'Next Steps:'
PRINT '1. Test Inter-Branch Transfer again'
PRINT '2. Test Purchase Order creation'
PRINT '3. Test Invoice Capture'
PRINT '4. Report any new errors'
PRINT ''
GO
