@echo off
echo Starting automated build process...
cd /d "c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP"

dotnet build --no-restore --verbosity minimal > build-log.txt 2>&1

if %ERRORLEVEL% EQU 0 (
    echo BUILD SUCCESSFUL!
    type build-log.txt
) else (
    echo BUILD FAILED with %ERRORLEVEL% error(s)
    echo ERRORS FOUND:
    findstr /i "error BC error CS Error:" build-log.txt
    echo.
    echo WARNINGS:
    findstr /i "warning BC warning CS Warning:" build-log.txt
)

echo Build completed at %date% %time%
echo.
echo Press any key to close this window...
pause >nul
