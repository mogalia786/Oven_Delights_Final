-- PROPER FIX - Work with the trigger, not against it
-- The trigger updates recipe costs when prices change, so we need to ensure
-- the trigger has all the data it needs when it fires

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
        
        -- Step 1: Check if product already exists
        IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE Name = @ProductName)
        BEGIN
            ROLLBACK TRANSACTION
            SELECT 'ERROR' AS Result,
                   'Product with this name already exists' AS Message,
                   0 AS ProductID
            RETURN
        END
        
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
        
        -- Get active branches
        DECLARE @BranchTable TABLE (BranchID INT)
        INSERT INTO @BranchTable
        SELECT BranchID FROM Branches WHERE IsActive = 1
        
        DECLARE @CurrentBranchID INT
        DECLARE branch_cursor CURSOR FOR SELECT BranchID FROM @BranchTable
        
        OPEN branch_cursor
        FETCH NEXT FROM branch_cursor INTO @CurrentBranchID
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Step 2: Insert Product - with proper default for CurrentStock
            DECLARE @InsertedProductID INT
            
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
                0,  -- Simple integer 0, let SQL handle the conversion
                @IsActive,
                '',
                GETDATE(),
                GETDATE(),
                0,
                @IsVatable
            )
            
            SET @InsertedProductID = SCOPE_IDENTITY()
            
            IF @NewProductID IS NULL OR @NewProductID = 0
                SET @NewProductID = @InsertedProductID
            
            -- Step 3: Insert Price BEFORE Variant and Stock
            -- This ensures the trigger has price data when it fires
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
            
            -- Step 4: Create Variant
            DECLARE @InsertedVariantID INT
            
            INSERT INTO Demo_Retail_Variant (
                ProductID, AttributesJson, IsDefault, IsActive
            )
            VALUES (
                @InsertedProductID,
                'Default',
                1,
                @IsActive
            )
            
            SET @InsertedVariantID = SCOPE_IDENTITY()
            
            -- Step 5: Insert Stock
            INSERT INTO Demo_Retail_Stock (
                VariantID, BranchID, QtyOnHand
            )
            VALUES (
                @InsertedVariantID,
                @CurrentBranchID,
                0
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

-- Test
PRINT 'Testing proper product creation...'
GO

DECLARE @TestProductID INT;

EXEC sp_SaveProductToAllBranches
    @ProductName = 'TEST PROPER FIX',
    @ProductCode = 'TESTPROPER',
    @SKU = 'SKU-PROPER-001',
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
SELECT 'Demo_Retail_Product' AS TableName, ProductID, Name, BranchID, CurrentStock
FROM Demo_Retail_Product
WHERE Name = 'TEST PROPER FIX'
ORDER BY BranchID;

SELECT 'Demo_Retail_Variant' AS TableName, VariantID, ProductID, AttributesJson, IsDefault
FROM Demo_Retail_Variant
WHERE ProductID IN (SELECT ProductID FROM Demo_Retail_Product WHERE Name = 'TEST PROPER FIX')
ORDER BY VariantID;

SELECT 'Demo_Retail_Stock' AS TableName, s.StockID, s.VariantID, s.BranchID, s.QtyOnHand
FROM Demo_Retail_Stock s
INNER JOIN Demo_Retail_Variant v ON s.VariantID = v.VariantID
WHERE v.ProductID IN (SELECT ProductID FROM Demo_Retail_Product WHERE Name = 'TEST PROPER FIX')
ORDER BY s.BranchID;

SELECT 'Demo_Retail_Price' AS TableName, pr.ProductID, pr.BranchID, pr.SellingPrice, pr.CostPrice
FROM Demo_Retail_Price pr
WHERE pr.ProductID IN (SELECT ProductID FROM Demo_Retail_Product WHERE Name = 'TEST PROPER FIX')
ORDER BY pr.BranchID;

PRINT 'If you see TEST PROPER FIX in all 4 tables, the fix is complete!'
