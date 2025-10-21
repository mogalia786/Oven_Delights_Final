# CAKE ORDER WORKFLOW - ERP MANUFACTURING SYSTEM

## Overview
The ERP Manufacturing system handles both CAKE orders and GENERAL orders through a unified interface with specialized features for each type.

---

## ORDER IDENTIFICATION

### Cake Orders
- **Format**: `O-BranchPrefix-CAKE-000001`
- **Example**: `O-JHB-CAKE-000001`, `O-CPT-CAKE-000023`
- **Identification**: Contains `-CAKE-` in order number

### General Orders
- **Format**: `O-BranchPrefix-000001`
- **Example**: `O-JHB-000045`, `O-CPT-000102`
- **Identification**: Does NOT contain `-CAKE-` in order number

---

## ERP MENU STRUCTURE

```
Manufacturing
├── Categories
├── Subcategories
├── Products
├── Add Product
├── Recipe Creator
├── Build My Product
├── Recipe Viewer
├── BOM
├── Complete Build
├── MO Actions
└── Orders
    ├── Cake Orders
    │   ├── New Cake Orders
    │   ├── Ready Cake Orders
    │   └── All Cake Orders
    └── General Orders
        ├── New General Orders
        ├── Ready General Orders
        └── All General Orders
```

---

## HOW ERP HANDLES CAKE ORDERS

### 1. **Separate Menu Access**
- Cake orders have dedicated menu items under `Manufacturing > Orders > Cake Orders`
- Filters automatically applied: `OrderNumber LIKE '%-CAKE-%'`
- Manufacturer can focus exclusively on cake production

### 2. **Manufacturing Instructions Display**
When viewing cake order details (double-click order):

```
═══════════════════════════════════════
ORDER: O-JHB-CAKE-000001
Type: CAKE ORDER
Status: New
═══════════════════════════════════════

PICKUP BRANCH:
  Johannesburg Branch
  123 Main Street, Johannesburg
  Tel: 011-123-4567

CUSTOMER:
  Name: John Smith
  Phone: 082-123-4567

DUE DATE:
  25 Oct 2025 at 14:00

FINANCIAL:
  Total: R450.00
  Deposit: R225.00
  Balance: R225.00

───────────────────────────────────────
=== CAKE SPECIFICATIONS ===
Order: O-JHB-CAKE-000001
Customer: John Smith (082-123-4567)
Due: 25/10/2025 at 14:00

ITEM 1:
  Product: Large Chocolate Round Cake
  Quantity: 1
  Size: Large
  Shape: Round
  Flavour: Chocolate
───────────────────────────────────────

ORDER ITEMS:
  1.00 x Large Chocolate Round Cake
      @ R450.00 = R450.00
  ─────────────────────
  TOTAL: R450.00
```

### 3. **Automatic Specification Extraction**
The system automatically extracts cake specifications from product names:

**Detected Attributes:**
- **Size**: Small, Medium, Large
- **Shape**: Round, Square, Heart, Rectangle
- **Flavour**: Chocolate, Vanilla, Strawberry, Red Velvet, Carrot

**Example Product Names:**
- "Large Chocolate Round Cake" → Size: Large, Shape: Round, Flavour: Chocolate
- "Medium Vanilla Heart Cake" → Size: Medium, Shape: Heart, Flavour: Vanilla
- "Small Red Velvet Square Cake" → Size: Small, Shape: Square, Flavour: Red Velvet

### 4. **Same Workflow as General Orders**
Despite being separate, cake orders follow the SAME process:

#### Status Flow:
1. **New** → Order placed at POS, appears in "New Cake Orders"
2. **Ready** → Manufacturer marks as ready (same button, same process)
3. **Delivered** → Customer collects and pays balance at POS

#### Priority Color Coding:
- **Red (OVERDUE)**: ReadyDate < Today
- **Yellow (DUE TODAY)**: ReadyDate = Today
- **Green (ON TIME)**: ReadyDate > Today

#### Mark as Ready:
- Select order in grid
- Click "Mark as Ready" button (green button, bottom right)
- Confirmation dialog
- Status changes from "New" to "Ready"
- Order moves to "Ready Cake Orders" list

---

## HOW ERP HANDLES GENERAL ORDERS

### 1. **Separate Menu Access**
- General orders under `Manufacturing > Orders > General Orders`
- Filters automatically applied: `OrderNumber NOT LIKE '%-CAKE-%'`

### 2. **Order Details Display**
When viewing general order details:

```
═══════════════════════════════════════
ORDER: O-JHB-000045
Type: GENERAL ORDER
Status: New
═══════════════════════════════════════

PICKUP BRANCH:
  Johannesburg Branch
  123 Main Street, Johannesburg
  Tel: 011-123-4567

CUSTOMER:
  Name: Jane Doe
  Phone: 083-987-6543

DUE DATE:
  26 Oct 2025 at 10:00

FINANCIAL:
  Total: R850.00
  Deposit: R425.00
  Balance: R425.00

ORDER ITEMS:
  2.00 x Artisan Bread Loaf
      @ R35.00 = R70.00
  10.00 x Croissants
      @ R18.00 = R180.00
  1.00 x Custom Birthday Cake
      @ R600.00 = R600.00
  ─────────────────────
  TOTAL: R850.00
```

**Note**: No manufacturing instructions section (only for cake orders)

### 3. **Same Workflow**
- Same status flow (New → Ready → Delivered)
- Same priority color coding
- Same "Mark as Ready" button
- Same grid display format

---

## KEY DIFFERENCES: CAKE vs GENERAL

| Feature | Cake Orders | General Orders |
|---------|-------------|----------------|
| **Order Number** | O-BranchPrefix-CAKE-000001 | O-BranchPrefix-000001 |
| **Menu Location** | Orders > Cake Orders | Orders > General Orders |
| **Manufacturing Instructions** | ✅ YES - Shows cake specifications | ❌ NO |
| **Specification Extraction** | ✅ YES - Size, Shape, Flavour | ❌ NO |
| **Status Workflow** | ✅ Same (New → Ready → Delivered) | ✅ Same |
| **Mark as Ready** | ✅ Same button, same process | ✅ Same button, same process |
| **Priority Colors** | ✅ Same (Red/Yellow/Green) | ✅ Same |
| **Branch Tracking** | ✅ YES - Must collect at same branch | ✅ YES - Must collect at same branch |
| **Double-click Details** | ✅ Shows full specs + instructions | ✅ Shows order items only |

---

## BRANCH TRACKING (CRITICAL)

### Both Order Types:
1. **BranchID stored** in POS_CustomOrders table when order created
2. **Branch name displayed** in order grid (from JOIN to Branches table)
3. **Branch details shown** in order details (name, address, phone)
4. **Collection enforced** at same branch where order was placed

### Why This Matters:
- Prevents customer confusion (going to wrong branch)
- Ensures proper inventory tracking per branch
- Maintains accurate financial records per branch
- Receipt clearly shows pickup location

---

## DATABASE QUERIES

### Cake Orders Query:
```sql
SELECT 
    o.OrderID,
    o.OrderNumber AS [Order #],
    b.BranchName AS Branch,
    o.CustomerName + ' ' + o.CustomerSurname AS Customer,
    o.CustomerPhone AS Phone,
    CONVERT(VARCHAR, o.OrderDate, 106) AS [Order Date],
    CONVERT(VARCHAR, o.ReadyDate, 106) + ' ' + CONVERT(VARCHAR, o.ReadyTime, 108) AS [Due Date/Time],
    o.TotalAmount AS Total,
    o.OrderStatus AS Status,
    CASE 
        WHEN o.ReadyDate < CAST(GETDATE() AS DATE) THEN 'OVERDUE'
        WHEN o.ReadyDate = CAST(GETDATE() AS DATE) THEN 'DUE TODAY'
        ELSE 'ON TIME'
    END AS Priority
FROM POS_CustomOrders o
INNER JOIN Branches b ON o.BranchID = b.BranchID
WHERE OrderNumber LIKE '%-CAKE-%'
  AND OrderStatus = 'New'  -- or 'Ready' or no filter for 'All'
ORDER BY ReadyDate, ReadyTime
```

### General Orders Query:
```sql
-- Same query but with:
WHERE OrderNumber NOT LIKE '%-CAKE-%'
```

---

## MANUFACTURER WORKFLOW

### For Cake Orders:
1. Open ERP → Manufacturing → Orders → Cake Orders → New Cake Orders
2. View list of all new cake orders (sorted by due date)
3. Double-click order to see full details including:
   - Customer info
   - Pickup branch
   - Due date/time
   - **CAKE SPECIFICATIONS** (size, shape, flavour)
   - Items ordered
   - Financial details
4. Manufacture the cake according to specifications
5. Select order in grid
6. Click "Mark as Ready"
7. Order moves to "Ready Cake Orders"
8. Customer can now collect at POS (F12)

### For General Orders:
1. Open ERP → Manufacturing → Orders → General Orders → New General Orders
2. View list of all new general orders
3. Double-click to see order details (no manufacturing specs)
4. Prepare the order items
5. Mark as Ready (same process)
6. Customer collects at POS

---

## TECHNICAL IMPLEMENTATION

### Files Modified:
- `MainDashboard.vb` - Added Cake/General order menu structure
- `ManufacturerOrdersForm.vb` (both locations) - Added orderType parameter, enhanced details view
- `POSMainForm_REDESIGN.vb` - Cake order creation with CAKE prefix
- `PaymentTenderForm.vb` - Order collection payment handling

### Key Features:
- **Unified Form**: Same ManufacturerOrdersForm handles both types
- **Smart Filtering**: Automatic filter based on order number pattern
- **Type Detection**: `orderNumber.Contains("-CAKE-")` determines type
- **Conditional Display**: Manufacturing instructions only shown for cake orders
- **Branch JOIN**: All queries join to Branches table for branch details

---

## SUMMARY

The ERP handles cake orders and general orders through:
1. **Separate menu access** for better organization
2. **Same underlying form and workflow** for consistency
3. **Automatic filtering** based on order number pattern
4. **Enhanced details** for cake orders (specifications)
5. **Identical status management** (New → Ready → Delivered)
6. **Unified branch tracking** for both types

**Result**: Manufacturers can efficiently manage both order types with specialized features for cakes while maintaining a consistent, familiar workflow.
