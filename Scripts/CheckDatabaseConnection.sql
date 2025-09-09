-- Simple query to check database connection and list tables
SELECT 'Database connection successful' AS Status;

-- Alternative way to list tables
SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM 
    INFORMATION_SCHEMA.TABLES 
WHERE 
    TABLE_TYPE = 'BASE TABLE'
ORDER BY 
    TABLE_SCHEMA, TABLE_NAME;
