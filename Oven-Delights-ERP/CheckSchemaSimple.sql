-- Check if Users table exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users')
BEGIN
    PRINT 'Users table exists.';
    
    -- Get column information
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        CHARACTER_MAXIMUM_LENGTH,
        IS_NULLABLE
    FROM 
        INFORMATION_SCHEMA.COLUMNS 
    WHERE 
        TABLE_NAME = 'Users'
    ORDER BY 
        ORDINAL_POSITION;
END
ELSE
BEGIN
    PRINT 'Users table does not exist.';
    
    -- List all tables in the database
    SELECT 
        TABLE_SCHEMA,
        TABLE_NAME
    FROM 
        INFORMATION_SCHEMA.TABLES 
    WHERE 
        TABLE_TYPE = 'BASE TABLE'
    ORDER BY 
        TABLE_NAME;
END
