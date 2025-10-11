SET NOCOUNT ON;
SET XACT_ABORT ON;

/* Retail Pre-clean for BranchID issues
   - Drops Retail views
   - Removes computed BranchID columns if present
   - Removes dependent constraints using BranchKey so we can rebuild cleanly
*/

/* Drop views to remove dependencies */
IF OBJECT_ID('dbo.v_Retail_ProductCatalog','V') IS NOT NULL DROP VIEW dbo.v_Retail_ProductCatalog;
IF OBJECT_ID('dbo.v_Retail_StockOnHand','V') IS NOT NULL DROP VIEW dbo.v_Retail_StockOnHand;
IF OBJECT_ID('dbo.v_Retail_ProductCurrentPrice','V') IS NOT NULL DROP VIEW dbo.v_Retail_ProductCurrentPrice;
IF OBJECT_ID('dbo.v_Retail_PriceHistory','V') IS NOT NULL DROP VIEW dbo.v_Retail_PriceHistory;

/* Retail_Stock: drop UQ and BranchKey first to allow BranchID column surgery */
IF OBJECT_ID('dbo.Retail_Stock','U') IS NOT NULL
BEGIN
    IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name='UQ_Retail_Stock' AND parent_object_id=OBJECT_ID('dbo.Retail_Stock'))
        ALTER TABLE dbo.Retail_Stock DROP CONSTRAINT UQ_Retail_Stock;

    IF COL_LENGTH('dbo.Retail_Stock','BranchKey') IS NOT NULL
        ALTER TABLE dbo.Retail_Stock DROP COLUMN BranchKey;

    /* If BranchID exists and is computed, drop it so we can recreate as REAL INT later */
    IF COL_LENGTH('dbo.Retail_Stock','BranchID') IS NOT NULL
    BEGIN
        IF COLUMNPROPERTY(OBJECT_ID('dbo.Retail_Stock'),'BranchID','IsComputed') = 1
            ALTER TABLE dbo.Retail_Stock DROP COLUMN BranchID;
    END
END

/* Retail_Price: drop computed BranchID if present */
IF OBJECT_ID('dbo.Retail_Price','U') IS NOT NULL
BEGIN
    IF COL_LENGTH('dbo.Retail_Price','BranchID') IS NOT NULL
    BEGIN
        IF COLUMNPROPERTY(OBJECT_ID('dbo.Retail_Price'),'BranchID','IsComputed') = 1
            ALTER TABLE dbo.Retail_Price DROP COLUMN BranchID;
    END
END

/* Retail_StockMovements: drop computed BranchID if present */
IF OBJECT_ID('dbo.Retail_StockMovements','U') IS NOT NULL
BEGIN
    IF COL_LENGTH('dbo.Retail_StockMovements','BranchID') IS NOT NULL
    BEGIN
        IF COLUMNPROPERTY(OBJECT_ID('dbo.Retail_StockMovements'),'BranchID','IsComputed') = 1
            ALTER TABLE dbo.Retail_StockMovements DROP COLUMN BranchID;
    END
END

PRINT 'Pre-clean completed. Now run Retail_Phase0_Branch_Repair_SafeDynamic.sql';
