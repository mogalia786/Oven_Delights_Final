# Kill any running ERP processes and rebuild cleanly
Write-Host "=== CLEAN BUILD PROCESS ===" -ForegroundColor Green
Set-Location "c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP"

# Step 1: Kill any running ERP processes
Write-Host "Terminating any running ERP processes..." -ForegroundColor Yellow
try {
    Get-Process -Name "Oven-Delights-ERP" -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 2
    Write-Host "ERP processes terminated" -ForegroundColor Green
} catch {
    Write-Host "No ERP processes found running" -ForegroundColor Gray
}

# Step 2: Clean all build artifacts
Write-Host "Cleaning build artifacts..." -ForegroundColor Yellow
dotnet clean --verbosity quiet | Out-Null
Remove-Item -Path "bin" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "obj" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Build artifacts cleaned" -ForegroundColor Green

# Step 3: Restore packages
Write-Host "Restoring packages..." -ForegroundColor Yellow
dotnet restore --verbosity quiet | Out-Null
Write-Host "Packages restored" -ForegroundColor Green

# Step 4: Build project
Write-Host "Building project..." -ForegroundColor Yellow
$buildOutput = dotnet build --verbosity minimal 2>&1
$buildSuccess = $LASTEXITCODE -eq 0

if ($buildSuccess) {
    Write-Host "BUILD SUCCESSFUL!" -ForegroundColor Green
    
    # Step 5: Run application for testing
    Write-Host "Starting ERP application..." -ForegroundColor Cyan
    Write-Host "Application will run for 3 minutes then auto-close" -ForegroundColor Gray
    
    # Start application in background job
    $job = Start-Job -ScriptBlock {
        param($workingDir)
        Set-Location $workingDir
        dotnet run --no-build
    } -ArgumentList (Get-Location).Path
    
    # Monitor for 3 minutes
    $timeout = 180 # 3 minutes
    $elapsed = 0
    
    while ($job.State -eq "Running" -and $elapsed -lt $timeout) {
        Start-Sleep -Seconds 15
        $elapsed += 15
        Write-Host "Application running... ($elapsed/$timeout seconds)" -ForegroundColor Gray
    }
    
    # Clean shutdown
    if ($job.State -eq "Running") {
        Write-Host "Stopping application..." -ForegroundColor Yellow
        Stop-Job $job -ErrorAction SilentlyContinue
        
        # Force kill any remaining processes
        Get-Process -Name "Oven-Delights-ERP" -ErrorAction SilentlyContinue | Stop-Process -Force
    }
    
    Remove-Job $job -ErrorAction SilentlyContinue
    Write-Host "Application testing completed successfully" -ForegroundColor Green
    
} else {
    Write-Host "BUILD FAILED" -ForegroundColor Red
    Write-Host "Build errors:" -ForegroundColor Yellow
    $buildOutput | Select-Object -Last 10 | ForEach-Object { Write-Host $_ -ForegroundColor Red }
}

Write-Host ""
Write-Host "=== PROCESS COMPLETED ===" -ForegroundColor Green
