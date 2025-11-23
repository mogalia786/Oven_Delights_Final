# PowerShell script to convert CSV to SQL INSERT statements
# This will create a SQL file with INSERT statements for the missing 563 products

$csvPath = "C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\ITEM_LIST_WITH_CATEGORY_IDS.csv"
$outputPath = "C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Database\Branch\Import_Missing_Products.sql"

# Read CSV
$products = Import-Csv -Path $csvPath

# Start SQL script
$sql = @"
-- =============================================
-- Import Missing 563 Products from CSV to Products Table
-- Generated from ITEM_LIST_WITH_CATEGORY_IDS.csv
-- =============================================

-- Check current count before import
SELECT 'Before Import' AS Stage, COUNT(*) AS ProductCount FROM Products;

-- Start transaction
BEGIN TRANSACTION;

"@

$insertCount = 0

foreach ($product in $products) {
    $itemCode = $product.'ITEM CCODE'.Replace("'", "''")
    $barcode = if ($product.BARCODE) { $product.BARCODE.Replace("'", "''") } else { "" }
    $description = $product.'ITEM DESCRIPTION'.Replace("'", "''")
    $categoryID = $product.CATERGORY
    $itemCategory = $product.'item catergory'
    $uom = $product.'unit of measure'
    
    # Map item category to ItemType (must match constraint: 'internal', 'external', 'Manufactured')
    $itemType = if ($itemCategory -eq 'internal') { 'internal' } else { 'external' }
    
    # Create INSERT statement - only insert if ProductCode doesn't exist
    $sql += @"

-- $description
IF NOT EXISTS (SELECT 1 FROM Products WHERE ProductCode = '$itemCode')
BEGIN
    INSERT INTO Products (ProductCode, ProductName, CategoryID, SubcategoryID, ItemType, BaseUoM, IsActive, CreatedDate)
    VALUES ('$itemCode', '$description', $categoryID, NULL, '$itemType', '$uom', 1, GETDATE());
    PRINT 'Inserted: $itemCode - $description';
END
ELSE
BEGIN
    -- Update CategoryID if product exists
    UPDATE Products 
    SET CategoryID = $categoryID, 
        ItemType = '$itemType',
        BaseUoM = '$uom'
    WHERE ProductCode = '$itemCode';
    PRINT 'Updated: $itemCode - $description';
END

"@
    $insertCount++
}

# End SQL script
$sql += @"

COMMIT TRANSACTION;

-- Check count after import
SELECT 'After Import' AS Stage, COUNT(*) AS ProductCount FROM Products;

-- Verify we have 1,587 products
SELECT 
    COUNT(*) AS TotalProducts,
    1587 AS ExpectedProducts,
    COUNT(*) - 1587 AS Difference,
    CASE 
        WHEN COUNT(*) = 1587 THEN '✓ SUCCESS - Products table now has 1,587 products'
        ELSE '⚠ Still missing ' + CAST(1587 - COUNT(*) AS VARCHAR) + ' products'
    END AS Status
FROM Products;

PRINT 'Import complete! Processed $insertCount products from CSV.';
"@

# Write to file
$sql | Out-File -FilePath $outputPath -Encoding UTF8

Write-Host "SQL import script created: $outputPath"
Write-Host "Total products in CSV: $insertCount"
Write-Host "Run the generated SQL file to import missing products"
