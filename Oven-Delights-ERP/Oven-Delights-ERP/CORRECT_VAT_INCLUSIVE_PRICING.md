# ✅ CORRECT VAT-INCLUSIVE PRICING - FINAL FIX

## THE CORRECT FLOW (AS USER EXPLAINED)

### User Enters Prices INCLUDING VAT
**Invoice shows:** 345.00 (Incl VAT)  
**User enters in PO:** 345.00 (Incl VAT)

### System Calculates BACKWARDS
```
Unit Price (entered): 345.00 (Incl VAT)
Quantity: 100
──────────────────────────────────
Line Total: 34,500.00 (Incl VAT)

CALCULATE BACKWARDS:
Total (Incl VAT): 34,500.00
SubTotal (Excl VAT): 34,500 ÷ 1.15 = 30,000.00
VAT: 34,500 - 30,000 = 4,500.00
```

---

## What Was Fixed

### 1. ✅ Purchase Order Form
**File:** `Forms\PurchaseOrderFormNew.vb`

**Column Header (Line 149):**
```vb
.HeaderText = "Unit Price (Incl VAT)"
```

**VAT Calculation (Lines 359-387):**
```vb
' USER ENTERS: Unit Price INCLUDING VAT (e.g., 345.00)
' LineTotal = Qty * UnitPrice = INCLUDING VAT (e.g., 100 * 345 = 34,500)
' Total = Sum of LineTotals = INCLUDING VAT (e.g., 34,500)
' CALCULATE BACKWARDS:
' SubTotal = Total ÷ 1.15 = EXCLUDING VAT (e.g., 34,500 ÷ 1.15 = 30,000)
' VAT = Total - SubTotal (e.g., 34,500 - 30,000 = 4,500)

Dim totalInclVAT As Decimal = 0

For Each row As DataGridViewRow In dgvLines.Rows
    If row.IsNewRow Then Continue For
    If row.Cells("LineTotal").Value IsNot Nothing Then
        totalInclVAT += Convert.ToDecimal(row.Cells("LineTotal").Value)
    End If
Next

' Calculate BACKWARDS from VAT-inclusive total
Dim subTotal As Decimal = Math.Round(totalInclVAT / 1.15D, 2)
Dim vat As Decimal = Math.Round(totalInclVAT - subTotal, 2)

txtSubTotal.Text = subTotal.ToString("N2")  ' Excl VAT (calculated)
txtVAT.Text = vat.ToString("N2")            ' VAT amount (calculated)
txtTotal.Text = totalInclVAT.ToString("N2") ' Incl VAT (entered)
```

**Last Paid Price (Line 299):**
```vb
SELECT ISNULL(SellingPrice, 0), ISNULL(SellingPrice, 0) 
FROM dbo.Demo_Retail_Price 
WHERE ProductID = @id AND BranchID = @branchId
```
Shows `SellingPrice` (Incl VAT) as Last Paid

---

### 2. ✅ Invoice Capture Service
**File:** `Services\InvoiceCaptureService.vb`

**Lines 170-191:**
```vb
' CRITICAL: Update Demo_Retail_Price for BRANCH-SPECIFIC pricing
' unitCost from invoice is INCLUDING VAT (as entered by user)
' Calculate CostPrice EXCLUDING VAT for storage
Dim costExclVAT As Decimal = Math.Round(unitCost / 1.15D, 2)

Dim updatePriceSql = "UPDATE dbo.Demo_Retail_Price " &
                     "SET CostPrice = @CostExclVAT, " &
                     "    SellingPrice = @CostInclVAT, " &
                     "    SellingPriceExVAT = @CostExclVAT, " &
                     "    UpdatedAt = GETDATE() " &
                     "WHERE ProductID = @ProductID AND BranchID = @BranchID; " &
                     "IF @@ROWCOUNT = 0 " &
                     "INSERT INTO dbo.Demo_Retail_Price (ProductID, BranchID, CostPrice, SellingPrice, SellingPriceExVAT, EffectiveFrom, CreatedAt) " &
                     "VALUES (@ProductID, @BranchID, @CostExclVAT, @CostInclVAT, @CostExclVAT, GETDATE(), GETDATE())"

Using cmd As New SqlCommand(updatePriceSql, con, tx)
    cmd.Parameters.AddWithValue("@ProductID", productId)
    cmd.Parameters.AddWithValue("@BranchID", branchId)
    cmd.Parameters.AddWithValue("@CostExclVAT", costExclVAT)
    cmd.Parameters.AddWithValue("@CostInclVAT", unitCost)
    cmd.ExecuteNonQuery()
End Using
```

**Stores:**
- `CostPrice` = Price EXCLUDING VAT (calculated: unitCost ÷ 1.15)
- `SellingPrice` = Price INCLUDING VAT (as entered)
- `SellingPriceExVAT` = Price EXCLUDING VAT (same as CostPrice)

---

## Database Storage

**Table:** `dbo.Demo_Retail_Price`

| Column | Value | Description |
|--------|-------|-------------|
| ProductID | 123 | Product identifier |
| BranchID | 1 | Branch identifier |
| **CostPrice** | **300.00** | Cost EXCLUDING VAT (calculated) |
| **SellingPrice** | **345.00** | Price INCLUDING VAT (as entered) |
| **SellingPriceExVAT** | **300.00** | Price EXCLUDING VAT (calculated) |

---

## Complete Example

### Step 1: Receive Invoice
**Invoice shows:** Bubblegum Syrup = **345.00 Rands (Incl VAT)**

### Step 2: Capture Invoice
- Enter unit price: **345.00** (Incl VAT)
- System calculates: 345 ÷ 1.15 = **300.00** (Excl VAT)
- **Stores in database:**
  - CostPrice = 300.00 (Excl VAT)
  - SellingPrice = 345.00 (Incl VAT)

### Step 3: Create Purchase Order
- Select product: Bubblegum Syrup
- **Last Paid shows: 345.00** (Incl VAT) ✓
- Enter quantity: 100
- Enter unit price: **345.00** (Incl VAT)
- **System calculates:**
  ```
  Line Total: 100 × 345 = 34,500.00 (Incl VAT)
  
  SubTotal: 34,500 ÷ 1.15 = 30,000.00 (Excl VAT)
  VAT: 34,500 - 30,000 = 4,500.00
  Total: 34,500.00 (Incl VAT)
  ```

---

## 🚀 DEPLOY

```
Build → Rebuild Solution
```

---

## ✅ Test

1. **Create PO:**
   - Product: Bubblegum Syrup
   - Qty: 100
   - Unit Price: **345.00** (Incl VAT)
   - **Verify:**
     - Line Total = 34,500.00
     - SubTotal = 30,000.00 (Excl VAT)
     - VAT = 4,500.00
     - Total = 34,500.00 (Incl VAT)

2. **Capture Invoice:**
   - Unit price: 345.00 (Incl VAT)

3. **Create New PO:**
   - Same product
   - **Last Paid = 345.00** ✓ (Incl VAT)

---

## Summary

**CORRECT FLOW:**
- ✅ User enters prices INCLUDING VAT
- ✅ System calculates SubTotal and VAT BACKWARDS
- ✅ Database stores both Incl and Excl VAT amounts
- ✅ Last Paid shows price INCLUDING VAT
- ✅ Column header: "Unit Price (Incl VAT)"

**REBUILD AND TEST - THIS IS THE FINAL CORRECT FIX!**
