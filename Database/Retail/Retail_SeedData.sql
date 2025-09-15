-- Retail Module Seed Data
-- Creates sample products and data for testing Phase 1 and Phase 2 functionality

SET NOCOUNT ON;

-- Insert sample products
IF NOT EXISTS (SELECT 1 FROM dbo.Retail_Product WHERE SKU = 'BREAD001')
BEGIN
    INSERT INTO dbo.Retail_Product (SKU, Name, Category, Description, IsActive)
    VALUES 
    ('BREAD001', 'White Bread Loaf', 'Bakery', 'Fresh white bread loaf 800g', 1),
    ('BREAD002', 'Brown Bread Loaf', 'Bakery', 'Whole wheat brown bread 800g', 1),
    ('CAKE001', 'Chocolate Cake', 'Cakes', 'Rich chocolate layer cake', 1),
    ('MUFFIN001', 'Blueberry Muffin', 'Pastries', 'Fresh blueberry muffin', 1),
    ('CROISS001', 'Plain Croissant', 'Pastries', 'Buttery plain croissant', 1);
END

-- Create variants for each product
DECLARE @ProductID INT, @VariantID INT;

-- Process each product
DECLARE product_cursor CURSOR FOR 
SELECT ProductID FROM dbo.Retail_Product WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM dbo.Retail_Variant);

OPEN product_cursor;
FETCH NEXT FROM product_cursor INTO @ProductID;

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC dbo.sp_Retail_EnsureVariant @ProductID = @ProductID, @VariantID = @VariantID OUTPUT;
    FETCH NEXT FROM product_cursor INTO @ProductID;
END

CLOSE product_cursor;
DEALLOCATE product_cursor;

-- Insert sample prices (assuming BranchID 1 exists, or NULL for global pricing)
DECLARE @BranchID INT = NULL;
IF EXISTS (SELECT 1 FROM dbo.Branches WHERE BranchID = 1)
    SET @BranchID = 1;

INSERT INTO dbo.Retail_Price (ProductID, BranchID, SellingPrice, Currency, EffectiveFrom)
SELECT p.ProductID, @BranchID, 
    CASE 
        WHEN p.SKU LIKE 'BREAD%' THEN 25.00
        WHEN p.SKU LIKE 'CAKE%' THEN 150.00
        WHEN p.SKU LIKE 'MUFFIN%' THEN 15.00
        WHEN p.SKU LIKE 'CROISS%' THEN 12.00
        ELSE 10.00
    END,
    'ZAR',
    CAST(GETDATE() AS DATE)
FROM dbo.Retail_Product p
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.Retail_Price pr 
    WHERE pr.ProductID = p.ProductID 
    AND (pr.BranchID = @BranchID OR (pr.BranchID IS NULL AND @BranchID IS NULL))
);

-- Insert sample stock levels
INSERT INTO dbo.Retail_Stock (VariantID, BranchID, QtyOnHand, ReorderPoint, Location)
SELECT v.VariantID, @BranchID, 
    CASE 
        WHEN p.SKU LIKE 'BREAD%' THEN 50
        WHEN p.SKU LIKE 'CAKE%' THEN 5
        WHEN p.SKU LIKE 'MUFFIN%' THEN 20
        WHEN p.SKU LIKE 'CROISS%' THEN 30
        ELSE 10
    END,
    CASE 
        WHEN p.SKU LIKE 'BREAD%' THEN 10
        WHEN p.SKU LIKE 'CAKE%' THEN 2
        WHEN p.SKU LIKE 'MUFFIN%' THEN 5
        WHEN p.SKU LIKE 'CROISS%' THEN 8
        ELSE 3
    END,
    'MAIN'
FROM dbo.Retail_Variant v
JOIN dbo.Retail_Product p ON p.ProductID = v.ProductID
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.Retail_Stock s 
    WHERE s.VariantID = v.VariantID 
    AND (s.BranchID = @BranchID OR (s.BranchID IS NULL AND @BranchID IS NULL))
);

-- Insert sample product images (URLs)
INSERT INTO dbo.Retail_ProductImage (ProductID, ImageUrl, IsPrimary)
SELECT p.ProductID, 
    CASE 
        WHEN p.SKU = 'BREAD001' THEN 'https://example.com/images/white-bread.jpg'
        WHEN p.SKU = 'BREAD002' THEN 'https://example.com/images/brown-bread.jpg'
        WHEN p.SKU = 'CAKE001' THEN 'https://example.com/images/chocolate-cake.jpg'
        WHEN p.SKU = 'MUFFIN001' THEN 'https://example.com/images/blueberry-muffin.jpg'
        WHEN p.SKU = 'CROISS001' THEN 'https://example.com/images/croissant.jpg'
        ELSE 'https://example.com/images/default-product.jpg'
    END,
    1
FROM dbo.Retail_Product p
WHERE NOT EXISTS (SELECT 1 FROM dbo.Retail_ProductImage i WHERE i.ProductID = p.ProductID);

-- Insert some historical prices for price history testing
INSERT INTO dbo.Retail_Price (ProductID, BranchID, SellingPrice, Currency, EffectiveFrom, EffectiveTo)
SELECT p.ProductID, @BranchID, 
    CASE 
        WHEN p.SKU LIKE 'BREAD%' THEN 22.00
        WHEN p.SKU LIKE 'CAKE%' THEN 140.00
        WHEN p.SKU LIKE 'MUFFIN%' THEN 12.00
        WHEN p.SKU LIKE 'CROISS%' THEN 10.00
        ELSE 8.00
    END,
    'ZAR',
    DATEADD(MONTH, -3, CAST(GETDATE() AS DATE)),
    DATEADD(DAY, -1, CAST(GETDATE() AS DATE))
FROM dbo.Retail_Product p
WHERE p.ProductID % 2 = 1; -- Only for odd ProductIDs to create some variety

PRINT 'Retail seed data inserted successfully.';
PRINT 'Products created: ' + CAST((SELECT COUNT(*) FROM dbo.Retail_Product) AS VARCHAR(10));
PRINT 'Variants created: ' + CAST((SELECT COUNT(*) FROM dbo.Retail_Variant) AS VARCHAR(10));
PRINT 'Price records: ' + CAST((SELECT COUNT(*) FROM dbo.Retail_Price) AS VARCHAR(10));
PRINT 'Stock records: ' + CAST((SELECT COUNT(*) FROM dbo.Retail_Stock) AS VARCHAR(10));
PRINT 'Image records: ' + CAST((SELECT COUNT(*) FROM dbo.Retail_ProductImage) AS VARCHAR(10));
