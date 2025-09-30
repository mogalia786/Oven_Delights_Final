@echo off
echo Fixing Retail Point of Sale Permissions...
echo.

sqlcmd -S tcp:mogalia.database.windows.net,1433 -d Oven_Delights_Main -U mogalia786 -P "Mogalia@786" -i "FixRetailPermissions.sql" -o "FixRetailPermissions_Output.txt"

if %errorlevel% equ 0 (
    echo.
    echo Retail permissions fixed successfully!
    echo Check FixRetailPermissions_Output.txt for details.
) else (
    echo.
    echo Error fixing Retail permissions. Check FixRetailPermissions_Output.txt for details.
)

echo.
pause
