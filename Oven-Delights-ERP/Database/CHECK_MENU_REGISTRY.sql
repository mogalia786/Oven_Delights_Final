-- Check if MenuRegistry table exists and show its structure
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MenuRegistry]') AND type in (N'U'))
BEGIN
    PRINT 'MenuRegistry table exists'
    
    -- Show columns
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        CHARACTER_MAXIMUM_LENGTH,
        IS_NULLABLE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'MenuRegistry'
    ORDER BY ORDINAL_POSITION
    
    -- Show row count
    SELECT COUNT(*) AS TotalRows FROM MenuRegistry
END
ELSE
BEGIN
    PRINT 'MenuRegistry table does NOT exist - please run CREATE_MENU_REGISTRY.sql first'
END
GO
