@echo off
echo FINAL FIX for All Administration Module Issues...

echo.
echo 1. Adding LastName column to Users table...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'LastName') BEGIN ALTER TABLE Users ADD LastName NVARCHAR(50) NULL; UPDATE Users SET LastName = Username WHERE LastName IS NULL; ALTER TABLE Users ALTER COLUMN LastName NVARCHAR(50) NOT NULL; PRINT 'LastName column added and populated' END ELSE PRINT 'LastName column exists'"

echo.
echo 2. Dropping and recreating SystemSettings with minimal structure...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "IF OBJECT_ID('SystemSettings','U') IS NOT NULL DROP TABLE SystemSettings; CREATE TABLE SystemSettings (ID INT IDENTITY(1,1) PRIMARY KEY, K NVARCHAR(20) NOT NULL, V NVARCHAR(MAX) NULL); PRINT 'SystemSettings recreated with minimal structure'"

echo.
echo 3. Creating RolePermissions table for Role Access Control...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "IF OBJECT_ID('RolePermissions','U') IS NULL BEGIN CREATE TABLE RolePermissions (ID INT IDENTITY(1,1) PRIMARY KEY, RoleID INT NOT NULL, ModuleName NVARCHAR(50) NOT NULL, CanRead BIT DEFAULT 0, CanWrite BIT DEFAULT 0, UNIQUE(RoleID, ModuleName)); PRINT 'RolePermissions table created' END ELSE PRINT 'RolePermissions exists'"

echo.
echo 4. Building application...
dotnet build --verbosity minimal

echo.
echo FINAL Administration Fix Complete!
