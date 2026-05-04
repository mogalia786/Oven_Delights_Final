# =============================================
# IMPORT MASTER PRODUCT LIST TO SQL
# Generates SQL script to update Products table
# =============================================

$csvPath = "c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\MASTER_PRODUCT_LIST.csv"
$outputFile = "c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Database\Branch\UPDATE_PRODUCTS_FROM_MASTER_LIST.sql"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GENERATING SQL FROM MASTER PRODUCT LIST" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Reading master product list..." -ForegroundColor Yellow
$masterData = Import-Csv -Path $csvPath

Write-Host "Found $($masterData.Count) products" -ForegroundColor Green
Write-Host ""

$sqlStatements = @()
$updateCount = 0

foreach ($row in $masterData) {
    $itemCode = $row.ItemCode.Trim().Replace("'", "''")
    $itemDesc = $row.ItemDescription.Trim().Replace("'", "''")
    $category = $row.Category.Trim().Replace("'", "''")
    $itemCategory = $row.ItemCategory.Trim().Replace("'", "''")
    $price = $row.SellingPrice.Replace(',', '').Replace(' ', '').Trim()
    $cost = $row.CostPrice.Replace(',', '').Replace(' ', '').Trim()
    $isRetail = $row.IsRetail
    
    if (-not $price) { $price = "0" }
    if (-not $cost) { $cost = "0" }
    
    # Determine ItemType based on IsRetail flag
    $itemType = if ($isRetail -eq 'TRUE') { 
        if ($itemCategory -eq 'internal') { 'internal' } 
        elseif ($itemCategory -eq 'external') { 'external' }
        else { 'Manufactured' }
    } else { 
        'RawMaterial' 
    }
    
    $sql = @"
-- Update or Insert: $itemCode
IF EXISTS (SELECT 1 FROM Products WHERE ProductCode = '$itemCode')
BEGIN
    UPDATE Products 
    SET ProductName = '$itemDesc',
        RecommendedSellingPrice = $price,
        LastPaidPrice = $price,
        AverageCost = $cost,
        ItemType = '$itemType',
        IsActive = 1
    WHERE ProductCode = '$itemCode';
END
ELSE
BEGIN
    INSERT INTO Products (ProductCode, ProductName, RecommendedSellingPrice, LastPaidPrice, AverageCost, ItemType, IsActive)
    VALUES ('$itemCode', '$itemDesc', $price, $price, $cost, '$itemType', 1);
END

"@
    
    $sqlStatements += $sql
    $updateCount++
}

Write-Host "Generated $updateCount SQL statements" -ForegroundColor Green
Write-Host ""

$sqlHeader = @"
-- =============================================
-- AUTO-GENERATED: UPDATE PRODUCTS FROM MASTER LIST
-- Generated: $(Get-Date)
-- Source: MASTER_PRODUCT_LIST.csv
-- =============================================

PRINT '========================================';
PRINT 'UPDATING PRODUCTS FROM MASTER LIST';
PRINT '========================================';
PRINT '';

BEGIN TRANSACTION;

"@

$sqlFooter = @"

COMMIT TRANSACTION;

PRINT '';
PRINT 'Products updated from master list';

-- Verify
SELECT 
    ItemType,
    COUNT(*) AS ProductCount,
    SUM(CASE WHEN RecommendedSellingPrice > 0 THEN 1 ELSE 0 END) AS WithPrice
FROM Products
WHERE IsActive = 1
GROUP BY ItemType
ORDER BY ItemType;

PRINT '';
PRINT '✅ PRODUCTS TABLE UPDATED FROM MASTER LIST!';
PRINT '';
PRINT 'Retail products (internal/external/Manufactured) will appear in POS';
PRINT 'Raw materials will NOT appear in POS (stockroom only)';
"@

$fullSQL = $sqlHeader + ($sqlStatements -join "`n") + $sqlFooter

$fullSQL | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ SQL SCRIPT GENERATED!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Output file: $outputFile" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next step: Run the SQL script in SQL Server Management Studio" -ForegroundColor Yellow
