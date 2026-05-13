-- =============================================
-- Stored Procedure: sp_GetCakeSheetCuttingSummary
-- Purpose: Generate consolidated sheet cutting summary for bakers
-- UPDATED: Now reads from ManufacturingInstructions field with structured data
-- Format: Layer: [Single/Double/Triple] | Cream: [Buttercream/Freshcream] | Flavour: [detected] | Shape: [detected] | Special: [text]
-- =============================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetCakeSheetCuttingSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_GetCakeSheetCuttingSummary]
GO

CREATE PROCEDURE [dbo].[sp_GetCakeSheetCuttingSummary]
    @ReadyDate DATE,
    @BranchID INT = NULL -- NULL = All branches
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Consolidated totals for sheet cutting
    -- Groups by Size, Layer, Shape, Cream Type across all branches
    
    SELECT 
        -- Extract Size: Find first 2-digit number in product name (10, 12, 14, 16, 18, 20, etc.)
        CASE 
            WHEN i.ProductName LIKE '%10%' THEN '10'
            WHEN i.ProductName LIKE '%12%' THEN '12'
            WHEN i.ProductName LIKE '%14%' THEN '14'
            WHEN i.ProductName LIKE '%16%' THEN '16'
            WHEN i.ProductName LIKE '%18%' THEN '18'
            WHEN i.ProductName LIKE '%20%' THEN '20'
            WHEN i.ProductName LIKE '%22%' THEN '22'
            WHEN i.ProductName LIKE '%24%' THEN '24'
            ELSE ''
        END AS Size,
        
        -- Extract Layer from ManufacturingInstructions (Format: "Layer: Single | Cream: ...")
        CASE 
            WHEN o.ManufacturingInstructions LIKE '%Layer: Triple%' THEN 'Triple'
            WHEN o.ManufacturingInstructions LIKE '%Layer: Double%' THEN 'Double'
            WHEN o.ManufacturingInstructions LIKE '%Layer: Single%' THEN 'Single'
            -- Fallback to old logic if ManufacturingInstructions is empty
            WHEN o.SpecialInstructions LIKE '%Triple%' OR o.SpecialInstructions LIKE '%triple%' THEN 'Triple'
            WHEN i.ProductName LIKE '%Triple%' OR i.ProductName LIKE '%TL%' THEN 'Triple'
            ELSE 'Double'
        END AS Layer,
        
        -- Extract Shape from ManufacturingInstructions (Format: "... | Shape: Bible | ...")
        CASE 
            WHEN o.ManufacturingInstructions LIKE '%Shape: Bible%' THEN 'Bible'
            WHEN o.ManufacturingInstructions LIKE '%Shape: Heart%' THEN 'Heart'
            WHEN o.ManufacturingInstructions LIKE '%Shape: Figure%' THEN 'Figure'
            WHEN o.ManufacturingInstructions LIKE '%Shape: Round%' THEN 'Round'
            WHEN o.ManufacturingInstructions LIKE '%Shape: Rectangle%' THEN 'Rectangle'
            WHEN o.ManufacturingInstructions LIKE '%Shape: Square%' THEN 'Square'
            -- Fallback to old logic if ManufacturingInstructions is empty
            WHEN o.SpecialInstructions LIKE '%Heart Shape%' OR o.SpecialInstructions LIKE '%Heart shape%' OR o.SpecialInstructions LIKE '%heart shape%' THEN 'Heart'
            WHEN o.SpecialInstructions LIKE '%Bible%' OR o.SpecialInstructions LIKE '%bible%' THEN 'Bible'
            WHEN o.SpecialInstructions = 'Figure' OR o.SpecialInstructions = 'figure' THEN 'Figure'
            WHEN o.SpecialInstructions LIKE '%Round cake%' OR o.SpecialInstructions LIKE '%round cake%' THEN 'Round'
            WHEN i.ProductName LIKE '%Figure%' OR i.ProductName LIKE '%figure%' THEN 'Figure'
            WHEN i.ProductName LIKE '%Round%' OR i.ProductName LIKE '%round%' THEN 'Round'
            WHEN i.ProductName LIKE '%Heart%' THEN 'Heart'
            WHEN i.ProductName LIKE '%Rectangle%' THEN 'Rectangle'
            WHEN i.ProductName LIKE '%Oval%' THEN 'Oval'
            WHEN i.ProductName LIKE '%Bible%' THEN 'Bible'
            ELSE 'Square'
        END AS Shape,
        
        -- Extract Cream Type from ManufacturingInstructions (Format: "... | Cream: Buttercream | ...")
        CASE 
            WHEN o.ManufacturingInstructions LIKE '%Cream: Buttercream%' THEN 'Butter Cream'
            WHEN o.ManufacturingInstructions LIKE '%Cream: Freshcream%' THEN 'Fresh Cream'
            WHEN o.ManufacturingInstructions LIKE '%Cream: Fresh Cream%' THEN 'Fresh Cream'
            -- Fallback to product name
            WHEN i.ProductName LIKE '%Fresh Cream%' OR i.ProductName LIKE '%Fresh-Cream%' OR i.ProductName LIKE '%FreshCream%' THEN 'Fresh Cream'
            WHEN i.ProductName LIKE '%Butter Cream%' OR i.ProductName LIKE '%Buttercream%' OR i.ProductName LIKE '%Butter-Cream%' THEN 'Butter Cream'
            ELSE 'Unknown'
        END AS CakeCream,
        
        -- Extract Special Request from ManufacturingInstructions (Format: "... | Special: EGGLESS, Bible  Double vanilla")
        -- EGGLESS is a dietary restriction and MUST ALWAYS appear if present in name or special requests
        CASE 
            WHEN o.ManufacturingInstructions LIKE '%Special:%' THEN 
                LTRIM(RTRIM(SUBSTRING(
                    o.ManufacturingInstructions, 
                    CHARINDEX('Special:', o.ManufacturingInstructions) + 8, 
                    LEN(o.ManufacturingInstructions)
                )))
            -- Fallback: Check for EGGLESS first (dietary restriction - highest priority)
            WHEN i.ProductName LIKE '%Eggless%' OR i.ProductName LIKE '%EGGLESS%' OR 
                 o.SpecialInstructions LIKE '%Eggless%' OR o.SpecialInstructions LIKE '%EGGLESS%' THEN 
                CASE 
                    -- If SpecialInstructions has other text besides shape keywords, combine with EGGLESS
                    WHEN o.SpecialInstructions IS NOT NULL AND LEN(LTRIM(RTRIM(o.SpecialInstructions))) > 0 AND
                         o.SpecialInstructions NOT LIKE '%Heart Shape%' AND o.SpecialInstructions NOT LIKE '%Bible%' AND
                         o.SpecialInstructions <> 'Figure' THEN 'EGGLESS, ' + LTRIM(RTRIM(o.SpecialInstructions))
                    ELSE 'EGGLESS'
                END
            -- Other special requests (not shape keywords)
            WHEN o.SpecialInstructions LIKE '%Heart Shape%' OR o.SpecialInstructions LIKE '%Heart shape%' OR o.SpecialInstructions LIKE '%heart shape%' THEN ''
            WHEN o.SpecialInstructions LIKE '%Bible%' OR o.SpecialInstructions LIKE '%bible%' THEN ''
            WHEN o.SpecialInstructions = 'Figure' OR o.SpecialInstructions = 'figure' THEN ''
            WHEN o.SpecialInstructions IS NOT NULL AND LEN(LTRIM(RTRIM(o.SpecialInstructions))) > 0 
                THEN LTRIM(RTRIM(o.SpecialInstructions))
            WHEN i.ProductName LIKE '%Vanilla%' OR i.ProductName LIKE '%VANILLA%' OR i.ProductName LIKE '%DBL VANILLA%' THEN 'DBL VANILLA'
            WHEN i.ProductName LIKE '%Chocolate%' OR i.ProductName LIKE '%CHOCOLATE%' THEN 'CHOCOLATE'
            WHEN i.ProductName LIKE '%Strawberry%' OR i.ProductName LIKE '%STRAWBERRY%' THEN 'STRAWBERRY'
            ELSE ''
        END AS SpecialRequest,
        
        -- Total quantity across all branches
        SUM(i.Quantity) AS Total,
        
        -- Completed quantity
        SUM(ISNULL(i.QtyCompleted, 0)) AS QtyCompleted,
        
        -- Remaining quantity to manufacture
        SUM(i.Quantity) - SUM(ISNULL(i.QtyCompleted, 0)) AS Remaining
        
    FROM POS_CustomOrders o
    INNER JOIN POS_CustomOrderItems i ON o.OrderID = i.OrderID
    INNER JOIN Branches b ON o.BranchID = b.BranchID
    
    WHERE o.ReadyDate = @ReadyDate
        AND o.OrderStatus IN ('New', 'InProgress', 'Ready') -- Include Ready status for manufacturing
        AND o.OrderStatus <> 'Cancelled' -- Exclude cancelled orders
        AND (@BranchID IS NULL OR o.BranchID = @BranchID)
    
    GROUP BY 
        o.ManufacturingInstructions,
        o.SpecialInstructions,
        -- Size
        CASE 
            WHEN i.ProductName LIKE '%10%' THEN '10'
            WHEN i.ProductName LIKE '%12%' THEN '12'
            WHEN i.ProductName LIKE '%14%' THEN '14'
            WHEN i.ProductName LIKE '%16%' THEN '16'
            WHEN i.ProductName LIKE '%18%' THEN '18'
            WHEN i.ProductName LIKE '%20%' THEN '20'
            WHEN i.ProductName LIKE '%22%' THEN '22'
            WHEN i.ProductName LIKE '%24%' THEN '24'
            ELSE ''
        END,
        i.ProductName
    
    ORDER BY 
        Size,
        Layer,
        Shape,
        CakeCream,
        SpecialRequest;
END
GO

PRINT 'sp_GetCakeSheetCuttingSummary created successfully with ManufacturingInstructions parsing';
GO
