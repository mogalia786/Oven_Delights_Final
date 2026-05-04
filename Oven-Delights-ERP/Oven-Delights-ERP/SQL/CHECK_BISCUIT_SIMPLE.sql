-- Simple check without guessing column names

-- 1. Check what columns exist in Demo_Retail_Price
SELECT TOP 1 * FROM dbo.Demo_Retail_Price;

-- 2. Check what columns exist in Demo_Retail_Product
SELECT TOP 1 * FROM dbo.Demo_Retail_Product;

-- 3. Find Biscuit Coconut product ID
SELECT * FROM dbo.Demo_Retail_Product WHERE Name LIKE '%Biscuit%Coconut%';

-- 4. Check its price (replace ProductID with actual ID from step 3)
-- SELECT * FROM dbo.Demo_Retail_Price WHERE ProductID = [PUT_ID_HERE];
