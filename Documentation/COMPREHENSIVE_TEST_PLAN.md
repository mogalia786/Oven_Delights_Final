# 🧪 COMPREHENSIVE TEST PLAN
## Complete System Testing Before POS Development

**Date:** 2025-10-06 10:35  
**Purpose:** Test all fixes and new features before starting POS

---

## 📋 PRE-TEST SETUP

### **Step 1: Run SQL Scripts** (5 minutes)

**Option A: Run Single Consolidated Script** ⭐ RECOMMENDED
```sql
-- File: RUN_ALL_FIXES.sql
-- This combines everything in one script
-- Run time: ~60 seconds
```

**Option B: Run Individual Scripts**
1. COMPLETE_OVERNIGHT_FIXES.sql (~30 sec)
2. TEST_DATA_5_PRODUCTS.sql (~10 sec)
3. ACCOUNTING_COMPLETE_SYSTEM.sql (~20 sec)

**Verification Query:**
```sql
-- Check all tables exist
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME IN (
    'InterBranchTransfers', 'GoodsReceivedNotes', 'Suppliers', 'Products',
    'CreditNotes', 'SupplierInvoices', 'ExpenseCategories', 'IncomeCategories',
    'CashBook', 'Employees', 'Timesheets', 'BankAccounts'
)
ORDER BY TABLE_NAME;
```
**Expected:** 12 tables

---

## 🧪 TEST SUITE 1: STOCKROOM MODULE

### **Test 1.1: Suppliers Form**
**Path:** Stockroom → Suppliers  
**Expected:** ✅ Loads without "Address" error  
**Test:**
1. Open Suppliers form
2. Click "Add New Supplier"
3. Fill in: Name, Contact, Email, Phone, Address, City, Bank Details
4. Save
5. Verify supplier appears in grid

**Pass Criteria:**
- Form loads without errors
- All address fields visible
- Bank details fields visible
- Can save successfully

---

### **Test 1.2: Inter-Branch Transfer**
**Path:** Stockroom → Stock Transfer  
**Expected:** ✅ Loads without "CreatedDate" error  
**Test:**
1. Open Inter-Branch Transfer form
2. Select From Branch
3. Select To Branch
4. Add product
5. Enter quantity
6. Save transfer

**Pass Criteria:**
- Form loads without errors
- Can select branches
- Can save transfer
- Both branches updated

---

### **Test 1.3: GRV Management**
**Path:** Stockroom → GRV Management  
**Expected:** ✅ Loads without "BranchID" error  
**Test:**
1. Open GRV Management
2. Filter by branch
3. View existing GRVs
4. Create new GRV

**Pass Criteria:**
- Form loads without errors
- Branch filter works
- Can view GRVs
- Can create new GRV

---

### **Test 1.4: Stock Movement Report**
**Path:** Reports → Stock Movement Report  
**Expected:** ✅ Loads without syntax error  
**Test:**
1. Open Stock Movement Report
2. Select date range
3. Generate report
4. Verify movements shown

**Pass Criteria:**
- Form loads without errors
- Date filters work
- Report generates
- Shows receipts, issues, transfers

---

### **Test 1.5: Products on Shelf**
**Path:** Retail → Products  
**Expected:** ✅ 5 external products visible  
**Test:**
1. Open Products form
2. Filter by ItemType = 'External'
3. Verify 5 products:
   - Coca-Cola 330ml (R12.00)
   - Coca-Cola 500ml (R18.00)
   - White Bread (R25.00)
   - Brown Bread (R28.00)
   - Lays Chips (R15.00)

**Pass Criteria:**
- All 5 products visible
- Each has barcode
- Each has price
- Each has stock (100 units)

---

## 🧪 TEST SUITE 2: ACCOUNTING MODULE

### **Test 2.1: Expense Categories**
**Path:** Query Database  
**Expected:** ✅ 50+ SAGE categories  
**Test:**
```sql
SELECT CategoryCode, CategoryName, AccountNumber 
FROM ExpenseCategories 
WHERE IsActive = 1
ORDER BY AccountNumber;
```

**Pass Criteria:**
- At least 10 categories returned
- Categories have account numbers (5000-5799)
- Includes: RENT, UTILITIES, WAGES, ELECTRICITY, etc.

---

### **Test 2.2: Income Categories**
**Path:** Query Database  
**Expected:** ✅ 15+ SAGE categories  
**Test:**
```sql
SELECT CategoryCode, CategoryName, AccountNumber 
FROM IncomeCategories 
WHERE IsActive = 1
ORDER BY AccountNumber;
```

**Pass Criteria:**
- At least 5 categories returned
- Categories have account numbers (4000-4399)
- Includes: RETAIL_SALES, WHOLESALE_SALES, SERVICE_REVENUE, etc.

---

### **Test 2.3: Cash Book Journal** ⭐ NEW FORM
**Path:** Accounting → Cash Book Journal  
**Expected:** ✅ New form loads and works  
**Test:**
1. Open Cash Book Journal form
2. Click "+ Receipt"
3. Enter: Date, Description, Amount, Payment Method
4. Save receipt
5. Click "- Payment"
6. Enter payment details
7. Save payment
8. Verify both appear in grid
9. Check summary totals

**Pass Criteria:**
- Form loads without errors
- Can add receipts (green background)
- Can add payments (red background)
- Summary shows: Total Receipts, Total Payments, Net Cash Flow
- Transactions filtered by branch
- 3-column format: Cash, Bank, Discount

---

### **Test 2.4: Timesheet Entry** ⭐ NEW FORM
**Path:** Accounting → Timesheet Entry  
**Expected:** ✅ New form loads and works  
**Test:**
1. Open Timesheet Entry form
2. Select employee (hourly)
3. Click "CLOCK IN"
4. Wait 1 minute
5. Click "CLOCK OUT"
6. Verify hours calculated
7. Click "Add Manual Entry"
8. Enter: Clock In, Clock Out, Hours
9. Save manual entry
10. Check summary totals

**Pass Criteria:**
- Form loads without errors
- Can clock in/out
- Hours calculated automatically
- Can add manual entries
- Summary shows: Total Hours, Overtime, Estimated Wages
- Status updates (Clocked In/Out)

---

### **Test 2.5: Payroll Entry**
**Path:** Payroll → Payroll Entry  
**Expected:** ✅ Existing form works  
**Test:**
1. Open Payroll Entry form
2. Select employee
3. Select branch
4. Enter: Base Pay, Allowances, Overtime, Deductions
5. Verify Gross and Net calculated
6. Save entry

**Pass Criteria:**
- Form loads without errors
- Branch dropdown works
- Employee dropdown works
- Calculations correct
- Can save entry

---

### **Test 2.6: Supplier Ledger**
**Path:** Accounting → Supplier Ledger  
**Expected:** ✅ Existing form works  
**Test:**
1. Open Supplier Ledger
2. Select supplier
3. Select date range
4. View transactions
5. Check balance

**Pass Criteria:**
- Form loads without errors
- Supplier dropdown works
- Transactions shown
- Balance calculated
- BranchID filtering works

---

## 🧪 TEST SUITE 3: REPORTS

### **Test 3.1: Income Statement**
**Path:** Reports → Income Statement  
**Expected:** ✅ Existing report works  
**Test:**
1. Open Income Statement
2. Select date range
3. Select branch
4. Generate report
5. Verify sections: Revenue, COGS, Expenses, Net Profit

**Pass Criteria:**
- Report loads without errors
- Branch filter works
- Shows revenue categories
- Shows expense categories
- Calculates net profit

---

### **Test 3.2: Balance Sheet**
**Path:** Reports → Balance Sheet  
**Expected:** ✅ Existing report works  
**Test:**
1. Open Balance Sheet
2. Select as-at date
3. Select branch
4. Generate report
5. Verify sections: Assets, Liabilities, Equity

**Pass Criteria:**
- Report loads without errors
- Branch filter works
- Shows assets
- Shows liabilities
- Shows equity
- Balances (Assets = Liabilities + Equity)

---

### **Test 3.3: Stock Reports**
**Path:** Reports → Stock Reports  
**Expected:** ✅ 3 existing reports work  
**Test:**
1. Stockroom Stock Report
2. Manufacturing Stock Report
3. Retail Products Stock Report

**Pass Criteria:**
- All 3 reports load
- Show stock levels
- Branch filtering works
- Export works

---

## 🧪 TEST SUITE 4: MONEY TRAIL INTEGRITY

### **Test 4.1: Cash Book Balance**
**Query:**
```sql
SELECT 
    b.BranchName,
    SUM(CASE WHEN cb.TransactionType = 'Receipt' THEN cb.Amount ELSE 0 END) AS TotalReceipts,
    SUM(CASE WHEN cb.TransactionType = 'Payment' THEN cb.Amount ELSE 0 END) AS TotalPayments,
    SUM(CASE WHEN cb.TransactionType = 'Receipt' THEN cb.Amount ELSE -cb.Amount END) AS NetCashFlow
FROM CashBook cb
LEFT JOIN Branches b ON cb.BranchID = b.BranchID
GROUP BY b.BranchName;
```

**Pass Criteria:**
- Query runs without errors
- Shows receipts and payments by branch
- Net cash flow calculated correctly

---

### **Test 4.2: Payroll to Wages Ledger**
**Concept Test:**
- When payroll run completed
- Wages expense should match payroll total
- Journal entry created: DR Wages Expense, CR Cash/Bank

**Pass Criteria:**
- Payroll amounts match ledger
- Double-entry maintained

---

### **Test 4.3: BranchID Tracking**
**Query:**
```sql
-- Check all financial tables have BranchID
SELECT 
    'CashBook' AS TableName, 
    COUNT(*) AS RecordsWithBranch,
    COUNT(CASE WHEN BranchID IS NULL THEN 1 END) AS RecordsWithoutBranch
FROM CashBook
UNION ALL
SELECT 'Timesheets', COUNT(*), COUNT(CASE WHEN e.BranchID IS NULL THEN 1 END)
FROM Timesheets t
INNER JOIN Employees e ON t.EmployeeID = e.EmployeeID;
```

**Pass Criteria:**
- All records have BranchID
- No NULL BranchIDs in financial transactions

---

## 📊 TEST RESULTS TEMPLATE

### **Test Execution Log**

| Test ID | Test Name | Status | Notes | Tester | Date |
|---------|-----------|--------|-------|--------|------|
| 1.1 | Suppliers Form | ⬜ | | | |
| 1.2 | Inter-Branch Transfer | ⬜ | | | |
| 1.3 | GRV Management | ⬜ | | | |
| 1.4 | Stock Movement Report | ⬜ | | | |
| 1.5 | Products on Shelf | ⬜ | | | |
| 2.1 | Expense Categories | ⬜ | | | |
| 2.2 | Income Categories | ⬜ | | | |
| 2.3 | Cash Book Journal | ⬜ | | | |
| 2.4 | Timesheet Entry | ⬜ | | | |
| 2.5 | Payroll Entry | ⬜ | | | |
| 2.6 | Supplier Ledger | ⬜ | | | |
| 3.1 | Income Statement | ⬜ | | | |
| 3.2 | Balance Sheet | ⬜ | | | |
| 3.3 | Stock Reports | ⬜ | | | |
| 4.1 | Cash Book Balance | ⬜ | | | |
| 4.2 | Payroll to Wages | ⬜ | | | |
| 4.3 | BranchID Tracking | ⬜ | | | |

**Legend:** ✅ Pass | ❌ Fail | ⚠️ Partial | ⬜ Not Tested

---

## 🚨 CRITICAL ISSUES TO WATCH

### **High Priority:**
1. **Database Connection** - Verify connection string correct
2. **BranchID Null** - Check all transactions have BranchID
3. **Control Name Mismatches** - Forms load without errors
4. **Money Trail** - Double-entry maintained

### **Medium Priority:**
5. **Theme Issues** - ComboBox backgrounds
6. **Performance** - Forms load quickly
7. **Data Validation** - Required fields enforced

---

## 📝 BUG REPORT TEMPLATE

**Bug ID:** [Auto-increment]  
**Severity:** Critical / High / Medium / Low  
**Module:** Stockroom / Accounting / Reports / Other  
**Form/Feature:** [Name]  
**Description:** [What happened]  
**Expected:** [What should happen]  
**Steps to Reproduce:**
1. 
2. 
3. 

**Error Message:** [If any]  
**Screenshot:** [If applicable]  
**Workaround:** [If known]  
**Status:** Open / In Progress / Fixed / Closed

---

## ✅ SIGN-OFF CRITERIA

**System is ready for POS development when:**

- ✅ All SQL scripts run successfully
- ✅ All Stockroom tests pass (5/5)
- ✅ All Accounting tests pass (6/6)
- ✅ All Report tests pass (3/3)
- ✅ Money trail integrity verified (3/3)
- ✅ No critical bugs
- ✅ 5 products ready for POS
- ✅ Cash Book Journal working
- ✅ Timesheet Entry working

**Total Tests:** 17  
**Must Pass:** 17 (100%)

---

## 🎯 NEXT STEPS AFTER TESTING

### **If All Tests Pass:**
1. ✅ Document test results
2. ✅ Create POS as new application
3. ✅ Begin POS development
4. ✅ Prepare for tomorrow's presentation

### **If Tests Fail:**
1. ❌ Document failures
2. 🔧 Fix critical issues
3. 🔄 Re-test
4. ✅ Proceed when stable

---

**Testing Time Estimate:** 45-60 minutes  
**Recommended:** Test in order (Suite 1 → 2 → 3 → 4)

**Good luck with testing!** 🚀
