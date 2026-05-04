-- Fix Macaroni Cake product so it appears in PO

-- STEP 1: Find the product
PRINT '=== STEP 1: Finding Macaroni Cake product ==='
SELECT 
    ProductID,
    SKU,
    Name,
    Category,
    ProductType,
    BranchID,
    IsActive
FROM Demo_Retail_Product
WHERE Name LIKE '%macaroni%cake%'
ORDER BY BranchID

-- STEP 2: Check if product exists in all branches
PRINT ''
PRINT '=== STEP 2: Checking branch coverage ==='
SELECT 
    b.BranchID,
    b.BranchName,
    CASE WHEN p.ProductID IS NOT NULL THEN 'YES' ELSE 'NO' END AS HasProduct
FROM Branches b
LEFT JOIN Demo_Retail_Product p ON p.BranchID = b.BranchID AND p.Name LIKE '%macaroni%cake%'
WHERE b.IsActive = 1
ORDER BY b.BranchID

-- STEP 3: Fix - Ensure product is active
PRINT ''
PRINT '=== STEP 3: Ensuring product is active ==='
UPDATE Demo_Retail_Product
SET IsActive = 1
WHERE Name LIKE '%macaroni%cake%'

SELECT @@ROWCOUNT AS RowsUpdated

-- STEP 4: If product only exists in one branch, copy to all branches
PRINT ''
PRINT '=== STEP 4: Checking if product needs to be copied to other branches ==='

DECLARE @ProductName NVARCHAR(255) = (SELECT TOP 1 Name FROM Demo_Retail_Product WHERE Name LIKE '%macaroni%cake%')
DECLARE @SourceProductID INT = (SELECT TOP 1 ProductID FROM Demo_Retail_Product WHERE Name LIKE '%macaroni%cake%')
DECLARE @SKU NVARCHAR(50)
DECLARE @Category NVARCHAR(100)
DECLARE @ProductType NVARCHAR(50)
DECLARE @IsVatable BIT
DECLARE @CostPrice DECIMAL(18,2)
DECLARE @SellingPrice DECIMAL(18,2)

IF @SourceProductID IS NOT NULL
BEGIN
    -- Get source product details
    SELECT 
        @SKU = SKU,
        @Category = Category,
        @ProductType = ProductType,
        @IsVatable = ISNULL(IsVatable, 1)
    FROM Demo_Retail_Product
    WHERE ProductID = @SourceProductID
    
    -- Get price from Demo_Retail_Price
    SELECT TOP 1
        @CostPrice = ISNULL(CostPrice, 0),
        @SellingPrice = ISNULL(SellingPrice, 0)
    FROM Demo_Retail_Price
    WHERE ProductID = @SourceProductID
    
    PRINT 'Source Product: ' + @ProductName
    PRINT 'SKU: ' + ISNULL(@SKU, 'NULL')
    PRINT 'Category: ' + ISNULL(@Category, 'NULL')
    PRINT 'ProductType: ' + ISNULL(@ProductType, 'NULL')
    PRINT 'CostPrice: ' + CAST(ISNULL(@CostPrice, 0) AS NVARCHAR)
    PRINT 'SellingPrice: ' + CAST(ISNULL(@SellingPrice, 0) AS NVARCHAR)
    
    -- Insert into branches that don't have it
    INSERT INTO Demo_Retail_Product (
        SKU, Name, Category, ProductType, BranchID, IsActive, IsVatable, CurrentStock
    )
    SELECT 
        @SKU,
        @ProductName,
        @Category,
        @ProductType,
        b.BranchID,
        1, -- IsActive
        @IsVatable,
        0 -- CurrentStock
    FROM Branches b
    WHERE b.IsActive = 1
      AND NOT EXISTS (
          SELECT 1 FROM Demo_Retail_Product p2 
          WHERE p2.Name = @ProductName AND p2.BranchID = b.BranchID
      )
    
    PRINT 'Products inserted: ' + CAST(@@ROWCOUNT AS NVARCHAR)
    
    -- Insert prices for new products
    INSERT INTO Demo_Retail_Price (
        ProductID, BranchID, CostPrice, SellingPrice, EffectiveFrom
    )
    SELECT 
        p.ProductID,
        p.BranchID,
        @CostPrice,
        @SellingPrice,
        GETDATE()
    FROM Demo_Retail_Product p
    WHERE p.Name = @ProductName
      AND NOT EXISTS (
          SELECT 1 FROM Demo_Retail_Price rp 
          WHERE rp.ProductID = p.ProductID AND rp.BranchID = p.BranchID
      )
    
    PRINT 'Price records inserted: ' + CAST(@@ROWCOUNT AS NVARCHAR)
END
ELSE
BEGIN
    PRINT 'ERROR: Macaroni Cake product not found!'
END

-- STEP 5: Verify final state
PRINT ''
PRINT '=== STEP 5: Final verification ==='
SELECT 
    p.ProductID,
    p.SKU,
    p.Name,
    p.BranchID,
    b.BranchName,
    p.IsActive,
    rp.CostPrice,
    rp.SellingPrice
FROM Demo_Retail_Product p
INNER JOIN Branches b ON b.BranchID = p.BranchID
LEFT JOIN Demo_Retail_Price rp ON rp.ProductID = p.ProductID AND rp.BranchID = p.BranchID
WHERE p.Name LIKE '%macaroni%cake%'
ORDER BY p.BranchID

-- STEP 6: Test PO query
PRINT ''
PRINT '=== STEP 6: Testing PO query (Branch 1) ==='
SELECT ProductID AS MaterialID, 
       ISNULL(Code, SKU) AS MaterialCode, 
       Name AS MaterialName, 
       0 AS AverageCost, 
       CASE WHEN ProductType = 'External' THEN 'EXT' ELSE 'RM' END AS ItemSource, 
       ISNULL(Category, 'Uncategorized') AS CategoryName 
FROM Demo_Retail_Product 
WHERE IsActive = 1 
  AND BranchID = 1
  AND Name LIKE '%macaroni%cake%'
ORDER BY Name

PRINT ''
PRINT '=== COMPLETE! Macaroni Cake should now appear in PO product list ==='
PRINT 'Close and reopen the PO form to refresh the product list'
