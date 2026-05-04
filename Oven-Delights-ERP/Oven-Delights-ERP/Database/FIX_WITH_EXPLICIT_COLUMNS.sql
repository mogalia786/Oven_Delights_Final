-- Fix using explicit column list in SELECT instead of relying on implicit conversion
-- This ensures proper data types are used

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
        
        -- 2. Get category name
        DECLARE @CategoryName NVARCHAR(255)
        SELECT @CategoryName = CategoryName 
        FROM Categories 
        WHERE CategoryID = @CategoryID
        
        -- 3. Determine ProductType
        DECLARE @ProductType NVARCHAR(50)
        SET @ProductType = CASE 
            WHEN LOWER(@ItemType) = 'external' THEN 'External'
            ELSE 'Internal'
        END
        
        -- 4. Insert into Demo_Retail_Product with explicit CAST for CurrentStock
        INSERT INTO Demo_Retail_Product (
            SKU, Name, Category, CategoryID, SubcategoryID,
            ProductType, BranchID, CurrentStock, IsActive,
            Description, CreatedAt, UpdatedAt, Is_VTable, IsVatable
        )
        SELECT 
            CAST(@SKU AS NVARCHAR(50)),
            CAST(@ProductName AS NVARCHAR(255)),
            CAST(@CategoryName AS NVARCHAR(255)),
            CAST(@CategoryID AS INT),
            CAST(ISNULL(@SubcategoryID, 0) AS INT),
            CAST(@ProductType AS NVARCHAR(50)),
            CAST(b.BranchID AS INT),
            CAST(0 AS DECIMAL(18,2)),
            CAST(@IsActive AS BIT),
            CAST('' AS NVARCHAR(MAX)),
            CAST(GETDATE() AS DATETIME),
            CAST(GETDATE() AS DATETIME),
            CAST(0 AS BIT),
            CAST(@IsVatable AS BIT)
        FROM Branches b
        WHERE b.IsActive = 1
        
        -- 5. Insert into Demo_Retail_Price
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
PRINT 'Testing with explicit CAST...'
GO

DECLARE @TestProductID INT;

EXEC sp_SaveProductToAllBranches
    @ProductName = 'TEST EXPLICIT CAST',
    @ProductCode = 'TESTCAST',
    @SKU = 'SKU-CAST-001',
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

-- Verify
SELECT 'Products' AS TableName, ProductID, ProductName, ProductCode
FROM Products
WHERE ProductName = 'TEST EXPLICIT CAST';

SELECT 'Demo_Retail_Product' AS TableName, ProductID, Name, BranchID, CurrentStock
FROM Demo_Retail_Product
WHERE Name = 'TEST EXPLICIT CAST'
ORDER BY BranchID;

SELECT 'Demo_Retail_Price' AS TableName, pr.ProductID, pr.BranchID, pr.SellingPrice, pr.CostPrice
FROM Demo_Retail_Price pr
WHERE pr.ProductID IN (SELECT ProductID FROM Demo_Retail_Product WHERE Name = 'TEST EXPLICIT CAST')
ORDER BY pr.BranchID;

PRINT 'If you see TEST EXPLICIT CAST in all 3 tables, the fix works!'
