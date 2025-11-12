-- Find where ACCEX-BOS-EAC exists
SELECT 'Demo_Retail_Product' AS TableName, ProductID, SKU, Name, CurrentStock, BranchID
FROM dbo.Demo_Retail_Product
WHERE SKU = 'ACCEX-BOS-EAC';

-- Check if it's in the old Products table
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL
BEGIN
    SELECT 'Products (OLD TABLE)' AS TableName, ProductID, SKU, ProductName
    FROM dbo.Products
    WHERE SKU = 'ACCEX-BOS-EAC';
END

-- Check vw_POS_Products view
SELECT 'vw_POS_Products' AS ViewName, ProductID, ItemCode, ProductName, QtyOnHand, BranchID
FROM vw_POS_Products
WHERE ItemCode = 'ACCEX-BOS-EAC';

-- Check what Bar One Slice records exist
SELECT 'All Bar One Slice in Demo_Retail_Product' AS Info, ProductID, SKU, Name, CurrentStock, BranchID
FROM dbo.Demo_Retail_Product
WHERE Name LIKE '%Bar One Slice%';
