# USER DEFINED ORDERS - COMPLETE IMPLEMENTATION

## Overview
The User Defined Orders system handles same-day/next-day cake orders with **full payment upfront**. This differs from regular cake orders which only require a deposit.

---

## KEY FEATURES

### Order Number Format
- **Format:** `BranchID` + `6` + `5-digit sequence`
- **Example:** `6600001` (Branch 6, sequence 00001)
- **Purpose:** Numeric-only for barcode compatibility

### Payment Model
- **Full payment required upfront** (unlike cake orders with deposits)
- Supports: Cash, Card, Split payments
- Immediately writes to Sales table as complete transaction
- Stock deducted at order creation

### Order Status Flow
1. **Created** - Order placed in POS, manufacturer notified
2. **Completed** - Manufacturer finished, ready for pickup
3. **PickedUp** - Customer collected order

---

## DATABASE SCHEMA

### POS_UserDefinedOrders Table
```sql
- UserDefinedOrderID (PK, Identity)
- OrderNumber (Unique, Format: BranchID6XXXXX)
- BranchID, BranchName
- CashierID, CashierName, TillPointID
- CustomerCellNumber, CustomerName, CustomerSurname
- CakeColour, CakeImage, SpecialRequest
- CollectionDate, CollectionTime, CollectionDay
- OrderDate, OrderTime, OrderDateTime
- TotalAmount, AmountPaid, PaymentMethod
- CashAmount, CardAmount
- Status (Created/Completed/PickedUp)
- CompletedDate, CompletedBy
- PickedUpDate, PickedUpTime, PickedUpDateTime, PickedUpBy
- SaleID, InvoiceNumber
- CreatedDate, ModifiedDate
```

### POS_UserDefinedOrderItems Table
```sql
- ItemID (PK, Identity)
- UserDefinedOrderID (FK)
- ProductID, ProductName, ProductCode
- Quantity, UnitPrice, LineTotal
- CreatedDate
```

### Indexes Created
- `IX_UserDefinedOrders_BranchID`
- `IX_UserDefinedOrders_Status`
- `IX_UserDefinedOrders_CustomerCell`
- `IX_UserDefinedOrders_CollectionDate`
- `IX_UserDefinedOrderItems_OrderID`

---

## POS SYSTEM COMPONENTS

### 1. Main POS Screen (`POSMainForm_REDESIGN.vb`)

**New Buttons Added:**
- **🎂 User Defined** - Creates new user defined order
- **📦 Collect UD** - Processes order pickup

**User Defined Mode Variables:**
```vb
Private _isUserDefinedMode As Boolean = False
Private _userDefinedOrderData As UserDefinedOrderData
Private _btnCompleteUserDefined As Button
```

**Key Methods:**
- `StartUserDefinedOrder()` - Initiates order creation
- `CompleteUserDefinedOrder()` - Processes payment and saves
- `SaveUserDefinedOrder()` - Writes to database
- `GenerateUserDefinedOrderNumber()` - Creates order number
- `CollectUserDefinedOrder()` - Opens collection dialog
- `ResetToSaleMode()` - Returns to normal sales mode

### 2. Header Capture Dialog (`UserDefinedOrderDialog.vb`)

**Captures:**
- Customer Cell Number (with lookup)
- Customer Name & Surname
- Cake Colour
- Special Request (dropdown + free text)
- Cake Picture
- Collection Date, Time, Day (auto-populated)

**Features:**
- Customer lookup by cell number
- Auto-populates if customer exists
- Adds new customer if not found
- Validates collection date (cannot be in past)

### 3. Order Printer (`UserDefinedOrderPrinter.vb`)

**Dual Till Slip Printing:**
- Customer Copy
- Business Copy

**Creation Slip Contains:**
- Full business info (name, address, phone)
- Order number with barcode
- Customer details
- Collection date/time/day
- Order details (colour, picture, special request)
- Items list with quantities and prices
- Payment info (method, amount paid)
- "PAID IN FULL" indicator
- "SCAN BARCODE FOR COLLECTION" footer

**Pickup Slip Contains:**
- "USER DEFINED ORDER - PICKED UP" header
- Pickup date/time
- Customer details
- Original order date
- Collection date/time
- Order details
- Items list
- Total paid
- Barcode

**All slips print in BOLD fonts** (Courier New 8pt & 11pt Bold)

### 4. Collection Dialog (`CollectUserDefinedDialog.vb`)

**Search Options:**
- Scan barcode (order number)
- Enter cell number

**Features:**
- Displays order details and status
- Shows items list
- **Process Pickup button:**
  - Only enabled if Status = "Completed"
  - Disabled if Status = "Created" (not ready)
  - Hidden if Status = "PickedUp" (already collected)
- Updates status to "PickedUp"
- Prints dual pickup slip
- Records pickup date/time and cashier

---

## ERP SYSTEM COMPONENTS

### 1. Management Form (`UserDefinedOrdersManagement.vb`)

**Location:** Manufacturing or Orders menu

**Features:**
- Date range filter
- Status filter (All/Created/Completed/PickedUp)
- Branch filter (Head Office sees all, branches see own)
- Color-coded grid:
  - Yellow: Created
  - Green: Completed
  - Gray: PickedUp

**Grid Columns:**
- Order Number
- Date Created
- Customer
- Phone
- Collection Date
- Collection Time
- Status
- Total Amount
- Branch

**Actions:**
- **View Order** - Opens details dialog
- **Set Completed** - Marks order ready for pickup
- **Refresh** - Reloads grid

### 2. Order Details Dialog (`UserDefinedOrderDetailsDialog.vb`)

**Displays:**
- Complete order information
- Customer details
- Collection details
- Order specifications
- Items list
- Payment information
- Status history

**Actions:**
- **Print Order** - Prints order summary
- **Close** - Closes dialog

---

## WORKFLOW

### ORDER CREATION (POS)
1. Cashier clicks **"User Defined"** button
2. System prompts to clear cart (if items present)
3. **UserDefinedOrderDialog** opens
4. Cashier enters customer cell number
5. System looks up customer (auto-fills if found)
6. Cashier enters order details:
   - Cake colour
   - Special request
   - Cake picture
   - Collection date/time
7. Click **Save**
8. System enters User Defined Mode
9. Breadcrumb shows: "🎂 USER DEFINED ORDER - [Customer] - Collect: [Date]"
10. Cashier adds items to cart
11. Click **"Complete User Defined Order"**
12. Payment tender opens
13. Customer pays **full amount**
14. System:
    - Generates order number (e.g., 6600001)
    - Writes to Sales table (SaleType = 'UserDefined')
    - Writes to Invoices table
    - Writes to POS_UserDefinedOrders table (Status = 'Created')
    - Writes to POS_UserDefinedOrderItems table
    - Updates stock (deducts immediately)
    - Creates journal entries
    - Prints dual till slip (Customer + Business copy)
15. Success message displays
16. Returns to Sale Mode

### MANUFACTURING (ERP)
1. Manufacturer opens **User Defined Orders Management**
2. Views orders with Status = "Created"
3. Manufactures the order
4. Clicks on order row
5. Clicks **"Set Completed"**
6. System updates Status to "Completed"
7. Order now ready for customer pickup

### ORDER COLLECTION (POS)
1. Customer arrives for pickup
2. Cashier clicks **"Collect User Defined"** button
3. **CollectUserDefinedDialog** opens
4. Cashier scans barcode OR enters cell number
5. System displays order details and status
6. If Status = "Completed":
   - **Process Pickup** button enabled
   - Cashier clicks button
   - System:
     - Updates Status to "PickedUp"
     - Records pickup date/time and cashier
     - Prints dual "PICKED UP" slip
   - Success message displays
7. If Status = "Created":
   - Button disabled
   - Message: "Order not ready yet"
8. If Status = "PickedUp":
   - Message: "Order already collected on [date/time]"

---

## CASH UP INTEGRATION

### Updated Stored Procedure: `sp_GetEndOfDayCashUp`

**New Columns:**
- `UserDefinedOrders` - Total amount from User Defined orders
- `UserDefinedOrderCount` - Number of User Defined orders
- `UserDefinedCash` - User Defined orders paid by cash
- `UserDefinedCard` - User Defined orders paid by card
- `UserDefinedSplit` - User Defined orders paid by split

**Included in:**
- `TransactionCount` - All transactions including User Defined
- `CashPayments` - Includes User Defined cash payments
- `CardPayments` - Includes User Defined card payments
- `ExpectedCash` - Includes User Defined cash in till

---

## FILES CREATED

### POS Solution (`Overn-Delights-POS`)
1. `Forms/UserDefinedOrderDialog.vb` - Header capture dialog
2. `Forms/CollectUserDefinedDialog.vb` - Collection dialog
3. `Services/UserDefinedOrderPrinter.vb` - Dual slip printer
4. `Models/UserDefinedOrderData.vb` - Data structure
5. `Database/CREATE_USERDEFINED_ORDERS_TABLES.sql` - Table creation

### ERP Solution (`Oven-Delights-ERP`)
1. `Forms/UserDefinedOrdersManagement.vb` - Management form
2. `Forms/UserDefinedOrderDetailsDialog.vb` - Details dialog
3. `Database/UPDATE_CASHUP_FOR_USERDEFINED.sql` - Cash up update
4. `Database/COMPLETE_USERDEFINED_SETUP.sql` - Complete setup script
5. `Documentation/USER_DEFINED_ORDERS_IMPLEMENTATION.md` - This document

### Modified Files
1. `POSMainForm_REDESIGN.vb` - Added buttons and User Defined mode logic

---

## INSTALLATION INSTRUCTIONS

### 1. Database Setup
Run the complete setup script:
```sql
-- Execute in SQL Server Management Studio
USE OvenDelightsERP
GO

-- Run complete setup
EXEC('path\to\COMPLETE_USERDEFINED_SETUP.sql')
```

Or run individual scripts in order:
1. `CREATE_USERDEFINED_ORDERS_TABLES.sql`
2. `UPDATE_CASHUP_FOR_USERDEFINED.sql`

### 2. ERP Integration
Add menu item to MainDashboard:
```vb
' In MainDashboard.vb or appropriate menu file
Private Sub OpenUserDefinedOrders(sender As Object, e As EventArgs)
    Try
        Dim frm As New UserDefinedOrdersManagement(_currentBranchID, _currentUserID)
        frm.MdiParent = Me
        frm.Show()
        frm.WindowState = FormWindowState.Maximized
    Catch ex As Exception
        MessageBox.Show("Error: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
    End Try
End Sub
```

Wire to menu:
```vb
Dim manufacturing As ToolStripMenuItem = GetOrCreateTopMenu("Manufacturing")
Dim userDefined As ToolStripMenuItem = GetOrCreateSubMenu(manufacturing, "User Defined Orders")
AddHandler userDefined.Click, AddressOf OpenUserDefinedOrders
```

### 3. Testing Checklist
- [ ] Create User Defined order in POS
- [ ] Verify dual till slip prints in bold
- [ ] Check order appears in ERP with Status = "Created"
- [ ] Mark order as "Completed" in ERP
- [ ] Collect order in POS using barcode
- [ ] Verify pickup slip prints
- [ ] Check status updated to "PickedUp"
- [ ] Verify Cash Up includes User Defined orders
- [ ] Test with Cash payment
- [ ] Test with Card payment
- [ ] Test with Split payment

---

## TROUBLESHOOTING

### Order Number Not Generating
- Check BranchID is set correctly
- Verify POS_UserDefinedOrders table exists
- Check TABLOCKX permissions

### Till Slip Not Printing
- Verify default printer is set
- Check BarcodeGenerator class exists
- Ensure fonts (Courier New) are installed

### Customer Lookup Not Working
- Verify Customers table exists
- Check CellNumber column format
- Ensure connection string is correct

### Status Not Updating
- Check UserDefinedOrderID is correct
- Verify user has UPDATE permissions
- Check Status column accepts values

### Cash Up Not Including Orders
- Verify SaleType = 'UserDefined' in DailySales
- Check sp_GetEndOfDayCashUp is updated
- Ensure BranchID and ReportDate are correct

---

## BUSINESS RULES

1. **Full payment required** - No deposits, full amount upfront
2. **Stock deducted immediately** - At order creation, not pickup
3. **Same branch collection** - Order must be collected from branch where placed
4. **Barcode required** - Order number must be numeric for scanning
5. **Status progression** - Created → Completed → PickedUp (no skipping)
6. **Dual printing** - Always print Customer + Business copy
7. **Bold fonts** - All till slips must print in bold
8. **Branch filtering** - Head Office sees all, branches see own

---

## SUPPORT

For issues or questions:
1. Check this documentation
2. Review troubleshooting section
3. Verify database setup is complete
4. Check connection strings
5. Review error logs

---

**Implementation Date:** December 2025  
**Version:** 1.0  
**Status:** Complete and Ready for Production
