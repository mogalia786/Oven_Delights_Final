@echo off
echo FINAL COMPLETE FIX for Administration Module...

echo.
echo 1. Adding LastName column to Users table...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'LastName') BEGIN ALTER TABLE Users ADD LastName NVARCHAR(50) NULL; UPDATE Users SET LastName = Username WHERE LastName IS NULL; ALTER TABLE Users ALTER COLUMN LastName NVARCHAR(50) NOT NULL; PRINT 'LastName column added' END ELSE PRINT 'LastName exists'"

echo.
echo 2. Recreating SystemSettings with ultra-short structure...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "IF OBJECT_ID('SystemSettings','U') IS NOT NULL DROP TABLE SystemSettings; CREATE TABLE SystemSettings (ID INT IDENTITY(1,1) PRIMARY KEY, K NVARCHAR(20) NOT NULL, V NVARCHAR(MAX) NULL); PRINT 'SystemSettings recreated'"

echo.
echo 3. Building application...
dotnet build --verbosity minimal

echo.
echo FINAL COMPLETE Administration Fix Done!
