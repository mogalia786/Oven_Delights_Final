# CASH BOOK SPECIFICATION - Based on Sage Pastel Best Practices

## RESEARCH FINDINGS

### From Sage Pastel:
1. **Separate Cash Books:** Create dedicated bank accounts for each cash type (Main Cash, Petty Cash, Sundries)
2. **Receipts & Payments:** Each cashbook has dedicated Receipts and Payments tabs
3. **GDC Transactions:** General Ledger (G), Debtors (D), Creditors (C) transaction types
4. **Batch Processing:** All transactions must be updated/posted in batches
5. **Reconciliation:** Daily reconciliation with opening and closing balances

### From Industry Standards:
1. **Single/Double/Triple Column:** Track Cash, Bank, and Discounts
2. **Petty Cash Book:** Separate book for small daily expenses
3. **Float Management:** Track opening float, receipts, payments, closing balance
4. **Daily Reconciliation:** Opening Balance + Receipts - Payments = Closing Balance

---

## CASH BOOK FEATURES REQUIRED

### 1. MULTIPLE CASH BOOKS
Create separate cash books for:
- **Main Cash Book** - Primary cash transactions
- **Petty Cash Book** - Small daily expenses (< R500)
- **Sundries Cash Book** - Miscellaneous cash transactions
- **Bank Account(s)** - One per bank account

### 2. DAILY FLOAT MANAGEMENT

**Opening Float:**
- Set at start of day
- Carried forward from previous day's closing
- Recorded in CashBook table

**Closing Float:**
- Counted at end of day
- Must match: Opening + Receipts - Payments
- Variance tracked (Over/Short)

**Process:**
```
Opening Float:     R 1,000.00
+ Cash Receipts:   R 5,450.00
- Cash Payments:   R 3,200.00
= Expected Close:  R 3,250.00
Actual Count:      R 3,245.00
Variance (Short):  R     5.00
```

### 3. TRANSACTION TYPES

**Receipts (Money IN):**
- Cash Sales
- Customer Payments
- Float Top-Up
- Refunds Received
- Inter-Cash Transfer IN
- Sundry Income

**Payments (Money OUT):**
- Supplier Payments
- Petty Cash Expenses
- Float Banking (deposit to bank)
- Refunds Issued
- Inter-Cash Transfer OUT
- Sundry Expenses

### 4. PETTY CASH FEATURES

**Voucher System:**
- Petty Cash Voucher Number
- Date
- Payee
- Amount
- Purpose/Description
- Authorized By
- Receipt Attached (Yes/No)

**Categories:**
- Office Supplies
- Transport/Fuel
- Refreshments
- Postage
- Cleaning
- Repairs & Maintenance
- Sundry Expenses

**Reconciliation:**
- Opening Balance
- Top-Up from Main Cash
- Expenses
- Closing Balance
- Physical Count
- Variance

### 5. SUNDRIES CASH BOOK

**Purpose:**
- One-off transactions
- Non-recurring items
- Temporary cash holdings
- Special purpose funds

**Examples:**
- Event cash
- Donations
- Special collections
- Temporary advances

### 6. CASH BOOK ENTRIES

**Required Fields:**
- Date
- Cash Book Type (Main/Petty/Sundries)
- Transaction Type (Receipt/Payment)
- Reference Number
- Payee/Payer
- Description
- Amount
- Category/GL Account
- Payment Method (Cash/Card/EFT)
- Authorized By
- Notes

### 7. RECONCILIATION FEATURES

**Daily Reconciliation:**
- Opening Balance
- Total Receipts
- Total Payments
- Expected Closing
- Actual Count
- Variance (Over/Short)
- Variance Reason
- Reconciled By
- Reconciled Date

**Variance Handling:**
- If Over: CR Cash, DR Cash Over/Short (Income)
- If Short: DR Cash Over/Short (Expense), CR Cash
- Post variance to GL

### 8. REPORTING REQUIREMENTS

**Daily Reports:**
- Cash Book Summary (per book)
- Daily Receipts & Payments
- Float Reconciliation
- Variance Report

**Period Reports:**
- Cash Book Ledger (detailed transactions)
- Petty Cash Analysis by Category
- Cash Flow Summary
- Bank Reconciliation

**Management Reports:**
- Cash Position (all books)
- Petty Cash Utilization
- Variance Trends
- Cash vs Bank Analysis

### 9. INTEGRATION WITH GL

**Automatic Posting:**
- Each transaction creates journal entry
- DR/CR based on transaction type
- Posted to appropriate GL accounts
- Reference to Cash Book entry

**GL Accounts Required:**
- Cash on Hand (Asset)
- Petty Cash (Asset)
- Sundries Cash (Asset)
- Cash Over/Short (Income/Expense)
- Various Expense Categories

### 10. SECURITY & CONTROLS

**Access Control:**
- Only authorized users can:
  - Create cash book entries
  - Reconcile cash books
  - Post to GL
  - View reports

**Audit Trail:**
- All transactions logged
- User who created
- Date/Time created
- Modifications tracked
- Deletion prevented (void instead)

**Approval Workflow:**
- Petty cash > R100 requires approval
- Daily reconciliation requires manager sign-off
- Variances > R50 require explanation

---

## DATABASE SCHEMA REQUIRED

### CashBooks Table
```sql
CREATE TABLE CashBooks (
    CashBookID INT IDENTITY(1,1) PRIMARY KEY,
    CashBookCode NVARCHAR(20) NOT NULL UNIQUE,
    CashBookName NVARCHAR(100) NOT NULL,
    CashBookType NVARCHAR(20) NOT NULL, -- Main, Petty, Sundries, Bank
    GLAccountID INT NOT NULL, -- Link to ChartOfAccounts
    BranchID INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedBy INT,
    CreatedDate DATETIME2 DEFAULT GETDATE()
)
```

### CashBookTransactions Table
```sql
CREATE TABLE CashBookTransactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    CashBookID INT NOT NULL,
    TransactionDate DATE NOT NULL,
    TransactionType NVARCHAR(20) NOT NULL, -- Receipt, Payment
    ReferenceNumber NVARCHAR(50),
    Payee NVARCHAR(200),
    Description NVARCHAR(500),
    Amount DECIMAL(18,2) NOT NULL,
    CategoryID INT, -- Link to expense categories
    GLAccountID INT, -- Contra account
    PaymentMethod NVARCHAR(50), -- Cash, Card, EFT
    VoucherNumber NVARCHAR(50),
    AuthorizedBy INT,
    Notes NVARCHAR(1000),
    JournalID INT, -- Link to posted journal
    IsPosted BIT DEFAULT 0,
    IsVoid BIT DEFAULT 0,
    CreatedBy INT,
    CreatedDate DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (CashBookID) REFERENCES CashBooks(CashBookID)
)
```

### CashBookReconciliation Table
```sql
CREATE TABLE CashBookReconciliation (
    ReconciliationID INT IDENTITY(1,1) PRIMARY KEY,
    CashBookID INT NOT NULL,
    ReconciliationDate DATE NOT NULL,
    OpeningBalance DECIMAL(18,2) NOT NULL,
    TotalReceipts DECIMAL(18,2) NOT NULL,
    TotalPayments DECIMAL(18,2) NOT NULL,
    ExpectedClosing DECIMAL(18,2) NOT NULL,
    ActualCount DECIMAL(18,2) NOT NULL,
    Variance DECIMAL(18,2) NOT NULL,
    VarianceReason NVARCHAR(500),
    ReconciledBy INT,
    ReconciledDate DATETIME2,
    IsApproved BIT DEFAULT 0,
    ApprovedBy INT,
    ApprovedDate DATETIME2,
    FOREIGN KEY (CashBookID) REFERENCES CashBooks(CashBookID)
)
```

---

## USER INTERFACE DESIGN

### Main Cash Book Screen

**Layout:**
```
┌─────────────────────────────────────────────────────────────┐
│ Cash Book Management                          [Branch: XXX] │
├─────────────────────────────────────────────────────────────┤
│ Cash Book: [Main Cash ▼]  Date: [DD/MM/YYYY]  [Reconcile]  │
├─────────────────────────────────────────────────────────────┤
│ Opening Balance: R 1,000.00                                 │
│                                                               │
│ ┌─ Receipts ─────────────┐ ┌─ Payments ─────────────────┐  │
│ │ [+ New Receipt]         │ │ [+ New Payment]            │  │
│ │                         │ │                            │  │
│ │ Time  Ref    Amount     │ │ Time  Ref    Amount        │  │
│ │ 09:00 R001  R  250.00   │ │ 10:30 P001  R  150.00      │  │
│ │ 11:15 R002  R  500.00   │ │ 14:00 P002  R  300.00      │  │
│ │ 15:30 R003  R1,200.00   │ │ 16:45 P003  R   75.00      │  │
│ │                         │ │                            │  │
│ │ Total:     R1,950.00    │ │ Total:     R  525.00       │  │
│ └─────────────────────────┘ └────────────────────────────┘  │
│                                                               │
│ Expected Closing: R 2,425.00                                │
│ Actual Count:     R [______]  [Count & Reconcile]           │
├─────────────────────────────────────────────────────────────┤
│ [View Transactions] [Reports] [Post to GL] [Close]          │
└─────────────────────────────────────────────────────────────┘
```

### Petty Cash Screen

**Layout:**
```
┌─────────────────────────────────────────────────────────────┐
│ Petty Cash Management                         [Branch: XXX] │
├─────────────────────────────────────────────────────────────┤
│ Opening Balance: R 500.00          [Top Up from Main Cash]  │
│                                                               │
│ ┌─ New Petty Cash Voucher ─────────────────────────────────┐│
│ │ Voucher No: [Auto]      Date: [DD/MM/YYYY]               ││
│ │ Payee:      [____________]                                ││
│ │ Amount:     R [______]                                    ││
│ │ Category:   [Office Supplies ▼]                           ││
│ │ Purpose:    [_______________________________________]     ││
│ │ Receipt:    [☑] Attached  [Upload]                        ││
│ │                                                            ││
│ │ [Save Voucher] [Cancel]                                   ││
│ └───────────────────────────────────────────────────────────┘│
│                                                               │
│ Today's Expenses:                                            │
│ ┌───────────────────────────────────────────────────────────┐│
│ │ Voucher  Time   Payee          Category      Amount       ││
│ │ PV001    09:15  Stationery Co  Office Supp   R  45.00    ││
│ │ PV002    11:30  Taxi Driver    Transport      R  80.00    ││
│ │ PV003    14:00  Coffee Shop    Refreshments   R  65.00    ││
│ │                                                            ││
│ │ Total Expenses:                              R 190.00     ││
│ └───────────────────────────────────────────────────────────┘│
│                                                               │
│ Closing Balance: R 310.00                                    │
│ Physical Count:  R [______]  [Reconcile]                     │
└─────────────────────────────────────────────────────────────┘
```

---

## IMPLEMENTATION CHECKLIST

### Phase 1: Database Setup
- [ ] Create CashBooks table
- [ ] Create CashBookTransactions table
- [ ] Create CashBookReconciliation table
- [ ] Create default cash books (Main, Petty, Sundries)
- [ ] Link to ChartOfAccounts

### Phase 2: Core Functionality
- [ ] Cash Book selection and switching
- [ ] Receipt entry form
- [ ] Payment entry form
- [ ] Transaction listing
- [ ] Daily totals calculation

### Phase 3: Petty Cash Features
- [ ] Petty cash voucher form
- [ ] Category management
- [ ] Receipt attachment
- [ ] Approval workflow
- [ ] Petty cash reconciliation

### Phase 4: Reconciliation
- [ ] Opening balance setup
- [ ] Daily reconciliation form
- [ ] Variance calculation
- [ ] Variance posting to GL
- [ ] Approval process

### Phase 5: GL Integration
- [ ] Auto journal creation
- [ ] Posting to GL
- [ ] Account mapping
- [ ] Batch posting

### Phase 6: Reporting
- [ ] Daily cash book report
- [ ] Petty cash analysis
- [ ] Reconciliation report
- [ ] Variance report
- [ ] Cash position summary

### Phase 7: Security
- [ ] User permissions
- [ ] Approval workflow
- [ ] Audit trail
- [ ] Void functionality

---

## SUCCESS CRITERIA

1. ✅ Multiple cash books (Main, Petty, Sundries) operational
2. ✅ Daily float management with opening/closing balances
3. ✅ Petty cash voucher system with categories
4. ✅ Automatic reconciliation with variance tracking
5. ✅ All transactions post to GL automatically
6. ✅ Comprehensive reporting available
7. ✅ User-friendly interface matching Sage Pastel workflow
8. ✅ Full audit trail and security controls
