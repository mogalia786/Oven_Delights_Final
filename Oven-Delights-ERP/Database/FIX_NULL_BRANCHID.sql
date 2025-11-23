-- Fix NULL BranchID products
-- Products MUST have a BranchID - delete orphaned records

-- 1. Show products with NULL BranchID
SELECT ProductID, Name, Category, BranchID, CurrentStock
FROM Demo_Retail_Product
WHERE BranchID IS NULL

-- 2. Delete products with NULL BranchID (they are orphaned/invalid)
DELETE FROM Demo_Retail_Product
WHERE BranchID IS NULL

PRINT 'Deleted ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' products with NULL BranchID'

-- 3. Add constraint to prevent NULL BranchID in future
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_Demo_Retail_Product_BranchID_NotNull')
BEGIN
    ALTER TABLE Demo_Retail_Product
    ALTER COLUMN BranchID INT NOT NULL
    
    PRINT 'Added NOT NULL constraint to BranchID column'
END

-- 4. Show remaining products
SELECT BranchID, COUNT(*) AS ProductCount
FROM Demo_Retail_Product
GROUP BY BranchID
ORDER BY BranchID
