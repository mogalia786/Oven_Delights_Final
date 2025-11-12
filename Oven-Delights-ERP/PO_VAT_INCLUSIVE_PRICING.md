# PO VAT-INCLUSIVE Pricing - FIXED

## How It Works Now

### You Enter VAT-INCLUSIVE Prices:
When you enter a price in the "Unit Price (Incl VAT)" column, that's the **final price including VAT**.

### System Calculates Backwards:
The bottom totals break down the VAT:

```
Line Item: 1 × R30.00 (incl VAT) = R30.00

Bottom Totals:
SubTotal (Excl VAT):  R26.09  ← R30.00 / 1.15
VAT (15%):            R 3.91  ← R30.00 - R26.09
Total (Incl VAT):     R30.00  ← What you entered (BOLD)
```

---

## Example Scenario

### Line Items:
| Product | Qty | Unit Price (Incl VAT) | Line Total |
|---------|-----|----------------------|------------|
| Coke    | 10  | R17.25              | R172.50    |
| Bread   | 20  | R14.38              | R287.50    |

### Bottom Totals:
```
SubTotal (Excl VAT):  R400.00  ← R460.00 / 1.15
VAT (15%):            R 60.00  ← R460.00 - R400.00
Total (Incl VAT):     R460.00  ← Sum of line totals (BOLD)
```

---

## The Math

**Formula:**
- Total (Incl VAT) = SubTotal × 1.15
- Therefore: SubTotal = Total / 1.15
- VAT = Total - SubTotal

**Example with R30.00:**
- SubTotal = R30.00 / 1.15 = R26.09
- VAT = R30.00 - R26.09 = R3.91
- Total = R30.00 ✓

---

## What Changed

### Column Header:
- Changed to: **"Unit Price (Incl VAT)"**

### Calculation Logic:
```vb
' OLD (VAT added to subtotal):
Dim vat = subTotal × 0.15
Dim total = subTotal + vat

' NEW (VAT calculated backwards from total):
Dim subTotal = totalInclVAT / 1.15
Dim vat = totalInclVAT - subTotal
```

### Display:
- Total label and textbox are now **BOLD** to emphasize it's the final amount

---

## Deploy

```
Build → Rebuild Solution
```

---

## Testing

1. Enter price: R30.00
2. Quantity: 1
3. Check bottom:
   - SubTotal (Excl VAT): R26.09 ✓
   - VAT (15%): R3.91 ✓
   - Total (Incl VAT): R30.00 ✓

**You enter the final VAT-inclusive price, system breaks it down!**
