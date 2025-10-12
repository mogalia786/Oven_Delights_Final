# CRITICAL GAPS FOUND - MUST FIX

## ISSUE 1: BOM FULFILLMENT DOESN'T MOVE STOCK ❌

**File:** Forms\Stockroom\InternalOrdersForm.vb (Line 393-506)

**Current Behavior:**
- OnFulfill method only updates InternalOrderHeader.Status to 'Completed'
- Does NOT reduce stockroom stock
- Does NOT increase manufacturing stock
- Does NOT create journal entries

**What It SHOULD Do:**
```vb
1. Get InternalOrderLines (raw materials requested)
2. For each line:
   - Reduce Inventory.QuantityOnHand (Stockroom, BranchID)
   - Increase Manufacturing_Inventory (BranchID)
3. Create Journal Entry:
   - DR Manufacturing Inventory
   - CR Stockroom Inventory (InventoryRaw)
4. Update InternalOrderHeader.Status = 'Issued'
5. Insert StockMovements records
```

**Impact:** Manufacturing doesn't actually receive ingredients. Stock levels incorrect.

---

## ISSUE 2: BUILD COMPLETE DOESN'T MOVE STOCK ❌

**File:** Forms\Manufacturing\CompleteBuildForm.vb (needs verification)

**Expected Behavior:**
```vb
1. Get ingredients used from BOM/Recipe
2. For each ingredient:
   - Reduce Manufacturing_Inventory (BranchID)
3. Calculate finished product cost from ingredients
4. Increase Retail_Stock.QtyOnHand (finished product, BranchID)
5. Create Journal Entry:
   - DR Retail Inventory (finished goods)
   - CR Manufacturing Inventory (WIP consumed)
6. Insert Retail_StockMovements record
```

**Status:** Needs verification - may or may not be implemented

**Impact:** Finished products don't appear in retail stock. Manufacturing stock never reduces.

---

## ISSUE 3: STOCK MOVEMENTS REPORT INCOMPLETE

**Current State:**
- StockMovements table exists for raw materials
- Retail_StockMovements exists for retail products
- No unified view of product journey

**What's Needed:**
A comprehensive report showing:
- Product Name
- Movement Type (Purchase, Issue to Mfg, Build Complete, Sale, Transfer, Adjustment)
- From Location (Stockroom/Manufacturing/Retail)
- To Location
- Quantity
- BranchID
- Date
- Journal Reference
- Ledger Accounts affected

**Query Should Join:**
- StockMovements (raw materials)
- Retail_StockMovements (retail products)
- Manufacturing movements (if table exists)
- JournalDetails (ledger impact)
- InterBranchTransfers

---

## VERIFIED WORKING ✅

1. ✅ PO → GRV Receipt (creates journals, updates stock)
2. ✅ External Products → Retail_Stock
3. ✅ Raw Materials → Stockroom
4. ✅ POS Sales (reduces stock, creates movements)
5. ✅ Inter-Branch Transfer (updates both branches, posts ledgers)

---

## MUST FIX BEFORE POS DESIGN

### Priority 1: BOM Fulfillment
**File to Fix:** Forms\Stockroom\InternalOrdersForm.vb (OnFulfill method)
**Add:**
- Stock movement logic
- Journal entry creation
- Manufacturing_Inventory table updates

### Priority 2: Build Complete
**File to Check:** Forms\Manufacturing\CompleteBuildForm.vb
**Verify/Add:**
- Manufacturing stock reduction
- Retail stock increase
- Cost calculation
- Journal entry creation

### Priority 3: Stock Movements Report
**Create New:** Forms\Reports\StockMovementsReport.vb
**Show:**
- Complete product journey
- All locations
- All movements
- Journal references

---

## TABLES THAT MAY BE MISSING

### Manufacturing_Inventory
**Purpose:** Track ingredients in manufacturing (WIP)
**Columns Needed:**
- MaterialID
- BranchID
- QuantityOnHand
- AverageCost
- Location (e.g., 'PRODUCTION')
- LastUpdated

**Status:** Needs verification if table exists

---

## RECOMMENDED FIX APPROACH

### Step 1: Verify Tables
```sql
-- Check if Manufacturing_Inventory exists
SELECT * FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'Manufacturing_Inventory'

-- If not, create it
CREATE TABLE Manufacturing_Inventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    MaterialID INT NOT NULL,
    BranchID INT NOT NULL,
    QuantityOnHand DECIMAL(18,4) NOT NULL DEFAULT 0,
    AverageCost DECIMAL(18,4) NOT NULL DEFAULT 0,
    Location NVARCHAR(50) NOT NULL DEFAULT 'PRODUCTION',
    LastUpdated DATETIME2 NOT NULL DEFAULT GETDATE(),
    ModifiedBy INT NULL,
    CONSTRAINT FK_MfgInv_Material FOREIGN KEY (MaterialID) REFERENCES RawMaterials(MaterialID),
    CONSTRAINT FK_MfgInv_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
)
```

### Step 2: Fix BOM Fulfillment
Add to OnFulfill method:
1. Load InternalOrderLines
2. For each line with MaterialID:
   - Check Inventory.QuantityOnHand (Stockroom)
   - If sufficient, reduce Stockroom
   - Increase Manufacturing_Inventory
   - Create journal entry
   - Insert movement record
3. Only mark as 'Issued' if all materials available

### Step 3: Fix Build Complete
Add to CompleteBuildForm:
1. Load recipe/BOM ingredients
2. Verify Manufacturing_Inventory has quantities
3. Reduce Manufacturing_Inventory
4. Calculate cost from ingredients
5. Increase Retail_Stock
6. Create journal entry
7. Insert movement record

### Step 4: Create Stock Movements Report
Union query:
```sql
SELECT 
    'Raw Material' AS ItemType,
    rm.MaterialName AS ItemName,
    sm.MovementType,
    'Stockroom' AS FromLocation,
    CASE sm.MovementType 
        WHEN 'Issue' THEN 'Manufacturing'
        WHEN 'Purchase' THEN 'Supplier'
        ELSE 'Stockroom'
    END AS ToLocation,
    sm.QuantityIn - sm.QuantityOut AS Quantity,
    sm.MovementDate,
    sm.ReferenceNumber,
    sm.CreatedBy,
    b.BranchName
FROM StockMovements sm
INNER JOIN RawMaterials rm ON sm.MaterialID = rm.MaterialID
LEFT JOIN Branches b ON sm.BranchID = b.BranchID

UNION ALL

SELECT 
    'Retail Product' AS ItemType,
    p.ProductName AS ItemName,
    CASE 
        WHEN rsm.QtyDelta < 0 THEN 'Sale'
        WHEN rsm.QtyDelta > 0 THEN 'Receipt'
        ELSE 'Adjustment'
    END AS MovementType,
    'Retail' AS FromLocation,
    CASE 
        WHEN rsm.QtyDelta < 0 THEN 'Customer'
        ELSE 'Retail'
    END AS ToLocation,
    rsm.QtyDelta AS Quantity,
    rsm.CreatedAt AS MovementDate,
    rsm.Ref1 AS ReferenceNumber,
    rsm.CreatedBy,
    b.BranchName
FROM Retail_StockMovements rsm
INNER JOIN Retail_Variant rv ON rsm.VariantID = rv.VariantID
INNER JOIN Products p ON rv.ProductID = p.ProductID
LEFT JOIN Branches b ON rsm.BranchID = b.BranchID

ORDER BY MovementDate DESC
```

---

## SUMMARY FOR USER

**What's Working:**
- ✅ Purchase Orders → GRV Receipt (with journals)
- ✅ External Products → Retail Stock
- ✅ Raw Materials → Stockroom
- ✅ POS Sales
- ✅ Inter-Branch Transfers

**What's Broken:**
- ❌ BOM Fulfillment (no stock movement, no journals)
- ❌ Build Complete (needs verification)
- ❌ Stock Movements Report (incomplete)

**What's Needed:**
1. Fix BOM Fulfillment to actually move stock
2. Verify/Fix Build Complete
3. Create comprehensive Stock Movements report
4. Verify Manufacturing_Inventory table exists

**Ready for POS Design:** NO - Must fix stock flow first
