-- Fix sp_SaveProductToAllBranches to remove Products table insert
-- The stored procedure already correctly inserts to Demo_Retail_Product and Demo_Retail_Price
-- We just need to remove the legacy Products table insert on line 24

-- Drop existing procedure
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
        
        -- REMOVED: INSERT INTO Products (legacy table)
        -- The form was inserting here but products weren't appearing in POS
        
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
            0, -- Initial stock = 0
            @IsActive,
            '', -- Empty description for now
            GETDATE(),
            GETDATE(),
            0, -- Is_VTable = false
            @IsVatable
        FROM Branches b
        WHERE b.IsActive = 1
        
        -- Get the first ProductID created (they share same Code/SKU across branches)
        SET @NewProductID = SCOPE_IDENTITY()
        
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
        
        -- 6. Note: Demo_Retail_Stock uses VariantID, not ProductID
        -- Stock records are created when variants are created or when stock is received
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
