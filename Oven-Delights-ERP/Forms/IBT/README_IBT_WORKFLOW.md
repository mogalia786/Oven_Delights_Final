# Inter-Branch Transfer (IBT) System - Complete Workflow

## Overview
Professional inter-branch transfer system with proper request/approval workflow, delivery notes, stock management, and inter-branch accounting.

---

## 🔄 Complete Workflow

### **Step 1: Request Products (Branch A - Requesting Branch)**
**Form:** `InternalPurchaseOrderForm`
**Menu:** Transfers (IBT) → Request Products

**Process:**
1. Branch 4 (requesting branch) creates Internal Purchase Order
2. Selects supplying branch (e.g., Branch 6)
3. Adds products with quantities and required dates
4. Submits request
5. System generates PO Number: `B4-i-PO-IBT-00001`
6. Status: **Pending**

**Database:**
- Table: `InternalPurchaseOrders`
- Status: `Pending`

---

### **Step 2: Approve/Reject Requests (Branch B - Supplying Branch)**
**Form:** `PendingRequestsForm`
**Menu:** Transfers (IBT) → Pending Requests

**Process:**
1. Branch 6 (supplying branch) views pending requests
2. Reviews product, quantity, required date
3. **Approves** or **Rejects** request
4. If rejected, enters rejection reason
5. Status changes to **Approved** or **Rejected**

**Database:**
- Table: `InternalPurchaseOrders`
- Status: `Approved` or `Rejected`
- Fields updated: `ApprovedBy`, `ApprovedDate`, `RejectionReason`

---

### **Step 3: Create Delivery Note (Branch B - Supplying Branch)**
**Form:** `CreateDeliveryNoteForm`
**Menu:** Transfers (IBT) → Create Delivery (or via Pending Requests)

**Process:**
1. Branch 6 selects approved PO
2. Clicks "Create Delivery"
3. Reviews delivery details:
   - PO Number
   - Requesting branch name & address
   - Product & quantity
   - Unit cost (from `Demo_Retail_Price`)
4. Confirms delivery quantity and cost
5. Adds notes
6. Clicks "Create & Dispatch"
7. System generates Delivery Note: `B6-i-DEL-IBT-00001`
8. **Stock deducted from Branch 6**
9. Status: **In Transit**

**Database:**
- Table: `InternalDeliveryNotes`
- Status: `In Transit`
- Fields: `FromBranchName`, `FromBranchAddress`, `ToBranchName`, `ToBranchAddress`
- Stock movement recorded in Branch 6 (negative)

---

### **Step 4: View In-Transit Deliveries (Branch A - Receiving Branch)**
**Form:** `InTransitDeliveriesForm`
**Menu:** Transfers (IBT) → In-Transit

**Process:**
1. Branch 4 views all deliveries dispatched to them
2. Shows:
   - Delivery Note Number
   - PO Number
   - From Branch
   - Product, Quantity, Value
   - Dispatch Date
3. Selects delivery to receive

---

### **Step 5: Receive Delivery (Branch A - Receiving Branch)**
**Form:** `ReceiveDeliveryForm`
**Menu:** Transfers (IBT) → Receive (or via In-Transit)

**Process:**
1. Branch 4 selects in-transit delivery
2. Reviews delivery details
3. Adds receiving notes
4. Confirms receipt
5. System:
   - **Stock added to Branch 4**
   - **Inter-branch ledger entry created**
   - Branch 4 becomes **debtor** to Branch 6
   - Status: **Delivered**

**Database:**
- Table: `InternalDeliveryNotes`
- Status: `Delivered`
- Fields updated: `ReceiveDate`, `ReceivedBy`
- Table: `InterBranchLedger`
  - `DebtorBranchID`: Branch 4 (owes money)
  - `CreditorBranchID`: Branch 6 (is owed money)
  - `Amount`: Total value
  - `Status`: `Outstanding`
- Stock movement recorded in Branch 4 (positive)

---

### **Step 6: View Delivered Items (Both Branches)**
**Form:** `DeliveredItemsForm`
**Menu:** Transfers (IBT) → Delivered Items

**Process:**
1. View complete history of delivered items
2. Filter by date range
3. Shows:
   - Date
   - PO Number
   - Delivery Note Number
   - Date Received
   - Product, Quantity, Value
   - Received By
4. Export to CSV

**Features:**
- Date range filtering
- Total deliveries count
- Total value calculation
- CSV export

---

### **Step 7: Inter-Branch Ledger (Both Branches)**
**Form:** `InterBranchLedgerForm`
**Menu:** Transfers (IBT) → Inter-Branch Ledger

**Process:**
1. View debtor/creditor balances between branches
2. Filter views:
   - All Transactions
   - Outstanding Only
   - Settled Only
   - We Owe Others
   - Others Owe Us
3. Shows:
   - Debtor Branch (owes money)
   - Creditor Branch (is owed money)
   - Delivery Note & PO Number
   - Amount
   - Status (Outstanding/Settled)
4. Mark transactions as settled
5. Summary:
   - Others Owe Us: R X.XX
   - We Owe Others: R X.XX
   - Net Position: R X.XX

**Features:**
- Color coding (red = we owe, green = settled)
- Settlement tracking
- Net position calculation

---

## 📊 Database Schema

### InternalPurchaseOrders
```sql
- InternalPOID (PK)
- PONumber (e.g., B4-i-PO-IBT-00001)
- RequestingBranchID
- SupplyingBranchID
- ProductID
- Quantity
- RequestedDate
- RequiredByDate
- Status (Pending, Approved, Rejected, Fulfilled)
- Notes
- ApprovedBy
- ApprovedDate
- RejectionReason
- CreatedBy
- CreatedDate
```

### InternalDeliveryNotes
```sql
- DeliveryNoteID (PK)
- DeliveryNoteNumber (e.g., B6-i-DEL-IBT-00001)
- InternalPOID (FK)
- FromBranchID
- FromBranchName
- FromBranchAddress
- ToBranchID
- ToBranchName
- ToBranchAddress
- ProductID
- Quantity
- UnitCost
- TotalValue
- DispatchDate
- ReceiveDate
- Status (In Transit, Delivered, Cancelled)
- Notes
- ReceivedBy
- CreatedBy
- CreatedDate
```

### InterBranchLedger
```sql
- LedgerID (PK)
- DebtorBranchID (Branch that owes money)
- CreditorBranchID (Branch that is owed money)
- DeliveryNoteID (FK)
- Amount
- TransactionDate
- Status (Outstanding, Settled)
- SettlementDate
- SettlementReference
- Notes
- CreatedBy
- CreatedDate
```

---

## 🎯 Key Features

### ✅ Proper Business Workflow
- Request → Approval → Delivery → Receipt
- No direct transfers without approval
- Full audit trail

### ✅ Stock Management
- Stock deducted on dispatch (Branch B)
- Stock added on receipt (Branch A)
- Automatic stock movements

### ✅ Accounting Integration
- Inter-branch debtor/creditor tracking
- Outstanding balances
- Settlement management
- Net position calculation

### ✅ Document Management
- Internal PO numbers
- Internal Delivery Note numbers
- Branch names and addresses on documents
- Ready for printing

### ✅ Professional UI
- Modern, clean interface
- Color-coded status
- Comprehensive filtering
- CSV export

---

## 🔐 Security & Validation

- Branch-specific views (users only see their branch data)
- Status validation (can't receive pending deliveries)
- Stock validation (prevents negative stock)
- User tracking (who created, approved, received)
- Transaction integrity (database transactions)

---

## 📝 Usage Examples

### Example 1: Branch 4 needs flour from Branch 6

1. **Branch 4 User:**
   - Menu → Transfers (IBT) → Request Products
   - Select "Branch 6" as supplying branch
   - Add "Flour Brown", Qty: 50kg
   - Submit
   - PO Created: `B4-i-PO-IBT-00001`

2. **Branch 6 User:**
   - Menu → Transfers (IBT) → Pending Requests
   - See request from Branch 4
   - Click "Approve"
   - Click "Create Delivery"
   - Confirm qty 50kg, cost R9.83/kg
   - Click "Create & Dispatch"
   - Delivery Note: `B6-i-DEL-IBT-00001`
   - Stock deducted: -50kg from Branch 6

3. **Branch 4 User:**
   - Menu → Transfers (IBT) → In-Transit
   - See delivery from Branch 6
   - Click "Receive Delivery"
   - Confirm receipt
   - Stock added: +50kg to Branch 4
   - Ledger: Branch 4 owes Branch 6 R491.50

4. **Both Branches:**
   - Menu → Transfers (IBT) → Inter-Branch Ledger
   - Branch 4 sees: "We Owe Others: R491.50"
   - Branch 6 sees: "Others Owe Us: R491.50"

---

## 🚀 Installation

1. **Run SQL Script:**
   ```sql
   -- Execute: CREATE_IBT_WORKFLOW_TABLES.sql
   ```

2. **Rebuild ERP:**
   - Right-click project → Rebuild
   - Ensure all forms compile

3. **Test Workflow:**
   - Login as Branch 4 → Request Products
   - Login as Branch 6 → Approve & Dispatch
   - Login as Branch 4 → Receive
   - Check ledger balances

---

## 📞 Support

For issues or questions:
- Check database tables exist
- Verify branch setup in `Branches` table
- Ensure products have cost prices in `Demo_Retail_Price`
- Check user has `BranchID` set in session

---

**Version:** 1.0  
**Created:** November 2024  
**Status:** Production Ready ✅
