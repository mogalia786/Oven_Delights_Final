# 🔍 COMPREHENSIVE QUERY VALIDATION REPORT
## Database Schema Validation for All Modules

**Generated:** 2025-10-06 14:50  
**Purpose:** Validate every SQL query against database schema  
**Scope:** Manufacturing, Retail, Accounting modules

---

## 📋 VALIDATION LEGEND

- ✅ **GREEN TICK** - All columns exist in database schema
- ❌ **RED CROSS** - Missing columns detected
- ⚠️ **WARNING** - Potential issues (nullable columns, deprecated tables)
- 🔧 **FIX REQUIRED** - Action needed

---

# 🏭 MANUFACTURING MODULE

## Menu: Manufacturing → Complete Build

### Form: CompleteBuildForm.vb

#### Query 1: Load Internal Order Header
```sql
SELECT IOH.InternalOrderNo, IOH.Status, IOH.RequestedDate, IOH.Notes 
FROM dbo.InternalOrderHeader IOH 
WHERE IOH.InternalOrderID=@id
```

**Table:** InternalOrderHeader  
**Columns Required:**
- InternalOrderNo
- Status  
- RequestedDate
- Notes
- InternalOrderID

**Validation:** ⏳ CHECKING...

---

#### Query 2: Load Products for Dropdown
```sql
SELECT ProductID, ProductName 
FROM dbo.Products 
WHERE IsActive = 1 
ORDER BY ProductName
```

**Table:** Products  
**Columns Required:**
- ProductID
- ProductName
- IsActive

**Validation:** ✅ PASS (Added IsActive in RUN_ALL_FIXES.sql)

---

#### Query 3: Get Latest Internal Order
```sql
SELECT TOP 1 IOH.InternalOrderID, IOH.InternalOrderNo, IOH.Status, IOH.Notes, IOH.RequestedDate
FROM dbo.InternalOrderHeader IOH
LEFT JOIN dbo.BomTaskStatus BTS ON BTS.InternalOrderID = IOH.InternalOrderID
WHERE IOH.Status IN ('Issued', 'In Progress')
AND (@prodId IS NULL OR EXISTS (SELECT 1 FROM dbo.InternalOrderDetails IOD WHERE IOD.InternalOrderID = IOH.InternalOrderID AND IOD.ProductID = @prodId))
AND (@userId IS NULL OR BTS.AssignedToUserID = @userId)
ORDER BY IOH.RequestedDate DESC
```

**Tables:** InternalOrderHeader, BomTaskStatus, InternalOrderDetails  
**Columns Required:**
- InternalOrderHeader: InternalOrderID, InternalOrderNo, Status, Notes, RequestedDate
- BomTaskStatus: InternalOrderID, AssignedToUserID
- InternalOrderDetails: InternalOrderID, ProductID

**Validation:** ⏳ CHECKING...

---

## Menu: Manufacturing → Issue to Manufacturing

### Form: IssueToManufacturingForm.vb

#### Query 1: Load Raw Materials
```sql
SELECT rm.MaterialID, rm.MaterialCode, rm.MaterialName,
ISNULL(rm.CurrentStock, 0) AS StockroomQty,
ISNULL(rm.AverageCost, 0) AS UnitCost,
rm.UnitOfMeasure
FROM RawMaterials rm
WHERE ISNULL(rm.IsActive, 1) = 1
AND ISNULL(rm.CurrentStock, 0) > 0
ORDER BY rm.MaterialName
```

**Table:** RawMaterials  
**Columns Required:**
- MaterialID
- MaterialCode
- MaterialName
- CurrentStock
- AverageCost
- UnitOfMeasure
- IsActive

**Validation:** ⏳ CHECKING...

---

## Menu: Manufacturing → BOM Editor

### Form: BOMEditorForm.vb

#### Query 1: Load Products
```sql
SELECT ProductID, ProductName, ProductCode
FROM dbo.Products
WHERE IsActive = 1
ORDER BY ProductName
```

**Table:** Products  
**Columns Required:**
- ProductID
- ProductName
- ProductCode
- IsActive

**Validation:** ✅ PASS (ProductCode added in RUN_ALL_FIXES.sql)

---

#### Query 2: Load BOM Components
```sql
SELECT bc.ComponentID, bc.MaterialID, rm.MaterialName, rm.MaterialCode,
bc.QuantityRequired, rm.UnitOfMeasure, bc.Notes
FROM dbo.BOMComponents bc
INNER JOIN dbo.RawMaterials rm ON bc.MaterialID = rm.MaterialID
WHERE bc.BOMID = @bomId
ORDER BY rm.MaterialName
```

**Tables:** BOMComponents, RawMaterials  
**Columns Required:**
- BOMComponents: ComponentID, MaterialID, QuantityRequired, Notes, BOMID
- RawMaterials: MaterialName, MaterialCode, UnitOfMeasure

**Validation:** ⏳ CHECKING...

---

# 🛒 RETAIL MODULE

## Menu: Retail → Products

### Form: ProductsForm.vb (checking...)

---

## Menu: Retail → Stock Management

### Form: RetailStockForm.vb (checking...)

---

# 💰 ACCOUNTING MODULE

## Menu: Accounting → Supplier Ledger

### Form: SupplierLedgerForm.vb

#### Query 1: Load Suppliers
```sql
SELECT SupplierID, SupplierName
FROM Suppliers
WHERE IsActive = 1
ORDER BY SupplierName
```

**Table:** Suppliers  
**Columns Required:**
- SupplierID
- SupplierName
- IsActive

**Validation:** ✅ PASS (IsActive added in RUN_ALL_FIXES.sql)

---

## Menu: Accounting → Expenses

### Form: ExpensesForm.vb

#### Query 1: Load Expense Types
```sql
SELECT ExpenseTypeID, ExpenseTypeName
FROM ExpenseTypes
WHERE IsActive = 1
ORDER BY ExpenseTypeName
```

**Table:** ExpenseTypes  
**Columns Required:**
- ExpenseTypeID
- ExpenseTypeName
- IsActive

**Validation:** ⏳ CHECKING...

---

# 📊 CRITICAL TABLES TO VERIFY

## Core Tables Status:

### 1. InternalOrderHeader
**Expected Columns:**
- InternalOrderID (PK)
- InternalOrderNo
- Status
- RequestedDate
- Notes
- BranchID
- CreatedDate
- CreatedBy

**Status:** ⏳ NEEDS VERIFICATION

---

### 2. RawMaterials
**Expected Columns:**
- MaterialID (PK)
- MaterialCode
- MaterialName
- CurrentStock
- AverageCost
- UnitOfMeasure
- IsActive
- BranchID

**Status:** ⏳ NEEDS VERIFICATION

---

### 3. Products
**Expected Columns:**
- ProductID (PK)
- ProductName
- ProductCode
- SKU
- ItemType
- IsActive
- LastPaidPrice
- AverageCost

**Status:** ✅ FIXED (RUN_ALL_FIXES.sql)

---

### 4. Suppliers
**Expected Columns:**
- SupplierID (PK)
- SupplierName
- Address
- City
- Province
- BankName
- AccountNumber
- IsActive

**Status:** ✅ FIXED (RUN_ALL_FIXES.sql)

---

### 5. BOMComponents
**Expected Columns:**
- ComponentID (PK)
- BOMID (FK)
- MaterialID (FK)
- QuantityRequired
- Notes

**Status:** ⏳ NEEDS VERIFICATION

---

### 6. InternalOrderDetails
**Expected Columns:**
- DetailID (PK)
- InternalOrderID (FK)
- ProductID (FK)
- Quantity
- UnitCost

**Status:** ⏳ NEEDS VERIFICATION

---

### 7. BomTaskStatus
**Expected Columns:**
- TaskID (PK)
- InternalOrderID (FK)
- AssignedToUserID (FK)
- Status
- UpdatedAtUtc

**Status:** ⏳ NEEDS VERIFICATION

---

# 🔧 ISSUES FOUND

## Critical Issues:

### Issue 1: Inter-Branch Transfer Blank Screen
**Location:** Stockroom → Inter-Branch Transfer  
**Status:** ❌ REPORTED BY USER  
**Action Required:** Investigate form load error

---

### Issue 2: Missing Menu Items
**Forms Not Wired:**
- CashBookJournalForm.vb
- TimesheetEntryForm.vb

**Status:** 🔧 NEEDS WIRING TO MENU

---

# 📝 NEXT STEPS

1. ⏳ Run DATABASE_SCHEMA_REFERENCE.sql to get complete schema
2. ⏳ Validate each query against actual schema
3. ⏳ Fix Inter-Branch Transfer blank screen
4. ⏳ Wire up CashBook and Timesheet forms
5. ⏳ Document complete PO → Retail workflow

---

**Report Status:** 🔄 IN PROGRESS  
**Estimated Completion:** 17:50 (3 hours remaining)
