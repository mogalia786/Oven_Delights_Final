# PowerShell script to generate SQL UPDATE statements from OD200.csv
# This will create a SQL file that updates Demo_Retail_Price for BranchID 6

$csvPath = "C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\StockItems with Prices and descriptions\OD200.csv"
$outputSql = "C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Database\Update_OD200_Prices_Generated.sql"

# Read CSV as raw lines
$lines = Get-Content -Path $csvPath

# Parse header
$header = $lines[0] -split ','
Write-Host "CSV Columns: $($header -join ' | ')"

# Start SQL script
$sql = @"
-- Auto-generated SQL script to update Demo_Retail_Price for BranchID 6 (OD200)
-- Generated on: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

BEGIN TRANSACTION;

"@

$processedCount = 0

# Process each line (skip header)
for ($i = 1; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    
    # Split by comma (simple split - may need adjustment for quoted values)
    $fields = $line -split ','
    
    if ($fields.Count -lt 10) { continue }
    
    # Extract fields by position
    # 0: Item Code, 1: BARCODE, 2: ITEM DESCRIPTION, 3: CATERGORY, 4: item catergory, 
    # 5: Ingredients, 6: Item Description, 7: Whse, 8: Cost, 9: Incl Price
    
    $sku = $fields[0].Trim().Trim('"')
    $costPrice = $fields[8].Trim().Trim('"').Replace(',', '')
    $inclPrice = $fields[9].Trim().Trim('"').Replace(',', '')
    
    # Skip if no SKU
    if ([string]::IsNullOrWhiteSpace($sku)) {
        continue
    }
    
    # Convert to decimal - default to 0.00 if empty or invalid
    try {
        if ([string]::IsNullOrWhiteSpace($costPrice)) {
            $costPriceDecimal = 0.00
        } else {
            $costPriceDecimal = [decimal]$costPrice
        }
        
        if ([string]::IsNullOrWhiteSpace($inclPrice)) {
            $inclPriceDecimal = 0.00
        } else {
            $inclPriceDecimal = [decimal]$inclPrice
        }
        
        # Calculate CostPrice Excl VAT
        # If Cost = 0, calculate from Incl Price (only if Incl Price > 0)
        if ($costPriceDecimal -eq 0 -and $inclPriceDecimal -gt 0) {
            $costPriceExcl = [Math]::Round($inclPriceDecimal / 1.15, 2)
        } else {
            $costPriceExcl = $costPriceDecimal
        }
        
        # Escape single quotes in SKU
        $skuEscaped = $sku.Replace("'", "''")
        
        # Generate UPDATE statement
        $sql += @"

-- SKU: $sku | Cost: $costPriceExcl | Retail: $inclPriceDecimal
IF EXISTS (
    SELECT 1 FROM Demo_Retail_Price drp
    INNER JOIN Demo_Retail_Product drprod ON drp.ProductID = drprod.ProductID AND drp.BranchID = drprod.BranchID
    WHERE drprod.SKU = '$skuEscaped' AND drp.BranchID = 6
)
BEGIN
    UPDATE drp
    SET drp.CostPrice = $costPriceExcl,
        drp.SellingPrice = $inclPriceDecimal,
        drp.EffectiveFrom = GETDATE(),
        drp.CreatedAt = GETDATE()
    FROM Demo_Retail_Price drp
    INNER JOIN Demo_Retail_Product drprod ON drp.ProductID = drprod.ProductID AND drp.BranchID = drprod.BranchID
    WHERE drprod.SKU = '$skuEscaped' AND drp.BranchID = 6;
END
ELSE
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = '$skuEscaped' AND BranchID = 6)
    BEGIN
        INSERT INTO Demo_Retail_Price (ProductID, BranchID, CostPrice, RetailPrice, EffectiveFrom, CreatedAt)
        SELECT ProductID, 6, $costPriceExcl, $inclPriceDecimal, GETDATE(), GETDATE()
        FROM Demo_Retail_Product
        WHERE SKU = '$skuEscaped' AND BranchID = 6;
    END
END

"@
        $processedCount++
        
    } catch {
        Write-Host "Skipping invalid row: $sku - Cost: $costPrice, Incl: $inclPrice - Error: $_"
    }
}

# End transaction
$sql += @"

COMMIT TRANSACTION;

PRINT 'Price update completed for BranchID 6 (OD200)';
PRINT 'Total products processed: $processedCount';

-- Show updated prices
SELECT 
    drprod.SKU,
    drprod.Name,
    drp.CostPrice AS 'Cost (Excl VAT)',
    drp.RetailPrice AS 'Retail (Incl VAT)',
    drp.EffectiveFrom
FROM Demo_Retail_Price drp
INNER JOIN Demo_Retail_Product drprod ON drp.ProductID = drprod.ProductID AND drp.BranchID = drprod.BranchID
WHERE drp.BranchID = 6
ORDER BY drprod.SKU;
"@

# Write to file
$sql | Out-File -FilePath $outputSql -Encoding UTF8

Write-Host ""
Write-Host "================================"
Write-Host "SQL script generated successfully!"
Write-Host "================================"
Write-Host "Output file: $outputSql"
Write-Host "Total rows processed: $processedCount"
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Review the generated SQL file"
Write-Host "2. Run it in SQL Server Management Studio"
Write-Host "3. This will update Demo_Retail_Price for BranchID 6"
