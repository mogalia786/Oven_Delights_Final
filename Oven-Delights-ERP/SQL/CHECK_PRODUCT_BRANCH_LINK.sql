-- Check if Demo_Retail_Product has BranchID and how products are linked to branches
SELECT TOP 10 ProductID, SKU, Name, BranchID, CurrentStock
FROM dbo.Demo_Retail_Product
WHERE ProductType = 'Internal'
ORDER BY ProductID DESC;

-- Check if products have NULL BranchID (shared across branches)
SELECT 
    CASE WHEN BranchID IS NULL THEN 'NULL (Shared)' ELSE CAST(BranchID AS VARCHAR) END AS BranchID,
    COUNT(*) AS ProductCount
FROM dbo.Demo_Retail_Product
GROUP BY BranchID
ORDER BY BranchID;
