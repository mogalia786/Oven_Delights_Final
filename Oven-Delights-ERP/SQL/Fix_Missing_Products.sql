-- The missing items are ProductIDs 56791 and 56893
-- They don't exist in Products or Stockroom_Product tables

-- Option 1: Check if they exist in Products table but with different columns
SELECT * FROM Products WHERE ProductID IN (56791, 56893);

-- Option 2: Check if they were deleted or deactivated
SELECT * FROM Stockroom_Product WHERE ProductID IN (56791, 56893);

-- Option 3: Search for products with similar names
SELECT ProductID, Name, Code FROM Stockroom_Product 
WHERE Name LIKE '%stabiliser%' OR Name LIKE '%petina%' OR Name LIKE '%cream%'
ORDER BY Name;

-- Option 4: If they truly don't exist, you need to either:
-- A) Add them to Stockroom_Product table, OR
-- B) Update the PO lines to reference correct ProductIDs

-- To see what data you'd need to add:
SELECT pol.POLineID, pol.ProductID, pol.OrderedQuantity, pol.UnitCost
FROM PurchaseOrderLines pol
WHERE pol.ProductID IN (56791, 56893) AND pol.PurchaseOrderID = 322;
