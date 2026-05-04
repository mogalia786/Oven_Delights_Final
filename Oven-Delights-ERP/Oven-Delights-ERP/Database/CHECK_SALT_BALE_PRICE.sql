-- Check what's stored for Salt Bale product
-- This will help diagnose if the issue is in storage or retrieval

-- 1. Check product VAT status
SELECT 
    p.ProductID,
    p.Name,
    p.SKU,
    p.IsVatable,
    p.BranchID,
    b.BranchName
FROM Demo_Retail_Product p
INNER JOIN Branches b ON p.BranchID = b.BranchID
WHERE p.Name LIKE '%Salt Bale%'
ORDER BY p.BranchID;

-- 2. Check price history for Salt Bale
SELECT 
    ph.PriceHistoryID,
    ph.ProductName,
    ph.CostPrice,
    ph.InvoiceDate,
    ph.SupplierName,
    ph.InvoiceNumber,
    ph.BranchID,
    ph.CapturedDate
FROM ProductPriceHistory ph
WHERE ph.ProductName LIKE '%Salt Bale%'
ORDER BY ph.InvoiceDate DESC, ph.PriceHistoryID DESC;

-- 3. Check current cost price in Demo_Retail_Price
SELECT 
    p.ProductID,
    p.Name,
    rp.CostPrice,
    p.IsVatable,
    p.BranchID
FROM Demo_Retail_Product p
LEFT JOIN Demo_Retail_Price rp ON p.ProductID = rp.ProductID AND p.BranchID = rp.BranchID
WHERE p.Name LIKE '%Salt Bale%';

-- 4. Test what sp_GetLatestProductPrice returns
DECLARE @ProductID INT;
DECLARE @BranchID INT = 1; -- Change to your branch ID

-- Get ProductID for Salt Bale
SELECT @ProductID = ProductID 
FROM Demo_Retail_Product 
WHERE Name LIKE '%Salt Bale%' AND BranchID = @BranchID;

IF @ProductID IS NOT NULL
BEGIN
    PRINT 'Testing sp_GetLatestProductPrice for Salt Bale (ProductID: ' + CAST(@ProductID AS NVARCHAR(10)) + ')';
    EXEC sp_GetLatestProductPrice @ProductID, @BranchID;
END
ELSE
BEGIN
    PRINT 'Salt Bale product not found for BranchID ' + CAST(@BranchID AS NVARCHAR(10));
END
