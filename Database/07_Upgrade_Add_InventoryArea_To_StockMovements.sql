/*
Upgrade: Add InventoryArea to StockMovements
- Purpose: Track inventory area (Stockroom, Manufacturing, Retail)
- Safe to run multiple times: checks for column existence
*/

IF COL_LENGTH('dbo.StockMovements', 'InventoryArea') IS NULL
BEGIN
    PRINT 'Adding InventoryArea to StockMovements...';
    ALTER TABLE dbo.StockMovements
        ADD InventoryArea NVARCHAR(20) NOT NULL CONSTRAINT DF_StockMovements_InventoryArea DEFAULT N'Stockroom';

    -- Optional: backfill existing rows explicitly to ensure data present even if default removed later
    UPDATE dbo.StockMovements SET InventoryArea = N'Stockroom' WHERE InventoryArea IS NULL;
END
ELSE
BEGIN
    PRINT 'InventoryArea already exists on StockMovements. Skipping.';
END

GO
