-- Consolidate duplicate products (same Name + BranchID, different ProductIDs)
-- Step 1: Identify duplicates and keep the OLDEST ProductID

BEGIN TRANSACTION

-- Create temp table to store consolidation mapping
CREATE TABLE #DuplicateMapping (
    KeepProductID INT,
    DeleteProductID INT,
    ProductName NVARCHAR(255),
    BranchID INT,
    MergedStock DECIMAL(18,2)
)

-- Find duplicates and decide which to keep (oldest ProductID = lowest ID)
INSERT INTO #DuplicateMapping (KeepProductID, DeleteProductID, ProductName, BranchID, MergedStock)
SELECT 
    MIN(p1.ProductID) AS KeepProductID,
    p2.ProductID AS DeleteProductID,
    p1.Name AS ProductName,
    p1.BranchID,
    SUM(ISNULL(p2.CurrentStock, 0)) AS MergedStock
FROM Demo_Retail_Product p1
INNER JOIN Demo_Retail_Product p2 
    ON p1.Name = p2.Name 
    AND p1.BranchID = p2.BranchID 
    AND p1.ProductID < p2.ProductID  -- Keep the lower (older) ProductID
WHERE p1.BranchID IS NOT NULL
GROUP BY p1.Name, p1.BranchID, p2.ProductID

-- Show what will be consolidated
SELECT * FROM #DuplicateMapping ORDER BY ProductName, BranchID

-- Step 2: Merge stock into the ProductID we're keeping
UPDATE p
SET CurrentStock = ISNULL(p.CurrentStock, 0) + dm.MergedStock
FROM Demo_Retail_Product p
INNER JOIN #DuplicateMapping dm ON p.ProductID = dm.KeepProductID

-- Step 3: Update all references to point to the ProductID we're keeping

-- Update PurchaseOrderLines
UPDATE pol
SET ProductID = dm.KeepProductID
FROM PurchaseOrderLines pol
INNER JOIN #DuplicateMapping dm ON pol.ProductID = dm.DeleteProductID

-- Update BOM_Lines (if ProductID exists there)
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BOM_Lines' AND COLUMN_NAME = 'ProductID')
BEGIN
    UPDATE bl
    SET ProductID = dm.KeepProductID
    FROM BOM_Lines bl
    INNER JOIN #DuplicateMapping dm ON bl.ProductID = dm.DeleteProductID
END

-- Update ReOrderBookLines
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReOrderBookLines' AND COLUMN_NAME = 'ProductID')
BEGIN
    UPDATE rol
    SET ProductID = dm.KeepProductID
    FROM ReOrderBookLines rol
    INNER JOIN #DuplicateMapping dm ON rol.ProductID = dm.DeleteProductID
END

-- Update Demo_Retail_Variant (if exists)
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Demo_Retail_Variant')
BEGIN
    UPDATE rv
    SET ProductID = dm.KeepProductID
    FROM Demo_Retail_Variant rv
    INNER JOIN #DuplicateMapping dm ON rv.ProductID = dm.DeleteProductID
END

-- Update Demo_Retail_Price - merge prices, keep the one with data or most recent
UPDATE p1
SET CostPrice = ISNULL(p1.CostPrice, p2.CostPrice),
    SellingPrice = ISNULL(p1.SellingPrice, p2.SellingPrice),
    SellingPriceExVAT = ISNULL(p1.SellingPriceExVAT, p2.SellingPriceExVAT)
FROM Demo_Retail_Price p1
INNER JOIN #DuplicateMapping dm ON p1.ProductID = dm.KeepProductID
INNER JOIN Demo_Retail_Price p2 ON p2.ProductID = dm.DeleteProductID AND p2.BranchID = p1.BranchID
WHERE p1.CostPrice IS NULL OR p1.CostPrice = 0

-- Delete duplicate price records
DELETE p
FROM Demo_Retail_Price p
INNER JOIN #DuplicateMapping dm ON p.ProductID = dm.DeleteProductID

-- Update POS_InvoiceLines (if exists)
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'POS_InvoiceLines')
BEGIN
    UPDATE pil
    SET ProductID = dm.KeepProductID
    FROM POS_InvoiceLines pil
    INNER JOIN #DuplicateMapping dm ON pil.ProductID = dm.DeleteProductID
END

-- Update any other tables that might reference ProductID
-- InvoiceLines (supplier invoices) - only if ProductID column exists
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'InvoiceLines' AND COLUMN_NAME = 'ProductID')
BEGIN
    UPDATE il
    SET ProductID = dm.KeepProductID
    FROM InvoiceLines il
    INNER JOIN #DuplicateMapping dm ON il.ProductID = dm.DeleteProductID
END

-- Step 4: Delete duplicate products
DELETE p
FROM Demo_Retail_Product p
INNER JOIN #DuplicateMapping dm ON p.ProductID = dm.DeleteProductID

-- Show results
PRINT 'Consolidation complete!'
SELECT 
    COUNT(*) AS ProductsDeleted,
    SUM(MergedStock) AS TotalStockMerged
FROM #DuplicateMapping

-- Cleanup
DROP TABLE #DuplicateMapping

-- COMMIT or ROLLBACK?
-- Review the output above, then:
-- COMMIT TRANSACTION  -- Run this if everything looks good
-- ROLLBACK TRANSACTION  -- Run this to undo changes
COMMIT TRANSACTION