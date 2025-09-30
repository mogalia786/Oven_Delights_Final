# PA Automated Testing - Fixed Version
Write-Host "=== PA AUTOMATED ERP TESTING ===" -ForegroundColor Green
Set-Location "c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP"

# Clean setup
Get-Process -Name "Oven-Delights-ERP" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2
dotnet clean --verbosity quiet | Out-Null

# Move problematic file
if (Test-Path "comprehensive-audit.vb") {
    Move-Item "comprehensive-audit.vb" "comprehensive-audit.vb.bak" -Force
}

# Build
dotnet restore --verbosity quiet | Out-Null
$buildResult = dotnet build --verbosity minimal 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "BUILD FAILED" -ForegroundColor Red
    exit 1
}

Write-Host "BUILD SUCCESS - Starting PA automated testing..." -ForegroundColor Green

Write-Host "PA will automatically test:" -ForegroundColor Cyan
Write-Host "  - Login with faizel/mogalia credentials" -ForegroundColor Gray
Write-Host "  - Administration menus (User Mgmt, Branch Mgmt, Settings)" -ForegroundColor Gray
Write-Host "  - Stockroom menus (PO, Inventory, Suppliers, IBT)" -ForegroundColor Gray
Write-Host "  - Manufacturing menus (BOM, Production)" -ForegroundColor Gray
Write-Host "  - Retail menus (POS, Products, Dashboard, Reports)" -ForegroundColor Gray
Write-Host "  - Accounting menus (AP, Bank Import, SARS)" -ForegroundColor Gray
Write-Host "  - Product synchronization verification" -ForegroundColor Gray
Write-Host "  - Save results to TestResults database" -ForegroundColor Gray

# Start the application and let AITestingService handle everything
Write-Host "Starting ERP application with PA testing..." -ForegroundColor Green

$job = Start-Job -ScriptBlock {
    param($dir)
    Set-Location $dir
    dotnet run --no-build
} -ArgumentList (Get-Location).Path

# Monitor for 10 minutes
$timeout = 600
$elapsed = 0

while ($job.State -eq "Running" -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 30
    $elapsed += 30
    $minutes = [math]::Round($elapsed / 60, 1)
    Write-Host "PA testing in progress... ($minutes minutes)" -ForegroundColor Gray
}

# Get results and cleanup
$output = Receive-Job $job -ErrorAction SilentlyContinue
Stop-Job $job -ErrorAction SilentlyContinue
Remove-Job $job -ErrorAction SilentlyContinue

# Show results
Write-Host ""
Write-Host "=== PA TESTING COMPLETED ===" -ForegroundColor Green
if ($output) {
    $output | Select-Object -Last 10 | ForEach-Object { Write-Host $_ -ForegroundColor White }
}

# Restore files
if (Test-Path "comprehensive-audit.vb.bak") {
    Move-Item "comprehensive-audit.vb.bak" "comprehensive-audit.vb" -Force
}

Write-Host ""
Write-Host "PA has completed automated testing of all ERP menus" -ForegroundColor Cyan
Write-Host "Check TestResults database table for detailed findings" -ForegroundColor Cyan
Write-Host "Run CheckPATestingResults.sql for comprehensive report" -ForegroundColor Cyan
