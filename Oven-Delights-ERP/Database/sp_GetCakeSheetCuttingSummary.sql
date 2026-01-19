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
        
        -- Extract Layer: "DL" for Double, blank for Single
        CASE 
            WHEN i.ProductName LIKE '%Double%' OR i.ProductName LIKE '%DL%' OR i.ProductName LIKE '%DBL%' THEN 'Double'
            ELSE 'Single'
        END AS Layer,
        
        -- Extract Shape: Square (default), Round, Figure, Heart, etc.
        CASE 
            WHEN i.ProductName LIKE '%Figure%' THEN 'Figure'
            WHEN i.ProductName LIKE '%Round%' THEN 'Round'
            WHEN i.ProductName LIKE '%Heart%' THEN 'Heart'
            WHEN i.ProductName LIKE '%Rectangle%' THEN 'Rectangle'
            WHEN i.ProductName LIKE '%Oval%' THEN 'Oval'
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
            WHEN i.ProductName LIKE '%Double%' OR i.ProductName LIKE '%DL%' OR i.ProductName LIKE '%DBL%' THEN 'Double'
            ELSE 'Single'
        END,
        -- Shape
        CASE 
            WHEN i.ProductName LIKE '%Figure%' THEN 'Figure'
            WHEN i.ProductName LIKE '%Round%' THEN 'Round'
            WHEN i.ProductName LIKE '%Heart%' THEN 'Heart'
            WHEN i.ProductName LIKE '%Rectangle%' THEN 'Rectangle'
            WHEN i.ProductName LIKE '%Oval%' THEN 'Oval'
            ELSE 'Square'
        END,
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
