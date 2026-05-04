-- Test the exact query used by InventoryReportForm
-- Run this with BranchID = 6 (Ayesha Centre) to see what it returns

DECLARE @bid INT = 6  -- Ayesha Centre
DECLARE @cat NVARCHAR(100) = 'All Categories'

SELECT 
    p.ProductID, 
    ISNULL(p.SKU, p.Code) AS SKU, 
    p.Name AS ProductName,
    ISNULL(p.Category, 'General') AS Category,
    ISNULL(p.CurrentStock, 0) AS QtyOnHand,
    ISNULL(pr.CostPrice, 0) AS UnitPrice,
    (ISNULL(p.CurrentStock, 0) * ISNULL(pr.CostPrice, 0)) AS TotalValue,
    0 AS ReorderPoint,
    '' AS Location,
    ISNULL(b.BranchName, 'Unknown') AS BranchName,
    p.BranchID,
    p.IsActive
FROM dbo.Demo_Retail_Product p
LEFT JOIN dbo.Demo_Retail_Price pr ON pr.ProductID = p.ProductID AND pr.BranchID = p.BranchID
LEFT JOIN dbo.Branches b ON b.BranchID = p.BranchID
WHERE p.IsActive = 1
  AND (@bid IS NULL OR p.BranchID = @bid)
  AND (@cat = 'All Categories' OR ISNULL(p.Category, 'General') = @cat)
  AND p.Name LIKE '%egg%'  -- Filter for eggs only
ORDER BY p.Name, p.BranchID;

-- Also check what categories exist
SELECT DISTINCT Category, COUNT(*) AS ProductCount
FROM Demo_Retail_Product
WHERE IsActive = 1
GROUP BY Category
ORDER BY Category;
