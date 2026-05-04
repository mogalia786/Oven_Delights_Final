-- Find exact ProductID and BranchID match

DECLARE @ProductID INT = 56840
DECLARE @BranchID INT = 6

-- Check if this exact combination exists
SELECT COUNT(*) AS RecordExists
FROM Demo_Retail_Product
WHERE ProductID = @ProductID AND BranchID = @BranchID

-- Show what DOES exist for this ProductID
SELECT ProductID, Name, BranchID, CurrentStock
FROM Demo_Retail_Product
WHERE ProductID = @ProductID

-- Show what DOES exist for Bar One Spread at Branch 6
SELECT ProductID, Name, BranchID, CurrentStock
FROM Demo_Retail_Product
WHERE Name = 'Bar One Spread' AND BranchID = @BranchID
