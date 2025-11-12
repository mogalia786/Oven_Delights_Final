# STOCKROOM STOCK FIX - COMPLETE INSTRUCTIONS

## THE PROBLEM
1. **Stockroom Stock Report showing all zeros** - Because `StockroomStock` table is empty
2. **Invoice Capture not updating stock for sub-recipes** - Because MaterialID column might be missing or NULL
3. **Baker always getting shortages** - Because stock is not in branch-specific `StockroomStock` table

## THE ROOT CAUSE
The system was using `RawMaterials.CurrentStock` (shared across branches) but needs to use `StockroomStock` (branch-specific). The `StockroomStock` table exists but is **EMPTY** - it needs to be populated!

## STEP-BY-STEP FIX

### Step 1: Run SQL Migration Script
**IMPORTANT: Do this FIRST before rebuilding!**

1. Open SQL Server Management Studio
2. Connect to your database
3. Open and run: `SQL\FIX_STOCKROOM_STOCK_SYNC.sql`

This script will:
- ✅ Ensure `StockroomStock` table exists
- ✅ Migrate existing stock from `RawMaterials.CurrentStock` to `StockroomStock` for ALL branches
- ✅ Standardize MaterialType spelling (e.g., "Sub Recipe")
- ✅ Create performance indexes
- ✅ Show you a summary of what was migrated

### Step 2: Debug PO Lines (Optional)
If you want to see what's in your Purchase Orders:

1. Open and run: `SQL\DEBUG_PO_LINES.sql`
2. This will show you:
   - PO line structure
   - Whether MaterialID is being set correctly
   - What sub-recipes exist
   - Sample data from latest PO

### Step 3: Rebuild the Application
Now that the database is ready, rebuild:

1. Clean Solution
2. Rebuild Solution
3. Run the application

### Step 4: Test the Complete Flow

#### Test 1: Stockroom Stock Report
1. Go to **Reports → Stockroom Stock Report**
2. You should now see actual stock quantities (not zeros)
3. Verify sub-recipes are listed

#### Test 2: Purchase Order → Invoice Capture
1. Create a new PO with:
   - Some raw materials (e.g., Flour, Sugar)
   - Some sub-recipes (e.g., Dough Mix, Filling)
2. Capture the invoice (GRV)
3. Check the **MaterialID** column in the grid - it should have values
4. Save the invoice
5. Go back to **Stockroom Stock Report** - stock should be updated

#### Test 3: BOM Request
1. Create a recipe that uses sub-recipes
2. Assign to baker
3. Baker requests BOM
4. Should NOT show shortage if stock was received in Test 2

## WHAT WAS FIXED IN CODE

### 1. StockroomService.GetPurchaseOrderLines (Line 3315-3351)
**BEFORE:**
```vb
"CASE WHEN pol.ItemSource = 'PR' THEN pol.ProductID ELSE pol.MaterialID END AS ProductID, "
```
This was aliasing MaterialID as ProductID, so there was no separate MaterialID column!

**AFTER:**
```vb
"pol.MaterialID, " &
"pol.ProductID, " &
"rm.MaterialType, "
```
Now returns separate columns for both IDs plus MaterialType.

### 2. StockroomService.UpdateRawMaterialStock (Line 3518-3560)
**BEFORE:**
```vb
UPDATE RawMaterials SET CurrentStock = CurrentStock + @Quantity
```
Updated shared stock across all branches.

**AFTER:**
```vb
-- Check if record exists in StockroomStock
-- UPDATE or INSERT into StockroomStock (branch-specific)
-- Also update RawMaterials.CurrentStock for legacy compatibility
```
Now updates branch-specific `StockroomStock` table.

### 3. StockroomStockReportForm.LoadReport (Line 20-43)
**BEFORE:**
```vb
"FROM RawMaterials rm " &
"ORDER BY rm.MaterialName"
```
Read only from RawMaterials.CurrentStock.

**AFTER:**
```vb
"FROM RawMaterials rm " &
"LEFT JOIN StockroomStock ss ON ss.ProductID = rm.MaterialID AND ss.BranchID = @BranchID " &
"ORDER BY rm.MaterialName"
```
Now reads from branch-specific StockroomStock.

### 4. BOMEditorForm.CheckIngredientAvailability (Line 1614-1619)
Now checks `StockroomStock` for branch-specific availability.

### 5. InternalOrdersForm.LoadLinesForSelected (Line 349-375)
Now shows available stock from branch-specific `StockroomStock`.

## VERIFICATION QUERIES

After running the migration, verify with these queries:

```sql
-- Check if StockroomStock has data
SELECT 
    b.BranchName,
    COUNT(*) AS ProductCount,
    SUM(ss.Quantity) AS TotalStock
FROM StockroomStock ss
INNER JOIN Branches b ON b.BranchID = ss.BranchID
GROUP BY b.BranchName

-- Check sub-recipes
SELECT 
    MaterialCode,
    MaterialName,
    MaterialType,
    CurrentStock
FROM RawMaterials
WHERE MaterialType LIKE '%recipe%'

-- Check latest PO lines
SELECT TOP 5
    pol.PurchaseOrderID,
    pol.MaterialID,
    pol.ProductID,
    pol.ItemSource,
    rm.MaterialName,
    rm.MaterialType
FROM PurchaseOrderLines pol
LEFT JOIN RawMaterials rm ON rm.MaterialID = pol.MaterialID
ORDER BY pol.PurchaseOrderID DESC
```

## TROUBLESHOOTING

### Issue: Stockroom report still shows zeros
**Solution:** 
1. Did you run `FIX_STOCKROOM_STOCK_SYNC.sql`?
2. Check if StockroomStock table has data (run verification query above)
3. Make sure you rebuilt the application after running SQL

### Issue: MaterialID column is empty in invoice capture
**Solution:**
1. Check if PO was created BEFORE or AFTER the code fix
2. Old POs might have NULL MaterialID - create a new test PO
3. Run `DEBUG_PO_LINES.sql` to see what's in the database

### Issue: Sub-recipes not updating stock
**Solution:**
1. Check MaterialType in RawMaterials - should be exactly "Sub Recipe"
2. Run the standardization part of `FIX_STOCKROOM_STOCK_SYNC.sql`
3. Verify ProductType in invoice capture shows "Raw Material" for sub-recipes

## SUMMARY

The key insight is that **each branch has its own stockroom**. The system now:

1. ✅ Stores stock in `StockroomStock` table (branch-specific)
2. ✅ Updates stock when GRV is captured
3. ✅ Checks stock against branch-specific quantities
4. ✅ Treats sub-recipes as raw materials (ingredients)
5. ✅ Reports show branch-specific stock levels

**CRITICAL:** Run the SQL migration script FIRST, then rebuild!
