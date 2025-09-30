@echo off
echo Fixing Roles Table Column Errors...

echo.
echo 1. Checking Roles table actual structure...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Roles' ORDER BY COLUMN_NAME"

echo.
echo 2. Testing corrected Roles query...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "SELECT TOP 5 RoleID, RoleName FROM Roles ORDER BY RoleName"

echo.
echo 3. Building application...
dotnet build --verbosity minimal

echo.
echo Roles Column Fix Complete!
