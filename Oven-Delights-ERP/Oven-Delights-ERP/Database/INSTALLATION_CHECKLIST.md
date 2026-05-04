# Installation Checklist - Product Price History & PO Integration

## STEP 1: Run SQL Scripts (In Order)

### Script 1: Create_ProductPriceHistory_Table.sql
**Purpose**: Creates price history tracking system

**What it creates**:
- `ProductPriceHistory` table
- `vw_LatestProductPrices` view
- `sp_GetLatestProductPrice` stored procedure
- `sp_RecordProductPriceFromInvoice` stored procedure

**Run in**: Azure SQL Query Editor or SSMS

**Expected Result**:
```
ProductPriceHistory table created successfully
vw_LatestProductPrices view created successfully
sp_GetLatestProductPrice procedure created successfully
sp_RecordProductPriceFromInvoice procedure created successfully
```

**If you see errors**: Check error messages below

---

### Script 2: sp_SaveProductToAllBranches.sql
**Purpose**: Creates stored procedures for product management

**What it creates**:
- `sp_SaveProductToAllBranches` stored procedure
- `sp_UpdateProductCostAllBranches` stored procedure

**Run in**: Azure SQL Query Editor or SSMS

**Expected Result**:
```
sp_SaveProductToAllBranches procedure created successfully
sp_UpdateProductCostAllBranches procedure created successfully
```

---

## STEP 2: Rebuild ERP Application

### Files Modified:
1. `AddProductForm.vb` - Now uses `sp_SaveProductToAllBranches`
2. `PurchaseOrderFormNew.vb` - Now calls `sp_GetLatestProductPrice`

### Build Steps:
1. Open ERP solution in Visual Studio
2. Build > Rebuild Solution
3. Fix any compilation errors
4. Test the application

---

## STEP 3: Verify PO Last Paid Price

### Test Procedure:

**A. Create Test Price History**:
```sql
-- Insert test price history record
EXEC sp_RecordProductPriceFromInvoice
    @ProductID = 123,
    @SKU = '2000000123',
    @ProductName = 'Test Product',
    @SupplierID = 1,
    @SupplierName = 'Test Supplier',
    @InvoiceNumber = 'INV-TEST-001',
    @InvoiceDate = '2024-12-10',
    @CostPrice = 45.50,
    @Quantity = 100,
    @UnitOfMeasure = 'Each',
    @BranchID = 1,
    @CapturedBy = 'Admin'
```

**B. Verify Price History**:
```sql
-- Check price was recorded
SELECT * FROM ProductPriceHistory
WHERE ProductID = 123
ORDER BY InvoiceDate DESC

-- Check view shows latest price
SELECT * FROM vw_LatestProductPrices
WHERE ProductID = 123
```

**C. Test in PO Form**:
1. Open Purchase Order form
2. Add product (ID 123)
3. Check "Last Paid" column shows R 45.50
4. Hover over "Last Paid" cell
5. Tooltip should show: "Last purchased from Test Supplier on 2024-12-10"

---

## STEP 4: Invoice Capture Integration (TODO)

**Need to update Invoice Capture forms to call `sp_RecordProductPriceFromInvoice`**

### Find Invoice Capture Forms:
```
Search for: "Invoice" AND "Capture" in Forms folder
Look for: SaveInvoice, CaptureInvoice, ProcessInvoice methods
```

### Add This Code:
```vb
' After saving invoice lines, record price history
For Each lineItem In invoiceLines
    Using cmd As New SqlCommand("sp_RecordProductPriceFromInvoice", conn)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.AddWithValue("@ProductID", lineItem.ProductID)
        cmd.Parameters.AddWithValue("@SKU", lineItem.SKU)
        cmd.Parameters.AddWithValue("@ProductName", lineItem.ProductName)
        cmd.Parameters.AddWithValue("@SupplierID", currentSupplierID)
        cmd.Parameters.AddWithValue("@SupplierName", currentSupplierName)
        cmd.Parameters.AddWithValue("@InvoiceNumber", invoiceNumber)
        cmd.Parameters.AddWithValue("@InvoiceDate", invoiceDate)
        cmd.Parameters.AddWithValue("@CostPrice", lineItem.UnitCost)
        cmd.Parameters.AddWithValue("@Quantity", lineItem.Quantity)
        cmd.Parameters.AddWithValue("@UnitOfMeasure", lineItem.UOM)
        cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
        cmd.Parameters.AddWithValue("@CapturedBy", currentUsername)
        cmd.ExecuteNonQuery()
    End Using
Next
```

---

## COMMON ERRORS & FIXES

### Error: "Invalid column name 'ProductName'"
**Fix**: Already fixed - uses `p.Name AS ProductName` in view

### Error: "Invalid column name 'Cost'"
**Fix**: Already fixed - uses `Demo_Retail_Price.CostPrice`

### Error: "Invalid column name 'LastUpdated'"
**Fix**: Already fixed - removed `LastUpdated` references

### Error: "Invalid column name 'ProductID' in Demo_Retail_Stock"
**Fix**: Already fixed - removed Demo_Retail_Stock insert (uses VariantID)

### Error: "Procedure already exists"
**Solution**: Scripts include `DROP PROCEDURE IF EXISTS` - just re-run

---

## VERIFICATION QUERIES

### 1. Check Price History Table Exists:
```sql
SELECT COUNT(*) FROM ProductPriceHistory
```

### 2. Check Latest Prices View:
```sql
SELECT TOP 10 * FROM vw_LatestProductPrices
```

### 3. Test Get Latest Price:
```sql
EXEC sp_GetLatestProductPrice @ProductID = 123, @BranchID = 1
```

### 4. Check PO Form Query:
```sql
-- This is what PO form runs when you add a product
DECLARE @ProductID INT = 123
DECLARE @BranchID INT = 1

-- Get latest price from history
EXEC sp_GetLatestProductPrice @ProductID, @BranchID

-- Get current cost from Demo_Retail_Price
SELECT ISNULL(rp.CostPrice, 0), ISNULL(p.IsVatable, 1)
FROM Demo_Retail_Product p
LEFT JOIN Demo_Retail_Price rp ON p.ProductID = rp.ProductID AND p.BranchID = rp.BranchID
WHERE p.ProductID = @ProductID AND p.BranchID = @BranchID
```

---

## SUCCESS CRITERIA

✅ **SQL Scripts run without errors**
✅ **ERP rebuilds successfully**
✅ **PO form shows "Last Paid" price**
✅ **Tooltip shows supplier and date**
✅ **Unit Price auto-fills with last paid price**
✅ **Invoice capture records price history** (after Step 4)

---

## ROLLBACK (If Needed)

```sql
-- Remove all objects created
DROP PROCEDURE IF EXISTS sp_RecordProductPriceFromInvoice
DROP PROCEDURE IF EXISTS sp_GetLatestProductPrice
DROP PROCEDURE IF EXISTS sp_UpdateProductCostAllBranches
DROP PROCEDURE IF EXISTS sp_SaveProductToAllBranches
DROP VIEW IF EXISTS vw_LatestProductPrices
DROP TABLE IF EXISTS ProductPriceHistory
```

---

## NEXT STEPS AFTER INSTALLATION

1. **Train users** on new PO features
2. **Update invoice capture forms** (Step 4)
3. **Monitor price history** for accuracy
4. **Generate price variance reports**
5. **Use for supplier negotiations**

---

## SUPPORT QUERIES

### Price History Report:
```sql
SELECT 
    p.Name AS ProductName,
    ph.SupplierName,
    ph.InvoiceDate,
    ph.CostPrice,
    b.BranchName
FROM ProductPriceHistory ph
INNER JOIN Demo_Retail_Product p ON p.ProductID = ph.ProductID
INNER JOIN Branches b ON b.BranchID = ph.BranchID
WHERE ph.InvoiceDate >= DATEADD(MONTH, -3, GETDATE())
ORDER BY p.Name, ph.InvoiceDate DESC
```

### Price Variance Report:
```sql
SELECT 
    p.Name AS ProductName,
    MIN(ph.CostPrice) AS LowestPrice,
    MAX(ph.CostPrice) AS HighestPrice,
    AVG(ph.CostPrice) AS AveragePrice,
    MAX(ph.CostPrice) - MIN(ph.CostPrice) AS PriceVariance,
    COUNT(*) AS PriceChanges
FROM ProductPriceHistory ph
INNER JOIN Demo_Retail_Product p ON p.ProductID = ph.ProductID
WHERE ph.InvoiceDate >= DATEADD(MONTH, -6, GETDATE())
GROUP BY p.Name
HAVING COUNT(*) > 1
ORDER BY PriceVariance DESC
```
