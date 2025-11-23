# =============================================
# IMPORT PRICES FROM CSV TO PRODUCTS TABLE
# =============================================

$csvPath = "c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\StockItems with Prices and descriptions\Combined_Inventory.csv"
$serverInstance = "localhost"  # Change if needed
$database = "Oven_Delights_Main"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "IMPORTING PRICES FROM CSV" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Read CSV with custom headers
Write-Host "Step 1: Reading CSV file..." -ForegroundColor Yellow
$csvContent = Get-Content -Path $csvPath
$csvData = $csvContent | Select-Object -Skip 1 | ConvertFrom-Csv -Header 'ItemCode','BARCODE','ITEM_DESCRIPTION','CATERGORY','item_catergory','Ingredients','Item_Description2','Whse','Cost','Incl_Price','Extra'

Write-Host "Found $($csvData.Count) rows in CSV" -ForegroundColor Green
Write-Host ""

# Generate SQL UPDATE statements
Write-Host "Step 2: Generating SQL UPDATE statements..." -ForegroundColor Yellow

$sqlStatements = @()
$updateCount = 0

foreach ($row in $csvData) {
    $itemCode = $row.ItemCode.Trim()
    $inclPrice = $row.Incl_Price.Replace(',', '').Replace(' ', '').Trim()
    $cost = $row.Cost.Replace(',', '').Replace(' ', '').Trim()
    
    if ($itemCode -and $inclPrice -and [decimal]::TryParse($inclPrice, [ref]$null)) {
        $sql = "UPDATE Products SET RecommendedSellingPrice = $inclPrice, LastPaidPrice = $inclPrice"
        
        if ($cost -and [decimal]::TryParse($cost, [ref]$null)) {
            $sql += ", AverageCost = $cost"
        }
        
        $sql += " WHERE ProductCode = '$itemCode';"
        $sqlStatements += $sql
        $updateCount++
    }
}

Write-Host "Generated $updateCount UPDATE statements" -ForegroundColor Green
Write-Host ""

# Save to SQL file
$outputFile = "c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Database\Branch\UPDATE_PRICES_FROM_CSV.sql"

$sqlHeader = @"
-- =============================================
-- AUTO-GENERATED: UPDATE PRICES FROM CSV
-- Generated: $(Get-Date)
-- =============================================

PRINT '========================================';
PRINT 'UPDATING PRODUCTS WITH PRICES FROM CSV';
PRINT '========================================';
PRINT '';

BEGIN TRANSACTION;

"@

$sqlFooter = @"

COMMIT TRANSACTION;

PRINT '';
PRINT 'Updated products with prices from CSV';

-- Verify
SELECT 
    'Products with prices (after import)' AS Info,
    COUNT(*) AS TotalProducts,
    SUM(CASE WHEN RecommendedSellingPrice > 0 THEN 1 ELSE 0 END) AS WithPrice,
    SUM(CASE WHEN RecommendedSellingPrice IS NULL OR RecommendedSellingPrice = 0 THEN 1 ELSE 0 END) AS WithoutPrice
FROM Products
WHERE IsActive = 1
    AND ItemType IN ('internal', 'external', 'Manufactured');

PRINT '';
PRINT '✅ PRICE IMPORT COMPLETE!';
"@

$fullSQL = $sqlHeader + ($sqlStatements -join "`n") + $sqlFooter

$fullSQL | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "Step 3: SQL file created at:" -ForegroundColor Yellow
Write-Host $outputFile -ForegroundColor Green
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ READY TO IMPORT!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next step: Run the generated SQL file in SQL Server Management Studio" -ForegroundColor Yellow
Write-Host $outputFile -ForegroundColor Cyan
