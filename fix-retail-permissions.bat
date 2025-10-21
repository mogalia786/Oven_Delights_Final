@echo off
echo Fixing Retail Point of Sale permissions...

echo.
echo Adding Retail module permissions for Super Administrator...
sqlcmd -S tcp:mogalia.database.windows.net,1433 -U faroq786 -P Faroq#786 -d Oven_Delights_Main -Q "INSERT INTO RolePermissions (RoleID, ModuleName, CanRead, CanWrite) SELECT r.RoleID, 'Retail', 1, 1 FROM Roles r WHERE r.RoleName = 'Super Administrator' AND NOT EXISTS (SELECT 1 FROM RolePermissions rp WHERE rp.RoleID = r.RoleID AND rp.ModuleName = 'Retail')"

echo.
echo Retail permissions fixed! Point of Sale should now be accessible.
