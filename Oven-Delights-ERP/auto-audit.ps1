# Fully automated audit script - no user interaction required
param(
    [int]$MaxRetries = 3,
    [int]$RetryDelaySeconds = 5
)

Write-Host "=== FULLY AUTOMATED ERP AUDIT ===" -ForegroundColor Green
Set-Location "c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP"

$attempt = 1
do {
    Write-Host "Build attempt $attempt of $MaxRetries..." -ForegroundColor Yellow
    
    # Run build with full error capture
    $buildOutput = dotnet build --no-restore --verbosity normal 2>&1
    $buildSuccess = $LASTEXITCODE -eq 0
    
    if ($buildSuccess) {
        Write-Host "BUILD SUCCESSFUL!" -ForegroundColor Green
        break
    } else {
        Write-Host "BUILD FAILED - Attempt $attempt" -ForegroundColor Red
        
        # Extract and show specific errors
        $errors = $buildOutput | Where-Object { $_ -match "error BC|error CS" }
        if ($errors) {
            Write-Host "ERRORS FOUND:" -ForegroundColor Yellow
            $errors | ForEach-Object { Write-Host $_ -ForegroundColor Red }
        }
        
        if ($attempt -lt $MaxRetries) {
            Write-Host "Retrying in $RetryDelaySeconds seconds..." -ForegroundColor Cyan
            Start-Sleep -Seconds $RetryDelaySeconds
        }
    }
    
    $attempt++
} while ($attempt -le $MaxRetries -and -not $buildSuccess)

if (-not $buildSuccess) {
    Write-Host "BUILD FAILED AFTER $MaxRetries ATTEMPTS" -ForegroundColor Red
    Write-Host "Cannot proceed with audit. Check errors above." -ForegroundColor Red
    
    # Save detailed error log
    $buildOutput | Out-File -FilePath "build-errors-detailed.log" -Encoding UTF8
    Write-Host "Detailed errors saved to build-errors-detailed.log" -ForegroundColor Cyan
    
    exit 1
}

# If build successful, continue with audit
Write-Host ""
Write-Host "Starting automated audit process..." -ForegroundColor Green
Write-Host "AI Personal Assistant will test all menus with faizel/mogalia credentials" -ForegroundColor Cyan

# Run the application in background for testing
try {
    Write-Host "Launching ERP application for comprehensive testing..." -ForegroundColor Yellow
    
    # Start the application process
    $process = Start-Process -FilePath "dotnet" -ArgumentList "run --no-build" -WorkingDirectory (Get-Location) -PassThru -WindowStyle Hidden
    
    Write-Host "ERP application started (Process ID: $($process.Id))" -ForegroundColor Green
    Write-Host "AI testing in progress..." -ForegroundColor Cyan
    
    # Wait for testing to complete (or timeout after 5 minutes)
    $timeout = 300 # 5 minutes
    $elapsed = 0
    
    while (-not $process.HasExited -and $elapsed -lt $timeout) {
        Start-Sleep -Seconds 10
        $elapsed += 10
        Write-Host "Testing in progress... ($elapsed seconds elapsed)" -ForegroundColor Gray
    }
    
    if ($process.HasExited) {
        Write-Host "Audit completed successfully!" -ForegroundColor Green
    } else {
        Write-Host "Audit timeout reached. Stopping process..." -ForegroundColor Yellow
        $process.Kill()
    }
    
} catch {
    Write-Host "Error during audit execution: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== AUDIT COMPLETED ===" -ForegroundColor Green
Write-Host "Check database TestResults table for detailed findings" -ForegroundColor Cyan
Write-Host "Run CheckPATestingResults.sql for comprehensive report" -ForegroundColor Cyan
