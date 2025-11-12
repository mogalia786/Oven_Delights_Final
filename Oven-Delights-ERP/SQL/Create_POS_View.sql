-- Drop and recreate vw_POS_Products view
IF OBJECT_ID('vw_POS_Products', 'V') IS NOT NULL
    DROP VIEW vw_POS_Products;
GO

CREATE VIEW vw_POS_Products
AS
SELECT 
    p.ProductID,
    p.Code AS ItemCode,
    p.Name AS ProductName,
    p.Category,
    p.CategoryID,
    p.IsActive,
    v.VariantID AS StockID,
    p.BranchID,
    ISNULL(s.QtyOnHand, 0) AS QtyOnHand,
    ISNULL(s.ReorderPoint, 0) AS ReorderLevel,
    ISNULL(pr.SellingPrice, 0) AS SellingPrice,
    CAST(ROUND(ISNULL(pr.SellingPrice, 0) / 1.15, 2) AS DECIMAL(18,2)) AS SellingPriceExVAT,
    ISNULL(pr.CostPrice, 0) AS CostPrice
FROM Demo_Retail_Product p
INNER JOIN Demo_Retail_Variant v ON p.ProductID = v.ProductID
LEFT JOIN Demo_Retail_Price pr ON p.ProductID = pr.ProductID 
    AND pr.BranchID = p.BranchID
LEFT JOIN Demo_Retail_Stock s ON v.VariantID = s.VariantID 
    AND s.BranchID = p.BranchID
WHERE p.IsActive = 1 AND v.IsActive = 1;
GO

-- Verify the view
SELECT 
    BranchID,
    COUNT(*) AS ProductCount
FROM vw_POS_Products
GROUP BY BranchID
ORDER BY BranchID;

-- Sample data
SELECT TOP 5 * FROM vw_POS_Products WHERE BranchID = 6;
SELECT TOP 5 * FROM vw_POS_Products WHERE BranchID = 4;

PRINT 'vw_POS_Products view created successfully!';
