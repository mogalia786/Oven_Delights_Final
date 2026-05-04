# =============================================
# CREATE MASTER PRODUCT LIST WITH RETAIL FLAG
# Merges two CSV files and adds Retail (Boolean) column
# =============================================

$file1 = "c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\ITEM_LIST_NEW_2025.csv"
$file2 = "c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\StockItems with Prices and descriptions\Combined_Inventory.csv"
$outputFile = "c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\MASTER_PRODUCT_LIST.csv"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "CREATING MASTER PRODUCT LIST" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Define retail categories (from POS screenshot)
$retailCategories = @(
    'beverages', 'biscuits', 'biscuit', 'buttercream', 'candle', 'exotic cakes', 'exotic', 'novelty',
    'platter', 'savoury', 'shop front', 'buttercream birthday cake', 'drinks',
    'fresh cream birthday cakes', 'fresh cream', 'fruitcake', 'pies', 'snacks', 'sweets', 'wedding cakes',
    'consumables', 'equipment'
)

# Non-retail categories (ingredients, packaging, etc.)
$nonRetailCategories = @(
    'ingredients', 'packaging', 'raw material', 'supplies', 'equipment'
)

Write-Host "Step 1: Reading File 1 (ITEM_LIST_NEW_2025.csv)..." -ForegroundColor Yellow
$data1 = Import-Csv -Path $file1
Write-Host "Found $($data1.Count) rows" -ForegroundColor Green

Write-Host "Step 2: Reading File 2 (Combined_Inventory.csv)..." -ForegroundColor Yellow
$csvContent = Get-Content -Path $file2
$data2 = $csvContent | Select-Object -Skip 1 | ConvertFrom-Csv -Header 'ItemCode','BARCODE','ITEM_DESCRIPTION','CATERGORY','item_catergory','Ingredients','Item_Description2','Whse','Cost','Incl_Price','Extra'
Write-Host "Found $($data2.Count) rows" -ForegroundColor Green

Write-Host ""
Write-Host "Step 3: Merging data and adding Retail flag..." -ForegroundColor Yellow

# Create hashtable for quick lookup from file2 (has prices)
$priceData = @{}
foreach ($row in $data2) {
    $code = $row.ItemCode.Trim()
    if ($code) {
        $priceData[$code] = $row
    }
}

# Create master list
$masterList = @()

foreach ($row in $data1) {
    $itemCode = $row.'ITEM CCODE'.Trim()
    $category = $row.'CATERGORY'.ToLower().Trim()
    $itemCategory = $row.'item catergory'.ToLower().Trim()
    
    # Determine if retail product
    $isRetail = $false
    
    # Check if category is in retail list
    if ($retailCategories -contains $category) {
        $isRetail = $true
    }
    
    # Exclude if it's ingredients, packaging, or sub recipe
    if ($category -like '*ingredient*' -or $category -like '*packaging*' -or 
        $category -like '*sub recipe*' -or $category -like '*sub-recipe*' -or
        $itemCategory -like '*ingredient*' -or $itemCategory -like '*packaging*' -or
        $itemCategory -like '*sub recipe*' -or $itemCategory -like '*sub-recipe*' -or
        $itemCategory -eq 'rawmaterial') {
        $isRetail = $false
    }
    
    # Get price data if available
    $price = "0.00"
    $cost = "0.00"
    if ($priceData.ContainsKey($itemCode)) {
        $price = $priceData[$itemCode].Incl_Price
        $cost = $priceData[$itemCode].Cost
    }
    
    # Create master record
    $masterRecord = [PSCustomObject]@{
        'ItemCode' = $itemCode
        'Barcode' = $row.'BARCODE'
        'ItemDescription' = $row.'ITEM DESCRIPTION'
        'Category' = $row.'CATERGORY'
        'ItemCategory' = $row.'item catergory'
        'UnitOfMeasure' = $row.'unit of measure'
        'SellingPrice' = $price
        'CostPrice' = $cost
        'IsRetail' = $isRetail
    }
    
    $masterList += $masterRecord
}

Write-Host "Created $($masterList.Count) master records" -ForegroundColor Green

Write-Host ""
Write-Host "Step 4: Analyzing data..." -ForegroundColor Yellow

$retailCount = ($masterList | Where-Object { $_.IsRetail -eq $true }).Count
$nonRetailCount = ($masterList | Where-Object { $_.IsRetail -eq $false }).Count
$withPriceCount = ($masterList | Where-Object { [decimal]$_.SellingPrice.Replace(',','') -gt 0 }).Count

Write-Host "  Retail products: $retailCount" -ForegroundColor Green
Write-Host "  Non-retail (ingredients/packaging): $nonRetailCount" -ForegroundColor Yellow
Write-Host "  Products with prices: $withPriceCount" -ForegroundColor Green

Write-Host ""
Write-Host "Step 5: Exporting to CSV..." -ForegroundColor Yellow
$masterList | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ MASTER PRODUCT LIST CREATED!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Output file: $outputFile" -ForegroundColor Cyan
Write-Host ""
Write-Host "Columns:" -ForegroundColor Yellow
Write-Host "  - ItemCode" -ForegroundColor White
Write-Host "  - Barcode" -ForegroundColor White
Write-Host "  - ItemDescription" -ForegroundColor White
Write-Host "  - Category" -ForegroundColor White
Write-Host "  - ItemCategory" -ForegroundColor White
Write-Host "  - UnitOfMeasure" -ForegroundColor White
Write-Host "  - SellingPrice" -ForegroundColor White
Write-Host "  - CostPrice" -ForegroundColor White
Write-Host "  - IsRetail (TRUE/FALSE)" -ForegroundColor Green
Write-Host ""
Write-Host "Next step: Import this master list into Products table" -ForegroundColor Yellow
