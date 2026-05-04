-- COMPLETE FIX FOR ADD PRODUCT
-- Creates product in all 4 required tables for each branch:
-- 1. Demo_Retail_Product
-- 2. Demo_Retail_Price
-- 3. Demo_Retail_Stock
-- 4. Demo_Retail_Variant

-- Step 1: Drop existing procedure
IF OBJECT_ID('sp_SaveProductToAllBranches', 'P') IS NOT NULL
    DROP PROCEDURE sp_SaveProductToAllBranches;
GO

-- Step 2: Create complete procedure
CREATE PROCEDURE sp_SaveProductToAllBranches
    @ProductName NVARCHAR(255),
    @ProductCode NVARCHAR(50),
    @SKU NVARCHAR(50) = NULL,
    @CategoryID INT,
    @SubcategoryID INT = NULL,
    @ItemType NVARCHAR(50),
    @IsActive BIT,
    @IsVatable BIT = 1,
    @ProductImage VARBINARY(MAX) = NULL,
    @CostPrice DECIMAL(18,2) = 0,
    @SellingPrice DECIMAL(18,2) = 0,
    @CreatedBy NVARCHAR(100),
    @NewProductID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Get category name
        DECLARE @CategoryName NVARCHAR(255)
        SELECT @CategoryName = CategoryName
        FROM Categories
        WHERE CategoryID = @CategoryID
        
        IF @CategoryName IS NULL
            SET @CategoryName = 'Uncategorized'
        
        -- Determine ProductType
        DECLARE @ProductType NVARCHAR(50)
        SET @ProductType = CASE
            WHEN LOWER(@ItemType) = 'external' THEN 'External'
            ELSE 'Internal'
        END
        
        -- Get list of active branches
        DECLARE @BranchTable TABLE (BranchID INT)
        INSERT INTO @BranchTable
        SELECT BranchID FROM Branches WHERE IsActive = 1
        
        -- Loop through each branch
        DECLARE @CurrentBranchID INT
        DECLARE branch_cursor CURSOR FOR SELECT BranchID FROM @BranchTable
        
        OPEN branch_cursor
        FETCH NEXT FROM branch_cursor INTO @CurrentBranchID
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- 1. Insert into Demo_Retail_Product for this branch
            INSERT INTO Demo_Retail_Product (
                SKU, Name, Category, CategoryID, SubcategoryID,
                ProductType, BranchID, CurrentStock, IsActive,
                Description, CreatedAt, UpdatedAt, Is_VTable, IsVatable
            )
            VALUES (
                @SKU,
                @ProductName,
                @CategoryName,
                @CategoryID,
                ISNULL(@SubcategoryID, 0),
                @ProductType,
                @CurrentBranchID,
                0.00,
                @IsActive,
                '',
                GETDATE(),
                GETDATE(),
                0,
                @IsVatable
            )
            
            DECLARE @InsertedProductID INT
            SET @InsertedProductID = SCOPE_IDENTITY()
            
            -- Store first ProductID as output
            IF @NewProductID IS NULL OR @NewProductID = 0
                SET @NewProductID = @InsertedProductID
            
            -- 2. Insert into Demo_Retail_Price for this branch
            INSERT INTO Demo_Retail_Price (
                ProductID, BranchID, SellingPrice, CostPrice, EffectiveFrom
            )
            VALUES (
                @InsertedProductID,
                @CurrentBranchID,
                @SellingPrice,
                @CostPrice,
                GETDATE()
            )
            
            -- 3. Insert into Demo_Retail_Stock for this branch
            INSERT INTO Demo_Retail_Stock (
                ProductID, BranchID, QtyOnHand, ReorderLevel, ReorderQty
            )
            VALUES (
                @InsertedProductID,
                @CurrentBranchID,
                0.00,
                0.00,
                0.00
            )
            
            -- 4. Insert into Demo_Retail_Variant for this branch
            -- Variant represents the default variant of the product
            INSERT INTO Demo_Retail_Variant (
                ProductID, BranchID, VariantName, SKU, IsDefault, IsActive
            )
            VALUES (
                @InsertedProductID,
                @CurrentBranchID,
                'Default',
                @SKU,
                1,
                @IsActive
            )
            
            FETCH NEXT FROM branch_cursor INTO @CurrentBranchID
        END
        
        CLOSE branch_cursor
        DEALLOCATE branch_cursor
        
        COMMIT TRANSACTION
        
        SELECT 'SUCCESS' AS Result,
               'Product saved to all branches with pricing, stock, and variant records' AS Message,
               @NewProductID AS ProductID
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        IF CURSOR_STATUS('local', 'branch_cursor') >= 0
        BEGIN
            CLOSE branch_cursor
            DEALLOCATE branch_cursor
        END
        
        SELECT 'ERROR' AS Result,
               ERROR_MESSAGE() AS Message,
               0 AS ProductID
    END CATCH
END
GO

-- Step 3: Test the procedure
PRINT 'Testing complete product creation...'
GO

DECLARE @TestProductID INT;

EXEC sp_SaveProductToAllBranches
    @ProductName = 'TEST COMPLETE PRODUCT',
    @ProductCode = 'TESTCOMPLETE',
    @SKU = 'SKU-COMPLETE-001',
    @CategoryID = 22,
    @SubcategoryID = 18,
    @ItemType = 'internal',
    @IsActive = 1,
    @IsVatable = 1,
    @ProductImage = NULL,
    @CostPrice = 50,
    @SellingPrice = 100,
    @CreatedBy = 'System',
    @NewProductID = @TestProductID OUTPUT;

-- Verify Demo_Retail_Product
PRINT 'Demo_Retail_Product records:'
SELECT ProductID, Name, Category, ProductType, BranchID, CurrentStock, IsActive
FROM Demo_Retail_Product
WHERE Name = 'TEST COMPLETE PRODUCT'
ORDER BY BranchID;

-- Verify Demo_Retail_Price
PRINT 'Demo_Retail_Price records:'
SELECT pr.ProductID, pr.BranchID, b.BranchName, pr.SellingPrice, pr.CostPrice
FROM Demo_Retail_Price pr
INNER JOIN Branches b ON pr.BranchID = b.BranchID
INNER JOIN Demo_Retail_Product p ON pr.ProductID = p.ProductID
WHERE p.Name = 'TEST COMPLETE PRODUCT'
ORDER BY pr.BranchID;

-- Verify Demo_Retail_Stock
PRINT 'Demo_Retail_Stock records:'
SELECT s.ProductID, s.BranchID, b.BranchName, s.QtyOnHand, s.ReorderLevel
FROM Demo_Retail_Stock s
INNER JOIN Branches b ON s.BranchID = b.BranchID
INNER JOIN Demo_Retail_Product p ON s.ProductID = p.ProductID
WHERE p.Name = 'TEST COMPLETE PRODUCT'
ORDER BY s.BranchID;

-- Verify Demo_Retail_Variant
PRINT 'Demo_Retail_Variant records:'
SELECT v.VariantID, v.ProductID, v.BranchID, b.BranchName, v.VariantName, v.SKU, v.IsDefault, v.IsActive
FROM Demo_Retail_Variant v
INNER JOIN Branches b ON v.BranchID = b.BranchID
INNER JOIN Demo_Retail_Product p ON v.ProductID = p.ProductID
WHERE p.Name = 'TEST COMPLETE PRODUCT'
ORDER BY v.BranchID;

PRINT ''
PRINT 'SUCCESS! If you see TEST COMPLETE PRODUCT in all 4 tables for each branch, the fix is complete!'
PRINT 'You can now rebuild the ERP and test adding a real product.'
