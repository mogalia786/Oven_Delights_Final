# Import Product Barcodes to Demo_Retail_Variant
$csvPath = "C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\Oven Delight full product list.csv"
$outputSql = "C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Database\Update_Product_Barcodes.sql"

$csv = Import-Csv -Path $csvPath -Delimiter ';'
Write-Host "Total products: $($csv.Count)"

$sql = "-- Update Demo_Retail_Variant with barcodes`r`n"
$sql += "-- Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n`r`n"
$sql += "BEGIN TRANSACTION;`r`n`r`n"

$barcodeCount = 0

foreach ($row in $csv) {
    $itemCode = if ($row.'TEM CCODE') { $row.'TEM CCODE'.Trim() } else { "" }
    $barcode = if ($row.'BARCODE') { $row.'BARCODE'.Trim() } else { "" }
    $office = if ($row.'OFFICE') { $row.'OFFICE'.Trim().ToLower() } else { "" }
    
    if ([string]::IsNullOrWhiteSpace($itemCode)) { continue }
    if ([string]::IsNullOrWhiteSpace($barcode)) { continue }
    if ($office -ne 'pos') { continue }
    
    $barcodeEscaped = $barcode.Replace("'", "''")
    $barcodeCount++
    
    $sql += "-- $itemCode - Barcode: $barcode`r`n"
    $sql += "DECLARE @ProductID INT;`r`n"
    $sql += "SELECT @ProductID = ProductID FROM Demo_Retail_Product WHERE SKU = '$itemCode';`r`n`r`n"
    
    $sql += "IF @ProductID IS NOT NULL`r`n"
    $sql += "BEGIN`r`n"
    $sql += "    IF EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = @ProductID)`r`n"
    $sql += "    BEGIN`r`n"
    $sql += "        UPDATE Demo_Retail_Variant SET Barcode = '$barcodeEscaped' WHERE ProductID = @ProductID;`r`n"
    $sql += "        PRINT 'Updated barcode for: $itemCode';`r`n"
    $sql += "    END`r`n"
    $sql += "    ELSE`r`n"
    $sql += "    BEGIN`r`n"
    $sql += "        INSERT INTO Demo_Retail_Variant (ProductID, Barcode, IsActive)`r`n"
    $sql += "        VALUES (@ProductID, '$barcodeEscaped', 1);`r`n"
    $sql += "        PRINT 'Inserted variant with barcode for: $itemCode';`r`n"
    $sql += "    END`r`n"
    $sql += "END`r`n"
    $sql += "GO`r`n`r`n"
}

$sql += "COMMIT TRANSACTION;`r`n`r`n"
$sql += "PRINT 'Barcode import completed!';`r`n"
$sql += "PRINT 'Total barcodes processed: $barcodeCount';`r`n`r`n"
$sql += "-- Show results`r`n"
$sql += "SELECT COUNT(*) AS VariantsWithBarcodes`r`n"
$sql += "FROM Demo_Retail_Variant`r`n"
$sql += "WHERE Barcode IS NOT NULL AND Barcode <> '';`r`n"

$sql | Out-File -FilePath $outputSql -Encoding UTF8

Write-Host "`n================================"
Write-Host "SQL generated successfully!"
Write-Host "================================"
Write-Host "Output: $outputSql"
Write-Host "Products with barcodes: $barcodeCount"
Write-Host "`nNext: Run the SQL file in SSMS"
