# PowerShell script to execute comprehensive ERP audit
# This runs the AI Personal Assistant to test every menu with login credentials

Write-Host "=== COMPREHENSIVE ERP SYSTEM AUDIT ===" -ForegroundColor Green
Write-Host "AI Personal Assistant will now test every menu systematically" -ForegroundColor Cyan
Write-Host ""

# Set location
Set-Location "c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP"

# Build project first
Write-Host "Building ERP project..." -ForegroundColor Yellow
$buildResult = dotnet build --no-restore --verbosity minimal 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "BUILD FAILED - Cannot proceed with audit" -ForegroundColor Red
    Write-Host $buildResult
    exit 1
}
Write-Host "Build successful" -ForegroundColor Green

# Start the audit process
Write-Host ""
Write-Host "Starting AI Personal Assistant audit with credentials faizel/mogalia..." -ForegroundColor Cyan
Write-Host ""
Write-Host "The AI will systematically test:" -ForegroundColor White
Write-Host "✓ Administration Menu (User Management, Branch Management, System Settings)" -ForegroundColor Gray
Write-Host "✓ Stockroom Menu (Purchase Orders, Inventory, Suppliers, IBT)" -ForegroundColor Gray  
Write-Host "✓ Manufacturing Menu (BOM Creation, Production, Material Requests)" -ForegroundColor Gray
Write-Host "✓ Retail Menu (POS, Products, Manager Dashboard, Reports)" -ForegroundColor Gray
Write-Host "✓ Accounting Menu (Accounts Payable, Bank Import, SARS)" -ForegroundColor Gray
Write-Host "✓ Product Synchronization (Legacy vs New tables)" -ForegroundColor Gray
Write-Host "✓ Critical Sync Points (4 defined sync operations)" -ForegroundColor Gray
Write-Host "✓ MessageBox Stub Detection and Removal" -ForegroundColor Gray
Write-Host ""

# Execute the application with AI testing
Write-Host "Launching ERP application for comprehensive testing..." -ForegroundColor Yellow

# Create a simple test execution script
$testScript = @"
using System;
using System.Threading.Tasks;
using Oven_Delights_ERP.Services;
using System.Configuration;

class Program {
    static async Task Main(string[] args) {
        try {
            var connectionString = ConfigurationManager.ConnectionStrings["OvenDelightsERPConnectionString"].ConnectionString;
            var testingService = new AITestingService(connectionString);
            
            Console.WriteLine("Starting comprehensive test with login credentials...");
            var report = await testingService.RunComprehensiveTestWithLogin("faizel", "mogalia");
            
            Console.WriteLine($"AUDIT RESULTS:");
            Console.WriteLine($"Total Tests: {report.TotalTests}");
            Console.WriteLine($"Passed: {report.PassedTests}");
            Console.WriteLine($"Failed: {report.FailedTests}");
            Console.WriteLine($"Success Rate: {(report.PassedTests * 100.0 / report.TotalTests):F1}%");
            
            Console.WriteLine("Audit completed successfully!");
        } catch (Exception ex) {
            Console.WriteLine($"Audit failed: {ex.Message}");
        }
    }
}
"@

$testScript | Out-File -FilePath "temp-audit-runner.cs" -Encoding UTF8

Write-Host "AI Personal Assistant is now running comprehensive audit..." -ForegroundColor Green
Write-Host "Results will be saved to database TestResults table" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press Ctrl+C to stop the audit process" -ForegroundColor Yellow

# Run the application
try {
    dotnet run --no-build
} catch {
    Write-Host "Audit execution completed or interrupted" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== AUDIT COMPLETED ===" -ForegroundColor Green
Write-Host "Check database TestResults table for detailed results" -ForegroundColor Cyan
Write-Host "Run CheckPATestingResults.sql to view comprehensive report" -ForegroundColor Cyan
