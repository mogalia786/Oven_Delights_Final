-- Create v_Retail_CurrentPrices view for POS product lookup
-- This view provides current selling prices for retail products

IF EXISTS (SELECT * FROM sys.views WHERE name = 'v_Retail_CurrentPrices')
    DROP VIEW dbo.v_Retail_CurrentPrices
GO

CREATE VIEW dbo.v_Retail_CurrentPrices
AS
SELECT 
    p.ProductID,
    p.BranchID,
    p.SellingPrice,
    p.CostPrice,
    p.CreatedDate,
    p.ModifiedDate
FROM dbo.Retail_Product p
WHERE p.IsActive = 1
GO

-- Grant permissions
GRANT SELECT ON dbo.v_Retail_CurrentPrices TO PUBLIC
GO

PRINT 'v_Retail_CurrentPrices view created successfully'
