-- Add BranchID to InventoryItemCostHistory and supporting index (idempotent)
IF COL_LENGTH('dbo.InventoryItemCostHistory', 'BranchID') IS NULL
BEGIN
    ALTER TABLE dbo.InventoryItemCostHistory ADD BranchID INT NOT NULL CONSTRAINT DF_InvCostHistory_BranchID DEFAULT(0);
    -- Drop default to avoid future column drops failing on constraint name if desired
    ALTER TABLE dbo.InventoryItemCostHistory DROP CONSTRAINT DF_InvCostHistory_BranchID;
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes 
    WHERE name = 'IX_InvCostHistory_Item_Branch_PaidDate' 
      AND object_id = OBJECT_ID('dbo.InventoryItemCostHistory')
)
BEGIN
    CREATE INDEX IX_InvCostHistory_Item_Branch_PaidDate
    ON dbo.InventoryItemCostHistory(ItemType, ItemID, BranchID, PaidDate DESC, HistoryID DESC);
END
GO
