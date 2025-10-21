// Main application module
const POS = (function() {
    // State management
    const state = {
        cart: [],
        currentCategory: 'all',
        searchTerm: '',
        products: [],
        categories: []
    };

    // DOM Elements
    const elements = {
        productsGrid: document.getElementById('products-grid'),
        cartItems: document.getElementById('cart-items'),
        cartTotal: document.getElementById('cart-total'),
        cartCount: document.querySelector('.cart-count'),
        categoriesList: document.querySelector('.categories'),
        searchInput: document.querySelector('.search-bar input'),
        clearCartBtn: document.getElementById('clear-cart-btn'),
        checkoutBtn: document.getElementById('checkout-btn'),
        cartIcon: document.querySelector('.cart-icon')
    };

    // Initialize the application
    function init() {
        // Load data
        state.products = [...menuProducts];
        state.categories = [...categories];

        // Render initial UI
        renderCategories();
        renderProducts();
        updateCartUI();

        // Add event listeners
        addEventListeners();
    }

    // Add event listeners
    function addEventListeners() {
        // Search functionality
        elements.searchInput.addEventListener('input', (e) => {
            state.searchTerm = e.target.value.toLowerCase();
            renderProducts();
        });

        // Clear cart
        elements.clearCartBtn.addEventListener('click', clearCart);

        // Checkout
        elements.checkoutBtn.addEventListener('click', checkout);

        // Toggle cart on mobile
        if (window.innerWidth <= 768) {
            const cartHeader = document.querySelector('.cart-header');
            const cart = document.querySelector('.cart');
            
            cartHeader.addEventListener('click', () => {
                cart.classList.toggle('open');
            });
        }
    }

    // Render categories
    function renderCategories() {
        // Clear existing categories (except the first 'All' item)
        const allItems = document.querySelectorAll('.category-item');
        if (allItems.length > 0) {
            allItems.forEach((item, index) => {
                if (index > 0) item.remove();
            });
        }
        
        // Add other categories
        state.categories.forEach(category => {
            if (category.id === 'all') return;
            
            const categoryElement = document.createElement('div');
            categoryElement.className = 'category-item';
            categoryElement.dataset.category = category.id;
            categoryElement.innerHTML = `
                <i class="fas ${category.icon}"></i>
                <span>${category.name}</span>
            `;
            
            categoryElement.addEventListener('click', () => {
                state.currentCategory = category.id;
                document.querySelectorAll('.category-item')
                    .forEach(el => el.classList.remove('active'));
                categoryElement.classList.add('active');
                renderProducts();
            });
            
            elements.categoriesList.appendChild(categoryElement);
        });
    }

    // Render products
    function renderProducts() {
        elements.productsGrid.innerHTML = '';
        
        // Filter products based on category and search term
        let filteredProducts = [...state.products];
        
        // Filter by category
        if (state.currentCategory !== 'all') {
            filteredProducts = filteredProducts.filter(
                product => product.category === state.currentCategory
            );
        }
        
        // Filter by search term
        if (state.searchTerm) {
            filteredProducts = filteredProducts.filter(product => 
                product.name.toLowerCase().includes(state.searchTerm) ||
                product.description.toLowerCase().includes(state.searchTerm)
            );
        }
        
        // Display products or no results message
        if (filteredProducts.length === 0) {
            const noResults = document.createElement('div');
            noResults.className = 'no-results';
            noResults.textContent = 'No products found';
            noResults.style.gridColumn = '1 / -1';
            noResults.style.textAlign = 'center';
            noResults.style.padding = '40px 0';
            noResults.style.color = '#666';
            elements.productsGrid.appendChild(noResults);
            return;
        }
        
        // Add products to grid
        filteredProducts.forEach((product, index) => {
            const productElement = createProductElement(product);
            // Add staggered animation
            productElement.style.animationDelay = `${index * 0.05}s`;
            elements.productsGrid.appendChild(productElement);
        });
    }

    // Create product element
    function createProductElement(product) {
        const productElement = document.createElement('div');
        productElement.className = 'product-item';
        productElement.dataset.id = product.id;
        
        productElement.innerHTML = `
            <div class="product-image">
                <img src="${product.image}" alt="${product.name}" onerror="this.src='https://via.placeholder.com/300x200?text=No+Image'">
                ${product.popular ? '<span class="popular-tag">Popular</span>' : ''}
            </div>
            <div class="product-details">
                <h3>${product.name}</h3>
                <p class="price">R ${product.price.toFixed(2)}</p>
                <p class="description">${product.description}</p>
            </div>
        `;
        
        productElement.addEventListener('click', () => {
            addToCart(product);
        });
        
        return productElement;
    }

    // Add to cart
    function addToCart(product) {
        const existingItem = state.cart.find(item => item.id === product.id);
        
        if (existingItem) {
            existingItem.quantity += 1;
        } else {
            state.cart.push({
                ...product,
                quantity: 1
            });
        }
        
        updateCartUI();
        showNotification(`${product.name} added to cart`);
    }

    // Update cart UI
    function updateCartUI() {
        // Update cart items
        if (state.cart.length === 0) {
            elements.cartItems.innerHTML = `
                <div class="empty-cart-message">
                    <i class="fas fa-shopping-cart"></i>
                    <p>Your cart is empty</p>
                    <small>Add items to get started</small>
                </div>
            `;
            elements.checkoutBtn.disabled = true;
            elements.cartCount.style.display = 'none';
            elements.cartTotal.textContent = 'R 0.00';
            return;
        }
        
        // Clear cart items
        elements.cartItems.innerHTML = '';
        
        // Add cart items
        let total = 0;
        let itemCount = 0;
        
        state.cart.forEach((item, index) => {
            const itemTotal = item.price * item.quantity;
            total += itemTotal;
            itemCount += item.quantity;
            
            const itemElement = document.createElement('div');
            itemElement.className = 'cart-item';
            itemElement.innerHTML = `
                <div class="cart-item-image">
                    <img src="${item.image}" alt="${item.name}">
                </div>
                <div class="cart-item-details">
                    <h4>${item.name}</h4>
                    <div class="cart-item-price">R ${item.price.toFixed(2)}</div>
                    <div class="cart-item-quantity">
                        <button class="quantity-btn" data-action="decrease" data-index="${index}">-</button>
                        <span>${item.quantity}</span>
                        <button class="quantity-btn" data-action="increase" data-index="${index}">+</button>
                    </div>
                </div>
                <button class="remove-item" data-index="${index}">×</button>
            `;
            
            elements.cartItems.appendChild(itemElement);
        });
        
        // Update total and count
        elements.cartTotal.textContent = `R ${total.toFixed(2)}`;
        elements.cartCount.textContent = itemCount;
        elements.cartCount.style.display = 'flex';
        elements.checkoutBtn.disabled = false;
        
        // Add event listeners for quantity buttons
        document.querySelectorAll('.quantity-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const action = btn.dataset.action;
                const index = parseInt(btn.dataset.index);
                
                if (action === 'increase') {
                    state.cart[index].quantity += 1;
                } else if (action === 'decrease' && state.cart[index].quantity > 1) {
                    state.cart[index].quantity -= 1;
                }
                
                updateCartUI();
            });
        });
        
        // Add event listeners for remove buttons
        document.querySelectorAll('.remove-item').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                removeFromCart(parseInt(btn.dataset.index));
            });
        });
    }

    // Remove from cart
    function removeFromCart(index) {
        if (index >= 0 && index < state.cart.length) {
            const itemName = state.cart[index].name;
            state.cart.splice(index, 1);
            updateCartUI();
            showNotification(`${itemName} removed from cart`);
        }
    }

    // Clear cart
    function clearCart() {
        if (state.cart.length === 0) return;
        
        state.cart = [];
        updateCartUI();
        showNotification('Cart cleared');
    }

    // Checkout
    function checkout() {
        if (state.cart.length === 0) {
            showNotification('Your cart is empty!');
            return;
        }
        
        // In a real app, you would process the payment here
        const total = state.cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
        
        // Show order summary
        const orderSummary = state.cart.map(item => 
            `${item.quantity}x ${item.name} - R ${(item.price * item.quantity).toFixed(2)}`
        ).join('\n');
        
        showNotification('Order placed successfully!');
        
        // In a real app, you would send this to your backend
        console.log('Order placed:', {
            items: state.cart,
            total: total,
            timestamp: new Date().toISOString()
        });
        
        // Clear cart after successful checkout
        state.cart = [];
        updateCartUI();
    }

    // Show notification
    function showNotification(message) {
        const notification = document.querySelector('.notification');
        notification.textContent = message;
        notification.classList.add('show');
        
        // Hide after 3 seconds
        setTimeout(() => {
            notification.classList.remove('show');
        }, 3000);
    }

    // Public API
    return {
        init: init
    };
})();

// Global variables
let currentPaymentMethod = null;
let isScanning = false;
let scanTimer = null;

// Initialize the application when the DOM is fully loaded
document.addEventListener('DOMContentLoaded', () => {
    POS.init();
    
    // Initialize payment method events
    initPaymentMethods();
    
    // Initialize function key events
    initFunctionKeys();
    
    // Initialize barcode scanner
    initBarcodeScanner();
    
    // Listen for F-key presses
    document.addEventListener('keydown', handleKeyPress);
});



// Initialize payment method functionality
function initPaymentMethods() {
    const paymentModal = document.getElementById('paymentModal');
    const closePayment = document.getElementById('closePayment');
    const cancelPayment = document.getElementById('cancelPayment');
    const confirmPayment = document.getElementById('confirmPayment');
    const paymentOptions = document.querySelectorAll('.payment-option');
    
    // Open payment modal when checkout is clicked
    document.querySelector('.checkout-btn').addEventListener('click', function() {
        if (getCartTotal() <= 0) {
            showNotification('Please add items to cart first', 'error');
            return;
        }
        document.getElementById('paymentAmount').textContent = formatCurrency(getCartTotal());
        paymentModal.classList.add('show');
        currentPaymentMethod = null;
        document.querySelectorAll('.payment-option').forEach(option => {
            option.classList.remove('selected');
        });
    });
    
    // Close payment modal
    const closeModal = () => {
        paymentModal.classList.remove('show');
    };
    
    closePayment.addEventListener('click', closeModal);
    cancelPayment.addEventListener('click', closeModal);
    
    // Select payment method
    paymentOptions.forEach(option => {
        option.addEventListener('click', function() {
            paymentOptions.forEach(opt => opt.classList.remove('selected'));
            this.classList.add('selected');
            currentPaymentMethod = this.getAttribute('data-method');
        });
    });
    
    // Confirm payment
    confirmPayment.addEventListener('click', function() {
        if (!currentPaymentMethod) {
            showNotification('Please select a payment method', 'error');
            return;
        }
        
        // Process payment (in a real app, this would integrate with a payment processor)
        processPayment(currentPaymentMethod);
    });
}

// Process payment
function processPayment(method) {
    const total = getCartTotal();
    
    // In a real app, you would integrate with a payment processor here
    // For demo purposes, we'll just show a success message
    showNotification(`Payment of ${formatCurrency(total)} via ${method} processed successfully`, 'success');
    
    // Close the payment modal
    document.getElementById('paymentModal').classList.remove('show');
    
    // Clear the cart
    clearCart();
    
    // Update the UI
    updateCartUI();
    
    // Print receipt (if needed)
    // printReceipt();
}

// Initialize function keys
function initFunctionKeys() {
    const functionKeys = document.querySelectorAll('.function-key');
    
    functionKeys.forEach(key => {
        key.addEventListener('click', function() {
            const action = this.getAttribute('data-action');
            handleFunctionKey(action);
        });
    });
}

// Handle function key actions
function handleFunctionKey(action) {
    switch(action) {
        case 'f1': // New Order
            if (confirm('Start a new order? Any items in the current order will be cleared.')) {
                clearCart();
                updateCartUI();
            }
            break;
            
        case 'f2': // Search
            const searchTerm = prompt('Enter search term:');
            if (searchTerm) {
                searchProducts(searchTerm);
            }
            break;
            
        case 'f3': // Discount
            const discount = prompt('Enter discount amount (R) or percentage (%):');
            if (discount) {
                applyDiscount(discount);
            }
            break;
            
        case 'f4': // Void Item
            if (cart.length === 0) {
                showNotification('No items in cart', 'error');
                return;
            }
            const itemId = prompt('Enter item ID to void:');
            if (itemId) {
                voidItem(itemId);
            }
            break;
            
        case 'f5': // Pay Cash
            currentPaymentMethod = 'cash';
            document.getElementById('paymentAmount').textContent = formatCurrency(getCartTotal());
            document.querySelector('.payment-option[data-method="cash"]').click();
            document.getElementById('confirmPayment').click();
            break;
            
        case 'f6': // Pay Card
            currentPaymentMethod = 'card';
            document.getElementById('paymentAmount').textContent = formatCurrency(getCartTotal());
            document.querySelector('.payment-option[data-method="card"]').click();
            document.getElementById('paymentModal').classList.add('show');
            break;
            
        case 'f7': // Print Bill
            printBill();
            break;
            
        case 'f8': // Checkout
            document.querySelector('.checkout-btn').click();
            break;
    }
}

// Initialize barcode scanner
function initBarcodeScanner() {
    const barcodeInput = document.getElementById('barcodeInput');
    const scanIndicator = document.getElementById('scanIndicator');
    
    // Focus the barcode input when the page loads
    barcodeInput.focus();
    
    // Handle barcode input
    barcodeInput.addEventListener('input', function(e) {
        const barcode = this.value.trim();
        
        // If the barcode is at least 4 characters long and we're not already processing a scan
        if (barcode.length >= 4 && !isScanning) {
            isScanning = true;
            showScanIndicator();
            
            // Clear any existing timer
            if (scanTimer) {
                clearTimeout(scanTimer);
            }
            
            // Set a timer to process the barcode after a short delay
            scanTimer = setTimeout(() => {
                processBarcode(barcode);
                barcodeInput.value = '';
                isScanning = false;
                hideScanIndicator();
            }, 100);
        }
    });
    
    // Handle keydown to detect the end of a barcode scan
    barcodeInput.addEventListener('keydown', function(e) {
        // If Enter is pressed, process the barcode immediately
        if (e.key === 'Enter') {
            e.preventDefault();
            const barcode = this.value.trim();
            
            if (barcode.length > 0) {
                processBarcode(barcode);
                this.value = '';
            }
        }
    });
    
    // Show scan indicator
    function showScanIndicator() {
        scanIndicator.classList.add('show');
    }
    
    // Hide scan indicator
    function hideScanIndicator() {
        scanIndicator.classList.remove('show');
    }
}

// Process barcode
function processBarcode(barcode) {
    // In a real app, you would look up the product by barcode
    // For demo purposes, we'll just show a notification
    const product = products.find(p => p.barcode === barcode);
    
    if (product) {
        addToCart(product);
        showNotification(`Scanned: ${product.name}`, 'success');
    } else {
        showNotification('Product not found', 'error');
    }
}

// Search products
function searchProducts(term) {
    const searchTerm = term.toLowerCase();
    const results = products.filter(product => 
        product.name.toLowerCase().includes(searchTerm) ||
        product.description.toLowerCase().includes(searchTerm) ||
        (product.barcode && product.barcode.includes(searchTerm))
    );
    
    // Display search results
    displayProducts(results);
    
    // Update category highlighting
    document.querySelectorAll('.category-item').forEach(item => {
        item.classList.remove('active');
    });
    
    // Show search results header
    document.querySelector('.products-header h2').textContent = `Search Results for "${term}"`;
}

// Apply discount
function applyDiscount(discount) {
    // In a real app, you would apply the discount to the cart
    // For demo purposes, we'll just show a notification
    showNotification(`Discount of ${discount} applied`, 'success');
}

// Void item
function voidItem(itemId) {
    // In a real app, you would remove the item from the cart
    // For demo purposes, we'll just show a notification
    showNotification(`Item ${itemId} voided`, 'success');
}

// Print bill
function printBill() {
    // In a real app, you would generate and print a bill
    // For demo purposes, we'll just show a notification
    showNotification('Printing bill...', 'info');
}

// Handle keyboard shortcuts
function handleKeyPress(e) {
    // Check for F1-F8 keys
    if (e.key && e.key.startsWith('F') && e.key.length <= 3) {
        e.preventDefault();
        const keyNum = parseInt(e.key.substring(1));
        if (keyNum >= 1 && keyNum <= 8) {
            const action = `f${keyNum}`;
            handleFunctionKey(action);
            
            // Add visual feedback
            const keyElement = document.querySelector(`.function-key[data-action="${action}"]`);
            if (keyElement) {
                keyElement.classList.add('active');
                setTimeout(() => {
                    keyElement.classList.remove('active');
                }, 200);
            }
        }
    }
    
    // Check for barcode scanner input (focus on barcode input if not already focused)
    if (e.target.tagName !== 'INPUT' && e.target.tagName !== 'TEXTAREA' && !e.ctrlKey && !e.altKey && !e.metaKey) {
        const barcodeInput = document.getElementById('barcodeInput');
        if (barcodeInput && e.key.length === 1) {
            barcodeInput.focus();
            barcodeInput.value = e.key;
            barcodeInput.dispatchEvent(new Event('input'));
        }
    }
}

// Make the app responsive
window.addEventListener('resize', () => {
    const cart = document.querySelector('.cart');
    if (window.innerWidth > 768) {
        cart.classList.remove('open');
    }
});
