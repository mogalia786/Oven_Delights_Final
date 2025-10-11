-- Temporarily disable the Inventory trigger to allow BOM fulfillment

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'tr_Inventory_AfterUpdate')
BEGIN
    DISABLE TRIGGER tr_Inventory_AfterUpdate ON dbo.Inventory;
    PRINT 'Disabled tr_Inventory_AfterUpdate trigger';
END
ELSE
BEGIN
    PRINT 'Trigger tr_Inventory_AfterUpdate does not exist';
END
GO

PRINT 'You can now try BOM fulfillment';
PRINT 'To re-enable the trigger later, run: ENABLE TRIGGER tr_Inventory_AfterUpdate ON dbo.Inventory';
