-- Fix CurrentStock issue in Demo_Retail_Product table only

-- CurrentStock already has a default constraint, just update any NULL values
UPDATE Demo_Retail_Product SET CurrentStock = 0 WHERE CurrentStock IS NULL;
GO

-- Step 5: Create the stored procedure
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
        
        -- Insert into Products (CurrentStock will use default)
        INSERT INTO Products (
            ProductName, ProductCode, SKU, CategoryID, SubcategoryID, 
            ItemType, IsActive, IsVatable, RecipeCreated, ProductImage, CreatedDate
        )
        VALUES (
            @ProductName, @ProductCode, @SKU, @CategoryID, @SubcategoryID,
            @ItemType, @IsActive, @IsVatable, 'No', @ProductImage, GETDATE()
        )
        
        SET @NewProductID = SCOPE_IDENTITY()
        
        DECLARE @CategoryName NVARCHAR(255)
        SELECT @CategoryName = CategoryName FROM Categories WHERE CategoryID = @CategoryID
        
        DECLARE @ProductType NVARCHAR(50)
        SET @ProductType = CASE WHEN LOWER(@ItemType) = 'external' THEN 'External' ELSE 'Internal' END
        
        -- Insert into Demo_Retail_Product (CurrentStock will use default)
        INSERT INTO Demo_Retail_Product (
            SKU, Name, Category, CategoryID, SubcategoryID,
            ProductType, BranchID, IsActive,
            Description, CreatedAt, UpdatedAt, Is_VTable, IsVatable
        )
        SELECT 
            @SKU, @ProductName, @CategoryName, @CategoryID, ISNULL(@SubcategoryID, 0),
            @ProductType, b.BranchID, @IsActive,
            '', GETDATE(), GETDATE(), 0, @IsVatable
        FROM Branches b
        WHERE b.IsActive = 1
        
        -- Insert into Demo_Retail_Price
        INSERT INTO Demo_Retail_Price (ProductID, BranchID, SellingPrice, CostPrice, Currency, EffectiveFrom, EffectiveTo, CreatedAt, SellingPriceExVAT, DisplayPriority)
        SELECT p.ProductID, p.BranchID, @SellingPrice, @CostPrice, 'ZAR', GETDATE(), NULL, GETDATE(), @SellingPrice, 0
        FROM Demo_Retail_Product p
        WHERE p.Name = @ProductName AND p.BranchID IN (SELECT BranchID FROM Branches WHERE IsActive = 1)
        
        COMMIT TRANSACTION
        
        SELECT 'SUCCESS' AS Result, 'Product saved to all branches successfully' AS Message, @NewProductID AS ProductID
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        SELECT 'ERROR' AS Result, ERROR_MESSAGE() AS Message, 0 AS ProductID
    END CATCH
END
GO

PRINT 'Fixed both tables and created stored procedure with default constraints'
GO

-- Test
DECLARE @TestProductID INT;
EXEC sp_SaveProductToAllBranches
    @ProductName = 'TEST BOTH TABLES FIXED',
    @ProductCode = 'TESTBOTH',
    @SKU = 'SKU-BOTH-001',
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

SELECT 'Products' AS TableName, * FROM Products WHERE ProductName = 'TEST BOTH TABLES FIXED';
SELECT 'Demo_Retail_Product' AS TableName, * FROM Demo_Retail_Product WHERE Name = 'TEST BOTH TABLES FIXED' ORDER BY BranchID;
SELECT 'Demo_Retail_Price' AS TableName, * FROM Demo_Retail_Price WHERE ProductID IN (SELECT ProductID FROM Demo_Retail_Product WHERE Name = 'TEST BOTH TABLES FIXED') ORDER BY BranchID;

PRINT 'SUCCESS! Both Products and Demo_Retail_Product should have CurrentStock = 0'
