-- Check Biscuit Coconut pricing - CORRECTED COLUMN NAMES

-- 1. Find the product (use correct column names)
SELECT ProductID, Name, BranchID 
FROM dbo.Demo_Retail_Product 
WHERE Name LIKE '%Biscuit Coconut%';

-- 2. Check pricing in Demo_Retail_Price
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    pr.BranchID,
    pr.CostPrice AS 'Cost Excl VAT',
    pr.SellingPrice AS 'Last Paid (Incl VAT)',
    pr.SellingPriceExVAT AS 'Selling Excl VAT',
    pr.ModifiedAt AS 'Last Updated'
FROM dbo.Demo_Retail_Product p
LEFT JOIN dbo.Demo_Retail_Price pr ON p.ProductID = pr.ProductID
WHERE p.Name LIKE '%Biscuit Coconut%'
ORDER BY pr.BranchID;

-- 3. Check recent invoice captures for this product
SELECT TOP 5
    ic.InvoiceID,
    ic.InvoiceNumber,
    ic.InvoiceDate,
    ic.BranchID,
    icl.ProductID,
    icl.Quantity,
    icl.UnitCost AS 'Unit Cost Entered',
    ic.CreatedDate
FROM dbo.InvoiceCapture ic
INNER JOIN dbo.InvoiceCaptureLines icl ON ic.InvoiceID = icl.InvoiceID
WHERE icl.ProductID IN (SELECT ProductID FROM dbo.Demo_Retail_Product WHERE Name LIKE '%Biscuit Coconut%')
ORDER BY ic.CreatedDate DESC;

-- 4. Show all products to verify
SELECT TOP 10 ProductID, Name, BranchID FROM dbo.Demo_Retail_Product;
