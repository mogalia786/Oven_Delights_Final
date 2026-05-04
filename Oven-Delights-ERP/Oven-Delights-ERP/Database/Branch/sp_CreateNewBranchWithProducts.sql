-- =============================================
-- Stored Procedure: sp_InitializeBranchProducts
-- Description: Initializes a new branch with all products, base prices, and zero stock
-- Called automatically after branch creation in ERP
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
        
        -- 2. Copy all products to Demo_Retail_Price for this branch (inherit prices from Products table)
        -- Only insert for products that exist in Demo_Retail_Product (to avoid FK constraint error)
        INSERT INTO Demo_Retail_Price (ProductID, BranchID, SellingPrice, CostPrice, EffectiveFrom, EffectiveTo)
        SELECT 
            drp.ProductID,
            @BranchID AS BranchID,
            COALESCE(p.RecommendedSellingPrice, p.LastPaidPrice, 10) AS SellingPrice,
            COALESCE(p.AverageCost, p.LastPaidPrice, 5) AS CostPrice,
            GETDATE() AS EffectiveFrom,
            NULL AS EffectiveTo
        FROM Demo_Retail_Product drp
        INNER JOIN Products p ON p.ProductID = drp.ProductID
        WHERE drp.IsActive = 1
          AND (drp.ProductType = 'External' OR drp.ProductType = 'Internal')
          AND NOT EXISTS (
              SELECT 1 FROM Demo_Retail_Price 
              WHERE ProductID = drp.ProductID AND BranchID = @BranchID
          );
        
        SET @PriceCount = @@ROWCOUNT;
        
        -- 3. Create stock records with quantity 0 for all products in RetailStock
        INSERT INTO RetailStock (ProductID, BranchID, Quantity, StockType, LastUpdated, UpdatedBy)
        SELECT 
            drp.ProductID,
            @BranchID,
            0 AS Quantity,
            drp.ProductType AS StockType,
            GETDATE() AS LastUpdated,
            'System' AS UpdatedBy
        FROM Demo_Retail_Product drp
        WHERE drp.IsActive = 1
          AND (drp.ProductType = 'External' OR drp.ProductType = 'Internal')
          AND NOT EXISTS (
              SELECT 1 FROM RetailStock 
              WHERE ProductID = drp.ProductID AND BranchID = @BranchID
          );
        
        SET @StockCount = @@ROWCOUNT;
        
        -- 3. Initialize Demo_Sales table for the branch (ensure it exists)
        IF NOT EXISTS (SELECT 1 FROM Demo_Sales WHERE BranchID = @BranchID)
        BEGIN
            -- Create a placeholder record to ensure branch exists in sales table
            -- This will be deleted if no actual sales are made
            INSERT INTO Demo_Sales (SaleNumber, InvoiceNumber, BranchID, TillPointID, CashierID, SaleDate, Subtotal, TaxAmount, TotalAmount, PaymentMethod, CashAmount, CardAmount, SaleType, ReferenceNumber)
            VALUES ('INIT-' + CAST(@BranchID AS VARCHAR), 'INIT-' + CAST(@BranchID AS VARCHAR), @BranchID, 1, 1, GETDATE(), 0, 0, 0, 'Cash', 0, 0, 'Initialization', 'Branch Setup');
        END
        
        COMMIT TRANSACTION;
        
        -- Return success message
        SELECT 
            @BranchID AS BranchID,
            'SUCCESS' AS Status,
            @PriceCount AS ProductPricesCreated,
            @StockCount AS StockRecordsCreated,
            'Branch initialized successfully with ' + CAST(@PriceCount AS VARCHAR) + ' product prices and ' + CAST(@StockCount AS VARCHAR) + ' stock records. Till points will be created on first POS login.' AS Message;
            
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        -- Return error
        SELECT 
            @BranchID AS BranchID,
            'ERROR' AS Status,
            0 AS ProductPricesCreated,
            0 AS StockRecordsCreated,
            ERROR_MESSAGE() AS Message;
            
        THROW;
    END CATCH
END
GO
