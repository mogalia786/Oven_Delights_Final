-- =============================================
-- Get Sub-Recipe Inventory Report
-- Color-coded freshness report for management
-- =============================================
CREATE OR ALTER PROCEDURE sp_GetSubRecipeInventoryReport
    @BranchID INT = NULL,
    @SubRecipeID INT = NULL,
    @FreshnessFilter NVARCHAR(20) = NULL -- 'VeryFresh', 'Fresh', 'Good', 'Aging', 'Old', 'VeryOld'
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
        FORMAT(i.ManufacturedDate, 'yyyy-MM-dd') AS ManufacturedDateFormatted,
        i.ManufacturedTime,
        FORMAT(CAST(i.ManufacturedTime AS DATETIME), 'HH:mm:ss') AS ManufacturedTimeFormatted,
        i.ExpiryDate,
        i.BranchID,
        b.BranchName,
        b.Prefix AS BranchPrefix,
        i.ManufacturedBy,
        u.Username AS ManufacturedByName,
        i.Status,
        i.Notes,
        -- Age calculations
        DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) AS AgeInHours,
        DATEDIFF(DAY, i.ManufacturedDate, GETDATE()) AS AgeInDays,
        -- Freshness level
        CASE 
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 24 THEN 'VeryFresh'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 48 THEN 'Fresh'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 72 THEN 'Good'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 120 THEN 'Aging'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 168 THEN 'Old'
            ELSE 'VeryOld'
        END AS FreshnessLevel,
        -- Color codes for UI
        CASE 
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 24 THEN 'DarkGreen'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 48 THEN 'Green'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 72 THEN 'LightGreen'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 120 THEN 'Yellow'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 168 THEN 'Orange'
            ELSE 'Red'
        END AS ColorCode,
        -- RGB values for exact color coding
        CASE 
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 24 THEN '0,100,0'      -- Dark Green
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 48 THEN '0,128,0'      -- Green
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 72 THEN '144,238,144'  -- Light Green
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 120 THEN '255,255,0'   -- Yellow
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 168 THEN '255,165,0'   -- Orange
            ELSE '255,0,0'                                                                 -- Red
        END AS RGBColor,
        -- Consumption priority (FIFO)
        ROW_NUMBER() OVER (PARTITION BY i.SubRecipeID, i.BranchID ORDER BY i.ManufacturedDate ASC) AS FIFOPriority,
        -- Summary info
        (SELECT COUNT(*) 
         FROM Demo_SubRecipe_Consumption_Log 
         WHERE InventoryID = i.InventoryID) AS TimesUsed,
        (SELECT SUM(QuantityConsumed) 
         FROM Demo_SubRecipe_Consumption_Log 
         WHERE InventoryID = i.InventoryID) AS TotalQuantityUsed
    FROM 
        Demo_SubRecipe_Inventory i
        INNER JOIN Branches b ON i.BranchID = b.BranchID
        LEFT JOIN Users u ON i.ManufacturedBy = u.UserID
    WHERE 
        i.Status = 'Available'
        AND (@BranchID IS NULL OR i.BranchID = @BranchID)
        AND (@SubRecipeID IS NULL OR i.SubRecipeID = @SubRecipeID)
        AND (@FreshnessFilter IS NULL OR 
            CASE 
                WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 24 THEN 'VeryFresh'
                WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 48 THEN 'Fresh'
                WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 72 THEN 'Good'
                WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 120 THEN 'Aging'
                WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 168 THEN 'Old'
                ELSE 'VeryOld'
            END = @FreshnessFilter
        )
    ORDER BY 
        i.SubRecipeName,
        i.ManufacturedDate ASC -- FIFO: Oldest first
END
GO

PRINT 'sp_GetSubRecipeInventoryReport created successfully'
GO
