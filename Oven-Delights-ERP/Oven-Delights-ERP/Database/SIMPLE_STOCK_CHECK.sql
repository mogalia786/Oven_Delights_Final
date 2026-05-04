-- Simple check - just show the data

-- 1. Bar One Spread in Demo_Retail_Product
SELECT ProductID, Name, Category, ProductType, BranchID, CurrentStock
FROM Demo_Retail_Product
WHERE Name LIKE '%Bar One Spread%'

-- 2. Manual update test
DECLARE @PID INT, @BID INT = 1
SELECT TOP 1 @PID = ProductID FROM Demo_Retail_Product WHERE Name LIKE '%Bar One Spread%' AND BranchID = @BID

PRINT 'ProductID: ' + CAST(@PID AS VARCHAR(10))

UPDATE Demo_Retail_Product 
SET CurrentStock = ISNULL(CurrentStock, 0) + 50
WHERE ProductID = @PID AND BranchID = @BID

SELECT ProductID, Name, BranchID, CurrentStock
FROM Demo_Retail_Product
WHERE ProductID = @PID
