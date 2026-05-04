# ✅ FIX ALL RETAIL STOCK REFERENCES

## Critical Change Required

**ALL references to `Retail_Stock` must be changed to `Demo_Retail_Stock`**

This affects:
- All reports
- All sales queries
- All inventory queries
- All stock movements
- All price management

---

## Files That Need Updating

### 1. Services\InvoiceCaptureService.vb (5 occurrences)
- Line 153: `FROM Retail_Stock WHERE`
- Line 183: `FROM Retail_Stock WHERE`
- Line 194: `UPDATE Retail_Stock SET`
- Line 212: `INSERT INTO Retail_Stock`
- Line 226: `INSERT INTO Retail_StockMovements`

### 2. Forms\Retail\RetailInventoryAdjustmentForm.vb (4 occurrences)

### 3. Forms\StockTransferForm.vb (4 occurrences)

### 4. Forms\Retail\PriceManagementForm.vb (3 occurrences)

### 5. Services\StockroomService.vb (3 occurrences)

### 6. Forms\Reports\RetailProductsStockReportForm.vb (1 occurrence)

### 7. Forms\Stockroom\InvoiceGRVForm.vb (1 occurrence)

### 8. Services\GRVService.vb (1 occurrence)

---

## Global Find & Replace

**Find:** `Retail_Stock`
**Replace:** `Demo_Retail_Stock`

**Find:** `Retail_StockMovements`
**Replace:** `Demo_Retail_StockMovements`

---

## IMPORTANT

This is a GLOBAL change affecting the entire application.

**After making these changes:**
1. Rebuild solution
2. Test ALL retail reports
3. Test ALL stock movements
4. Test ALL sales queries
5. Test inventory adjustments

---

## Summary

**Change ALL occurrences of:**
- `Retail_Stock` → `Demo_Retail_Stock`
- `Retail_StockMovements` → `Demo_Retail_StockMovements`

**This ensures all retail operations use the correct demo tables!**
