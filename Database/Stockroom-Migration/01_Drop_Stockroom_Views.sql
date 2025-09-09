-- Step 1 — Drop dependent views (safe to run)
IF OBJECT_ID('dbo.vw_PurchaseOrderAccounting', 'V') IS NOT NULL
    DROP VIEW dbo.vw_PurchaseOrderAccounting;
IF OBJECT_ID('dbo.vw_InventoryValuation', 'V') IS NOT NULL
    DROP VIEW dbo.vw_InventoryValuation;
