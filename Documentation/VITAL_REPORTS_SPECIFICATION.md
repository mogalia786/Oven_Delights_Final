# 📊 VITAL MANAGEMENT REPORTS
## Essential Reports for Educated Business Decisions

**Date:** 2025-10-04 05:40  
**Purpose:** Define all critical reports needed for business management

---

## 🎯 REPORT CATEGORIES

### **1. FINANCIAL STATEMENTS** (Statutory)

#### **1.1 Income Statement (Profit & Loss)**
**Status:** ✅ EXISTS (IncomeStatementForm.vb)  
**Purpose:** Show profitability over period  
**Key Metrics:**
- Revenue (by category)
- Cost of Goods Sold
- Gross Profit
- Operating Expenses
- Net Profit
- Profit Margin %

**Filters:** Date Range, Branch, Comparison Period

---

#### **1.2 Balance Sheet**
**Status:** ✅ EXISTS (BalanceSheetForm.vb)  
**Purpose:** Financial position at point in time  
**Key Metrics:**
- Assets (Current, Fixed)
- Liabilities (Current, Long-term)
- Equity
- Working Capital
- Current Ratio

**Filters:** As At Date, Branch

---

#### **1.3 Cash Flow Statement** ⭐ CREATE
**Status:** ❌ MISSING  
**Purpose:** Track cash movement  
**Sections:**
- Operating Activities
- Investing Activities
- Financing Activities
- Net Cash Flow
- Opening/Closing Cash Balance

**Filters:** Date Range, Branch

---

#### **1.4 Trial Balance** ⭐ CREATE
**Status:** ❌ MISSING  
**Purpose:** Verify ledger accuracy  
**Columns:**
- Account Code
- Account Name
- Debit Balance
- Credit Balance
- Variance (should be 0)

**Filters:** As At Date, Branch, Account Range

---

### **2. ACCOUNTS RECEIVABLE (Debtors)**

#### **2.1 Aged Debtors Report** ⭐ CREATE
**Status:** ❌ MISSING  
**Purpose:** Track outstanding customer payments  
**Aging Buckets:**
- Current (0-30 days)
- 30-60 days
- 60-90 days
- 90+ days (overdue)

**Key Metrics:**
- Total Outstanding
- Average Days Outstanding
- Bad Debt Provision

**Filters:** As At Date, Branch, Customer

---

#### **2.2 Customer Statement**
**Status:** ⚠️ PARTIAL  
**Purpose:** Customer account history  
**Shows:**
- Opening Balance
- Invoices
- Payments
- Credits
- Closing Balance

**Filters:** Customer, Date Range

---

### **3. ACCOUNTS PAYABLE (Creditors)**

#### **3.1 Aged Creditors Report** ⭐ CREATE
**Status:** ❌ MISSING  
**Purpose:** Track supplier payments due  
**Aging Buckets:**
- Current (0-30 days)
- 30-60 days
- 60-90 days
- 90+ days

**Key Metrics:**
- Total Payable
- Payment Due This Week
- Payment Due This Month
- Overdue Amount

**Filters:** As At Date, Branch, Supplier

---

#### **3.2 Supplier Statement**
**Status:** ✅ EXISTS (SupplierLedgerForm.vb)  
**Purpose:** Supplier account history  
**Shows:**
- Purchase Orders
- Invoices
- Payments
- Credits
- Balance Due

---

### **4. CASH MANAGEMENT**

#### **4.1 Cash Book Report** ⭐ CREATE
**Status:** ❌ MISSING  
**Purpose:** Daily cash receipts & payments  
**Sections:**
- Receipts (by category)
- Payments (by category)
- Net Cash Movement
- Opening/Closing Balance

**Filters:** Date Range, Branch, Payment Method

---

#### **4.2 Bank Reconciliation Report** ⭐ CREATE
**Status:** ❌ MISSING  
**Purpose:** Match bank statement to cash book  
**Shows:**
- Cash Book Balance
- Bank Statement Balance
- Outstanding Deposits
- Outstanding Cheques
- Reconciled Balance
- Variance

**Filters:** Bank Account, As At Date

---

#### **4.3 Payment Due Report** ⭐ CREATE
**Status:** ⚠️ PARTIAL (PaymentScheduleForm exists)  
**Purpose:** Upcoming payments schedule  
**Shows:**
- Supplier Invoices Due
- Expense Payments Due (rent, utilities)
- Payroll Due
- Total Cash Required

**Filters:** Due Date Range, Branch

---

### **5. SALES ANALYSIS**

#### **5.1 Sales by Product** ⭐ CREATE
**Status:** ❌ MISSING  
**Purpose:** Product performance analysis  
**Key Metrics:**
- Units Sold
- Revenue
- Cost of Sales
- Gross Profit
- Profit Margin %
- Market Share %

**Filters:** Date Range, Branch, Category, Product

---

#### **5.2 Sales by Customer** ⭐ CREATE
**Status:** ❌ MISSING  
**Purpose:** Customer profitability  
**Key Metrics:**
- Total Sales
- Number of Transactions
- Average Transaction Value
- Gross Profit
- Customer Lifetime Value

**Filters:** Date Range, Branch, Customer

---

#### **5.3 Sales by Branch** ⭐ CREATE
**Status:** ❌ MISSING  
**Purpose:** Branch performance comparison  
**Key Metrics:**
- Revenue
- Transactions
- Average Sale
- Top Products
- Growth %

**Filters:** Date Range, Comparison Period

---

#### **5.4 Sales by Period (Trend)** ⭐ CREATE
**Status:** ❌ MISSING  
**Purpose:** Identify sales trends  
**Views:**
- Daily
- Weekly
- Monthly
- Quarterly
- Year-over-Year

**Chart:** Line graph showing trend

---

### **6. PURCHASE ANALYSIS**

#### **6.1 Purchase by Supplier** ⭐ CREATE
**Status:** ❌ MISSING  
**Purpose:** Supplier spend analysis  
**Key Metrics:**
- Total Purchases
- Number of Orders
- Average Order Value
- Payment Terms Compliance
- Discount Utilization

**Filters:** Date Range, Branch, Supplier

---

#### **6.2 Purchase by Product** ⭐ CREATE
**Status:** ❌ MISSING  
**Purpose:** Product sourcing analysis  
**Key Metrics:**
- Quantity Purchased
- Total Cost
- Average Unit Cost
- Price Variance
- Supplier Count

**Filters:** Date Range, Branch, Product

---

### **7. INVENTORY REPORTS**

#### **7.1 Stock Valuation Report** ⭐ CREATE
**Status:** ⚠️ PARTIAL (Stock reports exist)  
**Purpose:** Inventory value by location  
**Shows:**
- Stockroom Inventory Value
- Manufacturing WIP Value
- Retail Stock Value
- Total Inventory Value

**Filters:** As At Date, Branch, Category

---

#### **7.2 Stock Movement Report**
**Status:** ✅ EXISTS (StockMovementReportForm.vb - FIXED)  
**Purpose:** Track stock in/out  
**Shows:**
- Receipts
- Issues
- Transfers
- Adjustments
- Net Movement

---

#### **7.3 Slow Moving Stock** ⭐ CREATE
**Status:** ❌ MISSING  
**Purpose:** Identify dead stock  
**Key Metrics:**
- Days Since Last Sale
- Quantity on Hand
- Value
- Recommended Action (discount/write-off)

**Filters:** Days Threshold, Branch, Category

---

#### **7.4 Stock Shortage Report** ⭐ CREATE
**Status:** ❌ MISSING  
**Purpose:** Items below reorder level  
**Shows:**
- Product
- Current Stock
- Reorder Level
- Shortage Quantity
- Suggested PO Quantity

**Filters:** Branch, Category

---

### **8. PAYROLL REPORTS**

#### **8.1 Payroll Summary** ⭐ CREATE
**Status:** ⚠️ PARTIAL (PayrollJournalForm exists)  
**Purpose:** Payroll run summary  
**Shows:**
- Gross Pay
- Deductions (Tax, UIF)
- Net Pay
- Employer Costs
- Payment Method Breakdown

**Filters:** Pay Period, Branch

---

#### **8.2 Employee Earnings Statement** ⭐ CREATE
**Status:** ❌ MISSING  
**Purpose:** Individual payslip  
**Shows:**
- Hours Worked
- Hourly Rate
- Gross Pay
- Deductions
- Net Pay
- Year-to-Date Totals

**Filters:** Employee, Pay Period

---

#### **8.3 Timesheet Report** ⭐ CREATE
**Status:** ❌ MISSING  
**Purpose:** Hours worked analysis  
**Shows:**
- Employee
- Regular Hours
- Overtime Hours
- Total Hours
- Approval Status

**Filters:** Date Range, Branch, Employee

---

### **9. MANAGEMENT DASHBOARDS**

#### **9.1 Executive Dashboard** ⭐ CREATE
**Status:** ❌ MISSING  
**Purpose:** High-level KPIs at a glance  
**Widgets:**
- Revenue (Today, MTD, YTD)
- Profit Margin %
- Cash Balance
- Outstanding Debtors
- Outstanding Creditors
- Stock Value
- Top 5 Products
- Top 5 Customers

**Filters:** Branch, Date Range

---

#### **9.2 Branch Performance Dashboard** ⭐ CREATE
**Status:** ❌ MISSING  
**Purpose:** Compare branch performance  
**Metrics:**
- Revenue by Branch
- Profit by Branch
- Transactions by Branch
- Average Sale by Branch
- Stock Turn by Branch

**Chart:** Bar chart comparison

---

### **10. TAX & COMPLIANCE**

#### **10.1 VAT Return Report**
**Status:** ⚠️ PARTIAL (SARSReportingForm exists)  
**Purpose:** VAT calculation for SARS  
**Shows:**
- Output VAT (Sales)
- Input VAT (Purchases)
- VAT Payable/Refundable

**Filters:** Tax Period

---

#### **10.2 PAYE Report** ⭐ CREATE
**Status:** ❌ MISSING  
**Purpose:** Employee tax for SARS  
**Shows:**
- Employee Tax Deducted
- UIF Deducted
- Total PAYE Payable

**Filters:** Tax Period

---

## 📋 IMPLEMENTATION PRIORITY

### **CRITICAL (Must Have for 10 AM):**
1. ✅ Cash Book Report
2. ✅ Trial Balance
3. ✅ Aged Debtors
4. ✅ Aged Creditors
5. ✅ Cash Flow Statement
6. ✅ Bank Reconciliation
7. ✅ Payment Due Report
8. ✅ Payroll Summary

### **HIGH (Add Soon):**
9. Sales Analysis Reports (by product, customer, branch)
10. Purchase Analysis Reports
11. Executive Dashboard
12. Stock Valuation
13. Timesheet Report

### **MEDIUM (Nice to Have):**
14. Slow Moving Stock
15. Stock Shortage
16. Employee Earnings Statement
17. Branch Performance Dashboard

---

## 🎯 REPORT DESIGN STANDARDS

**All Reports Must Have:**
- ✅ Date range filter
- ✅ Branch filter (multi-branch support)
- ✅ Export to Excel
- ✅ Print preview
- ✅ Email capability
- ✅ Drill-down to details
- ✅ Comparison to prior period
- ✅ Visual charts where applicable

**Report Layout:**
- Header: Company name, branch, report title, date range
- Filters: Show selected filters
- Summary: Key totals at top
- Detail: Detailed data grid
- Footer: Report generated date/time, user

---

## 📊 REPORT QUERIES (SQL)

### **Trial Balance:**
```sql
SELECT 
    a.AccountCode,
    a.AccountName,
    SUM(CASE WHEN jd.Debit > 0 THEN jd.Debit ELSE 0 END) AS TotalDebit,
    SUM(CASE WHEN jd.Credit > 0 THEN jd.Credit ELSE 0 END) AS TotalCredit,
    SUM(jd.Debit - jd.Credit) AS Balance
FROM Accounts a
LEFT JOIN JournalDetails jd ON a.AccountID = jd.AccountID
LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
WHERE jh.PostingDate <= @AsAtDate
AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
GROUP BY a.AccountCode, a.AccountName
ORDER BY a.AccountCode
```

### **Aged Debtors:**
```sql
SELECT 
    c.CustomerName,
    SUM(CASE WHEN DATEDIFF(day, i.InvoiceDate, @AsAtDate) <= 30 THEN i.AmountOutstanding ELSE 0 END) AS Current,
    SUM(CASE WHEN DATEDIFF(day, i.InvoiceDate, @AsAtDate) BETWEEN 31 AND 60 THEN i.AmountOutstanding ELSE 0 END) AS Days30_60,
    SUM(CASE WHEN DATEDIFF(day, i.InvoiceDate, @AsAtDate) BETWEEN 61 AND 90 THEN i.AmountOutstanding ELSE 0 END) AS Days60_90,
    SUM(CASE WHEN DATEDIFF(day, i.InvoiceDate, @AsAtDate) > 90 THEN i.AmountOutstanding ELSE 0 END) AS Days90Plus,
    SUM(i.AmountOutstanding) AS TotalOutstanding
FROM Customers c
INNER JOIN Invoices i ON c.CustomerID = i.CustomerID
WHERE i.Status <> 'Paid'
AND (@BranchID IS NULL OR i.BranchID = @BranchID)
GROUP BY c.CustomerName
ORDER BY TotalOutstanding DESC
```

---

**Status:** Specification complete  
**Next:** Create report forms
