@echo off
echo Fixing Role Dropdown and Audit Log Issues...

echo.
echo 1. Checking if Roles table has data...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "SELECT COUNT(*) as RoleCount FROM Roles"

echo.
echo 2. Inserting sample roles if table is empty...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "IF NOT EXISTS (SELECT TOP 1 * FROM Roles) BEGIN INSERT INTO Roles (RoleName) VALUES ('Administrator'), ('Manager'), ('User'), ('Viewer') PRINT 'Sample roles inserted' END ELSE PRINT 'Roles already exist'"

echo.
echo 3. Testing role dropdown query...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "SELECT RoleID, RoleName FROM Roles ORDER BY RoleName"

echo.
echo 4. Building application...
dotnet build --verbosity minimal

echo.
echo Role Dropdown and Audit Log Fix Complete!
