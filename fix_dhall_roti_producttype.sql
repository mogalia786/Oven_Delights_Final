-- Quick fix: Change Dhall Roti (6s) ProductType from External to Internal
-- This allows it to appear in Create Product Recipe dropdown with current production code
-- Run this on the production database as a temporary fix

-- First, check current state
SELECT 
    ProductID,
    Name,
    ProductType,
    BranchID
FROM Demo_Retail_Product
WHERE Name LIKE '%Dhall Roti%'
ORDER BY BranchID;

-- Update all Dhall Roti products across all branches to Internal
UPDATE Demo_Retail_Product
SET ProductType = 'Internal'
WHERE Name LIKE '%Dhall Roti%';

-- Verify the change
SELECT 
    ProductID,
    Name,
    ProductType,
    BranchID
FROM Demo_Retail_Product
WHERE Name LIKE '%Dhall Roti%'
ORDER BY BranchID;

PRINT 'Dhall Roti ProductType updated to Internal successfully';
