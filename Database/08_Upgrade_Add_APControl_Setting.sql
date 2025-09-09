/* Ensure required SystemSettings keys exist for accounting postings */
SET NOCOUNT ON;

IF OBJECT_ID('dbo.SystemSettings','U') IS NULL
BEGIN
    RAISERROR('SystemSettings table is missing. Run core schema scripts first.', 16, 1);
    RETURN;
END;

-- Add keys if they do not exist yet. Values can be set to valid GL AccountIDs later.
IF NOT EXISTS (SELECT 1 FROM dbo.SystemSettings WHERE [Key] = N'InventoryAccountID')
BEGIN
    INSERT INTO dbo.SystemSettings ([Key], [Value], Description)
    VALUES (N'InventoryAccountID', NULL, N'Default Inventory control account (GL AccountID)');
END;

IF NOT EXISTS (SELECT 1 FROM dbo.SystemSettings WHERE [Key] = N'GRIRAccountID')
BEGIN
    INSERT INTO dbo.SystemSettings ([Key], [Value], Description)
    VALUES (N'GRIRAccountID', NULL, N'Goods Received / Invoice Received clearing account (GL AccountID)');
END;

IF NOT EXISTS (SELECT 1 FROM dbo.SystemSettings WHERE [Key] = N'APControlAccountID')
BEGIN
    INSERT INTO dbo.SystemSettings ([Key], [Value], Description)
    VALUES (N'APControlAccountID', NULL, N'Accounts Payable control account (GL AccountID)');
END;

PRINT 'Verified/added InventoryAccountID, GRIRAccountID, APControlAccountID in SystemSettings.';
