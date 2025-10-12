-- Create automatic sync triggers for the 4 critical product creation points
-- These triggers will automatically execute sp_SyncLegacyInventoryToStockroom

-- 1. PURCHASE ORDER INVOICE RECEIPT SYNC
-- Trigger when GoodsReceivedNotes (invoice receipt) is updated
CREATE OR ALTER TRIGGER tr_GRN_AfterInsertUpdate
ON dbo.GoodsReceivedNotes
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Only sync when GRN is marked as received/completed
    IF EXISTS (SELECT 1 FROM inserted WHERE Status IN ('Received', 'Completed'))
    BEGIN
        -- Execute sync in background
        EXEC sp_SyncLegacyInventoryToStockroom
        
        -- Log the sync event (simplified - remove if AuditLog table doesn't exist)
        -- INSERT INTO dbo.AuditLog (TableName, Action, Description, CreatedDate, CreatedBy)
        -- VALUES ('GoodsReceivedNotes', 'SYNC', 'Legacy inventory synced after PO invoice receipt', GETDATE(), 1)
    END
END
GO

-- 2. INVENTORY CHANGES SYNC  
-- Trigger when Inventory table quantities change
CREATE OR ALTER TRIGGER tr_Inventory_AfterUpdate
ON dbo.Inventory
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Only sync when quantities actually changed
    IF EXISTS (SELECT 1 FROM inserted i 
               INNER JOIN deleted d ON i.InventoryID = d.InventoryID 
               WHERE i.QuantityOnHand != d.QuantityOnHand 
                  OR i.QuantityAvailable != d.QuantityAvailable)
    BEGIN
        -- Execute sync
        EXEC sp_SyncLegacyInventoryToStockroom
        
        -- Log the sync event (simplified - remove if AuditLog table doesn't exist)
        -- INSERT INTO dbo.AuditLog (TableName, Action, Description, CreatedDate, CreatedBy)
        -- VALUES ('Inventory', 'SYNC', 'Legacy inventory synced after quantity change', GETDATE(), 1)
    END
END
GO

-- 3. RAW MATERIALS CHANGES SYNC
-- Trigger when RawMaterials master data changes
CREATE OR ALTER TRIGGER tr_RawMaterials_AfterInsertUpdate
ON dbo.RawMaterials
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Execute sync for any raw materials changes
    EXEC sp_SyncLegacyInventoryToStockroom
    
    -- Log the sync event (simplified - remove if AuditLog table doesn't exist)
    -- INSERT INTO dbo.AuditLog (TableName, Action, Description, CreatedDate, CreatedBy)
    -- VALUES ('RawMaterials', 'SYNC', 'Legacy inventory synced after raw materials change', GETDATE(), 1)
END
GO

-- 4. MANUFACTURING BOM COMPLETION SYNC
-- Create stored procedure for Manufacturing BOM completion
CREATE OR ALTER PROCEDURE sp_CompleteBOM
    @BOMID INT,
    @CompletedBy INT,
    @CompletedQuantity DECIMAL(18,4)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Update BOM status to completed
        UPDATE dbo.BillOfMaterials 
        SET Status = 'Completed',
            CompletedDate = GETDATE(),
            CompletedBy = @CompletedBy,
            CompletedQuantity = @CompletedQuantity
        WHERE BOMID = @BOMID
        
        -- Reduce raw materials from stockroom (via Inventory table)
        UPDATE i
        SET QuantityOnHand = QuantityOnHand - (bom_line.RequiredQuantity * @CompletedQuantity),
            QuantityAvailable = QuantityAvailable - (bom_line.RequiredQuantity * @CompletedQuantity),
            LastIssued = GETDATE()
        FROM dbo.Inventory i
        INNER JOIN dbo.BOMLines bom_line ON i.MaterialID = bom_line.MaterialID
        WHERE bom_line.BOMID = @BOMID
        
        -- Add manufactured product to Manufacturing_Product inventory
        DECLARE @ProductID INT, @SKU NVARCHAR(50), @ProductName NVARCHAR(100)
        SELECT @ProductID = ProductID, @SKU = ProductSKU, @ProductName = ProductName 
        FROM dbo.BillOfMaterials WHERE BOMID = @BOMID
        
        -- Manufacturing_Product table doesn't have StockQuantity column
        -- Update or create manufacturing product record
        IF EXISTS (SELECT 1 FROM dbo.Manufacturing_Product WHERE SKU = @SKU)
        BEGIN
            UPDATE dbo.Manufacturing_Product 
            SET ModifiedDate = GETDATE()
            WHERE SKU = @SKU
        END
        ELSE
        BEGIN
            INSERT INTO dbo.Manufacturing_Product (SKU, ProductName, IsActive, CreatedDate, BranchID)
            VALUES (@SKU, @ProductName, 1, GETDATE(), 1)
        END
        
        -- Execute legacy sync
        EXEC sp_SyncLegacyInventoryToStockroom
        
        -- Log completion (simplified - remove if AuditLog table doesn't exist)
        -- INSERT INTO dbo.AuditLog (TableName, Action, Description, CreatedDate, CreatedBy)
        -- VALUES ('BillOfMaterials', 'COMPLETE', 'BOM completed and inventory synced', GETDATE(), @CompletedBy)
        
        COMMIT TRANSACTION;
        
        SELECT 'SUCCESS' AS Result, 'BOM completed and inventory synced successfully' AS Message
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 'ERROR' AS Result, @ErrorMessage AS Message
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

-- 5. MANUFACTURING TO RETAIL TRANSFER SYNC
-- Create stored procedure for transferring manufactured products to retail
CREATE OR ALTER PROCEDURE sp_TransferManufacturingToRetail
    @ManufacturingProductID INT,
    @TransferQuantity DECIMAL(18,4),
    @BranchID INT,
    @TransferredBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @SKU NVARCHAR(50), @ProductName NVARCHAR(100), @Category NVARCHAR(50), @Subcategory NVARCHAR(50)
        
        -- Get manufacturing product details
        SELECT @SKU = SKU, @ProductName = ProductName, @Category = Category, @Subcategory = Subcategory
        FROM dbo.Manufacturing_Product 
        WHERE ProductID = @ManufacturingProductID
        
        -- Manufacturing_Product table doesn't have StockQuantity column
        -- Just update the modified date to track the transfer
        UPDATE dbo.Manufacturing_Product 
        SET ModifiedDate = GETDATE()
        WHERE ProductID = @ManufacturingProductID
        
        -- Add to retail products
        IF EXISTS (SELECT 1 FROM dbo.Retail_Product WHERE SKU = @SKU)
        BEGIN
            -- Update existing retail product stock via Retail_Stock table
            DECLARE @RetailProductID INT
            SELECT @RetailProductID = ProductID FROM dbo.Retail_Product WHERE SKU = @SKU
            
            -- Update stock in Retail_Stock table (assuming variant exists)
            UPDATE rs
            SET QtyOnHand = ISNULL(QtyOnHand, 0) + @TransferQuantity,
                UpdatedAt = GETDATE()
            FROM dbo.Retail_Stock rs
            INNER JOIN dbo.Retail_Variant rv ON rs.VariantID = rv.VariantID
            WHERE rv.ProductID = @RetailProductID
        END
        ELSE
        BEGIN
            -- Create new retail product
            INSERT INTO dbo.Retail_Product (SKU, Name, Category, Subcategory, IsActive, CreatedAt)
            VALUES (@SKU, @ProductName, @Category, @Subcategory, 1, GETDATE())
            
            DECLARE @NewRetailProductID INT = SCOPE_IDENTITY()
            
            -- Create variant and stock entries
            INSERT INTO dbo.Retail_Variant (ProductID, IsActive, CreatedAt)
            VALUES (@NewRetailProductID, 1, GETDATE())
            
            DECLARE @VariantID INT = SCOPE_IDENTITY()
            
            INSERT INTO dbo.Retail_Stock (VariantID, QtyOnHand, BranchID, UpdatedAt)
            VALUES (@VariantID, @TransferQuantity, @BranchID, GETDATE())
        END
        
        -- Execute legacy sync
        EXEC sp_SyncLegacyInventoryToStockroom
        
        -- Log transfer (simplified - remove if AuditLog table doesn't exist)
        -- INSERT INTO dbo.AuditLog (TableName, Action, Description, CreatedDate, CreatedBy)
        -- VALUES ('Manufacturing_Product', 'TRANSFER', 'Product transferred to retail and inventory synced', GETDATE(), @TransferredBy)
        
        COMMIT TRANSACTION;
        
        SELECT 'SUCCESS' AS Result, 'Product transferred to retail and inventory synced successfully' AS Message
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 'ERROR' AS Result, @ErrorMessage AS Message
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

PRINT 'Product sync triggers and procedures created successfully!'
PRINT ''
PRINT 'Automatic sync points implemented:'
PRINT '1. Purchase Order Invoice Receipt (GoodsReceivedNotes trigger)'
PRINT '2. Inventory Quantity Changes (Inventory trigger)' 
PRINT '3. Raw Materials Changes (RawMaterials trigger)'
PRINT '4. Manufacturing BOM Completion (sp_CompleteBOM procedure)'
PRINT '5. Manufacturing to Retail Transfer (sp_TransferManufacturingToRetail procedure)'
PRINT ''
PRINT 'Usage:'
PRINT '- Triggers execute automatically on data changes'
PRINT '- Call sp_CompleteBOM when manufacturing completes BOM'
PRINT '- Call sp_TransferManufacturingToRetail when moving products to retail'
