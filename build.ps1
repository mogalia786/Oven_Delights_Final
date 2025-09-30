# Automated build script for Oven Delights ERP
# This script runs the build process without requiring user interaction

Write-Host "Starting automated build process..." -ForegroundColor Green

try {
    # Change to project directory
    Set-Location "c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP"
    
    # Run build with minimal output and capture errors
    $buildResult = dotnet build --no-restore --verbosity minimal 2>&1
    
    # Check if build succeeded
    if ($LASTEXITCODE -eq 0) {
        Write-Host "BUILD SUCCESSFUL!" -ForegroundColor Green
        Write-Host $buildResult
    } else {
        Write-Host "BUILD FAILED with $LASTEXITCODE error(s)" -ForegroundColor Red
        
        # Extract and display only error lines
        $errors = $buildResult | Where-Object { $_ -match "error BC|error CS|Error:|BC30002|BC30451|BC30456" }
        if ($errors) {
            Write-Host "ERRORS FOUND:" -ForegroundColor Yellow
            $errors | ForEach-Object { Write-Host $_ -ForegroundColor Red }
        }
        
        # Also show warnings for context
        $warnings = $buildResult | Where-Object { $_ -match "warning BC|warning CS|Warning:" }
        if ($warnings) {
            Write-Host "WARNINGS:" -ForegroundColor Yellow
            $warnings | ForEach-Object { Write-Host $_ -ForegroundColor Magenta }
        }
        
        # If no specific errors found, show full output
        if (-not $errors) {
            Write-Host "Full build output (no specific errors detected):" -ForegroundColor Yellow
            Write-Host $buildResult
        }
    }
} catch {
    Write-Host "Script execution failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Build process completed at $(Get-Date)" -ForegroundColor Cyan
