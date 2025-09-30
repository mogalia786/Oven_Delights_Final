@echo off
echo Fixing User Management Column Name Error...

echo.
echo 1. Checking Branches table structure...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Branches' AND COLUMN_NAME IN ('Name', 'BranchName') ORDER BY COLUMN_NAME"

echo.
echo 2. Testing corrected User Management query...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "SELECT TOP 3 u.UserID, u.Username, u.Email, ISNULL(u.IsActive, 1) AS IsActive, r.RoleName, b.BranchName, u.CreatedDate FROM Users u LEFT JOIN Roles r ON r.RoleID = u.RoleID LEFT JOIN Branches b ON b.BranchID = u.BranchID ORDER BY u.Username"

echo.
echo 3. Building application...
dotnet build --verbosity minimal

echo.
echo User Management Fix Complete!
