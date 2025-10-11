# Retail Module
## User Training Manual - Complete Guide

**Version:** 1.0  
**Last Updated:** October 2025  
**Module:** Retail Management

---

## Table of Contents

1. [Module Overview](#module-overview)
2. [Menu Structure](#menu-structure)
3. [Point of Sale (POS)](#point-of-sale-pos)
4. [Products](#products)
5. [Inventory](#inventory)
6. [Reports](#reports)

---

## Module Overview

### Purpose

The Retail module handles all customer-facing sales operations and retail inventory management. It controls:

- Point of Sale transactions
- Product catalog for retail
- Retail stock levels
- Sales reporting
- Customer transactions

### Who Can Access

**Primary Users:**
- Cashiers (POS only)
- Retail Manager (full access)
- Branch Manager (full access)
- Sales Staff (limited access)

### Retail Inventory Flow

```
Manufacturing → Retail_Products_Inventory → POS Sale → Customer
External Products → Retail_Products_Inventory → POS Sale → Customer
```

---

## Menu Structure

```
Retail
├── POS
│   ├── New Sale (Scan/Lookup)
│   ├── Hold/Resume Sales
│   └── Returns/Refunds
├── Products
├── Inventory
│   ├── Stock on Hand
│   └── Adjustments
└── Reports
    ├── Sales Report
    └── Inventory Report
```

---

## Point of Sale (POS)

### Purpose
Process customer sales transactions at the point of sale.

### Accessing POS

1. Click **Retail** → **POS** → **New Sale (Scan/Lookup)**
2. POS interface opens

**📸 Screenshot Required:** `Retail_POS_Main.png`
- Show full POS interface
- Show product area, cart area, payment area
- Show all buttons and functions

### POS Interface Layout

**Screen Sections:**
```
┌─────────────────────────────────────────────────────────┐
│ Header: Branch | Cashier | Date/Time                    │
├──────────────────────┬──────────────────────────────────┤
│                      │                                  │
│  Product Selection   │    Current Transaction          │
│  (Categories/Search) │    (Cart Items)                 │
│                      │                                  │
│                      │                                  │
├──────────────────────┴──────────────────────────────────┤
│ Payment Area: Total | Tender | Change | Payment Methods│
└─────────────────────────────────────────────────────────┘
```

**📸 Screenshot Required:** `Retail_POS_Layout.png`
- Annotate each section
- Show section purposes
- Show navigation flow

### Processing a Sale

#### Step 1: Start New Sale

1. POS opens with blank transaction
2. If previous transaction exists, click **New Sale**
3. Transaction number auto-generated

**📸 Screenshot Required:** `Retail_POS_NewSale.png`
- Show new sale button
- Show blank transaction
- Show transaction number

#### Step 2: Add Products

**Method A: Barcode Scanning**
1. Click in barcode field (or press F2)
2. Scan product barcode
3. Product adds to cart automatically
4. Quantity defaults to 1
5. Scan again to increase quantity

**📸 Screenshot Required:** `Retail_POS_Barcode.png`
- Show barcode field highlighted
- Show scanner icon
- Show product added after scan

**Method B: Product Search**
1. Click **Search** button (or press F3)
2. Type product name or code
3. Select from results
4. Click **Add to Sale**

**📸 Screenshot Required:** `Retail_POS_Search.png`
- Show search dialog
- Show search results
- Show product selection

**Method C: Category Navigation**
1. Click category button
2. Click subcategory
3. Click product
4. Product adds to cart

**📸 Screenshot Required:** `Retail_POS_Categories.png`
- Show category buttons
- Show subcategory drill-down
- Show product selection

#### Step 3: Modify Cart Items

**Change Quantity:**
1. Click on quantity field
2. Enter new quantity
3. Press Enter
4. Line total updates

**📸 Screenshot Required:** `Retail_POS_ChangeQty.png`
- Show quantity field selected
- Show numeric keypad
- Show updated total

**Remove Item:**
1. Select line item
2. Click **Delete** button (or press Delete key)
3. Item removed from cart

**Apply Discount:**
1. Select line item
2. Click **Discount** button
3. Enter discount % or amount
4. Manager approval if over limit

**📸 Screenshot Required:** `Retail_POS_Discount.png`
- Show discount dialog
- Show percentage vs amount options
- Show manager approval prompt

#### Step 4: Review Transaction

**Cart Display Shows:**
- Product name
- Quantity
- Unit price
- Line total
- Any discounts applied

**Transaction Totals:**
- Subtotal
- Discount total
- VAT (15%)
- **Total Amount Due**

**📸 Screenshot Required:** `Retail_POS_Cart.png`
- Show cart with multiple items
- Show totals section
- Highlight total amount due

#### Step 5: Process Payment

**Payment Methods Available:**
- Cash
- Card (Credit/Debit)
- Account (Credit customers)
- Split Payment

**Cash Payment:**
1. Click **Cash** button
2. Enter amount tendered
3. System calculates change
4. Click **Complete Sale**
5. Cash drawer opens
6. Give change to customer

**📸 Screenshot Required:** `Retail_POS_CashPayment.png`
- Show cash payment dialog
- Show tender amount entry
- Show change calculation

**Card Payment:**
1. Click **Card** button
2. Select card type
3. Process through card machine
4. Enter approval code
5. Click **Complete Sale**

**📸 Screenshot Required:** `Retail_POS_CardPayment.png`
- Show card payment dialog
- Show card type selection
- Show approval code entry

**Account Payment:**
1. Click **Account** button
2. Search for customer
3. Verify credit limit available
4. Click **Complete Sale**
5. Posts to customer account

**📸 Screenshot Required:** `Retail_POS_AccountPayment.png`
- Show customer search
- Show credit limit check
- Show account balance

**Split Payment:**
1. Click **Split Payment**
2. Enter amount for first method
3. Process first payment
4. System shows remaining balance
5. Process second payment method

**📸 Screenshot Required:** `Retail_POS_SplitPayment.png`
- Show split payment interface
- Show multiple payment methods
- Show running balance

#### Step 6: Complete Sale

**After Payment Processed:**
1. Receipt prints automatically
2. Transaction saved
3. Inventory updated
4. GL entries created
5. New sale screen ready

**📸 Screenshot Required:** `Retail_POS_SaleComplete.png`
- Show completion message
- Show receipt printing
- Show new sale ready

### Special POS Functions

**Hold Transaction:**
1. Click **Hold** button
2. Enter customer name/reference
3. Transaction saved
4. Can recall later

**📸 Screenshot Required:** `Retail_POS_Hold.png`
- Show hold dialog
- Show reference entry
- Show held transactions list

**Recall Transaction:**
1. Click **Recall** button
2. Select held transaction
3. Transaction loads
4. Continue processing

**Void Transaction:**
- Before payment: Click **Cancel Sale**
- After payment: Use Returns/Refunds (manager approval)

**Price Override:**
1. Select line item
2. Click **Override Price**
3. Enter manager PIN
4. Enter new price
5. Reason required

**📸 Screenshot Required:** `Retail_POS_PriceOverride.png`
- Show manager PIN entry
- Show price override dialog
- Show reason field

### End of Day Procedures

**Cash Up Process:**
1. Click **Cash Up** button
2. Count physical cash in drawer
3. Enter counted amount
4. System shows variance
5. Print cash-up report
6. Manager signs off

**📸 Screenshot Required:** `Retail_POS_CashUp.png`
- Show cash counting screen
- Show variance calculation
- Show cash-up report

---

## Products

### Purpose
Manage retail product catalog and pricing.

### Accessing Products

1. Click **Retail** → **Products**
2. Products form opens

**📸 Screenshot Required:** `Retail_Products_List.png`
- Show products grid
- Show filter options
- Show action buttons

### Products List View

**Grid Columns:**
- Product Code (SKU)
- Product Name
- Category
- Subcategory
- Retail Price
- Stock on Hand
- Status (Active/Inactive)

**Filter Options:**
- By category
- By subcategory
- By status
- Search by name/code

**📸 Screenshot Required:** `Retail_Products_Filters.png`
- Show filter dropdowns
- Show search box
- Show filtered results

### Product Sources

**Products Come From:**
1. **Manufacturing:** Internally produced
   - Created in Manufacturing module
   - Moved to retail after production
   - Prefix: "i-" (internal)

2. **External Purchase:** Bought for resale
   - Purchased via Stockroom
   - Moved to retail after GRV
   - Prefix: "x-" (external)

**📸 Screenshot Required:** `Retail_Products_Sources.png`
- Show internal products (i- prefix)
- Show external products (x- prefix)
- Show source indicator

### Viewing Product Details

**To View Details:**
1. Double-click product in list
2. Product details form opens

**Details Shown:**
- Product information
- Current stock level
- Pricing
- Sales history
- Supplier (if external)
- Recipe (if internal)

**📸 Screenshot Required:** `Retail_Products_Details.png`
- Show complete product details
- Show all tabs
- Show stock and pricing

### Updating Retail Prices

**To Change Price:**
1. Open product details
2. Click **Edit Price**
3. Enter new retail price
4. Manager approval required
5. Effective date
6. Click **Save**

**📸 Screenshot Required:** `Retail_Products_PriceChange.png`
- Show price change dialog
- Show approval requirement
- Show effective date

**Price Change Log:**
- All price changes logged
- Who changed
- When changed
- Old vs new price
- Reason for change

---

## Inventory

### Purpose
Manage retail stock levels and adjustments.

### Menu: Inventory

```
Inventory
├── Stock on Hand
└── Adjustments
```

### Stock on Hand

#### Purpose
View current retail stock levels across all branches.

#### Accessing Stock on Hand

1. Click **Retail** → **Inventory** → **Stock on Hand**
2. Stock on hand form opens

**📸 Screenshot Required:** `Retail_Inventory_StockOnHand.png`
- Show stock grid
- Show branch filter
- Show stock levels

#### Stock on Hand View

**Grid Columns:**
- Product Code
- Product Name
- Branch
- Quantity on Hand
- Unit
- Average Cost
- Total Value
- Reorder Level
- Status

**Status Indicators:**
- 🟢 **OK:** Above reorder level
- 🟡 **Low:** Below reorder level
- 🔴 **Out:** Zero stock

**📸 Screenshot Required:** `Retail_Inventory_StatusIndicators.png`
- Show color-coded status
- Show OK, Low, Out examples
- Show legend

#### Filtering Stock

**Filter Options:**
- By branch (specific or all)
- By category
- By status (OK/Low/Out)
- Search by product

**📸 Screenshot Required:** `Retail_Inventory_Filters.png`
- Show filter options
- Show filtered results
- Show clear filters button

#### Stock Valuation

**View Stock Value:**
1. Select products
2. Click **Valuation Report**
3. Shows:
   - Quantity on hand
   - Average cost
   - Total value
   - By branch
   - Grand total

**📸 Screenshot Required:** `Retail_Inventory_Valuation.png`
- Show valuation report
- Show totals by branch
- Show grand total

### Adjustments

#### Purpose
Correct retail stock quantities for variances, damage, theft, etc.

#### Accessing Adjustments

1. Click **Retail** → **Inventory** → **Adjustments**
2. Adjustments form opens

**📸 Screenshot Required:** `Retail_Inventory_Adjustments.png`
- Show adjustments list
- Show new adjustment button
- Show adjustment status

#### Creating Stock Adjustment

**Step 1: New Adjustment**
1. Click **New Adjustment**
2. Adjustment form opens

**📸 Screenshot Required:** `Retail_Inventory_NewAdjustment.png`
- Show blank adjustment form
- Show header fields
- Show lines section

**Step 2: Enter Header**
- Adjustment date
- Branch
- Reason:
  * Stock Count Variance
  * Damaged Goods
  * Expired Products
  * Theft/Loss
  * Data Entry Correction
  * Other

**📸 Screenshot Required:** `Retail_Inventory_AdjustmentHeader.png`
- Show header fields filled
- Show reason dropdown
- Show branch selection

**Step 3: Add Products**
1. Click **Add Product**
2. Search for product
3. Enter:
   - Current qty (system shows)
   - Actual qty (what you counted)
   - Variance (auto-calculated)
   - Notes

**📸 Screenshot Required:** `Retail_Inventory_AdjustmentLines.png`
- Show product lines
- Show variance calculation
- Show notes field

**Step 4: Review and Post**
1. Review all lines
2. Check total value
3. Manager approval if over R1000
4. Click **Post Adjustment**
5. Inventory updated
6. GL entries created

**📸 Screenshot Required:** `Retail_Inventory_AdjustmentPost.png`
- Show review screen
- Show approval dialog
- Show post confirmation

**GL Entries:**
```
If Variance Positive (stock found):
Debit:  Inventory Account
Credit: Inventory Variance Account

If Variance Negative (stock missing):
Debit:  Inventory Variance Account
Credit: Inventory Account
```

---

## Reports

### Purpose
Analyze retail sales and inventory performance.

### Menu: Reports

```
Reports
├── Sales Report
└── Inventory Report
```

### Sales Report

#### Purpose
View sales performance and trends.

#### Accessing Sales Report

1. Click **Retail** → **Reports** → **Sales Report**
2. Sales report form opens

**📸 Screenshot Required:** `Retail_Reports_Sales.png`
- Show report parameters
- Show date range selection
- Show generate button

#### Report Parameters

**Filters:**
- Date range (From/To)
- Branch (specific or all)
- Product category
- Payment method
- Cashier

**📸 Screenshot Required:** `Retail_Reports_SalesFilters.png`
- Show all filter options
- Show date picker
- Show branch dropdown

#### Sales Report Sections

**Summary Section:**
- Total sales amount
- Number of transactions
- Average transaction value
- Number of customers
- Comparison to previous period

**📸 Screenshot Required:** `Retail_Reports_SalesSummary.png`
- Show summary tiles
- Show KPIs
- Show comparison arrows

**Sales by Category:**
- Breakdown by product category
- Units sold
- Revenue
- Percentage of total

**📸 Screenshot Required:** `Retail_Reports_SalesByCategory.png`
- Show category breakdown
- Show bar chart
- Show percentages

**Sales by Payment Method:**
- Cash sales
- Card sales
- Account sales
- Split payments

**📸 Screenshot Required:** `Retail_Reports_SalesByPayment.png`
- Show payment method breakdown
- Show pie chart
- Show amounts

**Top Selling Products:**
- Top 10 by revenue
- Top 10 by quantity
- Product details

**📸 Screenshot Required:** `Retail_Reports_TopProducts.png`
- Show top products list
- Show ranking
- Show sales figures

**Hourly Sales:**
- Sales by hour of day
- Peak trading times
- Staffing insights

**📸 Screenshot Required:** `Retail_Reports_HourlySales.png`
- Show hourly breakdown
- Show line chart
- Show peak hours highlighted

#### Exporting Sales Report

**Export Options:**
- PDF (formatted report)
- Excel (data for analysis)
- CSV (raw data)
- Email report

**📸 Screenshot Required:** `Retail_Reports_Export.png`
- Show export options
- Show format selection
- Show email dialog

### Inventory Report

#### Purpose
Analyze inventory levels and movements.

#### Accessing Inventory Report

1. Click **Retail** → **Reports** → **Inventory Report**
2. Inventory report form opens

**📸 Screenshot Required:** `Retail_Reports_Inventory.png`
- Show report parameters
- Show report type selection
- Show generate button

#### Report Types

**Stock Valuation Report:**
- Current stock levels
- Average cost
- Total value
- By branch
- By category

**📸 Screenshot Required:** `Retail_Reports_StockValuation.png`
- Show valuation by branch
- Show totals
- Show grand total

**Stock Movement Report:**
- All stock movements
- Receipts
- Sales
- Adjustments
- Transfers
- Running balance

**📸 Screenshot Required:** `Retail_Reports_StockMovement.png`
- Show movement transactions
- Show running balance
- Show movement types

**Low Stock Report:**
- Products below reorder level
- Quantity on hand
- Reorder level
- Shortage
- Recommended order quantity

**📸 Screenshot Required:** `Retail_Reports_LowStock.png`
- Show low stock items
- Show shortage calculation
- Show reorder recommendations

**Slow Moving Report:**
- Products with low sales velocity
- Days of stock remaining
- Last sale date
- Recommendations

**📸 Screenshot Required:** `Retail_Reports_SlowMoving.png`
- Show slow movers
- Show days of stock
- Show recommendations

**Stock Age Report:**
- How long stock has been on hand
- Aging categories (0-30, 31-60, 61-90, 90+ days)
- Potential obsolescence

**📸 Screenshot Required:** `Retail_Reports_StockAge.png`
- Show aging analysis
- Show age categories
- Show at-risk items

---

## Retail Module Summary

### Key Takeaways

✅ **Point of Sale**
- Process sales efficiently
- Multiple payment methods
- Hold and recall transactions
- End of day cash-up

✅ **Products**
- View retail catalog
- Internal and external products
- Update pricing
- Track sales history

✅ **Inventory**
- Monitor stock levels
- Process adjustments
- Track variances
- Stock valuation

✅ **Reports**
- Sales analysis
- Inventory analysis
- Performance metrics
- Export capabilities

### Common Tasks Quick Reference

| Task | Steps |
|------|-------|
| Process Sale | Retail → POS → New Sale |
| View Stock | Retail → Inventory → Stock on Hand |
| Stock Adjustment | Retail → Inventory → Adjustments |
| Sales Report | Retail → Reports → Sales Report |
| Inventory Report | Retail → Reports → Inventory Report |

### POS Keyboard Shortcuts

| Key | Function |
|-----|----------|
| F2 | Barcode field |
| F3 | Product search |
| F4 | Hold transaction |
| F5 | Recall transaction |
| F6 | Apply discount |
| F7 | Cash payment |
| F8 | Card payment |
| F9 | Account payment |
| F10 | Complete sale |
| F12 | Cash up |
| Delete | Remove line item |
| Esc | Cancel sale |

### Critical Reminders

⚠️ **Cash Handling:**
- Count cash carefully
- Verify change before giving
- Never leave drawer open
- Report discrepancies immediately

⚠️ **Stock Accuracy:**
- Process adjustments promptly
- Document reasons clearly
- Manager approval for large adjustments
- Regular stock counts

⚠️ **Customer Service:**
- Greet every customer
- Process transactions efficiently
- Handle complaints professionally
- Thank customers

### Support and Help

**Need Help?**
- Press F1 for context-sensitive help
- Check [User Manual Index](USER_MANUAL_00_INDEX.md)
- Contact Branch Manager
- IT Support: support@ovendelights.co.za

---

**Next Module:** [Accounting Management](USER_MANUAL_06_ACCOUNTING.md)

---

**Document Version:** 1.0  
**Last Updated:** October 2025  
**Next Review:** January 2026
