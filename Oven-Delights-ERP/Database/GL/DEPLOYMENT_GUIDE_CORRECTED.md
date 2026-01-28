# GL POSTING DEPLOYMENT GUIDE - CORRECTED

## Issues Found During Testing

1. ❌ **Missing GL Accounts** - Accounts 2021 (VAT Input) and 1610 (Inter-Branch Creditors) not found
2. ❌ **FiscalPeriodID NULL Error** - JournalHeaders.FiscalPeriodID does not allow NULL values
3. ❌ **Missing BranchID** - AP_Invoices table missing BranchID column

---

## CORRECTED DEPLOYMENT ORDER

### Step 1: Add BranchID to AP_Invoices
```sql
:r "Database\AP\ALTER_AP_Invoices_Add_BranchID.sql"
```
**Creates:** BranchID column in AP_Invoices table

---

### Step 2: Update AP Stored Procedures
```sql
:r "Database\AP\sp_AP_Procedures.sql"
```
**Updates:** sp_AP_CreateInvoice to include BranchID parameter

---

### Step 3: Create Fiscal Period Helper Function
```sql
:r "Database\GL\00_Get_Current_FiscalPeriod_Function.sql"
```
**Creates:** 
- FiscalPeriods table (if not exists)
- fn_GetCurrentFiscalPeriodID() function
- Default fiscal period for current year

**CRITICAL:** This must run BEFORE any GL integration scripts

---

### Step 4: Create Missing GL Accounts
```sql
:r "Database\GL\20_Create_Missing_GL_Accounts.sql"
```
**Creates 4 accounts:**
- 1610 - Inter-Branch Creditors
- 2021 - VAT Input (Purchase VAT) ⭐ **Critical for SARS**
- 4030 - Other Income
- 6080 - Stock Loss/Shrinkage

---

### Step 5: Deploy GL Integration Procedures
```sql
-- AP Integration (uses fiscal period function)
:r "Database\GL\14_AP_GL_Integration.sql"

-- Enhanced PO Integration
:r "Database\GL\15_Enhanced_PO_Integration.sql"

-- Manufacturing to Retail Transfer
:r "Database\GL\16_Manufacturing_Retail_Transfer.sql"

-- Inter-Branch Transfer Integration
:r "Database\GL\17_IBT_GL_Integration.sql"

-- Inventory GL Integration
:r "Database\GL\18_Inventory_GL_Integration.sql"

-- Cashbook Additional Integration
:r "Database\GL\19_Cashbook_Additional_Integration.sql"
```

**Note:** Scripts 15-19 need to be updated to use `dbo.fn_GetCurrentFiscalPeriodID()` instead of NULL

---

### Step 6: Test All Procedures
```sql
:r "Database\GL\TEST_GL_POSTING_PROCEDURES.sql"
```

---

## MANUAL FIX REQUIRED FOR SCRIPTS 15-19

All procedures in scripts 15-19 currently have:
```sql
FiscalPeriodID, IsPosted, CreatedBy
)
VALUES (
    ...,
    NULL,  -- ❌ THIS WILL FAIL
    1,
    @CreatedBy
)
```

**Must be changed to:**
```sql
FiscalPeriodID, IsPosted, CreatedBy
)
VALUES (
    ...,
    dbo.fn_GetCurrentFiscalPeriodID(@TransactionDate),  -- ✅ CORRECT
    1,
    @CreatedBy
)
```

---

## FILES THAT NEED UPDATING

### ✅ Already Fixed:
- `14_AP_GL_Integration.sql` - All 4 procedures updated

### ⚠️ Need Manual Fix:
- `15_Enhanced_PO_Integration.sql` - sp_PO_PostInvoiceToGL
- `16_Manufacturing_Retail_Transfer.sql` - sp_MFG_PostManufacturingToRetailTransfer
- `17_IBT_GL_Integration.sql` - sp_IBT_PostReceiptToGL, sp_IBT_PostSettlementToGL
- `18_Inventory_GL_Integration.sql` - sp_INV_PostStockAdjustmentToGL
- `19_Cashbook_Additional_Integration.sql` - sp_CB_PostPettyCashTopUpToGL

---

## QUICK FIX INSTRUCTIONS

For each of the files above (15-19):

1. Open the file
2. Find all instances of:
   ```sql
   FiscalPeriodID, IsPosted, CreatedBy
   )
   VALUES (
       @JournalNumber,
       @BranchID,
       @SomeDate,
       @Reference,
       @Description,
       NULL,  -- ← FIND THIS
   ```

3. Replace `NULL,` with:
   ```sql
   dbo.fn_GetCurrentFiscalPeriodID(@SomeDate),
   ```
   (Use the appropriate date variable for each procedure)

---

## EXPECTED TEST RESULTS AFTER FIX

```
TEST 1: ADHOC Invoice Posting
  ✓ Journal created: 123
  ✓ Journal balanced: Dr=1150.00, Cr=1150.00
  ✓ TEST 1 PASSED

TEST 2: Single Payment Posting
  ✓ Journal created: 124
  ✓ Journal balanced: Dr=1150.00, Cr=1150.00
  ✓ TEST 2 PASSED

TEST 3: Manufacturing to Retail Transfer
  ✓ Journal created: 125
  ✓ Journal balanced: Dr=5000.00, Cr=5000.00
  ✓ TEST 3 PASSED

TEST 4: IBT Receipt Posting
  ✓ Journal created: 126
  ✓ Journal balanced: Dr=3000.00, Cr=3000.00
  ✓ TEST 4 PASSED

TEST 5: Stock Adjustment (Decrease)
  ✓ Journal created: 127
  ✓ Journal balanced: Dr=500.00, Cr=500.00
  ✓ TEST 5 PASSED

TEST 6: Petty Cash Top-Up
  ✓ Journal created: 128
  ✓ Journal balanced: Dr=500.00, Cr=500.00
  ✓ TEST 6 PASSED
```

---

## SUMMARY

**Root Causes:**
1. Missing GL accounts (2021, 1610)
2. FiscalPeriodID column does NOT allow NULL
3. Missing BranchID in AP_Invoices

**Solutions:**
1. ✅ Run `20_Create_Missing_GL_Accounts.sql`
2. ✅ Run `00_Get_Current_FiscalPeriod_Function.sql`
3. ✅ Update scripts 15-19 to use fiscal period function
4. ✅ Run `ALTER_AP_Invoices_Add_BranchID.sql`

**Next Action:**
Update scripts 15-19 manually, then re-run deployment in correct order.
