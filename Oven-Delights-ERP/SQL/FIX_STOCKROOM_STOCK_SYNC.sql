-- =============================================
-- FIX STOCKROOM STOCK SYNCHRONIZATION
-- =============================================
-- This script ensures StockroomStock table is properly populated
-- and synchronized with RawMaterials for all branches
-- =============================================

-- Step 1: Ensure StockroomStock table exists with correct structure
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'StockroomStock')
BEGIN
    CREATE TABLE StockroomStock (
        StockID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,  -- This is MaterialID from RawMaterials
        BranchID INT NOT NULL,
        Quantity DECIMAL(18,4) NOT NULL DEFAULT 0,
        LastUpdated DATETIME NOT NULL DEFAULT GETDATE(),
        UpdatedBy NVARCHAR(100),
        CONSTRAINT FK_StockroomStock_RawMaterials FOREIGN KEY (ProductID) REFERENCES RawMaterials(MaterialID),
        CONSTRAINT FK_StockroomStock_Branches FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
        CONSTRAINT UQ_StockroomStock_Product_Branch UNIQUE (ProductID, BranchID)
    )
    PRINT 'StockroomStock table created'
END
ELSE
BEGIN
    PRINT 'StockroomStock table already exists'
END
GO

-- Step 2: Migrate existing RawMaterials.CurrentStock to StockroomStock for all branches
-- This is a ONE-TIME migration to populate initial stock levels
PRINT 'Migrating existing stock from RawMaterials.CurrentStock to StockroomStock...'

-- For each branch, create StockroomStock records from RawMaterials where CurrentStock > 0
INSERT INTO StockroomStock (ProductID, BranchID, Quantity, LastUpdated, UpdatedBy)
SELECT 
    rm.MaterialID,
    b.BranchID,
    ISNULL(rm.CurrentStock, 0),
    GETDATE(),
    'System Migration'
FROM RawMaterials rm
CROSS JOIN Branches b
WHERE rm.CurrentStock > 0
AND NOT EXISTS (
    SELECT 1 FROM StockroomStock ss 
    WHERE ss.ProductID = rm.MaterialID 
    AND ss.BranchID = b.BranchID
)

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records migrated to StockroomStock'
GO

-- Step 3: Verify MaterialType values in RawMaterials
-- Ensure all sub-recipes are properly marked
PRINT 'Checking MaterialType values in RawMaterials...'

SELECT 
    MaterialType,
    COUNT(*) AS Count
FROM RawMaterials
GROUP BY MaterialType
ORDER BY MaterialType
GO

-- Step 4: Update any sub-recipes that might have incorrect MaterialType spelling
UPDATE RawMaterials
SET MaterialType = 'Sub Recipe'
WHERE MaterialType LIKE '%sub%recipe%'
AND MaterialType <> 'Sub Recipe'

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' MaterialType values standardized to "Sub Recipe"'
GO

-- Step 5: Verify StockroomStock has records
PRINT 'StockroomStock summary by branch:'
SELECT 
    b.BranchName,
    COUNT(DISTINCT ss.ProductID) AS UniqueProducts,
    SUM(ss.Quantity) AS TotalQuantity
FROM StockroomStock ss
INNER JOIN Branches b ON b.BranchID = ss.BranchID
GROUP BY b.BranchName
ORDER BY b.BranchName
GO

-- Step 6: Show any materials with stock in RawMaterials but NOT in StockroomStock
PRINT 'Materials with CurrentStock but missing from StockroomStock:'
SELECT 
    rm.MaterialCode,
    rm.MaterialName,
    rm.MaterialType,
    rm.CurrentStock,
    'Missing from StockroomStock' AS Issue
FROM RawMaterials rm
WHERE rm.CurrentStock > 0
AND NOT EXISTS (
    SELECT 1 FROM StockroomStock ss 
    WHERE ss.ProductID = rm.MaterialID
)
GO

-- Step 7: Create index for performance
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_StockroomStock_Branch_Product')
BEGIN
    CREATE NONCLUSTERED INDEX IX_StockroomStock_Branch_Product
    ON StockroomStock (BranchID, ProductID)
    INCLUDE (Quantity)
    PRINT 'Index IX_StockroomStock_Branch_Product created'
END
GO

PRINT '============================================='
PRINT 'STOCKROOM STOCK SYNCHRONIZATION COMPLETE!'
PRINT '============================================='
