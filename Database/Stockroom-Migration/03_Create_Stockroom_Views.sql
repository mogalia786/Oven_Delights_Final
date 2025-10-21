-- Step 3 — Recreate views with compatibility across schema variants

-- vw_PurchaseOrderAccounting (handles optional columns: PurchaseOrders.IsPosted, Suppliers.AccountsPayableAccountID, Suppliers.DefaultExpenseAccountID)
DECLARE @hasPO_IsPosted bit = CASE WHEN EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('[dbo].[PurchaseOrders]') AND name = 'IsPosted') THEN 1 ELSE 0 END;
DECLARE @hasSup_AP bit = CASE WHEN EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('[dbo].[Suppliers]') AND name = 'AccountsPayableAccountID') THEN 1 ELSE 0 END;
DECLARE @hasSup_DefaultExp bit = CASE WHEN EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('[dbo].[Suppliers]') AND name = 'DefaultExpenseAccountID') THEN 1 ELSE 0 END;

DECLARE @sql NVARCHAR(MAX) = N'';
SET @sql = N'CREATE OR ALTER VIEW [dbo].[vw_PurchaseOrderAccounting] AS
SELECT 
    po.PurchaseOrderID AS PurchaseOrderID,
    po.PONumber AS PONumber,
    po.SupplierID,
    s.CompanyName AS SupplierName,
    po.TotalAmount AS TotalAmount,
    po.VATAmount AS VATAmount,' +
    CASE WHEN @hasPO_IsPosted = 1 THEN N' ISNULL(po.IsPosted, 0) AS IsPosted,' ELSE N' CAST(0 AS bit) AS IsPosted,' END +
    CASE WHEN @hasSup_AP = 1 THEN N' s.AccountsPayableAccountID,' ELSE N' CAST(NULL AS int) AS AccountsPayableAccountID,' END +
    CASE WHEN @hasSup_DefaultExp = 1 THEN N' s.DefaultExpenseAccountID' ELSE N' CAST(NULL AS int) AS DefaultExpenseAccountID' END +
N' FROM dbo.PurchaseOrders po
INNER JOIN dbo.Suppliers s ON po.SupplierID = s.SupplierID' +
    CASE WHEN @hasPO_IsPosted = 1 THEN N' WHERE ISNULL(po.IsPosted, 0) = 0' ELSE N'' END + N';';

EXEC sys.sp_executesql @sql;
GO

-- vw_InventoryValuation (handles optional columns: RawMaterials.Category, InventoryAccountID, COGSAccountID)
DECLARE @hasRM_Category bit = CASE WHEN EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('[dbo].[RawMaterials]') AND name = 'Category') THEN 1 ELSE 0 END;
DECLARE @hasRM_InvAcct bit = CASE WHEN EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('[dbo].[RawMaterials]') AND name = 'InventoryAccountID') THEN 1 ELSE 0 END;
DECLARE @hasRM_COGS bit = CASE WHEN EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('[dbo].[RawMaterials]') AND name = 'COGSAccountID') THEN 1 ELSE 0 END;

DECLARE @sql NVARCHAR(MAX) = N'';
SET @sql = N'CREATE OR ALTER VIEW [dbo].[vw_InventoryValuation] AS
SELECT 
    rm.MaterialID AS MaterialID,
    rm.MaterialCode AS MaterialCode,
    rm.MaterialName AS MaterialName,' +
    CASE WHEN @hasRM_Category = 1 THEN N' rm.Category AS Category,' ELSE N' CAST(NULL AS nvarchar(50)) AS Category,' END +
N'    SUM(ISNULL(i.QuantityOnHand, 0)) AS TotalQuantity,
    AVG(ISNULL(i.UnitCost, 0)) AS AverageUnitCost,
    SUM(ISNULL(i.TotalCost, ISNULL(i.QuantityOnHand, 0) * ISNULL(i.UnitCost, 0))) AS TotalValue,' +
    CASE WHEN @hasRM_InvAcct = 1 THEN N' rm.InventoryAccountID,' ELSE N' CAST(NULL AS int) AS InventoryAccountID,' END +
    CASE WHEN @hasRM_COGS = 1 THEN N' rm.COGSAccountID' ELSE N' CAST(NULL AS int) AS COGSAccountID' END +
N' FROM dbo.RawMaterials rm
LEFT JOIN dbo.Inventory i ON rm.MaterialID = i.MaterialID
WHERE ISNULL(rm.IsActive, 1) = 1 AND (ISNULL(i.IsActive, 1) = 1 OR i.IsActive IS NULL)
GROUP BY rm.MaterialID, rm.MaterialCode, rm.MaterialName' +
    CASE WHEN @hasRM_Category = 1 THEN N', rm.Category' ELSE N'' END +
    CASE WHEN @hasRM_InvAcct = 1 THEN N', rm.InventoryAccountID' ELSE N'' END +
    CASE WHEN @hasRM_COGS = 1 THEN N', rm.COGSAccountID' ELSE N'' END + N';';

EXEC sys.sp_executesql @sql;
GO
