# 📦 COMPLETE WORKFLOW: Purchase Order → Retail Stock
## Step-by-Step Guide with Menu Paths

**Date:** 2025-10-06 18:58  
**Purpose:** Document exact workflow from PO creation to product in retail with price

---

## 🎯 WORKFLOW OVERVIEW

```
Purchase Order → Invoice Capture → Retail Stock (with Price)
```

**For:** External Products (Coca-Cola, Bread, Chips)  
**Time:** ~10 minutes  
**Result:** Product available for POS with price

---

## 📋 STEP-BY-STEP WORKFLOW

### **STEP 1: Create Purchase Order**

**Menu Path:** `Stockroom → Purchase Orders`

**Actions:**
1. Click **Stockroom** menu
2. Click **Purchase Orders**
3. Purchase Order form opens
4. Click **"Create New PO"** or **"Add"** button
5. Fill in PO details:
   - **Supplier:** Select supplier (e.g., Coca-Cola Beverages)
   - **Branch:** Select your branch
   - **Order Date:** Today's date
   - **Required Date:** Delivery date
6. Add product lines:
   - Click **"Add Item"**
   - Select **Product:** Coca-Cola 330ml Can
   - Enter **Quantity:** 100
   - Enter **Unit Price:** R8.50 (cost price)
   - Click **"Add"**
7. Review PO totals
8. Click **"Save"** or **"Submit"**
9. Note the **PO Number** (e.g., PO-2024-001)

**Expected Result:**
- ✅ PO created with status "Pending" or "Submitted"
- ✅ PO Number generated
- ✅ Supplier notified (if email configured)

**Database Tables Updated:**
- `PurchaseOrders` (header)
- `PurchaseOrderDetails` (line items)

---

### **STEP 2: Receive Goods (GRV)**

**Menu Path:** `Stockroom → GRV Management` or `Stockroom → Goods Received`

**Actions:**
1. Click **Stockroom** menu
2. Click **GRV Management**
3. GRV Management form opens
4. Click **"Create GRV"** or **"Receive Goods"**
5. Select **Purchase Order:** PO-2024-001
6. Verify delivery:
   - **Delivery Note Number:** Supplier's delivery note
   - **Received Date:** Today
   - **Received By:** Your name
7. Verify quantities received:
   - Coca-Cola 330ml: **100** units (match PO)
   - Check **"Qty Received"** column
8. Click **"Post GRV"** or **"Complete"**
9. Note the **GRV Number** (e.g., GRV-2024-001)

**Expected Result:**
- ✅ GRV created and posted
- ✅ Stock updated in system
- ✅ PO status changed to "Received" or "Completed"

**Database Tables Updated:**
- `GoodsReceivedNotes` (header)
- `GoodsReceivedNoteDetails` (line items)
- `RawMaterials` OR `Products` (depending on item type)

---

### **STEP 3: Capture Supplier Invoice**

**Menu Path:** `Stockroom → Supplier Invoices` or `Stockroom → Invoice Capture`

**Actions:**
1. Click **Stockroom** menu
2. Click **Supplier Invoices**
3. Invoice Capture form opens
4. Click **"Capture New Invoice"** or **"Add"**
5. Fill in invoice details:
   - **Supplier:** Coca-Cola Beverages (auto-filled from GRV)
   - **Invoice Number:** Supplier's invoice number
   - **Invoice Date:** Date on supplier invoice
   - **Due Date:** Payment due date (e.g., 30 days)
6. Link to GRV:
   - Select **GRV Number:** GRV-2024-001
   - System auto-populates line items from GRV
7. Verify amounts:
   - **Subtotal:** R850.00 (100 × R8.50)
   - **VAT (15%):** R127.50
   - **Total:** R977.50
8. Match to supplier invoice total
9. Click **"Save"** or **"Post"**

**Expected Result:**
- ✅ Invoice captured and linked to GRV
- ✅ Creditor account updated (amount owing)
- ✅ Stock cost updated
- ✅ **Product moved to Retail Stock** (for external products)

**Database Tables Updated:**
- `SupplierInvoices` (invoice header)
- `SupplierInvoiceDetails` (line items)
- `Retail_Stock` (stock quantity and cost) ⭐ **KEY UPDATE**
- `JournalHeaders` & `JournalDetails` (accounting entries)

**Ledger Entries Created:**
```
DR Inventory (Retail_Stock)     R977.50
CR Creditors (Supplier)         R977.50
```

---

### **STEP 4: Set Retail Price**

**Menu Path:** `Retail → Products` or `Retail → Price Management`

**Actions:**
1. Click **Retail** menu
2. Click **Products** or **Price Management**
3. Find product: **Coca-Cola 330ml Can**
4. Click **"Edit"** or **"Set Price"**
5. Enter pricing:
   - **Cost Price:** R8.50 (from invoice)
   - **Markup %:** 41% (or enter selling price directly)
   - **Selling Price:** R12.00
   - **Effective From:** Today
   - **Branch:** Select branch (or All Branches)
6. Click **"Save"**

**Expected Result:**
- ✅ Selling price set for product
- ✅ Price active for selected branch(es)
- ✅ Product ready for POS

**Database Tables Updated:**
- `Retail_Price` (pricing by branch)

---

### **STEP 5: Verify Product Ready for POS**

**Menu Path:** `Retail → Stock` or Query Database

**Verification Query:**
```sql
SELECT 
    p.ProductCode,
    p.ProductName,
    rv.Barcode,
    rp.SellingPrice AS Price,
    rs.QtyOnHand AS Stock,
    rs.AverageCost AS Cost,
    b.BranchName
FROM Products p
INNER JOIN Retail_Variant rv ON p.ProductID = rv.ProductID
INNER JOIN Retail_Price rp ON p.ProductID = rp.ProductID AND rp.EffectiveTo IS NULL
INNER JOIN Retail_Stock rs ON rv.VariantID = rs.VariantID
INNER JOIN Branches b ON rs.BranchID = b.BranchID
WHERE p.ProductName LIKE '%Coca-Cola 330ml%'
AND rs.BranchID = 1; -- Your branch
```

**Expected Result:**
```
ProductCode: BEV-COKE-330
ProductName: Coca-Cola 330ml Can
Barcode: 5449000000996
Price: R12.00
Stock: 100.00
Cost: R8.50
BranchName: Main Branch
```

**Checklist:**
- ✅ Product has barcode
- ✅ Product has selling price (R12.00)
- ✅ Product has stock (100 units)
- ✅ Product has cost (R8.50)
- ✅ Product linked to branch

---

## 🔍 ALTERNATIVE WORKFLOW (For Raw Materials)

### **If Product is Raw Material (Ingredient):**

**Different Path:**
```
Purchase Order → GRV → Invoice Capture → Stockroom Inventory (NOT Retail)
```

**Key Difference:**
- Raw materials go to `RawMaterials` table
- NOT available for retail sale
- Used for manufacturing only
- Must go through BOM → Manufacturing → Complete Build → THEN Retail

---

## 📊 DATABASE FLOW DIAGRAM

```
┌─────────────────┐
│ Purchase Order  │
│  (PO Table)     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Goods Received  │
│  (GRV Table)    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Invoice Capture │
│ (SupplierInv)   │
└────────┬────────┘
         │
         ▼
    ┌────┴────┐
    │         │
    ▼         ▼
┌─────────┐ ┌──────────────┐
│Raw Mat. │ │ Retail_Stock │ ← External Products
│ Table   │ │   + Price    │
└─────────┘ └──────────────┘
    │              │
    │              ▼
    │         ┌─────────┐
    │         │   POS   │
    │         └─────────┘
    ▼
┌──────────────┐
│Manufacturing │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Retail_Stock │
│   + Price    │
└──────────────┘
```

---

## ✅ VERIFICATION CHECKLIST

After completing workflow, verify:

- [ ] PO exists in PurchaseOrders table
- [ ] GRV exists in GoodsReceivedNotes table
- [ ] Invoice exists in SupplierInvoices table
- [ ] Stock exists in Retail_Stock table (for external products)
- [ ] Price exists in Retail_Price table
- [ ] Barcode exists in Retail_Variant table
- [ ] Product visible in POS (when POS is built)
- [ ] Creditor balance updated (amount owing to supplier)
- [ ] Journal entries created (DR Inventory, CR Creditors)

---

## 🚨 COMMON ISSUES

### **Issue 1: Product Not in Retail_Stock**
**Cause:** Product ItemType is not "External"  
**Fix:** Update Products.ItemType = 'External'

### **Issue 2: No Price Showing**
**Cause:** Price not set or expired  
**Fix:** Add price in Retail_Price with EffectiveTo = NULL

### **Issue 3: No Barcode**
**Cause:** Retail_Variant not created  
**Fix:** Add variant with barcode in Retail_Variant table

### **Issue 4: Stock Not Updating**
**Cause:** Invoice capture not triggering stock update  
**Fix:** Check InvoiceCaptureForm code calls stock update procedure

---

## 📝 QUICK REFERENCE

### **Menu Paths:**
1. **Create PO:** Stockroom → Purchase Orders
2. **Receive Goods:** Stockroom → GRV Management
3. **Capture Invoice:** Stockroom → Supplier Invoices
4. **Set Price:** Retail → Products or Price Management
5. **Verify Stock:** Retail → Stock or run verification query

### **Key Tables:**
- PurchaseOrders
- GoodsReceivedNotes
- SupplierInvoices
- Retail_Stock ⭐
- Retail_Price ⭐
- Retail_Variant ⭐

### **Key Columns:**
- Products.ItemType = 'External'
- Retail_Stock.QtyOnHand
- Retail_Stock.AverageCost
- Retail_Price.SellingPrice
- Retail_Variant.Barcode

---

**Workflow Complete!** 🎉

**Next:** Test this workflow with one of the 5 test products created.
