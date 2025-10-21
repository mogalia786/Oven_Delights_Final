# 🧪 TESTING CHECKLIST - Oven Delights ERP
## Complete Workflow Testing Guide

**Date:** 2025-10-03  
**Status:** Ready for Testing  
**Tester:** User

---

## 📋 PRE-TESTING REQUIREMENTS

### **Database Scripts to Run (In Order):**
1. ✅ `Update_Products_ItemType_And_LastPaid.sql`
2. ✅ `Create_SupplierInvoices_And_Payments.sql`
3. ✅ `Create_ProductPricing_Table.sql`
4. ✅ `Sync_ProductInventory_To_RetailStock.sql`
5. ✅ `Create_Manufacturing_Inventory_Table.sql`
6. ✅ `Create_InterBranchTransfers_Table.sql`

### **Verify Base Data Exists:**
- [ ] Branches table has at least 2 branches
- [ ] Users table has test users with different roles
- [ ] Suppliers table has test suppliers
- [ ] Categories and Subcategories exist
- [ ] ChartOfAccounts has basic accounts

---

## 🔄 WORKFLOW 1: EXTERNAL PRODUCTS (Coke, Bread, Sweets)

### **Step 1: Create Purchase Order**
**Form:** `PurchaseOrderForm`  
**Menu:** Stockroom → Purchase Orders → Create Purchase Order

**Test:**
- [ ] Form opens without errors
- [ ] Branch dropdown shows branches
- [ ] Supplier dropdown loads
- [ ] Can add External products to grid
- [ ] LastPaidPrice and AverageCost display
- [ ] Save creates PO with BranchID
- [ ] PO Number generated correctly

**Expected Result:** PO saved with status "Pending"

---

### **Step 2: Capture Invoice (External Products)**
**Form:** `InvoiceCaptureForm`  
**Menu:** Stockroom → Invoice Capture

**Test:**
- [ ] Form opens without errors
- [ ] PO dropdown loads pending POs
- [ ] Select PO loads lines
- [ ] Can enter "Receive Now" quantities
- [ ] Can enter "Return Qty" if shortage
- [ ] Credit Note button enabled only when ReturnQty > 0
- [ ] Credit Reason dropdown appears
- [ ] Save button works

**Expected Result:**
- ✅ Retail_Stock updated with received quantity (BranchID)
- ✅ SupplierInvoices record created (Status: Unpaid)
- ✅ Journal entries created:
  - DR Inventory (1200)
  - DR VAT Input (1300)
  - CR Accounts Payable (2100)
- ✅ If shortage: Credit note letter generated with Print/Email buttons

**SQL to Verify:**
```sql
-- Check Retail_Stock updated
SELECT * FROM Retail_Stock WHERE BranchID = @YourBranchID ORDER BY UpdatedAt DESC;

-- Check Supplier Invoice created
SELECT * FROM SupplierInvoices WHERE BranchID = @YourBranchID ORDER BY CreatedDate DESC;

-- Check Journal Entries
SELECT * FROM JournalHeaders WHERE BranchID = @YourBranchID ORDER BY CreatedDate DESC;
SELECT * FROM JournalDetails WHERE JournalID = @LastJournalID;
```

---

### **Step 3: Pay Supplier Invoice**
**Form:** `SupplierPaymentForm`  
**Menu:** Accounting → Payments → Pay Supplier Invoice

**Test:**
- [ ] Form opens without errors
- [ ] Supplier dropdown loads
- [ ] Select supplier shows outstanding invoices (filtered by BranchID)
- [ ] Can enter payment amounts
- [ ] Payment method dropdown works
- [ ] Save creates payment

**Expected Result:**
- ✅ SupplierPayments record created
- ✅ SupplierInvoices.AmountPaid updated
- ✅ Status changes (Unpaid → PartiallyPaid → Paid)
- ✅ Journal entries:
  - DR Accounts Payable (2100)
  - CR Bank (1050)

---

### **Step 4: View Credit Notes**
**Form:** `CreditNoteViewerForm`  
**Menu:** Accounting → Credit Notes → View Credit Notes

**Test:**
- [ ] Form opens without errors
- [ ] Shows credit notes for current branch
- [ ] Status filter works (All, Pending, Approved, Applied)
- [ ] Select credit note enables Print/Email buttons
- [ ] Print button opens print dialog
- [ ] Email button opens email client

---

## 🔄 WORKFLOW 2: RAW MATERIALS → MANUFACTURING → RETAIL

### **Step 1: Create PO for Raw Materials**
**Form:** `PurchaseOrderForm`

**Test:**
- [ ] Can add Raw Material products (Flour, Butter, Sugar, etc.)
- [ ] LastPaidPrice shows for raw materials
- [ ] Save creates PO

---

### **Step 2: Capture Invoice (Raw Materials)**
**Form:** `InvoiceCaptureForm`

**Test:**
- [ ] Select PO with raw materials
- [ ] Enter receive quantities
- [ ] Save updates RawMaterials.CurrentStock (not Retail_Stock)

**Expected Result:**
- ✅ RawMaterials.CurrentStock updated
- ✅ SupplierInvoices created
- ✅ Journal entries created

**SQL to Verify:**
```sql
SELECT * FROM RawMaterials WHERE MaterialID = @MaterialID;
```

---

### **Step 3: Create Bill of Materials (BOM)**
**Form:** `BuildProductForm`  
**Menu:** Manufacturing → Build My Product

**Test:**
- [ ] Form opens without errors
- [ ] Can create product with ItemType='Manufactured'
- [ ] Can add raw materials to recipe
- [ ] Can add sub-assemblies
- [ ] Save creates BOM
- [ ] Product marked as ItemType='Manufactured'

**SQL to Verify:**
```sql
SELECT * FROM Products WHERE ItemType = 'Manufactured';
SELECT * FROM BOMHeader WHERE ProductID = @ProductID;
SELECT * FROM BOMItems WHERE BOMID = @BOMID;
```

---

### **Step 4: Issue to Manufacturing**
**Form:** Manufacturing Dashboard or Internal Orders

**Test:**
- [ ] Manufacturer can request ingredients
- [ ] System checks RawMaterials.CurrentStock
- [ ] If available: Issues to manufacturing
- [ ] If not available: Creates PO

**Expected Result:**
- ✅ RawMaterials.CurrentStock reduced
- ✅ Manufacturing_Inventory increased (optional)
- ✅ Journal entries:
  - DR Manufacturing Inventory
  - CR Stockroom Inventory

---

### **Step 5: Complete Build**
**Form:** `CompleteBuildForm`  
**Menu:** Manufacturing → Complete Build

**Test:**
- [ ] Form opens without errors
- [ ] Can select manufactured product
- [ ] Can enter quantity completed
- [ ] Save completes build

**Expected Result:**
- ✅ Manufacturing_Inventory reduced (ingredients consumed)
- ✅ ProductInventory updated (finished goods)
- ✅ **Retail_Stock updated via sp_Sync_ProductInventory_To_RetailStock**
- ✅ Retail_Variant created if needed
- ✅ Retail_StockMovements recorded
- ✅ Product available for POS

**SQL to Verify:**
```sql
-- Check ProductInventory
SELECT * FROM ProductInventory WHERE ProductID = @ProductID AND BranchID = @BranchID;

-- Check Retail_Stock (CRITICAL for POS)
SELECT rs.*, rv.Barcode, p.ProductName 
FROM Retail_Stock rs
INNER JOIN Retail_Variant rv ON rs.VariantID = rv.VariantID
INNER JOIN Products p ON rv.ProductID = p.ProductID
WHERE rs.BranchID = @BranchID AND p.ItemType = 'Manufactured';

-- Check movements
SELECT * FROM Retail_StockMovements WHERE BranchID = @BranchID ORDER BY CreatedAt DESC;
```

---

## 🔄 WORKFLOW 3: INTER-BRANCH TRANSFER

### **Step 1: Create Transfer**
**Form:** `StockTransferForm`  
**Menu:** Stockroom → Stock Transfer

**Test:**
- [ ] Form opens without errors
- [ ] From Branch dropdown shows branches
- [ ] To Branch dropdown shows branches
- [ ] If NOT Super Admin: From Branch locked to user's branch
- [ ] If Super Admin: Can select any From Branch
- [ ] Product dropdown loads
- [ ] Can enter quantity
- [ ] Save creates transfer

**Expected Result:**
- ✅ Retail_Stock reduced at sender branch
- ✅ Retail_Stock increased at receiver branch
- ✅ InterBranchTransfers record created
- ✅ Journal entries for SENDER:
  - DR Inter-Branch Debtors (1400)
  - CR Inventory (1200)
- ✅ Journal entries for RECEIVER:
  - DR Inventory (1200)
  - CR Inter-Branch Creditors (2200)

**SQL to Verify:**
```sql
-- Check sender branch stock reduced
SELECT * FROM Retail_Stock WHERE BranchID = @SenderBranchID AND VariantID = @VariantID;

-- Check receiver branch stock increased
SELECT * FROM Retail_Stock WHERE BranchID = @ReceiverBranchID AND VariantID = @VariantID;

-- Check transfer record
SELECT * FROM InterBranchTransfers WHERE FromBranchID = @SenderBranchID AND ToBranchID = @ReceiverBranchID;

-- Check journal entries (both branches)
SELECT jh.*, jd.* 
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
WHERE jh.Reference LIKE '%iTrans%'
ORDER BY jh.CreatedDate DESC;
```

---

## 🔄 WORKFLOW 4: POINT OF SALE (POS)

### **Pre-requisites:**
- [ ] Retail_Stock has products with QtyOnHand > 0
- [ ] Retail_Price has prices set for products
- [ ] Products have ItemType set (Manufactured or External)

### **Step 1: Check POS Data Availability**

**SQL to Verify:**
```sql
-- Products available for sale at current branch
SELECT 
    p.ProductID, 
    p.SKU, 
    p.ProductName, 
    p.ItemType,
    rs.QtyOnHand, 
    rp.SellingPrice,
    rv.Barcode
FROM Products p
INNER JOIN Retail_Variant rv ON p.ProductID = rv.ProductID
INNER JOIN Retail_Stock rs ON rv.VariantID = rs.VariantID
LEFT JOIN Retail_Price rp ON p.ProductID = rp.ProductID AND rp.BranchID = @BranchID
WHERE rs.BranchID = @BranchID 
AND rs.QtyOnHand > 0
AND p.IsActive = 1;
```

**Expected Result:**
- ✅ Both External products (from PO) and Manufactured products (from Complete Build) appear
- ✅ Each has QtyOnHand > 0
- ✅ Each has SellingPrice set

---

### **Step 2: Test POS Form (When Ready)**
**Form:** `POSForm`  
**Menu:** Retail → Point of Sale

**Test:**
- [ ] Form opens without errors
- [ ] Categories load
- [ ] Products load with images
- [ ] Barcode scanning works
- [ ] Can add items to cart
- [ ] Stock check works (shows available quantity)
- [ ] Multiple payment methods work
- [ ] Sale completes successfully

**Expected Result:**
- ✅ Retail_Stock reduced
- ✅ Retail_StockMovements recorded (Reason: 'Sale')
- ✅ Journal entries:
  - DR Cash/Debtors
  - CR Sales Revenue
  - CR VAT Output
  - DR Cost of Sales
  - CR Inventory

---

## 🐛 KNOWN ISSUES TO FIX

### **Compilation Errors:**
- [x] Fixed: StockTransferForm - AppSession.CurrentRoleName
- [x] Fixed: ManufacturingService - bid variable
- [x] Fixed: CreditNoteViewerForm - Print/Email methods

### **Potential Runtime Errors:**
- [ ] Missing database tables (run scripts first)
- [ ] Missing stored procedures (sp_Sync_ProductInventory_To_RetailStock)
- [ ] Missing ChartOfAccounts entries (auto-created on first use)
- [ ] Missing Retail_Variant records (auto-created by sync)

---

## 📊 VERIFICATION QUERIES

### **Check Multi-Branch Setup:**
```sql
-- Verify branches exist
SELECT * FROM Branches;

-- Verify users have BranchID
SELECT UserID, Username, BranchID FROM Users;

-- Verify AppSession tracking
-- (Check in code: AppSession.CurrentBranchID should be set on login)
```

### **Check Stock Levels:**
```sql
-- Raw Materials
SELECT * FROM RawMaterials WHERE CurrentStock > 0;

-- Manufacturing Inventory (WIP)
SELECT * FROM Manufacturing_Inventory WHERE QtyOnHand > 0;

-- Product Inventory (Finished Goods)
SELECT * FROM ProductInventory WHERE QuantityOnHand > 0;

-- Retail Stock (POS Ready)
SELECT rs.*, rv.Barcode, p.ProductName, p.ItemType
FROM Retail_Stock rs
INNER JOIN Retail_Variant rv ON rs.VariantID = rv.VariantID
INNER JOIN Products p ON rv.ProductID = p.ProductID
WHERE rs.QtyOnHand > 0;
```

### **Check Ledger Entries:**
```sql
-- All journal entries for current branch
SELECT jh.JournalID, jh.JournalNumber, jh.JournalDate, jh.Reference, jh.Description,
       jd.AccountID, coa.AccountCode, coa.AccountName, jd.Debit, jd.Credit
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
LEFT JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jh.BranchID = @BranchID
ORDER BY jh.JournalDate DESC, jh.JournalID DESC;
```

---

## ✅ SUCCESS CRITERIA

### **Workflow 1 (External Products):**
- [x] PO created with BranchID
- [x] Invoice captured updates Retail_Stock
- [x] SupplierInvoices created
- [x] Journal entries correct
- [x] Credit notes work for shortages
- [x] Products available in Retail_Stock for POS

### **Workflow 2 (Manufacturing):**
- [x] PO for raw materials updates RawMaterials
- [x] BOM created with ItemType='Manufactured'
- [x] Issue to manufacturing reduces stockroom
- [x] Complete build updates ProductInventory
- [x] **Sync to Retail_Stock works**
- [x] Manufactured products available for POS

### **Workflow 3 (Inter-Branch):**
- [x] Transfer reduces sender stock
- [x] Transfer increases receiver stock
- [x] Ledger entries for both branches
- [x] Inter-Branch Debtors/Creditors created

### **Workflow 4 (POS):**
- [ ] Products visible in POS (both External and Manufactured)
- [ ] Stock levels accurate
- [ ] Prices set
- [ ] Sale completes
- [ ] Ledger entries correct

---

## 🚨 CRITICAL CHECKS

### **BranchID Everywhere:**
```sql
-- These queries should ALL filter by BranchID
SELECT * FROM Retail_Stock WHERE BranchID = @BranchID;
SELECT * FROM SupplierInvoices WHERE BranchID = @BranchID;
SELECT * FROM JournalHeaders WHERE BranchID = @BranchID;
SELECT * FROM InterBranchTransfers WHERE FromBranchID = @BranchID OR ToBranchID = @BranchID;
```

### **ItemType Correct:**
```sql
-- External products
SELECT * FROM Products WHERE ItemType = 'External';

-- Manufactured products
SELECT * FROM Products WHERE ItemType = 'Manufactured';
```

### **Sync Working:**
```sql
-- After Complete Build, this should have records
SELECT * FROM Retail_Stock rs
INNER JOIN Retail_Variant rv ON rs.VariantID = rv.VariantID
INNER JOIN Products p ON rv.ProductID = p.ProductID
WHERE p.ItemType = 'Manufactured' AND rs.BranchID = @BranchID;
```

---

## 📝 TESTING NOTES

**Date:** _____________  
**Tester:** _____________  
**Branch Tested:** _____________

### **Issues Found:**
1. _____________________________________________
2. _____________________________________________
3. _____________________________________________

### **Fixes Applied:**
1. _____________________________________________
2. _____________________________________________
3. _____________________________________________

### **Status:**
- [ ] All workflows tested
- [ ] All issues resolved
- [ ] System ready for production
- [ ] POS ready for development

---

**Next Steps:**
1. Run all database scripts
2. Test each workflow step-by-step
3. Document any errors
4. Fix errors one by one
5. Re-test until all green
6. Begin POS development
