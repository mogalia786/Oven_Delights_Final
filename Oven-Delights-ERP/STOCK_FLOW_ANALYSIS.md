# Stock Flow Analysis - Manufacturing to Retail

## Your Questions Answered:

### 1. ✅ Is the product being baked specific to branch?

**YES** - Branch-specific tracking is implemented:

- **Internal Order** has `BranchID` (line 419 in InternalOrdersForm.vb)
- **Manufacturing_Inventory** tracks stock per branch (line 459-483)
- **Manufacturing_InventoryMovements** records movements per branch (line 486-494)
- **RetailStock** should track completed products per branch

**Current Implementation:**
```vb
' From InternalOrdersForm.vb - Line 415-419
Using cmdBranch As New SqlCommand("SELECT ISNULL(BranchID, 0) FROM dbo.InternalOrderHeader WHERE InternalOrderID=@id", cn, tx)
    cmdBranch.Parameters.AddWithValue("@id", id)
    Dim obj = cmdBranch.ExecuteScalar()
    If obj IsNot Nothing AndAlso Not IsDBNull(obj) Then branchId = Convert.ToInt32(obj)
End Using
```

---

### 2. ✅ Is stockroom qty being reduced and manufacturing stock being added after fulfill?

**YES** - This is working correctly:

#### When Stockroom Fulfills BOM (InternalOrdersForm.vb):

**Step 1: Reduce Stockroom (Line 452-456)**
```vb
' Reduce Stockroom Inventory (RawMaterials table)
Using cmdReduce As New SqlCommand("UPDATE dbo.RawMaterials SET CurrentStock = CurrentStock - @qty WHERE MaterialID=@mid", cn, tx)
    cmdReduce.Parameters.AddWithValue("@qty", mat.Quantity)
    cmdReduce.Parameters.AddWithValue("@mid", mat.MaterialID)
    cmdReduce.ExecuteNonQuery()
End Using
```

**Step 2: Increase Manufacturing (Line 458-483)**
```vb
' Increase Manufacturing_Inventory
Using cmdCheck2 As New SqlCommand("SELECT COUNT(*) FROM dbo.Manufacturing_Inventory WHERE MaterialID=@mid AND BranchID=@bid", cn, tx)
    ' ... check if exists ...
    If exists Then
        ' UPDATE existing record
        Using cmdUpdate As New SqlCommand("UPDATE dbo.Manufacturing_Inventory SET QtyOnHand = QtyOnHand + @qty, AverageCost = @cost, LastUpdated = GETDATE(), UpdatedBy = @user WHERE MaterialID=@mid AND BranchID=@bid", cn, tx)
    Else
        ' INSERT new record
        Using cmdInsert As New SqlCommand("INSERT INTO dbo.Manufacturing_Inventory (MaterialID, BranchID, QtyOnHand, AverageCost, LastUpdated, UpdatedBy) VALUES (@mid, @bid, @qty, @cost, GETDATE(), @user)", cn, tx)
End Using
```

**Step 3: Log Movement (Line 486-494)**
```vb
' Insert Manufacturing_InventoryMovements
Using cmdMove As New SqlCommand("INSERT INTO dbo.Manufacturing_InventoryMovements (MaterialID, BranchID, MovementType, QtyDelta, CostPerUnit, Reference, Notes, MovementDate, CreatedBy) VALUES (@mid, @bid, 'Issue from Stockroom', @qty, @cost, @ref, @notes, GETDATE(), @user)", cn, tx)
```

✅ **CONFIRMED: Stockroom reduces, Manufacturing increases**

---

### 3. ⚠️ Is Manufacturing stock being reduced and Demo_Retail_Product stock being increased after completion?

**PARTIALLY IMPLEMENTED** - This depends on the `sp_CompleteReOrderProduct` stored procedure.

Based on the SQL files found, there are multiple versions of this procedure. The procedure should:

#### What SHOULD Happen:

**Step 1: Reduce Manufacturing_Inventory**
```sql
-- Consume ingredients from Manufacturing
UPDATE Manufacturing_Inventory 
SET QtyOnHand = QtyOnHand - @IngredientQty
WHERE MaterialID = @MaterialID AND BranchID = @BranchID
```

**Step 2: Increase RetailStock (Branch-Specific)**
```sql
-- Add finished product to Retail Stock
IF EXISTS (SELECT 1 FROM RetailStock WHERE ProductID = @ProductID AND BranchID = @BranchID)
BEGIN
    UPDATE RetailStock 
    SET Quantity = Quantity + @QuantityCompleted,
        StockType = 'Internal',
        LastUpdated = GETDATE()
    WHERE ProductID = @ProductID AND BranchID = @BranchID
END
ELSE
BEGIN
    INSERT INTO RetailStock (ProductID, BranchID, Quantity, StockType, LastUpdated)
    VALUES (@ProductID, @BranchID, @QuantityCompleted, 'Internal', GETDATE())
END
```

**Step 3: Log Stock Movement**
```sql
INSERT INTO StockMovements (
    ProductID, 
    BranchID, 
    MovementType, 
    QuantityIn, 
    InventoryArea, 
    Reference, 
    CreatedBy, 
    CreatedDate
)
VALUES (
    @ProductID, 
    @BranchID, 
    'Production Complete', 
    @QuantityCompleted, 
    'Retail', 
    @ReOrderLineID, 
    @CompletedBy, 
    GETDATE()
)
```

---

## 🔍 CURRENT ISSUES TO VERIFY:

### Issue 1: Check if `sp_CompleteReOrderProduct` exists and is updated
Run this query:
```sql
SELECT OBJECT_DEFINITION(OBJECT_ID('sp_CompleteReOrderProduct'))
```

### Issue 2: Verify RetailStock table structure
```sql
SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'RetailStock'
ORDER BY ORDINAL_POSITION
```

### Issue 3: Check if Manufacturing_Inventory is being reduced
The stored procedure should reduce manufacturing stock when production completes.

---

## 📊 COMPLETE STOCK FLOW:

```
┌─────────────────────────────────────────────────────────────┐
│                    STOCK FLOW DIAGRAM                        │
└─────────────────────────────────────────────────────────────┘

1. PURCHASE ORDER → STOCKROOM
   ├─ RawMaterials.CurrentStock += Qty
   └─ Per Branch: Global stockroom

2. BOM FULFILLMENT → MANUFACTURING
   ├─ RawMaterials.CurrentStock -= Qty
   ├─ Manufacturing_Inventory.QtyOnHand += Qty (per branch)
   └─ Manufacturing_InventoryMovements logged

3. PRODUCTION COMPLETE → RETAIL
   ├─ Manufacturing_Inventory.QtyOnHand -= Ingredient Qty (per branch)
   ├─ RetailStock.Quantity += Product Qty (per branch)
   └─ StockMovements logged (InventoryArea = 'Retail')

4. RETAIL SALE → CUSTOMER
   ├─ RetailStock.Quantity -= Qty (per branch)
   └─ StockMovements logged (InventoryArea = 'Retail')
```

---

## ✅ WHAT'S WORKING:

1. ✅ Branch-specific tracking in Manufacturing
2. ✅ Stockroom → Manufacturing transfer
3. ✅ Manufacturing_Inventory updates per branch
4. ✅ Movement logging for Manufacturing

## ⚠️ WHAT NEEDS VERIFICATION:

1. ⚠️ `sp_CompleteReOrderProduct` - Does it reduce Manufacturing_Inventory?
2. ⚠️ `sp_CompleteReOrderProduct` - Does it update RetailStock per branch?
3. ⚠️ `sp_CompleteReOrderProduct` - Does it log StockMovements for Retail?

---

## 🛠️ RECOMMENDED ACTIONS:

### Action 1: Verify Stored Procedure
Check if `sp_CompleteReOrderProduct` has the correct logic.

### Action 2: If Missing, Update Procedure
Use one of these SQL scripts:
- `FIX_RETAIL_STOCK_SAFE.sql`
- `FIX_RETAIL_STOCK_UNIVERSAL.sql`

### Action 3: Test Complete Flow
1. Create recipe
2. Create re-order book
3. Request BOM
4. Stockroom fulfills → Check Manufacturing_Inventory
5. Baker completes production → Check RetailStock
6. Verify POS can see the product

---

## 📝 TABLES INVOLVED:

| Table | Purpose | Branch-Specific? |
|-------|---------|------------------|
| `RawMaterials` | Stockroom inventory | ❌ Global |
| `Manufacturing_Inventory` | Work-in-progress materials | ✅ Yes |
| `Manufacturing_InventoryMovements` | Manufacturing audit trail | ✅ Yes |
| `RetailStock` | Finished products for sale | ✅ Yes |
| `StockMovements` | Retail stock audit trail | ✅ Yes |
| `Demo_Retail_Product` | Product master data | ❌ Global |

---

## 🎯 SUMMARY:

**Question 1:** ✅ YES - Branch-specific  
**Question 2:** ✅ YES - Stockroom reduces, Manufacturing increases  
**Question 3:** ⚠️ NEEDS VERIFICATION - Check `sp_CompleteReOrderProduct`

The first two parts of the flow are working correctly. The third part (production completion) depends on the stored procedure implementation.
