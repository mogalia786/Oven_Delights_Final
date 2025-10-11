-- Retail Master Setup Script (Azure SQL)
-- Runs Phase 0 in one shot. Safe to re-run.
-- Timestamp: 11-Sep-2025 21:43 SAST

/* ===================== Create Tables ===================== */
:r .\Retail_Tables.sql
GO

/* ===================== Create Views ===================== */
:r .\Retail_Views.sql
GO

/* ===================== Quick Verification ===================== */
PRINT 'Retail tables (expect at least Retail_Product, Retail_Variant, Retail_Price, Retail_Stock, Retail_StockMovements, Retail_ProductImage):';
SELECT name FROM sys.tables WHERE name LIKE 'Retail_%' ORDER BY name;
PRINT 'Retail views (expect v_Retail_ProductCurrentPrice, v_Retail_StockOnHand, v_Retail_ProductCatalog, v_Retail_PriceHistory):';
SELECT name FROM sys.views WHERE name LIKE 'v_Retail_%' ORDER BY name;
GO
