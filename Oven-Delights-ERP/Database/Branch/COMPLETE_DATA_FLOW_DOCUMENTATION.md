# 🔄 COMPLETE DATA FLOW: POS & Manufacturing Integration

## 📊 **MASTER DATA STRUCTURE**

### **Products Table (Master - 1,696 products)**
- **Purpose:** Central product catalog (NO branch duplication)
- **Key Fields:**
  - `ProductID` (Primary Key)
  - `ProductCode` (Unique SKU)
  - `ProductName`
  - `CategoryID`, `SubcategoryID`
  - `ItemType`: `'internal'` | `'external'` | `'Manufactured'`
  - `RecommendedSellingPrice`, `AverageCost`, `LastPaidPrice`
  - `IsActive`

### **Demo_Retail_Product Table (Branch-Specific)**
- **Purpose:** Branch-specific product records (DUPLICATES per branch)
- **Key Fields:**
  - `ProductID` (FK to Products)
  - `BranchID` (Part of composite key)
  - `SKU`, `Name`, `Category`
  - `CategoryID`, `SubcategoryID`
  - `ProductType`: `'Internal'` | `'External'`
  - `CurrentStock` (legacy field)
  - `IsActive`
- **Total Records:** Unique Products × Number of Branches
  - Example: 1,696 products × 8 branches = 13,568 records

### **Demo_Retail_Price Table (Branch-Specific Pricing)**
- **Purpose:** Pricing per product per branch
- **Key Fields:**
  - `ProductID` + `BranchID` (Composite key)
  - `SellingPrice`, `CostPrice`
  - `EffectiveFrom`, `EffectiveTo`

### **Demo_Retail_Stock Table (Branch-Specific Inventory)**
- **Purpose:** Real-time inventory per product per branch
- **Key Fields:**
  - `ProductID` + `BranchID` (Composite key)
  - `Quantity` (Current stock level)
  - `LastUpdated`

---

## 🏪 **POS DATA FLOW (Branch-Specific)**

### **1. POS Login → Load Products**
**Location:** `POSDataService.vb` → `GetProductsWithStock()`

```sql
SELECT 
    p.ProductID,
    p.SKU,
    p.Name AS ProductName,
    p.Category,
    ISNULL(pr.SellingPrice, 0) AS SellingPrice,
    ISNULL(pr.CostPrice, 0) AS CostPrice,
    ISNULL(s.Quantity, 0) AS QtyOnHand
FROM Demo_Retail_Product p
LEFT JOIN Demo_Retail_Price pr 
    ON p.ProductID = pr.ProductID 
    AND pr.BranchID = @BranchID
LEFT JOIN Demo_Retail_Stock s 
    ON p.ProductID = s.ProductID 
    AND s.BranchID = @BranchID
WHERE p.IsActive = 1 
    AND (p.BranchID = @BranchID OR p.BranchID IS NULL)
    AND p.ProductType IN ('External', 'Internal')
ORDER BY p.Category, p.Name
```

**Key Points:**
- ✅ Filters by `@BranchID` for branch-specific data
- ✅ Shows both `'External'` (purchased) and `'Internal'` (manufactured) products
- ✅ Uses `Demo_Retail_Stock` for real-time inventory
- ✅ Uses `Demo_Retail_Price` for branch-specific pricing
- ✅ `ISNULL(s.Quantity, 0)` ensures products without stock records show as 0

### **2. POS Sale → Update Stock**
**Location:** `POSDataService.vb` → `RecordSale()`

```sql
UPDATE Demo_Retail_Stock
SET Quantity = Quantity - @Quantity,
    LastUpdated = GETDATE()
WHERE ProductID = @ProductID 
    AND BranchID = @BranchID
```

**Key Points:**
- ✅ Reduces stock by sold quantity
- ✅ Branch-specific update (only affects current branch)
- ✅ Real-time inventory deduction

---

## 🏭 **MANUFACTURING COMPLETION FLOW**

### **Step 1: Baker Completes Production**
**Location:** ERP → Re-Order Book → Complete Button
**Stored Procedure:** `sp_CompleteReOrderProduct`

**Parameters:**
- `@ReOrderLineID` - The production line being completed
- `@QuantityCompleted` - How many units were produced
- `@CompletedBy` - UserID of the baker

### **Step 2: Procedure Execution Flow**

```sql
-- 1. Get production details
SELECT 
    @ProductID = rol.ProductID,
    @BranchID = rob.BranchID
FROM ReOrderBookLines rol
INNER JOIN ReOrderBooks rob ON rol.ReOrderBookID = rob.ReOrderBookID
WHERE rol.ReOrderLineID = @ReOrderLineID;

-- 2. Update production line status
UPDATE ReOrderBookLines
SET 
    QuantityCompleted = @QuantityCompleted,
    LineStatus = 'Completed',
    CompletedBy = @CompletedByName,
    CompletedDate = GETDATE()
WHERE ReOrderLineID = @ReOrderLineID;

-- 3. Log to StockMovements (audit trail)
INSERT INTO StockMovements (
    MaterialID,
    BranchID,
    MovementType,
    QuantityIn,
    ReferenceType,
    Notes
)
VALUES (
    @ProductID,
    @BranchID,
    'Production Complete',
    @QuantityCompleted,
    'ReOrderBook',
    'Completed from Re-Order Book by ' + @CompletedByName
);

-- 4. ⚠️ CRITICAL: Update RetailStock (NOT Demo_Retail_Stock!)
IF EXISTS (SELECT 1 FROM RetailStock WHERE ProductID = @ProductID AND BranchID = @BranchID)
BEGIN
    UPDATE RetailStock
    SET 
        Quantity = Quantity + @QuantityCompleted,
        LastUpdated = GETDATE()
    WHERE ProductID = @ProductID AND BranchID = @BranchID;
END
ELSE
BEGIN
    INSERT INTO RetailStock (ProductID, BranchID, Quantity, StockType, LastUpdated)
    VALUES (@ProductID, @BranchID, @QuantityCompleted, 'Internal', GETDATE());
END
```

### **⚠️ CRITICAL ISSUE IDENTIFIED:**

**Problem:** `sp_CompleteReOrderProduct` updates `RetailStock` table, but POS reads from `Demo_Retail_Stock`!

**Current State:**
- ✅ Manufacturing completion → Updates `RetailStock`
- ❌ POS queries → Reads from `Demo_Retail_Stock`
- ❌ **MISMATCH:** Completed products don't appear in POS!

---

## 🔧 **REQUIRED FIX**

### **Option 1: Update sp_CompleteReOrderProduct to use Demo_Retail_Stock**

Change line 114-130 in `FIX_SP_COMPLETE_REORDER_FINAL.sql`:

```sql
-- Update Demo_Retail_Stock table (CORRECTED)
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Demo_Retail_Stock')
BEGIN
    IF EXISTS (SELECT 1 FROM Demo_Retail_Stock WHERE ProductID = @ProductID AND BranchID = @BranchID)
    BEGIN
        UPDATE Demo_Retail_Stock
        SET 
            Quantity = Quantity + @QuantityCompleted,
            LastUpdated = GETDATE()
        WHERE ProductID = @ProductID AND BranchID = @BranchID;
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Stock (ProductID, BranchID, Quantity, LastUpdated)
        VALUES (@ProductID, @BranchID, @QuantityCompleted, GETDATE());
    END
END
```

### **Option 2: Create Sync Trigger (Recommended)**

Create a trigger to keep `RetailStock` and `Demo_Retail_Stock` in sync:

```sql
CREATE TRIGGER trg_Sync_RetailStock_To_Demo
ON RetailStock
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Sync to Demo_Retail_Stock
    MERGE Demo_Retail_Stock AS target
    USING inserted AS source
    ON target.ProductID = source.ProductID AND target.BranchID = source.BranchID
    WHEN MATCHED THEN
        UPDATE SET 
            Quantity = source.Quantity,
            LastUpdated = source.LastUpdated
    WHEN NOT MATCHED THEN
        INSERT (ProductID, BranchID, Quantity, LastUpdated)
        VALUES (source.ProductID, source.BranchID, source.Quantity, source.LastUpdated);
END
```

---

## 🆕 **NEW BRANCH INITIALIZATION FLOW**

### **When Creating a New Branch**
**Stored Procedure:** `sp_InitializeBranchProducts`

**Step 1: Copy Prices from Products Master**
```sql
INSERT INTO Demo_Retail_Price (ProductID, BranchID, SellingPrice, CostPrice)
SELECT 
    p.ProductID,
    @BranchID,
    COALESCE(p.RecommendedSellingPrice, p.LastPaidPrice, 0),
    COALESCE(p.AverageCost, p.LastPaidPrice, 0)
FROM Products p
WHERE p.IsActive = 1
    AND p.ItemType IN ('Finished', 'SemiFinished')  -- ⚠️ NEEDS UPDATE to 'internal', 'external'
    AND COALESCE(p.RecommendedSellingPrice, p.LastPaidPrice, 0) > 0
```

**Step 2: Create Stock Records with Zero Quantity**
```sql
INSERT INTO Demo_Retail_Stock (ProductID, BranchID, Quantity, LastUpdated)
SELECT 
    p.ProductID,
    @BranchID,
    0,
    GETDATE()
FROM Products p
WHERE p.IsActive = 1
    AND p.ItemType IN ('Finished', 'SemiFinished')  -- ⚠️ NEEDS UPDATE to 'internal', 'external'
    AND EXISTS (
        SELECT 1 FROM Demo_Retail_Price 
        WHERE ProductID = p.ProductID AND BranchID = @BranchID
    )
```

### **⚠️ CRITICAL FIX NEEDED:**

The `sp_InitializeBranchProducts` procedure uses:
```sql
WHERE p.ItemType IN ('Finished', 'SemiFinished')
```

But Products table now uses:
```sql
WHERE p.ItemType IN ('internal', 'external', 'Manufactured')
```

**Required Update:**
```sql
WHERE p.ItemType IN ('internal', 'external', 'Manufactured')
```

---

## 📋 **SUMMARY OF ISSUES & FIXES**

### **Issue 1: Manufacturing Completion Stock Mismatch**
- **Problem:** `sp_CompleteReOrderProduct` updates `RetailStock`, POS reads `Demo_Retail_Stock`
- **Fix:** Update procedure to use `Demo_Retail_Stock` OR create sync trigger

### **Issue 2: Branch Initialization ItemType Mismatch**
- **Problem:** `sp_InitializeBranchProducts` filters by `'Finished', 'SemiFinished'`
- **Current Values:** `'internal', 'external', 'Manufactured'`
- **Fix:** Update WHERE clause to use correct ItemType values

### **Issue 3: Product Count Discrepancy**
- **Expected:** 1,587 products
- **Actual:** 1,696 products
- **Difference:** +109 products
- **Action:** Identify and remove duplicate/extra products

---

## ✅ **RECOMMENDED ACTION PLAN**

1. **Fix sp_CompleteReOrderProduct** to update `Demo_Retail_Stock`
2. **Fix sp_InitializeBranchProducts** to use correct ItemType values
3. **Identify and remove 109 extra products** from Products table
4. **Test complete flow:**
   - Create new branch
   - Verify products appear in POS
   - Complete manufacturing
   - Verify stock updates in POS
   - Make sale in POS
   - Verify stock deduction

---

## 🔗 **KEY FILES**

### **POS Application:**
- `POSDataService.vb` - Product queries and stock updates

### **ERP Stored Procedures:**
- `sp_CompleteReOrderProduct` - Manufacturing completion
- `sp_InitializeBranchProducts` - New branch setup

### **Database Tables:**
- `Products` - Master product catalog (1,696 products)
- `Demo_Retail_Product` - Branch-specific product records
- `Demo_Retail_Price` - Branch-specific pricing
- `Demo_Retail_Stock` - Branch-specific inventory (CURRENT)
- `RetailStock` - Legacy inventory table (DEPRECATED)

---

**Last Updated:** November 19, 2025
**Status:** ⚠️ Critical fixes required for manufacturing → POS flow
