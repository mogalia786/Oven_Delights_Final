@echo off
echo Getting detailed build errors...
dotnet build --verbosity diagnostic > build-output.txt 2>&1
type build-output.txt | findstr /i "error"
echo.
echo Full output saved to build-output.txt
