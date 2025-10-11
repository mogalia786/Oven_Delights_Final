-- Synchronize Legacy Inventory table with new Stockroom_Product table
-- This ensures backward compatibility with existing Purchase Order system

-- Step 1: Create synchronization view that maps legacy Inventory to new Stockroom_Product
CREATE OR ALTER VIEW vw_LegacyInventorySync AS
SELECT 
    -- Legacy Inventory fields
    i.InventoryID,
    i.MaterialID,
    i.BranchID,
    i.Location,
    i.Batch,
    i.QuantityOnHand,
    i.QuantityAllocated,
    i.QuantityAvailable,
    i.UnitCost,
    i.TotalCost,
    i.LastReceived,
    i.LastIssued,
    i.ExpiryDate,
    
    -- Raw Materials info
    rm.MaterialCode AS SKU,
    rm.MaterialName AS ProductName,
    rm.Description,
    rm.UnitOfMeasure,
    rm.ReorderLevel,
    rm.StandardCost,
    rm.IsActive,
    
    -- Map to new Stockroom_Product structure
    sp.ProductID AS StockroomProductID,
    sp.Code AS ProductCode,
    sp.MaterialType,
    sp.DestinationModule,
    
    -- Status indicators
    CASE 
        WHEN i.QuantityOnHand <= rm.ReorderLevel THEN 'Reorder Required'
        WHEN i.QuantityOnHand <= (rm.ReorderLevel * 1.5) THEN 'Low Stock'
        ELSE 'Adequate Stock'
    END AS StockStatus
    
FROM dbo.Inventory i
INNER JOIN dbo.RawMaterials rm ON i.MaterialID = rm.MaterialID
LEFT JOIN dbo.Stockroom_Product sp ON sp.SKU = rm.MaterialCode
WHERE i.IsActive = 1 AND rm.IsActive = 1
GO

-- Step 2: Create procedure to sync data from Legacy Inventory to Stockroom_Product
CREATE OR ALTER PROCEDURE sp_SyncLegacyInventoryToStockroom
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Insert new materials from RawMaterials to Stockroom_Product if they don't exist
    INSERT INTO dbo.Stockroom_Product (
        SKU, Code, ProductName, Description, 
        UnitPrice, StockQuantity, ReorderPoint, BranchID,
        MaterialType, DestinationModule, IsActive, CreatedDate, ModifiedDate
    )
    SELECT 
        rm.MaterialCode,
        FORMAT(ROW_NUMBER() OVER (ORDER BY rm.MaterialID) + 10000, '00000') AS Code,
        rm.MaterialName,
        rm.Description,
        rm.StandardCost,
        ISNULL(SUM(i.QuantityOnHand), 0),
        rm.ReorderLevel,
        i.BranchID,
        'Raw Material',
        'Manufacturing',
        rm.IsActive,
        GETDATE(),
        GETDATE()
    FROM dbo.RawMaterials rm
    LEFT JOIN dbo.Inventory i ON i.MaterialID = rm.MaterialID AND i.IsActive = 1
    WHERE rm.IsActive = 1 
        AND NOT EXISTS (SELECT 1 FROM dbo.Stockroom_Product sp WHERE sp.SKU = rm.MaterialCode)
    GROUP BY rm.MaterialID, rm.MaterialCode, rm.MaterialName, 
             rm.Description, rm.StandardCost, rm.ReorderLevel, i.BranchID, rm.IsActive;
    
    -- Update existing Stockroom_Product quantities from Inventory
    UPDATE sp
    SET StockQuantity = inv_totals.TotalQuantity,
        UnitPrice = inv_totals.AvgCost,
        ModifiedDate = GETDATE()
    FROM dbo.Stockroom_Product sp
    INNER JOIN (
        SELECT 
            rm.MaterialCode,
            SUM(i.QuantityOnHand) AS TotalQuantity,
            AVG(i.UnitCost) AS AvgCost
        FROM dbo.Inventory i
        INNER JOIN dbo.RawMaterials rm ON i.MaterialID = rm.MaterialID
        WHERE i.IsActive = 1
        GROUP BY rm.MaterialCode
    ) inv_totals ON sp.SKU = inv_totals.MaterialCode;
    
    PRINT 'Legacy Inventory synchronized with Stockroom_Product table';
END
GO

-- Step 3: Create view for Purchase Order compatibility
CREATE OR ALTER VIEW vw_PurchaseOrderMaterials AS
SELECT 
    -- Legacy fields for PO compatibility
    rm.MaterialID,
    rm.MaterialCode AS SKU,
    rm.MaterialName AS ProductName,
    rm.Description,
    rm.UnitOfMeasure,
    rm.StandardCost AS UnitCost,
    rm.ReorderLevel,
    rm.PreferredSupplierID,
    
    -- New Stockroom_Product fields
    sp.ProductID AS StockroomProductID,
    sp.Code AS ProductCode,
    sp.MaterialType,
    sp.DestinationModule,
    sp.StockQuantity,
    
    -- Current inventory totals
    ISNULL(inv_summary.TotalOnHand, 0) AS CurrentStock,
    ISNULL(inv_summary.TotalAllocated, 0) AS AllocatedStock,
    ISNULL(inv_summary.AvailableStock, 0) AS AvailableStock,
    
    -- Reorder status
    CASE 
        WHEN ISNULL(inv_summary.TotalOnHand, 0) <= rm.ReorderLevel THEN 1
        ELSE 0
    END AS NeedsReorder,
    
    rm.IsActive
    
FROM dbo.RawMaterials rm
LEFT JOIN dbo.Stockroom_Product sp ON sp.SKU = rm.MaterialCode
LEFT JOIN (
    SELECT 
        i.MaterialID,
        SUM(i.QuantityOnHand) AS TotalOnHand,
        SUM(i.QuantityAllocated) AS TotalAllocated,
        SUM(i.QuantityAvailable) AS AvailableStock
    FROM dbo.Inventory i
    WHERE i.IsActive = 1
    GROUP BY i.MaterialID
) inv_summary ON inv_summary.MaterialID = rm.MaterialID
WHERE rm.IsActive = 1
GO

-- Step 4: Create procedure to generate Bill of Materials requests
CREATE OR ALTER PROCEDURE sp_CreateBOMRequest
    @RequestingModule NVARCHAR(20), -- 'Manufacturing' or 'Retail'
    @BranchID INT,
    @RequestedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Create BOM request for materials needed by requesting module
    SELECT 
        pom.MaterialID,
        pom.SKU,
        pom.ProductName,
        pom.MaterialType,
        pom.CurrentStock,
        pom.ReorderLevel,
        CASE 
            WHEN pom.CurrentStock <= pom.ReorderLevel 
            THEN pom.ReorderLevel * 2
            ELSE 0
        END AS SuggestedOrderQuantity,
        pom.UnitCost,
        pom.PreferredSupplierID,
        s.CompanyName AS PreferredSupplierName,
        @RequestingModule AS RequestingModule,
        @BranchID AS BranchID,
        GETDATE() AS RequestDate,
        @RequestedBy AS RequestedBy
        
    FROM vw_PurchaseOrderMaterials pom
    LEFT JOIN dbo.Suppliers s ON s.SupplierID = pom.PreferredSupplierID
    WHERE pom.DestinationModule IN (@RequestingModule, 'Both')
        AND pom.NeedsReorder = 1
        AND pom.IsActive = 1
    ORDER BY pom.ProductName;
    
    PRINT 'BOM Request generated for ' + @RequestingModule + ' module';
END
GO

PRINT 'Legacy Inventory synchronization system created successfully!';
PRINT 'Available components:';
PRINT '- vw_LegacyInventorySync: Maps legacy Inventory to new Stockroom_Product';
PRINT '- sp_SyncLegacyInventoryToStockroom: Syncs data between tables';
PRINT '- vw_PurchaseOrderMaterials: Purchase Order compatible view';
PRINT '- sp_CreateBOMRequest: Generates Bill of Materials requests';
PRINT '';
PRINT 'Usage: EXEC sp_SyncLegacyInventoryToStockroom to sync data';
PRINT 'Usage: EXEC sp_CreateBOMRequest ''Manufacturing'', 1, 1 for BOM requests';
