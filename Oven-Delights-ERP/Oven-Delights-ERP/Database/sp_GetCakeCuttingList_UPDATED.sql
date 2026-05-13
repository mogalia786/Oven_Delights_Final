-- =============================================
-- Stored Procedure: sp_GetCakeCuttingList
-- Purpose: Generate cutting list for cake manufacturing
-- UPDATED: Now reads from ManufacturingInstructions field with structured data
-- Format: Layer: [Single/Double/Triple] | Cream: [Buttercream/Freshcream] | Flavour: [detected] | Shape: [detected] | Special: [text]
-- =============================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetCakeCuttingList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_GetCakeCuttingList]
GO

CREATE PROCEDURE [dbo].[sp_GetCakeCuttingList]
    @ReadyDate DATE,
    @BranchID INT = NULL -- NULL = All branches
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Helper function to extract value from ManufacturingInstructions
    -- Format: "Layer: Single | Cream: Buttercream | Flavour: Double Vanilla | Shape: Bible | Special: Bible  Double vanilla"
    
    -- Combine orders from both POS_UserDefinedOrders and POS_CustomOrders
    SELECT 
        b.BranchName AS CollectionPoint,
        o.BranchID,
        o.CollectionTime AS ReadyTime,
        
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
            WHEN o.SpecialRequest LIKE '%Triple%' OR o.SpecialRequest LIKE '%triple%' THEN 'Triple'
            WHEN i.ProductName LIKE '%Triple%' OR i.ProductName LIKE '%TL%' THEN 'Triple'
            ELSE 'Double' -- Always default to Double
        END AS Layer,
        
        -- Extract Shape: PRIORITY ORDER
        -- 1. SpecialRequest dropdown with EXACT shape keywords (Heart Shape, Bible, Figure, Round cake)
        -- 2. Product name with shape keywords (Figure, Round, Heart, etc.)
        -- 3. Default to Square
        CASE 
            -- Shape overrides from SpecialRequest dropdown (only exact shape keywords)
            WHEN o.SpecialRequest LIKE '%Heart Shape%' OR o.SpecialRequest LIKE '%Heart shape%' OR o.SpecialRequest LIKE '%heart shape%' THEN 'Heart'
            WHEN o.SpecialRequest LIKE '%Bible%' OR o.SpecialRequest LIKE '%bible%' THEN 'Bible'
            WHEN o.SpecialRequest = 'Figure' OR o.SpecialRequest = 'figure' THEN 'Figure'
            WHEN o.SpecialRequest LIKE '%Round cake%' OR o.SpecialRequest LIKE '%round cake%' THEN 'Round'
            -- Check product name for shape keywords (CRITICAL: must check before defaulting)
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
            WHEN i.ProductName LIKE '%Butter Cream%' OR i.ProductName LIKE '%Buttercream%' OR i.ProductName LIKE '%Butter-Cream%' THEN 'Buttercream'
            ELSE 'Buttercream' -- Default to Buttercream
        END AS CakeCream,
        
        -- Special Request: Show FLAVOURS only (not shapes)
        CASE 
            -- If SpecialRequest is a shape keyword, check product name for flavour instead
            WHEN o.SpecialRequest LIKE '%Heart Shape%' OR o.SpecialRequest LIKE '%Heart shape%' OR o.SpecialRequest LIKE '%heart shape%' THEN 
                CASE 
                    WHEN i.ProductName LIKE '%Eggless%' OR i.ProductName LIKE '%EGGLESS%' THEN 'EGGLESS'
                    WHEN i.ProductName LIKE '%Vanilla%' OR i.ProductName LIKE '%VANILLA%' OR i.ProductName LIKE '%DBL VANILLA%' THEN 'DBL VANILLA'
                    WHEN i.ProductName LIKE '%Chocolate%' OR i.ProductName LIKE '%CHOCOLATE%' THEN 'CHOCOLATE'
                    WHEN i.ProductName LIKE '%Strawberry%' OR i.ProductName LIKE '%STRAWBERRY%' THEN 'STRAWBERRY'
                    ELSE ''
                END
            WHEN o.SpecialRequest LIKE '%Bible%' OR o.SpecialRequest LIKE '%bible%' THEN 
                CASE 
                    WHEN i.ProductName LIKE '%Eggless%' OR i.ProductName LIKE '%EGGLESS%' THEN 'EGGLESS'
                    WHEN i.ProductName LIKE '%Vanilla%' OR i.ProductName LIKE '%VANILLA%' OR i.ProductName LIKE '%DBL VANILLA%' THEN 'DBL VANILLA'
                    WHEN i.ProductName LIKE '%Chocolate%' OR i.ProductName LIKE '%CHOCOLATE%' THEN 'CHOCOLATE'
                    WHEN i.ProductName LIKE '%Strawberry%' OR i.ProductName LIKE '%STRAWBERRY%' THEN 'STRAWBERRY'
                    ELSE ''
                END
            WHEN o.SpecialRequest = 'Figure' OR o.SpecialRequest = 'figure' THEN 
                CASE 
                    WHEN i.ProductName LIKE '%Eggless%' OR i.ProductName LIKE '%EGGLESS%' THEN 'EGGLESS'
                    WHEN i.ProductName LIKE '%Vanilla%' OR i.ProductName LIKE '%VANILLA%' OR i.ProductName LIKE '%DBL VANILLA%' THEN 'DBL VANILLA'
                    WHEN i.ProductName LIKE '%Chocolate%' OR i.ProductName LIKE '%CHOCOLATE%' THEN 'CHOCOLATE'
                    WHEN i.ProductName LIKE '%Strawberry%' OR i.ProductName LIKE '%STRAWBERRY%' THEN 'STRAWBERRY'
                    ELSE ''
                END
            -- Show actual flavour/special requirements from dropdown
            WHEN o.SpecialRequest IS NOT NULL AND LEN(LTRIM(RTRIM(o.SpecialRequest))) > 0 
                THEN LTRIM(RTRIM(o.SpecialRequest))
            -- Fallback to product name for flavour
            WHEN i.ProductName LIKE '%Eggless%' OR i.ProductName LIKE '%EGGLESS%' THEN 'EGGLESS'
            WHEN i.ProductName LIKE '%Vanilla%' OR i.ProductName LIKE '%VANILLA%' OR i.ProductName LIKE '%DBL VANILLA%' THEN 'DBL VANILLA'
            WHEN i.ProductName LIKE '%Chocolate%' OR i.ProductName LIKE '%CHOCOLATE%' THEN 'CHOCOLATE'
            WHEN i.ProductName LIKE '%Strawberry%' OR i.ProductName LIKE '%STRAWBERRY%' THEN 'STRAWBERRY'
            WHEN i.ProductName LIKE '%FIG%ON%BASE%' THEN SUBSTRING(i.ProductName, CHARINDEX('FIG', i.ProductName), 15)
            WHEN i.ProductName LIKE '%HALF%HALF%' THEN 'HALF & HALF'
            ELSE ''
        END AS SpecialRequest,
        
        -- Total quantity for this combination
        SUM(i.Quantity) AS Total,
        
        -- Completed quantity (UserDefinedOrders don't track completion at item level)
        0 AS QtyCompleted,
        
        -- Remaining quantity to manufacture
        SUM(i.Quantity) AS Remaining
        
    FROM POS_UserDefinedOrders o
    INNER JOIN POS_UserDefinedOrderItems i ON o.UserDefinedOrderID = i.UserDefinedOrderID
    INNER JOIN Branches b ON o.BranchID = b.BranchID
    
    WHERE o.CollectionDate = @ReadyDate
        AND o.Status IN ('Created', 'InProgress', 'Completed') -- Include Completed status for manufacturing
        AND o.Status <> 'Cancelled' -- Exclude cancelled orders
        AND (@BranchID IS NULL OR o.BranchID = @BranchID)
    
    GROUP BY 
        b.BranchName,
        o.BranchID,
        o.CollectionTime,
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
            WHEN o.SpecialRequest LIKE '%Triple%' OR o.SpecialRequest LIKE '%triple%' THEN 'Triple'
            WHEN i.ProductName LIKE '%Triple%' OR i.ProductName LIKE '%TL%' THEN 'Triple'
            ELSE 'Double'
        END,
        -- Shape (must match SELECT clause)
        CASE 
            WHEN o.SpecialRequest LIKE '%Heart Shape%' OR o.SpecialRequest LIKE '%Heart shape%' OR o.SpecialRequest LIKE '%heart shape%' THEN 'Heart'
            WHEN o.SpecialRequest LIKE '%Bible%' OR o.SpecialRequest LIKE '%bible%' THEN 'Bible'
            WHEN o.SpecialRequest = 'Figure' OR o.SpecialRequest = 'figure' THEN 'Figure'
            WHEN o.SpecialRequest LIKE '%Round cake%' OR o.SpecialRequest LIKE '%round cake%' THEN 'Round'
            WHEN i.ProductName LIKE '%Figure%' OR i.ProductName LIKE '%figure%' THEN 'Figure'
            WHEN i.ProductName LIKE '%Round%' OR i.ProductName LIKE '%round%' THEN 'Round'
            WHEN i.ProductName LIKE '%Heart%' THEN 'Heart'
            WHEN i.ProductName LIKE '%Rectangle%' THEN 'Rectangle'
            WHEN i.ProductName LIKE '%Oval%' THEN 'Oval'
            WHEN i.ProductName LIKE '%Bible%' THEN 'Bible'
            ELSE 'Square'
        END,
        -- Cream Type
        CASE 
            WHEN i.ProductName LIKE '%Fresh Cream%' OR i.ProductName LIKE '%Fresh-Cream%' OR i.ProductName LIKE '%FreshCream%' THEN 'Fresh Cream'
            WHEN i.ProductName LIKE '%Butter Cream%' OR i.ProductName LIKE '%Buttercream%' OR i.ProductName LIKE '%Butter-Cream%' THEN 'Buttercream'
            ELSE 'Buttercream'
        END,
        -- Special Request (must match SELECT clause exactly)
        CASE 
            WHEN o.SpecialRequest LIKE '%Heart Shape%' OR o.SpecialRequest LIKE '%Heart shape%' OR o.SpecialRequest LIKE '%heart shape%' THEN 
                CASE 
                    WHEN i.ProductName LIKE '%Eggless%' OR i.ProductName LIKE '%EGGLESS%' THEN 'EGGLESS'
                    WHEN i.ProductName LIKE '%Vanilla%' OR i.ProductName LIKE '%VANILLA%' OR i.ProductName LIKE '%DBL VANILLA%' THEN 'DBL VANILLA'
                    WHEN i.ProductName LIKE '%Chocolate%' OR i.ProductName LIKE '%CHOCOLATE%' THEN 'CHOCOLATE'
                    WHEN i.ProductName LIKE '%Strawberry%' OR i.ProductName LIKE '%STRAWBERRY%' THEN 'STRAWBERRY'
                    ELSE ''
                END
            WHEN o.SpecialRequest LIKE '%Bible%' OR o.SpecialRequest LIKE '%bible%' THEN 
                CASE 
                    WHEN i.ProductName LIKE '%Eggless%' OR i.ProductName LIKE '%EGGLESS%' THEN 'EGGLESS'
                    WHEN i.ProductName LIKE '%Vanilla%' OR i.ProductName LIKE '%VANILLA%' OR i.ProductName LIKE '%DBL VANILLA%' THEN 'DBL VANILLA'
                    WHEN i.ProductName LIKE '%Chocolate%' OR i.ProductName LIKE '%CHOCOLATE%' THEN 'CHOCOLATE'
                    WHEN i.ProductName LIKE '%Strawberry%' OR i.ProductName LIKE '%STRAWBERRY%' THEN 'STRAWBERRY'
                    ELSE ''
                END
            WHEN o.SpecialRequest = 'Figure' OR o.SpecialRequest = 'figure' THEN 
                CASE 
                    WHEN i.ProductName LIKE '%Eggless%' OR i.ProductName LIKE '%EGGLESS%' THEN 'EGGLESS'
                    WHEN i.ProductName LIKE '%Vanilla%' OR i.ProductName LIKE '%VANILLA%' OR i.ProductName LIKE '%DBL VANILLA%' THEN 'DBL VANILLA'
                    WHEN i.ProductName LIKE '%Chocolate%' OR i.ProductName LIKE '%CHOCOLATE%' THEN 'CHOCOLATE'
                    WHEN i.ProductName LIKE '%Strawberry%' OR i.ProductName LIKE '%STRAWBERRY%' THEN 'STRAWBERRY'
                    ELSE ''
                END
            WHEN o.SpecialRequest IS NOT NULL AND LEN(LTRIM(RTRIM(o.SpecialRequest))) > 0 
                THEN LTRIM(RTRIM(o.SpecialRequest))
            WHEN i.ProductName LIKE '%Eggless%' OR i.ProductName LIKE '%EGGLESS%' THEN 'EGGLESS'
            WHEN i.ProductName LIKE '%Vanilla%' OR i.ProductName LIKE '%VANILLA%' OR i.ProductName LIKE '%DBL VANILLA%' THEN 'DBL VANILLA'
            WHEN i.ProductName LIKE '%Chocolate%' OR i.ProductName LIKE '%CHOCOLATE%' THEN 'CHOCOLATE'
            WHEN i.ProductName LIKE '%Strawberry%' OR i.ProductName LIKE '%STRAWBERRY%' THEN 'STRAWBERRY'
            WHEN i.ProductName LIKE '%FIG%ON%BASE%' THEN SUBSTRING(i.ProductName, CHARINDEX('FIG', i.ProductName), 15)
            WHEN i.ProductName LIKE '%HALF%HALF%' THEN 'HALF & HALF'
            ELSE ''
        END
    
    
    UNION ALL
    
    -- POS_CustomOrders - NOW READS FROM ManufacturingInstructions field
    SELECT 
        b.BranchName AS CollectionPoint,
        o.BranchID,
        o.ReadyTime,
        
        -- Extract Size from product name
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
            WHEN o.SpecialInstructions LIKE '%Figure%' OR o.SpecialInstructions LIKE '%figure%' THEN 'Figure'
            WHEN o.SpecialInstructions LIKE '%Doll cake%' OR o.SpecialInstructions LIKE '%doll cake%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Round cake%' OR o.SpecialInstructions LIKE '%round cake%' THEN 'Round'
            WHEN i.ProductName LIKE '%Round%' OR i.ProductName LIKE '%round%' THEN 'Round'
            WHEN i.ProductName LIKE '%Heart%' THEN 'Heart'
            WHEN i.ProductName LIKE '%Rectangle%' THEN 'Rectangle'
            WHEN i.ProductName LIKE '%Oval%' THEN 'Oval'
            ELSE 'Square'
        END AS Shape,
        
        -- Extract Cream Type from ManufacturingInstructions (Format: "... | Cream: Buttercream | ...")
        CASE 
            WHEN o.ManufacturingInstructions LIKE '%Cream: Buttercream%' THEN 'Buttercream'
            WHEN o.ManufacturingInstructions LIKE '%Cream: Freshcream%' THEN 'Fresh Cream'
            WHEN o.ManufacturingInstructions LIKE '%Cream: Fresh Cream%' THEN 'Fresh Cream'
            -- Fallback to product name
            WHEN i.ProductName LIKE '%Fresh Cream%' OR i.ProductName LIKE '%Fresh-Cream%' OR i.ProductName LIKE '%FreshCream%' THEN 'Fresh Cream'
            WHEN i.ProductName LIKE '%Butter Cream%' OR i.ProductName LIKE '%Buttercream%' OR i.ProductName LIKE '%Butter-Cream%' THEN 'Buttercream'
            ELSE 'Buttercream'
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
        
        SUM(i.Quantity) AS Total,
        SUM(ISNULL(i.QtyCompleted, 0)) AS QtyCompleted,
        SUM(i.Quantity) - SUM(ISNULL(i.QtyCompleted, 0)) AS Remaining
        
    FROM POS_CustomOrders o
    INNER JOIN POS_CustomOrderItems i ON o.OrderID = i.OrderID
    INNER JOIN Branches b ON o.BranchID = b.BranchID
    
    WHERE o.ReadyDate = @ReadyDate
        AND o.OrderStatus IN ('New', 'InProgress', 'Ready')
        AND o.OrderStatus <> 'Cancelled'
        AND (@BranchID IS NULL OR o.BranchID = @BranchID)
    
    GROUP BY 
        b.BranchName,
        o.BranchID,
        o.ReadyTime,
        o.ManufacturingInstructions,
        o.SpecialInstructions,
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
        ReadyTime ASC,
        CollectionPoint,
        Size,
        Layer,
        Shape,
        CakeCream;
END
GO

PRINT 'sp_GetCakeCuttingList created successfully with ManufacturingInstructions parsing';
GO
