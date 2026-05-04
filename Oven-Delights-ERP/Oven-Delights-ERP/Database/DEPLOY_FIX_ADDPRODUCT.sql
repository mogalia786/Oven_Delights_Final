-- DEPLOY FIX FOR ADD PRODUCT FEATURE
-- Run this entire script in Azure SQL Query Editor

-- Step 1: Drop existing procedure
IF OBJECT_ID('sp_SaveProductToAllBranches', 'P') IS NOT NULL
    DROP PROCEDURE sp_SaveProductToAllBranches;
GO

-- Step 2: Create fixed procedure
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
        
        -- Insert into Demo_Retail_Product for ALL branches with ALL required columns
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
            CAST(0 AS DECIMAL(18,2)),
            @IsActive,
            '',
            GETDATE(),
            GETDATE(),
            0,
            @IsVatable
        FROM Branches b
        WHERE b.IsActive = 1
        
        SET @NewProductID = SCOPE_IDENTITY()
        
        -- Insert into Demo_Retail_Price for ALL branches
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

-- Step 3: Test the procedure
PRINT 'Testing stored procedure...'
GO

DECLARE @TestProductID INT;

EXEC sp_SaveProductToAllBranches
    @ProductName = 'TEST PRODUCT - DELETE ME',
    @ProductCode = 'TEST999',
    @SKU = '999999999999',
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

-- Step 4: Verify products were created for all branches
SELECT 
    ProductID,
    Name,
    Category,
    ProductType,
    BranchID,
    IsActive,
    CreatedAt
FROM Demo_Retail_Product
WHERE Name = 'TEST PRODUCT - DELETE ME'
ORDER BY BranchID;

-- Step 5: Verify pricing was created for all branches
SELECT 
    pr.ProductID,
    pr.BranchID,
    b.BranchName,
    pr.SellingPrice,
    pr.CostPrice,
    pr.EffectiveFrom
FROM Demo_Retail_Price pr
INNER JOIN Branches b ON pr.BranchID = b.BranchID
INNER JOIN Demo_Retail_Product p ON pr.ProductID = p.ProductID
WHERE p.Name = 'TEST PRODUCT - DELETE ME'
ORDER BY pr.BranchID;

PRINT 'Deployment complete. Check results above.'
PRINT 'If test product appears for all branches with pricing, the fix is working.'
PRINT 'You can now delete the test product or test adding a real product through the ERP form.'
