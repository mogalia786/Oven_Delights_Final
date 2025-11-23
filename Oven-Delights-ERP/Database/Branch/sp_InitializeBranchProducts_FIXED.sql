-- =============================================
-- Stored Procedure: sp_InitializeBranchProducts
-- Description: Initializes a new branch with all products, copying prices from master branch (Branch 6), and zero stock
-- Called automatically after branch creation in ERP
-- =============================================

CREATE OR ALTER PROCEDURE sp_InitializeBranchProducts
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @MasterBranchID INT = 6; -- Master branch with all prices
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @ProductCount INT = 0;
        DECLARE @PriceCount INT = 0;
        DECLARE @StockCount INT = 0;
        
        -- 1. Copy prices from master branch (Branch 6) to new branch
        INSERT INTO Demo_Retail_Price (ProductID, BranchID, SellingPrice, CostPrice, EffectiveFrom, EffectiveTo)
        SELECT 
            master.ProductID,
            @BranchID AS BranchID,
            master.SellingPrice,
            master.CostPrice,
            GETDATE() AS EffectiveFrom,
            NULL AS EffectiveTo
        FROM Demo_Retail_Price master
        INNER JOIN Demo_Retail_Product drp ON drp.ProductID = master.ProductID
        WHERE master.BranchID = @MasterBranchID
          AND drp.IsActive = 1
          AND (drp.ProductType = 'External' OR drp.ProductType = 'Internal')
          AND master.SellingPrice > 0  -- Only copy products with valid prices
          AND NOT EXISTS (
              SELECT 1 FROM Demo_Retail_Price 
              WHERE ProductID = master.ProductID AND BranchID = @BranchID
          );
        
        SET @PriceCount = @@ROWCOUNT;
        
        -- 2. Create stock records with quantity 0 for all products in RetailStock
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
          AND EXISTS (
              SELECT 1 FROM Demo_Retail_Price 
              WHERE ProductID = drp.ProductID AND BranchID = @BranchID
          )
          AND NOT EXISTS (
              SELECT 1 FROM RetailStock 
              WHERE ProductID = drp.ProductID AND BranchID = @BranchID
          );
        
        SET @StockCount = @@ROWCOUNT;
        
        -- 3. Initialize Demo_Sales table for the branch (ensure it exists)
        IF NOT EXISTS (SELECT 1 FROM Demo_Sales WHERE BranchID = @BranchID)
        BEGIN
            -- Create a placeholder record to ensure branch exists in sales table
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
            'Branch initialized successfully with ' + CAST(@PriceCount AS VARCHAR) + ' product prices (copied from Branch ' + CAST(@MasterBranchID AS VARCHAR) + ') and ' + CAST(@StockCount AS VARCHAR) + ' stock records. Till points will be created on first POS login.' AS Message;
            
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
