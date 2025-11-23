-- Copy stock from ProductID 58840 to all other "Mvutu Bar One" products at Branch 6

UPDATE Demo_Retail_Product
SET CurrentStock = 7000.00
WHERE BranchID = 6
  AND Name LIKE '%Mvutu%Bar%One%'
  AND ProductID <> 58840

-- Verify the update
SELECT ProductID, Name, BranchID, CurrentStock
FROM Demo_Retail_Product
WHERE BranchID = 6
  AND Name LIKE '%Mvutu%'
ORDER BY Name, ProductID
