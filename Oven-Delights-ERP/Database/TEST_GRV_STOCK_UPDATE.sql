-- Test GRV stock update logic

DECLARE @ProductID INT = 56940  -- Bar One Spread ProductID (change this to your actual ProductID)
DECLARE @BranchID INT = 1       -- Your branch ID (change this to your actual branch)
DECLARE @Qty DECIMAL(18,3) = 50.000

PRINT '=== BEFORE UPDATE ==='
SELECT ProductID, Name, BranchID, CurrentStock
FROM Demo_Retail_Product
WHERE ProductID = @ProductID AND BranchID = @BranchID

PRINT ''
PRINT '=== EXECUTING UPDATE ==='
PRINT 'ProductID: ' + CAST(@ProductID AS VARCHAR(10))
PRINT 'BranchID: ' + CAST(@BranchID AS VARCHAR(10))
PRINT 'Quantity to add: ' + CAST(@Qty AS VARCHAR(10))

-- This is the exact same UPDATE that GRV uses
UPDATE Demo_Retail_Product 
SET CurrentStock = ISNULL(CurrentStock, 0) + @Qty
WHERE ProductID = @ProductID AND BranchID = @BranchID

PRINT 'Rows affected: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

PRINT ''
PRINT '=== AFTER UPDATE ==='
SELECT ProductID, Name, BranchID, CurrentStock
FROM Demo_Retail_Product
WHERE ProductID = @ProductID AND BranchID = @BranchID

PRINT ''
PRINT '=== ALL Bar One Spread RECORDS ==='
SELECT ProductID, Name, BranchID, CurrentStock
FROM Demo_Retail_Product
WHERE Name = 'Bar One Spread'
ORDER BY BranchID
