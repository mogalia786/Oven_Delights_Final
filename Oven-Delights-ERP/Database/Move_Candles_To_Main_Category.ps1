# Move all candle subcategory items to main Candle category
$csvPath = "C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\Oven Delight full product list.csv"
$outputSql = "C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Database\Move_Candles_To_Main_Category.sql"

$csv = Import-Csv -Path $csvPath -Delimiter ';'
Write-Host "Total products in CSV: $($csv.Count)"

$sql = "-- Move all candle subcategory items to main Candle category`r`n"
$sql += "-- Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"
$sql += "BEGIN TRANSACTION;`r`n`r`n"

$candleCount = 0

foreach ($row in $csv) {
    $itemCode = if ($row.'TEM CCODE') { $row.'TEM CCODE'.Trim() } else { "" }
    $description = if ($row.'ITEM DESCRIPTION') { $row.'ITEM DESCRIPTION'.Trim().Replace("'", "''") } else { "" }
    $subCategory = if ($row.'SUB CATEGORY') { $row.'SUB CATEGORY'.Trim() } else { "" }
    $mainCategory = if ($row.'MAIN CATEGORY') { $row.'MAIN CATEGORY'.Trim() } else { "" }
    $itemCategory = if ($row.'ITEM CATEGORY') { $row.'ITEM CATEGORY'.Trim().ToLower() } else { "external" }
    $office = if ($row.'OFFICE') { $row.'OFFICE'.Trim().ToLower() } else { "" }
    
    if ([string]::IsNullOrWhiteSpace($itemCode)) { continue }
    if ($subCategory.ToLower() -ne 'candle') { continue }
    if ($office -ne 'pos') { continue }
    
    $candleCount++
    $productType = if ($itemCategory -eq 'internal') { 'Internal' } else { 'External' }
    
    $sql += "-- $itemCode - $description`r`n"
    $sql += "DECLARE @CandleCatID INT;`r`n"
    $sql += "SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';`r`n`r`n"
    
    $sql += "IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = '$itemCode')`r`n"
    $sql += "BEGIN`r`n"
    $sql += "    UPDATE Demo_Retail_Product SET`r`n"
    $sql += "        Name = '$description',`r`n"
    $sql += "        Category = 'candle',`r`n"
    $sql += "        CategoryID = @CandleCatID,`r`n"
    $sql += "        SubCategoryID = NULL,`r`n"
    $sql += "        ProductType = '$productType',`r`n"
    $sql += "        IsActive = 1`r`n"
    $sql += "    WHERE SKU = '$itemCode';`r`n"
    $sql += "    PRINT 'Updated: $itemCode';`r`n"
    $sql += "END`r`n"
    $sql += "ELSE`r`n"
    $sql += "BEGIN`r`n"
    $sql += "    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)`r`n"
    $sql += "    VALUES ('$itemCode', '$description', 'candle', @CandleCatID, NULL, '$productType', 1);`r`n"
    $sql += "    PRINT 'Inserted: $itemCode';`r`n"
    $sql += "END`r`n"
    $sql += "GO`r`n`r`n"
}

$sql += "COMMIT TRANSACTION;`r`n`r`n"
$sql += "PRINT 'Candle products moved to main category!';`r`n"
$sql += "PRINT 'Total Candle products processed: $candleCount';`r`n`r`n"
$sql += "-- Show results`r`n"
$sql += "SELECT COUNT(*) AS TotalCandleProducts`r`n"
$sql += "FROM Demo_Retail_Product`r`n"
$sql += "WHERE Category = 'candle' AND IsActive = 1;`r`n"

$sql | Out-File -FilePath $outputSql -Encoding UTF8

Write-Host "`n================================"
Write-Host "SQL generated successfully!"
Write-Host "================================"
Write-Host "Output: $outputSql"
Write-Host "Total Candle products found: $candleCount"
Write-Host "`nNext: Run the SQL file in SSMS"
