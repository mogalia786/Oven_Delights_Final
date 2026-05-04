-- Test the stored procedure directly to see what happens
DECLARE @NewProductID INT;

EXEC sp_SaveProductToAllBranches
    @ProductName = 'Test Product Direct',
    @ProductCode = 'TEST123',
    @SKU = '999999999999',
    @CategoryID = 22, -- buttercream
    @SubcategoryID = 18, -- buttercream cake
    @ItemType = 'internal',
    @IsActive = 1,
    @IsVatable = 1,
    @ProductImage = NULL,
    @CostPrice = 0,
    @SellingPrice = 100,
    @CreatedBy = 'System',
    @NewProductID = @NewProductID OUTPUT;

SELECT @NewProductID AS NewProductID;

-- Check if it was inserted
SELECT TOP 5
    ProductID,
    Name,
    Category,
    CategoryID,
    SubcategoryID,
    ProductType,
    BranchID,
    IsActive,
    CreatedAt
FROM Demo_Retail_Product
WHERE Name LIKE '%Test Product%'
ORDER BY CreatedAt DESC;
