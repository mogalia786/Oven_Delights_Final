-- Create sample retail products for POS testing
-- Insert sample products into Retail_Product table

-- Check if products already exist
IF NOT EXISTS (SELECT 1 FROM Retail_Product WHERE Code = 'BREAD001')
BEGIN
    INSERT INTO Retail_Product (Code, SKU, Name, Description, CategoryID, SellingPrice, CostPrice, BranchID, IsActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
    VALUES 
    ('BREAD001', 'BREAD001', 'White Bread Loaf', 'Fresh white bread loaf', 1, 25.00, 15.00, 1, 1, 'admin', GETDATE(), 'admin', GETDATE()),
    ('BREAD002', 'BREAD002', 'Brown Bread Loaf', 'Healthy brown bread loaf', 1, 28.00, 18.00, 1, 1, 'admin', GETDATE(), 'admin', GETDATE()),
    ('CAKE001', 'CAKE001', 'Chocolate Cake', 'Rich chocolate cake slice', 2, 45.00, 25.00, 1, 1, 'admin', GETDATE(), 'admin', GETDATE()),
    ('CAKE002', 'CAKE002', 'Vanilla Cake', 'Classic vanilla cake slice', 2, 40.00, 22.00, 1, 1, 'admin', GETDATE(), 'admin', GETDATE()),
    ('MUFFIN001', 'MUFFIN001', 'Blueberry Muffin', 'Fresh blueberry muffin', 3, 18.00, 10.00, 1, 1, 'admin', GETDATE(), 'admin', GETDATE()),
    ('MUFFIN002', 'MUFFIN002', 'Chocolate Chip Muffin', 'Chocolate chip muffin', 3, 20.00, 12.00, 1, 1, 'admin', GETDATE(), 'admin', GETDATE()),
    ('COOKIE001', 'COOKIE001', 'Chocolate Chip Cookie', 'Classic chocolate chip cookie', 4, 12.00, 6.00, 1, 1, 'admin', GETDATE(), 'admin', GETDATE()),
    ('COOKIE002', 'COOKIE002', 'Oatmeal Cookie', 'Healthy oatmeal cookie', 4, 10.00, 5.00, 1, 1, 'admin', GETDATE(), 'admin', GETDATE()),
    ('DONUT001', 'DONUT001', 'Glazed Donut', 'Classic glazed donut', 5, 15.00, 8.00, 1, 1, 'admin', GETDATE(), 'admin', GETDATE()),
    ('DONUT002', 'DONUT002', 'Chocolate Donut', 'Chocolate glazed donut', 5, 16.00, 9.00, 1, 1, 'admin', GETDATE(), 'admin', GETDATE())
    
    PRINT 'Sample retail products created successfully'
END
ELSE
BEGIN
    PRINT 'Sample products already exist'
END

-- Create sample stock entries
IF NOT EXISTS (SELECT 1 FROM Retail_Stock WHERE ProductID = (SELECT ProductID FROM Retail_Product WHERE Code = 'BREAD001'))
BEGIN
    INSERT INTO Retail_Stock (ProductID, BranchID, QtyOnHand, ReorderLevel, MaxLevel, LastUpdated)
    SELECT p.ProductID, 1, 50, 10, 100, GETDATE()
    FROM Retail_Product p 
    WHERE p.Code IN ('BREAD001', 'BREAD002', 'CAKE001', 'CAKE002', 'MUFFIN001', 'MUFFIN002', 'COOKIE001', 'COOKIE002', 'DONUT001', 'DONUT002')
    
    PRINT 'Sample stock entries created successfully'
END
ELSE
BEGIN
    PRINT 'Sample stock entries already exist'
END
