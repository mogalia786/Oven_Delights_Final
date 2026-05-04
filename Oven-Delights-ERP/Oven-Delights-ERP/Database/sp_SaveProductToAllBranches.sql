-- =============================================
-- Stored Procedure: Save Product to All Branches
-- Saves new product to Products table AND Demo_Retail_Product for all branches
-- =============================================

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_SaveProductToAllBranches')
    DROP PROCEDURE sp_SaveProductToAllBranches
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
        -- Note: ProductID is IDENTITY, don't insert it explicitly
        INSERT INTO Demo_Retail_Product (
            SKU, Name, Category, CategoryID, SubcategoryID,
            ProductType, BranchID, CurrentStock, IsActive
        )
        SELECT 
            @SKU,
            @ProductName,
            @CategoryName,
            @CategoryID,
            @SubcategoryID,
            @ProductType,
            b.BranchID,
            0, -- Initial stock = 0
            @IsActive
        FROM Branches b
        WHERE b.IsActive = 1
        
        -- 5. Insert into Demo_Retail_Price for ALL branches
        -- Use the auto-generated ProductIDs from Demo_Retail_Product
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
        
        -- 6. Note: Demo_Retail_Stock uses VariantID, not ProductID
        -- Stock records are created when variants are created
        -- Skip stock initialization here
        
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

PRINT 'sp_SaveProductToAllBranches procedure created successfully'
GO

-- =============================================
-- Stored Procedure: Update Product Cost Price All Branches
-- Updates cost price for a product across all branches
-- =============================================

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_UpdateProductCostAllBranches')
    DROP PROCEDURE sp_UpdateProductCostAllBranches
GO

CREATE PROCEDURE sp_UpdateProductCostAllBranches
    @ProductID INT,
    @NewCostPrice DECIMAL(18,2),
    @UpdatedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Update Demo_Retail_Price with new cost
        UPDATE Demo_Retail_Price
        SET CostPrice = @NewCostPrice
        WHERE ProductID = @ProductID
        
        COMMIT TRANSACTION
        
        SELECT 'SUCCESS' AS Result, 
               'Cost price updated for all branches' AS Message,
               @@ROWCOUNT AS BranchesUpdated
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
            
        SELECT 'ERROR' AS Result, 
               ERROR_MESSAGE() AS Message,
               0 AS BranchesUpdated
    END CATCH
END
GO

PRINT 'sp_UpdateProductCostAllBranches procedure created successfully'
GO
