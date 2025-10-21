# EXISTING FEATURES AUDIT - OVEN DELIGHTS ERP

## FORMS INVENTORY (What Already Exists)

### **STOCKROOM MODULE**
✅ **SuppliersForm** - Supplier management
✅ **SupplierAddEditForm** - Add/Edit suppliers
✅ **PurchaseOrderForm** - Create purchase orders (FIXED - Key/Value errors resolved)
✅ **StockTransferForm** - Inter-branch transfers (COMPLETE with From/To/Product dropdowns)
✅ **StockMovementReportForm** - Stock movement history
✅ **ProductAddEditForm** - Add/Edit products (External only)
✅ **InvoiceGRVForm** - Invoice and GRV processing
✅ **GRVInvoiceMatchForm** - Match GRV to invoices
✅ **GRVCreateForm** - Create goods received vouchers
✅ **GRVManagementForm** - Manage GRVs
✅ **IssueToManufacturingForm** - Issue materials to manufacturing (JUST CREATED)

### **MANUFACTURING MODULE**
✅ **BuildProductForm** - Create BOM and products
✅ **CompleteBuildForm** - Complete manufacturing build
✅ **CategoryManagementForm** - Manage categories
✅ **SubcategoryManagementForm** - Manage subcategories
✅ **BOMManagementForm** - Bill of Materials management
✅ **MOActionsForm** - Manufacturing order actions

### **RETAIL MODULE**
✅ **InventoryReportForm** - Inventory reports
✅ **LowStockReportForm** - Low stock alerts
✅ **ProductCatalogReportForm** - Product catalog
✅ **PriceHistoryReportForm** - Price change history
✅ **SalesReportForm** - Sales reports

### **ACCOUNTING MODULE**
✅ **SupplierLedgerForm** - Supplier ledger (Accounts Payable)
✅ **IncomeStatementCrystalReportForm** - Income statement
✅ **SARSReportingForm** - SARS tax reporting

---

## DATABASE TABLES (Verified)

### **INVENTORY TABLES**
✅ **RawMaterials** - Raw materials master (shared across branches)
✅ **Products** - Products master (SKU, ItemType, LastPaidPrice, AverageCost, ProductImage)
✅ **Retail_Stock** - Branch-specific product inventory (VariantID, BranchID, QtyOnHand, AverageCost)
✅ **Retail_StockMovements** - Audit trail for retail stock
✅ **Manufacturing_Inventory** - WIP ingredients per branch (CREATED)
✅ **Manufacturing_InventoryMovements** - Audit trail for manufacturing (CREATED)

### **TRANSACTION TABLES**
✅ **PurchaseOrders** - Purchase order headers
✅ **PurchaseOrderLines** - PO line items (MaterialID, ProductID, ItemSource)
✅ **SupplierInvoices** - Supplier invoices (NEEDS CREATION)
✅ **InterBranchTransfers** - Inter-branch transfers (CREATED)

### **PRICING & COSTING**
✅ **ProductPricing** - Branch-specific selling prices (CREATED)
✅ **ProductPricingHistory** - Price change audit (CREATED)

### **ACCOUNTING**
✅ **JournalHeaders** - Journal entry headers
✅ **JournalDetails** - Journal entry lines
✅ **ChartOfAccounts** - GL accounts

---

## SERVICES (Business Logic)

✅ **StockroomService** - Core stockroom operations
✅ **InvoiceCaptureService** - Invoice routing logic (CREATED)
✅ **GRVService** - GRV operations
✅ **ReportingService** - Report generation
✅ **DashboardChartsService** - Dashboard data

---

## WHAT NEEDS TO BE DONE

### **1. WIRE EXISTING FORMS TO CORRECT TABLES**

#### **A. BuildProductForm** (Manufacturing)
**Current State:** Creates products in Products table
**Needs:**
- ✅ Already sets ItemType='Manufactured' (FIXED)
- ❌ Needs to consume from Manufacturing_Inventory (not RawMaterials directly)
- ❌ Needs to create product in Retail_Stock with calculated cost

#### **B. CompleteBuildForm** (Manufacturing)
**Current State:** Completes manufacturing orders
**Needs:**
- ❌ Reduce Manufacturing_Inventory (ingredients consumed)
- ❌ Add finished product to Retail_Stock
- ❌ Create ledger: DR Finished Goods, CR Manufacturing Inventory

#### **C. InvoiceGRVForm** (Stockroom)
**Current State:** Processes invoices
**Needs:**
- ✅ Use InvoiceCaptureService for routing
- ✅ External Products → Retail_Stock
- ✅ Raw Materials → RawMaterials
- ❌ Wire up to use new service

#### **D. SupplierLedgerForm** (Accounting)
**Current State:** Shows supplier transactions
**Needs:**
- ✅ Already exists and works
- ❌ Add "Pay Invoice" button
- ❌ Link to invoice payment form

---

### **2. CREATE MISSING FORMS**

#### **A. Supplier Invoice Payment Form**
**Purpose:** Pay supplier invoices (Accounts Payable)
**Features:**
- Select supplier
- Show outstanding invoices
- Enter payment amount
- Select payment method (Cash, Bank Transfer, Check)
- Create ledger: DR Accounts Payable, CR Bank/Cash

#### **B. Stock Reports (3 Reports)**

**1. Stockroom Stock Report**
- Show RawMaterials inventory
- By branch (movements tracked)
- Current stock, value, reorder points

**2. Manufacturing Stock Report**
- Show Manufacturing_Inventory
- WIP ingredients per branch
- Issued quantities, costs

**3. Retail Products Report**
- Show Retail_Stock
- Products per branch
- QtyOnHand, AverageCost, selling price
- Stock value

#### **C. Stock Adjustment Forms**
- Stockroom adjustments (RawMaterials)
- Retail adjustments (Retail_Stock)
- Manufacturing adjustments (Manufacturing_Inventory)
- All with ledger entries (DR/CR Inventory, Variance accounts)

---

### **3. MENU WIRING**

#### **Stockroom Menu**
✅ Stock Transfers (wired)
✅ Suppliers (wired)
✅ Purchase Orders (wired)
✅ Stock Movement Report (wired)
❌ Invoice Capture (needs wiring to InvoiceCaptureService)
❌ Stockroom Stock Report (needs creation + wiring)

#### **Manufacturing Menu**
✅ Build Product (wired)
✅ Complete Build (wired)
✅ BOM Management (wired)
❌ Issue to Manufacturing (needs wiring - form created)
❌ Manufacturing Stock Report (needs creation + wiring)

#### **Retail Menu**
✅ Inventory Report (wired)
✅ Low Stock Report (wired)
✅ Product Catalog (wired)
❌ Retail Products Report (needs creation + wiring)

#### **Accounting Menu**
✅ Supplier Ledger (wired)
❌ Pay Supplier Invoice (needs creation + wiring)
❌ Accounts Payable Report (needs creation + wiring)

---

### **4. LEDGER INTEGRATION CHECKLIST**

#### **Purchase Order → Invoice Capture**
✅ DR Inventory (Stockroom or Retail)
✅ DR VAT Input
✅ CR Accounts Payable (Creditor)
**Status:** InvoiceCaptureService created, needs wiring

#### **Issue to Manufacturing**
✅ DR Manufacturing Inventory
✅ CR Stockroom Inventory
**Status:** IssueToManufacturingForm created, needs wiring

#### **Complete Manufacturing Build**
❌ DR Finished Goods Inventory (Retail_Stock)
❌ CR Manufacturing Inventory
**Status:** Needs implementation in CompleteBuildForm

#### **Inter-Branch Transfer**
❌ Sender: DR Inter-Branch Debtors, CR Inventory
❌ Receiver: DR Inventory, CR Inter-Branch Creditors
**Status:** StockTransferForm exists, needs ledger entries

#### **Pay Supplier Invoice**
❌ DR Accounts Payable
❌ CR Bank/Cash
**Status:** Needs form creation

#### **Stock Adjustments**
❌ Write-off: DR Cost of Sales, CR Inventory
❌ Gain: DR Inventory, CR Variance Income
**Status:** Needs forms creation

---

### **5. ACCOUNTS PAYABLE WORKFLOW**

**Current State:**
- SupplierLedgerForm shows supplier transactions
- Can view outstanding invoices

**Needs:**
1. **Invoice Payment Form:**
   - Select supplier
   - Show unpaid invoices
   - Enter payment details
   - Create payment record
   - Update invoice status
   - Create ledger entries

2. **Payment Methods:**
   - Cash
   - Bank Transfer
   - Check
   - Credit Note

3. **Ledger Entries:**
   ```
   DR Accounts Payable (Creditor)  R 1,000
   CR Bank Account                 R 1,000
   ```

---

## PRIORITY ACTION ITEMS

### **HIGH PRIORITY**
1. ✅ Fix PurchaseOrderForm Key/Value errors (DONE)
2. ✅ Create InvoiceCaptureService (DONE)
3. ✅ Create IssueToManufacturingForm (DONE)
4. ❌ Wire InvoiceGRVForm to use InvoiceCaptureService
5. ❌ Update CompleteBuildForm to use Manufacturing_Inventory
6. ❌ Create Supplier Invoice Payment Form
7. ❌ Add ledger entries to StockTransferForm

### **MEDIUM PRIORITY**
8. ❌ Create 3 Stock Reports (Stockroom, Manufacturing, Retail)
9. ❌ Create Stock Adjustment forms
10. ❌ Wire all new forms to MainDashboard menus

### **LOW PRIORITY**
11. ❌ Add "Pay Invoice" button to SupplierLedgerForm
12. ❌ Create Accounts Payable aging report
13. ❌ Add payment history to supplier ledger

---

## DATABASE SCRIPTS TO RUN (In Order)

1. ✅ Create_Manufacturing_Inventory_Table.sql
2. ✅ Create_InterBranchTransfers_Table.sql
3. ✅ Update_Products_ItemType_And_LastPaid.sql
4. ✅ Create_ProductPricing_Table.sql
5. ❌ Create_SupplierInvoices_Table.sql (NEEDS CREATION)
6. ❌ Create_SupplierPayments_Table.sql (NEEDS CREATION)

---

**Document Version:** 1.0  
**Last Updated:** 2025-09-30 21:10  
**Status:** ACTIVE AUDIT
