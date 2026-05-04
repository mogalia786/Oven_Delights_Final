-- Fix Missing Variants for Products
-- These products exist in Demo_Retail_Product but are missing entries in Demo_Retail_Variant
-- This prevents stock updates from working correctly

USE Oven_Delights_ERP;
GO

BEGIN TRANSACTION;

-- Insert missing variants for the 7 products identified in the error log
INSERT INTO Demo_Retail_Variant (ProductID, SKU, IsActive, CreatedAt)
SELECT 
    p.ProductID,
    p.SKU,
    1 AS IsActive,
    GETDATE() AS CreatedAt
FROM Demo_Retail_Product p
WHERE p.ProductID IN (59902, 59962, 59942, 59972, 59932, 59912, 59952)
  AND NOT EXISTS (
      SELECT 1 
      FROM Demo_Retail_Variant v 
      WHERE v.ProductID = p.ProductID
  );

-- Verify the inserts
SELECT 
    v.VariantID,
    v.ProductID,
    v.SKU,
    p.Name AS ProductName,
    v.IsActive,
    v.CreatedAt
FROM Demo_Retail_Variant v
INNER JOIN Demo_Retail_Product p ON v.ProductID = p.ProductID
WHERE v.ProductID IN (59902, 59962, 59942, 59972, 59932, 59912, 59952)
ORDER BY v.ProductID;

-- Check if there are any other products missing variants
SELECT 
    p.ProductID,
    p.SKU,
    p.Name,
    p.BranchID,
    b.BranchName
FROM Demo_Retail_Product p
INNER JOIN Branches b ON p.BranchID = b.BranchID
WHERE p.IsActive = 1
  AND NOT EXISTS (
      SELECT 1 
      FROM Demo_Retail_Variant v 
      WHERE v.ProductID = p.ProductID AND v.IsActive = 1
  )
ORDER BY p.BranchID, p.Name;

COMMIT TRANSACTION;

PRINT 'Missing variants created successfully!';
