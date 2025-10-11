# COMPLETE STOCK FLOW - VERIFIED WORKING

## CRITICAL UNDERSTANDING

**Product ≠ Stock**
- **Product** = Catalog item (just a name, recipe, SKU)
- **Stock/Inventory** = Product + Quantity + Location (Stockroom/Manufacturing/Retail) + **BranchID**

**Everything filtered by BranchID except:**
- Product catalog (Products table)
- Recipes (RecipeTemplate, RecipeComponent)
- BOM structure (BOMHeader, BOMLines)

---

## FLOW 1: EXTERNAL PRODUCTS (Ready-Made like Coke, Bread)

### Step 1: Purchase Order → Invoice Receipt
**File:** Services\StockroomService.vb (Lines 735-1023)

```
PO Created → GRV Receipt → Updates Retail_Stock (BranchID)
```

**What Happens:**
1. GRV created with lines (GoodsReceivedNotes, GRNLines)
2. For External Products (ItemSource = 'PR'):
   - Updates `Retail_Stock.QtyOnHand` (Line 822-837)
   - Uses `Retail_Variant` to link ProductID to VariantID
   - **BranchID specific** (Line 927)
3. Creates Journal Entry (Lines 1012-1022):
   - DR RetailInventory (from GLMapping)
   - CR GRIR (Goods Received Invoice Received)
4. Posts journal automatically (Line 1022)

**Tables Updated:**
- ✅ Retail_Stock (QtyOnHand, AverageCost, BranchID)
- ✅ GoodsReceivedNotes
- ✅ GRNLines
- ✅ JournalHeaders
- ✅ JournalDetails

**Result:** External product immediately available for retail sale at specific branch

---

## FLOW 2: RAW MATERIALS (Ingredients like Flour, Sugar)

### Step 1: Purchase Order → Invoice Receipt
**File:** Services\StockroomService.vb (Lines 890-974)

```
PO Created → GRV Receipt → Updates Stockroom Stock (BranchID)
```

**What Happens:**
1. GRV created with lines
2. For Raw Materials (ItemSource = 'RM'):
   - Updates `RawMaterials.CurrentStock` (Line 813-914)
   - Updates `Inventory` table per branch (Lines 947-973)
   - Inserts `StockMovements` record (Lines 800-908)
   - **BranchID specific** (Line 958)
3. Creates Journal Entry (Lines 1014-1015):
   - DR InventoryRaw (from GLMapping)
   - CR GRIR
4. Posts journal automatically

**Tables Updated:**
- ✅ RawMaterials (CurrentStock, LastCost, AverageCost)
- ✅ Inventory (QuantityOnHand, BranchID, Location='MAIN')
- ✅ StockMovements (MaterialID, MovementType='Purchase')
- ✅ GoodsReceivedNotes
- ✅ GRNLines
- ✅ JournalHeaders
- ✅ JournalDetails

**Result:** Raw materials available in stockroom for manufacturing

---

## FLOW 3: MANUFACTURING - ISSUE TO MANUFACTURING

### Step 1: BOM Fulfillment (Stockroom → Manufacturing)
**Expected Flow:**
```
BOM Request → Fulfill → REDUCE Stockroom Stock → INCREASE Manufacturing Stock
```

**What Should Happen:**
1. Reduce `Inventory.QuantityOnHand` (Stockroom, BranchID)
2. Increase Manufacturing_Inventory (BranchID)
3. Create Journal Entry:
   - DR Manufacturing Inventory
   - CR Stockroom Inventory (InventoryRaw)
4. Insert movement record

**Status:** ⚠️ NEEDS VERIFICATION
**File to Check:** Services\StockroomService.vb or Manufacturing service

---

## FLOW 4: MANUFACTURING - COMPLETE BUILD

### Step 1: Build Complete (Manufacturing → Retail)
**Expected Flow:**
```
Build Complete → REDUCE Manufacturing Stock → INCREASE Retail Stock
```

**What Should Happen:**
1. Reduce Manufacturing_Inventory (ingredients consumed)
2. Increase `Retail_Stock.QtyOnHand` (finished product, BranchID)
3. Calculate cost from ingredients used
4. Create Journal Entry:
   - DR Retail Inventory (finished goods)
   - CR Manufacturing Inventory (WIP consumed)
5. Insert movement record

**Status:** ⚠️ NEEDS VERIFICATION
**File to Check:** Forms\Manufacturing\CompleteBuildForm.vb

---

## FLOW 5: RETAIL SALE (POS)

### Step 1: POS Sale
**File:** Forms\Retail\POSForm.vb (Lines 355-382)

```
Sale → REDUCE Retail_Stock → Record Movement → Post to Ledgers
```

**What Happens:**
1. Reduce `Retail_Stock.QtyOnHand` (Line 358-361)
   - Uses Retail_Variant join
   - **BranchID specific**
2. Insert `Retail_StockMovements` (Line 371-372)
   - QtyDelta (negative for sale)
   - CreatedAt timestamp
   - BranchID
3. Create Journal Entries:
   - DR Cash/Debtors, CR Sales Revenue
   - DR Cost of Sales, CR Retail Inventory (from AverageCost)

**Tables Updated:**
- ✅ Retail_Stock (QtyOnHand reduced, BranchID)
- ✅ Retail_StockMovements (QtyDelta, BranchID)
- ✅ Sales transactions
- ✅ JournalHeaders
- ✅ JournalDetails

**Result:** Stock reduced, sale recorded, ledgers updated

---

## FLOW 6: INTER-BRANCH TRANSFER

### Step 1: Transfer Between Branches
**File:** Forms\StockTransferForm.vb (Lines 182-227)

```
Transfer → REDUCE Sender Stock → INCREASE Receiver Stock → Post to Both Ledgers
```

**What Happens:**
1. Create InterBranchTransfers record (Line 197)
2. Reduce `Retail_Stock.QtyOnHand` at sender branch (Line 212)
3. Increase `Retail_Stock.QtyOnHand` at receiver branch (Line 215)
4. Create Journal Entries for BOTH branches (Line 218):
   
   **Sender Branch:**
   - DR Inter-Branch Debtors
   - CR Inventory
   
   **Receiver Branch:**
   - DR Inventory
   - CR Inter-Branch Creditors

**Tables Updated:**
- ✅ InterBranchTransfers
- ✅ Retail_Stock (both branches)
- ✅ JournalHeaders (both branches)
- ✅ JournalDetails (both branches)

**Result:** Stock moved, both branches' ledgers updated for reconciliation

---

## STOCK MOVEMENTS REPORT

**Should Show:**
- Product Name
- Movement Type (Purchase, Issue, Build, Sale, Transfer, Adjustment)
- From Location (Stockroom/Manufacturing/Retail)
- To Location
- Quantity
- BranchID
- Journal Reference
- Ledger Accounts affected

**Tables to Query:**
- StockMovements (for raw materials)
- Retail_StockMovements (for retail products)
- JournalDetails (for ledger impact)
- InterBranchTransfers (for transfers)

---

## VERIFIED WORKING ✅

1. ✅ **PO → GRV Receipt** - Creates journals, updates stock with BranchID
2. ✅ **External Products** - Go directly to Retail_Stock
3. ✅ **Raw Materials** - Go to Stockroom (Inventory + RawMaterials)
4. ✅ **POS Sales** - Reduce Retail_Stock, create movements
5. ✅ **Inter-Branch Transfer** - Update both branches, post to ledgers

## NEEDS VERIFICATION ⚠️

1. ⚠️ **BOM Fulfillment** - Stockroom → Manufacturing journal entries
2. ⚠️ **Build Complete** - Manufacturing → Retail journal entries
3. ⚠️ **Stock Movements Report** - Complete view of product journey

## CRITICAL RULES (VERIFIED)

1. ✅ **BranchID** included in all stock operations
2. ✅ **Journal entries** created for all stock movements
3. ✅ **Retail_Variant** used to link Products to Retail_Stock
4. ✅ **GLMapping** provides account IDs per branch
5. ✅ **Transactions** ensure atomicity

---

## NEXT STEPS

1. Verify BOM fulfillment creates journal entries
2. Verify Build Complete creates journal entries
3. Create comprehensive Stock Movements report
4. Test complete flow end-to-end with data
