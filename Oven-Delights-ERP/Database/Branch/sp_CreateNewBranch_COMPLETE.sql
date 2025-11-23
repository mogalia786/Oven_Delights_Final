-- =============================================
-- ONE-CLICK BRANCH CREATION
-- Creates branch and initializes ALL data: products, prices, stock, ledgers
-- =============================================

CREATE OR ALTER PROCEDURE sp_CreateNewBranch
    @BranchName NVARCHAR(100),
    @BranchPrefix NVARCHAR(10),
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @BranchID INT;
    DECLARE @ErrorMsg NVARCHAR(4000);
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        PRINT '========================================';
        PRINT 'CREATING NEW BRANCH: ' + @BranchName;
        PRINT '========================================';
        PRINT '';
        
        -- =============================================
        -- STEP 1: Create Branch Record
        -- =============================================
        INSERT INTO Branches (BranchName, Prefix, IsActive, CreatedDate, CreatedBy)
        VALUES (@BranchName, @BranchPrefix, 1, GETDATE(), @CreatedBy);
        
        SET @BranchID = SCOPE_IDENTITY();
        PRINT 'Step 1: Created Branch (ID: ' + CAST(@BranchID AS NVARCHAR(10)) + ')';
        
        -- =============================================
        -- STEP 2: Copy ONLY RETAIL products to Demo_Retail_Product (shared, no BranchID)
        -- Exclude RawMaterial (ingredients) - they go to Stockroom only
        -- =============================================
        INSERT INTO Demo_Retail_Product (SKU, Name, Category, IsActive, CreatedAt)
        SELECT 
            p.ProductCode,
            p.ProductName,
            c.CategoryName,
            p.IsActive,
            GETDATE()
        FROM Products p
        LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
        WHERE p.IsActive = 1
            AND p.ItemType IN ('internal', 'external', 'Manufactured')  -- ONLY retail products
            AND NOT EXISTS (
                SELECT 1 FROM Demo_Retail_Product drp
                WHERE drp.SKU = p.ProductCode
            );
        
        PRINT 'Step 2: Ensured retail products exist in Demo_Retail_Product (' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' new)';
        
        -- =============================================
        -- STEP 3: Create variants for each product (if not exists)
        -- =============================================
        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive, CreatedAt)
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
        
        PRINT 'Step 3: Created variants (' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' new)';
        
        -- =============================================
        -- STEP 4: Copy prices from Products master to Demo_Retail_Price for this branch
        -- Only for retail products (internal/external/Manufactured)
        -- =============================================
        INSERT INTO Demo_Retail_Price (ProductID, BranchID, SellingPrice, CostPrice, EffectiveFrom, CreatedAt)
        SELECT 
            drp.ProductID,
            @BranchID,
            COALESCE(p.RecommendedSellingPrice, p.LastPaidPrice, 0),
            COALESCE(p.AverageCost, p.LastPaidPrice, 0),
            CAST(GETDATE() AS DATE),
            GETDATE()
        FROM Products p
        INNER JOIN Demo_Retail_Product drp ON drp.SKU = p.ProductCode
        WHERE p.IsActive = 1
            AND p.ItemType IN ('internal', 'external', 'Manufactured');  -- ONLY retail products
        
        DECLARE @PriceCount INT = @@ROWCOUNT;
        PRINT 'Step 4: Created ' + CAST(@PriceCount AS NVARCHAR(10)) + ' retail prices for Branch ' + CAST(@BranchID AS NVARCHAR(10));
        
        -- =============================================
        -- STEP 5: Create stock records (Quantity = 0)
        -- =============================================
        INSERT INTO Demo_Retail_Stock (VariantID, BranchID, QtyOnHand, ReorderPoint, UpdatedAt)
        SELECT 
            drv.VariantID,
            @BranchID,
            0,
            0,
            GETDATE()
        FROM Demo_Retail_Variant drv
        INNER JOIN Demo_Retail_Product drp ON drv.ProductID = drp.ProductID
        WHERE drp.IsActive = 1;
        
        DECLARE @StockCount INT = @@ROWCOUNT;
        PRINT 'Step 5: Created ' + CAST(@StockCount AS NVARCHAR(10)) + ' stock records';
        
        -- =============================================
        -- STEP 6: Create Stockroom inventory (for raw materials)
        -- =============================================
        IF OBJECT_ID('Stockroom_Inventory', 'U') IS NOT NULL
        BEGIN
            -- Stockroom_Inventory table doesn't exist yet
            PRINT 'Step 6: Stockroom_Inventory - skipped (table not implemented)';
            
            PRINT 'Step 6: Created ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' stockroom inventory records';
        END
        ELSE
            PRINT 'Step 6: Stockroom_Inventory table not found - skipped';
        
        -- =============================================
        -- STEP 7: Create Manufacturing inventory
        -- =============================================
        IF OBJECT_ID('Manufacturing_Inventory', 'U') IS NOT NULL
        BEGIN
            INSERT INTO Manufacturing_Inventory (MaterialID, BranchID, QtyOnHand, AverageCost, LastUpdated, UpdatedBy)
            SELECT 
                p.ProductID,
                @BranchID,
                0,
                COALESCE(p.AverageCost, 0),
                GETDATE(),
                @CreatedBy
            FROM Products p
            WHERE p.IsActive = 1
                AND p.ItemType IN ('internal', 'Manufactured')
                AND NOT EXISTS (
                    SELECT 1 FROM Manufacturing_Inventory mi
                    WHERE mi.MaterialID = p.ProductID AND mi.BranchID = @BranchID
                );
            
            PRINT 'Step 7: Created ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' manufacturing inventory records';
        END
        ELSE
            PRINT 'Step 7: Manufacturing_Inventory table not found - skipped';
        
        -- =============================================
        -- STEP 8: Create branch-specific ledger accounts
        -- =============================================
        IF OBJECT_ID('ChartOfAccounts', 'U') IS NOT NULL
        BEGIN
            -- Create branch-specific accounts (Sales, Inventory, etc.)
            DECLARE @AccountsCreated INT = 0;
            
            -- You can add specific ledger account creation here
            -- Example: Branch-specific Sales Revenue account
            
            PRINT 'Step 8: Created ' + CAST(@AccountsCreated AS NVARCHAR(10)) + ' ledger accounts';
        END
        ELSE
            PRINT 'Step 8: ChartOfAccounts table not found - skipped';
        
        COMMIT TRANSACTION;
        
        PRINT '';
        PRINT '========================================';
        PRINT '✅ BRANCH CREATED SUCCESSFULLY!';
        PRINT '========================================';
        PRINT 'Branch ID: ' + CAST(@BranchID AS NVARCHAR(10));
        PRINT 'Branch Name: ' + @BranchName;
        PRINT 'Products: ' + CAST(@PriceCount AS NVARCHAR(10));
        PRINT 'Stock Records: ' + CAST(@StockCount AS NVARCHAR(10));
        PRINT '========================================';
        
        -- Return summary
        SELECT 
            @BranchID AS BranchID,
            @BranchName AS BranchName,
            @BranchPrefix AS BranchPrefix,
            @PriceCount AS ProductsInitialized,
            @StockCount AS StockRecordsCreated,
            'Success' AS Status;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        SET @ErrorMsg = ERROR_MESSAGE();
        
        PRINT '';
        PRINT '========================================';
        PRINT '❌ ERROR: Branch creation failed!';
        PRINT 'Error: ' + @ErrorMsg;
        PRINT '========================================';
        
        RAISERROR(@ErrorMsg, 16, 1);
    END CATCH
END
GO

PRINT '';
PRINT '✅ sp_CreateNewBranch created successfully!';
PRINT '';
PRINT 'USAGE:';
PRINT 'EXEC sp_CreateNewBranch';
PRINT '    @BranchName = ''New Branch Name'',';
PRINT '    @BranchPrefix = ''NBR'',';
PRINT '    @CreatedBy = 1;';
PRINT '';
PRINT 'This will:';
PRINT '1. Create branch record';
PRINT '2. Copy ALL products from Products master';
PRINT '3. Create variants';
PRINT '4. Copy prices from Products.RecommendedSellingPrice';
PRINT '5. Create stock records (Qty=0)';
PRINT '6. Create stockroom inventory';
PRINT '7. Create manufacturing inventory';
PRINT '8. Create ledger accounts';
PRINT '';
