# 🧪 MENU & FEATURE TESTING PLAN
## Systematic Testing Before POS Development

**Date:** 2025-10-03  
**Status:** Ready to Begin Testing  
**Goal:** Iron out all errors in every menu and feature

---

## 📋 TESTING APPROACH

### **Method:**
1. Open each menu item one by one
2. Test basic functionality
3. Document any errors
4. Fix errors immediately
5. Re-test until working
6. Move to next menu item

### **Error Documentation:**
- Error message
- Steps to reproduce
- Expected behavior
- Actual behavior

---

## 🗂️ MENU STRUCTURE TO TEST

### **1. STOCKROOM MENU**

#### **Purchase Orders**
- [ ] **Create Purchase Order**
  - Form opens without errors
  - Branch dropdown loads
  - Supplier dropdown loads
  - Product search works
  - Can add products to grid
  - LastPaidPrice displays
  - Save creates PO
  - PO Number generated
  
- [ ] **View Purchase Orders**
  - Grid loads with POs
  - Filter by status works
  - Can view PO details
  - Can edit pending POs
  
- [ ] **Invoice Capture**
  - Form opens
  - PO dropdown loads
  - Lines load from selected PO
  - Can enter receive quantities
  - Can enter return quantities
  - Credit note button enables correctly
  - Save updates stock
  - Creates supplier invoice
  - Creates journal entries

#### **Inventory Management**
- [ ] **Add Inventory**
  - Form opens
  - Can add raw materials
  - Can add external products
  - Stock updates correctly
  
- [ ] **Stock Transfer**
  - Form opens
  - Branch dropdowns load
  - Super Admin can select any branch
  - Regular user locked to their branch
  - Product dropdown loads
  - Transfer creates correct entries
  - Both branches updated

#### **Reports**
- [ ] **Stock Movement Report**
  - Report loads
  - Shows movements by branch
  - Date filters work
  
#### **GRV Management**
- [ ] **GRV Management**
  - Form opens
  - Can create GRV
  - Can match to invoice
  - Can view GRV list

---

### **2. MANUFACTURING MENU**

#### **Product Management**
- [ ] **Categories**
  - Form opens
  - Can add category
  - Can edit category
  - Can delete category
  
- [ ] **Subcategories**
  - Form opens
  - Can add subcategory
  - Linked to category
  - Can edit/delete
  
- [ ] **Products**
  - Form opens
  - Can add manufactured product
  - ItemType set to 'Manufactured'
  - Can upload image
  - Can set category/subcategory

#### **BOM & Production**
- [ ] **Recipe Creator (BOM)**
  - Form opens
  - Can select product
  - Can add ingredients
  - Can add sub-assemblies
  - Quantities calculate correctly
  - Save creates BOM
  
- [ ] **Build My Product**
  - Form opens
  - Can create new product with BOM
  - ItemType='Manufactured'
  - BOM saves correctly
  
- [ ] **Complete Build**
  - Form opens
  - Can select manufactured product
  - Can enter quantity completed
  - Reduces manufacturing inventory
  - Updates ProductInventory
  - **Syncs to Retail_Stock**
  - Creates journal entries
  
- [ ] **MO Actions**
  - Form opens
  - Shows manufacturing orders
  - Can update status

---

### **3. RETAIL MENU**

#### **Product Management**
- [ ] **Products**
  - Form opens
  - Shows all products
  - Can add new product
  - Can edit product
  - Can set prices
  
- [ ] **Price Management**
  - Form opens
  - Shows products by branch
  - Can set selling price
  - Can set effective dates
  - Branch-specific pricing works
  
- [ ] **Inventory Adjustment**
  - Form opens
  - Can adjust stock levels
  - Creates journal entries
  - Updates Retail_Stock

#### **Reports**
- [ ] **Low Stock Report**
  - Report loads
  - Shows products below reorder point
  - Filtered by branch
  
- [ ] **Product Catalog**
  - Report loads
  - Shows all products
  - Includes prices and stock
  
- [ ] **Price History**
  - Report loads
  - Shows price changes
  - Filtered by branch

#### **Point of Sale**
- [ ] **Point of Sale**
  - Form opens (if exists)
  - Or note: To be developed

---

### **4. ACCOUNTING MENU**

#### **Ledger Viewers**
- [ ] **General Ledger Viewer**
  - Form opens
  - Shows journal entries
  - Filtered by branch
  - Can filter by date
  - Can filter by account
  
- [ ] **Supplier Ledger**
  - Form opens
  - Shows supplier transactions
  - Filtered by branch
  - Shows outstanding balances

#### **Payments**
- [ ] **Pay Supplier Invoice**
  - Form opens
  - Supplier dropdown loads
  - Shows outstanding invoices
  - Filtered by branch
  - Can allocate payment
  - Creates journal entries
  - Updates invoice status

#### **Credit Notes**
- [ ] **View Credit Notes**
  - Form opens
  - Shows credit notes by branch
  - Status filter works
  - Print button works
  - Email button works

#### **Reports**
- [ ] **Trial Balance**
  - Report loads
  - Shows all accounts
  - Debits = Credits
  
- [ ] **Income Statement**
  - Report loads
  - Shows revenue and expenses
  - Filtered by date range
  
- [ ] **Balance Sheet**
  - Report loads
  - Shows assets, liabilities, equity

---

### **5. ADMIN MENU**

#### **User Management**
- [ ] **User Management**
  - Form opens
  - Shows all users
  - Can add new user
  - Can assign branch
  - Can assign role
  
- [ ] **Role Management**
  - Form opens
  - Shows all roles
  - Can create role
  - Can assign permissions

#### **System Settings**
- [ ] **Branch Management**
  - Form opens
  - Shows all branches
  - Can add branch
  - Can edit branch details
  
- [ ] **GL Account Mappings**
  - Form opens
  - Shows account mappings
  - Can configure accounts

---

## 🐛 ERROR TRACKING TEMPLATE

### **Error #1: [Menu Item Name]**
**Date:** _____________  
**Error Message:**
```
[Paste error message here]
```

**Steps to Reproduce:**
1. _____________
2. _____________
3. _____________

**Expected Behavior:**
_____________

**Actual Behavior:**
_____________

**Fix Applied:**
_____________

**Status:** ⬜ Open | ⬜ Fixed | ⬜ Verified

---

### **Error #2: [Menu Item Name]**
**Date:** _____________  
**Error Message:**
```
[Paste error message here]
```

**Steps to Reproduce:**
1. _____________
2. _____________
3. _____________

**Expected Behavior:**
_____________

**Actual Behavior:**
_____________

**Fix Applied:**
_____________

**Status:** ⬜ Open | ⬜ Fixed | ⬜ Verified

---

## 📊 TESTING PROGRESS

### **Overall Progress:**
- [ ] Stockroom Menu (0/12 items tested)
- [ ] Manufacturing Menu (0/7 items tested)
- [ ] Retail Menu (0/7 items tested)
- [ ] Accounting Menu (0/7 items tested)
- [ ] Admin Menu (0/4 items tested)

**Total:** 0/37 menu items tested

---

## 🎯 CRITICAL TESTS

### **Multi-Branch Functionality:**
- [ ] Branch dropdown shows actual branch names (not "Main Branch")
- [ ] Super Admin can select any branch
- [ ] Regular users locked to their branch
- [ ] All operations include BranchID
- [ ] Stock levels are branch-specific

### **Inventory Flow:**
- [ ] External products: PO → Invoice → Retail_Stock
- [ ] Raw materials: PO → Invoice → RawMaterials
- [ ] Manufacturing: RawMaterials → Manufacturing → ProductInventory → Retail_Stock
- [ ] Inter-branch transfers update both branches

### **Ledger Integration:**
- [ ] All transactions create journal entries
- [ ] Debits = Credits for all entries
- [ ] BranchID included in all journal entries
- [ ] Inter-branch transfers create proper Debtors/Creditors

### **Credit Notes:**
- [ ] Button only enabled when shortage/damage
- [ ] Letter generates correctly
- [ ] Print button works
- [ ] Email button works

---

## 📝 TESTING SESSION LOG

### **Session 1: [Date/Time]**
**Tester:** _____________  
**Duration:** _____________  
**Items Tested:** _____________  
**Errors Found:** _____________  
**Errors Fixed:** _____________  
**Notes:**
_____________________________________________
_____________________________________________

---

### **Session 2: [Date/Time]**
**Tester:** _____________  
**Duration:** _____________  
**Items Tested:** _____________  
**Errors Found:** _____________  
**Errors Fixed:** _____________  
**Notes:**
_____________________________________________
_____________________________________________

---

## 🔧 COMMON FIXES NEEDED

### **Database Issues:**
- [ ] Missing tables (run database scripts)
- [ ] Missing stored procedures
- [ ] Missing ChartOfAccounts entries
- [ ] Missing Branches data
- [ ] Missing Users data

### **Form Issues:**
- [ ] Missing Designer files
- [ ] Control declaration errors
- [ ] Missing event handlers
- [ ] Incorrect connection strings

### **Logic Issues:**
- [ ] BranchID not included in queries
- [ ] ItemType not set correctly
- [ ] Stock not updating
- [ ] Journal entries not created

---

## ✅ COMPLETION CRITERIA

### **Before POS Development:**
- [ ] All 37 menu items tested
- [ ] All errors documented
- [ ] All errors fixed
- [ ] All critical tests passing
- [ ] Multi-branch functionality verified
- [ ] Inventory flow verified
- [ ] Ledger integration verified
- [ ] System stable and reliable

---

## 🚀 NEXT STEPS AFTER TESTING

1. ✅ All menus working
2. ✅ All features tested
3. ✅ All errors fixed
4. ✅ Database scripts run
5. ✅ Sample data imported
6. → **BEGIN POS DEVELOPMENT**

---

**Testing Start Date:** _____________  
**Testing End Date:** _____________  
**Total Errors Found:** _____________  
**Total Errors Fixed:** _____________  
**System Status:** ⬜ Ready for POS Development
