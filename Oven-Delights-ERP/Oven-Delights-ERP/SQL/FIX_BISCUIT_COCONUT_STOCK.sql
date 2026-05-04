-- Fix Biscuit Coconut stock and pricing issue

-- 1. Check both product IDs
SELECT ProductID, SKU, Name, BranchID, IsActive 
FROM dbo.Demo_Retail_Product 
WHERE ProductID IN (17267, 55930);

-- 2. Check stock for both
SELECT * FROM dbo.Demo_Retail_Stock 
WHERE VariantID IN (17267, 55930);

-- 3. Check prices for both
SELECT * FROM dbo.Demo_Retail_Price 
WHERE ProductID IN (17267, 55930);

-- 4. Check recent invoice captures
SELECT TOP 5 
    ic.InvoiceNumber,
    ic.BranchID,
    icl.ProductID,
    icl.Quantity,
    icl.UnitCost,
    ic.CreatedDate
FROM dbo.InvoiceCapture ic
INNER JOIN dbo.InvoiceCaptureLines icl ON ic.InvoiceID = icl.InvoiceID
WHERE icl.ProductID IN (17267, 55930)
ORDER BY ic.CreatedDate DESC;

-- 5. If ProductID 55930 is the correct one, copy data from 17267
/*
-- Copy price from 17267 to 55930
INSERT INTO dbo.Demo_Retail_Price (ProductID, BranchID, CostPrice, SellingPrice, SellingPriceExVAT, EffectiveFrom, CreatedAt)
SELECT 55930, BranchID, CostPrice, SellingPrice, SellingPriceExVAT, EffectiveFrom, GETDATE()
FROM dbo.Demo_Retail_Price
WHERE ProductID = 17267;

-- Copy stock from 17267 to 55930
INSERT INTO dbo.Demo_Retail_Stock (VariantID, BranchID, QtyOnHand, AverageCost, UpdatedAt)
SELECT 55930, BranchID, QtyOnHand, AverageCost, GETDATE()
FROM dbo.Demo_Retail_Stock
WHERE VariantID = 17267;
*/
