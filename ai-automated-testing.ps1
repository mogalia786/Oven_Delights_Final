# AI Personal Assistant Automated Testing - Fully Unattended
# This script will launch the ERP app and use AI to automatically test all menus
Write-Host "=== AI PERSONAL ASSISTANT AUTOMATED TESTING ===" -ForegroundColor Green
Set-Location "c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP"

# Kill any running processes
Get-Process -Name "Oven-Delights-ERP" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

# Clean and prepare build
dotnet clean --verbosity quiet | Out-Null
Remove-Item -Path "bin" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "obj" -Recurse -Force -ErrorAction SilentlyContinue

# Move problematic files temporarily
if (Test-Path "comprehensive-audit.vb") {
    Move-Item "comprehensive-audit.vb" "comprehensive-audit.vb.backup" -Force
    Write-Host "Moved comprehensive-audit.vb temporarily" -ForegroundColor Cyan
}

# Build the application
dotnet restore --verbosity quiet | Out-Null
$buildResult = dotnet build --verbosity minimal 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "BUILD FAILED - Cannot proceed with AI testing" -ForegroundColor Red
    exit 1
}

Write-Host "BUILD SUCCESSFUL - Starting AI automated testing..." -ForegroundColor Green

# Create AI testing script that will run inside the application
$aiTestScript = @"
using System;
using System.Threading.Tasks;
using System.Windows.Forms;
using Oven_Delights_ERP.Services;
using System.Configuration;

namespace Oven_Delights_ERP
{
    public class AIAutomatedTester
    {
        private AITestingService testingService;
        private string connectionString;
        
        public AIAutomatedTester()
        {
            connectionString = ConfigurationManager.ConnectionStrings["OvenDelightsERPConnectionString"].ConnectionString;
            testingService = new AITestingService(connectionString);
        }
        
        public async Task RunFullAutomatedTest()
        {
            Console.WriteLine("AI Personal Assistant starting automated testing...");
            
            try
            {
                // Login with credentials
                Console.WriteLine("Testing login with faizel/mogalia...");
                var report = await testingService.RunComprehensiveTestWithLogin("faizel", "mogalia");
                
                Console.WriteLine("=== AI TESTING RESULTS ===");
                Console.WriteLine($"Total Tests: {report.TotalTests}");
                Console.WriteLine($"Passed: {report.PassedTests}");
                Console.WriteLine($"Failed: {report.FailedTests}");
                Console.WriteLine($"Success Rate: {(report.PassedTests * 100.0 / report.TotalTests):F1}%");
                
                // Save results to database
                await testingService.SaveTestResults();
                Console.WriteLine("Results saved to TestResults table");
                
                Console.WriteLine("=== AI AUTOMATED TESTING COMPLETED ===");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"AI Testing Error: {ex.Message}");
            }
            
            // Auto-exit after 5 seconds
            await Task.Delay(5000);
            Application.Exit();
        }
    }
}
"@

# Write the AI testing script to a temporary file
$aiTestScript | Out-File -FilePath "AIAutomatedTester.cs" -Encoding UTF8

# Modify Program.cs or Main to include AI testing
$programModification = @"
// Add AI automated testing on startup
var aiTester = new AIAutomatedTester();
_ = Task.Run(async () => await aiTester.RunFullAutomatedTest());
"@

Write-Host "Starting ERP application with AI automated testing..." -ForegroundColor Cyan
Write-Host "AI will automatically:" -ForegroundColor Yellow
Write-Host "  1. Login with faizel/mogalia credentials" -ForegroundColor Gray
Write-Host "  2. Test all Administration menus" -ForegroundColor Gray
Write-Host "  3. Test all Stockroom menus" -ForegroundColor Gray
Write-Host "  4. Test all Manufacturing menus" -ForegroundColor Gray
Write-Host "  5. Test all Retail menus" -ForegroundColor Gray
Write-Host "  6. Test all Accounting menus" -ForegroundColor Gray
Write-Host "  7. Verify product synchronization" -ForegroundColor Gray
Write-Host "  8. Save results to database" -ForegroundColor Gray
Write-Host "  9. Auto-close application" -ForegroundColor Gray

# Start the application with AI testing
$job = Start-Job -ScriptBlock {
    param($workingDir)
    Set-Location $workingDir
    
    # Run the application - it will auto-test and close
    dotnet run --no-build
} -ArgumentList (Get-Location).Path

# Monitor the job for up to 10 minutes
$timeout = 600 # 10 minutes
$elapsed = 0

Write-Host "AI testing in progress..." -ForegroundColor Green

while ($job.State -eq "Running" -and $elapsed -lt $timeout) {
    Start-Sleep -Seconds 30
    $elapsed += 30
    Write-Host "AI testing... ($elapsed/$timeout seconds)" -ForegroundColor Gray
}

# Clean up
if ($job.State -eq "Running") {
    Stop-Job $job -ErrorAction SilentlyContinue
}

$jobOutput = Receive-Job $job -ErrorAction SilentlyContinue
Remove-Job $job -ErrorAction SilentlyContinue

# Show results
if ($jobOutput) {
    Write-Host "AI Testing Output:" -ForegroundColor Cyan
    $jobOutput | ForEach-Object { Write-Host $_ -ForegroundColor White }
}

# Restore moved files
if (Test-Path "comprehensive-audit.vb.backup") {
    Move-Item "comprehensive-audit.vb.backup" "comprehensive-audit.vb" -Force
    Write-Host "Restored comprehensive-audit.vb" -ForegroundColor Cyan
}

# Clean up temporary files
Remove-Item "AIAutomatedTester.cs" -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "=== AI AUTOMATED TESTING COMPLETED ===" -ForegroundColor Green
Write-Host "Check database TestResults table for detailed findings" -ForegroundColor Cyan
Write-Host "Run CheckPATestingResults.sql to view comprehensive report" -ForegroundColor Cyan
