-- SQL Scripts to run in your SQL Management Environment
-- Execute these scripts in the exact order listed below

-- STEP 1: Create Teller Role and Permissions
-- File: CreateTellerRole.sql
-- This creates the Teller role with POS permissions

-- STEP 2: Add Code Fields to Product Tables  
-- File: AddCodeFieldsToProducts.sql
-- This adds Code field to all product tables and populates with sequential values

-- STEP 3: Add Code Field to Sale Lines Table
-- File: AddCodeToSaleLines.sql
-- This adds Code field to Retail_SaleLines table for tracking product codes in sales

-- STEP 4: Verify the changes
-- Run this verification query after completing steps 1 and 2:

SELECT 'Roles Check' AS CheckType, COUNT(*) AS Count 
FROM Roles WHERE RoleName = 'Teller'

UNION ALL

SELECT 'Permissions Check' AS CheckType, COUNT(*) AS Count 
FROM Permissions WHERE PermissionName IN ('POS_ACCESS', 'PRODUCT_VIEW', 'STOCK_VIEW', 'SALES_PROCESS', 'CASH_HANDLING', 'SALES_REPORTS')

UNION ALL

SELECT 'Retail Product Code Check' AS CheckType, COUNT(*) AS Count 
FROM Retail_Product WHERE Code IS NOT NULL

-- STEP 4: Test Code field functionality
-- Run this to see the Code values that were assigned:

SELECT TOP 10 
    ProductID,
    Code,
    SKU,
    Name
FROM Retail_Product 
ORDER BY Code

-- Expected result: You should see Code values like 00001, 00002, 00003, etc.
