-- =============================================
-- TEST DATA: 5 External Products + Suppliers
-- Ready for POS System
-- Date: 2025-10-04 00:00
-- =============================================

SET NOCOUNT ON;
PRINT '========================================='
PRINT 'CREATING TEST DATA - 5 EXTERNAL PRODUCTS'
PRINT '========================================='
PRINT ''

-- =============================================
-- STEP 1: Create Test Suppliers
-- =============================================
PRINT '=== STEP 1: Creating Suppliers ==='

-- Coca-Cola
IF NOT EXISTS (SELECT * FROM Suppliers WHERE CompanyName = 'Coca-Cola Beverages SA')
BEGIN
    INSERT INTO Suppliers (CompanyName, ContactPerson, Email, Phone, Mobile, Address, City, Province, PostalCode, Country, VATNumber, BankName, BranchCode, AccountNumber, PaymentTerms, CreditLimit, IsActive, Notes, CreatedDate)
    VALUES ('Coca-Cola Beverages SA', 'John Smith', 'orders@ccbsa.co.za', '011-123-4567', '082-123-4567', '123 Main Road', 'Johannesburg', 'Gauteng', '2000', 'South Africa', '4123456789', 'FNB', '250655', '62123456789', '30 Days', 50000.00, 1, 'Main beverage supplier', GETDATE());
    PRINT '✓ Created Coca-Cola Beverages SA'
END

-- Tiger Brands
IF NOT EXISTS (SELECT * FROM Suppliers WHERE CompanyName = 'Tiger Brands Limited')
BEGIN
    INSERT INTO Suppliers (CompanyName, ContactPerson, Email, Phone, Mobile, Address, City, Province, PostalCode, Country, VATNumber, BankName, BranchCode, AccountNumber, PaymentTerms, CreditLimit, IsActive, Notes, CreatedDate)
    VALUES ('Tiger Brands Limited', 'Sarah Johnson', 'sales@tigerbrands.co.za', '011-234-5678', '083-234-5678', '456 Industrial Ave', 'Sandton', 'Gauteng', '2196', 'South Africa', '4234567890', 'ABSA', '632005', '4071234567', '30 Days', 75000.00, 1, 'Bread and snacks supplier', GETDATE());
    PRINT '✓ Created Tiger Brands Limited'
END

-- Simba Chips
IF NOT EXISTS (SELECT * FROM Suppliers WHERE CompanyName = 'Simba Chips')
BEGIN
    INSERT INTO Suppliers (CompanyName, ContactPerson, Email, Phone, Mobile, Address, City, Province, PostalCode, Country, VATNumber, BankName, BranchCode, AccountNumber, PaymentTerms, CreditLimit, IsActive, Notes, CreatedDate)
    VALUES ('Simba Chips', 'Robert Anderson', 'orders@simba.co.za', '011-901-2345', '082-901-2345', '369 Snack Avenue', 'Kempton Park', 'Gauteng', '1619', 'South Africa', '4901234567', 'Standard Bank', '051001', '072345678', '30 Days', 40000.00, 1, 'Snacks and chips', GETDATE());
    PRINT '✓ Created Simba Chips'
END

PRINT 'Suppliers created ✓'
PRINT ''
GO

-- =============================================
-- STEP 2: Create Categories
-- =============================================
PRINT '=== STEP 2: Creating Categories ==='

IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = 'Beverages')
BEGIN
    INSERT INTO Categories (CategoryName, IsActive) VALUES ('Beverages', 1);
    PRINT '✓ Created Beverages category'
END

IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = 'Bread')
BEGIN
    INSERT INTO Categories (CategoryName, IsActive) VALUES ('Bread', 1);
    PRINT '✓ Created Bread category'
END

IF NOT EXISTS (SELECT * FROM Categories WHERE CategoryName = 'Snacks')
BEGIN
    INSERT INTO Categories (CategoryName, IsActive) VALUES ('Snacks', 1);
    PRINT '✓ Created Snacks category'
END

PRINT 'Categories created ✓'
PRINT ''
GO

-- =============================================
-- STEP 3: Create Subcategories
-- =============================================
PRINT '=== STEP 3: Creating Subcategories ==='

DECLARE @BevCatID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Beverages');
DECLARE @BreadCatID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Bread');
DECLARE @SnackCatID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Snacks');

IF NOT EXISTS (SELECT * FROM Subcategories WHERE SubcategoryName = 'Soft Drinks')
BEGIN
    INSERT INTO Subcategories (SubcategoryName, CategoryID, IsActive) VALUES ('Soft Drinks', @BevCatID, 1);
    PRINT '✓ Created Soft Drinks subcategory'
END

IF NOT EXISTS (SELECT * FROM Subcategories WHERE SubcategoryName = 'Loaves')
BEGIN
    INSERT INTO Subcategories (SubcategoryName, CategoryID, IsActive) VALUES ('Loaves', @BreadCatID, 1);
    PRINT '✓ Created Loaves subcategory'
END

IF NOT EXISTS (SELECT * FROM Subcategories WHERE SubcategoryName = 'Chips')
BEGIN
    INSERT INTO Subcategories (SubcategoryName, CategoryID, IsActive) VALUES ('Chips', @SnackCatID, 1);
    PRINT '✓ Created Chips subcategory'
END

PRINT 'Subcategories created ✓'
PRINT ''
GO

-- =============================================
-- STEP 4: Create 5 External Products
-- =============================================
PRINT '=== STEP 4: Creating 5 External Products ==='

DECLARE @BevCatID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Beverages');
DECLARE @BreadCatID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Bread');
DECLARE @SnackCatID INT = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Snacks');
DECLARE @SoftDrinkSubID INT = (SELECT SubcategoryID FROM Subcategories WHERE SubcategoryName = 'Soft Drinks');
DECLARE @LoavesSubID INT = (SELECT SubcategoryID FROM Subcategories WHERE SubcategoryName = 'Loaves');
DECLARE @ChipsSubID INT = (SELECT SubcategoryID FROM Subcategories WHERE SubcategoryName = 'Chips');

-- Product 1: Coca-Cola 330ml
IF NOT EXISTS (SELECT * FROM Products WHERE ProductCode = 'BEV-COKE-330')
BEGIN
    INSERT INTO Products (ProductCode, ProductName, SKU, ItemType, CategoryID, SubcategoryID, IsActive, LastPaidPrice, AverageCost)
    VALUES ('BEV-COKE-330', 'Coca-Cola 330ml Can', '5449000000996', 'External', @BevCatID, @SoftDrinkSubID, 1, 8.50, 9.00);
    PRINT '✓ Created Coca-Cola 330ml Can'
END

-- Product 2: Coca-Cola 500ml
IF NOT EXISTS (SELECT * FROM Products WHERE ProductCode = 'BEV-COKE-500')
BEGIN
    INSERT INTO Products (ProductCode, ProductName, SKU, ItemType, CategoryID, SubcategoryID, IsActive, LastPaidPrice, AverageCost)
    VALUES ('BEV-COKE-500', 'Coca-Cola 500ml PET', '5449000054227', 'External', @BevCatID, @SoftDrinkSubID, 1, 13.00, 13.50);
    PRINT '✓ Created Coca-Cola 500ml PET'
END

-- Product 3: White Bread
IF NOT EXISTS (SELECT * FROM Products WHERE ProductCode = 'BRD-WHT-001')
BEGIN
    INSERT INTO Products (ProductCode, ProductName, SKU, ItemType, CategoryID, SubcategoryID, IsActive, LastPaidPrice, AverageCost)
    VALUES ('BRD-WHT-001', 'White Bread Loaf 700g', '7001234567890', 'External', @BreadCatID, @LoavesSubID, 1, 18.50, 19.00);
    PRINT '✓ Created White Bread Loaf 700g'
END

-- Product 4: Brown Bread
IF NOT EXISTS (SELECT * FROM Products WHERE ProductCode = 'BRD-BRN-001')
BEGIN
    INSERT INTO Products (ProductCode, ProductName, SKU, ItemType, CategoryID, SubcategoryID, IsActive, LastPaidPrice, AverageCost)
    VALUES ('BRD-BRN-001', 'Brown Bread Loaf 700g', '7001234567891', 'External', @BreadCatID, @LoavesSubID, 1, 20.00, 21.00);
    PRINT '✓ Created Brown Bread Loaf 700g'
END

-- Product 5: Lays Chips
IF NOT EXISTS (SELECT * FROM Products WHERE ProductCode = 'SNK-CHIPS-001')
BEGIN
    INSERT INTO Products (ProductCode, ProductName, SKU, ItemType, CategoryID, SubcategoryID, IsActive, LastPaidPrice, AverageCost)
    VALUES ('SNK-CHIPS-001', 'Lays Chips 120g', '6001087340014', 'External', @SnackCatID, @ChipsSubID, 1, 10.50, 11.00);
    PRINT '✓ Created Lays Chips 120g'
END

PRINT '5 External Products created ✓'
PRINT ''
GO

-- =============================================
-- STEP 5: Create Retail_Variant for Each Product
-- =============================================
PRINT '=== STEP 5: Creating Retail_Variant Records ==='

INSERT INTO Retail_Variant (ProductID, Barcode, IsActive, CreatedAt, UpdatedAt)
SELECT 
    p.ProductID,
    p.SKU,
    1,
    SYSUTCDATETIME(),
    SYSUTCDATETIME()
FROM Products p
WHERE p.ItemType = 'External'
AND p.ProductCode IN ('BEV-COKE-330', 'BEV-COKE-500', 'BRD-WHT-001', 'BRD-BRN-001', 'SNK-CHIPS-001')
AND NOT EXISTS (SELECT 1 FROM Retail_Variant rv WHERE rv.ProductID = p.ProductID);

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Retail_Variant records created ✓'
PRINT ''
GO

-- =============================================
-- STEP 6: Create Retail_Price for Each Product (All Branches)
-- =============================================
PRINT '=== STEP 6: Creating Retail_Price Records ==='

-- Get all branches
DECLARE @BranchID INT;
DECLARE branch_cursor CURSOR FOR SELECT BranchID FROM Branches;

OPEN branch_cursor;
FETCH NEXT FROM branch_cursor INTO @BranchID;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Coca-Cola 330ml - R12.00
    IF NOT EXISTS (SELECT * FROM Retail_Price WHERE ProductID = (SELECT ProductID FROM Products WHERE ProductCode = 'BEV-COKE-330') AND BranchID = @BranchID AND EffectiveTo IS NULL)
    BEGIN
        INSERT INTO Retail_Price (ProductID, BranchID, SellingPrice, Currency, EffectiveFrom, CreatedAt)
        VALUES ((SELECT ProductID FROM Products WHERE ProductCode = 'BEV-COKE-330'), @BranchID, 12.00, 'ZAR', CAST(GETDATE() AS DATE), SYSUTCDATETIME());
    END
    
    -- Coca-Cola 500ml - R18.00
    IF NOT EXISTS (SELECT * FROM Retail_Price WHERE ProductID = (SELECT ProductID FROM Products WHERE ProductCode = 'BEV-COKE-500') AND BranchID = @BranchID AND EffectiveTo IS NULL)
    BEGIN
        INSERT INTO Retail_Price (ProductID, BranchID, SellingPrice, Currency, EffectiveFrom, CreatedAt)
        VALUES ((SELECT ProductID FROM Products WHERE ProductCode = 'BEV-COKE-500'), @BranchID, 18.00, 'ZAR', CAST(GETDATE() AS DATE), SYSUTCDATETIME());
    END
    
    -- White Bread - R25.00
    IF NOT EXISTS (SELECT * FROM Retail_Price WHERE ProductID = (SELECT ProductID FROM Products WHERE ProductCode = 'BRD-WHT-001') AND BranchID = @BranchID AND EffectiveTo IS NULL)
    BEGIN
        INSERT INTO Retail_Price (ProductID, BranchID, SellingPrice, Currency, EffectiveFrom, CreatedAt)
        VALUES ((SELECT ProductID FROM Products WHERE ProductCode = 'BRD-WHT-001'), @BranchID, 25.00, 'ZAR', CAST(GETDATE() AS DATE), SYSUTCDATETIME());
    END
    
    -- Brown Bread - R28.00
    IF NOT EXISTS (SELECT * FROM Retail_Price WHERE ProductID = (SELECT ProductID FROM Products WHERE ProductCode = 'BRD-BRN-001') AND BranchID = @BranchID AND EffectiveTo IS NULL)
    BEGIN
        INSERT INTO Retail_Price (ProductID, BranchID, SellingPrice, Currency, EffectiveFrom, CreatedAt)
        VALUES ((SELECT ProductID FROM Products WHERE ProductCode = 'BRD-BRN-001'), @BranchID, 28.00, 'ZAR', CAST(GETDATE() AS DATE), SYSUTCDATETIME());
    END
    
    -- Lays Chips - R15.00
    IF NOT EXISTS (SELECT * FROM Retail_Price WHERE ProductID = (SELECT ProductID FROM Products WHERE ProductCode = 'SNK-CHIPS-001') AND BranchID = @BranchID AND EffectiveTo IS NULL)
    BEGIN
        INSERT INTO Retail_Price (ProductID, BranchID, SellingPrice, Currency, EffectiveFrom, CreatedAt)
        VALUES ((SELECT ProductID FROM Products WHERE ProductCode = 'SNK-CHIPS-001'), @BranchID, 15.00, 'ZAR', CAST(GETDATE() AS DATE), SYSUTCDATETIME());
    END
    
    FETCH NEXT FROM branch_cursor INTO @BranchID;
END

CLOSE branch_cursor;
DEALLOCATE branch_cursor;

PRINT 'Retail_Price records created for all branches ✓'
PRINT ''
GO

-- =============================================
-- STEP 7: Add Initial Stock to Branch 1
-- =============================================
PRINT '=== STEP 7: Adding Initial Stock to Branch 1 ==='

DECLARE @Branch1ID INT = (SELECT TOP 1 BranchID FROM Branches ORDER BY BranchID);

-- Add stock for each product
INSERT INTO Retail_Stock (VariantID, BranchID, QtyOnHand, AverageCost, UpdatedAt)
SELECT 
    rv.VariantID,
    @Branch1ID,
    100.00,  -- Initial stock: 100 units
    p.AverageCost,
    SYSUTCDATETIME()
FROM Retail_Variant rv
INNER JOIN Products p ON rv.ProductID = p.ProductID
WHERE p.ProductCode IN ('BEV-COKE-330', 'BEV-COKE-500', 'BRD-WHT-001', 'BRD-BRN-001', 'SNK-CHIPS-001')
AND NOT EXISTS (SELECT 1 FROM Retail_Stock rs WHERE rs.VariantID = rv.VariantID AND rs.BranchID = @Branch1ID);

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' stock records created for Branch 1 ✓'
PRINT ''
GO

-- =============================================
-- STEP 8: Verification Report
-- =============================================
PRINT '=== STEP 8: Verification Report ==='
PRINT ''

PRINT '5 EXTERNAL PRODUCTS CREATED:'
SELECT 
    p.ProductCode,
    p.ProductName,
    p.SKU AS Barcode,
    p.ItemType,
    c.CategoryName,
    sc.SubcategoryName,
    p.LastPaidPrice AS CostPrice,
    ISNULL(rp.SellingPrice, 0) AS SellingPrice,
    ISNULL(rs.QtyOnHand, 0) AS StockOnHand
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
LEFT JOIN Subcategories sc ON p.SubcategoryID = sc.SubcategoryID
LEFT JOIN Retail_Variant rv ON p.ProductID = rv.ProductID
LEFT JOIN Retail_Price rp ON p.ProductID = rp.ProductID AND rp.EffectiveTo IS NULL
LEFT JOIN Retail_Stock rs ON rv.VariantID = rs.VariantID
WHERE p.ProductCode IN ('BEV-COKE-330', 'BEV-COKE-500', 'BRD-WHT-001', 'BRD-BRN-001', 'SNK-CHIPS-001')
ORDER BY p.ProductCode;

PRINT ''
PRINT 'PRODUCTS READY FOR POS:'
SELECT 
    COUNT(DISTINCT p.ProductID) AS TotalProducts,
    COUNT(DISTINCT rv.VariantID) AS TotalVariants,
    COUNT(DISTINCT rp.ProductID) AS ProductsWithPrices,
    COUNT(DISTINCT rs.VariantID) AS ProductsWithStock
FROM Products p
LEFT JOIN Retail_Variant rv ON p.ProductID = rv.ProductID
LEFT JOIN Retail_Price rp ON p.ProductID = rp.ProductID AND rp.EffectiveTo IS NULL
LEFT JOIN Retail_Stock rs ON rv.VariantID = rs.VariantID
WHERE p.ProductCode IN ('BEV-COKE-330', 'BEV-COKE-500', 'BRD-WHT-001', 'BRD-BRN-001', 'SNK-CHIPS-001');

PRINT ''
PRINT '========================================='
PRINT 'TEST DATA CREATION COMPLETE!'
PRINT '========================================='
PRINT ''
PRINT '✓ 3 Suppliers created'
PRINT '✓ 3 Categories created'
PRINT '✓ 3 Subcategories created'
PRINT '✓ 5 External Products created'
PRINT '✓ 5 Retail_Variant records created'
PRINT '✓ Prices set for all branches'
PRINT '✓ Initial stock added to Branch 1'
PRINT ''
PRINT 'PRODUCTS ARE NOW ON THE SHELF!'
PRINT 'Ready for POS development.'
PRINT ''
GO
