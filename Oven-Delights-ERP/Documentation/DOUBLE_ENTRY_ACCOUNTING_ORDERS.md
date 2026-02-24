# Double-Entry Accounting for Order System

## Overview
This document outlines the complete double-entry accounting implementation for the custom order system, ensuring proper revenue recognition and liability management.

---

## 1. ORDER CREATION (Deposit Payment)

### Business Rule
**Deposit is a LIABILITY, NOT revenue**. Revenue is only recognized when the order is completed and fully paid.

### Transaction Flow
```
Customer pays R500 deposit for cake order
```

### Accounting Entries
| Account                | Debit  | Credit |
|------------------------|--------|--------|
| Cash on Hand / Bank    | R500   |        |
| Customer Deposits      |        | R500   |

### Database Recording
```sql
-- Demo_Sales entry (tracking only, not revenue)
INSERT INTO Demo_Sales (InvoiceNumber, SaleType, TotalAmount, PaymentMethod)
VALUES ('O-AC-CAKE-000001', 'OrderDeposit', 500.00, 'Cash')

-- General Ledger postings
INSERT INTO GeneralLedger (AccountID, DebitAmount, Reference, Description)
VALUES (@CashAccountID, 500.00, 'O-AC-CAKE-000001', 'Deposit received')

INSERT INTO GeneralLedger (AccountID, CreditAmount, Reference, Description)
VALUES (@CustomerDepositsAccountID, 500.00, 'O-AC-CAKE-000001', 'Customer deposit liability')
```

### Key Points
- ✅ Cash/Bank increases (asset)
- ✅ Customer Deposits increases (liability)
- ❌ NO Sales Revenue recorded
- ❌ NO VAT recorded (not a sale yet)

---

## 2. ORDER COMPLETION (Collection & Balance Payment)

### Business Rule
**Revenue is recognized when order is collected and balance is paid in full.**

### Transaction Flow
```
Order total: R1,200
Deposit paid: R500
Balance due: R700
Customer pays R700 and collects order
```

### Accounting Entries
| Account                | Debit    | Credit   |
|------------------------|----------|----------|
| Cash on Hand / Bank    | R700     |          |
| Customer Deposits      | R500     |          |
| Sales Revenue          |          | R1,043   |
| VAT Payable (15%)      |          | R157     |

**Calculation:**
- Total Incl VAT: R1,200
- Total Ex VAT: R1,200 / 1.15 = R1,043.48
- VAT Amount: R1,200 - R1,043.48 = R156.52

### Database Recording
```sql
-- Demo_Sales entry (THIS IS THE ACTUAL SALE)
INSERT INTO Demo_Sales (InvoiceNumber, SaleType, TotalAmount, PaymentMethod)
VALUES ('COLLECT-20260223-001', 'OrderCollection', 1200.00, 'Cash')

-- GL: Debit Cash for balance payment
INSERT INTO GeneralLedger (AccountID, DebitAmount, Reference)
VALUES (@CashAccountID, 700.00, 'COLLECT-20260223-001')

-- GL: Debit Customer Deposits (clear liability)
INSERT INTO GeneralLedger (AccountID, DebitAmount, Reference)
VALUES (@CustomerDepositsAccountID, 500.00, 'COLLECT-20260223-001')

-- GL: Credit Sales Revenue
INSERT INTO GeneralLedger (AccountID, CreditAmount, Reference)
VALUES (@SalesRevenueAccountID, 1043.48, 'COLLECT-20260223-001')

-- GL: Credit VAT Payable
INSERT INTO GeneralLedger (AccountID, CreditAmount, Reference)
VALUES (@VATPayableAccountID, 156.52, 'COLLECT-20260223-001')
```

### Key Points
- ✅ Full revenue recognized (R1,043.48)
- ✅ VAT liability recorded (R156.52)
- ✅ Customer Deposits liability cleared (R500)
- ✅ Cash/Bank increased by balance (R700)
- ✅ Order status updated to "Delivered"

---

## 3. ORDER CANCELLATION (Refund with Fee)

### Business Rule
**Cancellation fee is revenue. Refund is return of deposit minus fee.**

### Transaction Flow
```
Deposit paid: R500
Cancellation fee: R100
Refund to customer: R400
```

### Accounting Entries
| Account                    | Debit  | Credit |
|----------------------------|--------|--------|
| Customer Deposits          | R500   |        |
| Cancellation Fee Revenue   |        | R100   |
| Cash on Hand / Bank        |        | R400   |

### Database Recording
```sql
-- 1. Record cancellation fee as REVENUE
INSERT INTO Demo_Sales (InvoiceNumber, SaleType, TotalAmount, PaymentMethod)
VALUES ('CANCEL-20260223-001', 'CancellationFee', 100.00, 'Cash')

-- GL: Debit Customer Deposits (partial clear)
INSERT INTO GeneralLedger (AccountID, DebitAmount, Reference)
VALUES (@CustomerDepositsAccountID, 100.00, 'CANCEL-20260223-001')

-- GL: Credit Cancellation Fee Revenue
INSERT INTO GeneralLedger (AccountID, CreditAmount, Reference)
VALUES (@CancellationFeeRevenueAccountID, 100.00, 'CANCEL-20260223-001')

-- 2. Record refund transaction
INSERT INTO Demo_Sales (InvoiceNumber, SaleType, TotalAmount, PaymentMethod)
VALUES ('REFUND-20260223-001', 'OrderRefund', -400.00, 'Cash')

-- GL: Debit Customer Deposits (clear remaining liability)
INSERT INTO GeneralLedger (AccountID, DebitAmount, Reference)
VALUES (@CustomerDepositsAccountID, 400.00, 'REFUND-20260223-001')

-- GL: Credit Cash/Bank (money out)
INSERT INTO GeneralLedger (AccountID, CreditAmount, Reference)
VALUES (@CashAccountID, 400.00, 'REFUND-20260223-001')
```

### Refund Tender Dialog
**CRITICAL:** System MUST open tender dialog to process refund:
- User selects refund method (Cash/Card/EFT)
- System processes refund through appropriate channel
- Card refunds go through payment gateway
- EFT refunds require manual processing
- Prints refund receipt for customer

### Key Points
- ✅ Cancellation fee recognized as revenue (R100)
- ✅ Customer Deposits liability fully cleared (R500 total)
- ✅ Cash/Bank reduced by refund amount (R400)
- ✅ Order status updated to "Cancelled"
- ✅ Refund tender dialog opened for payment processing

---

## 4. ORDER EDIT (Deposit Change)

### Business Rule
**Only accounting impact if deposit amount changes.**

### Scenario A: Deposit Increase
```
Original deposit: R500
New deposit: R700
Additional payment: R200
```

#### Accounting Entries
| Account                | Debit  | Credit |
|------------------------|--------|--------|
| Cash on Hand / Bank    | R200   |        |
| Customer Deposits      |        | R200   |

### Scenario B: Deposit Decrease
```
Original deposit: R500
New deposit: R300
Refund to customer: R200
```

#### Accounting Entries
| Account                | Debit  | Credit |
|------------------------|--------|--------|
| Customer Deposits      | R200   |        |
| Cash on Hand / Bank    |        | R200   |

### Key Points
- ✅ Only record if deposit amount changes
- ✅ Increase = collect more cash, increase liability
- ✅ Decrease = refund cash, decrease liability
- ❌ NO revenue impact (still a liability)

---

## 5. CHART OF ACCOUNTS SETUP

### Required GL Accounts

#### Assets
- **Cash on Hand** (1010) - Cash drawer, petty cash
- **Bank Account** (1020) - Business bank account
- **Card Terminal Clearing** (1030) - Card payments in transit

#### Liabilities
- **Customer Deposits** (2010) - Deposits for pending orders
- **VAT Payable** (2020) - VAT collected from sales

#### Revenue
- **Sales Revenue** (4010) - Main sales revenue
- **Cancellation Fee Revenue** (4020) - Revenue from cancelled orders

### SQL Setup
```sql
-- Ensure these accounts exist in ChartOfAccounts table
INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID)
VALUES 
('1010', 'Cash on Hand', 'Asset', NULL),
('1020', 'Bank Account', 'Asset', NULL),
('2010', 'Customer Deposits', 'Liability', NULL),
('2020', 'VAT Payable', 'Liability', NULL),
('4010', 'Sales Revenue', 'Revenue', NULL),
('4020', 'Cancellation Fee Revenue', 'Revenue', NULL)
```

---

## 6. VERIFICATION & RECONCILIATION

### Daily Reconciliation Checks

#### 1. Customer Deposits Balance
```sql
-- Should equal total deposits for pending orders
SELECT SUM(CreditAmount) - SUM(DebitAmount) AS CustomerDepositsBalance
FROM GeneralLedger
WHERE AccountID = (SELECT AccountID FROM ChartOfAccounts WHERE AccountName = 'Customer Deposits')
```

#### 2. Pending Orders Total
```sql
-- Should match Customer Deposits balance
SELECT SUM(DepositAmount) AS PendingDeposits
FROM POS_CustomOrders o
INNER JOIN Demo_Sales s ON o.OrderNumber = s.InvoiceNumber
WHERE o.OrderStatus IN ('New', 'Ready')
AND s.SaleType = 'OrderDeposit'
```

#### 3. Revenue Recognition
```sql
-- Only completed orders should show as revenue
SELECT 
    SUM(CASE WHEN SaleType = 'OrderCollection' THEN TotalAmount ELSE 0 END) AS CollectionRevenue,
    SUM(CASE WHEN SaleType = 'CancellationFee' THEN TotalAmount ELSE 0 END) AS CancellationRevenue
FROM Demo_Sales
WHERE SaleDate = CAST(GETDATE() AS DATE)
```

---

## 7. REPORTING

### Financial Statements Impact

#### Balance Sheet
- **Assets:** Cash/Bank increases with deposits and collections
- **Liabilities:** Customer Deposits shows pending order obligations
- **Equity:** Retained earnings only increase when orders complete

#### Income Statement
- **Revenue:** Only from completed orders and cancellation fees
- **Not Revenue:** Deposits (these are liabilities)

#### Cash Flow Statement
- **Operating Activities:** 
  - Cash from deposits (increase in liability)
  - Cash from collections (revenue + decrease in liability)
  - Cash refunds (decrease in liability)

---

## 8. AUDIT TRAIL

### Every Transaction Must Have
1. ✅ Reference number (Invoice/Order number)
2. ✅ Description (clear purpose)
3. ✅ Date/Time stamp
4. ✅ User ID (who processed)
5. ✅ Branch ID (where processed)
6. ✅ Balanced debits and credits

### Transaction Logging
```sql
-- All GL postings logged in GeneralLedger table
SELECT 
    gl.TransactionDate,
    coa.AccountName,
    gl.DebitAmount,
    gl.CreditAmount,
    gl.Reference,
    gl.Description,
    u.Username AS ProcessedBy
FROM GeneralLedger gl
INNER JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID
INNER JOIN Users u ON gl.CreatedBy = u.UserID
WHERE gl.Reference LIKE 'O-%' -- Order-related transactions
ORDER BY gl.TransactionDate DESC
```

---

## 9. IMPLEMENTATION CHECKLIST

- [x] RefundTenderDialog created for refund processing
- [x] CancelOrderForm updated with GL posting
- [x] PostToGeneralLedger helper method implemented
- [x] Double-entry accounting for cancellation fee
- [x] Double-entry accounting for refunds
- [ ] Verify ChartOfAccounts table has required accounts
- [ ] Test cancellation with Cash refund
- [ ] Test cancellation with Card refund
- [ ] Test cancellation with EFT refund
- [ ] Verify GL balances after cancellation
- [ ] Ensure order creation posts to Customer Deposits
- [ ] Ensure order completion posts to Sales Revenue
- [ ] Create reconciliation reports

---

## 10. COMMON MISTAKES TO AVOID

❌ **DON'T** record deposits as sales revenue
❌ **DON'T** skip GL postings for any transaction
❌ **DON'T** allow unbalanced entries (debits must equal credits)
❌ **DON'T** process refunds without tender dialog
❌ **DON'T** recognize revenue before order completion

✅ **DO** treat deposits as liabilities
✅ **DO** post every transaction to GL
✅ **DO** ensure debits = credits for every transaction
✅ **DO** use tender dialog for all refunds
✅ **DO** recognize revenue only on completion

---

## Summary

The order system now implements proper **accrual accounting** with:
- Deposits recorded as liabilities (not revenue)
- Revenue recognized only when earned (order completion)
- Cancellation fees properly recorded as revenue
- Refunds processed through tender dialog
- Complete double-entry GL postings for audit trail
- Proper balance sheet and income statement impact

This ensures compliance with accounting standards and provides accurate financial reporting.
