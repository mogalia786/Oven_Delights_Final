-- =============================================
-- Sync ProductInventory to Retail_Stock
-- Ensures manufactured products appear in Retail_Stock for POS
-- =============================================

IF OBJECT_ID('dbo.sp_Sync_ProductInventory_To_RetailStock','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.sp_Sync_ProductInventory_To_RetailStock AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.sp_Sync_ProductInventory_To_RetailStock
    @ProductID INT,
    @BranchID INT,
    @Quantity DECIMAL(18,4),
    @UnitCost DECIMAL(18,4) = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get or create variant for product
    DECLARE @VariantID INT;
    
    -- Check if Retail_Variant exists
    IF OBJECT_ID('dbo.Retail_Variant','U') IS NOT NULL
    BEGIN
        -- Get existing variant or create new one
        SELECT TOP 1 @VariantID = VariantID 
        FROM dbo.Retail_Variant 
        WHERE ProductID = @ProductID AND IsActive = 1;
        
        IF @VariantID IS NULL
        BEGIN
            -- Get SKU from Products table
            DECLARE @SKU NVARCHAR(64);
            SELECT @SKU = SKU FROM dbo.Products WHERE ProductID = @ProductID;
            
            -- Create variant
            INSERT INTO dbo.Retail_Variant (ProductID, Barcode, IsActive, CreatedAt, UpdatedAt)
            VALUES (@ProductID, @SKU, 1, SYSUTCDATETIME(), SYSUTCDATETIME());
            
            SET @VariantID = SCOPE_IDENTITY();
        END
        
        -- Update or insert into Retail_Stock
        IF EXISTS (SELECT 1 FROM dbo.Retail_Stock WHERE VariantID = @VariantID AND ISNULL(BranchID, -1) = ISNULL(@BranchID, -1))
        BEGIN
            UPDATE dbo.Retail_Stock
            SET QtyOnHand = QtyOnHand + @Quantity,
                UpdatedAt = SYSUTCDATETIME()
            WHERE VariantID = @VariantID 
            AND ISNULL(BranchID, -1) = ISNULL(@BranchID, -1);
        END
        ELSE
        BEGIN
            INSERT INTO dbo.Retail_Stock (VariantID, BranchID, QtyOnHand, ReorderPoint, UpdatedAt)
            VALUES (@VariantID, @BranchID, @Quantity, 10, SYSUTCDATETIME());
        END
        
        -- Record movement
        INSERT INTO dbo.Retail_StockMovements (VariantID, BranchID, QtyDelta, Reason, Ref1, CreatedAt, CreatedBy)
        VALUES (@VariantID, @BranchID, @Quantity, 'Production', 'Manufacturing Complete', SYSUTCDATETIME(), NULL);
    END
    ELSE
    BEGIN
        -- Retail_Variant table doesn't exist, skip sync
        PRINT 'Retail_Variant table not found, skipping sync';
    END
END
GO

PRINT 'Created sp_Sync_ProductInventory_To_RetailStock';
GO
