# Create images directory if it doesn't exist
$imagesDir = "$PSScriptRoot\images"
if (-not (Test-Path -Path $imagesDir)) {
    New-Item -ItemType Directory -Path $imagesDir | Out-Null
}

# List of product images to download
$productImages = @(
    @{id=1; name="classic_croissant.jpg"; url="https://via.placeholder.com/150/FF6B35/FFFFFF?text=Croissant"},
    @{id=2; name="almond_croissant.jpg"; url="https://via.placeholder.com/150/4ECDC4/FFFFFF?text=Almond"},
    @{id=3; name="chocolate_croissant.jpg"; url="https://via.placeholder.com/150/FFD166/000000?text=Choc"},
    @{id=4; name="apple_danish.jpg"; url="https://via.placeholder.com/150/EF476F/FFFFFF?text=Apple"},
    @{id=5; name="cream_cheese_danish.jpg"; url="https://via.placeholder.com/150/06D6A0/000000?text=Cheese"},
    @{id=6; name="french_vanilla_danish.jpg"; url="https://via.placeholder.com/150/118AB2/FFFFFF?text=Vanilla"},
    @{id=7; name="strawberry_cream_danish.jpg"; url="https://via.placeholder.com/150/073B4C/FFFFFF?text=Strawberry"},
    @{id=8; name="cherry_cheese_danish.jpg"; url="https://via.placeholder.com/150/FF9F1C/000000?text=Cherry"},
    @{id=9; name="blueberry_cheese_danish.jpg"; url="https://via.placeholder.com/150/6A4C93/FFFFFF?text=Blueberry"},
    @{id=10; name="blueberry_muffin.jpg"; url="https://via.placeholder.com/150/1B9AAA/FFFFFF?text=Blueberry"},
    @{id=11; name="corn_muffin.jpg"; url="https://via.placeholder.com/150/FFC43D/000000?text=Corn"},
    @{id=12; name="chocolate_muffin.jpg"; url="https://via.placeholder.com/150/2D2D2A/FFFFFF?text=Choc"},
    @{id=13; name="apple_cinnamon_muffin.jpg"; url="https://via.placeholder.com/150/F18F01/000000?text=Apple"},
    @{id=14; name="banana_nut_muffin.jpg"; url="https://via.placeholder.com/150/FFD700/000000?text=Banana"},
    @{id=15; name="classic_pound_cake.jpg"; url="https://via.placeholder.com/150/F8F4E3/000000?text=Classic"},
    @{id=16; name="lemon_pound_cake.jpg"; url="https://via.placeholder.com/150/FFF44F/000000?text=Lemon"},
    @{id=17; name="marble_pound_cake.jpg"; url="https://via.placeholder.com/150/4A4A4A/FFFFFF?text=Marble"}
)

# Download each image
foreach ($img in $productImages) {
    $filePath = Join-Path -Path $imagesDir -ChildPath $img.name
    
    # Only download if the file doesn't already exist
    if (-not (Test-Path -Path $filePath)) {
        Write-Host "Downloading $($img.name)..."
        try {
            Invoke-WebRequest -Uri $img.url -OutFile $filePath
            Start-Sleep -Milliseconds 500  # Be nice to the server
        } catch {
            Write-Warning "Failed to download $($img.name): $_"
        }
    } else {
        Write-Host "Skipping $($img.name) - already exists"
    }
}

Write-Host "`nAll images have been downloaded to: $imagesDir"
Write-Host "You can now run the POS system with local images."
