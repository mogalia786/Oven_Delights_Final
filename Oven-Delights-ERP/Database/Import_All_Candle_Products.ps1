# Import ALL Candle products (not just POS ones)
$csvPath = "C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\Oven Delight full product list.csv"
$outputSql = "C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Database\Update_All_Candle_Products.sql"

$csv = Import-Csv -Path $csvPath -Delimiter ';'
Write-Host "Total products in CSV: $($csv.Count)"

$sql = "-- Import ALL Candle products`r`n"
$sql += "-- Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"
$sql += "BEGIN TRANSACTION;`r`n`r`n"

$candleCount = 0

foreach ($row in $csv) {
    $itemCode = if ($row.'TEM CCODE') { $row.'TEM CCODE'.Trim() } else { "" }
    $description = if ($row.'ITEM DESCRIPTION') { $row.'ITEM DESCRIPTION'.Trim().Replace("'", "''") } else { "" }
    $subCategory = if ($row.'SUB CATEGORY') { $row.'SUB CATEGORY'.Trim() } else { "" }
    $mainCategory = if ($row.'MAIN CATEGORY') { $row.'MAIN CATEGORY'.Trim() } else { "" }
    $itemCategory = if ($row.'ITEM CATEGORY') { $row.'ITEM CATEGORY'.Trim().ToLower() } else { "external" }
    
    if ([string]::IsNullOrWhiteSpace($itemCode)) { continue }
    if ($mainCategory.ToLower() -ne 'candle') { continue }
    
    $candleCount++
    $productType = if ($itemCategory -eq 'internal') { 'Internal' } else { 'External' }
    
    $sql += "-- $itemCode - $description`r`n"
    $sql += "DECLARE @CatID INT, @SubCatID INT;`r`n"
    $sql += "SELECT @CatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';`r`n"
    $sql += "SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = '$subCategory' AND CategoryID = @CatID;`r`n`r`n"
    
    $sql += "IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = '$itemCode')`r`n"
    $sql += "BEGIN`r`n"
    $sql += "    UPDATE Demo_Retail_Product SET`r`n"
    $sql += "        Name = '$description',`r`n"
    $sql += "        Category = 'candle',`r`n"
    $sql += "        CategoryID = @CatID,`r`n"
    $sql += "        SubCategoryID = @SubCatID,`r`n"
    $sql += "        ProductType = '$productType',`r`n"
    $sql += "        IsActive = 1`r`n"
    $sql += "    WHERE SKU = '$itemCode';`r`n"
    $sql += "    PRINT 'Updated: $itemCode';`r`n"
    $sql += "END`r`n"
    $sql += "ELSE`r`n"
    $sql += "BEGIN`r`n"
    $sql += "    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)`r`n"
    $sql += "    VALUES ('$itemCode', '$description', 'candle', @CatID, @SubCatID, '$productType', 1);`r`n"
    $sql += "    PRINT 'Inserted: $itemCode';`r`n"
    $sql += "END`r`n"
    $sql += "GO`r`n`r`n"
}

$sql += "COMMIT TRANSACTION;`r`n`r`n"
$sql += "PRINT 'Candle product import completed!';`r`n"
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
Write-Host "Total Candle products: $candleCount"
Write-Host "`nNext: Run the SQL file in SSMS"
