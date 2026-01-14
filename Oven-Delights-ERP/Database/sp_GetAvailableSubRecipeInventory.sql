-- =============================================
-- Get Available Sub-Recipe Inventory
-- Returns available sub-recipes with freshness indicators
-- =============================================
CREATE OR ALTER PROCEDURE sp_GetAvailableSubRecipeInventory
    @SubRecipeID INT = NULL,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        i.InventoryID,
        i.SubRecipeID,
        i.SubRecipeName,
        i.BatchNumber,
        i.Quantity,
        i.UnitOfMeasure,
        i.ManufacturedDate,
        i.ManufacturedTime,
        i.ExpiryDate,
        i.BranchID,
        b.BranchName,
        i.ManufacturedBy,
        u.Username AS ManufacturedByName,
        i.Status,
        i.Notes,
        -- Calculate age in hours
        DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) AS AgeInHours,
        -- Calculate age in days
        DATEDIFF(DAY, i.ManufacturedDate, GETDATE()) AS AgeInDays,
        -- Freshness indicator (for color coding)
        CASE 
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 24 THEN 'VeryFresh' -- 0-24 hours: Dark Green
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 48 THEN 'Fresh'     -- 24-48 hours: Green
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 72 THEN 'Good'      -- 48-72 hours: Light Green
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 120 THEN 'Aging'    -- 72-120 hours: Yellow
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 168 THEN 'Old'      -- 120-168 hours: Orange
            ELSE 'VeryOld'                                                              -- >168 hours (7 days): Red
        END AS FreshnessLevel,
        -- Priority for FIFO consumption (oldest first)
        ROW_NUMBER() OVER (PARTITION BY i.SubRecipeID, i.BranchID ORDER BY i.ManufacturedDate ASC) AS ConsumptionPriority
    FROM 
        Demo_SubRecipe_Inventory i
        INNER JOIN Branches b ON i.BranchID = b.BranchID
        LEFT JOIN Users u ON i.ManufacturedBy = u.UserID
    WHERE 
        i.Status = 'Available'
        AND (@SubRecipeID IS NULL OR i.SubRecipeID = @SubRecipeID)
        AND (@BranchID IS NULL OR i.BranchID = @BranchID)
    ORDER BY 
        i.SubRecipeName,
        i.ManufacturedDate ASC -- FIFO: Oldest first
END
GO

PRINT 'sp_GetAvailableSubRecipeInventory created successfully'
GO
