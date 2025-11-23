-- Fix Bar One Spread stock for your current branch

-- What branch are you using? Change this to your branch number
DECLARE @YourBranchID INT = 1  -- CHANGE THIS TO YOUR BRANCH ID

-- Update stock for Bar One Spread for your branch
UPDATE Demo_Retail_Product
SET CurrentStock = 100  -- Set to 100 for testing
WHERE Name = 'Bar One Spread' 
  AND BranchID = @YourBranchID

-- Show result
SELECT ProductID, Name, BranchID, CurrentStock
FROM Demo_Retail_Product
WHERE Name = 'Bar One Spread'
ORDER BY BranchID
