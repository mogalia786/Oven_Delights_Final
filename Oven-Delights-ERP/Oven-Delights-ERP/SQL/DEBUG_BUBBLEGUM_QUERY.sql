-- EXACT QUERY BEING USED IN PO FORM
-- Line 297 in PurchaseOrderFormNew.vb

-- First, find the ProductID for "Bubblegum Milkshake Syrup"
SELECT ProductID, Name, BranchID 
FROM dbo.Demo_Retail_Product 
WHERE Name LIKE '%Bubblegum%'
ORDER BY ProductID;

-- Then, check what's in Demo_Retail_Price for those ProductIDs
SELECT 
    drp.ProductID,
    drp.BranchID,
    p.Name,
    drp.CostPrice,
    drp.SellingPrice,
    drp.SellingPriceExVAT
FROM dbo.Demo_Retail_Price drp
INNER JOIN dbo.Demo_Retail_Product p ON drp.ProductID = p.ProductID
WHERE p.Name LIKE '%Bubblegum%';

-- THE ACTUAL QUERY BEING RUN (for Branch 6 - AYESHA CENTRE):
-- SELECT ISNULL(SellingPrice, 0), ISNULL(CostPrice, 0) 
-- FROM dbo.Demo_Retail_Price 
-- WHERE ProductID = @id AND BranchID = @branchId

-- Test with actual values:
DECLARE @ProductID INT = 56326;  -- OD Bubblegum Milkshake
DECLARE @BranchID INT = 6;       -- AYESHA CENTRE

SELECT 
    'Query Result' AS Source,
    ISNULL(SellingPrice, 0) AS LastPaid,
    ISNULL(CostPrice, 0) AS AvgCost
FROM dbo.Demo_Retail_Price 
WHERE ProductID = @ProductID AND BranchID = @BranchID;

-- Check if the product name in the form matches the database
SELECT 
    ProductID,
    Name,
    BranchID,
    SKU,
    Code
FROM dbo.Demo_Retail_Product
WHERE Name = 'Bubblegum Milkshake Syrup'  -- EXACT match
   OR Name LIKE '%Bubblegum%Syrup%';       -- Partial match
