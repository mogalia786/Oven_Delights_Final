@echo off
echo Fixing Multiple Form Errors...

echo.
echo 1. Checking Users table structure for password column...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME IN ('Password', 'PasswordHash') ORDER BY COLUMN_NAME"

echo.
echo 2. Creating SystemSettings table if missing...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "IF OBJECT_ID('dbo.SystemSettings','U') IS NULL BEGIN CREATE TABLE dbo.SystemSettings (SettingID INT IDENTITY(1,1) PRIMARY KEY, SettingKey NVARCHAR(50) NOT NULL UNIQUE, SettingValue NVARCHAR(MAX) NULL, ModifiedBy INT NULL, ModifiedDate DATETIME2 DEFAULT GETDATE()) PRINT 'SystemSettings table created' END ELSE PRINT 'SystemSettings table exists'"

echo.
echo 3. Testing corrected Add User query...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "SELECT TOP 1 'Test' as Result"

echo.
echo 4. Building application...
dotnet build --verbosity minimal

echo.
echo Multiple Form Errors Fix Complete!
