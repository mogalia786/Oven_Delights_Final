# 📊 COMPLETE WORKFLOW: PO → SALE
## Oven Delights ERP - End-to-End Process with Journal & Ledger Entries

---

## 🎯 KEY PRINCIPLES

### **1. UNIVERSAL PRODUCTS, BRANCH-SPECIFIC STOCK & PRICING**
- **Products** table: Universal across all branches (no BranchID)
- **Retail_Stock** table: Branch-specific inventory (includes BranchID)
- **Retail_Price** table: Branch-specific pricing (includes BranchID)
- Each product MUST have: SKU, ProductCode, ProductImage (BLOB)

### **2. STOCK TYPES (Only 2)**
- **Internal Stock**: Products manufactured/baked by manufacturer (`ItemType = 'Internal'`)
- **External Stock**: Ready-made products purchased (`ItemType = 'External'`, NOT raw materials)

### **3. BRANCH FILTERING**
- Regular users: See only their branch data (auto-filtered by `AppSession.CurrentBranchID`)
- Super Administrator: Can select which branch to view (dropdown)

---

## 📋 WORKFLOW STEPS

### **SCENARIO A: EXTERNAL STOCK (Ready-Made Products)**

```
Purchase Order → Invoice Capture → Retail_Stock → Set Price → Sale
```

#### **Step A1: Create Purchase Order**
**Form:** `PurchaseOrderForm`

**User Action:**
1. Select Supplier
2. Add External Products (e.g., Coca-Cola, Bread from supplier)
3. Enter quantities and unit costs
4. **Display:** LastPaidPrice, AverageCost from previous purchases
5. Save PO

**Database:**
```sql
INSERT INTO PurchaseOrders (SupplierID, BranchID, PODate, Status, CreatedBy)
VALUES (@SupplierID, @CurrentBranchID, GETDATE(), 'Pending', @UserID);

INSERT INTO PurchaseOrderLines (POID, ProductID, Quantity, UnitCost)
VALUES (@POID, @ProductID, @Qty, @Cost);
```

**Journal/Ledger:** NONE (commitment only, not yet received)

---

#### **Step A2: Capture Invoice (External Products)**
**Form:** `InvoiceCaptureForm`

**User Action:**
1. Select Supplier
2. Select PO
3. Enter delivery note number
4. Enter quantities received
5. **System checks:** `Products.ItemType = 'External'`
6. Save invoice

**Database:**
```sql
-- Update Retail_Stock (branch-specific)
IF EXISTS (SELECT 1 FROM Retail_Stock WHERE VariantID = @VariantID AND BranchID = @BranchID)
    UPDATE Retail_Stock 
    SET QtyOnHand = QtyOnHand + @Qty,
        UpdatedAt = GETDATE()
    WHERE VariantID = @VariantID AND BranchID = @BranchID;
ELSE
    INSERT INTO Retail_Stock (VariantID, BranchID, QtyOnHand, ReorderPoint)
    VALUES (@VariantID, @BranchID, @Qty, 10);

-- Record movement
INSERT INTO Retail_StockMovements (VariantID, BranchID, QtyDelta, Reason, Ref1, CreatedBy)
VALUES (@VariantID, @BranchID, @Qty, 'Purchase', @InvoiceNumber, @UserID);

-- Update product costs
UPDATE Retail_Product 
SET LastPaidPrice = @UnitCost,
    AverageCost = (AverageCost * OldQty + @UnitCost * @Qty) / (OldQty + @Qty);

-- Create supplier invoice
INSERT INTO SupplierInvoices (InvoiceNumber, SupplierID, BranchID, InvoiceDate, SubTotal, VATAmount, TotalAmount, Status)
VALUES (@InvoiceNum, @SupplierID, @BranchID, GETDATE(), @SubTotal, @VAT, @Total, 'Unpaid');
```

**Journal Entries:**
```
DR  Inventory (1200)                 R 1,000.00
DR  VAT Input (1300)                 R   150.00
    CR  Accounts Payable (2100)                  R 1,150.00
    
Description: Purchase of External Products - Invoice #INV001
BranchID: [Current Branch]
```

**Ledger Impact:**
- **Inventory Ledger:** +R 1,000.00 (asset increase)
- **Accounts Payable Ledger:** +R 1,150.00 (liability increase)
- **VAT Ledger:** +R 150.00 (recoverable VAT)

---

#### **Step A3: Set Selling Price**
**Form:** Product Pricing Form (needs enhancement)

**User Action:**
1. System checks: `SELECT * FROM Retail_Price WHERE ProductID = X AND BranchID = Y`
2. **IF NOT EXISTS:** Show warning above menu: "⚠️ Some products missing prices"
3. Open pricing form:
   - Select/Create Category (with image upload)
   - Select/Create Subcategory (with image upload)
   - Upload Product Image (store as BLOB in `Retail_Product.ProductImage`)
   - Set SellingPrice for this branch
   - Set EffectiveFrom date

**Database:**
```sql
-- Insert/Update price
INSERT INTO Retail_Price (ProductID, BranchID, SellingPrice, Currency, EffectiveFrom)
VALUES (@ProductID, @BranchID, @Price, 'ZAR', GETDATE());

-- Update product image
UPDATE Retail_Product 
SET ProductImage = @ImageBlob
WHERE ProductID = @ProductID;

-- Category/Subcategory images
UPDATE Categories SET CategoryImage = @ImageBlob WHERE CategoryID = @CatID;
UPDATE Subcategories SET SubcategoryImage = @ImageBlob WHERE SubcategoryID = @SubID;
```

**Journal/Ledger:** NONE (pricing setup only)

---

#### **Step A4: Sale (Point of Sale)**
**Form:** POS System (separate lightweight project)

**User Action:**
1. Scan barcode or select product
2. Add to cart
3. Process payment (Cash/Card/Account)
4. Print receipt

**Database:**
```sql
-- Reduce stock
UPDATE Retail_Stock 
SET QtyOnHand = QtyOnHand - @QtySold
WHERE VariantID = @VariantID AND BranchID = @BranchID;

-- Record movement
INSERT INTO Retail_StockMovements (VariantID, BranchID, QtyDelta, Reason, Ref1, CreatedBy)
VALUES (@VariantID, @BranchID, -@QtySold, 'Sale', @ReceiptNo, @UserID);

-- Create sale record
INSERT INTO Sales (BranchID, SaleDate, CustomerID, TotalAmount, PaymentMethod, CreatedBy)
VALUES (@BranchID, GETDATE(), @CustomerID, @Total, @Method, @UserID);
```

**Journal Entries:**
```
-- Revenue recognition
DR  Cash/Debtors (1050/1100)         R 1,150.00
    CR  Sales Revenue (4000)                     R 1,000.00
    CR  VAT Output (2300)                        R   150.00

-- Cost of sales
DR  Cost of Sales (5000)             R   500.00
    CR  Inventory (1200)                         R   500.00
    
Description: Sale - Receipt #REC001
BranchID: [Current Branch]
```

**Ledger Impact:**
- **Sales Ledger:** +R 1,000.00 (revenue)
- **Inventory Ledger:** -R 500.00 (asset decrease)
- **Cost of Sales Ledger:** +R 500.00 (expense)
- **Cash Ledger:** +R 1,150.00 (asset increase)
- **VAT Ledger:** +R 150.00 (output VAT payable)

---

### **SCENARIO B: INTERNAL STOCK (Manufactured Products)**

```
Purchase Raw Materials → BOM Request → Stockroom Fulfills → 
Manufacturer Completes → Retail_Stock → Set Price → Sale
```

#### **Step B1: Purchase Raw Materials**
**Form:** `PurchaseOrderForm`

**User Action:**
1. Select Supplier
2. Add Raw Materials (e.g., Flour, Butter, Sugar)
3. Enter quantities and unit costs
4. **Display:** LastPaidPrice, AverageCost
5. Save PO

**Database:**
```sql
INSERT INTO PurchaseOrders (SupplierID, BranchID, PODate, Status, CreatedBy)
VALUES (@SupplierID, @CurrentBranchID, GETDATE(), 'Pending', @UserID);

INSERT INTO PurchaseOrderLines (POID, MaterialID, Quantity, UnitCost, ItemType)
VALUES (@POID, @MaterialID, @Qty, @Cost, 'RawMaterial');
```

**Journal/Ledger:** NONE (commitment only)

---

#### **Step B2: Capture Invoice (Raw Materials)**
**Form:** `InvoiceCaptureForm`

**User Action:**
1. Select Supplier
2. Select PO
3. Enter delivery note
4. Enter quantities received
5. **System checks:** `ItemType = 'RawMaterial'`
6. Save invoice

**Database:**
```sql
-- Update RawMaterials stock (branch-specific)
UPDATE RawMaterials 
SET CurrentStock = CurrentStock + @Qty,
    LastPaidPrice = @UnitCost,
    AverageCost = (AverageCost * OldQty + @UnitCost * @Qty) / (OldQty + @Qty)
WHERE MaterialID = @MaterialID;

-- Record movement (with BranchID)
INSERT INTO RawMaterialMovements (MaterialID, BranchID, MovementType, Quantity, Reason, CreatedBy)
VALUES (@MaterialID, @BranchID, 'IN', @Qty, 'Purchase - PO #' + @PONumber, @UserID);

-- Create supplier invoice
INSERT INTO SupplierInvoices (InvoiceNumber, SupplierID, BranchID, InvoiceDate, SubTotal, VATAmount, TotalAmount, Status)
VALUES (@InvoiceNum, @SupplierID, @BranchID, GETDATE(), @SubTotal, @VAT, @Total, 'Unpaid');
```

**Journal Entries:**
```
DR  Inventory - Raw Materials (1200)    R 2,000.00
DR  VAT Input (1300)                    R   300.00
    CR  Accounts Payable (2100)                      R 2,300.00
    
Description: Purchase of Raw Materials - Invoice #INV002
BranchID: [Current Branch]
```

**Ledger Impact:**
- **Inventory Ledger:** +R 2,000.00 (raw materials)
- **Accounts Payable Ledger:** +R 2,300.00 (liability)
- **VAT Ledger:** +R 300.00 (recoverable)

---

#### **Step B3: BOM Request (Manufacturer Requests Ingredients)**
**Form:** `BuildProductForm` or `BOMCreateForm`

**User Action:**
1. Manufacturer selects product to make
2. System displays BOM (Bill of Materials)
3. Enter quantity to produce
4. Create request
5. Assign to specific user (baker) based on workload

**Database:**
```sql
-- Create internal order
INSERT INTO InternalOrderHeader (ProductID, BranchID, QuantityOrdered, RequestedBy, Status, CreatedDate)
VALUES (@ProductID, @BranchID, @Qty, @UserID, 'Pending', GETDATE());

-- Create BOM task
INSERT INTO BomTaskStatus (InternalOrderID, AssignedUserID, Status, CreatedAtUtc)
VALUES (@OrderID, @BakerUserID, 'Pending', GETDATE());
```

**Journal/Ledger:** NONE (internal request only)

---

#### **Step B4: Stockroom Fulfills Request**
**Form:** Stockroom Fulfillment Form

**User Action:**
1. Stockroom sees pending BOM requests
2. **Check stock:** `RawMaterials.CurrentStock >= Required`
3. **IF YES:** Fulfill
4. **IF NO:** Create PO to purchase missing ingredients (go to Step B1)

**Database:**
```sql
-- Reduce Stockroom inventory
UPDATE RawMaterials 
SET CurrentStock = CurrentStock - @QtyRequired
WHERE MaterialID = @MaterialID;

-- Record movement
INSERT INTO RawMaterialMovements (MaterialID, BranchID, MovementType, Quantity, Reason, CreatedBy)
VALUES (@MaterialID, @BranchID, 'OUT', -@QtyRequired, 'Issued to Manufacturing - Order #' + @OrderID, @UserID);

-- Increase Manufacturing inventory
IF EXISTS (SELECT 1 FROM Manufacturing_Inventory WHERE MaterialID = @MaterialID AND BranchID = @BranchID)
    UPDATE Manufacturing_Inventory 
    SET QtyOnHand = QtyOnHand + @QtyRequired,
        LastUpdated = GETDATE()
    WHERE MaterialID = @MaterialID AND BranchID = @BranchID;
ELSE
    INSERT INTO Manufacturing_Inventory (MaterialID, BranchID, QtyOnHand, AverageCost)
    VALUES (@MaterialID, @BranchID, @QtyRequired, @AvgCost);

-- Record manufacturing movement
INSERT INTO Manufacturing_InventoryMovements (MaterialID, BranchID, MovementType, Quantity, Reason, CreatedBy)
VALUES (@MaterialID, @BranchID, 'IN', @QtyRequired, 'From Stockroom - Order #' + @OrderID, @UserID);

-- Update order status
UPDATE InternalOrderHeader SET Status = 'Fulfilled' WHERE InternalOrderID = @OrderID;
```

**Journal Entries:**
```
DR  Manufacturing Inventory (1210)       R 1,500.00
    CR  Stockroom Inventory (1200)                   R 1,500.00
    
Description: Materials issued to manufacturing - Order #MO001
BranchID: [Current Branch]
```

**Ledger Impact:**
- **Manufacturing Inventory Ledger:** +R 1,500.00 (WIP)
- **Stockroom Inventory Ledger:** -R 1,500.00 (materials moved)

---

#### **Step B5: Manufacturer Dashboard Shows Task**
**Form:** `Manufacturing.UserDashboardForm`

**User Action:**
1. Baker logs in
2. Dashboard shows assigned tasks (flashing/highlighted)
3. Task count updates in real-time
4. Baker clicks task or their name

**Database:**
```sql
-- Query for user's tasks
SELECT * FROM BomTaskStatus 
WHERE AssignedUserID = @UserID 
AND Status = 'Pending'
AND BranchID = @BranchID
ORDER BY CreatedAtUtc;
```

**Journal/Ledger:** NONE (display only)

---

#### **Step B6: Complete BOM (Manufacturer Completes Product)**
**Form:** `CompleteBuildForm`

**User Action:**
1. Form opens with BOM details
2. Enter quantity completed
3. System calculates cost from ingredients
4. Save completion

**Database:**
```sql
-- Reduce Manufacturing inventory (ingredients consumed)
UPDATE Manufacturing_Inventory 
SET QtyOnHand = QtyOnHand - @QtyUsed
WHERE MaterialID = @MaterialID AND BranchID = @BranchID;

-- Record movement
INSERT INTO Manufacturing_InventoryMovements (MaterialID, BranchID, MovementType, Quantity, Reason, CreatedBy)
VALUES (@MaterialID, @BranchID, 'OUT', -@QtyUsed, 'Consumed in production - Order #' + @OrderID, @UserID);

-- Create/Update product
IF NOT EXISTS (SELECT 1 FROM Retail_Product WHERE ProductCode = @Code)
    INSERT INTO Retail_Product (SKU, ProductCode, Name, ItemType, AverageCost)
    VALUES (@SKU, @Code, @Name, 'Internal', @CalculatedCost);

-- Get/Create variant
EXEC sp_Retail_EnsureVariant @ProductID, @SKU, @VariantID OUTPUT;

-- Add to Retail_Stock (finished product)
IF EXISTS (SELECT 1 FROM Retail_Stock WHERE VariantID = @VariantID AND BranchID = @BranchID)
    UPDATE Retail_Stock 
    SET QtyOnHand = QtyOnHand + @QtyProduced
    WHERE VariantID = @VariantID AND BranchID = @BranchID;
ELSE
    INSERT INTO Retail_Stock (VariantID, BranchID, QtyOnHand, ReorderPoint)
    VALUES (@VariantID, @BranchID, @QtyProduced, 10);

-- Record movement
INSERT INTO Retail_StockMovements (VariantID, BranchID, QtyDelta, Reason, Ref1, CreatedBy)
VALUES (@VariantID, @BranchID, @QtyProduced, 'Production', 'Order #' + @OrderID, @UserID);

-- Update order status
UPDATE InternalOrderHeader SET Status = 'Completed', CompletedDate = GETDATE() WHERE InternalOrderID = @OrderID;
UPDATE BomTaskStatus SET Status = 'Completed', UpdatedAtUtc = GETDATE() WHERE InternalOrderID = @OrderID;
```

**Journal Entries:**
```
DR  Finished Goods Inventory (1220)     R 2,000.00
    CR  Manufacturing Inventory (1210)               R 1,500.00
    CR  Manufacturing Labor (5100)                   R   300.00
    CR  Manufacturing Overhead (5200)                R   200.00
    
Description: Production completed - Order #MO001, 100 units
BranchID: [Current Branch]
```

**Ledger Impact:**
- **Finished Goods Ledger:** +R 2,000.00 (manufactured products)
- **Manufacturing Inventory Ledger:** -R 1,500.00 (materials consumed)
- **Labor Ledger:** +R 300.00 (labor cost allocated)
- **Overhead Ledger:** +R 200.00 (overhead allocated)

---

#### **Step B7: Set Selling Price**
**Same as Step A3** - Set price for manufactured product

---

#### **Step B8: Sale**
**Same as Step A4** - Sell manufactured product

---

### **SCENARIO C: INTER-BRANCH TRANSFER**

```
Branch A (Sender) → Transfer Request → Branch B (Receiver) → Reconciliation
```

#### **Step C1: Create Transfer**
**Form:** `StockTransferForm`

**User Action:**
1. **Super Admin:** Select From Branch and To Branch from dropdown
2. **Regular User:** From Branch = Current Branch (locked), select To Branch
3. Select Product
4. Enter Quantity
5. Enter Reference
6. Save transfer

**Database:**
```sql
-- Create transfer record
INSERT INTO InterBranchTransfers (TransferNumber, FromBranchID, ToBranchID, ProductID, Quantity, TransferDate, Status, CreatedBy)
VALUES (@TransferNum, @FromBranchID, @ToBranchID, @ProductID, @Qty, GETDATE(), 'Pending', @UserID);

-- Reduce sender's stock
UPDATE Retail_Stock 
SET QtyOnHand = QtyOnHand - @Qty
WHERE VariantID = @VariantID AND BranchID = @FromBranchID;

-- Record sender movement
INSERT INTO Retail_StockMovements (VariantID, BranchID, QtyDelta, Reason, Ref1, CreatedBy)
VALUES (@VariantID, @FromBranchID, -@Qty, 'Inter-Branch Transfer Out', @TransferNum, @UserID);

-- Increase receiver's stock
IF EXISTS (SELECT 1 FROM Retail_Stock WHERE VariantID = @VariantID AND BranchID = @ToBranchID)
    UPDATE Retail_Stock 
    SET QtyOnHand = QtyOnHand + @Qty
    WHERE VariantID = @VariantID AND BranchID = @ToBranchID;
ELSE
    INSERT INTO Retail_Stock (VariantID, BranchID, QtyOnHand, ReorderPoint)
    VALUES (@VariantID, @ToBranchID, @Qty, 10);

-- Record receiver movement
INSERT INTO Retail_StockMovements (VariantID, BranchID, QtyDelta, Reason, Ref1, CreatedBy)
VALUES (@VariantID, @ToBranchID, @Qty, 'Inter-Branch Transfer In', @TransferNum, @UserID);

-- Update transfer status
UPDATE InterBranchTransfers SET Status = 'Completed' WHERE TransferNumber = @TransferNum;
```

**Journal Entries (Sender Branch):**
```
DR  Inter-Branch Debtors (1400)          R 1,000.00
    CR  Inventory (1200)                             R 1,000.00
    
Description: Inter-Branch Transfer Out - #TR001 to Branch B
BranchID: [From Branch]
```

**Journal Entries (Receiver Branch):**
```
DR  Inventory (1200)                     R 1,000.00
    CR  Inter-Branch Creditors (2200)                R 1,000.00
    
Description: Inter-Branch Transfer In - #TR001 from Branch A
BranchID: [To Branch]
```

**Ledger Impact:**
- **Sender - Inter-Branch Debtors:** +R 1,000.00 (receivable from other branch)
- **Sender - Inventory:** -R 1,000.00 (stock sent)
- **Receiver - Inventory:** +R 1,000.00 (stock received)
- **Receiver - Inter-Branch Creditors:** +R 1,000.00 (payable to other branch)

---

### **SCENARIO D: SUPPLIER PAYMENT**

```
Outstanding Invoices → Payment Allocation → Ledger Update
```

#### **Step D1: Pay Supplier Invoice**
**Form:** `SupplierPaymentForm`

**User Action:**
1. Select Supplier
2. View outstanding invoices (filtered by current branch)
3. Enter payment amounts
4. Select payment method (Cash/Bank Transfer/Check)
5. Process payment

**Database:**
```sql
-- Create payment record
INSERT INTO SupplierPayments (PaymentNumber, SupplierID, BranchID, PaymentDate, PaymentMethod, PaymentAmount, CreatedBy)
VALUES (@PaymentNum, @SupplierID, @BranchID, GETDATE(), @Method, @Amount, @UserID);

-- Allocate to invoices
INSERT INTO SupplierPaymentAllocations (PaymentID, InvoiceID, AllocatedAmount)
VALUES (@PaymentID, @InvoiceID, @Amount);

-- Update invoice status
UPDATE SupplierInvoices 
SET AmountPaid = AmountPaid + @Amount,
    Status = CASE 
        WHEN AmountPaid + @Amount >= TotalAmount THEN 'Paid'
        WHEN AmountPaid + @Amount > 0 THEN 'PartiallyPaid'
        ELSE Status 
    END
WHERE InvoiceID = @InvoiceID;
```

**Journal Entries:**
```
DR  Accounts Payable (2100)              R 1,150.00
    CR  Bank Account (1050)                          R 1,150.00
    
Description: Payment to Supplier - Invoice #INV001
BranchID: [Current Branch]
```

**Ledger Impact:**
- **Accounts Payable Ledger:** -R 1,150.00 (liability reduced)
- **Bank Ledger:** -R 1,150.00 (cash out)

---

## 📊 LEDGER TYPES & ACCOUNTS

### **Chart of Accounts Structure:**

| Account Code | Account Name | Type | Used In |
|--------------|--------------|------|---------|
| **1000-1999** | **ASSETS** | | |
| 1050 | Bank Account | Asset | Sales, Payments |
| 1100 | Accounts Receivable (Debtors) | Asset | Credit Sales |
| 1200 | Inventory - Stockroom | Asset | Purchases, Transfers |
| 1210 | Inventory - Manufacturing (WIP) | Asset | Manufacturing |
| 1220 | Inventory - Finished Goods | Asset | Production Complete |
| 1300 | VAT Input (Recoverable) | Asset | Purchases |
| 1400 | Inter-Branch Debtors | Asset | Inter-Branch Transfers |
| **2000-2999** | **LIABILITIES** | | |
| 2100 | Accounts Payable (Creditors) | Liability | Supplier Invoices |
| 2200 | Inter-Branch Creditors | Liability | Inter-Branch Transfers |
| 2300 | VAT Output (Payable) | Liability | Sales |
| **4000-4999** | **REVENUE** | | |
| 4000 | Sales Revenue | Revenue | Sales |
| **5000-5999** | **EXPENSES** | | |
| 5000 | Cost of Sales | Expense | Sales |
| 5100 | Manufacturing Labor | Expense | Production |
| 5200 | Manufacturing Overhead | Expense | Production |

### **Ledger Viewer Dropdown:**
```
┌─────────────────────────────────────┐
│ Select Ledger Type:                 │
├─────────────────────────────────────┤
│ ► All Ledgers                       │
│ ► Suppliers (Accounts Payable)      │
│ ► Customers (Accounts Receivable)   │
│ ► Inventory (Stock Movements)       │
│ ► Bank (Cash Flow)                  │
│ ► Sales (Revenue)                   │
│ ► Expenses (Operating Costs)        │
│ ► VAT (Tax)                         │
│ ► Inter-Branch (Transfers)          │
│ ► Manufacturing (WIP & Production)  │
└─────────────────────────────────────┘
```

**Filter Query:**
```sql
SELECT j.JournalID, j.JournalDate, j.Reference, j.Description,
       a.AccountCode, a.AccountName, a.AccountType,
       jd.Debit, jd.Credit, j.BranchID, b.BranchName
FROM JournalHeaders j
INNER JOIN JournalDetails jd ON j.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts a ON jd.AccountID = a.AccountID
INNER JOIN Branches b ON j.BranchID = b.BranchID
WHERE (@LedgerType = 'All' OR a.AccountType = @LedgerType)
  AND (@BranchID IS NULL OR j.BranchID = @BranchID) -- Super Admin can view all
ORDER BY j.JournalDate DESC, j.JournalID;
```

---

## 🔧 REQUIRED FIXES

### **1. StockTransferForm - Branch Dropdown**
**Current Issue:** Shows "Main Branch" instead of actual branch names

**Fix:**
```vb
Private Sub LoadBranches()
    Using con As New SqlConnection(connectionString)
        Dim sql = "SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1 ORDER BY BranchName"
        Using ad As New SqlDataAdapter(sql, con)
            Dim dt As New DataTable()
            ad.Fill(dt)
            
            ' From Branch
            cboFromBranch.DataSource = dt.Copy()
            cboFromBranch.DisplayMember = "BranchName"
            cboFromBranch.ValueMember = "BranchID"
            
            ' To Branch
            cboToBranch.DataSource = dt.Copy()
            cboToBranch.DisplayMember = "BranchName"
            cboToBranch.ValueMember = "BranchID"
            
            ' If not Super Admin, lock From Branch to current branch
            If Not IsSuperAdmin() Then
                cboFromBranch.SelectedValue = AppSession.CurrentBranchID
                cboFromBranch.Enabled = False
            End If
        End Using
    End Using
End Sub
```

---

### **2. Add BranchID to Retail_Product & Retail_Price Queries**
**Current Issue:** Not filtering by BranchID

**Fix:** Already exists in schema! `Retail_Price` has BranchID (line 42), `Retail_Stock` has BranchID (line 60)

**Ensure all queries include:**
```sql
-- When viewing stock
SELECT * FROM Retail_Stock WHERE BranchID = @CurrentBranchID;

-- When viewing prices
SELECT * FROM Retail_Price WHERE BranchID = @CurrentBranchID;
```

---

### **3. Price Warning Above Menu**
**Add to MainDashboard:**
```vb
Private Sub CheckMissingPrices()
    Dim branchId = AppSession.CurrentBranchID
    Dim sql = "SELECT COUNT(*) FROM Retail_Stock rs " &
              "LEFT JOIN Retail_Price rp ON rs.VariantID = rp.ProductID AND rp.BranchID = @BranchID " &
              "WHERE rs.BranchID = @BranchID AND rs.QtyOnHand > 0 AND rp.PriceID IS NULL"
    
    ' If count > 0, show warning label
    If missingCount > 0 Then
        lblWarning.Text = $"⚠️ {missingCount} products missing selling prices"
        lblWarning.Visible = True
        lblWarning.BackColor = Color.Orange
    End If
End Sub
```

---

### **4. Product/Category Image Upload**
**Add to Pricing Form:**
```vb
Private Sub btnUploadImage_Click(sender As Object, e As EventArgs)
    Dim ofd As New OpenFileDialog With {
        .Filter = "Image Files|*.jpg;*.jpeg;*.png;*.bmp;*.gif",
        .Title = "Select Product Image"
    }
    
    If ofd.ShowDialog() = DialogResult.OK Then
        Dim imageBytes() As Byte = File.ReadAllBytes(ofd.FileName)
        
        ' Save to database
        Using con As New SqlConnection(connectionString)
            con.Open()
            Dim sql = "UPDATE Retail_Product SET ProductImage = @Image WHERE ProductID = @ID"
            Using cmd As New SqlCommand(sql, con)
                cmd.Parameters.AddWithValue("@Image", imageBytes)
                cmd.Parameters.AddWithValue("@ID", productId)
                cmd.ExecuteNonQuery()
            End Using
        End Using
        
        ' Display preview
        Using ms As New MemoryStream(imageBytes)
            pbProductImage.Image = Image.FromStream(ms)
        End Using
    End If
End Sub
```

---

### **5. Manufacturing_Inventory vs Manufacturing_Product**
**Clarification:**
- **Manufacturing_Inventory:** WIP ingredients (what's being used to make products)
- **Manufacturing_Product:** Finished products that were manufactured (now in Retail_Stock)

**Tables:**
- `Manufacturing_Inventory` (MaterialID, BranchID, QtyOnHand) - Ingredients in production
- `Retail_Product` with `ItemType = 'Internal'` - Manufactured finished products

---

## ✅ SUMMARY

**Complete Flow:**
1. **Purchase** → Inventory + Accounts Payable
2. **Manufacturing** → WIP Inventory → Finished Goods
3. **Pricing** → Set selling prices per branch
4. **Sale** → Revenue + Cost of Sales
5. **Transfer** → Inter-Branch Debtors/Creditors
6. **Payment** → Reduce Accounts Payable

**All transactions:**
- ✅ Include BranchID
- ✅ Create journal entries
- ✅ Update ledgers
- ✅ Track movements
- ✅ Maintain audit trail

**POS System:**
- Separate lightweight project
- Connects to same database
- Reads Retail_Stock, Retail_Price
- Creates Sales, updates Stock
- Minimal code for till points

---

**Document Version:** 1.0  
**Date:** 2025-10-02  
**Status:** COMPREHENSIVE PLAN COMPLETE
