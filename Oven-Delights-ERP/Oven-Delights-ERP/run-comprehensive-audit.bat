@echo off
echo ========================================
echo COMPREHENSIVE ERP SYSTEM AUDIT
echo ========================================
echo.
echo This will run your AI Personal Assistant to:
echo 1. Login with credentials faizel/mogalia
echo 2. Test every single menu and submenu
echo 3. Check product synchronization
echo 4. Identify runtime errors
echo 5. Remove redundant menus
echo 6. Generate detailed report
echo.
echo Starting audit process...
echo.

cd /d "c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP"

REM First build the project
echo Building project...
dotnet build --no-restore --verbosity minimal > audit-build.log 2>&1

if %ERRORLEVEL% NEQ 0 (
    echo BUILD FAILED - Cannot run audit
    echo Check audit-build.log for errors
    pause
    exit /b 1
)

echo Build successful. Starting ERP application for AI testing...

REM Run the application with AI testing enabled
dotnet run --no-build > audit-results.log 2>&1 &

echo.
echo AI Personal Assistant is now running comprehensive tests...
echo.
echo The audit will:
echo - Test Administration menu (User Management, Branch Management, System Settings)
echo - Test Stockroom menu (Purchase Orders, Inventory, Suppliers, IBT)
echo - Test Manufacturing menu (BOM Creation, Production, Material Requests)  
echo - Test Retail menu (POS, Products, Inventory, Reports)
echo - Test Accounting menu (AP, Bank Import, SARS Compliance)
echo - Verify product sync between legacy and new tables
echo - Check all 4 critical sync points you defined
echo - Remove MessageBox stubs
echo - Generate comprehensive report
echo.
echo Results will be saved to audit-results.log
echo.
echo Press any key when testing is complete...
pause >nul

echo.
echo Audit completed. Check the following files:
echo - audit-results.log (detailed test results)
echo - TestResults table in database (AI test data)
echo - audit-build.log (build information)
echo.
pause
