-- =============================================
-- Stored Procedure: sp_GetCakeSheetCuttingSummary
-- Purpose: Generate consolidated sheet cutting summary for bakers
-- Shows total quantities needed by Size, Layer, Shape, and Cream Type
-- This helps bakers know how many sheets to cut for each combination
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
        
        -- Extract Layer: Default to 'Double', only override if Special Request says 'Triple'
        CASE 
            WHEN o.SpecialInstructions LIKE '%Triple%' OR o.SpecialInstructions LIKE '%triple%' THEN 'Triple'
            WHEN i.ProductName LIKE '%Triple%' OR i.ProductName LIKE '%TL%' THEN 'Triple'
            ELSE 'Double' -- Always default to Double
        END AS Layer,
        
        -- Extract Shape: SHAPES ONLY - Heart, Bible, Figure, Round, Square, Rectangle, Oval
        -- Flavours (Blackforest, Red velvet, etc.) are NOT shapes
        CASE 
            -- Shape overrides from SpecialInstructions dropdown (highest priority - exact shape keywords only)
            WHEN o.SpecialInstructions LIKE '%Heart Shape%' OR o.SpecialInstructions LIKE '%Heart shape%' OR o.SpecialInstructions LIKE '%heart shape%' THEN 'Heart'
            WHEN o.SpecialInstructions LIKE '%Bible%' OR o.SpecialInstructions LIKE '%bible%' THEN 'Bible'
            WHEN o.SpecialInstructions = 'Figure' OR o.SpecialInstructions = 'figure' THEN 'Figure'
            WHEN o.SpecialInstructions LIKE '%Round cake%' OR o.SpecialInstructions LIKE '%round cake%' THEN 'Round'
            -- Check product name for shape keywords (MUST check before defaulting to Square)
            WHEN i.ProductName LIKE '%Figure%' OR i.ProductName LIKE '%figure%' THEN 'Figure'
            WHEN i.ProductName LIKE '%Round%' OR i.ProductName LIKE '%round%' THEN 'Round'
            WHEN i.ProductName LIKE '%Heart%' THEN 'Heart'
            WHEN i.ProductName LIKE '%Rectangle%' THEN 'Rectangle'
            WHEN i.ProductName LIKE '%Oval%' THEN 'Oval'
            WHEN i.ProductName LIKE '%Bible%' THEN 'Bible'
            ELSE 'Square' -- Default shape for cutting sponge layers
        END AS Shape,
        
        -- Extract Cream Type
        CASE 
            WHEN i.ProductName LIKE '%Fresh Cream%' OR i.ProductName LIKE '%Fresh-Cream%' OR i.ProductName LIKE '%FreshCream%' THEN 'Fresh Cream'
            WHEN i.ProductName LIKE '%Butter Cream%' OR i.ProductName LIKE '%Buttercream%' OR i.ProductName LIKE '%Butter-Cream%' THEN 'Butter Cream'
            ELSE 'Unknown'
        END AS CakeCream,
        
        -- Special Request: Show FLAVOURS only (not shapes)
        CASE 
            -- If SpecialInstructions is a shape keyword, check product name for flavour instead
            WHEN o.SpecialInstructions LIKE '%Heart Shape%' OR o.SpecialInstructions LIKE '%Heart shape%' OR o.SpecialInstructions LIKE '%heart shape%' THEN 
                CASE 
                    WHEN i.ProductName LIKE '%Eggless%' OR i.ProductName LIKE '%EGGLESS%' THEN 'EGGLESS'
                    WHEN i.ProductName LIKE '%Vanilla%' OR i.ProductName LIKE '%VANILLA%' OR i.ProductName LIKE '%DBL VANILLA%' THEN 'DBL VANILLA'
                    WHEN i.ProductName LIKE '%Chocolate%' OR i.ProductName LIKE '%CHOCOLATE%' THEN 'CHOCOLATE'
                    WHEN i.ProductName LIKE '%Strawberry%' OR i.ProductName LIKE '%STRAWBERRY%' THEN 'STRAWBERRY'
                    ELSE ''
                END
            WHEN o.SpecialInstructions LIKE '%Bible%' OR o.SpecialInstructions LIKE '%bible%' THEN 
                CASE 
                    WHEN i.ProductName LIKE '%Eggless%' OR i.ProductName LIKE '%EGGLESS%' THEN 'EGGLESS'
                    WHEN i.ProductName LIKE '%Vanilla%' OR i.ProductName LIKE '%VANILLA%' OR i.ProductName LIKE '%DBL VANILLA%' THEN 'DBL VANILLA'
                    WHEN i.ProductName LIKE '%Chocolate%' OR i.ProductName LIKE '%CHOCOLATE%' THEN 'CHOCOLATE'
                    WHEN i.ProductName LIKE '%Strawberry%' OR i.ProductName LIKE '%STRAWBERRY%' THEN 'STRAWBERRY'
                    ELSE ''
                END
            WHEN o.SpecialInstructions = 'Figure' OR o.SpecialInstructions = 'figure' THEN 
                CASE 
                    WHEN i.ProductName LIKE '%Eggless%' OR i.ProductName LIKE '%EGGLESS%' THEN 'EGGLESS'
                    WHEN i.ProductName LIKE '%Vanilla%' OR i.ProductName LIKE '%VANILLA%' OR i.ProductName LIKE '%DBL VANILLA%' THEN 'DBL VANILLA'
                    WHEN i.ProductName LIKE '%Chocolate%' OR i.ProductName LIKE '%CHOCOLATE%' THEN 'CHOCOLATE'
                    WHEN i.ProductName LIKE '%Strawberry%' OR i.ProductName LIKE '%STRAWBERRY%' THEN 'STRAWBERRY'
                    ELSE ''
                END
            -- Show actual flavour/special requirements from SpecialInstructions
            WHEN o.SpecialInstructions IS NOT NULL AND LEN(LTRIM(RTRIM(o.SpecialInstructions))) > 0 
                THEN LTRIM(RTRIM(o.SpecialInstructions))
            -- Fallback to product name for flavour
            WHEN i.ProductName LIKE '%Eggless%' OR i.ProductName LIKE '%EGGLESS%' THEN 'EGGLESS'
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
        -- Layer
        CASE 
            WHEN o.SpecialInstructions LIKE '%Triple%' OR o.SpecialInstructions LIKE '%triple%' THEN 'Triple'
            WHEN i.ProductName LIKE '%Triple%' OR i.ProductName LIKE '%TL%' THEN 'Triple'
            ELSE 'Double'
        END,
        -- Shape (must match SELECT clause)
        CASE 
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
        END
        ,
        -- Cream Type
        CASE 
            WHEN i.ProductName LIKE '%Fresh Cream%' OR i.ProductName LIKE '%Fresh-Cream%' OR i.ProductName LIKE '%FreshCream%' THEN 'Fresh Cream'
            WHEN i.ProductName LIKE '%Butter Cream%' OR i.ProductName LIKE '%Buttercream%' OR i.ProductName LIKE '%Butter-Cream%' THEN 'Butter Cream'
            ELSE 'Unknown'
        END,
        -- Special Request (must match SELECT clause exactly)
        CASE 
            WHEN o.SpecialInstructions LIKE '%Heart Shape%' OR o.SpecialInstructions LIKE '%Heart shape%' OR o.SpecialInstructions LIKE '%heart shape%' THEN 
                CASE 
                    WHEN i.ProductName LIKE '%Eggless%' OR i.ProductName LIKE '%EGGLESS%' THEN 'EGGLESS'
                    WHEN i.ProductName LIKE '%Vanilla%' OR i.ProductName LIKE '%VANILLA%' OR i.ProductName LIKE '%DBL VANILLA%' THEN 'DBL VANILLA'
                    WHEN i.ProductName LIKE '%Chocolate%' OR i.ProductName LIKE '%CHOCOLATE%' THEN 'CHOCOLATE'
                    WHEN i.ProductName LIKE '%Strawberry%' OR i.ProductName LIKE '%STRAWBERRY%' THEN 'STRAWBERRY'
                    ELSE ''
                END
            WHEN o.SpecialInstructions LIKE '%Bible%' OR o.SpecialInstructions LIKE '%bible%' THEN 
                CASE 
                    WHEN i.ProductName LIKE '%Eggless%' OR i.ProductName LIKE '%EGGLESS%' THEN 'EGGLESS'
                    WHEN i.ProductName LIKE '%Vanilla%' OR i.ProductName LIKE '%VANILLA%' OR i.ProductName LIKE '%DBL VANILLA%' THEN 'DBL VANILLA'
                    WHEN i.ProductName LIKE '%Chocolate%' OR i.ProductName LIKE '%CHOCOLATE%' THEN 'CHOCOLATE'
                    WHEN i.ProductName LIKE '%Strawberry%' OR i.ProductName LIKE '%STRAWBERRY%' THEN 'STRAWBERRY'
                    ELSE ''
                END
            WHEN o.SpecialInstructions = 'Figure' OR o.SpecialInstructions = 'figure' THEN 
                CASE 
                    WHEN i.ProductName LIKE '%Eggless%' OR i.ProductName LIKE '%EGGLESS%' THEN 'EGGLESS'
                    WHEN i.ProductName LIKE '%Vanilla%' OR i.ProductName LIKE '%VANILLA%' OR i.ProductName LIKE '%DBL VANILLA%' THEN 'DBL VANILLA'
                    WHEN i.ProductName LIKE '%Chocolate%' OR i.ProductName LIKE '%CHOCOLATE%' THEN 'CHOCOLATE'
                    WHEN i.ProductName LIKE '%Strawberry%' OR i.ProductName LIKE '%STRAWBERRY%' THEN 'STRAWBERRY'
                    ELSE ''
                END
            WHEN o.SpecialInstructions IS NOT NULL AND LEN(LTRIM(RTRIM(o.SpecialInstructions))) > 0 
                THEN LTRIM(RTRIM(o.SpecialInstructions))
            WHEN i.ProductName LIKE '%Eggless%' OR i.ProductName LIKE '%EGGLESS%' THEN 'EGGLESS'
            WHEN i.ProductName LIKE '%Vanilla%' OR i.ProductName LIKE '%VANILLA%' OR i.ProductName LIKE '%DBL VANILLA%' THEN 'DBL VANILLA'
            WHEN i.ProductName LIKE '%Chocolate%' OR i.ProductName LIKE '%CHOCOLATE%' THEN 'CHOCOLATE'
            WHEN i.ProductName LIKE '%Strawberry%' OR i.ProductName LIKE '%STRAWBERRY%' THEN 'STRAWBERRY'
            ELSE ''
        END
    
    ORDER BY 
        Size,
        Layer,
        Shape,
        CakeCream,
        SpecialRequest;
END
GO

PRINT 'sp_GetCakeSheetCuttingSummary created successfully';
GO
