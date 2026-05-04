# Import Master Product List to Demo_Retail_Product
$csvPath = "C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\Oven Delight full product list.csv"
$outputSql = "C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Database\Update_Master_Product_List.sql"

$csv = Import-Csv -Path $csvPath -Delimiter ';'
Write-Host "Total products: $($csv.Count)"

$sql = "-- Update Demo_Retail_Product from master list`r`n"
$sql += "-- Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"
$sql += "BEGIN TRANSACTION;`r`n`r`n"

$posCount = 0
$internalCount = 0

foreach ($row in $csv) {
    $itemCode = if ($row.'TEM CCODE') { $row.'TEM CCODE'.Trim() } else { "" }
    $barcode = if ($row.'BARCODE') { $row.'BARCODE'.Trim() } else { "" }
    $description = if ($row.'ITEM DESCRIPTION') { $row.'ITEM DESCRIPTION'.Trim().Replace("'", "''") } else { "" }
    $subCategory = if ($row.'SUB CATEGORY') { $row.'SUB CATEGORY'.Trim() } else { "" }
    $mainCategory = if ($row.'MAIN CATEGORY') { $row.'MAIN CATEGORY'.Trim() } else { "" }
    $itemCategory = if ($row.'ITEM CATEGORY') { $row.'ITEM CATEGORY'.Trim().ToLower() } else { "external" }
    $office = if ($row.'OFFICE') { $row.'OFFICE'.Trim().ToLower() } else { "" }
    
    if ([string]::IsNullOrWhiteSpace($itemCode)) { continue }
    
    # Extract UOM from last part of item code (after last hyphen)
    $uom = "ea"
    if ($itemCode -match '-([A-Z0-9]+)$') {
        $uom = $matches[1]
    }
    
    # Determine ProductType
    $productType = if ($itemCategory -eq 'internal') { 'Internal' } else { 'External' }
    
    # Only process items marked for POS
    if ($office -eq 'pos') {
        $posCount++
        
        $sql += "-- $itemCode - $description`r`n"
        $sql += "DECLARE @CatID INT, @SubCatID INT;`r`n"
        $sql += "SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = '$mainCategory';`r`n"
        $sql += "SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = '$subCategory' AND CategoryID = @CatID;`r`n`r`n"
        
        $sql += "IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = '$itemCode')`r`n"
        $sql += "BEGIN`r`n"
        $sql += "    UPDATE Demo_Retail_Product SET`r`n"
        $sql += "        Name = '$description',`r`n"
        $sql += "        Category = '$mainCategory',`r`n"
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
        $sql += "    VALUES ('$itemCode', '$description', '$mainCategory', @CatID, @SubCatID, '$productType', 1);`r`n"
        $sql += "    PRINT 'Inserted: $itemCode';`r`n"
        $sql += "END`r`n"
        $sql += "GO`r`n`r`n"
    }
    
    if ($itemCategory -eq 'internal') { $internalCount++ }
}

$sql += "COMMIT TRANSACTION;`r`n`r`n"
$sql += "PRINT 'Product import completed!';`r`n"
$sql += "PRINT 'Total POS products processed: $posCount';`r`n"
$sql += "PRINT 'Total Internal products: $internalCount';`r`n`r`n"
$sql += "-- Show results`r`n"
$sql += "SELECT CategoryID, Category, ProductType, COUNT(*) AS ProductCount`r`n"
$sql += "FROM Demo_Retail_Product`r`n"
$sql += "WHERE IsActive = 1`r`n"
$sql += "GROUP BY CategoryID, Category, ProductType`r`n"
$sql += "ORDER BY Category, ProductType;`r`n"

$sql | Out-File -FilePath $outputSql -Encoding UTF8

Write-Host "`n================================"
Write-Host "SQL generated successfully!"
Write-Host "================================"
Write-Host "Output: $outputSql"
Write-Host "POS products: $posCount"
Write-Host "Internal products: $internalCount"
Write-Host "`nNext: Run the SQL file in SSMS"
