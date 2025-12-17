# Inter-Branch Transfer (IBT) Workflow Redesign

## Current Issues:
1. No cost price popup fires on every keystroke during product search
2. Simple transfer model doesn't match business workflow
3. No proper request/approval process
4. No delivery notes
5. No inter-branch debtor/creditor accounting

## New Workflow:

### Step 1: Branch A Requests Products (Internal Purchase Order)
- **Form:** `InternalPurchaseOrderForm`
- **Action:** Branch 4 creates request for products from Branch 6
- **Document:** `B4-i-PO-IBT-00001`
- **Status:** "Pending Approval"
- **Table:** `InternalPurchaseOrders`

### Step 2: Branch B Approves and Creates Delivery
- **Form:** `InternalPOApprovalForm`
- **Action:** Branch 6 views pending requests, approves
- **Document:** `B6-i-DEL-IBT-00001` (Delivery Note)
- **Status:** "In Transit"
- **Stock:** Deducted from Branch 6
- **Table:** `InternalDeliveryNotes`

### Step 3: Branch A Receives Delivery
- **Form:** `InternalDeliveryReceiveForm`
- **Action:** Branch 4 receives delivery
- **Status:** "Delivered"
- **Stock:** Added to Branch 4
- **Accounting:** 
  - DR: Inventory (Branch 4)
  - CR: Inter-Branch Payable (Branch 4 owes Branch 6)

### Step 4: View Delivered Items
- **Form:** `DeliveredItemsListForm`
- **Shows:** Date, PO Number, Delivery Note, Date Received
- **Filter:** By branch, date range, status

## Database Changes Needed:

### Table: InternalPurchaseOrders
```sql
- InternalPOID (PK)
- PONumber (e.g., B4-i-PO-IBT-00001)
- RequestingBranchID (Branch 4)
- SupplyingBranchID (Branch 6)
- ProductID
- Quantity
- RequestedDate
- Status (Pending, Approved, Rejected, Fulfilled)
- Notes
- CreatedBy
- CreatedDate
```

### Table: InternalDeliveryNotes
```sql
- DeliveryNoteID (PK)
- DeliveryNoteNumber (e.g., B6-i-DEL-IBT-00001)
- InternalPOID (FK to InternalPurchaseOrders)
- FromBranchID (Branch 6)
- ToBranchID (Branch 4)
- ProductID
- Quantity
- UnitCost
- TotalValue
- DispatchDate
- ReceiveDate
- Status (In Transit, Delivered, Cancelled)
- CreatedBy
- CreatedDate
```

### Table: InterBranchLedger
```sql
- LedgerID (PK)
- DebtorBranchID (Branch 4 - owes money)
- CreditorBranchID (Branch 6 - is owed money)
- DeliveryNoteID (FK)
- Amount
- TransactionDate
- Status (Outstanding, Settled)
- SettlementDate
- Notes
```

## Menu Structure:

### Transfers (IBT) Menu:
1. **Request Products** → InternalPurchaseOrderForm (Create i-PO)
2. **Pending Requests** → InternalPOApprovalForm (Approve/Reject)
3. **Create Delivery** → InternalDeliveryForm (Create i-DEL from approved PO)
4. **In Transit** → InTransitDeliveriesForm (View dispatched deliveries)
5. **Receive Delivery** → ReceiveDeliveryForm (Receive and update stock)
6. **Delivered Items** → DeliveredItemsListForm (History)
7. **Inter-Branch Ledger** → InterBranchLedgerForm (Debtor/Creditor balances)

## Implementation Priority:
1. ✅ Fix cost price popup (already done, needs rebuild)
2. Create database tables (SQL scripts)
3. Create InternalPurchaseOrderForm
4. Create InternalPOApprovalForm
5. Create InternalDeliveryForm
6. Create ReceiveDeliveryForm
7. Create DeliveredItemsListForm
8. Create InterBranchLedgerForm
9. Update menu structure
10. Add accounting journal entries
