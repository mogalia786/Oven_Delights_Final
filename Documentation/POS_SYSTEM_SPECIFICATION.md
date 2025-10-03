# OVEN DELIGHTS ERP - POINT OF SALE (POS) SYSTEM SPECIFICATION

## OVERVIEW
Modern, touchscreen-friendly POS system with futuristic aesthetic design, full keyboard shortcut support (F-keys), and complete integration with inventory, accounting, and multi-branch operations.

---

## 1. DESIGN PHILOSOPHY

### **Visual Design:**
- **Futuristic Aesthetic**: Clean, modern UI with smooth animations
- **Touchscreen Optimized**: Large buttons, swipe gestures, minimal text input
- **Responsive Layout**: Adapts to different screen sizes (tablet, desktop, touchscreen terminal)
- **Color Scheme**: Professional with brand colors, high contrast for readability
- **Typography**: Large, clear fonts for quick scanning
- **Product Images**: High-quality images for visual product selection

### **User Experience:**
- **Speed First**: Minimize clicks/taps to complete sale
- **Intuitive Navigation**: Category → Subcategory → Product flow
- **Visual Feedback**: Immediate response to all actions
- **Error Prevention**: Clear validation, undo capabilities
- **Accessibility**: Keyboard shortcuts for power users

---

## 2. KEYBOARD SHORTCUTS (F-KEYS) - SAGE POS COMPATIBLE

### **Core Functions:**
| Key | Function | Description |
|-----|----------|-------------|
| **F1** | Help | Quick help overlay with shortcuts |
| **F2** | Product Search | Quick search by SKU/Name/Barcode |
| **F3** | Customer Lookup | Find/Add customer |
| **F4** | Price Override | Manager override for price changes |
| **F5** | Discount | Apply discount to item/transaction |
| **F6** | Void Item | Remove selected item from cart |
| **F7** | Void Transaction | Cancel entire transaction |
| **F8** | Hold Transaction | Park transaction for later |
| **F9** | Recall Transaction | Retrieve parked transaction |
| **F10** | Cash Payment | Quick cash payment |
| **F11** | Card Payment | Quick card payment |
| **F12** | Complete Sale | Finalize and print receipt |

### **Extended Functions:**
| Key Combo | Function | Description |
|-----------|----------|-------------|
| **Shift+F1** | Manager Login | Supervisor access |
| **Shift+F2** | Stock Inquiry | Check stock levels |
| **Shift+F3** | Customer History | View customer purchases |
| **Shift+F4** | Refund | Process return/refund |
| **Shift+F5** | Loyalty Points | Apply/View loyalty |
| **Shift+F6** | Gift Card | Activate/Redeem gift card |
| **Shift+F7** | Layby/Layaway | Create layby transaction |
| **Shift+F8** | Quote | Create sales quote |
| **Shift+F9** | Reports | Quick reports menu |
| **Shift+F10** | End of Day | Cash up/close shift |
| **Shift+F11** | Settings | POS settings |
| **Shift+F12** | Logout | Sign out cashier |

### **Numeric Shortcuts:**
| Key | Function |
|-----|----------|
| **Enter** | Add product to cart |
| **Esc** | Cancel/Back |
| **Tab** | Next field |
| **+** | Increase quantity |
| **-** | Decrease quantity |
| **\*** | Multiply (qty × price) |
| **/** | Calculator |
| **Del** | Delete/Clear |

---

## 3. MAIN POS SCREEN LAYOUT

```
┌─────────────────────────────────────────────────────────────────────┐
│  OVEN DELIGHTS POS          Branch: Main Store    Cashier: John D. │
│  [F1 Help] [F2 Search] [F3 Customer] [F8 Hold] [F12 Complete]      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────┐  ┌──────────────────────────────────┐│
│  │  CATEGORIES (Left)      │  │  SHOPPING CART (Right)           ││
│  │                         │  │                                  ││
│  │  ┌──────┐  ┌──────┐    │  │  Item              Qty  Price    ││
│  │  │ 🍞   │  │ 🥤   │    │  │  Chocolate Cake     1   R 85.00  ││
│  │  │Bakery│  │Drinks│    │  │  Coca-Cola 500ml    2   R 30.00  ││
│  │  └──────┘  └──────┘    │  │  White Bread        1   R 15.00  ││
│  │                         │  │                                  ││
│  │  ┌──────┐  ┌──────┐    │  │  ─────────────────────────────  ││
│  │  │ 🍰   │  │ 🥗   │    │  │  Subtotal:              R 130.00 ││
│  │  │Cakes │  │Salads│    │  │  VAT (15%):             R  19.50 ││
│  │  └──────┘  └──────┘    │  │  ─────────────────────────────  ││
│  │                         │  │  TOTAL:                 R 149.50 ││
│  └─────────────────────────┘  │                                  ││
│                                │  [F6 Void] [F5 Discount]        ││
│  ┌─────────────────────────┐  └──────────────────────────────────┘│
│  │  PRODUCTS (Center)      │                                      │
│  │                         │  ┌──────────────────────────────────┐│
│  │  ┌────┐ ┌────┐ ┌────┐  │  │  PAYMENT (Bottom Right)          ││
│  │  │[🍰]│ │[🍰]│ │[🍰]│  │  │                                  ││
│  │  │R85 │ │R95 │ │R75 │  │  │  [F10 Cash]  [F11 Card]         ││
│  │  │Choc│ │Van │ │Red │  │  │  [Split]     [Account]          ││
│  │  └────┘ └────┘ └────┘  │  │                                  ││
│  │                         │  └──────────────────────────────────┘│
│  └─────────────────────────┘                                      │
│                                                                     │
│  [Barcode: _______________]  [Qty: 1]  [F2 Search Product]        │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 4. NAVIGATION FLOW

### **Product Selection Flow:**
```
1. HOME SCREEN
   ↓
2. SELECT CATEGORY (Bakery, Drinks, Cakes, etc.)
   - Large touchable tiles with icons/images
   - Grid layout (3-4 columns)
   ↓
3. SELECT SUBCATEGORY (Optional - if category has subcategories)
   - Bread, Pastries, Donuts
   - Smooth slide-in animation
   ↓
4. SELECT PRODUCT
   - Product tiles with:
     * Product image (from Products.ProductImage BLOB)
     * Product name
     * Price
     * Stock indicator (green/yellow/red)
   - Tap to add to cart
   ↓
5. CART UPDATED
   - Item appears in cart
   - Quantity adjustable
   - Smooth animation
   ↓
6. REPEAT or CHECKOUT
```

### **Alternative Flows:**
- **Barcode Scan**: Bypass navigation, add directly to cart
- **Quick Search (F2)**: Type product name/SKU, instant results
- **Recent Items**: Quick access to frequently sold items

---

## 5. DATABASE INTEGRATION

### **A. Product Lookup (On Category/Search):**
```sql
-- Get products by category
SELECT 
    p.ProductID,
    p.SKU,
    p.ProductName,
    p.ItemType,
    p.ProductImage,
    p.AverageCost,
    c.CategoryName,
    sc.SubcategoryName,
    rs.QtyOnHand,
    rs.AverageCost AS BranchCost
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
LEFT JOIN Subcategories sc ON p.SubcategoryID = sc.SubcategoryID
LEFT JOIN Retail_Stock rs ON rs.VariantID = p.ProductID 
    AND rs.BranchID = @CurrentBranchID
WHERE p.CategoryID = @CategoryID
  AND p.IsActive = 1
  AND rs.QtyOnHand > 0
ORDER BY p.ProductName;
```

### **B. Barcode Scan:**
```sql
-- Quick product lookup by SKU/Barcode
SELECT 
    p.ProductID,
    p.ProductName,
    p.ItemType,
    rs.QtyOnHand,
    rs.AverageCost,
    pr.SellingPrice
FROM Products p
LEFT JOIN Retail_Stock rs ON rs.VariantID = p.ProductID 
    AND rs.BranchID = @CurrentBranchID
LEFT JOIN ProductPricing pr ON pr.ProductID = p.ProductID
WHERE p.SKU = @Barcode
  AND p.IsActive = 1;
```

### **C. Stock Check (Shift+F2):**
```sql
-- Real-time stock inquiry
SELECT 
    p.ProductName,
    rs.QtyOnHand,
    rs.ReorderPoint,
    rs.Location,
    CASE 
        WHEN rs.QtyOnHand <= 0 THEN 'Out of Stock'
        WHEN rs.QtyOnHand <= rs.ReorderPoint THEN 'Low Stock'
        ELSE 'In Stock'
    END AS StockStatus
FROM Products p
INNER JOIN Retail_Stock rs ON rs.VariantID = p.ProductID
WHERE rs.BranchID = @CurrentBranchID
  AND p.ProductID = @ProductID;
```

---

## 6. SALE TRANSACTION PROCESS

### **Step-by-Step Flow:**

#### **1. Add Items to Cart**
```vb
For Each item In cart
    ' Validate stock availability
    If Retail_Stock.QtyOnHand < item.Quantity Then
        ShowError("Insufficient stock")
        Exit
    End If
Next
```

#### **2. Apply Discounts (F5)**
```vb
' Discount types:
- Percentage (10% off)
- Fixed amount (R10 off)
- Manager override required for > 20%
```

#### **3. Select Payment Method**
```vb
Payment Options:
- Cash (F10)
- Card (F11)
- Account (Customer credit)
- Split payment (Cash + Card)
- Gift Card
- Loyalty Points
```

#### **4. Process Sale Transaction**
```sql
BEGIN TRANSACTION;

-- 1. Create Sale Header
INSERT INTO Sales (
    SaleNumber, BranchID, CashierID, CustomerID,
    SaleDate, SubTotal, VATAmount, TotalAmount,
    PaymentMethod, Status
) VALUES (...);

-- 2. Create Sale Lines
INSERT INTO SaleLines (
    SaleID, ProductID, Quantity, UnitPrice, 
    LineTotal, CostPrice
) VALUES (...);

-- 3. Update Retail_Stock (Reduce inventory)
UPDATE Retail_Stock
SET QtyOnHand = QtyOnHand - @Quantity
WHERE VariantID = @ProductID
  AND BranchID = @BranchID;

-- 4. Record Stock Movement
INSERT INTO Retail_StockMovements (
    VariantID, BranchID, QtyDelta, Reason,
    Ref1, Ref2, CreatedBy
) VALUES (
    @ProductID, @BranchID, -@Quantity, 'Sale',
    @SaleNumber, @ReceiptNumber, @CashierID
);

-- 5. Create Ledger Entries
-- Debit: Cash/Debtors
-- Credit: Sales Revenue
INSERT INTO JournalDetails (...);

-- Debit: Cost of Sales
-- Credit: Inventory
INSERT INTO JournalDetails (...);

COMMIT TRANSACTION;
```

#### **5. Print Receipt**
```
┌─────────────────────────────┐
│     OVEN DELIGHTS           │
│     Main Store              │
│     123 Main St, City       │
│     Tel: 012-345-6789       │
├─────────────────────────────┤
│ Receipt: RCP-2025-001234    │
│ Date: 2025-09-30 14:30      │
│ Cashier: John Doe           │
├─────────────────────────────┤
│ Chocolate Cake    1  R 85.00│
│ Coca-Cola 500ml   2  R 30.00│
│ White Bread       1  R 15.00│
├─────────────────────────────┤
│ Subtotal:           R 130.00│
│ VAT (15%):          R  19.50│
├─────────────────────────────┤
│ TOTAL:              R 149.50│
│                             │
│ Payment: Cash               │
│ Tendered:           R 150.00│
│ Change:             R   0.50│
├─────────────────────────────┤
│ Thank you for shopping!     │
│ Visit us again soon!        │
└─────────────────────────────┘
```

---

## 7. MULTI-BRANCH INTEGRATION

### **Branch-Specific Operations:**
```vb
' Current branch from user session
Dim currentBranchID As Integer = AppSession.CurrentBranchID

' All queries filter by branch
SELECT * FROM Retail_Stock WHERE BranchID = currentBranchID

' Sales recorded per branch
INSERT INTO Sales (BranchID, ...) VALUES (currentBranchID, ...)

' Reports per branch
SELECT SUM(TotalAmount) FROM Sales 
WHERE BranchID = currentBranchID 
  AND SaleDate = TODAY
```

### **Inter-Branch Stock Transfers:**
```vb
' If product out of stock at current branch
If Retail_Stock.QtyOnHand = 0 Then
    ' Check other branches
    SELECT BranchName, QtyOnHand 
    FROM Retail_Stock rs
    INNER JOIN Branches b ON b.BranchID = rs.BranchID
    WHERE VariantID = @ProductID
      AND QtyOnHand > 0
    
    ' Suggest transfer or order
    ShowMessage("Available at Branch X. Transfer?")
End If
```

---

## 8. DEBTORS & CREDITORS INTEGRATION

### **Customer Account Sales (Debtors):**
```sql
-- Create debtor transaction
INSERT INTO Debtors (
    CustomerID, BranchID, TransactionDate,
    TransactionType, Amount, Reference
) VALUES (
    @CustomerID, @BranchID, GETDATE(),
    'Sale', @TotalAmount, @SaleNumber
);

-- Ledger entry
DR Accounts Receivable (Debtors)  R 149.50
CR Sales Revenue                  R 130.00
CR VAT Output                     R  19.50
```

### **Supplier Purchases (Creditors):**
```sql
-- When invoice captured for External Products
INSERT INTO Creditors (
    SupplierID, BranchID, TransactionDate,
    TransactionType, Amount, Reference
) VALUES (
    @SupplierID, @BranchID, GETDATE(),
    'Purchase', @TotalAmount, @InvoiceNumber
);

-- Ledger entry
DR Inventory                      R 130.00
DR VAT Input                      R  19.50
CR Accounts Payable (Creditors)   R 149.50
```

### **Inter-Branch Transfers:**
```sql
-- Sender Branch
DR Inter-Branch Debtors           R 100.00
CR Inventory                      R 100.00

-- Receiver Branch
DR Inventory                      R 100.00
CR Inter-Branch Creditors         R 100.00
```

---

## 9. ADVANCED POS FEATURES

### **A. Customer Management:**
- Quick customer lookup (F3)
- Customer history
- Loyalty points
- Account balance
- Purchase history

### **B. Promotions & Discounts:**
- Automatic promotions (Buy 2 Get 1)
- Happy hour pricing
- Loyalty discounts
- Coupon codes
- Manager overrides

### **C. Returns & Refunds (Shift+F4):**
```vb
Process:
1. Scan/Select original receipt
2. Select items to return
3. Verify condition
4. Process refund:
   - Increase Retail_Stock.QtyOnHand
   - Create credit note
   - Refund payment
   - Update ledgers
```

### **D. Layby/Layaway (Shift+F7):**
```vb
Process:
1. Create layby transaction
2. Take deposit
3. Reserve stock
4. Schedule payments
5. Release when paid in full
```

### **E. Gift Cards (Shift+F6):**
```vb
Operations:
- Activate new gift card
- Check balance
- Redeem gift card
- Reload gift card
```

### **F. Reports (Shift+F9):**
```vb
Quick Reports:
- Sales Summary (Today/Week/Month)
- Top Selling Products
- Cashier Performance
- Stock Levels
- Payment Methods
- Hourly Sales
```

### **G. End of Day (Shift+F10):**
```vb
Cash Up Process:
1. Count cash drawer
2. Reconcile card payments
3. Generate Z-Report
4. Close shift
5. Print summary
6. Lock terminal
```

---

## 10. PRODUCT IMAGE MANAGEMENT

### **Image Storage:**
```sql
-- Products table already has ProductImage VARBINARY(MAX)
UPDATE Products
SET ProductImage = @ImageBytes
WHERE ProductID = @ProductID;
```

### **Image Display in POS:**
```vb
' Load product image from database
Dim imageBytes() As Byte = GetProductImage(productID)
If imageBytes IsNot Nothing Then
    Using ms As New MemoryStream(imageBytes)
        pictureBox.Image = Image.FromStream(ms)
    End Using
Else
    ' Show placeholder image
    pictureBox.Image = My.Resources.NoImagePlaceholder
End If
```

### **Image Guidelines:**
- **Format**: JPEG/PNG
- **Size**: 300x300 pixels (square)
- **File Size**: < 100KB (compressed)
- **Background**: White or transparent
- **Quality**: High resolution for touchscreens

---

## 11. TOUCHSCREEN OPTIMIZATION

### **Touch Gestures:**
- **Tap**: Select item
- **Double Tap**: Quick add to cart
- **Swipe Left**: Previous category
- **Swipe Right**: Next category
- **Swipe Up**: Scroll products
- **Pinch**: Zoom product image
- **Long Press**: Show product details

### **Button Sizing:**
- **Minimum**: 60x60 pixels
- **Recommended**: 80x80 pixels
- **Spacing**: 10px between buttons
- **Touch Target**: 44x44 pixels minimum

### **Visual Feedback:**
- **Hover**: Highlight on touch
- **Press**: Scale down 95%
- **Success**: Green flash
- **Error**: Red shake animation
- **Loading**: Spinner overlay

---

## 12. PERFORMANCE REQUIREMENTS

### **Speed Targets:**
- **Product Search**: < 200ms
- **Add to Cart**: < 100ms
- **Complete Sale**: < 2 seconds
- **Print Receipt**: < 3 seconds
- **Screen Transitions**: < 300ms

### **Optimization:**
- Cache product images
- Preload categories
- Lazy load products
- Async database queries
- Connection pooling

---

## 13. SECURITY & PERMISSIONS

### **User Roles:**
| Role | Permissions |
|------|-------------|
| **Cashier** | Basic sales, returns (with limits) |
| **Supervisor** | Price overrides, voids, discounts |
| **Manager** | All operations, reports, settings |
| **Admin** | System configuration, user management |

### **Security Features:**
- Login required (PIN or card)
- Auto-logout after inactivity
- Manager approval for sensitive operations
- Audit trail (all actions logged)
- Encrypted payment data

---

## 14. IMPLEMENTATION CHECKLIST

### **Phase 1: Core POS**
- [ ] Main POS screen layout
- [ ] Category/Product navigation
- [ ] Shopping cart functionality
- [ ] Barcode scanning
- [ ] Basic payment processing
- [ ] Receipt printing
- [ ] Stock integration (Retail_Stock)

### **Phase 2: Advanced Features**
- [ ] Customer management
- [ ] Discounts & promotions
- [ ] Returns & refunds
- [ ] Multiple payment methods
- [ ] Hold/Recall transactions
- [ ] Product images display

### **Phase 3: Integration**
- [ ] Debtors/Creditors ledgers
- [ ] Inter-branch transfers
- [ ] Inventory synchronization
- [ ] Accounting integration
- [ ] Multi-branch support

### **Phase 4: Polish**
- [ ] Futuristic UI design
- [ ] Touchscreen optimization
- [ ] Keyboard shortcuts (F-keys)
- [ ] Performance optimization
- [ ] User training materials

---

## 15. TECHNICAL STACK

### **Frontend:**
- **Framework**: WinForms (VB.NET) with custom controls
- **UI Library**: Modern flat design components
- **Graphics**: GDI+ for custom rendering
- **Touch**: Windows Touch API

### **Backend:**
- **Database**: SQL Server
- **ORM**: ADO.NET (direct SQL)
- **Services**: StockroomService, SalesService
- **Caching**: In-memory cache for products

### **Hardware:**
- **Touchscreen**: 15-17" capacitive
- **Barcode Scanner**: USB/Serial
- **Receipt Printer**: Thermal 80mm
- **Cash Drawer**: RJ11 connected to printer
- **Card Reader**: EMV chip & contactless

---

## 16. SAGE POS FEATURE PARITY

### **Core Features (Implemented):**
✅ Product catalog with categories
✅ Barcode scanning
✅ Multiple payment methods
✅ Receipt printing
✅ Stock management
✅ Customer accounts
✅ Returns & refunds
✅ Discounts & promotions
✅ Hold/Recall transactions
✅ End of day reports
✅ Multi-branch support
✅ Keyboard shortcuts (F-keys)

### **Advanced Features (Planned):**
- [ ] Loyalty program
- [ ] Gift cards
- [ ] Layby/Layaway
- [ ] Price checker
- [ ] Kitchen display system
- [ ] Table management (restaurant)
- [ ] Online order integration
- [ ] Mobile POS (tablet)

---

**Document Version:** 1.0  
**Last Updated:** 2025-09-30 20:33  
**Status:** ACTIVE SPECIFICATION  
**Ready for Implementation:** YES

---

**NEXT STEPS:**
1. Run database scripts (Manufacturing_Inventory, InterBranchTransfers, Update_Products)
2. Test Purchase Order and Inter-Branch Transfer
3. Design POS UI mockups
4. Implement POS core functionality
5. Integrate with existing inventory system
6. User acceptance testing
7. Deploy to production
