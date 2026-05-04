-- =============================================
-- COMPLETE ONE-CLICK BRANCH CREATION
-- Creates branch with ALL inventory tables, prices, and journals
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
            AND p.ItemType IN ('internal', 'external', 'Manufactured')
            AND NOT EXISTS (
                SELECT 1 FROM Demo_Retail_Product drp
                WHERE drp.SKU = p.ProductCode
            );
        
        PRINT 'Step 2: Retail products in Demo_Retail_Product (' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' new)';
        
        -- =============================================
        -- STEP 3: Create variants for each retail product
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
        -- STEP 4: Create RETAIL PRICES (Demo_Retail_Price) for this branch
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
            AND p.ItemType IN ('internal', 'external', 'Manufactured');
        
        DECLARE @RetailPriceCount INT = @@ROWCOUNT;
        PRINT 'Step 4: Created ' + CAST(@RetailPriceCount AS NVARCHAR(10)) + ' retail prices';
        
        -- =============================================
        -- STEP 5: Create RETAIL STOCK (Demo_Retail_Stock) for this branch
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
        
        DECLARE @RetailStockCount INT = @@ROWCOUNT;
        PRINT 'Step 5: Created ' + CAST(@RetailStockCount AS NVARCHAR(10)) + ' retail stock records';
        
        -- =============================================
        -- STEP 6: Create RETAIL STOCK (RetailStock table) for this branch
        -- =============================================
        INSERT INTO RetailStock (ProductID, BranchID, Quantity, StockType, LastUpdated, UpdatedBy)
        SELECT 
            p.ProductID,
            @BranchID,
            0,
            CASE 
                WHEN p.ItemType = 'external' THEN 'External'
                WHEN p.ItemType IN ('internal', 'Manufactured') THEN 'Internal'
                ELSE 'External'
            END,
            GETDATE(),
            @CreatedBy
        FROM Products p
        WHERE p.IsActive = 1
            AND p.ItemType IN ('internal', 'external', 'Manufactured')
            AND NOT EXISTS (
                SELECT 1 FROM RetailStock rs
                WHERE rs.ProductID = p.ProductID AND rs.BranchID = @BranchID
            );
        
        PRINT 'Step 6: Created ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' RetailStock records';
        
        -- =============================================
        -- STEP 7: Create STOCKROOM STOCK (raw materials) for this branch
        -- =============================================
        INSERT INTO StockroomStock (ProductID, BranchID, Quantity, LastUpdated, UpdatedBy)
        SELECT 
            p.ProductID,
            @BranchID,
            0,
            GETDATE(),
            @CreatedBy
        FROM Products p
        WHERE p.IsActive = 1
            AND p.ItemType = 'RawMaterial'
            AND NOT EXISTS (
                SELECT 1 FROM StockroomStock ss
                WHERE ss.ProductID = p.ProductID AND ss.BranchID = @BranchID
            );
        
        PRINT 'Step 7: Created ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' stockroom stock records';
        
        -- =============================================
        -- STEP 8: Create MANUFACTURING STOCK for this branch
        -- =============================================
        INSERT INTO ManufacturingStock (ProductID, BranchID, Quantity, LastUpdated, UpdatedBy)
        SELECT 
            p.ProductID,
            @BranchID,
            0,
            GETDATE(),
            @CreatedBy
        FROM Products p
        WHERE p.IsActive = 1
            AND p.ItemType IN ('internal', 'Manufactured')
            AND NOT EXISTS (
                SELECT 1 FROM ManufacturingStock ms
                WHERE ms.ProductID = p.ProductID AND ms.BranchID = @BranchID
            );
        
        PRINT 'Step 8: Created ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' manufacturing stock records';
        
        -- =============================================
        -- STEP 9: Create MANUFACTURING INVENTORY for this branch
        -- =============================================
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
        
        PRINT 'Step 9: Created ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' manufacturing inventory records';
        
        -- =============================================
        -- STEP 10: Create branch-specific Chart of Accounts
        -- =============================================
        DECLARE @AccountsCreated INT = 0;
        
        -- Create branch-specific accounts (Sales, Inventory, COGS, etc.)
        -- Note: ChartOfAccounts doesn't have BranchID column, using AccountCode prefix instead
        IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = @BranchPrefix + '-SALES')
        BEGIN
            INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, CreatedDate, CreatedBy)
            VALUES 
                (@BranchPrefix + '-SALES', @BranchName + ' - Sales Revenue', 'Revenue', 1, GETDATE(), @CreatedBy),
                (@BranchPrefix + '-COGS', @BranchName + ' - Cost of Goods Sold', 'Expense', 1, GETDATE(), @CreatedBy),
                (@BranchPrefix + '-INV', @BranchName + ' - Inventory', 'Asset', 1, GETDATE(), @CreatedBy);
            
            SET @AccountsCreated = 3;
        END
        
        PRINT 'Step 10: Created ' + CAST(@AccountsCreated AS NVARCHAR(10)) + ' chart of accounts';
        
        COMMIT TRANSACTION;
        
        PRINT '';
        PRINT '========================================';
        PRINT '✅ BRANCH CREATED SUCCESSFULLY!';
        PRINT '========================================';
        PRINT 'Branch ID: ' + CAST(@BranchID AS NVARCHAR(10));
        PRINT 'Branch Name: ' + @BranchName;
        PRINT 'Retail Products: ' + CAST(@RetailPriceCount AS NVARCHAR(10));
        PRINT 'Retail Stock: ' + CAST(@RetailStockCount AS NVARCHAR(10));
        PRINT '========================================';
        
        -- Return summary
        SELECT 
            @BranchID AS BranchID,
            @BranchName AS BranchName,
            @BranchPrefix AS BranchPrefix,
            @RetailPriceCount AS RetailProducts,
            @RetailStockCount AS StockRecords,
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
PRINT 'EXEC sp_CreateNewBranch @BranchName = ''Branch Name'', @BranchPrefix = ''BXX'', @CreatedBy = 1;';
PRINT '';
PRINT 'This creates:';
PRINT '1. Branch record';
PRINT '2. Retail products (Demo_Retail_Product)';
PRINT '3. Retail prices (Demo_Retail_Price) - per branch';
PRINT '4. Retail stock (Demo_Retail_Stock + RetailStock) - per branch';
PRINT '5. Stockroom stock (raw materials) - per branch';
PRINT '6. Manufacturing stock - per branch';
PRINT '7. Manufacturing inventory - per branch';
PRINT '8. Chart of accounts - per branch';
