-- =============================================
-- Stored Procedure: sp_GetCakeCuttingList
-- Purpose: Generate cutting list for cake manufacturing
-- Groups cake orders by Size, Layer, Shape, and Cream Type for a specific ReadyDate
-- Ordered by ReadyTime (pickup time)
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
    
    -- Parse product names to extract Size, Layer, Shape, Cream Type
    -- Size: Extract first number found in product name
    -- Layer: "DL" if Double found, else blank (single layer)
    -- Shape: Extract shape keywords, default to Square
    -- Cream: Fresh Cream or Butter Cream
    -- Special Request: Pull from SpecialInstructions field
    
    SELECT 
        b.BranchName AS CollectionPoint,
        o.BranchID,
        o.ReadyTime,
        
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
        
        -- Extract Shape: Check Special Request for 'Heart' or 'Bible', then item name for 'round', else default to 'square'
        CASE 
            WHEN o.SpecialInstructions LIKE '%Heart%' OR o.SpecialInstructions LIKE '%heart%' THEN 'Heart'
            WHEN o.SpecialInstructions LIKE '%Bible%' OR o.SpecialInstructions LIKE '%bible%' THEN 'Bible'
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
        
        -- Special Request: Pull from order SpecialInstructions + product name variants
        CASE 
            WHEN o.SpecialInstructions IS NOT NULL AND LEN(LTRIM(RTRIM(o.SpecialInstructions))) > 0 
                THEN LTRIM(RTRIM(o.SpecialInstructions))
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
        b.BranchName,
        o.BranchID,
        o.ReadyTime,
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
            WHEN o.SpecialInstructions LIKE '%Heart%' OR o.SpecialInstructions LIKE '%heart%' THEN 'Heart'
            WHEN o.SpecialInstructions LIKE '%Bible%' OR o.SpecialInstructions LIKE '%bible%' THEN 'Bible'
            WHEN i.ProductName LIKE '%Figure%' THEN 'Figure'
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
            WHEN i.ProductName LIKE '%Butter Cream%' OR i.ProductName LIKE '%Buttercream%' OR i.ProductName LIKE '%Butter-Cream%' THEN 'Butter Cream'
            ELSE 'Unknown'
        END,
        -- Special Request
        CASE 
            WHEN o.SpecialInstructions IS NOT NULL AND LEN(LTRIM(RTRIM(o.SpecialInstructions))) > 0 
                THEN LTRIM(RTRIM(o.SpecialInstructions))
            WHEN i.ProductName LIKE '%Eggless%' OR i.ProductName LIKE '%EGGLESS%' THEN 'EGGLESS'
            WHEN i.ProductName LIKE '%Vanilla%' OR i.ProductName LIKE '%VANILLA%' OR i.ProductName LIKE '%DBL VANILLA%' THEN 'DBL VANILLA'
            WHEN i.ProductName LIKE '%Chocolate%' OR i.ProductName LIKE '%CHOCOLATE%' THEN 'CHOCOLATE'
            WHEN i.ProductName LIKE '%Strawberry%' OR i.ProductName LIKE '%STRAWBERRY%' THEN 'STRAWBERRY'
            WHEN i.ProductName LIKE '%FIG%ON%BASE%' THEN SUBSTRING(i.ProductName, CHARINDEX('FIG', i.ProductName), 15)
            WHEN i.ProductName LIKE '%HALF%HALF%' THEN 'HALF & HALF'
            ELSE ''
        END
    
    ORDER BY 
        o.ReadyTime ASC,  -- Order by pickup time first
        b.BranchName,
        Size,
        Layer,
        Shape,
        CakeCream;
END
GO

PRINT 'sp_GetCakeCuttingList created successfully';
GO
