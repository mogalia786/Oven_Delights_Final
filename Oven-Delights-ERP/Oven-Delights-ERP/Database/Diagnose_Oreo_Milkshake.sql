-- Diagnostic query to find OD Oreo Milkshake product
-- Check if it exists and why it might not appear in Purchase Orders

-- 1. Search for any product with "Oreo" in the name
SELECT 
    ProductID,
    SKU,
    Code,
    Name,
    Category,
    ProductType,
    BranchID,
    IsActive,
    CASE 
        WHEN IsActive = 0 THEN '❌ INACTIVE - This is why it does not appear!'
        WHEN BranchID IS NULL THEN '❌ NULL BranchID - This is why it does not appear!'
        WHEN IsActive = 1 AND BranchID IS NOT NULL THEN '✅ Should appear in PO list'
        ELSE '⚠️ Unknown issue'
    END AS Status
FROM Demo_Retail_Product
WHERE Name LIKE '%Oreo%'
ORDER BY Name;

-- 2. Check exact match for "OD Oreo Milkshake"
SELECT 
    ProductID,
    SKU,
    Code,
    Name,
    Category,
    ProductType,
    BranchID,
    IsActive
FROM Demo_Retail_Product
WHERE Name = 'OD Oreo Milkshake';

-- 3. Check with different spacing variations
SELECT 
    ProductID,
    SKU,
    Code,
    Name,
    Category,
    ProductType,
    BranchID,
    IsActive
FROM Demo_Retail_Product
WHERE Name IN ('OD Oreo Milkshake', 'OD Oreo Milk Shake', 'OD Oreo MilkShake');

-- 4. Show all branches to verify BranchID
SELECT BranchID, BranchName, BranchCode 
FROM Branches 
WHERE IsActive = 1 
ORDER BY BranchName;

-- 5. If you need to FIX the product, use one of these:

-- Fix Option A: If product exists but IsActive = 0, activate it
-- UPDATE Demo_Retail_Product 
-- SET IsActive = 1 
-- WHERE Name LIKE '%Oreo%Milkshake%' AND IsActive = 0;

-- Fix Option B: If product exists but BranchID is NULL, set it to your branch
-- UPDATE Demo_Retail_Product 
-- SET BranchID = 4  -- Change 4 to your actual BranchID (e.g., 4 for Umhlanga, 6 for Ayesha)
-- WHERE Name LIKE '%Oreo%Milkshake%' AND BranchID IS NULL;

-- Fix Option C: If product doesn't exist at all, you need to add it via the Product Management screen
