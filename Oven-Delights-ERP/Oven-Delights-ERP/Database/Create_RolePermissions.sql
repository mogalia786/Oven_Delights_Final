-- Create RolePermissions table and seed feature keys (idempotent)
SET NOCOUNT ON;

IF OBJECT_ID('dbo.RolePermissions','U') IS NULL
BEGIN
    CREATE TABLE dbo.RolePermissions(
        RolePermissionID INT IDENTITY(1,1) PRIMARY KEY,
        RoleID INT NOT NULL,
        FeatureKey NVARCHAR(100) NOT NULL,
        CanRead BIT NOT NULL DEFAULT(0),
        CanWrite BIT NOT NULL DEFAULT(0),
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CreatedBy INT NULL
    );
    CREATE UNIQUE INDEX UX_RolePermissions_Role_Feature ON dbo.RolePermissions(RoleID, FeatureKey);
END;

-- Seed common feature keys into a helper table for the Admin UI (optional)
IF OBJECT_ID('dbo.FeatureCatalog','U') IS NULL
BEGIN
    CREATE TABLE dbo.FeatureCatalog(
        FeatureKey NVARCHAR(100) NOT NULL PRIMARY KEY,
        DisplayName NVARCHAR(150) NOT NULL,
        Category NVARCHAR(50) NOT NULL
    );
END;

;WITH F(FeatureKey, DisplayName, Category) AS (
    SELECT 'Retail.Products.Upsert','Product Upsert','Retail' UNION ALL
    SELECT 'Retail.Prices.Manage','Price Management','Retail' UNION ALL
    SELECT 'Retail.Inventory.Adjustments','Stock Adjustments','Retail' UNION ALL
    SELECT 'Receiving.MFG','Receive from Manufacturing','Retail' UNION ALL
    SELECT 'Receiving.PO','Receive External (PO)','Retail' UNION ALL
    SELECT 'Reporting.LowStock','Low Stock','Reporting' UNION ALL
    SELECT 'Reporting.ProductCatalog','Product Catalog','Reporting' UNION ALL
    SELECT 'Reporting.PriceHistory','Price History','Reporting' UNION ALL
    SELECT 'Stockroom.InternalOrders','Internal Orders','Stockroom' UNION ALL
    SELECT 'Accounting.GL.View','View GL','Accounting' UNION ALL
    SELECT 'Accounting.AP.Payments','AP Payments (Batch)','Accounting' UNION ALL
    SELECT 'Transfers.InterBranch','Inter-Branch Transfers','Stockroom'
)
MERGE dbo.FeatureCatalog AS tgt
USING F AS src
ON tgt.FeatureKey = src.FeatureKey
WHEN NOT MATCHED THEN
    INSERT(FeatureKey, DisplayName, Category) VALUES(src.FeatureKey, src.DisplayName, src.Category);

PRINT 'RolePermissions and FeatureCatalog ready.';
