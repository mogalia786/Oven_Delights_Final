-- Diagnostic query to check ManufacturedDate values
SELECT 
    InventoryID,
    SubRecipeName,
    BatchNumber,
    ManufacturedDate,
    ManufacturedTime,
    GETDATE() AS CurrentDateTime_GETDATE,
    SYSDATETIME() AS CurrentDateTime_SYSDATETIME,
    DATEDIFF(HOUR, ManufacturedDate, GETDATE()) AS AgeInHours_GETDATE,
    DATEDIFF(HOUR, ManufacturedDate, SYSDATETIME()) AS AgeInHours_SYSDATETIME,
    DATEDIFF(MINUTE, ManufacturedDate, SYSDATETIME()) AS AgeInMinutes,
    -- Show the actual datetime difference
    CAST(SYSDATETIME() AS DATETIME) - ManufacturedDate AS ActualTimeDifference
FROM Demo_SubRecipe_Inventory
WHERE Status = 'Available'
ORDER BY ManufacturedDate DESC;
