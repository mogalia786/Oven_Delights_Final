-- FINAL FIX FOR ADD PRODUCT - Simplified approach
-- This creates products per branch matching how POS expects them

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
        
        -- Insert products for each branch
        DECLARE @CurrentBranchID INT
        DECLARE branch_cursor CURSOR FOR SELECT BranchID FROM @BranchTable
        
        OPEN branch_cursor
        FETCH NEXT FROM branch_cursor INTO @CurrentBranchID
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Insert product for this branch
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
            
            -- Get the ProductID that was just inserted
            DECLARE @InsertedProductID INT
            SET @InsertedProductID = SCOPE_IDENTITY()
            
            -- Store first ProductID as output
            IF @NewProductID IS NULL OR @NewProductID = 0
                SET @NewProductID = @InsertedProductID
            
            -- Insert pricing for this branch
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
            
            FETCH NEXT FROM branch_cursor INTO @CurrentBranchID
        END
        
        CLOSE branch_cursor
        DEALLOCATE branch_cursor
        
        COMMIT TRANSACTION
        
        SELECT 'SUCCESS' AS Result,
               'Product saved to all branches successfully' AS Message,
               @NewProductID AS ProductID
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        CLOSE branch_cursor
        DEALLOCATE branch_cursor
        
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
    @ProductName = 'TEST FINAL FIX',
    @ProductCode = 'TESTFINAL',
    @SKU = 'SKU-FINAL-001',
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

-- Step 4: Verify
SELECT 
    ProductID,
    Name,
    Category,
    ProductType,
    BranchID,
    CurrentStock,
    IsActive
FROM Demo_Retail_Product
WHERE Name = 'TEST FINAL FIX'
ORDER BY BranchID;

SELECT 
    pr.ProductID,
    pr.BranchID,
    b.BranchName,
    pr.SellingPrice,
    pr.CostPrice
FROM Demo_Retail_Price pr
INNER JOIN Branches b ON pr.BranchID = b.BranchID
INNER JOIN Demo_Retail_Product p ON pr.ProductID = p.ProductID
WHERE p.Name = 'TEST FINAL FIX'
ORDER BY pr.BranchID;

PRINT 'If you see TEST FINAL FIX for all branches, the fix works!'
