-- Check the actual data in PurchaseOrderLines for this PO
SELECT 
    pol.POLineID,
    pol.PurchaseOrderID,
    pol.MaterialID,
    pol.ProductID,
    pol.OrderedQuantity,
    pol.UnitCost,
    pol.IsVatable,
    pol.ItemSource
FROM PurchaseOrderLines pol
WHERE pol.PurchaseOrderID IN (
    SELECT PurchaseOrderID 
    FROM PurchaseOrders 
    WHERE PONumber = 'PO-6-20260210213001'
)

-- Check if these items exist in RawMaterials
SELECT MaterialID, MaterialCode, MaterialName, LastPaidPrice
FROM RawMaterials
WHERE MaterialName LIKE '%FlourCake%' OR MaterialName LIKE '%Eggs%'

-- Check if these items exist in Demo_Retail_Product for Branch 6
SELECT ProductID, Name, IsVatable, ProductType, Category, BranchID
FROM Demo_Retail_Product
WHERE (Name LIKE '%FlourCake%' OR Name LIKE '%Eggs%')
  AND BranchID = 6
