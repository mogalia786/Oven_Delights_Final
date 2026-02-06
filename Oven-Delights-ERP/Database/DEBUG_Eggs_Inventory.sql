-- Check eggs product details and stock levels
SELECT TOP 10
    ProductID,
    Name,
    ProductType,
    Category,
    CurrentStock,
    BranchID,
    IsActive
FROM Demo_Retail_Product
WHERE Name LIKE '%egg%'
ORDER BY ProductID;

-- Check if eggs exists in RawMaterials
SELECT TOP 10
    MaterialID,
    MaterialName,
    MaterialCode,
    Category,
    CurrentStock,
    LastPaidPrice,
    LastPurchaseDate
FROM RawMaterials
WHERE MaterialName LIKE '%egg%'
ORDER BY MaterialID;

-- Check recent purchase order lines for eggs
SELECT TOP 10
    pol.POLineID,
    pol.POID,
    pol.ProductName,
    pol.ProductType,
    pol.MaterialID,
    pol.ProductID,
    pol.Quantity,
    pol.UnitCost,
    po.PONumber,
    po.Status
FROM PurchaseOrderLines pol
INNER JOIN PurchaseOrders po ON pol.POID = po.POID
WHERE pol.ProductName LIKE '%egg%'
ORDER BY pol.POLineID DESC;

-- Check Demo_Retail_Price for eggs
SELECT TOP 10
    ProductID,
    BranchID,
    CostPrice,
    SellingPrice,
    EffectiveFrom,
    CreatedAt
FROM Demo_Retail_Price
WHERE ProductID IN (SELECT ProductID FROM Demo_Retail_Product WHERE Name LIKE '%egg%')
ORDER BY ProductID, BranchID;
