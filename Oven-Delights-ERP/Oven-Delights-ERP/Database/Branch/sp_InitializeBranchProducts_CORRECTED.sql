-- =============================================
-- CORRECTED: sp_InitializeBranchProducts
-- 
-- Properly handles IDENTITY columns and correct table relationships:
-- 1. Demo_Retail_Product (ProductID IDENTITY) - shared products
-- 2. Demo_Retail_Variant (VariantID IDENTITY, FK to ProductID) - one variant per product
-- 3. Demo_Retail_Price (ProductID + BranchID) - branch-specific pricing
-- 4. Demo_Retail_Stock (VariantID + BranchID) - branch-specific inventory
-- =============================================

CREATE OR ALTER PROCEDURE sp_InitializeBranchProducts
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @ProductCount INT = 0;
        DECLARE @VariantCount INT = 0;
        DECLARE @PriceCount INT = 0;
        DECLARE @StockCount INT = 0;
        
        PRINT '========================================';
        PRINT 'Initializing Branch: ' + CAST(@BranchID AS NVARCHAR(10));
        PRINT '========================================';
        
        -- =============================================
        -- STEP 1: Insert products into Demo_Retail_Product (if not exists)
        -- ProductID is IDENTITY, so it auto-generates
        -- =============================================
        INSERT INTO Demo_Retail_Product (
            SKU,
            Name,
            Category,
            IsActive,
            CreatedAt
        )
        SELECT 
            p.ProductCode,
            p.ProductName,
            c.CategoryName,
            p.IsActive,
            GETDATE()
        FROM Products p
        LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
        WHERE p.IsActive = 1
            AND p.ItemType IN ('internal', 'external', 'Manufactured')
            AND NOT EXISTS (
                SELECT 1 FROM Demo_Retail_Product drp
                WHERE drp.SKU = p.ProductCode
            );
        
        SET @ProductCount = @@ROWCOUNT;
        PRINT 'Step 1: Added ' + CAST(@ProductCount AS NVARCHAR(10)) + ' new products to Demo_Retail_Product';
        
        -- =============================================
        -- STEP 2: Create variants for each product (if not exists)
        -- One variant per product with same barcode as SKU
        -- =============================================
        INSERT INTO Demo_Retail_Variant (
            ProductID,
            Barcode,
            IsActive,
            CreatedAt
        )
        SELECT 
            drp.ProductID,
            drp.SKU,
            drp.IsActive,
            GETDATE()
        FROM Demo_Retail_Product drp
        WHERE drp.IsActive = 1
            AND NOT EXISTS (
                SELECT 1 FROM Demo_Retail_Variant drv
                WHERE drv.ProductID = drp.ProductID
            );
        
        SET @VariantCount = @@ROWCOUNT;
        PRINT 'Step 2: Created ' + CAST(@VariantCount AS NVARCHAR(10)) + ' variants in Demo_Retail_Variant';
        
        -- =============================================
        -- STEP 3: Copy prices for this branch
        -- =============================================
        INSERT INTO Demo_Retail_Price (
            ProductID,
            BranchID,
            SellingPrice,
            CostPrice,
            EffectiveFrom,
            EffectiveTo,
            CreatedAt
        )
        SELECT 
            drp.ProductID,
            @BranchID,
            COALESCE(p.RecommendedSellingPrice, p.LastPaidPrice, 0),
            COALESCE(p.AverageCost, p.LastPaidPrice, 0),
            CAST(GETDATE() AS DATE),
            NULL,
            GETDATE()
        FROM Products p
        INNER JOIN Demo_Retail_Product drp ON drp.SKU = p.ProductCode
        WHERE p.IsActive = 1
            AND p.ItemType IN ('internal', 'external', 'Manufactured')
            AND COALESCE(p.RecommendedSellingPrice, p.LastPaidPrice, 0) > 0
            AND NOT EXISTS (
                SELECT 1 FROM Demo_Retail_Price price
                WHERE price.ProductID = drp.ProductID 
                    AND price.BranchID = @BranchID
            );
        
        SET @PriceCount = @@ROWCOUNT;
        PRINT 'Step 3: Added ' + CAST(@PriceCount AS NVARCHAR(10)) + ' prices for Branch ' + CAST(@BranchID AS NVARCHAR(10));
        
        -- =============================================
        -- STEP 4: Create stock records with QtyOnHand = 0
        -- =============================================
        INSERT INTO Demo_Retail_Stock (
            VariantID,
            BranchID,
            QtyOnHand,
            ReorderPoint,
            UpdatedAt
        )
        SELECT 
            drv.VariantID,
            @BranchID,
            0,
            0,
            GETDATE()
        FROM Demo_Retail_Variant drv
        INNER JOIN Demo_Retail_Product drp ON drv.ProductID = drp.ProductID
        INNER JOIN Products p ON p.ProductCode = drp.SKU
        WHERE drp.IsActive = 1
            AND drv.IsActive = 1
            AND p.IsActive = 1
            AND p.ItemType IN ('internal', 'external', 'Manufactured')
            AND NOT EXISTS (
                SELECT 1 FROM Demo_Retail_Stock stock
                WHERE stock.VariantID = drv.VariantID 
                    AND stock.BranchID = @BranchID
            );
        
        SET @StockCount = @@ROWCOUNT;
        PRINT 'Step 4: Created ' + CAST(@StockCount AS NVARCHAR(10)) + ' stock records for Branch ' + CAST(@BranchID AS NVARCHAR(10));
        
        COMMIT TRANSACTION;
        
        PRINT '========================================';
        PRINT 'Branch Initialization Complete!';
        PRINT 'Products: ' + CAST(@ProductCount AS NVARCHAR(10)) + ' (new)';
        PRINT 'Variants: ' + CAST(@VariantCount AS NVARCHAR(10)) + ' (new)';
        PRINT 'Prices: ' + CAST(@PriceCount AS NVARCHAR(10)) + ' (for this branch)';
        PRINT 'Stock Records: ' + CAST(@StockCount AS NVARCHAR(10)) + ' (for this branch)';
        PRINT '========================================';
        
        -- Return summary
        SELECT 
            @BranchID AS BranchID,
            @ProductCount AS NewProducts,
            @VariantCount AS NewVariants,
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
PRINT '✅ sp_InitializeBranchProducts CORRECTED successfully!';
PRINT '';
PRINT 'KEY FIXES:';
PRINT '- ✅ Does NOT insert ProductID (IDENTITY column)';
PRINT '- ✅ Does NOT insert VariantID (IDENTITY column)';
PRINT '- ✅ Creates Demo_Retail_Variant entries (one per product)';
PRINT '- ✅ Uses correct column names (QtyOnHand, UpdatedAt, VariantID)';
PRINT '- ✅ Products are shared (no BranchID in Demo_Retail_Product)';
PRINT '- ✅ Prices and Stock are branch-specific';
PRINT '';
PRINT 'USAGE: EXEC sp_InitializeBranchProducts @BranchID = 8';
PRINT '';
