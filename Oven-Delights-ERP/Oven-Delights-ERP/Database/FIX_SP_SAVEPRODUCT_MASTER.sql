-- Fix sp_SaveProductToAllBranches - Master Product + Variant Pricing Pattern
-- This creates ONE master product record and branch-specific pricing

-- Step 1: Drop existing procedure
IF OBJECT_ID('sp_SaveProductToAllBranches', 'P') IS NOT NULL
    DROP PROCEDURE sp_SaveProductToAllBranches;
GO

-- Step 2: Create new procedure with Master Product pattern
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
        
        -- Get category name for Demo_Retail_Product
        DECLARE @CategoryName NVARCHAR(255)
        SELECT @CategoryName = CategoryName
        FROM Categories
        WHERE CategoryID = @CategoryID
        
        -- Determine ProductType based on ItemType
        DECLARE @ProductType NVARCHAR(50)
        SET @ProductType = CASE
            WHEN LOWER(@ItemType) = 'external' THEN 'External'
            ELSE 'Internal'
        END
        
        -- Insert ONE master product record (BranchID = NULL for master products)
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
            NULL,  -- Master product has NULL BranchID
            0,
            @IsActive,
            '',
            GETDATE(),
            GETDATE(),
            0,
            @IsVatable
        )
        
        SET @NewProductID = SCOPE_IDENTITY()
        
        -- Insert pricing into Demo_Retail_Price for ALL active branches
        INSERT INTO Demo_Retail_Price (
            ProductID, BranchID, SellingPrice, CostPrice, EffectiveFrom
        )
        SELECT
            @NewProductID,
            b.BranchID,
            @SellingPrice,
            @CostPrice,
            GETDATE()
        FROM Branches b
        WHERE b.IsActive = 1
        
        COMMIT TRANSACTION
        
        SELECT 'SUCCESS' AS Result,
               'Product saved successfully with pricing for all branches' AS Message,
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

-- Step 3: Test the procedure
DECLARE @TestProductID INT;

EXEC sp_SaveProductToAllBranches
    @ProductName = 'TEST MASTER PRODUCT',
    @ProductCode = 'TESTM001',
    @SKU = 'SKU-TESTM-001',
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

-- Step 4: Verify master product was created
SELECT 
    ProductID,
    Name,
    Category,
    CategoryID,
    ProductType,
    BranchID,
    IsActive,
    CreatedAt
FROM Demo_Retail_Product
WHERE Name = 'TEST MASTER PRODUCT';

-- Step 5: Verify pricing records were created for all branches
SELECT 
    pr.ProductID,
    pr.BranchID,
    b.BranchName,
    pr.SellingPrice,
    pr.CostPrice,
    pr.EffectiveFrom
FROM Demo_Retail_Price pr
INNER JOIN Branches b ON pr.BranchID = b.BranchID
WHERE pr.ProductID = @TestProductID
ORDER BY pr.BranchID;
