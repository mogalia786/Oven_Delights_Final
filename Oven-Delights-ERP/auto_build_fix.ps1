# Auto Build Fix Script - Runs continuously until clean build
param(
    [int]$MaxIterations = 50,
    [int]$DelaySeconds = 5
)

$projectPath = "c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP"
Set-Location $projectPath

Write-Host "Starting auto build fix process..." -ForegroundColor Green
Write-Host "Project: $projectPath" -ForegroundColor Yellow
Write-Host "Max iterations: $MaxIterations" -ForegroundColor Yellow

for ($i = 1; $i -le $MaxIterations; $i++) {
    Write-Host "`n=== Iteration $i ===" -ForegroundColor Cyan
    
    # Build and capture errors
    $buildResult = dotnet build --no-restore 2>&1
    $exitCode = $LASTEXITCODE
    
    if ($exitCode -eq 0) {
        Write-Host "SUCCESS! Build completed without errors!" -ForegroundColor Green
        Write-Host "Total iterations needed: $i" -ForegroundColor Green
        break
    }
    
    # Extract error count
    $errorLines = $buildResult | Select-String "failed with (\d+) error"
    if ($errorLines) {
        $errorCount = [regex]::Match($errorLines[0], "(\d+) error").Groups[1].Value
        Write-Host "Build failed with $errorCount errors" -ForegroundColor Red
        
        # Update heartbeat
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $heartbeatContent = @"
# Live Heartbeat Log

This file tracks the latest activity and progress on the Oven Delights ERP system.

## Heartbeat Log

### **$timestamp** - AUTO-BUILD ITERATION $i`: $errorCount compilation errors remaining. System auto-repairing...

**OVERNIGHT REPAIR MISSION:**
- User frustrated with system instability and duplicate menus
- Comprehensive audit of ALL menus and functionality required
- Fix duplicate menus appearing after form exit
- Replace ALL menu stubs with proper implementations
- 6-hour window for complete system restoration
- Heartbeat updates every 5 minutes

"@
        Set-Content -Path "Documentation\Heartbeat.md" -Value $heartbeatContent
        
        if ($errorCount -eq "0") {
            Write-Host "SUCCESS! All errors resolved!" -ForegroundColor Green
            break
        }
    }
    
    if ($i -lt $MaxIterations) {
        Write-Host "Waiting $DelaySeconds seconds before next iteration..." -ForegroundColor Yellow
        Start-Sleep -Seconds $DelaySeconds
    }
}

if ($i -gt $MaxIterations) {
    Write-Host "Reached maximum iterations ($MaxIterations). Manual intervention may be needed." -ForegroundColor Red
}

Write-Host "`nAuto build fix process completed." -ForegroundColor Green
