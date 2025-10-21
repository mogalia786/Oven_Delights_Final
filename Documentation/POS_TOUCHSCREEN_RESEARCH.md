# Touch Screen POS System - Comprehensive Research & Specification
**Project:** Oven Delights ERP - Point of Sale Module  
**Date:** October 8, 2025  
**Purpose:** Research and document touch-friendly POS interface options

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Research Findings](#research-findings)
3. [UI/UX Design Options](#uiux-design-options)
4. [Technical Architecture](#technical-architecture)
5. [Payment Integration](#payment-integration)
6. [Custom Orders System](#custom-orders-system)
7. [Recommended Solution](#recommended-solution)
8. [Implementation Plan](#implementation-plan)

---

## Executive Summary

### Project Requirements

**Core Functionality:**
- Touch-optimized interface for bakery/retail operations
- Category → Subcategory → Product navigation
- Visual product display with images
- Real-time cart/line feed
- Multiple payment methods (Card, Cash, EFT, Split)
- FNB PayPoint integration
- Custom order management (deposits, pickup)
- SAGE POS-compatible F-key shortcuts
- Pole display integration
- Receipt printing

**Target Users:**
- Cashiers/Tellers (primary)
- Branch managers (supervision)
- Customers (visual feedback via pole display)

**Deployment:**
- Standalone Windows application
- Connects to existing SQL database
- Runs on touch-enabled devices (tablets, touch monitors)
- Offline capability for network failures

---

## Research Findings

### Industry Best Practices

#### 1. **Touch Screen Design Principles**

**Button Sizing:**
- Minimum touch target: 44×44 pixels (Apple HIG)
- Recommended: 48×48 pixels (Material Design)
- Optimal for bakery POS: 60×60 pixels minimum
- Spacing between buttons: 8-12 pixels

**Color Psychology for Bakery:**
- **Primary:** Warm browns (#8B4513, #D2691E) - bread/baked goods
- **Secondary:** Cream/beige (#F5DEB3, #FFE4C4) - flour/dough
- **Accent:** Golden yellow (#FFD700) - freshness
- **Action:** Green (#4CAF50) - confirm/accept
- **Cancel:** Red (#F44336) - cancel/void
- **Info:** Blue (#2196F3) - information

**Typography:**
- Font size: 16px minimum for body text
- 20-24px for buttons
- 32px+ for totals and important numbers
- Font family: Segoe UI, Roboto, or Open Sans (clear, readable)

#### 2. **POS Layout Standards**

**Screen Zones (1920×1080 landscape):**
```
┌─────────────────────────────────────────────────────────────┐
│ Header: Branch | Cashier | Date/Time | Transaction #       │ 80px
├──────────────────────┬──────────────────────────────────────┤
│                      │                                      │
│  Left Panel          │  Center Panel                        │
│  (Categories)        │  (Products/Subcategories)            │
│  300px               │  960px                               │
│                      │                                      │
│                      │                                      │
├──────────────────────┴──────────────────────────────────────┤
│ Footer: F-Key Shortcuts (F1-F12)                           │ 60px
└─────────────────────────────────────────────────────────────┘
```

**Alternative Layout (with cart):**
```
┌─────────────────────────────────────────────────────────────┐
│ Header: Branch | Cashier | Date/Time | Transaction #       │
├──────────────┬─────────────────────────┬────────────────────┤
│              │                         │                    │
│ Categories   │  Products Grid          │  Cart/Line Feed   │
│ (Left)       │  (Center)               │  (Right)          │
│ 250px        │  1000px                 │  670px            │
│              │                         │                    │
│              │                         ├────────────────────┤
│              │                         │  Tender Panel     │
│              │                         │  (Payment)        │
├──────────────┴─────────────────────────┴────────────────────┤
│ F-Key Shortcuts                                             │
└─────────────────────────────────────────────────────────────┘
```

#### 3. **Competitive Analysis**

**Researched Systems:**

**A. Square POS**
- **Strengths:** Clean UI, intuitive navigation, excellent mobile support
- **Layout:** Grid-based product display, right-side cart
- **Payment:** Integrated card reader, tap-to-pay
- **Customization:** Limited but elegant

**B. Lightspeed Retail**
- **Strengths:** Robust inventory, detailed reporting
- **Layout:** Category tabs at top, product grid center, cart right
- **Payment:** Multiple payment types, split payments
- **Customization:** Highly customizable

**C. Vend POS**
- **Strengths:** Beautiful UI, easy to learn
- **Layout:** Left sidebar categories, center products, right cart
- **Payment:** Comprehensive payment options
- **Customization:** Good balance

**D. SAGE POS (South African Standard)**
- **Strengths:** F-key shortcuts, local compliance, robust
- **Layout:** Traditional but functional
- **Payment:** All SA payment methods
- **Customization:** Extensive

**E. TouchBistro (Restaurant/Bakery focused)**
- **Strengths:** Visual menu, modifiers, kitchen integration
- **Layout:** Category buttons, item grid, order summary
- **Payment:** Table management, split bills
- **Customization:** Menu-focused

---

## UI/UX Design Options

### Option 1: Modern Grid Layout (Recommended)

**Description:** Clean, modern interface with visual product cards

**Layout:**
```
┌─────────────────────────────────────────────────────────────────────┐
│ 🏪 Oven Delights - Branch: JHB Main    👤 Cashier: John    🕐 14:30 │
│ Transaction #: POS-2025-001234                                      │
│ 🔍 Scan/Search: [________________________] 🔄 SKU/Code Toggle      │
├──────────────┬─────────────────────────────────────┬────────────────┤
│              │                                     │                │
│ 🍞 Breads    │  ┌─────┐  ┌─────┐  ┌─────┐        │ CART           │
│ 🎂 Cakes     │  │ 🥖  │  │ 🥐  │  │ 🍞  │        │ ────────────── │
│ 🥐 Pastries  │  │White│  │Crois│  │Brown│        │ 1× White Bread │
│ 🍪 Cookies   │  │Bread│  │sant │  │Bread│        │    R 25.00     │
│ 🥤 Beverages │  │R25  │  │R15  │  │R28  │        │ 2× Croissant   │
│ 🎁 Specials  │  └─────┘  └─────┘  └─────┘        │    R 30.00     │
│              │                                     │                │
│ 📦 Custom    │  ┌─────┐  ┌─────┐  ┌─────┐        │ ────────────── │
│    Orders    │  │ 🥖  │  │ 🥐  │  │ 🍞  │        │ Subtotal:      │
│              │  │Rye  │  │Danish│  │Seed │        │   R 55.00      │
│              │  │Bread│  │     │  │Bread│        │ VAT (15%):     │
│              │  │R30  │  │R18  │  │R32  │        │   R 8.25       │
│              │  └─────┘  └─────┘  └─────┘        │ ────────────── │
│              │                                     │ TOTAL:         │
│              │                                     │ R 63.25        │
│              │                                     │                │
│              │                                     │ [💳 TENDER]    │
├──────────────┴─────────────────────────────────────┴────────────────┤
│ F1:Help F2:Search F3:Hold F4:Recall F5:Void F6:Discount F7:Returns │
│ F8:Reports F9:CashUp F10:Manager F11:Settings F12:Logout           │
└─────────────────────────────────────────────────────────────────────┘
```

**Features:**
- ✅ **Barcode scan field with auto-focus** (always ready for scanning)
- ✅ SKU/Code toggle for flexible product lookup
- ✅ Large, visual product cards with images
- ✅ Clear category sidebar
- ✅ Prominent cart display
- ✅ Large tender button
- ✅ F-key shortcuts always visible
- ✅ Clean, modern aesthetic

**Pros:**
- Intuitive for new users
- Visual product identification
- Fast navigation
- Professional appearance

**Cons:**
- Requires good product images
- More screen space needed

---

### Option 2: Compact Professional Layout

**Description:** Maximizes products on screen, SAGE-inspired

**Layout:**
```
┌─────────────────────────────────────────────────────────────────────┐
│ Branch: JHB │ Cashier: John │ 14:30 │ Trans: POS-001234            │
├──────┬──────────────────────────────────────────────┬───────────────┤
│Bread │ White Bread  Croissant  Brown Bread  Rye    │ 1× White R25  │
│Cakes │ [  R25.00  ] [ R15.00 ] [ R28.00  ] [R30]   │ 2× Crois R30  │
│Pastr │                                              │               │
│Cook  │ Seed Bread   Danish     Baguette    Roll    │ Sub:   R55.00 │
│Bever │ [  R32.00  ] [ R18.00 ] [ R22.00  ] [R8]    │ VAT:   R 8.25 │
│      │                                              │ ───────────── │
│Order │ Muffin      Scone       Donut      Tart     │ TOT:  R63.25  │
│      │ [ R12.00  ] [ R10.00 ] [ R15.00  ] [R20]    │               │
│      │                                              │ [   TENDER  ] │
├──────┴──────────────────────────────────────────────┴───────────────┤
│ F1:Help F2:Srch F3:Hold F4:Recall F5:Void F6:Disc F7:Ret F8:Rpt   │
└─────────────────────────────────────────────────────────────────────┘
```

**Features:**
- ✅ More products visible at once
- ✅ Compact but readable
- ✅ Fast for experienced users
- ✅ Less scrolling needed

**Pros:**
- Efficient use of space
- Faster for high-volume
- Less training needed for SAGE users

**Cons:**
- Less visual appeal
- Smaller touch targets
- No product images

---

### Option 3: Tablet-Optimized Layout

**Description:** Designed for iPad/Android tablets (landscape)

**Layout:**
```
┌─────────────────────────────────────────────────────────┐
│ 🏪 Oven Delights        👤 John        🕐 14:30         │
├──────────────────────────────────────┬──────────────────┤
│                                      │                  │
│  ┌──────┐  ┌──────┐  ┌──────┐      │ CART             │
│  │ 🍞   │  │ 🎂   │  │ 🥐   │      │ ──────────────── │
│  │Breads│  │Cakes │  │Pastr │      │ 1× White Bread   │
│  └──────┘  └──────┘  └──────┘      │    R 25.00       │
│                                      │                  │
│  ┌──────┐  ┌──────┐  ┌──────┐      │ 2× Croissant     │
│  │ 🍪   │  │ 🥤   │  │ 🎁   │      │    R 30.00       │
│  │Cookie│  │Bever │  │Spec  │      │                  │
│  └──────┘  └──────┘  └──────┘      │ ──────────────── │
│                                      │ TOTAL: R 63.25   │
│  [Tap category to view products]    │                  │
│                                      │ [💳 PAY]         │
├──────────────────────────────────────┴──────────────────┤
│ [Help] [Search] [Hold] [Void] [Manager] [Logout]       │
└─────────────────────────────────────────────────────────┘
```

**Features:**
- ✅ Touch-optimized for tablets
- ✅ Large, finger-friendly buttons
- ✅ Simplified navigation
- ✅ Mobile-first design

**Pros:**
- Perfect for tablets
- Very easy to use
- Portable
- Lower hardware cost

**Cons:**
- Smaller screen real estate
- Fewer shortcuts visible
- May need multiple taps

---

### Option 4: Hybrid Multi-Mode Layout

**Description:** Adaptive layout that switches based on context

**Modes:**

**Browse Mode (Category Selection):**
```
┌─────────────────────────────────────────────────────────┐
│ SELECT CATEGORY                                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐            │
│  │   🍞     │  │   🎂     │  │   🥐     │            │
│  │          │  │          │  │          │            │
│  │ BREADS   │  │  CAKES   │  │ PASTRIES │            │
│  │          │  │          │  │          │            │
│  └──────────┘  └──────────┘  └──────────┘            │
│                                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐            │
│  │   🍪     │  │   🥤     │  │   📦     │            │
│  │          │  │          │  │          │            │
│  │ COOKIES  │  │BEVERAGES │  │  CUSTOM  │            │
│  │          │  │          │  │  ORDERS  │            │
│  └──────────┘  └──────────┘  └──────────┘            │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Product Selection Mode:**
```
┌─────────────────────────────────────────────────────────┐
│ ← BREADS                                    [CART: 2]   │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐         │
│  │ 🥖  │  │ 🥐  │  │ 🍞  │  │ 🥖  │  │ 🍞  │         │
│  │White│  │Crois│  │Brown│  │ Rye │  │Seed │         │
│  │R25  │  │R15  │  │R28  │  │R30  │  │R32  │         │
│  └─────┘  └─────┘  └─────┘  └─────┘  └─────┘         │
│                                                         │
│  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐         │
│  │ 🥖  │  │ 🥐  │  │ 🍞  │  │ 🥖  │  │ 🍞  │         │
│  │Bagel│  │Danish│  │Roll │  │Bun  │  │Loaf │         │
│  │R18  │  │R20  │  │R8   │  │R10  │  │R35  │         │
│  └─────┘  └─────┘  └─────┘  └─────┘  └─────┘         │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Checkout Mode:**
```
┌─────────────────────────────────────────────────────────┐
│ CHECKOUT                                                │
├─────────────────────────────────────────────────────────┤
│ 1× White Bread                              R 25.00     │
│ 2× Croissant                                R 30.00     │
│ ─────────────────────────────────────────────────────── │
│ Subtotal:                                   R 55.00     │
│ VAT (15%):                                  R  8.25     │
│ ═════════════════════════════════════════════════════── │
│ TOTAL:                                      R 63.25     │
│                                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐            │
│  │   💳     │  │   💵     │  │   🏦     │            │
│  │  CARD    │  │  CASH    │  │   EFT    │            │
│  └──────────┘  └──────────┘  └──────────┘            │
│                                                         │
│  ┌──────────────────────────────────────┐             │
│  │         💰 SPLIT PAYMENT              │             │
│  └──────────────────────────────────────┘             │
└─────────────────────────────────────────────────────────┘
```

**Features:**
- ✅ Context-aware interface
- ✅ Full-screen modes for focus
- ✅ Simplified navigation
- ✅ Reduces clutter

**Pros:**
- Clean, focused experience
- Easier for beginners
- Modern UX pattern
- Flexible

**Cons:**
- More screen transitions
- May feel slower for experts
- Requires more development

---

## Barcode Scanning System

### Critical Requirement: Auto-Focus

**The barcode scan field MUST always have focus for seamless scanning operation.**

### Scan Field Specifications

**Location:** Top of screen, below header, always visible

**Layout:**
```
┌─────────────────────────────────────────────────────────────┐
│ 🔍 Scan/Search: [________________________] 🔄 SKU/Code     │
│                  ↑ ALWAYS FOCUSED                           │
└─────────────────────────────────────────────────────────────┘
```

**Field Properties:**
- **Width:** Full width minus margins (800-1000px)
- **Height:** 40px minimum
- **Font Size:** 18px
- **Background:** White with blue border when focused
- **Placeholder:** "Scan barcode or enter SKU/Code..."
- **Auto-Focus:** YES - Always returns focus after any action

### SKU/Code Toggle

**Purpose:** Switch between barcode lookup and product code lookup

**Toggle Button:**
- **Label:** "🔄 SKU/Code"
- **States:** 
  - "Barcode Mode" (default)
  - "Product Code Mode"
- **Visual Indicator:** Icon changes color/style

**Behavior:**
- **Barcode Mode:** Searches `Products.Barcode` field
- **Product Code Mode:** Searches `Products.ProductCode` or `Products.SKU` field
- **Toggle Shortcut:** F2 key

### Auto-Focus Behavior

**When Focus Should Return to Scan Field:**

1. ✅ **After adding product to cart**
   - Product scanned → Added to cart → Focus returns immediately
   
2. ✅ **After clicking any product button**
   - Touch product card → Added to cart → Focus returns
   
3. ✅ **After quantity adjustment**
   - Quantity changed → Focus returns
   
4. ✅ **After discount applied**
   - Discount entered → Focus returns
   
5. ✅ **After voiding item**
   - Item voided → Focus returns
   
6. ✅ **After dialog closes**
   - Any popup closed → Focus returns
   
7. ✅ **After payment cancelled**
   - Payment cancelled → Focus returns
   
8. ✅ **After transaction completed**
   - Receipt printed → New transaction → Focus returns

**When Focus Should NOT Return:**
- ❌ During payment processing
- ❌ When numpad is open
- ❌ When manager override dialog is open
- ❌ When custom order form is open

### Implementation Code

**WPF Implementation:**
```vb.net
Public Class POSForm
    Private Sub POSForm_Loaded(sender As Object, e As RoutedEventArgs)
        ' Set initial focus
        txtBarcodeScan.Focus()
    End Sub
    
    Private Sub ReturnFocusToScan()
        ' Always return focus to scan field
        txtBarcodeScan.Focus()
        txtBarcodeScan.SelectAll()
    End Sub
    
    Private Sub txtBarcodeScan_KeyDown(sender As Object, e As KeyEventArgs)
        If e.Key = Key.Enter Then
            ' Process barcode/code
            ProcessScan(txtBarcodeScan.Text)
            txtBarcodeScan.Clear()
            e.Handled = True
        End If
    End Sub
    
    Private Sub ProcessScan(scanValue As String)
        Try
            Dim product As Product = Nothing
            
            If isBarcodeMode Then
                ' Search by barcode
                product = ProductService.GetByBarcode(scanValue)
            Else
                ' Search by product code/SKU
                product = ProductService.GetByCode(scanValue)
            End If
            
            If product IsNot Nothing Then
                AddToCart(product)
                PlayBeep() ' Success sound
            Else
                ShowError("Product not found")
                PlayErrorBeep()
            End If
            
        Finally
            ' Always return focus
            ReturnFocusToScan()
        End Try
    End Sub
    
    Private Sub AddToCart(product As Product)
        ' Add product to cart
        cartItems.Add(New CartItem With {
            .ProductID = product.ProductID,
            .ProductName = product.ProductName,
            .Quantity = 1,
            .UnitPrice = product.SellingPrice
        })
        
        UpdateCartDisplay()
        ReturnFocusToScan()
    End Sub
    
    Private Sub btnProduct_Click(sender As Object, e As RoutedEventArgs)
        ' Product button clicked
        Dim product = CType(CType(sender, Button).Tag, Product)
        AddToCart(product)
        ' Focus returns automatically via AddToCart
    End Sub
    
    Private Sub btnTender_Click(sender As Object, e As RoutedEventArgs)
        ' Open payment dialog
        txtBarcodeScan.IsEnabled = False ' Disable during payment
        
        Dim paymentDialog As New PaymentDialog()
        If paymentDialog.ShowDialog() = True Then
            CompleteTransaction()
        Else
            ' Payment cancelled
            txtBarcodeScan.IsEnabled = True
            ReturnFocusToScan()
        End If
    End Sub
    
    Private Sub CompleteTransaction()
        ' Print receipt, clear cart, etc.
        ClearCart()
        txtBarcodeScan.IsEnabled = True
        ReturnFocusToScan()
    End Sub
    
    ' Ensure focus returns when form is activated
    Private Sub POSForm_Activated(sender As Object, e As EventArgs)
        If txtBarcodeScan.IsEnabled Then
            ReturnFocusToScan()
        End If
    End Sub
    
    ' Prevent focus loss
    Private Sub POSForm_PreviewMouseDown(sender As Object, e As MouseButtonEventArgs)
        ' If clicking on non-input control, return focus after click
        Dim element = TryCast(e.OriginalSource, FrameworkElement)
        If element IsNot Nothing AndAlso 
           Not TypeOf element Is TextBox AndAlso 
           Not TypeOf element Is ComboBox Then
            ' Schedule focus return after click is processed
            Dispatcher.BeginInvoke(Sub() ReturnFocusToScan(), DispatcherPriority.Input)
        End If
    End Sub
End Class
```

**WinForms Implementation:**
```vb.net
Public Class POSForm
    Private Sub POSForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        ' Set initial focus
        txtBarcodeScan.Focus()
    End Sub
    
    Private Sub ReturnFocusToScan()
        txtBarcodeScan.Focus()
        txtBarcodeScan.SelectAll()
    End Sub
    
    Private Sub txtBarcodeScan_KeyPress(sender As Object, e As KeyPressEventArgs) Handles txtBarcodeScan.KeyPress
        If e.KeyChar = ChrW(Keys.Enter) Then
            ProcessScan(txtBarcodeScan.Text)
            txtBarcodeScan.Clear()
            e.Handled = True
        End If
    End Sub
    
    ' Override ProcessDialogKey to prevent Tab from leaving scan field
    Protected Overrides Function ProcessDialogKey(keyData As Keys) As Boolean
        If keyData = Keys.Tab AndAlso ActiveControl Is txtBarcodeScan Then
            Return True ' Prevent tab from moving focus
        End If
        Return MyBase.ProcessDialogKey(keyData)
    End Function
    
    ' Ensure focus returns after any button click
    Private Sub AllButtons_Click(sender As Object, e As EventArgs) Handles _
        btnProduct1.Click, btnProduct2.Click, btnTender.Click ' etc.
        
        ' Process button action
        ' ...
        
        ' Return focus
        ReturnFocusToScan()
    End Sub
    
    ' Timer to enforce focus (backup mechanism)
    Private WithEvents tmrFocusEnforcer As New Timer With {.Interval = 500}
    
    Private Sub tmrFocusEnforcer_Tick(sender As Object, e As EventArgs) Handles tmrFocusEnforcer.Tick
        ' If no dialog is open and scan field doesn't have focus, return it
        If txtBarcodeScan.Enabled AndAlso Not txtBarcodeScan.Focused Then
            If Not IsDialogOpen() Then
                ReturnFocusToScan()
            End If
        End If
    End Sub
    
    Private Function IsDialogOpen() As Boolean
        ' Check if any modal dialog is open
        Return Me.OwnedForms.Length > 0
    End Function
End Class
```

### Barcode Scanner Hardware

**Recommended Scanners:**
- **Symbol LS2208** - Reliable, affordable, USB
- **Honeywell Voyager 1200g** - Fast, accurate
- **Zebra DS2208** - 2D barcode support
- **Datalogic QuickScan QD2430** - Omnidirectional

**Connection:**
- USB (HID mode - acts as keyboard)
- Configured to send Enter after scan
- No special drivers needed

**Configuration:**
- **Suffix:** Carriage Return (Enter key)
- **Prefix:** None (or custom if needed)
- **Beep:** Enabled on successful scan
- **LED:** Visual feedback

### Search Functionality

**Manual Search (F2):**
- Opens search dialog
- Type product name or partial code
- Shows matching products
- Select and add to cart
- Focus returns to scan field

**Quick Search:**
- Type in scan field without scanning
- Shows autocomplete dropdown
- Select product from list
- Press Enter to add

### Best Practices

**DO:**
- ✅ Always return focus to scan field
- ✅ Clear scan field after processing
- ✅ Provide audio feedback (beep)
- ✅ Show visual confirmation (flash/highlight)
- ✅ Handle scan errors gracefully
- ✅ Support both barcode and manual entry

**DON'T:**
- ❌ Allow focus to stay on other controls
- ❌ Require clicking in scan field
- ❌ Disable scan field unnecessarily
- ❌ Forget to re-enable after dialogs
- ❌ Allow Tab key to move focus away

### Testing Checklist

- [ ] Scan field has focus on form load
- [ ] Focus returns after adding product
- [ ] Focus returns after clicking product button
- [ ] Focus returns after payment cancelled
- [ ] Focus returns after transaction complete
- [ ] SKU/Code toggle works correctly
- [ ] Barcode scanner adds products correctly
- [ ] Manual entry works
- [ ] F2 search works
- [ ] Audio feedback works
- [ ] Error handling works
- [ ] Focus doesn't leave during payment
- [ ] Tab key doesn't move focus
- [ ] Focus returns after any dialog closes

---

## Technical Architecture

### Technology Stack Options

#### Option A: WPF (Windows Presentation Foundation)

**Pros:**
- ✅ Native Windows performance
- ✅ Excellent touch support
- ✅ Rich UI capabilities (animations, effects)
- ✅ XAML for UI design
- ✅ Strong data binding
- ✅ Mature ecosystem

**Cons:**
- ❌ Windows-only
- ❌ Steeper learning curve
- ❌ Larger application size

**Best For:** Desktop POS terminals, Windows tablets

#### Option B: WinForms with Modern UI Library

**Pros:**
- ✅ Familiar technology (current ERP uses it)
- ✅ Fast development
- ✅ Easy database integration
- ✅ Libraries like MetroFramework, Bunifu

**Cons:**
- ❌ Less modern look
- ❌ Limited touch optimization
- ❌ Older technology

**Best For:** Quick implementation, existing WinForms expertise

#### Option C: Electron + React/Vue

**Pros:**
- ✅ Cross-platform (Windows, Linux, macOS)
- ✅ Modern web technologies
- ✅ Rich UI libraries
- ✅ Easy updates
- ✅ Web-based deployment option

**Cons:**
- ❌ Larger memory footprint
- ❌ Slower startup
- ❌ Requires web development skills

**Best For:** Cross-platform deployment, web-based POS

#### Option D: .NET MAUI (Multi-platform App UI)

**Pros:**
- ✅ Cross-platform (Windows, Android, iOS, macOS)
- ✅ Native performance
- ✅ Single codebase
- ✅ Modern .NET
- ✅ Touch-optimized

**Cons:**
- ❌ Newer technology (less mature)
- ❌ Learning curve
- ❌ Some platform-specific code needed

**Best For:** Future-proof, mobile + desktop deployment

---

### Database Integration

**Connection Architecture:**
```
┌─────────────────────┐
│   POS Application   │
│   (Standalone)      │
└──────────┬──────────┘
           │
           │ SQL Connection
           │ (Direct or API)
           │
┌──────────▼──────────┐
│  SQL Server         │
│  (Azure/On-Premise) │
│                     │
│  - Products         │
│  - Retail_Stock     │
│  - Transactions     │
│  - Orders           │
│  - Payments         │
└─────────────────────┘
```

**Key Tables:**

**Products & Inventory:**
- `Products` - Product master
- `Categories` - Product categories
- `Subcategories` - Product subcategories
- `Retail_Stock` - Branch-specific stock levels
- `Retail_StockMovements` - Stock audit trail

**Transactions:**
- `POS_Transactions` - Sale headers
- `POS_TransactionLines` - Sale line items
- `POS_Payments` - Payment details
- `POS_HeldTransactions` - Parked sales

**Custom Orders:**
- `CustomOrders` - Order headers
- `CustomOrderLines` - Order items
- `OrderDeposits` - Deposit payments
- `OrderPickups` - Pickup tracking

**System:**
- `POS_Sessions` - Cashier sessions
- `POS_CashDrawer` - Cash drawer tracking
- `POS_AuditLog` - All POS actions

---

## Payment Integration

### FNB PayPoint Integration

**Integration Method:** ECR (Electronic Cash Register) Protocol

**Connection Types:**

#### Option 1: Serial/USB Connection (Recommended)
```
POS Terminal ←→ USB Cable ←→ FNB PayPoint Device
```

**Implementation:**
```vb.net
Public Class FNBPayPointService
    Private serialPort As SerialPort
    
    Public Sub New(portName As String)
        serialPort = New SerialPort(portName, 9600, Parity.None, 8, StopBits.One)
    End Sub
    
    Public Function ProcessCardPayment(amount As Decimal, receiptNumber As String) As PaymentResult
        Try
            serialPort.Open()
            
            ' ECR command format for FNB
            Dim command As String = $"SALE|{amount:F2}|{receiptNumber}|{DateTime.Now:yyyyMMddHHmmss}|"
            serialPort.WriteLine(command)
            
            ' Wait for response (timeout 60 seconds)
            Dim response As String = WaitForResponse(60000)
            serialPort.Close()
            
            ' Parse response
            Return ParsePaymentResponse(response)
        Catch ex As Exception
            Return New PaymentResult With {
                .Success = False,
                .ErrorMessage = ex.Message
            }
        End Try
    End Function
    
    Private Function WaitForResponse(timeoutMs As Integer) As String
        Dim startTime = DateTime.Now
        Dim response As String = ""
        
        While (DateTime.Now - startTime).TotalMilliseconds < timeoutMs
            If serialPort.BytesToRead > 0 Then
                response = serialPort.ReadLine()
                Exit While
            End If
            Threading.Thread.Sleep(100)
        End While
        
        Return response
    End Function
    
    Private Function ParsePaymentResponse(response As String) As PaymentResult
        ' Response format: STATUS|AMOUNT|AUTH_CODE|CARD_TYPE|MASKED_PAN|
        Dim parts = response.Split("|"c)
        
        Return New PaymentResult With {
            .Success = (parts(0) = "APPROVED"),
            .Amount = Decimal.Parse(parts(1)),
            .AuthCode = parts(2),
            .CardType = parts(3),
            .MaskedCardNumber = parts(4),
            .TransactionDate = DateTime.Now
        }
    End Function
End Class

Public Class PaymentResult
    Public Property Success As Boolean
    Public Property Amount As Decimal
    Public Property AuthCode As String
    Public Property CardType As String
    Public Property MaskedCardNumber As String
    Public Property TransactionDate As DateTime
    Public Property ErrorMessage As String
End Class
```

#### Option 2: IP/Network Connection
```
POS Terminal ←→ LAN/WiFi ←→ FNB PayPoint Device
```

**Implementation:**
```vb.net
Public Class FNBPayPointNetworkService
    Private ipAddress As String
    Private port As Integer = 8080
    
    Public Function ProcessCardPayment(amount As Decimal, receiptNumber As String) As PaymentResult
        Try
            Using client As New TcpClient(ipAddress, port)
                Using stream As NetworkStream = client.GetStream()
                    ' Send payment request
                    Dim request = CreatePaymentRequest(amount, receiptNumber)
                    Dim requestBytes = Encoding.UTF8.GetBytes(request)
                    stream.Write(requestBytes, 0, requestBytes.Length)
                    
                    ' Read response
                    Dim responseBytes(1024) As Byte
                    Dim bytesRead = stream.Read(responseBytes, 0, responseBytes.Length)
                    Dim response = Encoding.UTF8.GetString(responseBytes, 0, bytesRead)
                    
                    Return ParsePaymentResponse(response)
                End Using
            End Using
        Catch ex As Exception
            Return New PaymentResult With {.Success = False, .ErrorMessage = ex.Message}
        End Try
    End Function
End Class
```

**FNB PayPoint Requirements:**
1. ECR integration documentation from FNB
2. Device configuration (COM port or IP address)
3. Merchant ID and terminal ID
4. Test mode credentials
5. PCI DSS compliance (terminal handles card data)

**Payment Flow:**
```
1. Customer selects Card payment
2. POS displays "Processing..." and amount on pole display
3. POS sends amount to PayPoint device
4. PayPoint displays amount on its screen
5. Customer inserts/taps card
6. PayPoint processes with bank
7. PayPoint returns result (APPROVED/DECLINED)
8. POS updates transaction
9. POS prints receipt with card details (last 4 digits, auth code)
10. POS opens cash drawer (optional)
```

### Cash Payment with Numpad

**Numpad Design:**
```
┌─────────────────────────────┐
│  CASH PAYMENT               │
│  Amount Due: R 63.25        │
├─────────────────────────────┤
│  Tendered: [R 100.00]       │
│  Change:    R 36.75         │
├─────────────────────────────┤
│  ┌────┬────┬────┬────────┐ │
│  │ 7  │ 8  │ 9  │  ⌫     │ │
│  ├────┼────┼────┤  Back  │ │
│  │ 4  │ 5  │ 6  │  space │ │
│  ├────┼────┼────┼────────┤ │
│  │ 1  │ 2  │ 3  │        │ │
│  ├────┴────┼────┤  ENTER │ │
│  │    0    │ .  │        │ │
│  └─────────┴────┴────────┘ │
│                             │
│  Quick Amounts:             │
│  [R50] [R100] [R200] [R500]│
│                             │
│  [CANCEL]      [COMPLETE]  │
└─────────────────────────────┘
```

**Features:**
- ✅ Numeric input only (no alphabets)
- ✅ Large buttons (80×80 pixels)
- ✅ Auto-calculate change
- ✅ Quick amount buttons
- ✅ Clear visual feedback
- ✅ Backspace for corrections

**Implementation:**
```vb.net
Public Class CashPaymentDialog
    Private tenderedAmount As Decimal = 0
    Private amountDue As Decimal
    
    Private Sub NumpadButton_Click(sender As Object, e As EventArgs)
        Dim btn = CType(sender, Button)
        Dim digit = btn.Text
        
        ' Append digit to tendered amount
        txtTendered.Text &= digit
        tenderedAmount = Decimal.Parse(txtTendered.Text)
        
        ' Calculate change
        CalculateChange()
    End Sub
    
    Private Sub CalculateChange()
        Dim change = tenderedAmount - amountDue
        
        If change >= 0 Then
            lblChange.Text = $"R {change:F2}"
            lblChange.ForeColor = Color.Green
            btnComplete.Enabled = True
        Else
            lblChange.Text = $"R {Math.Abs(change):F2} SHORT"
            lblChange.ForeColor = Color.Red
            btnComplete.Enabled = False
        End If
    End Sub
    
    Private Sub QuickAmount_Click(sender As Object, e As EventArgs)
        Dim btn = CType(sender, Button)
        tenderedAmount = Decimal.Parse(btn.Tag.ToString())
        txtTendered.Text = tenderedAmount.ToString("F2")
        CalculateChange()
    End Sub
End Class
```

### Split Payment

**Split Payment Dialog:**
```
┌─────────────────────────────────────┐
│  SPLIT PAYMENT                      │
│  Total Amount: R 150.00             │
├─────────────────────────────────────┤
│  Payment 1: Card                    │
│  Amount: [R 100.00]                 │
│  [Process Card Payment]             │
│  Status: ✓ APPROVED                 │
├─────────────────────────────────────┤
│  Payment 2: Cash                    │
│  Amount: [R 50.00]                  │
│  [Process Cash Payment]             │
│  Status: ⏳ Pending                  │
├─────────────────────────────────────┤
│  Remaining: R 50.00                 │
│                                     │
│  [CANCEL]            [COMPLETE]     │
└─────────────────────────────────────┘
```

**Flow:**
1. User selects Split Payment
2. Enters first payment amount
3. Selects payment method (Card/Cash/EFT)
4. Processes first payment
5. System shows remaining balance
6. Repeats for second payment
7. Completes when total reached

---

## Custom Orders System

### Order Management Flow

**Order Creation:**
```
Customer requests custom cake
    ↓
Teller clicks "Custom Order" button
    ↓
Order form opens
    ↓
Enter customer details
    ↓
Select/describe product
    ↓
Enter specifications (size, flavor, design)
    ↓
Set pickup date/time
    ↓
Calculate total price
    ↓
Collect deposit
    ↓
Print order receipt
    ↓
Save to CustomOrders table
```

### Custom Order Form Design

```
┌─────────────────────────────────────────────────────────┐
│  CUSTOM ORDER                                           │
├─────────────────────────────────────────────────────────┤
│  Customer Information:                                  │
│  Name: [_____________________________]                  │
│  Phone: [_______________]                               │
│  Email: [_____________________________]                 │
├─────────────────────────────────────────────────────────┤
│  Order Details:                                         │
│  Product Type: [▼ Birthday Cake    ]                   │
│  Size: [▼ Large (12-15 people)     ]                   │
│  Flavor: [▼ Chocolate              ]                    │
│  Design/Message:                                        │
│  [_____________________________________________]        │
│  [_____________________________________________]        │
│                                                         │
│  Special Instructions:                                  │
│  [_____________________________________________]        │
│  [_____________________________________________]        │
├─────────────────────────────────────────────────────────┤
│  Pickup Information:                                    │
│  Pickup Date: [📅 15/10/2025]                          │
│  Pickup Time: [🕐 14:00]                               │
├─────────────────────────────────────────────────────────┤
│  Pricing:                                               │
│  Base Price:        R 450.00                            │
│  Customization:     R  50.00                            │
│  ─────────────────────────────                          │
│  Total:             R 500.00                            │
│                                                         │
│  Deposit Required:  R 250.00 (50%)                      │
│  Balance Due:       R 250.00                            │
├─────────────────────────────────────────────────────────┤
│  [CANCEL]    [SAVE DRAFT]    [COLLECT DEPOSIT]         │
└─────────────────────────────────────────────────────────┘
```

### Order Receipt

```
═══════════════════════════════════════
        OVEN DELIGHTS
        Custom Order Receipt
═══════════════════════════════════════
Order #: CO-2025-001234
Date: 08/10/2025 14:30

Customer: John Smith
Phone: 082 123 4567
Email: john@email.com

───────────────────────────────────────
ORDER DETAILS:
───────────────────────────────────────
Product: Birthday Cake
Size: Large (12-15 people)
Flavor: Chocolate
Design: "Happy Birthday Sarah"
        with pink roses

Special Instructions:
- No nuts (allergy)
- Extra chocolate frosting

───────────────────────────────────────
PICKUP INFORMATION:
───────────────────────────────────────
Date: 15/10/2025
Time: 14:00
Location: JHB Main Branch

───────────────────────────────────────
PRICING:
───────────────────────────────────────
Base Price:         R 450.00
Customization:      R  50.00
                    ─────────
Total:              R 500.00

Deposit Paid:       R 250.00
Balance Due:        R 250.00

Payment Method: Cash
Cashier: John Doe

═══════════════════════════════════════
IMPORTANT NOTES:
═══════════════════════════════════════
- Please bring this receipt when
  collecting your order
- Balance due on collection
- Orders not collected within 24 hours
  will be cancelled
- No refunds on custom orders

═══════════════════════════════════════
Thank you for your order!
www.ovendelights.co.za
011-XXX-XXXX
═══════════════════════════════════════
```

### Order Pickup Process

**Pickup Flow:**
```
Customer arrives for pickup
    ↓
Teller clicks "Order Pickup"
    ↓
Enter order number or search by phone
    ↓
Order details display
    ↓
Verify customer identity
    ↓
Show balance due
    ↓
Collect payment
    ↓
Mark order as completed
    ↓
Print final receipt
    ↓
Hand over product
```

**Pickup Screen:**
```
┌─────────────────────────────────────────────────────────┐
│  ORDER PICKUP                                           │
├─────────────────────────────────────────────────────────┤
│  Search Order:                                          │
│  Order Number: [CO-2025-______] [SEARCH]               │
│  OR                                                     │
│  Phone Number: [_______________] [SEARCH]               │
├─────────────────────────────────────────────────────────┤
│  Order Found:                                           │
│  Order #: CO-2025-001234                                │
│  Customer: John Smith (082 123 4567)                    │
│  Product: Birthday Cake - Chocolate Large               │
│  Pickup Date: 15/10/2025 14:00                          │
│  Status: ✓ Ready for Pickup                            │
├─────────────────────────────────────────────────────────┤
│  Payment Summary:                                       │
│  Total Amount:      R 500.00                            │
│  Deposit Paid:      R 250.00                            │
│  ─────────────────────────────                          │
│  Balance Due:       R 250.00                            │
├─────────────────────────────────────────────────────────┤
│  [VIEW DETAILS]  [COLLECT PAYMENT]  [CANCEL]           │
└─────────────────────────────────────────────────────────┘
```

### Database Schema for Custom Orders

```sql
-- Custom Orders Header
CREATE TABLE CustomOrders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    OrderNumber NVARCHAR(20) NOT NULL UNIQUE,
    OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
    BranchID INT NOT NULL,
    
    -- Customer Information
    CustomerName NVARCHAR(100) NOT NULL,
    CustomerPhone NVARCHAR(20) NOT NULL,
    CustomerEmail NVARCHAR(100),
    
    -- Order Details
    ProductType NVARCHAR(50) NOT NULL,
    ProductSize NVARCHAR(50),
    ProductFlavor NVARCHAR(50),
    DesignDescription NVARCHAR(500),
    SpecialInstructions NVARCHAR(500),
    
    -- Pickup Information
    PickupDate DATE NOT NULL,
    PickupTime TIME NOT NULL,
    
    -- Pricing
    BasePrice DECIMAL(18,2) NOT NULL,
    CustomizationCharge DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalAmount AS (BasePrice + CustomizationCharge) PERSISTED,
    DepositAmount DECIMAL(18,2) NOT NULL,
    BalanceDue AS (BasePrice + CustomizationCharge - DepositAmount) PERSISTED,
    
    -- Status
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    -- Pending, InProduction, Ready, Completed, Cancelled
    
    -- Audit
    CreatedBy INT NOT NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CompletedDate DATETIME NULL,
    CompletedBy INT NULL,
    
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- Order Deposits/Payments
CREATE TABLE OrderDeposits (
    DepositID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    PaymentDate DATETIME NOT NULL DEFAULT GETDATE(),
    Amount DECIMAL(18,2) NOT NULL,
    PaymentMethod NVARCHAR(20) NOT NULL,
    PaymentReference NVARCHAR(50),
    CashierID INT NOT NULL,
    
    FOREIGN KEY (OrderID) REFERENCES CustomOrders(OrderID),
    FOREIGN KEY (CashierID) REFERENCES Users(UserID)
);

-- Order Status History
CREATE TABLE OrderStatusHistory (
    HistoryID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    OldStatus NVARCHAR(20),
    NewStatus NVARCHAR(20) NOT NULL,
    StatusDate DATETIME NOT NULL DEFAULT GETDATE(),
    Notes NVARCHAR(500),
    ChangedBy INT NOT NULL,
    
    FOREIGN KEY (OrderID) REFERENCES CustomOrders(OrderID),
    FOREIGN KEY (ChangedBy) REFERENCES Users(UserID)
);
```

---

## Recommended Solution

### Primary Recommendation: **Option 1 - Modern Grid Layout with WPF**

**Why This Combination:**

1. **Modern Grid Layout** provides:
   - Visual product identification (crucial for bakery)
   - Intuitive navigation
   - Professional appearance
   - Easy training for new staff
   - Customer-facing appeal

2. **WPF Technology** offers:
   - Native Windows performance
   - Excellent touch support
   - Rich UI capabilities
   - Strong data binding
   - Future-proof

3. **Implementation Approach:**
   - Standalone WPF application
   - Direct SQL Server connection
   - FNB PayPoint serial integration
   - Pole display USB connection
   - Receipt printer integration

### Screen Specifications

**Primary POS Terminal:**
- **Display:** 21-24" touch screen monitor (1920×1080)
- **Orientation:** Landscape
- **Touch Technology:** Capacitive (10-point multi-touch)
- **Mounting:** Adjustable stand or wall-mount
- **Secondary Display:** Customer pole display (2×20 characters)

**Tablet Option (Mobile POS):**
- **Device:** Windows tablet (Surface Pro or similar)
- **Display:** 12-13" (1920×1280 or higher)
- **Touch:** Capacitive multi-touch
- **Connectivity:** WiFi + Bluetooth
- **Accessories:** Portable receipt printer, card reader

### Hardware Requirements

**POS Terminal Setup:**
```
┌─────────────────────┐
│  Touch Monitor      │
│  (21" 1920×1080)    │
└──────────┬──────────┘
           │
┌──────────▼──────────┐
│  PC/Mini PC         │
│  - i5/Ryzen 5       │
│  - 8GB RAM          │
│  - 256GB SSD        │
│  - Windows 10/11    │
└──────────┬──────────┘
           │
    ┌──────┴──────┬──────────┬──────────┬──────────┐
    │             │          │          │          │
┌───▼───┐   ┌────▼────┐ ┌──▼────┐ ┌───▼────┐ ┌──▼────┐
│Receipt│   │ FNB     │ │ Pole  │ │ Cash   │ │Barcode│
│Printer│   │PayPoint │ │Display│ │Drawer  │ │Scanner│
└───────┘   └─────────┘ └───────┘ └────────┘ └───────┘
```

**Peripherals:**
1. **Receipt Printer:** Epson TM-T20II or Star TSP143III
2. **Card Reader:** FNB PayPoint device
3. **Pole Display:** Logic Controls PD3000 or similar
4. **Cash Drawer:** APG Vasario or similar (RJ11 connection)
5. **Barcode Scanner:** Symbol LS2208 or Honeywell Voyager
6. **Backup UPS:** 650VA minimum

---

## Implementation Plan

### Phase 1: Design & Prototyping (2 weeks)

**Week 1:**
- Create detailed UI mockups in Figma/Adobe XD
- Design all screens (main POS, payment, orders)
- Create style guide (colors, fonts, spacing)
- User testing with mockups

**Week 2:**
- Build WPF prototype
- Implement navigation flow
- Test touch interactions
- Gather feedback

**Deliverables:**
- Complete UI mockups
- Interactive prototype
- Style guide document
- User feedback report

### Phase 2: Core Development (6 weeks)

**Week 1-2: Foundation**
- Set up WPF project structure
- Create database connection layer
- Implement authentication
- Build main window shell

**Week 3-4: Product Catalog**
- Category navigation
- Product grid display
- Image loading and caching
- Search functionality
- Cart management

**Week 5-6: Transaction Processing**
- Sale creation
- Line item management
- Tax calculation
- Hold/recall transactions
- Void/refund functionality

**Deliverables:**
- Working POS core
- Product catalog integration
- Basic transaction processing

### Phase 3: Payment Integration (3 weeks)

**Week 1: Cash Payments**
- Numpad dialog
- Change calculation
- Cash drawer integration
- Receipt printing

**Week 2: Card Payments**
- FNB PayPoint integration
- Serial communication
- Response handling
- Error management

**Week 3: EFT & Split Payments**
- EFT processing
- Split payment logic
- Payment reconciliation
- Testing

**Deliverables:**
- All payment methods working
- FNB integration complete
- Receipt printing functional

### Phase 4: Custom Orders (2 weeks)

**Week 1:**
- Order creation form
- Customer database
- Deposit processing
- Order receipt printing

**Week 2:**
- Order pickup process
- Order search
- Balance payment
- Order reporting

**Deliverables:**
- Complete custom orders system
- Order management
- Reporting

### Phase 5: Hardware Integration (2 weeks)

**Week 1:**
- Pole display integration
- Barcode scanner integration
- Cash drawer control
- Printer configuration

**Week 2:**
- Hardware testing
- Error handling
- Fallback mechanisms
- Documentation

**Deliverables:**
- All hardware integrated
- Testing complete
- User manual

### Phase 6: Testing & Deployment (3 weeks)

**Week 1: Testing**
- Unit testing
- Integration testing
- User acceptance testing
- Performance testing

**Week 2: Training**
- Create training materials
- Train trainers
- Train cashiers
- Create support documentation

**Week 3: Deployment**
- Install at pilot branch
- Monitor and support
- Fix issues
- Gather feedback

**Deliverables:**
- Tested application
- Trained users
- Deployed system
- Support documentation

### Total Timeline: 18 weeks (4.5 months)

---

## Cost Estimates

### Hardware Costs (Per Terminal)

| Item | Quantity | Unit Price | Total |
|------|----------|------------|-------|
| Touch Monitor 21" | 1 | R 5,000 | R 5,000 |
| Mini PC (i5, 8GB, 256GB) | 1 | R 8,000 | R 8,000 |
| Receipt Printer | 1 | R 3,500 | R 3,500 |
| FNB PayPoint Device | 1 | R 2,500 | R 2,500 |
| Pole Display | 1 | R 1,500 | R 1,500 |
| Cash Drawer | 1 | R 2,000 | R 2,000 |
| Barcode Scanner | 1 | R 1,200 | R 1,200 |
| UPS | 1 | R 1,000 | R 1,000 |
| Cables & Accessories | 1 | R 500 | R 500 |
| **Total per Terminal** | | | **R 25,200** |

### Software Development Costs

| Phase | Duration | Estimated Cost |
|-------|----------|----------------|
| Design & Prototyping | 2 weeks | R 30,000 |
| Core Development | 6 weeks | R 90,000 |
| Payment Integration | 3 weeks | R 45,000 |
| Custom Orders | 2 weeks | R 30,000 |
| Hardware Integration | 2 weeks | R 30,000 |
| Testing & Deployment | 3 weeks | R 45,000 |
| **Total Development** | 18 weeks | **R 270,000** |

### Ongoing Costs (Annual)

| Item | Cost |
|------|------|
| FNB Transaction Fees | Variable |
| Software Maintenance | R 30,000 |
| Support & Updates | R 20,000 |
| Hardware Warranty | R 5,000 |
| **Total Annual** | **R 55,000+** |

---

## Next Steps

### Immediate Actions

1. **Review & Approve Design**
   - Review this document
   - Select preferred UI option
   - Approve technology stack
   - Set budget

2. **FNB Integration Setup**
   - Contact FNB Merchant Services (087 575 9405)
   - Request ECR integration documentation
   - Obtain test device/credentials
   - Schedule technical meeting

3. **Hardware Procurement**
   - Get quotes for hardware
   - Order test equipment
   - Set up test environment
   - Configure devices

4. **Team Assembly**
   - Assign developers
   - Assign UI/UX designer
   - Assign tester
   - Assign project manager

5. **Project Kickoff**
   - Schedule kickoff meeting
   - Set milestones
   - Create project plan
   - Begin Phase 1

---

## Appendix

### A. F-Key Shortcuts (SAGE Compatible)

| Key | Function | Description |
|-----|----------|-------------|
| F1 | Help | Context-sensitive help |
| F2 | Search | Product search |
| F3 | Hold | Park current transaction |
| F4 | Recall | Retrieve parked transaction |
| F5 | Void | Void current transaction |
| F6 | Discount | Apply discount |
| F7 | Returns | Process return/refund |
| F8 | Reports | Quick reports |
| F9 | Cash Up | End of day cash up |
| F10 | Manager | Manager functions |
| F11 | Settings | POS settings |
| F12 | Logout | Logout cashier |

**Shift Combinations:**
| Key | Function |
|-----|----------|
| Shift+F1 | Price Override |
| Shift+F2 | Quantity Override |
| Shift+F3 | Customer Lookup |
| Shift+F4 | Reprint Receipt |
| Shift+F5 | Void Line Item |
| Shift+F6 | Loyalty Card |

### B. Pole Display Messages

**Standard Messages:**
- Welcome: "WELCOME TO OVEN DELIGHTS"
- Item Added: "WHITE BREAD    R 25.00"
- Subtotal: "SUBTOTAL      R 63.25"
- Total: "TOTAL         R 63.25"
- Tendered: "CASH         R100.00"
- Change: "CHANGE        R 36.75"
- Thank You: "THANK YOU! COME AGAIN"

**Format:** 2 lines × 20 characters

### C. Receipt Format

```
═══════════════════════════════════════
        OVEN DELIGHTS
        JHB Main Branch
        123 Main Road, Johannesburg
        Tel: 011-XXX-XXXX
        VAT: 1234567890
═══════════════════════════════════════
Date: 08/10/2025        Time: 14:30:25
Trans: POS-2025-001234
Cashier: John Doe       Till: 01
───────────────────────────────────────
1× White Bread                  R 25.00
2× Croissant @ R15.00           R 30.00
1× Chocolate Cake               R 85.00
───────────────────────────────────────
Subtotal:                      R140.00
VAT (15%):                      R21.00
───────────────────────────────────────
TOTAL:                         R161.00

Payment Method: CARD
Card Type: VISA
Card Number: ************1234
Auth Code: 123456
───────────────────────────────────────
        Thank you for your purchase!
        www.ovendelights.co.za

        Please retain this receipt
═══════════════════════════════════════
```

### D. Glossary

- **ECR:** Electronic Cash Register
- **POS:** Point of Sale
- **SKU:** Stock Keeping Unit
- **UOM:** Unit of Measure
- **EFT:** Electronic Funds Transfer
- **PCI DSS:** Payment Card Industry Data Security Standard
- **WPF:** Windows Presentation Foundation
- **MAUI:** Multi-platform App UI
- **API:** Application Programming Interface
- **UPS:** Uninterruptible Power Supply

---

**Document Version:** 1.0  
**Last Updated:** October 8, 2025  
**Next Review:** After stakeholder feedback  
**Author:** Development Team  
**Status:** Draft for Review
