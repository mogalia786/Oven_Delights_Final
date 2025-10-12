# Quick build test to identify exact error
Write-Host "Finding exact build error..." -ForegroundColor Yellow
Set-Location "c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP"

# Clean build first
dotnet clean --verbosity quiet

# Build with detailed output and capture errors
$output = dotnet build --no-restore --verbosity detailed 2>&1
$errors = $output | Where-Object { $_ -like "*error BC*" -or $_ -like "*error CS*" }

if ($errors) {
    Write-Host "BUILD ERRORS FOUND:" -ForegroundColor Red
    $errors | ForEach-Object { 
        Write-Host $_ -ForegroundColor Red
        # Extract file and line info
        if ($_ -match "([^\\]+\.vb)\((\d+),(\d+)\)") {
            Write-Host "  File: $($matches[1]), Line: $($matches[2]), Column: $($matches[3])" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "No specific errors found. Full output:" -ForegroundColor Yellow
    $output | Select-Object -Last 20 | ForEach-Object { Write-Host $_ }
}

# Check if it's a simple missing reference issue
$missingRefs = $output | Where-Object { $_ -like "*could not be found*" -or $_ -like "*reference*" }
if ($missingRefs) {
    Write-Host "`nMISSING REFERENCES:" -ForegroundColor Cyan
    $missingRefs | ForEach-Object { Write-Host $_ -ForegroundColor Cyan }
}

Write-Host "`nBuild exit code: $LASTEXITCODE" -ForegroundColor Gray
