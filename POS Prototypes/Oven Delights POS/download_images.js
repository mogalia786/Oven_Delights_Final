const https = require('https');
const fs = require('fs');
const path = require('path');

// Ensure images directory exists
const imagesDir = path.join(__dirname, 'images');
if (!fs.existsSync(imagesDir)) {
    fs.mkdirSync(imagesDir, { recursive: true });
}

// Product images to download
const productImages = [
    { id: 1, name: 'classic_croissant.jpg', url: 'https://via.placeholder.com/150/FF6B35/FFFFFF?text=Croissant' },
    { id: 2, name: 'almond_croissant.jpg', url: 'https://via.placeholder.com/150/4ECDC4/FFFFFF?text=Almond' },
    { id: 3, name: 'chocolate_croissant.jpg', url: 'https://via.placeholder.com/150/FFD166/000000?text=Choc' },
    { id: 4, name: 'apple_danish.jpg', url: 'https://via.placeholder.com/150/EF476F/FFFFFF?text=Apple' },
    { id: 5, name: 'cream_cheese_danish.jpg', url: 'https://via.placeholder.com/150/06D6A0/000000?text=Cheese' },
    { id: 6, name: 'french_vanilla_danish.jpg', url: 'https://via.placeholder.com/150/118AB2/FFFFFF?text=Vanilla' },
    { id: 7, name: 'strawberry_cream_danish.jpg', url: 'https://via.placeholder.com/150/073B4C/FFFFFF?text=Strawberry' },
    { id: 8, name: 'cherry_cheese_danish.jpg', url: 'https://via.placeholder.com/150/FF9F1C/000000?text=Cherry' },
    { id: 9, name: 'blueberry_cheese_danish.jpg', url: 'https://via.placeholder.com/150/6A4C93/FFFFFF?text=Blueberry' },
    { id: 10, name: 'blueberry_muffin.jpg', url: 'https://via.placeholder.com/150/1B9AAA/FFFFFF?text=Blueberry' },
    { id: 11, name: 'corn_muffin.jpg', url: 'https://via.placeholder.com/150/FFC43D/000000?text=Corn' },
    { id: 12, name: 'chocolate_muffin.jpg', url: 'https://via.placeholder.com/150/2D2D2A/FFFFFF?text=Choc' },
    { id: 13, name: 'apple_cinnamon_muffin.jpg', url: 'https://via.placeholder.com/150/F18F01/000000?text=Apple' },
    { id: 14, name: 'banana_nut_muffin.jpg', url: 'https://via.placeholder.com/150/FFD700/000000?text=Banana' },
    { id: 15, name: 'classic_pound_cake.jpg', url: 'https://via.placeholder.com/150/F8F4E3/000000?text=Classic' },
    { id: 16, name: 'lemon_pound_cake.jpg', url: 'https://via.placeholder.com/150/FFF44F/000000?text=Lemon' },
    { id: 17, name: 'marble_pound_cake.jpg', url: 'https://via.placeholder.com/150/4A4A4A/FFFFFF?text=Marble' }
];

// Download function
function downloadImage(url, filepath) {
    return new Promise((resolve, reject) => {
        const file = fs.createWriteStream(filepath);
        https.get(url, (response) => {
            response.pipe(file);
            file.on('finish', () => {
                file.close();
                console.log(`Downloaded ${filepath}`);
                resolve();
            });
        }).on('error', (err) => {
            fs.unlink(filepath, () => {}); // Delete the file if there's an error
            console.error(`Error downloading ${url}:`, err.message);
            reject(err);
        });
    });
}

// Download all images
async function downloadAllImages() {
    console.log('Starting image downloads...');
    
    for (const img of productImages) {
        const filePath = path.join(imagesDir, img.name);
        try {
            await downloadImage(img.url, filePath);
            // Add a small delay between downloads to be nice to the server
            await new Promise(resolve => setTimeout(resolve, 500));
        } catch (error) {
            console.error(`Failed to download ${img.name}:`, error.message);
        }
    }
    
    console.log('All downloads completed!');
    
    // Generate the updated products array with local image paths
    const updatedProducts = productImages.map(img => {
        const product = products.find(p => p.id === img.id);
        return {
            ...product,
            image: `images/${img.name}`
        };
    });
    
    console.log('\nUpdated products array (copy this to your code):');
    console.log(JSON.stringify(updatedProducts, null, 2));
}

// Run the download
const products = [
    { id: 1, name: 'Classic Croissant', price: 35.00, category: 'croissants', image: '' },
    { id: 2, name: 'Almond Croissant', price: 42.00, category: 'croissants', image: '' },
    { id: 3, name: 'Chocolate Croissant', price: 38.00, category: 'croissants', image: '' },
    { id: 4, name: 'Apple Danish', price: 32.00, category: 'danish', image: '' },
    { id: 5, name: 'Cream Cheese Danish', price: 36.00, category: 'danish', image: '' },
    { id: 6, name: 'French Vanilla Danish', price: 34.00, category: 'danish', image: '' },
    { id: 7, name: 'Strawberries & Cream Danish', price: 38.00, category: 'danish', image: '' },
    { id: 8, name: 'Cherry Cheese Danish', price: 36.00, category: 'danish', image: '' },
    { id: 9, name: 'Blueberry Cheese Danish', price: 36.00, category: 'danish', image: '' },
    { id: 10, name: 'Blueberry Muffin', price: 28.00, category: 'muffins', image: '' },
    { id: 11, name: 'Corn Muffin', price: 25.00, category: 'muffins', image: '' },
    { id: 12, name: 'Chocolate Muffin', price: 30.00, category: 'muffins', image: '' },
    { id: 13, name: 'Apple Cinnamon Muffin', price: 28.00, category: 'muffins', image: '' },
    { id: 14, name: 'Banana Nut Muffin', price: 30.00, category: 'muffins', image: '' },
    { id: 15, name: 'Classic Pound Cake', price: 45.00, category: 'pound-cakes', image: '' },
    { id: 16, name: 'Lemon Pound Cake', price: 48.00, category: 'pound-cakes', image: '' },
    { id: 17, name: 'Marble Pound Cake', price: 48.00, category: 'pound-cakes', image: '' }
];

downloadAllImages().catch(console.error);
