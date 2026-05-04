# OVEN DELIGHTS ERP - COMPLETE ACCOUNTING SYSTEM DESIGN

## Business Transaction Flows

### 1. POINT OF SALE (POS) - Retail Sales
**Transaction Flow:**
- Customer purchases retail items (bread, pastries, etc.)
- Payment received immediately (Cash or Card)
- Inventory reduced
- Revenue recognized immediately

**Accounting Entries:**
```
DR Cash on Hand (1110) / Bank (1120)     [Sale Amount]
   CR Sales Revenue (4100)                [Sale Amount]

DR Cost of Goods Sold (5100)             [Cost Amount]
   CR Retail Inventory (1300)             [Cost Amount]
```

**Current Issues:**
- POS sales posting to GL correctly?
- COGS calculation working?
- Inventory reduction happening?

---

### 2. CAKE ORDERS - Custom Orders with Deposits
**Transaction Flow:**
- Customer places cake order
- Deposit received (partial payment)
- Deposit held as liability until order fulfilled
- Balance paid on pickup
- Revenue recognized only when order completed and fully paid

**Accounting Entries:**

**Step 1: Deposit Received**
```
DR Cash on Hand (1110)                   [Deposit Amount]
   CR Customer Deposits (2120)            [Deposit Amount]
```

**Step 2: Balance Payment on Pickup**
```
DR Cash on Hand (1110)                   [Balance Amount]
   CR Customer Deposits (2120)            [Deposit Amount - clear liability]
   CR Cake Sales Revenue (4110)           [Total Order Amount]

DR Cost of Goods Sold (5100)             [Cost Amount]
   CR Finished Goods Inventory (1310)     [Cost Amount]
```

**Current Issues:**
- Cake orders NOT posting to Sales Revenue
- Deposits going to wrong account
- Revenue recognized too early?

---

### 3. MANUFACTURING - Production Process
**Transaction Flow:**
- Raw materials purchased via Purchase Order
- Raw materials moved to production
- Labor and overhead applied
- Finished goods (cakes) produced
- Finished goods moved to retail inventory OR used for cake orders

**Accounting Entries:**

**Step 1: Purchase Raw Materials (via PO)**
```
DR Raw Materials Inventory (1320)        [Cost]
   CR Accounts Payable - Supplier (2100-XXX) [Cost]
```

**Step 2: Move to Production**
```
DR Work in Progress (1330)               [Material Cost]
   CR Raw Materials Inventory (1320)      [Material Cost]
```

**Step 3: Apply Labor & Overhead**
```
DR Work in Progress (1330)               [Labor + Overhead]
   CR Wages Payable (2200)                [Labor]
   CR Manufacturing Overhead (5300)       [Overhead]
```

**Step 4: Complete Production**
```
DR Finished Goods Inventory (1310)       [Total Cost]
   CR Work in Progress (1330)             [Total Cost]
```

**Step 5: Move to Retail Inventory**
```
DR Retail Inventory (1300)               [Cost]
   CR Finished Goods Inventory (1310)     [Cost]
```

**Current Issues:**
- Manufacturing process posting to GL?
- Inventory costing method (FIFO, Average)?
- Overhead allocation?

---

### 4. PURCHASE ORDERS - Supplier Invoices
**Transaction Flow:**
- PO created for raw materials or supplies
- Goods received
- Invoice received from supplier
- Inventory increased
- Liability recorded

**Accounting Entries:**
```
DR Raw Materials Inventory (1320) / Supplies (1340) [Amount]
DR VAT Input (1500)                      [VAT Amount]
   CR Accounts Payable - Supplier (2100-XXX) [Total Amount]
```

**Current Issues:**
- PO posting to correct supplier subsidiary ledger?
- Inventory increase happening?
- VAT handling?

---

### 5. SUPPLIER PAYMENTS - Beneficiary Payments
**Transaction Flow:**
- Payment made to supplier via bank transfer
- Reduces Accounts Payable
- Reduces Bank balance
- Bank statement shows debit transaction

**Accounting Entries:**
```
DR Accounts Payable - Supplier (2100-XXX) [Amount]
   CR Bank Account (1120)                 [Amount]
```

**Current Issues:**
- Bank statement posting to correct supplier ledger?
- Matching to invoice?
- Subsidiary ledger showing debits (reducing liability)?

---

### 6. BANK RECONCILIATION - Statement Matching
**Transaction Flow:**
- Bank statement retrieved from FNB API
- Transactions matched to existing GL entries
- Unmatched transactions posted
- Reconciliation report generated

**Key Principle:**
**Bank reconciliation should MATCH existing GL entries, NOT create new ones for operational transactions**

**Accounting Entries (for unmatched items only):**

**Bank Charges:**
```
DR Bank Charges Expense (6080)           [Amount]
   CR Bank Account (1120)                 [Amount]
```

**Interest Earned:**
```
DR Bank Account (1120)                   [Amount]
   CR Interest Income (4300)              [Amount]
```

**Cash Deposits to Bank:**
```
DR Bank Account (1120)                   [Amount]
   CR Cash on Hand (1110)                 [Amount]
```

**Current Issues:**
- Bank statement creating duplicate GL entries
- Not matching to existing POS sales, supplier payments, customer receipts
- Posting to wrong accounts

---

## CORRECT ACCOUNTING FLOW

### Operational Transactions (POS, Cake Orders, PO, Payments)
1. Transaction occurs in business system
2. GL entry created immediately
3. Cash on Hand or Accounts Payable/Receivable updated
4. Bank account NOT updated yet (cash not deposited)

### End of Day - Cash Deposit
1. Cash from POS and cake deposits physically deposited to bank
2. GL entry created:
   ```
   DR Bank Account (1120)
   CR Cash on Hand (1110)
   ```

### Bank Reconciliation
1. Retrieve bank statement
2. Match deposits to cash deposit GL entries
3. Match payments to supplier payment GL entries
4. Match customer receipts to AR payment GL entries
5. Post ONLY unmatched items (bank charges, interest, etc.)
6. Mark matched GL entries as reconciled

---

## CHART OF ACCOUNTS STRUCTURE

### Assets (1000-1999)
- 1110 - Cash on Hand
- 1120 - Bank Account - FNB
- 1200 - Accounts Receivable (Control)
- 1200-XXX - Customer Subsidiary Ledgers
- 1300 - Retail Inventory
- 1310 - Finished Goods Inventory
- 1320 - Raw Materials Inventory
- 1330 - Work in Progress
- 1340 - Supplies Inventory
- 1500 - VAT Input

### Liabilities (2000-2999)
- 2100 - Accounts Payable (Control)
- 2100-XXX - Supplier Subsidiary Ledgers
- 2120 - Customer Deposits (Unearned Revenue)
- 2200 - Wages Payable
- 2300 - VAT Output

### Equity (3000-3999)
- 3100 - Owner's Equity
- 3200 - Retained Earnings

### Revenue (4000-4999)
- 4100 - Retail Sales Revenue
- 4110 - Cake Sales Revenue
- 4300 - Interest Income

### Cost of Goods Sold (5000-5099)
- 5100 - Cost of Goods Sold

### Expenses (5100-5999)
- 5300 - Manufacturing Overhead
- 6010 - Rent Expense
- 6020 - Utilities Expense
- 6080 - Bank Charges

---

## IMPLEMENTATION REQUIREMENTS

### 1. Fix IsMapped Column Error
- Run ALTER_AP_STATEMENT_TRANSACTIONS_ADD_MAPPING.sql

### 2. Verify/Create Chart of Accounts
- Ensure all accounts exist with correct codes
- Create subsidiary ledger accounts for suppliers and customers

### 3. Create/Fix GL Posting Procedures
- sp_PostPOSSale - POS transactions
- sp_PostCakeOrderDeposit - Cake order deposits
- sp_PostCakeOrderCompletion - Cake order completion
- sp_PostPurchaseOrder - PO receipt
- sp_PostSupplierPayment - Supplier payments
- sp_PostCashDeposit - Daily cash deposits
- sp_ReconcileBankStatement - Match and reconcile

### 4. Implement Inventory Management
- Track inventory movements
- Calculate COGS using FIFO or Average Cost
- Update inventory on sales and production

### 5. Bank Reconciliation Process
- Match bank transactions to existing GL entries
- Post only unmatched items
- Generate reconciliation report

---

## NEXT STEPS

1. First, fix the immediate IsMapped error
2. Audit existing GL posting procedures
3. Identify which procedures exist and which are missing
4. Create comprehensive posting procedures for each transaction type
5. Test each transaction type end-to-end
6. Implement bank reconciliation LAST (after operational posting works)
