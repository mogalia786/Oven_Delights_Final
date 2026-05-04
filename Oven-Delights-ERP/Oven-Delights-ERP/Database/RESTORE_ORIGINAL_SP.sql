-- Restore original SP with fixes for missing required columns
-- Based on original sp_SaveProductToAllBranches.sql

IF OBJECT_ID('sp_SaveProductToAllBranches', 'P') IS NOT NULL
    DROP PROCEDURE sp_SaveProductToAllBranches;
GO

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
        
        -- 1. Insert into Products (Master Table)
        INSERT INTO Products (
            ProductName, ProductCode, SKU, CategoryID, SubcategoryID, 
            ItemType, IsActive, IsVatable, RecipeCreated, ProductImage, CreatedDate
        )
        VALUES (
            @ProductName, @ProductCode, @SKU, @CategoryID, @SubcategoryID,
            @ItemType, @IsActive, @IsVatable, 'No', @ProductImage, GETDATE()
        )
        
        SET @NewProductID = SCOPE_IDENTITY()
        
        -- 2. Get category name for Demo_Retail_Product
        DECLARE @CategoryName NVARCHAR(255)
        SELECT @CategoryName = CategoryName 
        FROM Categories 
        WHERE CategoryID = @CategoryID
        
        -- 3. Determine ProductType based on ItemType
        DECLARE @ProductType NVARCHAR(50)
        SET @ProductType = CASE 
            WHEN LOWER(@ItemType) = 'external' THEN 'External'
            ELSE 'Internal'
        END
        
        -- 4. Insert into Demo_Retail_Product for ALL branches
        -- Added missing required columns: Description, CreatedAt, UpdatedAt, Is_VTable, IsVatable
        INSERT INTO Demo_Retail_Product (
            SKU, Name, Category, CategoryID, SubcategoryID,
            ProductType, BranchID, CurrentStock, IsActive,
            Description, CreatedAt, UpdatedAt, Is_VTable, IsVatable
        )
        SELECT 
            @SKU,
            @ProductName,
            @CategoryName,
            @CategoryID,
            ISNULL(@SubcategoryID, 0),
            @ProductType,
            b.BranchID,
            CONVERT(DECIMAL(18,2), 0),
            @IsActive,
            '',
            GETDATE(),
            GETDATE(),
            0,
            @IsVatable
        FROM Branches b
        WHERE b.IsActive = 1
        
        -- 5. Insert into Demo_Retail_Price for ALL branches
        INSERT INTO Demo_Retail_Price (
            ProductID, BranchID, SellingPrice, CostPrice, EffectiveFrom
        )
        SELECT 
            p.ProductID,
            p.BranchID,
            @SellingPrice,
            @CostPrice,
            GETDATE()
        FROM Demo_Retail_Product p
        WHERE p.Name = @ProductName
          AND p.BranchID IN (SELECT BranchID FROM Branches WHERE IsActive = 1)
        
        COMMIT TRANSACTION
        
        SELECT 'SUCCESS' AS Result, 
               'Product saved to all branches successfully' AS Message,
               @NewProductID AS ProductID
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
            
        SELECT 'ERROR' AS Result, 
               ERROR_MESSAGE() AS Message,
               0 AS ProductID
    END CATCH
END
GO

-- Test
PRINT 'Testing restored original SP...'
GO

DECLARE @TestProductID INT;

EXEC sp_SaveProductToAllBranches
    @ProductName = 'TEST RESTORED ORIGINAL',
    @ProductCode = 'TESTORIGINAL',
    @SKU = 'SKU-ORIGINAL-001',
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

-- Verify Products table
SELECT 'Products' AS TableName, ProductID, ProductName, ProductCode, SKU
FROM Products
WHERE ProductName = 'TEST RESTORED ORIGINAL';

-- Verify Demo_Retail_Product
SELECT 'Demo_Retail_Product' AS TableName, ProductID, Name, BranchID, CurrentStock
FROM Demo_Retail_Product
WHERE Name = 'TEST RESTORED ORIGINAL'
ORDER BY BranchID;

-- Verify Demo_Retail_Price
SELECT 'Demo_Retail_Price' AS TableName, pr.ProductID, pr.BranchID, pr.SellingPrice, pr.CostPrice
FROM Demo_Retail_Price pr
WHERE pr.ProductID IN (SELECT ProductID FROM Demo_Retail_Product WHERE Name = 'TEST RESTORED ORIGINAL')
ORDER BY pr.BranchID;

PRINT 'If you see TEST RESTORED ORIGINAL in Products, Demo_Retail_Product, and Demo_Retail_Price, the fix works!'
PRINT 'Note: Demo_Retail_Variant and Demo_Retail_Stock are NOT created by this SP - they are created elsewhere.'
