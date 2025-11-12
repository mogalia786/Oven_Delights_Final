# Inter-Branch Transfer Implementation

## Overview
Complete 3-stage workflow for inter-branch stock transfers with proper status management and accounting integration.

## Database Setup

### 1. Run SQL Script
Execute: `SQL/CREATE_INTERBRANCH_TRANSFERS_TABLE.sql`

This creates:
- `InterBranchTransfers` table with status workflow
- Adds `TransferID` column to `PurchaseOrders` table

## Forms Created

### 1. InterBranchTransferForm.vb
**Purpose:** Create new transfer orders
**Status:** Pending
**Actions:**
- Select From Branch and To Branch
- Select Product from `demo_Retail_product`
- Auto-populate cost price from `demo_Retail_price`
- Enter quantity
- Optional: Generate Inter-Branch PO
- Saves to `InterBranchTransfers` table

**Menu Location:** Retail → Transfers (IBT) → Create

### 2. TransferOrdersListForm.vb
**Purpose:** View and manage all transfer orders
**Features:**
- Filter by status (All, Pending, In Transit, Received, Cancelled)
- Color-coded status display
- Launch Dispatch or Receive forms
- Refresh list

**Menu Location:** Retail → Transfers (IBT) → Transfer Orders

### 3. TransferDispatchForm.vb
**Purpose:** Dispatch pending transfers
**Status Change:** Pending → In Transit
**Actions:**
- View transfer details
- Add dispatch notes
- Update status to "In Transit"
- Record DispatchedBy and DispatchedDate
- TODO: Reduce sender inventory
- TODO: Post accounting (DR Inter-Branch Debtors, CR Inventory)

**Menu Location:** Retail → Transfers (IBT) → Dispatch

### 4. TransferReceiveForm.vb
**Purpose:** Receive in-transit transfers
**Status Change:** In Transit → Received
**Actions:**
- View transfer details including dispatch date
- Add receipt notes
- Update status to "Received"
- Record ReceivedBy and ReceivedDate
- TODO: Increase receiver inventory
- TODO: Post accounting (DR Inventory, CR Inter-Branch Creditors)

**Menu Location:** Retail → Transfers (IBT) → Receive

## Workflow

```
┌─────────────────┐
│  CREATE         │
│  (Pending)      │
│  - Select items │
│  - Set quantity │
│  - Optional PO  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  DISPATCH       │
│  (In Transit)   │
│  - Reduce stock │
│  - DR Debtors   │
│  - CR Inventory │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  RECEIVE        │
│  (Received)     │
│  - Increase stk │
│  - DR Inventory │
│  - CR Creditors │
└─────────────────┘
```

## Key Features

### Product Integration
- Uses `demo_Retail_product` for product list
- Uses `demo_Retail_price` for cost prices by branch
- Uses `BranchCode` from Branches table

### Purchase Order Integration
- Optional PO generation on transfer creation
- PO linked to transfer via `TransferID`
- Uses ToBranchID as SupplierID (4=Umhlanga, 6=Ayesha Court)

### Accounting (TODO)
**On Dispatch:**
- Sender Branch: DR Inter-Branch Debtors, CR Inventory
- Reduce inventory quantity at sender

**On Receive:**
- Receiver Branch: DR Inventory, CR Inter-Branch Creditors
- Increase inventory quantity at receiver

### Audit Trail
- CreatedBy, CreatedDate
- DispatchedBy, DispatchedDate
- ReceivedBy, ReceivedDate
- Notes field tracks all actions

## Next Steps

1. **Inventory Integration**
   - Connect to `demo_Retail_stock` or appropriate inventory table
   - Reduce quantity on Dispatch
   - Increase quantity on Receive

2. **Accounting Integration**
   - Post to `JournalEntries` table on Dispatch
   - Post to `JournalEntries` table on Receive
   - Use product ledger codes (i-PROD-xxx for internal, x-PROD-xxx for external)

3. **Menu Integration**
   - Add menu items to MainForm
   - Wire up to new forms

4. **Reporting**
   - Transfer history report
   - In-transit items report
   - Inter-branch reconciliation report

## Testing Checklist

- [ ] Create transfer with valid product and branches
- [ ] Verify cost price populates correctly
- [ ] Generate PO (optional)
- [ ] View transfer in Transfer Orders list
- [ ] Dispatch transfer (status → In Transit)
- [ ] Receive transfer (status → Received)
- [ ] Verify all audit fields populated
- [ ] Test with different branches
- [ ] Test with different products

## Database Schema

### InterBranchTransfers Table
```sql
TransferID INT PRIMARY KEY
TransferNumber NVARCHAR(50) -- BranchCode-IBT-#####
FromBranchID INT
ToBranchID INT
ProductID INT (from demo_Retail_product)
Quantity DECIMAL(18,2)
UnitCost DECIMAL(18,2)
TotalValue DECIMAL(18,2)
TransferDate DATETIME
Status NVARCHAR(20) -- Pending, In Transit, Received, Cancelled
Notes NVARCHAR(MAX)
CreatedBy INT
CreatedDate DATETIME
DispatchedBy INT
DispatchedDate DATETIME
ReceivedBy INT
ReceivedDate DATETIME
```

## Status Flow Rules

1. **Pending** → Can only be Dispatched or Cancelled
2. **In Transit** → Can only be Received or Cancelled
3. **Received** → Final status, no further changes
4. **Cancelled** → Final status, no further changes
