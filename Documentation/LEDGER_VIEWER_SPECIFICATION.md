# GENERAL LEDGER VIEWER SPECIFICATION

## RESEARCH FINDINGS

### From Sage ERP:
1. **GL Detail Account Balance:** Shows journal detail transactions that make up account balance
2. **Dimensions:** Transaction type, document number, accounting date, reference
3. **Amounts:** Debit, Credit, Running Balance
4. **Filtering:** Company, site, date range, account, currency
5. **Totaling:** Activity subtotals, account subtotals, grand totals

### Industry Standards:
1. **Trial Balance:** List all accounts with debit/credit balances
2. **Account Ledger:** Detailed transactions per account
3. **Journal Entries:** View source journal with all lines
4. **Drill-Down:** From summary to detail to source document

---

## LEDGER VIEWER FEATURES REQUIRED

### 1. GENERAL LEDGER SUMMARY (Trial Balance)

**Display:**
- Account Code
- Account Name
- Account Type (Asset, Liability, Equity, Revenue, Expense)
- Debit Balance
- Credit Balance
- Net Balance
- Period comparison

**Features:**
- Filter by date range
- Filter by account type
- Filter by branch
- Group by account type
- Show/hide zero balances
- Export to Excel
- Print

**Layout:**
```
┌──────────────────────────────────────────────────────────────────┐
│ General Ledger - Trial Balance                                   │
├──────────────────────────────────────────────────────────────────┤
│ Period: [From: DD/MM/YYYY] [To: DD/MM/YYYY]  Branch: [All ▼]    │
│ Account Type: [All ▼]  [☐] Show Zero Balances  [Refresh]        │
├──────────────────────────────────────────────────────────────────┤
│ Code    Account Name              Type      Debit      Credit    │
│ ────────────────────────────────────────────────────────────────│
│ ASSETS                                                            │
│ 1010    Bank Account              Asset    25,450.00      -      │
│ 1300    Inventory                 Asset    45,200.00      -      │
│ 1310    Stockroom Inventory       Asset    12,300.00      -      │
│ 1320    Manufacturing Inventory   Asset     8,150.00      -      │
│ 1330    Retail Inventory          Asset    24,750.00      -      │
│                                   Subtotal: 115,850.00      -    │
│                                                                   │
│ LIABILITIES                                                       │
│ 2100    Accounts Payable          Liab         -      18,500.00  │
│ 2200    Inter-Branch Creditors    Liab         -       3,200.00  │
│                                   Subtotal:     -      21,700.00  │
│                                                                   │
│ REVENUE                                                           │
│ 4000    Sales Revenue             Revenue     -      95,450.00   │
│                                   Subtotal:     -      95,450.00  │
│                                                                   │
│ EXPENSES                                                          │
│ 5000    Cost of Sales             Expense  55,200.00      -      │
│ 5100    Operating Expenses        Expense  12,300.00      -      │
│                                   Subtotal: 67,500.00      -      │
│ ────────────────────────────────────────────────────────────────│
│ TOTAL:                                     183,350.00  117,150.00 │
│ DIFFERENCE:                                           66,200.00   │
└──────────────────────────────────────────────────────────────────┘
```

### 2. ACCOUNT LEDGER (Detailed Transactions)

**Display:**
- Transaction Date
- Journal Number
- Reference
- Description
- Debit Amount
- Credit Amount
- Running Balance
- Source Document Link

**Features:**
- Select account from dropdown
- Date range filter
- Search by reference/description
- Running balance calculation
- Drill-down to journal entry
- Export to Excel/PDF

**Layout:**
```
┌──────────────────────────────────────────────────────────────────┐
│ Account Ledger - 1300 Inventory                                  │
├──────────────────────────────────────────────────────────────────┤
│ Period: [From: DD/MM/YYYY] [To: DD/MM/YYYY]  Branch: [All ▼]    │
│ Search: [____________]  [Filter]  [Export]  [Print]             │
├──────────────────────────────────────────────────────────────────┤
│ Date       Journal#  Reference    Description      Debit  Credit Balance│
│ ─────────────────────────────────────────────────────────────────│
│ 01/10/2025 JNL-001   GRV-1001    GRV Receipt      2,500     -   2,500 │
│ 02/10/2025 JNL-005   IO-45       BOM Fulfill        -    1,200  1,300 │
│ 03/10/2025 JNL-012   POS-2301    POS Sale           -      850    450 │
│ 05/10/2025 JNL-018   GRV-1005    GRV Receipt      3,200     -   3,650 │
│ 07/10/2025 JNL-025   BUILD-12    Build Complete     -    1,500  2,150 │
│ ─────────────────────────────────────────────────────────────────│
│ Opening Balance:                                              0   │
│ Total Debits:                                             5,700   │
│ Total Credits:                                            3,550   │
│ Closing Balance:                                          2,150   │
└──────────────────────────────────────────────────────────────────┘
```

### 3. JOURNAL ENTRY VIEWER

**Display:**
- Journal Header (Number, Date, Reference, Description, Posted By)
- All Journal Lines (Account, Debit, Credit, Description)
- Total Debits = Total Credits verification
- Source document reference
- Posting status

**Features:**
- Search by journal number
- Filter by date range
- Filter by posted/unposted
- View source document
- Reverse/void journal
- Print journal voucher

**Layout:**
```
┌──────────────────────────────────────────────────────────────────┐
│ Journal Entry - JNL-BOM-45-20251008033045                        │
├──────────────────────────────────────────────────────────────────┤
│ Journal Number:  JNL-BOM-45-20251008033045                       │
│ Date:            08/10/2025                                       │
│ Reference:       IO-45                                            │
│ Description:     BOM Fulfillment - Issue to Manufacturing        │
│ Posted By:       John Smith                                       │
│ Posted Date:     08/10/2025 03:30:45                             │
│ Status:          ✅ Posted                                        │
├──────────────────────────────────────────────────────────────────┤
│ Account Code  Account Name              Debit      Credit        │
│ ──────────────────────────────────────────────────────────────  │
│ 1320          Manufacturing Inventory   1,200.00      -          │
│ 1310          Stockroom Inventory          -      1,200.00       │
│ ──────────────────────────────────────────────────────────────  │
│ TOTAL:                                   1,200.00  1,200.00      │
│ BALANCE:                                 ✅ Balanced              │
├──────────────────────────────────────────────────────────────────┤
│ [View Source Document] [Print Voucher] [Reverse] [Close]        │
└──────────────────────────────────────────────────────────────────┘
```

### 4. JOURNAL REGISTER (All Journals)

**Display:**
- Journal Number
- Date
- Reference
- Description
- Total Amount
- Posted By
- Status

**Features:**
- Filter by date range
- Filter by status (Posted/Unposted)
- Filter by user
- Search by reference
- Bulk posting
- Export list

**Layout:**
```
┌──────────────────────────────────────────────────────────────────┐
│ Journal Register                                                  │
├──────────────────────────────────────────────────────────────────┤
│ Period: [From: DD/MM/YYYY] [To: DD/MM/YYYY]                      │
│ Status: [All ▼]  Posted By: [All ▼]  [Search]  [Export]         │
├──────────────────────────────────────────────────────────────────┤
│ Journal#        Date       Reference  Description      Amount  Status│
│ ──────────────────────────────────────────────────────────────  │
│ JNL-001         01/10/2025 GRV-1001   GRV Receipt      2,500  Posted│
│ JNL-005         02/10/2025 IO-45      BOM Fulfill      1,200  Posted│
│ JNL-012         03/10/2025 POS-2301   POS Sale           850  Posted│
│ JNL-018         05/10/2025 GRV-1005   GRV Receipt      3,200  Posted│
│ JNL-025         07/10/2025 BUILD-12   Build Complete   1,500  Posted│
│ ──────────────────────────────────────────────────────────────  │
│ Total Journals: 5                     Total Amount:    9,250       │
└──────────────────────────────────────────────────────────────────┘
```

### 5. ACCOUNT ACTIVITY REPORT

**Display:**
- Account summary
- Monthly activity
- Trend analysis
- Comparison periods

**Layout:**
```
┌──────────────────────────────────────────────────────────────────┐
│ Account Activity - 1300 Inventory                                 │
├──────────────────────────────────────────────────────────────────┤
│ Period: October 2025                                              │
│                                                                   │
│ Opening Balance (01/10/2025):                            0.00    │
│                                                                   │
│ Activity:                                                         │
│   Receipts (GRV):                                     5,700.00    │
│   Issues (BOM):                                      (1,200.00)   │
│   Transfers (Build):                                 (1,500.00)   │
│   Sales (POS):                                         (850.00)   │
│                                                                   │
│ Net Change:                                           2,150.00    │
│ Closing Balance (08/10/2025):                        2,150.00    │
│                                                                   │
│ Transaction Count: 5                                              │
│ Average Transaction: 1,140.00                                     │
└──────────────────────────────────────────────────────────────────┘
```

---

## DATABASE QUERIES REQUIRED

### 1. Trial Balance Query
```sql
SELECT 
    coa.AccountCode,
    coa.AccountName,
    coa.AccountType,
    SUM(CASE WHEN jd.Debit > 0 THEN jd.Debit ELSE 0 END) AS TotalDebit,
    SUM(CASE WHEN jd.Credit > 0 THEN jd.Credit ELSE 0 END) AS TotalCredit,
    SUM(jd.Debit - jd.Credit) AS NetBalance
FROM ChartOfAccounts coa
LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
WHERE jh.IsPosted = 1
  AND jh.JournalDate BETWEEN @FromDate AND @ToDate
  AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
GROUP BY coa.AccountCode, coa.AccountName, coa.AccountType
ORDER BY coa.AccountCode
```

### 2. Account Ledger Query
```sql
SELECT 
    jh.JournalDate,
    jh.JournalNumber,
    jh.Reference,
    jh.Description,
    jd.Debit,
    jd.Credit,
    SUM(jd.Debit - jd.Credit) OVER (ORDER BY jh.JournalDate, jh.JournalID) AS RunningBalance
FROM JournalDetails jd
INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
WHERE jd.AccountID = @AccountID
  AND jh.IsPosted = 1
  AND jh.JournalDate BETWEEN @FromDate AND @ToDate
ORDER BY jh.JournalDate, jh.JournalID
```

### 3. Journal Entry Detail Query
```sql
SELECT 
    jh.JournalID,
    jh.JournalNumber,
    jh.JournalDate,
    jh.Reference,
    jh.Description,
    jh.IsPosted,
    jh.CreatedBy,
    jh.CreatedDate,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit,
    jd.Description AS LineDescription
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jh.JournalID = @JournalID
ORDER BY jd.JournalDetailID
```

---

## IMPLEMENTATION CHECKLIST

### Phase 1: Trial Balance View
- [ ] Create TrialBalanceForm.vb
- [ ] Implement trial balance query
- [ ] Add filtering (date, branch, account type)
- [ ] Add export to Excel
- [ ] Add print functionality

### Phase 2: Account Ledger View
- [ ] Create AccountLedgerForm.vb
- [ ] Implement account selection dropdown
- [ ] Implement ledger query with running balance
- [ ] Add drill-down to journal entry
- [ ] Add export and print

### Phase 3: Journal Entry Viewer
- [ ] Create JournalEntryViewerForm.vb
- [ ] Display journal header and lines
- [ ] Verify debit = credit
- [ ] Add source document link
- [ ] Add print voucher

### Phase 4: Journal Register
- [ ] Create JournalRegisterForm.vb
- [ ] List all journals with filters
- [ ] Add search functionality
- [ ] Add bulk operations
- [ ] Add export

### Phase 5: Account Activity Report
- [ ] Create AccountActivityReportForm.vb
- [ ] Implement monthly summary
- [ ] Add trend analysis
- [ ] Add comparison features

### Phase 6: Integration
- [ ] Add to Accounting menu
- [ ] Link from other forms
- [ ] Add keyboard shortcuts
- [ ] Add help documentation

---

## SUCCESS CRITERIA

1. ✅ View all GL accounts with balances (Trial Balance)
2. ✅ Drill-down to account transactions (Account Ledger)
3. ✅ View individual journal entries with all lines
4. ✅ Search and filter by date, account, reference
5. ✅ Running balance calculation
6. ✅ Export to Excel/PDF
7. ✅ Print reports and vouchers
8. ✅ User-friendly navigation and interface
