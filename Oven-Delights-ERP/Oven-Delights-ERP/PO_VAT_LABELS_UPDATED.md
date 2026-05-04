# PO VAT Labels - Updated for Clarity

## What Was Changed

### Column Header
**Before:** "Est. Unit Price"  
**After:** "Unit Price (Excl VAT)"

### Footer Labels
**Before:**
- SubTotal
- VAT (15%)
- Total

**After:**
- **SubTotal (Excl VAT)**
- VAT (15%)
- **Total (Incl VAT)**

---

## How It Works

### When Entering Prices:
1. Enter price in **"Unit Price (Excl VAT)"** column
2. Enter quantity
3. System calculates line total (Qty × Unit Price)

### Bottom Totals Show:
```
SubTotal (Excl VAT):  R1,000.00  ← Sum of all line totals
VAT (15%):            R  150.00  ← 15% of subtotal
Total (Incl VAT):     R1,150.00  ← Subtotal + VAT
```

---

## Example

### Line Items:
| Product | Qty | Unit Price (Excl VAT) | Line Total |
|---------|-----|----------------------|------------|
| Coke    | 10  | R15.00              | R150.00    |
| Bread   | 20  | R12.50              | R250.00    |

### Bottom Totals:
```
SubTotal (Excl VAT):  R400.00
VAT (15%):            R 60.00
Total (Incl VAT):     R460.00
```

---

## Deploy

```
Build → Rebuild Solution
```

**Labels now clearly show that prices are excluding VAT and totals include VAT!**
