# PowerShell script to generate SQL UPDATE statements from OD200.csv
# This will create a SQL file that updates Demo_Retail_Price for BranchID 6

$csvPath = "C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\StockItems with Prices and descriptions\OD200.csv"
$outputSql = "C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Database\Update_OD200_Prices_Generated.sql"

# Read CSV
$csv = Import-Csv -Path $csvPath

# Start SQL script
$sql = @"
-- Auto-generated SQL script to update Demo_Retail_Price for BranchID 6 (OD200)
-- Generated on: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

BEGIN TRANSACTION;

"@

$updateCount = 0
$insertCount = 0

foreach ($row in $csv) {
    $sku = $row.'Item Code'.Trim()
    $costPrice = $row.'Cost'.Replace(',', '').Replace('"', '').Trim()
    $inclPrice = $row.'Incl Price'.Replace(',', '').Replace('"', '').Trim()
    
    # Skip if no SKU or prices are invalid
    if ([string]::IsNullOrWhiteSpace($sku) -or 
        [string]::IsNullOrWhiteSpace($costPrice) -or 
        [string]::IsNullOrWhiteSpace($inclPrice)) {
        continue
    }
    
    # Convert to decimal
    try {
        $costPriceDecimal = [decimal]$costPrice
        $inclPriceDecimal = [decimal]$inclPrice
        
        # Calculate CostPrice Excl VAT (assuming Cost is already Excl VAT, but Incl Price is Incl VAT)
        # If Cost = 0, calculate from Incl Price
        if ($costPriceDecimal -eq 0 -and $inclPriceDecimal -gt 0) {
            $costPriceExcl = [Math]::Round($inclPriceDecimal / 1.15, 2)
        } else {
            $costPriceExcl = $costPriceDecimal
        }
        
        # Escape single quotes in SKU
        $skuEscaped = $sku.Replace("'", "''")
        
        # Generate UPDATE statement (updates if exists)
        $sql += @"

-- Update/Insert for SKU: $sku
IF EXISTS (
    SELECT 1 FROM Demo_Retail_Price drp
    INNER JOIN Demo_Retail_Product drprod ON drp.ProductID = drprod.ProductID AND drp.BranchID = drprod.BranchID
    WHERE drprod.SKU = '$skuEscaped' AND drp.BranchID = 6
)
BEGIN
    UPDATE drp
    SET drp.CostPrice = $costPriceExcl,
        drp.RetailPrice = $inclPriceDecimal,
        drp.EffectiveFrom = GETDATE(),
        drp.CreatedAt = GETDATE()
    FROM Demo_Retail_Price drp
    INNER JOIN Demo_Retail_Product drprod ON drp.ProductID = drprod.ProductID AND drp.BranchID = drprod.BranchID
    WHERE drprod.SKU = '$skuEscaped' AND drp.BranchID = 6;
    PRINT 'Updated: $sku';
END
ELSE
BEGIN
    -- Insert if product exists but no price record
    IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = '$skuEscaped' AND BranchID = 6)
    BEGIN
        INSERT INTO Demo_Retail_Price (ProductID, BranchID, CostPrice, RetailPrice, EffectiveFrom, CreatedAt)
        SELECT ProductID, 6, $costPriceExcl, $inclPriceDecimal, GETDATE(), GETDATE()
        FROM Demo_Retail_Product
        WHERE SKU = '$skuEscaped' AND BranchID = 6;
        PRINT 'Inserted: $sku';
    END
    ELSE
    BEGIN
        PRINT 'Product not found: $sku';
    END
END

"@
        
    } catch {
        Write-Host "Skipping invalid row: $sku - Cost: $costPrice, Incl: $inclPrice"
    }
}

# End transaction
$sql += @"

COMMIT TRANSACTION;

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

PRINT 'Price update completed for BranchID 6 (OD200)';
"@

# Write to file
$sql | Out-File -FilePath $outputSql -Encoding UTF8

Write-Host "SQL script generated successfully!"
Write-Host "Output file: $outputSql"
Write-Host "Total rows processed: $($csv.Count)"
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Review the generated SQL file"
Write-Host "2. Run it in SQL Server Management Studio or your database tool"
