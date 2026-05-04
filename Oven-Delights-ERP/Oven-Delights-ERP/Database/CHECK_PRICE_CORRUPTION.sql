-- Check if Demo_Retail_Price has duplicate/corrupted records from the wrong BranchID
-- This will show if the stored procedure created duplicate price records

-- Check for products that now have prices in BOTH BranchID 1 and 6
SELECT 
    p.ProductID,
    p.Name,
    p.Category,
    price1.CostPrice AS [BranchID_1_CostPrice],
    price6.CostPrice AS [BranchID_6_CostPrice],
    CASE 
        WHEN price1.CostPrice IS NOT NULL AND price6.CostPrice IS NOT NULL THEN 'DUPLICATE PRICES'
        WHEN price1.CostPrice IS NULL AND price6.CostPrice IS NOT NULL THEN 'ONLY BranchID 6 (WRONG)'
        WHEN price1.CostPrice IS NOT NULL AND price6.CostPrice IS NULL THEN 'ONLY BranchID 1 (CORRECT)'
        ELSE 'NO PRICES'
    END AS [Status]
FROM Demo_Retail_Product p
LEFT JOIN Demo_Retail_Price price1 ON p.ProductID = price1.ProductID AND price1.BranchID = 1
LEFT JOIN Demo_Retail_Price price6 ON p.ProductID = price6.ProductID AND price6.BranchID = 6
WHERE p.Category LIKE '%ingredient%' OR p.Category LIKE '%sub%recipe%'
ORDER BY [Status], p.Name;

-- Count summary
SELECT 
    CASE 
        WHEN price1.CostPrice IS NOT NULL AND price6.CostPrice IS NOT NULL THEN 'DUPLICATE PRICES'
        WHEN price1.CostPrice IS NULL AND price6.CostPrice IS NOT NULL THEN 'ONLY BranchID 6 (WRONG)'
        WHEN price1.CostPrice IS NOT NULL AND price6.CostPrice IS NULL THEN 'ONLY BranchID 1 (CORRECT)'
        ELSE 'NO PRICES'
    END AS [Status],
    COUNT(*) AS [Count]
FROM Demo_Retail_Product p
LEFT JOIN Demo_Retail_Price price1 ON p.ProductID = price1.ProductID AND price1.BranchID = 1
LEFT JOIN Demo_Retail_Price price6 ON p.ProductID = price6.ProductID AND price6.BranchID = 6
WHERE p.Category LIKE '%ingredient%' OR p.Category LIKE '%sub%recipe%'
GROUP BY 
    CASE 
        WHEN price1.CostPrice IS NOT NULL AND price6.CostPrice IS NOT NULL THEN 'DUPLICATE PRICES'
        WHEN price1.CostPrice IS NULL AND price6.CostPrice IS NOT NULL THEN 'ONLY BranchID 6 (WRONG)'
        WHEN price1.CostPrice IS NOT NULL AND price6.CostPrice IS NULL THEN 'ONLY BranchID 1 (CORRECT)'
        ELSE 'NO PRICES'
    END;
