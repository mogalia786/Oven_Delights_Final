# GL INTEGRATION QUICK REFERENCE GUIDE
## Daily Operations & Account Posting Reference

**For:** All ERP Users  
**Date:** January 28, 2026

---

## 📊 CHART OF ACCOUNTS - QUICK REFERENCE

### Assets (1xxx)
| Code | Account Name | Normal Balance | Used For |
|------|--------------|----------------|----------|
| 1010 | Bank - Current Account | Debit | Card payments, cleared EFTs, bank deposits |
| 1030 | Cash on Hand | Debit | Cash sales (until deposited) |
| 1050 | Debtors - Uncleared EFT | Debit | EFT payments (until cleared) |
| 1220 | Inventory - Retail Stock | Debit | Stock value |
| 1600 | Inter-Branch Debtors | Debit | Amounts owed by other branches |
| 1610 | Inter-Branch Creditors | Credit | Amounts owed to other branches |

### Liabilities (2xxx)
| Code | Account Name | Normal Balance | Used For |
|------|--------------|----------------|----------|
| 2010 | Customer Deposits | Credit | POS order deposits ONLY |
| 2020 | VAT Output | Credit | VAT collected on sales |
| 2021 | VAT Input | Debit | VAT paid on purchases |
| 2030 | Accounts Payable | Credit | Supplier invoices ONLY |

### Revenue (4xxx)
| Code | Account Name | Normal Balance | Used For |
|------|--------------|----------------|----------|
| 4010 | Sales Revenue - Retail | Credit | Sales income |
| 4020 | Sales Returns | Debit | Refunds |

### Expenses (5xxx & 6xxx)
| Code | Account Name | Normal Balance | Used For |
|------|--------------|----------------|----------|
| 5010 | Cost of Goods Sold | Debit | Cost of items sold |
| 5020 | Direct Labor | Debit | Manufacturing labor |
| 6010 | Rent Expense | Debit | Rent payments |
| 6020 | Utilities Expense | Debit | Electricity, water, gas |
| 6030 | Telephone & Internet | Debit | Communication costs |
| 6040 | Office Supplies | Debit | Stationery, supplies |
| 6050 | Inventory Variance | Debit/Credit | Stock adjustments |
| 6060 | Wastage Expense | Debit | Damaged/expired stock |
| 6070 | Manufacturing Overhead | Debit | Production overheads |

---

## 💰 POS TRANSACTIONS

### Cash Sale
**When:** Customer pays cash  
**GL Posting:**
```
DR 1030 Cash on Hand          R100.00
CR 4010 Sales Revenue                  R100.00
DR 5010 Cost of Goods Sold     R60.00
CR 1220 Inventory                       R60.00
```
**Journal Prefix:** POS-

---

### Card Sale
**When:** Customer pays by card  
**GL Posting:**
```
DR 1010 Bank                  R100.00
CR 4010 Sales Revenue                  R100.00
DR 5010 Cost of Goods Sold     R60.00
CR 1220 Inventory                       R60.00
```
**Journal Prefix:** POS-

---

### EFT Sale
**When:** Customer pays by EFT  
**GL Posting:**
```
DR 1050 Debtors - Uncleared EFT  R100.00
CR 4010 Sales Revenue                    R100.00
DR 5010 Cost of Goods Sold        R60.00
CR 1220 Inventory                         R60.00
```
**Journal Prefix:** POS-  
**Note:** EFT stays in 1050 until cleared

---

### Order Deposit
**When:** Customer places order and pays deposit  
**GL Posting:**
```
DR 1030/1010/1050 (payment method)  R50.00
CR 2010 Customer Deposits                   R50.00
```
**Journal Prefix:** POS-DEP-

---

### Order Collection
**When:** Customer collects order and pays balance  
**GL Posting:**
```
DR 1030/1010/1050 (payment method)  R50.00
DR 2010 Customer Deposits            R50.00
CR 4010 Sales Revenue                       R100.00
DR 5010 Cost of Goods Sold           R60.00
CR 1220 Inventory                            R60.00
```
**Journal Prefix:** POS-COL-

---

### Refund
**When:** Customer returns item  
**GL Posting:**
```
DR 4020 Sales Returns          R100.00
CR 1030/1010 (refund method)           R100.00
DR 1220 Inventory               R60.00
CR 5010 Cost of Goods Sold              R60.00
```
**Journal Prefix:** POS-REF-

---

### Cash Deposit to Bank
**When:** End of day - depositing cash  
**GL Posting:**
```
DR 1010 Bank                  R1,000.00
CR 1030 Cash on Hand                   R1,000.00
```
**Journal Prefix:** CASH-DEP-  
**Form:** Cashbook → Cash Deposit

---

### EFT Clearing
**When:** EFT reflects in bank statement  
**GL Posting:**
```
DR 1010 Bank                    R100.00
CR 1050 Debtors - Uncleared EFT         R100.00
```
**Journal Prefix:** EFTC-  
**Form:** Accounting → EFT Clearing

---

## 🧾 ACCOUNTS PAYABLE

### Adhoc Invoice
**When:** Receiving supplier invoice (no PO)  
**GL Posting:**
```
DR 60xx Expense Account       R10,000.00
DR 2021 VAT Input              R1,500.00
CR 2030 Accounts Payable               R11,500.00
```
**Journal Prefix:** AP-  
**Form:** Accounting → Adhoc Invoices

---

### Single Payment
**When:** Paying single supplier invoice  
**GL Posting:**
```
DR 2030 Accounts Payable      R11,500.00
CR 1010 Bank (EFT/Cheque)              R11,500.00
   OR
CR 1030 Cash on Hand (Cash)            R11,500.00
```
**Journal Prefix:** PAY-  
**Form:** Accounting → Supplier Payments

---

### Batch Payment
**When:** Paying multiple invoices via EFT  
**GL Posting (per invoice):**
```
DR 2030 Accounts Payable       R5,000.00
CR 1010 Bank                            R5,000.00
```
**Journal Prefix:** BP-  
**Form:** Accounting → Batch Payments

---

### Credit Note
**When:** Receiving credit from supplier  
**GL Posting:**
```
DR 2030 Accounts Payable       R2,875.00
CR 60xx Expense Account                 R2,500.00
CR 2021 VAT Input                         R375.00
```
**Journal Prefix:** CN-  
**Form:** Accounting → Credit Notes

---

## 📦 INVENTORY MANAGEMENT

### Stock Adjustment (Increase)
**When:** Found extra stock during count  
**GL Posting:**
```
DR 1220 Inventory              R500.00
CR 6050 Inventory Variance             R500.00
```
**Journal Prefix:** ADJ-  
**Form:** Inventory → Stock Adjustments

---

### Stock Adjustment (Decrease)
**When:** Missing stock during count  
**GL Posting:**
```
DR 6050 Inventory Variance     R500.00
CR 1220 Inventory                      R500.00
```
**Journal Prefix:** ADJ-  
**Form:** Inventory → Stock Adjustments

---

### Wastage
**When:** Damaged or expired stock  
**GL Posting:**
```
DR 6060 Wastage Expense        R300.00
CR 1220 Inventory                      R300.00
```
**Journal Prefix:** WST-  
**Form:** Inventory → Wastage

---

## 🏢 INTER-BRANCH TRANSFERS

### IBT Receipt
**When:** Receiving stock from another branch  
**GL Posting (Receiving Branch):**
```
DR 1220 Inventory              R1,000.00
CR 1610 Inter-Branch Creditors         R1,000.00
```
**Journal Prefix:** IBT-R-  
**Form:** IBT → Receive Delivery

---

### IBT Settlement
**When:** Paying for received stock  
**GL Posting (Paying Branch):**
```
DR 1610 Inter-Branch Creditors  R1,000.00
CR 1010 Bank                            R1,000.00
```
**GL Posting (Receiving Branch):**
```
DR 1010 Bank                    R1,000.00
CR 1600 Inter-Branch Debtors           R1,000.00
```
**Journal Prefix:** IBT-P- (Paying), IBT-S- (Receiving)  
**Form:** IBT → Inter-Branch Ledger

---

## 📈 DAILY REPORTS

### Daily Posting Report
**Purpose:** View all GL postings for the day  
**Access:** Accounting → Daily Posting Report  
**Shows:**
- All journal entries
- Summary by transaction type
- Double-entry verification
- Total Debits vs Total Credits

**Key Check:** Total Debits MUST equal Total Credits

---

### Trial Balance
**Purpose:** Verify accounting equation  
**Access:** Run SQL: `EXEC sp_GL_TrialBalance`  
**Shows:**
- All account balances
- Debit balances vs Credit balances
- Abnormal balances (if any)

**Key Check:** Total Debit Balances = Total Credit Balances

---

### Account Ledger
**Purpose:** View transactions for specific account  
**Access:** Run SQL: `EXEC sp_GL_AccountLedger @AccountCode = '1010'`  
**Shows:**
- Opening balance
- All transactions
- Running balance
- Closing balance

---

## 🚨 COMMON ISSUES & SOLUTIONS

### Issue: "Account not found or inactive"
**Solution:**
1. Check account exists: `SELECT * FROM ChartOfAccounts WHERE AccountCode = 'xxxx'`
2. If missing, contact administrator
3. If inactive, activate: `UPDATE ChartOfAccounts SET IsActive = 1 WHERE AccountCode = 'xxxx'`

---

### Issue: "Journal out of balance"
**Solution:**
1. Open Daily Posting Report
2. Go to "Double-Entry Verification" tab
3. Find unbalanced journal
4. Contact administrator with journal number

---

### Issue: "Trial balance doesn't balance"
**Solution:**
1. Run: `EXEC sp_GL_DailyPostingReport`
2. Check for unbalanced journals
3. Review recent transactions
4. Contact administrator

---

### Issue: "EFT not clearing"
**Solution:**
1. Check bank statement received
2. Open: Accounting → EFT Clearing
3. Find pending EFT
4. Click "Mark as Cleared"
5. Verify clearing date matches bank statement

---

## ✅ DAILY CHECKLIST

### For Cashiers (End of Day)
- [ ] Count cash in till
- [ ] Record cash deposit amount
- [ ] Navigate to: Cashbook → Cash Deposit
- [ ] Enter deposit amount
- [ ] Verify GL posting: DR Bank, CR Cash

---

### For AP Clerk (Daily)
- [ ] Capture new invoices
- [ ] Verify expense accounts selected correctly
- [ ] Process payments due today
- [ ] Import bank statement
- [ ] Clear reflected EFTs
- [ ] Verify AP balance matches supplier statements

---

### For Inventory Manager (Daily)
- [ ] Process stock adjustments
- [ ] Record wastage
- [ ] Verify inventory GL postings
- [ ] Check inventory balance matches physical count

---

### For Accountant (Daily)
- [ ] Open Daily Posting Report
- [ ] Verify Total Debits = Total Credits
- [ ] Check for unbalanced journals
- [ ] Review abnormal account balances
- [ ] Investigate discrepancies

---

### For Accountant (Month-End)
- [ ] Run trial balance
- [ ] Verify all EFTs cleared
- [ ] Reconcile bank accounts
- [ ] Review all expense accounts
- [ ] Generate financial statements
- [ ] Close accounting period

---

## 📞 SUPPORT CONTACTS

**System Administrator:** _________________  
**Accountant:** _________________  
**IT Support:** _________________

---

## 🔑 KEY PRINCIPLES

### Double-Entry Accounting
**Every transaction has TWO sides:**
- Debit (left side) = Credit (right side)
- Total Debits MUST equal Total Credits
- If unbalanced, system has error

---

### Normal Balances
**Assets & Expenses:** Debit balance (increase with debits)  
**Liabilities, Revenue & Equity:** Credit balance (increase with credits)

---

### Account Separation
**CRITICAL:**
- Account 2010 = Customer Deposits (POS orders) ONLY
- Account 2030 = Accounts Payable (Suppliers) ONLY
- NEVER mix these accounts

---

### EFT Workflow
1. **Payment made** → DR 1050 (Uncleared EFT)
2. **Bank statement received** → Check for EFT
3. **Mark as cleared** → DR 1010 (Bank), CR 1050 (Uncleared EFT)

---

## 📚 ADDITIONAL RESOURCES

- **Complete Deployment Guide:** `COMPLETE_DEPLOYMENT_GUIDE.md`
- **ERP Comprehensive Review:** `ERP_COMPREHENSIVE_REVIEW.md`
- **POS GL Implementation Guide:** `POS_GL_IMPLEMENTATION_GUIDE.md`

---

**Last Updated:** January 28, 2026  
**Version:** 1.0
