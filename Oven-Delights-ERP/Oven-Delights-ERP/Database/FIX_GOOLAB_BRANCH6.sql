-- Find Goolab Jumbu ProductID for Branch 6
SELECT ProductID, Name, BranchID, Recipe_Created
FROM Demo_Retail_Product
WHERE Name = 'Goolab Jumbu'
ORDER BY BranchID;

-- Update Recipe_Created for ALL branches of Goolab Jumbu
UPDATE Demo_Retail_Product
SET Recipe_Created = 1
WHERE Name = 'Goolab Jumbu';

-- Verify all branches updated
SELECT ProductID, Name, BranchID, Recipe_Created, ProductType, Category
FROM Demo_Retail_Product
WHERE Name = 'Goolab Jumbu'
ORDER BY BranchID;

PRINT 'Updated Recipe_Created for Goolab Jumbu across all branches';
