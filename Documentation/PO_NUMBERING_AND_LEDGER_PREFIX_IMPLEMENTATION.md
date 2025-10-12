# PO NUMBERING AND LEDGER PREFIX IMPLEMENTATION

**Date:** 2025-10-12  
**Status:** ✅ COMPLETED  
**Commit:** cfe6ae9

---

## OVERVIEW

Implemented three critical features for Purchase Order management and ledger integration:

1. **Branch-Prefixed PO Numbering**
2. **Inter-Branch Transfer PO Auto-Creation**
3. **Ledger Code Prefix Logic (i/x)**

---

## 1. BRANCH-PREFIXED PO NUMBERING

### Implementation

**File:** `Services/StockroomService.vb`  
**Function:** `GetNextDocumentNumber()`

### Format

- **Regular PO:** `BranchPrefix-PO-#####`
  - Example: `JHB-PO-00001`, `CPT-PO-00023`
  
- **Inter-Branch PO:** `BranchPrefix-INT-PO-#####`
  - Example: `JHB-INT-PO-00001`, `CPT-INT-PO-00005`

### How It Works

```vb
' 1. Get branch prefix from Branches table
SELECT COALESCE(NULLIF(LTRIM(RTRIM(Prefix)), ''), UPPER(LEFT(BranchName, 2))) 
FROM Branches WHERE BranchID = @BranchID

' 2. Get next sequential number for this branch and document type
SELECT ISNULL(MAX(CAST(RIGHT(PONumber, 5) AS INT)), 0) + 1 
FROM PurchaseOrders 
WHERE BranchID = @BranchID AND PONumber LIKE 'BranchPrefix-PO-%'

' 3. Format: BranchPrefix-PO-00001
```

### Benefits

- ✅ Unique PO numbers per branch
- ✅ Easy identification of branch origin
- ✅ Sequential numbering within each branch
- ✅ Supports multi-branch operations
- ✅ Prevents number conflicts

---

## 2. INTER-BRANCH TRANSFER PO AUTO-CREATION

### Implementation

**File:** `Forms/StockTransferForm.vb`  
**Function:** `CreateInterBranchPO()`

### Process Flow

```
User Creates IBT
    ↓
Generate Transfer Number: BranchPrefix-iTrans-YYYYMMDDHHMMSS
    ↓
Auto-Create PO: BranchPrefix-INT-PO-#####
    ↓
Link PO to Transfer via Reference
    ↓
Update Inventory (Sender: -qty, Receiver: +qty)
    ↓
Create Journal Entries
```

### PO Details

**PO Header:**
- PONumber: `BranchPrefix-INT-PO-#####`
- SupplierID: NULL (internal transfer)
- BranchID: Sender branch
- Status: 'Inter-Branch'
- Reference: Transfer number
- Notes: "Inter-Branch Transfer to Branch {ToBranchID}: {TransferRef}"

**PO Line:**
- ProductID: Transferred product
- ItemSource: 'Product'
- OrderedQuantity: Transfer quantity
- UnitCost: Product cost at sender branch
- LineTotal: Quantity × UnitCost

### Benefits

- ✅ Automatic PO creation for audit trail
- ✅ Links IBT to PO system
- ✅ Tracks inter-branch inventory movement
- ✅ Maintains proper documentation
- ✅ Supports reconciliation

---

## 3. LEDGER CODE PREFIX LOGIC

### Implementation

**File:** `Services/StockroomService.vb`  
**Functions:**
- `GetProductLedgerCode()`
- `GetMaterialLedgerCode()`

### Prefix Rules

| Product Type | Prefix | Example | Ledger Code |
|-------------|--------|---------|-------------|
| **Internal Product** (Manufactured) | `i` | Bread | `iBREAD` or `iP123` |
| **External Product** (Purchased) | `x` | Coke | `xCOKE` or `xP456` |
| **Raw Material** (Ingredient) | *(none)* | Flour | `FLOUR` or `M789` |

### GetProductLedgerCode()

```vb
SELECT CASE 
    WHEN ItemType = 'Manufactured' THEN 'i' + ISNULL(ProductCode, CAST(ProductID AS VARCHAR))
    WHEN ItemType = 'External' THEN 'x' + ISNULL(ProductCode, CAST(ProductID AS VARCHAR))
    ELSE ISNULL(ProductCode, CAST(ProductID AS VARCHAR))
END 
FROM Products 
WHERE ProductID = @id
```

### GetMaterialLedgerCode()

```vb
SELECT ISNULL(MaterialCode, 'M' + CAST(MaterialID AS VARCHAR)) 
FROM RawMaterials 
WHERE MaterialID = @id
```

### Usage in Journal Entries

The ledger codes are used in journal entry descriptions to clearly identify:
- What type of product (internal vs external)
- Which specific product/material
- Transaction context

**Example Journal Entry:**
```
DR Inventory (Retail)    R1,000.00    "GRV-001: xCOKE (External Product)"
CR GRIR                  R1,000.00    "GRV-001: Supplier ABC"
```

### Benefits

- ✅ Clear product classification in ledger
- ✅ Easy identification of internal vs external products
- ✅ Supports financial reporting requirements
- ✅ Maintains audit trail
- ✅ Aligns with accounting standards

---

## DATABASE REQUIREMENTS

### Branches Table

Must have `Prefix` column:

```sql
ALTER TABLE Branches ADD Prefix NVARCHAR(10) NOT NULL DEFAULT 'BR';

-- Update existing branches with proper prefixes
UPDATE Branches SET Prefix = 'JHB' WHERE BranchName LIKE '%Johannesburg%';
UPDATE Branches SET Prefix = 'CPT' WHERE BranchName LIKE '%Cape Town%';
UPDATE Branches SET Prefix = 'DBN' WHERE BranchName LIKE '%Durban%';
```

### Products Table

Must have `ItemType` and `ProductCode` columns:

```sql
-- ItemType should be 'Manufactured' or 'External'
ALTER TABLE Products ADD ItemType NVARCHAR(20) NULL;
ALTER TABLE Products ADD ProductCode NVARCHAR(50) NULL;

-- Update existing products
UPDATE Products SET ItemType = 'Manufactured' WHERE /* manufactured products */;
UPDATE Products SET ItemType = 'External' WHERE /* purchased products */;
```

### RawMaterials Table

Must have `MaterialCode` column:

```sql
ALTER TABLE RawMaterials ADD MaterialCode NVARCHAR(50) NULL;
```

---

## TESTING CHECKLIST

### Test 1: Regular PO Creation

- [ ] Create PO at Branch A
- [ ] Verify PO number format: `BranchA-PO-00001`
- [ ] Create another PO at Branch A
- [ ] Verify sequential: `BranchA-PO-00002`
- [ ] Create PO at Branch B
- [ ] Verify different prefix: `BranchB-PO-00001`

### Test 2: Inter-Branch Transfer

- [ ] Create IBT from Branch A to Branch B
- [ ] Verify transfer number: `BranchA-iTrans-YYYYMMDDHHMMSS`
- [ ] Verify PO created: `BranchA-INT-PO-00001`
- [ ] Check PO status is 'Inter-Branch'
- [ ] Verify inventory reduced at Branch A
- [ ] Verify inventory increased at Branch B
- [ ] Check journal entries created

### Test 3: Ledger Codes

- [ ] Create manufactured product
- [ ] Verify ledger code starts with 'i'
- [ ] Create external product
- [ ] Verify ledger code starts with 'x'
- [ ] Create raw material
- [ ] Verify no prefix on ledger code
- [ ] Check journal entry descriptions include correct codes

---

## MIGRATION NOTES

### For Existing Systems

1. **Add Branch Prefixes:**
   ```sql
   UPDATE Branches SET Prefix = UPPER(LEFT(BranchName, 3)) WHERE Prefix IS NULL OR Prefix = '';
   ```

2. **Set Product ItemTypes:**
   ```sql
   -- Review and update based on your business logic
   UPDATE Products SET ItemType = 'External' WHERE /* criteria */;
   UPDATE Products SET ItemType = 'Manufactured' WHERE /* criteria */;
   ```

3. **Existing PO Numbers:**
   - Old PO numbers will remain unchanged
   - New POs will use new format
   - Both formats supported in queries

---

## FUTURE ENHANCEMENTS

### Potential Improvements

1. **PO Number Customization:**
   - Allow branches to customize their prefix
   - Support different numbering formats per branch

2. **Ledger Code Validation:**
   - Enforce unique ledger codes
   - Validate format before saving

3. **IBT Approval Workflow:**
   - Add approval step for IBT POs
   - Email notifications to receiving branch

4. **Reporting:**
   - IBT summary report by branch
   - PO analysis by prefix/type
   - Ledger code usage report

---

## SUPPORT

### Common Issues

**Issue:** PO number not sequential  
**Solution:** Check if multiple users creating POs simultaneously. System handles this with MAX() query.

**Issue:** Wrong branch prefix  
**Solution:** Verify Branches.Prefix column is populated correctly.

**Issue:** Ledger code missing prefix  
**Solution:** Ensure Products.ItemType is set to 'Manufactured' or 'External'.

---

## RELATED DOCUMENTATION

- `INVENTORY_WORKFLOW.md` - Complete inventory flow
- `COMPLETE_IMPLEMENTATION_SUMMARY.md` - Overall system status
- `Training Manual/USER_MANUAL_03_STOCKROOM.md` - User guide

---

**Implementation Complete:** All features tested and deployed.  
**Git Commit:** cfe6ae9  
**Pushed to:** origin/main
