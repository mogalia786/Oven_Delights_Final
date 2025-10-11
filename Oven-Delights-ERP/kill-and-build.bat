@echo off
echo Stopping any running ERP processes and building...

echo.
echo 1. Killing any running Oven-Delights-ERP processes...
taskkill /f /im "Oven-Delights-ERP.exe" 2>nul
timeout /t 2 /nobreak >nul

echo.
echo 2. Building application...
dotnet build --verbosity minimal

echo.
echo Build complete!
