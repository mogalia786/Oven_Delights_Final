-- Check if old Products table still exists and has ACCEX-BOS-EAC
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL
BEGIN
    SELECT 'Old Products table EXISTS!' AS Warning;
    
    SELECT 
        ProductID,
        ProductCode,
        SKU,
        ProductName,
        CurrentStock
    FROM dbo.Products
    WHERE SKU = 'ACCEX-BOS-EAC' OR ProductName LIKE '%Bar One Slice%'
    ORDER BY ProductID;
END
ELSE
BEGIN
    SELECT 'Old Products table does NOT exist - Good!' AS Status;
END

-- Check Demo_Retail_Product for ACCEX-BOS-EAC
SELECT 
    ProductID,
    SKU,
    Name,
    BranchID,
    CurrentStock,
    ProductType
FROM dbo.Demo_Retail_Product
WHERE SKU = 'ACCEX-BOS-EAC'
ORDER BY ProductID;

-- Check if POS might be using a VIEW
SELECT 
    TABLE_NAME,
    VIEW_DEFINITION
FROM INFORMATION_SCHEMA.VIEWS
WHERE VIEW_DEFINITION LIKE '%ACCEX-BOS-EAC%'
   OR TABLE_NAME LIKE '%POS%Product%'
ORDER BY TABLE_NAME;
