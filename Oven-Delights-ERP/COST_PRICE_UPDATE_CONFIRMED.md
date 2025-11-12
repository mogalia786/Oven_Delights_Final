# COST PRICE UPDATE - CONFIRMED & FIXED

## How It Works Now

### When Invoice is Captured for External Product:

**Step 1: Update Products Table**
```vb
' LastPaidPrice = NEW invoice price (always latest)
' AverageCost = Weighted average of all purchases
UPDATE Products 
SET LastPaidPrice = @NewPrice,
    AverageCost = ((OldAvgCost * OldQty) + (NewPrice * NewQty)) / (OldQty + NewQty)
WHERE ProductID = @ProductID
```

**Step 2: Update Retail_Stock Table**
```vb
' Add quantity to branch stock
' Update branch-specific average cost
UPDATE Retail_Stock
SET QtyOnHand = QtyOnHand + @NewQty,
    AverageCost = ((OldAvgCost * OldQty) + (NewPrice * NewQty)) / (OldQty + NewQty)
WHERE VariantID = @ProductID AND BranchID = @BranchID
```

**Step 3: PO Form Shows Updated Price**
```vb
' When creating next PO, system reads:
SELECT LastPaidPrice FROM Products WHERE ProductID = @ProductID
' Shows in "Last Paid" column
' Auto-fills "Est. Unit Price" with this value
```

---

## Example Scenario

### Purchase 1:
- Buy 10 units @ R10.00 each
- **LastPaidPrice** = R10.00
- **AverageCost** = R10.00

### Purchase 2:
- Buy 5 units @ R12.00 each
- **LastPaidPrice** = R12.00 (latest price)
- **AverageCost** = ((R10 × 10) + (R12 × 5)) / 15 = R10.67

### Purchase 3:
- Buy 15 units @ R11.00 each
- **LastPaidPrice** = R11.00 (latest price)
- **AverageCost** = ((R10.67 × 15) + (R11 × 15)) / 30 = R10.83

### Next PO:
- Open PO form
- Select this product
- **"Last Paid" column shows:** R11.00
- **"Est. Unit Price" auto-fills:** R11.00
- **"Last Cost" column shows:** R10.83 (average)

---

## What Was Fixed

### Before Fix:
```vb
' Products table update (WRONG)
SET LastPaidPrice = @Cost,
    AverageCost = @Cost  -- Just overwrites with new cost!
```

### After Fix:
```vb
' Products table update (CORRECT)
SET LastPaidPrice = @Cost,  -- Latest price
    AverageCost = @AvgCost  -- Weighted average of all purchases
```

---

## Files Changed

### `Services\InvoiceCaptureService.vb`
**Method:** `UpdateExternalProductInventory`
**Lines:** 147-180

**Changes:**
1. Added query to get current stock quantity and average cost
2. Calculate weighted average: `((OldAvg × OldQty) + (NewCost × NewQty)) / (OldQty + NewQty)`
3. Update Products table with LastPaidPrice AND calculated AverageCost

---

## Testing

### Test 1: First Purchase
1. Capture invoice for external product (e.g., Coke)
2. Price: R15.00, Qty: 10
3. Check Products table:
   - LastPaidPrice = R15.00 ✓
   - AverageCost = R15.00 ✓

### Test 2: Second Purchase (Different Price)
1. Capture another invoice for same product
2. Price: R18.00, Qty: 5
3. Check Products table:
   - LastPaidPrice = R18.00 ✓ (latest)
   - AverageCost = R16.00 ✓ ((15×10 + 18×5) / 15)

### Test 3: PO Shows Updated Price
1. Create new Purchase Order
2. Select "External Product"
3. Add the product
4. Check columns:
   - "Last Paid" = R18.00 ✓
   - "Est. Unit Price" = R18.00 ✓ (auto-filled)
   - "Last Cost" = R16.00 ✓ (average)

---

## Summary

✅ **LastPaidPrice** = Always the LATEST invoice price  
✅ **AverageCost** = Weighted average of ALL purchases  
✅ **PO Form** = Shows LastPaidPrice and auto-fills Est. Unit Price  
✅ **Updates Automatically** = Every time invoice is captured  

**The system now correctly tracks cost prices and updates them with each invoice!**
