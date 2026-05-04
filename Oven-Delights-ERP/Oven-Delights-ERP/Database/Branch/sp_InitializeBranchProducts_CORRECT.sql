-- =============================================
-- Stored Procedure: sp_InitializeBranchProducts
-- Description: Initializes a new branch with products from MASTER Products table
-- Uses Demo_Retail_Stock (not RetailStock) for stock tracking
-- =============================================

CREATE OR ALTER PROCEDURE sp_InitializeBranchProducts
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @PriceCount INT = 0;
        DECLARE @StockCount INT = 0;
        
        -- 1. Copy prices from Products master table to Demo_Retail_Price for this branch
        -- Use the pricing fields from Products table (RecommendedSellingPrice, AverageCost, etc.)
        INSERT INTO Demo_Retail_Price (ProductID, BranchID, SellingPrice, CostPrice, EffectiveFrom, EffectiveTo)
        SELECT 
            p.ProductID,
            @BranchID AS BranchID,
            COALESCE(p.RecommendedSellingPrice, p.LastPaidPrice, 0) AS SellingPrice,
            COALESCE(p.AverageCost, p.LastPaidPrice, 0) AS CostPrice,
            GETDATE() AS EffectiveFrom,
            NULL AS EffectiveTo
        FROM Products p
        WHERE p.IsActive = 1
          AND p.ItemType IN ('Finished', 'SemiFinished')
          AND COALESCE(p.RecommendedSellingPrice, p.LastPaidPrice, 0) > 0  -- Only products with valid prices
          AND NOT EXISTS (
              SELECT 1 FROM Demo_Retail_Price 
              WHERE ProductID = p.ProductID AND BranchID = @BranchID
          );
        
        SET @PriceCount = @@ROWCOUNT;
        
        -- 2. Create stock records in Demo_Retail_Stock with quantity 0
        -- Check if Demo_Retail_Stock table exists first
        IF OBJECT_ID('Demo_Retail_Stock', 'U') IS NOT NULL
        BEGIN
            INSERT INTO Demo_Retail_Stock (ProductID, BranchID, Quantity, LastUpdated)
            SELECT 
                p.ProductID,
                @BranchID,
                0 AS Quantity,
                GETDATE() AS LastUpdated
            FROM Products p
            WHERE p.IsActive = 1
              AND p.ItemType IN ('Finished', 'SemiFinished')
              AND EXISTS (
                  SELECT 1 FROM Demo_Retail_Price 
                  WHERE ProductID = p.ProductID AND BranchID = @BranchID
              )
              AND NOT EXISTS (
                  SELECT 1 FROM Demo_Retail_Stock 
                  WHERE ProductID = p.ProductID AND BranchID = @BranchID
              );
            
            SET @StockCount = @@ROWCOUNT;
        END
        ELSE
        BEGIN
            -- If Demo_Retail_Stock doesn't exist, create it
            CREATE TABLE Demo_Retail_Stock (
                StockID INT IDENTITY(1,1) PRIMARY KEY,
                ProductID INT NOT NULL,
                BranchID INT NOT NULL,
                Quantity DECIMAL(18,2) NOT NULL DEFAULT 0,
                LastUpdated DATETIME NOT NULL DEFAULT GETDATE(),
                CONSTRAINT FK_Demo_Retail_Stock_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
                CONSTRAINT FK_Demo_Retail_Stock_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
                CONSTRAINT UQ_Demo_Retail_Stock_Product_Branch UNIQUE (ProductID, BranchID)
            );
            
            -- Now insert the stock records
            INSERT INTO Demo_Retail_Stock (ProductID, BranchID, Quantity, LastUpdated)
            SELECT 
                p.ProductID,
                @BranchID,
                0 AS Quantity,
                GETDATE() AS LastUpdated
            FROM Products p
            WHERE p.IsActive = 1
              AND p.ItemType IN ('Finished', 'SemiFinished')
              AND EXISTS (
                  SELECT 1 FROM Demo_Retail_Price 
                  WHERE ProductID = p.ProductID AND BranchID = @BranchID
              );
            
            SET @StockCount = @@ROWCOUNT;
        END
        
        COMMIT TRANSACTION;
        
        -- Return success message
        SELECT 
            @BranchID AS BranchID,
            'SUCCESS' AS Status,
            @PriceCount AS ProductPricesCreated,
            @StockCount AS StockRecordsCreated,
            'Branch initialized successfully with ' + CAST(@PriceCount AS VARCHAR) + ' product prices and ' + CAST(@StockCount AS VARCHAR) + ' stock records from Products master table.' AS Message;
            
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
