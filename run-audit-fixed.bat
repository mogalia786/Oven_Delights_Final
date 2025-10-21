@echo off
echo =============================
echo COMPREHENSIVE ERP AUDIT
echo =============================
echo.
echo This will automatically:
echo - Fix any build issues
echo - Launch ERP application  
echo - Run for 2 minutes of testing
echo - Close automatically
echo.
echo No user interaction required!
echo.

cd /d "c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP"

echo Starting automated build fix and audit...
powershell -ExecutionPolicy Bypass -File "fix-build-and-run.ps1"

echo.
echo =============================
echo AUDIT COMPLETED
echo =============================
echo Check above output for results
echo.
pause
