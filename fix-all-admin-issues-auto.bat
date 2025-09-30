@echo off
echo Fixing All Administration Module Issues...

echo.
echo 1. Fixing Users table structure - adding FirstName column if missing...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'FirstName') BEGIN ALTER TABLE Users ADD FirstName NVARCHAR(50) NULL PRINT 'FirstName column added to Users table' END ELSE PRINT 'FirstName column already exists'"

echo.
echo 2. Updating existing users to have FirstName values...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "UPDATE Users SET FirstName = Username WHERE FirstName IS NULL OR FirstName = ''"

echo.
echo 3. Making FirstName column NOT NULL after populating data...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "ALTER TABLE Users ALTER COLUMN FirstName NVARCHAR(50) NOT NULL"

echo.
echo 4. Fixing SystemSettings table structure for shorter identifiers...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "IF OBJECT_ID('dbo.SystemSettings','U') IS NOT NULL DROP TABLE SystemSettings; CREATE TABLE dbo.SystemSettings (ID INT IDENTITY(1,1) PRIMARY KEY, SettingKey NVARCHAR(50) NOT NULL UNIQUE, SettingValue NVARCHAR(MAX) NULL, ModifiedBy INT NULL, ModifiedDate DATETIME2 DEFAULT GETDATE()) PRINT 'SystemSettings table recreated with shorter structure'"

echo.
echo 5. Building application...
dotnet build --verbosity minimal

echo.
echo All Administration Issues Fix Complete!
