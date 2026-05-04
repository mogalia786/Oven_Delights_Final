-- Test the EXACT update that GRV is running

DECLARE @ProductID INT = 56840
DECLARE @BranchID INT = 6
DECLARE @Qty DECIMAL(18,3) = 200.000

-- Show BEFORE
SELECT ProductID, Name, BranchID, CurrentStock 
FROM Demo_Retail_Product 
WHERE ProductID = @ProductID AND BranchID = @BranchID

-- Run the EXACT update
UPDATE Demo_Retail_Product 
SET CurrentStock = ISNULL(CurrentStock, 0) + @Qty 
WHERE ProductID = @ProductID AND BranchID = @BranchID

PRINT 'Rows affected: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- Show AFTER
SELECT ProductID, Name, BranchID, CurrentStock 
FROM Demo_Retail_Product 
WHERE ProductID = @ProductID AND BranchID = @BranchID
