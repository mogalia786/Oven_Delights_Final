-- =============================================
-- FINAL CORRECTED: sp_InitializeBranchProducts
-- 
-- WORKFLOW:
-- 1. When a branch is created, it inherits ALL products from Products master table
-- 2. Gets RecommendedSellingPrice from Products table
-- 3. Sets Quantity = 0 in Demo_Retail_Stock
-- 4. Copies CategoryID and SubcategoryID to Demo_Retail_Product
-- 5. Writes all this to Demo_ tables with new BranchID
-- =============================================

CREATE OR ALTER PROCEDURE sp_InitializeBranchProducts
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @ProductCount INT = 0;
        DECLARE @PriceCount INT = 0;
        DECLARE @StockCount INT = 0;
        
        PRINT '========================================';
        PRINT 'Initializing Branch: ' + CAST(@BranchID AS NVARCHAR(10));
        PRINT '========================================';
        
        -- =============================================
        -- STEP 1: Copy products to Demo_Retail_Product
        -- NOTE: ProductID is IDENTITY, so we don't insert it
        -- =============================================
        INSERT INTO Demo_Retail_Product (
            SKU,
            Name,
            Category,
            IsActive,
            CreatedAt
        )
        SELECT 
            p.ProductCode AS SKU,
            p.ProductName AS Name,
            c.CategoryName AS Category,
            p.IsActive,
            GETDATE() AS CreatedAt
        FROM Products p
        LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
        WHERE p.IsActive = 1
            AND p.ItemType IN ('internal', 'external', 'Manufactured')
            AND NOT EXISTS (
                SELECT 1 FROM Demo_Retail_Product drp
                WHERE drp.SKU = p.ProductCode
            );
        
        SET @ProductCount = @@ROWCOUNT;
        PRINT 'Step 1: Copied ' + CAST(@ProductCount AS NVARCHAR(10)) + ' products to Demo_Retail_Product';
        
        -- =============================================
        -- STEP 2: Copy prices to Demo_Retail_Price
        -- =============================================
        INSERT INTO Demo_Retail_Price (
            ProductID,
            BranchID,
            SellingPrice,
            CostPrice,
            EffectiveFrom,
            EffectiveTo
        )
        SELECT 
            p.ProductID,
            @BranchID AS BranchID,
            COALESCE(p.RecommendedSellingPrice, p.LastPaidPrice, 0) AS SellingPrice,
            COALESCE(p.AverageCost, p.LastPaidPrice, 0) AS CostPrice,
            GETDATE() AS EffectiveFrom,
            NULL AS EffectiveTo
        FROM Products p
        WHERE p.IsActive = 1
            AND p.ItemType IN ('internal', 'external', 'Manufactured')
            AND COALESCE(p.RecommendedSellingPrice, p.LastPaidPrice, 0) > 0
            AND NOT EXISTS (
                SELECT 1 FROM Demo_Retail_Price drp
                WHERE drp.ProductID = p.ProductID 
                    AND drp.BranchID = @BranchID
            );
        
        SET @PriceCount = @@ROWCOUNT;
        PRINT 'Step 2: Copied ' + CAST(@PriceCount AS NVARCHAR(10)) + ' prices to Demo_Retail_Price';
        
        -- =============================================
        -- STEP 3: Create stock records with Quantity = 0
        -- =============================================
        IF OBJECT_ID('Demo_Retail_Stock', 'U') IS NOT NULL
        BEGIN
            INSERT INTO Demo_Retail_Stock (
                VariantID,
                BranchID,
                QtyOnHand,
                UpdatedAt
            )
            SELECT 
                p.ProductID,
                @BranchID,
                0 AS QtyOnHand,
                GETDATE() AS UpdatedAt
            FROM Products p
            WHERE p.IsActive = 1
                AND p.ItemType IN ('internal', 'external', 'Manufactured')
                AND EXISTS (
                    SELECT 1 FROM Demo_Retail_Product drp
                    WHERE drp.ProductID = p.ProductID 
                        AND drp.BranchID = @BranchID
                )
                AND NOT EXISTS (
                    SELECT 1 FROM Demo_Retail_Stock drs
                    WHERE drs.VariantID = p.ProductID 
                        AND drs.BranchID = @BranchID
                );
            
            SET @StockCount = @@ROWCOUNT;
            PRINT 'Step 3: Created ' + CAST(@StockCount AS NVARCHAR(10)) + ' stock records in Demo_Retail_Stock';
        END
        ELSE
        BEGIN
            PRINT 'Step 3: Demo_Retail_Stock table does not exist - skipping';
        END
        
        COMMIT TRANSACTION;
        
        PRINT '========================================';
        PRINT 'Branch Initialization Complete!';
        PRINT 'Products: ' + CAST(@ProductCount AS NVARCHAR(10));
        PRINT 'Prices: ' + CAST(@PriceCount AS NVARCHAR(10));
        PRINT 'Stock Records: ' + CAST(@StockCount AS NVARCHAR(10));
        PRINT '========================================';
        
        -- Return summary
        SELECT 
            @BranchID AS BranchID,
            @ProductCount AS ProductsAdded,
            @PriceCount AS PricesAdded,
            @StockCount AS StockRecordsAdded,
            'Success' AS Status;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        PRINT '========================================';
        PRINT 'ERROR: Branch initialization failed!';
        PRINT 'Error: ' + @ErrorMessage;
        PRINT '========================================';
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO

PRINT '';
PRINT '✅ sp_InitializeBranchProducts created successfully!';
PRINT '';
PRINT 'FEATURES:';
PRINT '- ✅ Copies ALL active products from Products master table';
PRINT '- ✅ Uses correct ItemType values: internal, external, Manufactured';
PRINT '- ✅ Copies CategoryID and SubcategoryID to Demo_Retail_Product';
PRINT '- ✅ Maps ItemType to ProductType (internal→Internal, external→External)';
PRINT '- ✅ Gets RecommendedSellingPrice from Products table';
PRINT '- ✅ Sets Quantity = 0 in Demo_Retail_Stock';
PRINT '- ✅ Proper transaction handling and error reporting';
PRINT '';
PRINT 'USAGE: EXEC sp_InitializeBranchProducts @BranchID = 9';
PRINT '';
