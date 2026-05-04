-- =============================================
-- Add Cost of Sales tracking to Demo_Sales
-- Ensures cost per unit is recorded for every sale
-- Table already has CostOfSales column - just need to ensure it's populated correctly
-- =============================================

-- Check if CostPerUnit column exists (for per-unit tracking)
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Demo_Sales') AND name = 'CostPerUnit')
BEGIN
    ALTER TABLE dbo.Demo_Sales
    ADD CostPerUnit DECIMAL(18,6) NULL;
    PRINT '✅ Added CostPerUnit column to Demo_Sales';
END
ELSE
BEGIN
    PRINT '⚠️  CostPerUnit column already exists in Demo_Sales';
END

GO

-- =============================================
-- Update existing records with cost per unit
-- Uses AverageCost from Demo_Retail_Product
-- CostOfSales should be: Quantity × CostPerUnit
-- =============================================
UPDATE s
SET 
    s.CostPerUnit = ISNULL(p.AverageCost, ISNULL(p.LastPaidPrice, 0)),
    s.CostOfSales = s.Quantity * ISNULL(p.AverageCost, ISNULL(p.LastPaidPrice, 0))
FROM dbo.Demo_Sales s
INNER JOIN dbo.Demo_Retail_Product p ON s.ProductID = p.ProductID
WHERE s.CostPerUnit IS NULL OR s.CostOfSales IS NULL OR s.CostOfSales = 0;

PRINT '✅ Updated existing sales with cost per unit data';
GO

PRINT '';
PRINT '═══════════════════════════════════════════════════════════════';
PRINT '✅ Cost of Sales tracking enabled for Demo_Sales';
PRINT '';
PRINT '📊 Columns:';
PRINT '   - CostPerUnit: Cost per single unit (from AverageCost/LastPaidPrice)';
PRINT '   - CostOfSales: Quantity × CostPerUnit (existing column)';
PRINT '';
PRINT '💡 IMPORTANT: Sales amounts should be stored EXCLUDING VAT';
PRINT '   - Amount column = Selling price × Quantity (excl VAT)';
PRINT '   - VAT calculated separately and added at display/reporting';
PRINT '   - CostOfSales = Cost per unit × Quantity';
PRINT '   - Gross Profit = Amount - CostOfSales';
PRINT '═══════════════════════════════════════════════════════════════';
GO
