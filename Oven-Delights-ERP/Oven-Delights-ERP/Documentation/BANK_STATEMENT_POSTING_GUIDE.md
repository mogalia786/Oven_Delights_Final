# BANK STATEMENT POSTING GUIDE - ACCOUNTANT'S PERSPECTIVE

## The Accounting Reality

**Every bank statement line must post to TWO accounts (double-entry):**
1. **Bank Account** (always DR for deposits, CR for payments)
2. **Corresponding Ledger Account** (the "other side")

---

## TYPICAL BANK STATEMENT TRANSACTIONS

### **DEBITS (Money Out - CR Bank Account)**

| Bank Statement Description | Post To | Subsidiary Ledger? |
|---------------------------|---------|-------------------|
| **Supplier Payment - ABC Suppliers** | DR 2100-001 (ABC Suppliers)<br>CR 1120 (Bank) | ✅ YES - Supplier ledger |
| **Rent - Property Owner** | DR 5200-001 (Landlord X)<br>CR 1120 (Bank) | ✅ YES - Landlord ledger |
| **Salary - John Doe** | DR 5100 (Salaries)<br>CR 1120 (Bank) | ❌ NO - Simple expense |
| **Fuel - Engen** | DR 5300 (Fuel Expense)<br>CR 1120 (Bank) | ❌ NO - Simple expense |
| **Maintenance - ABC Motors** | DR 5400 (Repairs & Maintenance)<br>CR 1120 (Bank) | ❌ NO - Simple expense |
| **Electricity - Eskom** | DR 5500 (Utilities - Electricity)<br>CR 1120 (Bank) | ❌ NO - Simple expense |
| **Water - City Council** | DR 5510 (Utilities - Water)<br>CR 1120 (Bank) | ❌ NO - Simple expense |
| **Internet - Telkom** | DR 5520 (Utilities - Telephone)<br>CR 1120 (Bank) | ❌ NO - Simple expense |
| **Bank Charges** | DR 5600 (Bank Charges)<br>CR 1120 (Bank) | ❌ NO - Simple expense |
| **Insurance - Santam** | DR 5700 (Insurance)<br>CR 1120 (Bank) | ❌ NO - Simple expense |
| **Legal Fees - Attorneys Inc** | DR 5800 (Professional Fees)<br>CR 1120 (Bank) | ❌ NO - Simple expense |
| **Stationery - Office Supplies** | DR 5900 (Stationery)<br>CR 1120 (Bank) | ❌ NO - Simple expense |

### **CREDITS (Money In - DR Bank Account)**

| Bank Statement Description | Post To | Subsidiary Ledger? |
|---------------------------|---------|-------------------|
| **Customer Payment - Customer A** | DR 1120 (Bank)<br>CR 1200-001 (Customer A) | ✅ YES - Customer ledger |
| **Rent Received - Mr Thomas** | DR 1120 (Bank)<br>CR 4200-001 (Tenant - Mr Thomas) | ✅ YES - Tenant ledger |
| **Interest Earned** | DR 1120 (Bank)<br>CR 4300 (Interest Income) | ❌ NO - Simple income |
| **Cash Deposit** | DR 1120 (Bank)<br>CR 1100 (Cash on Hand) | ❌ NO - Asset transfer |
| **Sales - Card Machine** | DR 1120 (Bank)<br>CR 4000 (Sales Revenue) | ❌ NO - Simple income |
| **Refund from Supplier** | DR 1120 (Bank)<br>CR 2100-001 (Supplier X) | ✅ YES - Supplier ledger |

---

## THE KEY INSIGHT

### ✅ USE SUBSIDIARY LEDGERS FOR:
1. **Accounts Payable (Suppliers)** - Because you owe them money over time
2. **Accounts Receivable (Customers)** - Because they owe you money over time
3. **Rent Income (Tenants)** - Because they pay you monthly
4. **Rent Expense (Landlords)** - Because you pay them monthly

### ❌ DON'T USE SUBSIDIARY LEDGERS FOR:
1. **Fuel** - It's an expense, not a creditor
2. **Maintenance** - It's an expense, not a creditor
3. **Utilities** - It's an expense (unless you track by location)
4. **Bank Charges** - It's an expense
5. **Salaries** - It's an expense (unless you need individual tracking)
6. **Interest Earned** - It's income

**Why?** Because these are **immediate expenses/income**, not **ongoing balances** you need to track.

---

## CORRECT CHART OF ACCOUNTS STRUCTURE

### ASSETS
```
1100 - Cash on Hand
1120 - Bank Account - FNB
1121 - Bank Account - Nedbank

1200 - Accounts Receivable (CONTROL) ⭐
  ├── 1200-001 - Customer A
  ├── 1200-002 - Customer B
  └── 1200-003 - Customer C
```

### LIABILITIES
```
2100 - Accounts Payable (CONTROL) ⭐
  ├── 2100-001 - ABC Suppliers
  ├── 2100-002 - XYZ Trading
  └── 2100-003 - Eskom (if on account)
```

### INCOME
```
4000 - Sales Revenue
4100 - Sales - Cash
4110 - Sales - Card
4120 - Sales - Credit

4200 - Rent Income (CONTROL) ⭐
  ├── 4200-001 - Rent - Mr Thomas
  └── 4200-002 - Rent - ABC Company

4300 - Interest Income
4400 - Other Income
```

### EXPENSES
```
5100 - Salaries & Wages
5200 - Rent Expense (CONTROL) ⭐
  ├── 5200-001 - Rent - Property Owner ABC
  └── 5200-002 - Rent - XYZ Properties

5300 - Fuel Expense
5400 - Repairs & Maintenance
5500 - Utilities - Electricity
5510 - Utilities - Water
5520 - Utilities - Telephone & Internet
5600 - Bank Charges
5700 - Insurance
5800 - Professional Fees
5900 - Stationery & Supplies
6000 - Depreciation
6100 - Bad Debts
6200 - Sundry Expenses
```

---

## BANK STATEMENT AUTO-MAPPING LOGIC

### Pattern 1: Supplier Payment
```
Bank Statement: "PAYMENT TO ABC SUPPLIERS INV-12345"
↓
Match invoice number → Find SupplierID → Get supplier ledger
↓
Journal Entry:
DR 2100-001 - ABC Suppliers (reduces payable)
CR 1120 - Bank Account
```

### Pattern 2: Customer Receipt
```
Bank Statement: "DEPOSIT FROM CUSTOMER A INV-67890"
↓
Match invoice number → Find CustomerID → Get customer ledger
↓
Journal Entry:
DR 1120 - Bank Account
CR 1200-001 - Customer A (reduces receivable)
```

### Pattern 3: Rent Payment (Expense)
```
Bank Statement: "RENT PAYMENT TO PROPERTY OWNER"
↓
Match landlord name → Get landlord ledger
↓
Journal Entry:
DR 5200-001 - Rent - Property Owner ABC
CR 1120 - Bank Account
```

### Pattern 4: Rent Received (Income)
```
Bank Statement: "RENT FROM MR THOMAS"
↓
Match tenant name → Get tenant ledger
↓
Journal Entry:
DR 1120 - Bank Account
CR 4200-001 - Rent - Mr Thomas
```

### Pattern 5: Fuel (Simple Expense)
```
Bank Statement: "ENGEN FUEL PURCHASE"
↓
Pattern match "fuel" → Simple expense account
↓
Journal Entry:
DR 5300 - Fuel Expense
CR 1120 - Bank Account
```

### Pattern 6: Bank Charges (Simple Expense)
```
Bank Statement: "BANK CHARGES"
↓
Pattern match "bank charges" → Simple expense account
↓
Journal Entry:
DR 5600 - Bank Charges
CR 1120 - Bank Account
```

### Pattern 7: Interest Earned (Simple Income)
```
Bank Statement: "INTEREST EARNED"
↓
Pattern match "interest" → Simple income account
↓
Journal Entry:
DR 1120 - Bank Account
CR 4300 - Interest Income
```

### Pattern 8: Cash Deposit
```
Bank Statement: "CASH DEPOSIT"
↓
Asset transfer (Cash → Bank)
↓
Journal Entry:
DR 1120 - Bank Account
CR 1100 - Cash on Hand
```

---

## CASH ON HAND RECONCILIATION

### The Problem
If you receive R10,000 cash sales but only bank R8,000, where's the R2,000?

### The Solution
```
Daily Cash Sales:
DR 1100 - Cash on Hand     R10,000
CR 4100 - Sales - Cash     R10,000

Cash Banked:
DR 1120 - Bank Account     R8,000
CR 1100 - Cash on Hand     R8,000

Result:
- Cash on Hand balance: R2,000 (still in till)
- Bank Account balance: R8,000 (banked)
- Sales Revenue: R10,000 (total sales)
- Balance Sheet balances ✅
```

### Cash Float
```
Opening Float:
DR 1100 - Cash on Hand     R1,000
CR 3000 - Owner's Equity   R1,000

Daily Sales:
DR 1100 - Cash on Hand     R5,000
CR 4100 - Sales - Cash     R5,000

Banking (leaving R1,000 float):
DR 1120 - Bank Account     R5,000
CR 1100 - Cash on Hand     R5,000

Cash on Hand balance: R1,000 (float maintained)
```

---

## UPDATED BANK STATEMENT MAPPING RULES

### Priority 1: Match to Subsidiary Ledgers (Ongoing Balances)
1. **Supplier payments** → Match invoice → Get supplier ledger (2100-001)
2. **Customer receipts** → Match invoice → Get customer ledger (1200-001)
3. **Rent payments** → Match landlord → Get landlord ledger (5200-001)
4. **Rent receipts** → Match tenant → Get tenant ledger (4200-001)

### Priority 2: Pattern Match to Simple Accounts (Immediate Expenses/Income)
5. **Fuel** → 5300 - Fuel Expense
6. **Maintenance** → 5400 - Repairs & Maintenance
7. **Electricity** → 5500 - Utilities - Electricity
8. **Water** → 5510 - Utilities - Water
9. **Telephone/Internet** → 5520 - Utilities - Telephone
10. **Bank charges** → 5600 - Bank Charges
11. **Insurance** → 5700 - Insurance
12. **Professional fees** → 5800 - Professional Fees
13. **Stationery** → 5900 - Stationery
14. **Salaries** → 5100 - Salaries & Wages
15. **Interest earned** → 4300 - Interest Income
16. **Cash deposit** → 1100 - Cash on Hand

### Priority 3: Manual Mapping
17. **Unknown transactions** → Prompt user to select account

---

## JOURNAL ENTRY EXAMPLES

### Example 1: Supplier Payment
```
Bank Statement Line:
Date: 2026-03-13
Description: PAYMENT TO ABC SUPPLIERS
Reference: INV-12345
Amount: -R5,000 (debit)

Journal Entry:
JournalNumber: BP-20260313-001
JournalDate: 2026-03-13
Reference: INV-12345
Description: Payment to ABC Suppliers

Lines:
1. DR 2100-001 (ABC Suppliers)     R5,000
2. CR 1120 (Bank Account - FNB)    R5,000
```

### Example 2: Fuel Purchase
```
Bank Statement Line:
Date: 2026-03-13
Description: ENGEN FUEL PURCHASE
Amount: -R800 (debit)

Journal Entry:
JournalNumber: BP-20260313-002
JournalDate: 2026-03-13
Reference: ENGEN-FUEL
Description: Fuel purchase

Lines:
1. DR 5300 (Fuel Expense)          R800
2. CR 1120 (Bank Account - FNB)    R800
```

### Example 3: Rent Received
```
Bank Statement Line:
Date: 2026-03-13
Description: RENT FROM MR THOMAS
Amount: +R10,000 (credit)

Journal Entry:
JournalNumber: BP-20260313-003
JournalDate: 2026-03-13
Reference: RENT-MAR2026
Description: Rent received from Mr Thomas

Lines:
1. DR 1120 (Bank Account - FNB)    R10,000
2. CR 4200-001 (Rent - Mr Thomas)  R10,000
```

### Example 4: Cash Deposit
```
Bank Statement Line:
Date: 2026-03-13
Description: CASH DEPOSIT
Amount: +R8,000 (credit)

Journal Entry:
JournalNumber: BP-20260313-004
JournalDate: 2026-03-13
Reference: CASH-DEP-001
Description: Cash deposit from till

Lines:
1. DR 1120 (Bank Account - FNB)    R8,000
2. CR 1100 (Cash on Hand)          R8,000
```

---

## IMPLEMENTATION CHANGES NEEDED

### 1. Update BankStatementViewerForm.vb
```vb
' Current: Returns supplier ledger for invoices only
' Needed: Return correct account for ALL transaction types

Function DetermineLedgerAccount(description, reference, amount, type) As String
    ' Priority 1: Subsidiary Ledgers
    If IsSupplierPayment(description, reference) Then
        Return GetSupplierLedger(reference)
    ElseIf IsCustomerReceipt(description, reference) Then
        Return GetCustomerLedger(reference)
    ElseIf IsRentPayment(description) Then
        Return GetLandlordLedger(description)
    ElseIf IsRentReceipt(description) Then
        Return GetTenantLedger(description)
    
    ' Priority 2: Simple Accounts (Pattern Match)
    ElseIf description.Contains("FUEL") Then
        Return "5300" ' Fuel Expense
    ElseIf description.Contains("BANK CHARGES") Then
        Return "5600" ' Bank Charges
    ElseIf description.Contains("INTEREST") And type = "Credit" Then
        Return "4300" ' Interest Income
    ElseIf description.Contains("CASH DEPOSIT") Then
        Return "1100" ' Cash on Hand
    ' ... more patterns
    
    Else
        Return "" ' Manual mapping required
    End If
End Function
```

### 2. Create Simple Expense/Income Accounts
```sql
-- Add to 01_ENHANCE_CHART_OF_ACCOUNTS.sql
INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, NormalBalance)
VALUES 
('5300', 'Fuel Expense', 'Expense', 'DR'),
('5400', 'Repairs & Maintenance', 'Expense', 'DR'),
('5500', 'Utilities - Electricity', 'Expense', 'DR'),
('5510', 'Utilities - Water', 'Expense', 'DR'),
('5520', 'Utilities - Telephone & Internet', 'Expense', 'DR'),
('5600', 'Bank Charges', 'Expense', 'DR'),
('5700', 'Insurance', 'Expense', 'DR'),
('5800', 'Professional Fees', 'Expense', 'DR'),
('5900', 'Stationery & Supplies', 'Expense', 'DR'),
('4300', 'Interest Income', 'Revenue', 'CR'),
('1100', 'Cash on Hand', 'Asset', 'DR');
```

---

## SUMMARY

**The Accountant's View:**
- **Subsidiary ledgers** = Ongoing balances (suppliers, customers, tenants, landlords)
- **Simple accounts** = Immediate expenses/income (fuel, utilities, bank charges, interest)
- **Every bank line** must post to exactly 2 accounts
- **Cash on Hand** is critical for balance sheet reconciliation

**Not every expense needs a subsidiary ledger - only those with ongoing balances!**
