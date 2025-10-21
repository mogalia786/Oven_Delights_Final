@echo off
echo Fixing Add User Form IsActive Column Error...

echo.
echo 1. Testing corrected Roles query without IsActive filter...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "SELECT TOP 5 RoleID, RoleName FROM Roles ORDER BY RoleName"

echo.
echo 2. Building application...
dotnet build --verbosity minimal

echo.
echo Add User Form Fix Complete!
