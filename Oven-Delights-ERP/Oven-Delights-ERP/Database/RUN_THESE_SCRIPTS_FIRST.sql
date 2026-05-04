-- =============================================
-- CRITICAL: RUN THESE SCRIPTS IN ORDER
-- These stored procedures MUST exist before using the ERP
-- =============================================

-- SCRIPT 1: Create Product Price History System
-- Run: Create_ProductPriceHistory_Table.sql
-- This creates:
--   - ProductPriceHistory table
--   - vw_LatestProductPrices view
--   - sp_GetLatestProductPrice procedure
--   - sp_RecordProductPriceFromInvoice procedure

-- SCRIPT 2: Create Product Management Procedures
-- Run: sp_SaveProductToAllBranches.sql
-- This creates:
--   - sp_SaveProductToAllBranches procedure (REQUIRED for Add Product form!)
--   - sp_UpdateProductCostAllBranches procedure

-- =============================================
-- QUICK CHECK: Do these procedures exist?
-- =============================================

SELECT 
    name AS ProcedureName,
    CASE WHEN name IN (
        'sp_SaveProductToAllBranches',
        'sp_UpdateProductCostAllBranches',
        'sp_GetLatestProductPrice',
        'sp_RecordProductPriceFromInvoice'
    ) THEN '✓ EXISTS' ELSE '✗ MISSING' END AS Status
FROM sys.procedures
WHERE name IN (
    'sp_SaveProductToAllBranches',
    'sp_UpdateProductCostAllBranches',
    'sp_GetLatestProductPrice',
    'sp_RecordProductPriceFromInvoice'
)

UNION ALL

SELECT 
    'sp_SaveProductToAllBranches' AS ProcedureName,
    '✗ MISSING - CRITICAL!' AS Status
WHERE NOT EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_SaveProductToAllBranches')

UNION ALL

SELECT 
    'sp_UpdateProductCostAllBranches' AS ProcedureName,
    '✗ MISSING' AS Status
WHERE NOT EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_UpdateProductCostAllBranches')

UNION ALL

SELECT 
    'sp_GetLatestProductPrice' AS ProcedureName,
    '✗ MISSING' AS Status
WHERE NOT EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_GetLatestProductPrice')

UNION ALL

SELECT 
    'sp_RecordProductPriceFromInvoice' AS ProcedureName,
    '✗ MISSING' AS Status
WHERE NOT EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_RecordProductPriceFromInvoice')

ORDER BY ProcedureName

-- =============================================
-- IF ANY PROCEDURES ARE MISSING:
-- 1. Open Azure SQL Query Editor
-- 2. Run Create_ProductPriceHistory_Table.sql
-- 3. Run sp_SaveProductToAllBranches.sql
-- 4. Run this script again to verify
-- =============================================
