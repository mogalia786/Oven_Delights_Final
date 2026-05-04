-- Update NULL BranchID products with correct BranchID
-- Find which branch they should belong to based on existing duplicates

-- 1. Show products with NULL BranchID and their duplicates
SELECT p1.ProductID, p1.Name, p1.BranchID, p2.ProductID AS DuplicateProductID, p2.BranchID AS DuplicateBranchID
FROM Demo_Retail_Product p1
LEFT JOIN Demo_Retail_Product p2 ON p1.Name = p2.Name AND p2.BranchID IS NOT NULL
WHERE p1.BranchID IS NULL
ORDER BY p1.Name

-- 2. Update NULL BranchID products to match their first duplicate's BranchID
-- Use CROSS APPLY to ensure single value per row
UPDATE p1
SET p1.BranchID = x.BranchID
FROM Demo_Retail_Product p1
CROSS APPLY (
    SELECT TOP 1 p2.BranchID 
    FROM Demo_Retail_Product p2 
    WHERE p2.Name = p1.Name AND p2.BranchID IS NOT NULL
    ORDER BY p2.ProductID
) x
WHERE p1.BranchID IS NULL

PRINT 'Updated ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' products with NULL BranchID'

-- 3. For any remaining NULL BranchID products (no duplicates), set to Branch 6 (your current branch)
UPDATE Demo_Retail_Product
SET BranchID = 6
WHERE BranchID IS NULL

PRINT 'Set remaining NULL BranchID products to Branch 6: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- 4. Show results
SELECT BranchID, COUNT(*) AS ProductCount
FROM Demo_Retail_Product
GROUP BY BranchID
ORDER BY BranchID

-- 5. Verify no NULL BranchID remains
SELECT COUNT(*) AS NullBranchIDCount
FROM Demo_Retail_Product
WHERE BranchID IS NULL
