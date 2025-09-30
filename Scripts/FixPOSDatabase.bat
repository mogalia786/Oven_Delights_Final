@echo off
echo Creating missing POS database objects...
echo.

sqlcmd -S tcp:mogalia.database.windows.net,1433 -d Oven_Delights_Main -U mogalia786 -P "Mogalia@786" -i "..\Database\Retail\Create_Retail_CurrentPrices_View.sql" -o "FixPOSDatabase_Output.txt"

if %errorlevel% equ 0 (
    echo.
    echo POS database objects created successfully!
    echo Check FixPOSDatabase_Output.txt for details.
) else (
    echo.
    echo Error creating POS database objects. Check FixPOSDatabase_Output.txt for details.
)

echo.
pause
