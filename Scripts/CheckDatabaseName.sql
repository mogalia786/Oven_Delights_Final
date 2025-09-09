-- Check current database
SELECT DB_NAME() AS CurrentDatabase;

-- List all databases on the server
SELECT name FROM sys.databases WHERE database_id > 4; -- Skip system databases
