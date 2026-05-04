-- Check what's actually stored in the database for Salt Bale
-- This will help determine if the issue is in storage or retrieval

-- 0. First check what columns actually exist in Demo_Retail_Product
SELECT TOP 1 * FROM Demo_Retail_Product WHERE Name LIKE '%Salt Bale%';

-- 1. Check Demo_Retail_Product (basic info)
SELECT 
    ProductID,
    Name,
    SKU,
    IsVatable,
    BranchID,
    ProductType,
    Category
FROM Demo_Retail_Product
WHERE Name LIKE '%Salt Bale%'
ORDER BY BranchID;

-- 2. Check ProductPriceHistory (what was saved from invoices)
SELECT 
    PriceHistoryID,
    ProductName,
    CostPrice,
    InvoiceDate,
    SupplierName,
    BranchID,
    CapturedDate
FROM ProductPriceHistory
WHERE ProductName LIKE '%Salt Bale%'
ORDER BY InvoiceDate DESC;

-- 3. Check Demo_Retail_Price (CostPrice)
SELECT 
    p.ProductID,
    p.Name,
    p.IsVatable,
    rp.CostPrice,
    p.BranchID
FROM Demo_Retail_Product p
LEFT JOIN Demo_Retail_Price rp ON p.ProductID = rp.ProductID AND p.BranchID = rp.BranchID
WHERE p.Name LIKE '%Salt Bale%';

-- EXPECTED RESULTS:
-- If Salt Bale is non-vatable and was purchased at R20:
-- - LastPaidPrice should be 20.00 (NOT 17.39)
-- - ProductPriceHistory.CostPrice should be 20.00 (NOT 17.39)
-- - Demo_Retail_Price.CostPrice should be 20.00 (NOT 17.39)

-- If you see 17.39 in any of these, the problem is in how prices are SAVED, not loaded
