-- Fix StockroomStock table - remove invalid ProductIDs 
-- RawMaterials uses MaterialID, not ProductID
-- We need to find the link between MaterialID and ProductID

-- Step 1: Check RawMaterials structure
SELECT TOP 5 MaterialID, MaterialName, CurrentStock
FROM RawMaterials
WHERE CurrentStock > 0

-- Step 2: Check if Products table has materials with matching names
SELECT TOP 5 p.ProductID, p.ProductName, rm.MaterialID, rm.MaterialName, rm.CurrentStock
FROM RawMaterials rm
LEFT JOIN Products p ON p.ProductName = rm.MaterialName
WHERE rm.CurrentStock > 0

-- Step 3: Show invalid entries in StockroomStock (ProductIDs that don't exist in Products table)
SELECT ss.ProductID, ss.Quantity, 'INVALID - Not in Products table' AS Issue
FROM StockroomStock ss
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductID = ss.ProductID)

-- Step 4: Delete invalid entries
DELETE FROM StockroomStock
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductID = ProductID)

PRINT 'Cleaned up invalid StockroomStock entries'

-- Step 5: Rebuild StockroomStock by matching ProductName to MaterialName
-- Note: Using BranchID = 1 as default - adjust if needed for multi-branch
INSERT INTO StockroomStock (ProductID, Quantity, BranchID, UpdatedBy)
SELECT p.ProductID, rm.CurrentStock, 1, 'SYSTEM'
FROM RawMaterials rm
INNER JOIN Products p ON p.ProductName = rm.MaterialName
WHERE rm.CurrentStock > 0
AND NOT EXISTS (SELECT 1 FROM StockroomStock WHERE ProductID = p.ProductID AND BranchID = 1)

PRINT 'Rebuilt StockroomStock from RawMaterials by matching ProductName to MaterialName'

-- Step 6: Verify results
SELECT p.ProductID, p.ProductName, ss.Quantity
FROM StockroomStock ss
INNER JOIN Products p ON ss.ProductID = p.ProductID
ORDER BY p.ProductName
