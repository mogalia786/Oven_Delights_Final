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
        
        -- Extract Shape: Check SpecialRequest for special cake types that override shape
        CASE 
            -- Special cake types that override shape to 'Special'
            WHEN o.SpecialInstructions LIKE '%Doll cake%' OR o.SpecialInstructions LIKE '%doll cake%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Figure%' OR o.SpecialInstructions LIKE '%figure%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Figure on base%' OR o.SpecialInstructions LIKE '%figure on base%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Eggless Figure%' OR o.SpecialInstructions LIKE '%eggless figure%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Eggless Figure on base%' OR o.SpecialInstructions LIKE '%eggless figure on base%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%1mx 500%' OR o.SpecialInstructions LIKE '%1mx500%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%1mx 500 eggless%' OR o.SpecialInstructions LIKE '%1mx500 eggless%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Bar one%' OR o.SpecialInstructions LIKE '%bar one%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Ferrero%' OR o.SpecialInstructions LIKE '%ferrero%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Milky bar%' OR o.SpecialInstructions LIKE '%milky bar%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Blackforest%' OR o.SpecialInstructions LIKE '%blackforest%' OR o.SpecialInstructions LIKE '%Black forest%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Red velvet%' OR o.SpecialInstructions LIKE '%red velvet%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Carrot cake%' OR o.SpecialInstructions LIKE '%carrot cake%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Soccerfield%' OR o.SpecialInstructions LIKE '%soccerfield%' OR o.SpecialInstructions LIKE '%Soccer field%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Mould%' OR o.SpecialInstructions LIKE '%mould%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Novelty%' OR o.SpecialInstructions LIKE '%novelty%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Tiered sponge%' OR o.SpecialInstructions LIKE '%tiered sponge%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Tiered fruit%' OR o.SpecialInstructions LIKE '%tiered fruit%' THEN 'Special'
            -- Regular shape overrides from SpecialInstructions
            WHEN o.SpecialInstructions LIKE '%Heart shape%' OR o.SpecialInstructions LIKE '%heart shape%' OR o.SpecialInstructions LIKE '%Heart%' OR o.SpecialInstructions LIKE '%heart%' THEN 'Heart'
            WHEN o.SpecialInstructions LIKE '%Bible%' OR o.SpecialInstructions LIKE '%bible%' THEN 'Bible'
            WHEN o.SpecialInstructions LIKE '%Round cake%' OR o.SpecialInstructions LIKE '%round cake%' THEN 'Round'
            -- Check product name for shape keywords
            WHEN i.ProductName LIKE '%Figure%' THEN 'Figure'
            WHEN i.ProductName LIKE '%Round%' OR i.ProductName LIKE '%round%' THEN 'Round'
            WHEN i.ProductName LIKE '%Heart%' THEN 'Heart'
            WHEN i.ProductName LIKE '%Rectangle%' THEN 'Rectangle'
            WHEN i.ProductName LIKE '%Oval%' THEN 'Oval'
            WHEN i.ProductName LIKE '%Bible%' THEN 'Bible'
            ELSE 'Square' -- Default shape
        END AS Shape,
        
        -- Extract Cream Type
        CASE 
            WHEN i.ProductName LIKE '%Fresh Cream%' OR i.ProductName LIKE '%Fresh-Cream%' OR i.ProductName LIKE '%FreshCream%' THEN 'Fresh Cream'
            WHEN i.ProductName LIKE '%Butter Cream%' OR i.ProductName LIKE '%Buttercream%' OR i.ProductName LIKE '%Butter-Cream%' THEN 'Butter Cream'
            ELSE 'Unknown'
        END AS CakeCream,
        
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
        AND o.OrderStatus IN ('New', 'InProgress') -- Only pending orders
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
        -- Shape
        CASE 
            -- Special cake types that override shape to 'Special'
            WHEN o.SpecialInstructions LIKE '%Doll cake%' OR o.SpecialInstructions LIKE '%doll cake%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Figure%' OR o.SpecialInstructions LIKE '%figure%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Figure on base%' OR o.SpecialInstructions LIKE '%figure on base%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Eggless Figure%' OR o.SpecialInstructions LIKE '%eggless figure%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Eggless Figure on base%' OR o.SpecialInstructions LIKE '%eggless figure on base%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%1mx 500%' OR o.SpecialInstructions LIKE '%1mx500%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%1mx 500 eggless%' OR o.SpecialInstructions LIKE '%1mx500 eggless%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Bar one%' OR o.SpecialInstructions LIKE '%bar one%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Ferrero%' OR o.SpecialInstructions LIKE '%ferrero%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Milky bar%' OR o.SpecialInstructions LIKE '%milky bar%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Blackforest%' OR o.SpecialInstructions LIKE '%blackforest%' OR o.SpecialInstructions LIKE '%Black forest%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Red velvet%' OR o.SpecialInstructions LIKE '%red velvet%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Carrot cake%' OR o.SpecialInstructions LIKE '%carrot cake%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Soccerfield%' OR o.SpecialInstructions LIKE '%soccerfield%' OR o.SpecialInstructions LIKE '%Soccer field%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Mould%' OR o.SpecialInstructions LIKE '%mould%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Novelty%' OR o.SpecialInstructions LIKE '%novelty%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Tiered sponge%' OR o.SpecialInstructions LIKE '%tiered sponge%' THEN 'Special'
            WHEN o.SpecialInstructions LIKE '%Tiered fruit%' OR o.SpecialInstructions LIKE '%tiered fruit%' THEN 'Special'
            -- Regular shape overrides from SpecialInstructions
            WHEN o.SpecialInstructions LIKE '%Heart shape%' OR o.SpecialInstructions LIKE '%heart shape%' OR o.SpecialInstructions LIKE '%Heart%' OR o.SpecialInstructions LIKE '%heart%' THEN 'Heart'
            WHEN o.SpecialInstructions LIKE '%Bible%' OR o.SpecialInstructions LIKE '%bible%' THEN 'Bible'
            WHEN o.SpecialInstructions LIKE '%Round cake%' OR o.SpecialInstructions LIKE '%round cake%' THEN 'Round'
            -- Check product name for shape keywords
            WHEN i.ProductName LIKE '%Figure%' THEN 'Figure'
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
        END
    
    ORDER BY 
        Size,
        Layer,
        Shape,
        CakeCream;
END
GO

PRINT 'sp_GetCakeSheetCuttingSummary created successfully';
GO
