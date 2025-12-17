# Purchase Order - Price History Integration

## Overview
Purchase Order form now references `ProductPriceHistory` table to show the last paid price from actual invoice captures, not just static fields.

---

## What Changed

### Before:
- PO showed "Last Paid" from `RawMaterials.LastPaidPrice` (static field)
- No historical tracking
- No supplier/date information
- Manual updates required

### After:
- PO shows "Last Paid" from `ProductPriceHistory` table (actual invoice data)
- Full historical tracking
- Tooltip shows: "Last purchased from [Supplier] on [Date]"
- Automatically updated when invoices are captured

---

## PO Form Behavior

### When Adding Product to PO:

1. **Last Paid Column**:
   - Shows most recent cost price from `ProductPriceHistory`
   - Tooltip displays: `"Last purchased from ABC Suppliers on 2024-12-09"`
   - If no history exists, shows 0.00

2. **Avg Cost Column**:
   - Shows current average cost from `Demo_Retail_Product.Cost`
   - Used as fallback if no price history

3. **Unit Price (Auto-Fill)**:
   - Automatically fills with "Last Paid" if available
   - Falls back to "Avg Cost" if no price history
   - User can override manually

### Example:
```
Product: Bar One Spread
Last Paid: R 45.50 (Tooltip: "Last purchased from ABC Suppliers on 2024-12-09")
Avg Cost: R 42.00
Unit Price: R 45.50 (auto-filled from Last Paid)
```

---

## Integration Points

### 1. Purchase Order Creation (PurchaseOrderFormNew.vb)

**Method: `LoadPricesForProduct()`**
```vb
' Calls sp_GetLatestProductPrice to get:
' - Latest cost price
' - Last purchase date
' - Last supplier name
' - Last invoice number

' Sets tooltip on LastPaid cell:
row.Cells("LastPaid").ToolTipText = "Last purchased from [Supplier] on [Date]"
```

### 2. Invoice Capture (InvoiceCaptureForm.vb - TO BE UPDATED)

**When saving invoice lines, call:**
```vb
For Each lineItem In invoiceLines
    EXEC sp_RecordProductPriceFromInvoice
        @ProductID = lineItem.ProductID,
        @SKU = lineItem.SKU,
        @ProductName = lineItem.ProductName,
        @SupplierID = currentSupplierID,
        @SupplierName = currentSupplierName,
        @InvoiceNumber = invoiceNumber,
        @InvoiceDate = invoiceDate,
        @CostPrice = lineItem.UnitCost,
        @Quantity = lineItem.Quantity,
        @UnitOfMeasure = lineItem.UOM,
        @BranchID = currentBranchID,
        @CapturedBy = currentUsername
Next
```

---

## Benefits

### For Purchasing:
✅ See actual last paid price (not estimates)
✅ Know which supplier and when
✅ Make informed pricing decisions
✅ Identify price increases/decreases

### For Cost Control:
✅ Track price trends over time
✅ Compare supplier pricing
✅ Negotiate better rates with data
✅ Audit trail for all price changes

### For Accuracy:
✅ No manual price updates needed
✅ Automatic from invoice capture
✅ Branch-specific pricing
✅ Real-time data

---

## User Experience

### Creating a PO:

1. **Select Product**:
   - Type product name (autocomplete)
   - Press Enter/Tab

2. **View Price Info**:
   - "Last Paid" column shows latest price
   - Hover over "Last Paid" to see supplier and date
   - "Avg Cost" shows current average

3. **Enter Quantity**:
   - "Unit Price" auto-fills with "Last Paid"
   - Adjust if needed (e.g., negotiated new price)

4. **Tooltip Example**:
   ```
   Hover over "Last Paid: R 45.50"
   Tooltip: "Last purchased from ABC Suppliers on 2024-12-09"
   ```

---

## Data Flow

```
Invoice Capture
    ↓
sp_RecordProductPriceFromInvoice
    ↓
ProductPriceHistory table
    ↓
sp_GetLatestProductPrice
    ↓
Purchase Order Form
    ↓
"Last Paid" column + Tooltip
```

---

## Queries for Verification

### Check Price History for Product:
```sql
SELECT TOP 10
    ph.InvoiceDate,
    ph.SupplierName,
    ph.InvoiceNumber,
    ph.CostPrice,
    ph.Quantity,
    b.BranchName
FROM ProductPriceHistory ph
INNER JOIN Branches b ON b.BranchID = ph.BranchID
WHERE ph.ProductID = 123
ORDER BY ph.InvoiceDate DESC
```

### Get Latest Price (Same as PO uses):
```sql
EXEC sp_GetLatestProductPrice 
    @ProductID = 123, 
    @BranchID = 1
```

### View All Latest Prices:
```sql
SELECT * FROM vw_LatestProductPrices
WHERE BranchID = 1
ORDER BY ProductName
```

---

## Next Steps

### 1. Update Invoice Capture Form:
- Add call to `sp_RecordProductPriceFromInvoice` when saving invoice lines
- Ensure all invoice captures record price history

### 2. Test Workflow:
1. Capture supplier invoice with products
2. Verify price history recorded
3. Create new PO with same products
4. Verify "Last Paid" shows correct price
5. Hover to see tooltip with supplier/date

### 3. Train Users:
- Show tooltip feature
- Explain "Last Paid" vs "Avg Cost"
- Demonstrate price history tracking

---

## Troubleshooting

### "Last Paid" shows 0.00:
- No price history exists for this product
- Capture an invoice first
- Or manually insert price history record

### Tooltip doesn't show:
- Price history exists but tooltip not set
- Check `sp_GetLatestProductPrice` returns data
- Verify `LoadPricesForProduct()` sets tooltip

### Wrong price shown:
- Check `ProductPriceHistory` for correct branch
- Verify invoice was captured for correct branch
- Check date ordering (latest should show)

---

## Files Modified

1. **PurchaseOrderFormNew.vb**
   - Updated `LoadPricesForProduct()` method
   - Now calls `sp_GetLatestProductPrice`
   - Sets tooltip on LastPaid cell

2. **Create_ProductPriceHistory_Table.sql**
   - Created table and stored procedures
   - Run this script first

3. **sp_SaveProductToAllBranches.sql**
   - Ensures new products exist in all branches
   - Required for price history to work

---

## Database Objects Used

- **Table**: `ProductPriceHistory`
- **View**: `vw_LatestProductPrices`
- **Stored Procedure**: `sp_GetLatestProductPrice`
- **Stored Procedure**: `sp_RecordProductPriceFromInvoice`
- **Stored Procedure**: `sp_UpdateProductCostAllBranches`

---

## Important Notes

- Price history is **branch-specific**
- Same product can have different prices at different branches
- Tooltip only shows on "Last Paid" column (hover to see)
- "Unit Price" can be manually overridden by user
- All prices in PO are **including VAT** (user enters actual price paid)
