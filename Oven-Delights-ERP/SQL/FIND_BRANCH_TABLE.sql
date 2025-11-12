-- Find the correct branch table name
SELECT 
    TABLE_NAME,
    TABLE_SCHEMA
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%Branch%'
ORDER BY TABLE_NAME;

-- Check for common branch/location tables
SELECT 
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME IN ('Branch', 'Branches', 'Demo_Branch', 'Location', 'Locations', 'Store', 'Stores')
ORDER BY TABLE_NAME;
