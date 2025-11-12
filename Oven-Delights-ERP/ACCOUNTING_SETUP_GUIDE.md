# ACCOUNTING SETUP GUIDE
## Complete Guide to Setting Up Chart of Accounts & Inventory Ledgers

---

## 📋 OVERVIEW

This guide walks you through setting up the complete accounting structure for Oven Delights ERP, including:
- ✅ Chart of Accounts (all GL accounts)
- ✅ Cash accounts (Cash on Hand, Petty Cash, Over/Short, Sundries)
- ✅ Inventory accounts (Stockroom, Manufacturing, Finished Goods, Raw Materials)
- ✅ Ledger links for automated posting

---

## 🚀 QUICK START (3 STEPS)

### **Step 1: Run SQL Scripts in Order**

Execute these scripts in **SQL Server Management Studio** or **Azure Data Studio**:

```sql
-- 1. Fix missing columns (if not done already)
SQL\ADD_MISSING_COLUMNS.sql

-- 2. Populate Chart of Accounts
SQL\POPULATE_CHART_OF_ACCOUNTS.sql

-- 3. Setup Inventory Ledgers
SQL\SETUP_INVENTORY_LEDGERS.sql
```

### **Step 2: Rebuild ERP Application**

```
Visual Studio → Build → Rebuild Solution
```

### **Step 3: Test in ERP**

1. Open ERP application
2. Go to **Accounting → Master Data → Chart of Accounts**
3. You should see all accounts populated!

---

## 📊 CHART OF ACCOUNTS STRUCTURE

### **1000-1999: ASSETS**

#### **1100-1199: Cash & Bank**
| Code | Account Name | Purpose |
|------|--------------|---------|
| 1100 | Cash on Hand | Physical cash in tills/registers |
| 1110 | Petty Cash | Small cash for minor expenses |
| 1120 | Cash Over/Short | Cash discrepancies/variances |
| 1130 | Sundries Cash | Miscellaneous cash transactions |
| 1200 | Bank - Current Account | Main operating bank account |
| 1210 | Bank - Savings Account | Savings/reserve funds |

#### **1300-1399: Accounts Receivable**
| Code | Account Name | Purpose |
|------|--------------|---------|
| 1300 | Accounts Receivable | Customer debts |
| 1310 | Debtors Control | Customer accounts control |
| 1320 | Inter-Branch Debtors | Branch-to-branch receivables |

#### **1400-1499: Inventory**
| Code | Account Name | Purpose |
|------|--------------|---------|
| **1400** | **Stockroom Inventory** | Raw materials + external products |
| **1410** | **Manufacturing Inventory (WIP)** | Work-in-progress materials |
| **1420** | **Finished Goods Inventory** | Completed products for sale |
| **1430** | **Raw Materials Inventory** | Ingredients for manufacturing |

#### **1500-1599: Fixed Assets**
| Code | Account Name | Purpose |
|------|--------------|---------|
| 1500 | Equipment & Machinery | Ovens, mixers, etc. |
| 1510 | Furniture & Fixtures | Store fixtures, displays |
| 1520 | Vehicles | Delivery vehicles |
| 1530 | Accumulated Depreciation | Asset depreciation |

---

### **2000-2999: LIABILITIES**

#### **2100-2199: Current Liabilities**
| Code | Account Name | Purpose |
|------|--------------|---------|
| 2100 | Accounts Payable | Supplier debts |
| 2110 | Creditors Control | Supplier accounts control |
| 2120 | Inter-Branch Creditors | Branch-to-branch payables |

#### **2200-2299: Tax Liabilities**
| Code | Account Name | Purpose |
|------|--------------|---------|
| 2200 | VAT Output | VAT collected on sales |
| 2210 | VAT Input | VAT paid on purchases |
| 2220 | PAYE Payable | Employee tax payable |
| 2230 | UIF Payable | Unemployment insurance |

---

### **3000-3999: EQUITY**

| Code | Account Name | Purpose |
|------|--------------|---------|
| 3000 | Owner's Equity | Owner's investment |
| 3100 | Retained Earnings | Accumulated profits |
| 3200 | Current Year Earnings | Current period profit/loss |

---

### **4000-4999: REVENUE**

| Code | Account Name | Purpose |
|------|--------------|---------|
| 4000 | Sales Revenue | Total sales |
| 4100 | Retail Sales | Walk-in sales |
| 4200 | Custom Order Sales | Special orders |
| 4300 | Cake Order Sales | Custom cakes |
| 4900 | Other Income | Miscellaneous income |

---

### **5000-5999: COST OF SALES**

| Code | Account Name | Purpose |
|------|--------------|---------|
| 5000 | Cost of Sales | Total COGS |
| 5100 | Cost of Goods Sold - Retail | Retail product costs |
| 5200 | Cost of Goods Sold - Manufacturing | Manufactured product costs |
| 5300 | Direct Materials | Raw material costs |
| 5400 | Direct Labor | Manufacturing labor |

---

### **6000-6999: OPERATING EXPENSES**

| Code | Account Name | Purpose |
|------|--------------|---------|
| 6000 | Salaries & Wages | Employee salaries |
| 6100 | Rent Expense | Store/facility rent |
| 6110 | Electricity | Power costs |
| 6120 | Water & Sewerage | Water utilities |
| 6130 | Telephone & Internet | Communications |
| 6200 | Office Supplies | Stationery, etc. |
| 6300 | Advertising & Marketing | Promotions |
| 6400 | Fuel & Oil | Vehicle fuel |
| 6500 | Insurance | Business insurance |
| 6600 | Repairs & Maintenance | Equipment repairs |
| 6700 | Depreciation Expense | Asset depreciation |
| 6800 | Bank Charges | Banking fees |
| 6810 | Interest Expense | Loan interest |
| 6900 | Sundry Expenses | Miscellaneous |

---

## 🔗 INVENTORY LEDGER LINKS

These ledgers connect your inventory tables to GL accounts:

| Ledger Code | Ledger Name | GL Account | Purpose |
|-------------|-------------|------------|---------|
| **INV-STOCKROOM** | Stockroom Inventory | 1400 | Raw materials + external products |
| **INV-MANUFACTURING** | Manufacturing Inventory | 1410 | Work-in-progress |
| **INV-FINISHED** | Finished Goods | 1420 | Completed products |
| **INV-RAWMATERIALS** | Raw Materials | 1430 | Ingredients |
| **CASH-ONHAND** | Cash on Hand | 1100 | Till cash |
| **CASH-PETTY** | Petty Cash | 1110 | Small expenses |
| **CASH-OVERSHORT** | Cash Over/Short | 1120 | Variances |
| **CASH-SUNDRIES** | Sundries Cash | 1130 | Misc cash |
| **SALES-REVENUE** | Sales Revenue | 4000 | Sales income |
| **COGS** | Cost of Sales | 5000 | Product costs |

---

## 📦 INVENTORY FLOW & POSTING

### **Purchase Order Receipt**

**External Products (e.g., Coke, Bread):**
```
Purchase Order → Invoice Capture
  ↓
DR 1420 Finished Goods Inventory
CR 2100 Accounts Payable
```

**Raw Materials (e.g., Flour, Sugar):**
```
Purchase Order → Invoice Capture
  ↓
DR 1400 Stockroom Inventory
CR 2100 Accounts Payable
```

---

### **Manufacturing Process**

**Step 1: Issue to Manufacturing**
```
Bill of Materials → Issue Ingredients
  ↓
DR 1410 Manufacturing Inventory (WIP)
CR 1400 Stockroom Inventory
```

**Step 2: Complete Production**
```
Complete Build → Finished Product
  ↓
DR 1420 Finished Goods Inventory
CR 1410 Manufacturing Inventory (WIP)
```

---

### **Retail Sales**

**Point of Sale Transaction**
```
Sale → Payment
  ↓
DR 1100 Cash on Hand (or 1300 Debtors)
CR 4000 Sales Revenue

AND

DR 5000 Cost of Sales
CR 1420 Finished Goods Inventory
```

---

### **Inter-Branch Transfer**

**Sender Branch:**
```
Transfer Out
  ↓
DR 1320 Inter-Branch Debtors
CR 1420 Finished Goods Inventory
```

**Receiver Branch:**
```
Transfer In
  ↓
DR 1420 Finished Goods Inventory
CR 2120 Inter-Branch Creditors
```

---

## 💰 CASH MANAGEMENT

### **Cash on Hand (1100)**
- **Purpose:** Main till cash for sales
- **Increases:** Cash sales, deposits
- **Decreases:** Banking, cash-outs
- **Used by:** POS system for daily sales

### **Petty Cash (1110)**
- **Purpose:** Small expenses (< R500)
- **Increases:** Petty cash float top-ups
- **Decreases:** Small purchases (tea, cleaning supplies)
- **Used by:** Branch managers for minor expenses

### **Cash Over/Short (1120)**
- **Purpose:** Till discrepancies
- **Increases:** Cash overages (more than expected)
- **Decreases:** Cash shortages (less than expected)
- **Used by:** End-of-day cash-up reconciliation

### **Sundries Cash (1130)**
- **Purpose:** Miscellaneous cash transactions
- **Increases:** Misc cash receipts
- **Decreases:** Misc cash payments
- **Used by:** One-off cash transactions

---

## 🧪 TESTING YOUR SETUP

### **1. Verify Chart of Accounts**

In ERP:
```
Accounting → Master Data → Chart of Accounts
```

**Expected Result:**
- ✅ All accounts visible in dropdown
- ✅ Accounts organized by code
- ✅ Account names display correctly

---

### **2. Verify Ledgers**

Run this query in SQL:
```sql
SELECT 
    LedgerCode,
    LedgerName,
    AccountCode,
    AccountName
FROM Ledgers
WHERE IsActive = 1
ORDER BY LedgerCode;
```

**Expected Result:**
- ✅ 10+ ledgers created
- ✅ All linked to GL accounts
- ✅ Inventory and cash ledgers present

---

### **3. Test Ledger Viewer**

In ERP:
```
Accounting → Master Data → Ledgers
```

**Expected Result:**
- ✅ Opens without errors
- ✅ Shows Cash account (1100) by default
- ✅ Can select different accounts

---

### **4. Test Trial Balance**

In ERP:
```
Accounting → General Ledger → Trial Balance
```

**Expected Result:**
- ✅ Opens without errors
- ✅ Shows all accounts (even with zero balance)
- ✅ Debits = Credits

---

## 🔧 TROUBLESHOOTING

### **Problem: Chart of Accounts is Empty**

**Solution:**
```sql
-- Run this script
SQL\POPULATE_CHART_OF_ACCOUNTS.sql
```

---

### **Problem: Ledgers Not Linked**

**Solution:**
```sql
-- Run this script
SQL\SETUP_INVENTORY_LEDGERS.sql
```

---

### **Problem: Missing Columns Error**

**Solution:**
```sql
-- Run this script first
SQL\ADD_MISSING_COLUMNS.sql
```

---

### **Problem: Forms Show Blank Screens**

**Solution:**
1. Check database connection string
2. Verify tables exist:
   ```sql
   SELECT * FROM INFORMATION_SCHEMA.TABLES
   WHERE TABLE_NAME IN ('ChartOfAccounts', 'Ledgers', 'GeneralJournal');
   ```
3. Run all SQL scripts in order

---

## 📝 NEXT STEPS

After setup is complete:

1. **✅ Create Opening Balances**
   - Post journal entries for starting balances
   - Set up initial inventory values

2. **✅ Configure POS Integration**
   - Link POS to GL accounts
   - Test sales posting

3. **✅ Setup Supplier Accounts**
   - Create supplier records
   - Link to Accounts Payable

4. **✅ Test Complete Workflow**
   - Purchase Order → Invoice → Payment
   - Manufacturing → Production → Sale
   - End-of-day cash-up

---

## 📞 SUPPORT

If you encounter issues:

1. Check SQL script output for errors
2. Verify database connection
3. Review error logs in ERP
4. Check that all scripts ran successfully

---

## ✅ COMPLETION CHECKLIST

- [ ] Ran `ADD_MISSING_COLUMNS.sql`
- [ ] Ran `POPULATE_CHART_OF_ACCOUNTS.sql`
- [ ] Ran `SETUP_INVENTORY_LEDGERS.sql`
- [ ] Rebuilt ERP application
- [ ] Verified Chart of Accounts loads
- [ ] Verified Ledgers load
- [ ] Tested Trial Balance
- [ ] Tested account selection
- [ ] Ready for transactions!

---

**Your accounting system is now ready for use!** 🎉
