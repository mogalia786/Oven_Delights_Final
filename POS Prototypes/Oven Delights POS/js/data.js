// Sample product data
const menuProducts = [
    { 
        id: 1, 
        name: 'Margherita Pizza', 
        price: 89.99, 
        category: 'pizza', 
        image: 'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        description: 'Classic pizza with tomato sauce, mozzarella, and fresh basil',
        popular: true
    },
    { 
        id: 2, 
        name: 'Pepperoni Pizza', 
        price: 99.99, 
        category: 'pizza', 
        image: 'https://images.unsplash.com/photo-1601924582970-9238bcb405d3?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        description: 'Traditional pizza topped with spicy pepperoni and mozzarella cheese',
        popular: true
    },
    { 
        id: 3, 
        name: 'Chicken Burger', 
        price: 69.99, 
        category: 'burgers', 
        image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        description: 'Juicy chicken breast with lettuce, tomato, and special sauce',
        popular: true
    },
    { 
        id: 4, 
        name: 'Beef Burger', 
        price: 79.99, 
        category: 'burgers', 
        image: 'https://images.unsplash.com/photo-1553979459-d2229ba7433b?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        description: '100% pure beef patty with cheese, lettuce, and pickles',
        popular: true
    },
    { 
        id: 5, 
        name: 'Spaghetti Carbonara', 
        price: 74.99, 
        category: 'pasta', 
        image: 'https://images.unsplash.com/photo-1612874742237-6526221588e3?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        description: 'Classic Italian pasta with eggs, cheese, pancetta, and black pepper',
        popular: true
    },
    { 
        id: 6, 
        name: 'Penne Arrabbiata', 
        price: 69.99, 
        category: 'pasta', 
        image: 'https://images.unsplash.com/photo-1551183053-bf91a1d81111?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        description: 'Penne pasta in a spicy tomato and garlic sauce',
        popular: false
    },
    { 
        id: 7, 
        name: 'Caesar Salad', 
        price: 59.99, 
        category: 'salads', 
        image: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        description: 'Crisp romaine lettuce with Caesar dressing, croutons and parmesan',
        popular: true
    },
    { 
        id: 8, 
        name: 'Greek Salad', 
        price: 54.99, 
        category: 'salads', 
        image: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        description: 'Fresh vegetables, feta cheese, olives, and olive oil dressing',
        popular: false
    },
    { 
        id: 9, 
        name: 'Chocolate Lava Cake', 
        price: 39.99, 
        category: 'desserts', 
        image: 'https://images.unsplash.com/photo-1564355808539-22fda35bed7e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        description: 'Warm chocolate cake with a molten center, served with vanilla ice cream',
        popular: true
    },
    { 
        id: 10, 
        name: 'Tiramisu', 
        price: 44.99, 
        category: 'desserts', 
        image: 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        description: 'Classic Italian dessert with layers of coffee-soaked ladyfingers and mascarpone cream',
        popular: true
    },
    { 
        id: 11, 
        name: 'Coca-Cola', 
        price: 19.99, 
        category: 'drinks', 
        image: 'https://images.unsplash.com/photo-1554866585-cd94860890b7?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        description: 'Refreshing cola drink',
        popular: true
    },
    { 
        id: 12, 
        name: 'Orange Juice', 
        price: 24.99, 
        category: 'drinks', 
        image: 'https://images.unsplash.com/photo-1603569283847-aa295f0d016a?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        description: 'Freshly squeezed orange juice',
        popular: true
    },
    { 
        id: 13, 
        name: 'Garlic Bread', 
        price: 29.99, 
        category: 'sides', 
        image: 'https://images.unsplash.com/photo-1608196453270-85a2b0a4f6c3?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        description: 'Toasted bread with garlic butter and herbs',
        popular: true
    },
    { 
        id: 14, 
        name: 'French Fries', 
        price: 34.99, 
        category: 'sides', 
        image: 'https://images.unsplash.com/photo-1576107232684-1279f390859f?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
        description: 'Crispy golden fries with a pinch of salt',
        popular: true
    }
];

// Categories data
const categories = [
    { id: 'all', name: 'All Items', icon: 'fa-th-large' },
    { id: 'pizza', name: 'Pizza', icon: 'fa-pizza-slice' },
    { id: 'burgers', name: 'Burgers', icon: 'fa-hamburger' },
    { id: 'pasta', name: 'Pasta', icon: 'fa-utensils' },
    { id: 'salads', name: 'Salads', icon: 'fa-leaf' },
    { id: 'desserts', name: 'Desserts', icon: 'fa-ice-cream' },
    { id: 'drinks', name: 'Drinks', icon: 'fa-coffee' },
    { id: 'sides', name: 'Sides', icon: 'fa-bread-slice' }
];
