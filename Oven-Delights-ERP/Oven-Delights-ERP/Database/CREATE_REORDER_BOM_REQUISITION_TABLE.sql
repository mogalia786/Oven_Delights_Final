-- =============================================
-- Create ReOrderBOMRequisition Table
-- Stores scaled BOM ingredients for each re-order line
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ReOrderBOMRequisition')
BEGIN
    CREATE TABLE ReOrderBOMRequisition (
        BOMRequisitionID INT IDENTITY(1,1) PRIMARY KEY,
        ReOrderLineID INT NOT NULL,
        ItemID INT NOT NULL,
        ItemName NVARCHAR(255) NOT NULL,
        ItemType NVARCHAR(50) NOT NULL, -- 'Ingredient', 'Packaging'
        Quantity DECIMAL(18,3) NOT NULL,
        UnitOfMeasure NVARCHAR(50) NOT NULL,
        CostPerUnit DECIMAL(18,6) NOT NULL,
        TotalCost DECIMAL(18,2) NOT NULL,
        IsFulfilled BIT DEFAULT 0,
        FulfilledQuantity DECIMAL(18,3) DEFAULT 0,
        FulfilledDate DATETIME NULL,
        FulfilledBy INT NULL,
        CreatedDate DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_BOMRequisition_ReOrderLine FOREIGN KEY (ReOrderLineID) 
            REFERENCES ReOrderBookLines(ReOrderLineID) ON DELETE CASCADE,
        CONSTRAINT FK_BOMRequisition_Item FOREIGN KEY (ItemID) 
            REFERENCES Demo_Retail_Product(ProductID)
    );
    
    CREATE INDEX IX_ReOrderBOMRequisition_ReOrderLineID ON ReOrderBOMRequisition(ReOrderLineID);
    CREATE INDEX IX_ReOrderBOMRequisition_ItemID ON ReOrderBOMRequisition(ItemID);
    CREATE INDEX IX_ReOrderBOMRequisition_IsFulfilled ON ReOrderBOMRequisition(IsFulfilled);
    
    PRINT '✅ ReOrderBOMRequisition table created successfully!';
END
ELSE
BEGIN
    PRINT '⚠️  ReOrderBOMRequisition table already exists.';
END
GO

PRINT '';
PRINT '📋 TABLE PURPOSE:';
PRINT '   Stores scaled BOM ingredients for each production order line';
PRINT '   Links to ReOrderBookLines to show what ingredients are needed';
PRINT '   Tracks fulfillment status for stockroom requisitions';
PRINT '';
PRINT '🔄 WORKFLOW:';
PRINT '   1. Manager adds product to re-order (e.g., 10 Madeiras)';
PRINT '   2. System calls sp_GetScaledBOMFromRecipe';
PRINT '   3. Scaled BOM saved to ReOrderBOMRequisition';
PRINT '   4. Baker sees BOM requisition on dashboard';
PRINT '   5. Stockroom fulfills requisition';
PRINT '   6. Baker starts production when BOM fulfilled';
GO
