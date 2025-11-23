# Dropdown Tables and Filters Breakdown

## BUILD MY PRODUCT FORM (`BuildProductForm.vb`)

### 1. Product Dropdown (`cmbProduct`)
**Method:** `LoadProductsWithoutRecipe()` (Line 285)

**Table:** `Demo_Retail_Product`

**Columns Selected:**
- `p.ProductID`
- `p.Name AS ProductName`

**Filters/Criteria:**
```sql
WHERE p.IsActive = 1 
  AND (p.BranchID = @branchId OR p.BranchID IS NULL) 
  AND p.ProductType = 'Internal' 
  AND NOT EXISTS (SELECT 1 FROM BOMItems bi WHERE bi.ComponentProductID = p.ProductID)
ORDER BY p.Name
```

**Filter Breakdown:**
- ✅ `IsActive = 1` - Only active products
- ✅ `BranchID = @branchId OR BranchID IS NULL` - Current branch or global products
- ✅ `ProductType = 'Internal'` - Only manufactured/internal products
- ❌ `NOT EXISTS (BOMItems)` - **EXCLUDES products that are used as components in other BOMs** (sub-recipes/ingredients)

**Purpose:** Shows only top-level manufactured products that don't have a recipe yet and aren't used as ingredients elsewhere.

---

### 2. Category Dropdown (`cmbCategory`)
**Method:** `LoadCategories()` (Line 958)

**Table:** `ProductCategories`

**Columns Selected:**
- `CategoryID`
- `CategoryName`

**Filters/Criteria:**
```sql
SELECT CategoryID, CategoryName 
FROM ProductCategories 
ORDER BY CategoryName
```

**Filter Breakdown:**
- ✅ No filters - shows ALL categories
- ✅ Ordered alphabetically

**Purpose:** Shows all product categories for classification.

---

### 3. Subcategory Dropdown (`cmbSubcategory`)
**Method:** `LoadSubcategories(categoryId)` (Line 995)

**Table:** `ProductSubcategories`

**Columns Selected:**
- `SubcategoryID`
- `SubcategoryName`

**Filters/Criteria:**
```sql
SELECT SubcategoryID, SubcategoryName 
FROM ProductSubcategories 
WHERE CategoryID = @categoryId 
ORDER BY SubcategoryName
```

**Filter Breakdown:**
- ✅ `CategoryID = @categoryId` - Only subcategories for selected category
- ✅ Ordered alphabetically

**Purpose:** Shows subcategories filtered by the selected category (cascading dropdown).

---

## PURCHASE ORDER FORM (`PurchaseOrderForm.vb`)

### 1. Supplier Dropdown/Autocomplete (`txtSupplier`)
**Method:** `LoadLookups()` → `service.GetSuppliersLookup()` (Line 260)

**Service Method:** `StockroomService.GetSuppliersLookup()` (Line 1791)

**Table:** `Suppliers`

**Columns Selected:**
- `SupplierID`
- `CompanyName`

**Filters/Criteria:**
```sql
SELECT SupplierID, CompanyName 
FROM Suppliers 
WHERE IsActive = 1
-- Additional branch filtering if not SuperAdmin
AND (BranchID = @branchId OR @isSuperAdmin = 1)
ORDER BY CompanyName
```

**Filter Breakdown:**
- ✅ `IsActive = 1` - Only active suppliers
- ✅ Branch-aware (unless SuperAdmin)
- ✅ Ordered alphabetically

**Purpose:** Shows suppliers available for creating purchase orders.

---

### 2. Materials/Products Dropdown (`dgvLines` - Material Column)
**Method:** `LoadLookups()` → `service.GetPOItemsLookup()` (Line 261)

**Service Method:** `StockroomService.GetPOItemsLookup()` (Line 1839)

**Tables:** `RawMaterials` UNION `Demo_Retail_Product`

**Columns Selected:**
- `MaterialID` (RawMaterials.MaterialID OR Products.ProductID)
- `MaterialCode`
- `MaterialName`
- `AverageCost`
- `ItemSource` ('RM' for Raw Materials, 'PR' for Products)

**Filters/Criteria:**
```sql
-- Part 1: Raw Materials
SELECT rm.MaterialID AS MaterialID, 
       rm.MaterialCode AS MaterialCode, 
       rm.MaterialName AS MaterialName, 
       ISNULL(rm.AverageCost, 0) AS AverageCost, 
       'RM' AS ItemSource 
FROM RawMaterials rm 
WHERE ISNULL(rm.IsActive, 1) = 1 

UNION ALL 

-- Part 2: External Products (NOT Internal/Manufactured)
SELECT p.ProductID AS MaterialID, 
       ISNULL(p.Code, p.SKU) AS MaterialCode, 
       p.Name AS MaterialName, 
       0 AS AverageCost, 
       'PR' AS ItemSource 
FROM dbo.Demo_Retail_Product p 
WHERE ISNULL(p.IsActive, 1) = 1 
  AND p.BranchID = @BranchID  -- if branchId specified
ORDER BY MaterialName
```

**Filter Breakdown:**
- ✅ `IsActive = 1` - Only active items
- ✅ **Raw Materials** - All active raw materials
- ✅ **External Products** - All active products from Demo_Retail_Product
- ⚠️ **NO ProductType filter** - This means it shows ALL products (Internal AND External)
- ✅ Branch-aware if branchId parameter provided
- ✅ Ordered alphabetically

**Additional Filtering:** `FilterMaterialsByType()` (Line 301)
- If Product Type = "External Product", shows only items where `ItemSource = 'PR'`
- If Product Type = "Raw Material", shows only items where `ItemSource = 'RM'`

**Purpose:** Shows all purchasable items (raw materials and products) for creating PO lines.

---

### 3. Branch Dropdown (`cboBranch`)
**Method:** `LoadLookups()` → `service.GetBranchesLookup()` (Line 262)

**Service Method:** `StockroomService.GetBranchesLookup()` (Line 1881)

**Table:** `Branches`

**Columns Selected:**
- `BranchID`
- `BranchName`
- `BranchCode`

**Filters/Criteria:**
```sql
SELECT BranchID, BranchName, BranchCode 
FROM Branches 
WHERE ISNULL(IsActive, 1) = 1 
ORDER BY BranchName
```

**Filter Breakdown:**
- ✅ `IsActive = 1` - Only active branches
- ✅ Ordered alphabetically

**Purpose:** Shows branches for multi-branch purchase order management.

---

## KEY ISSUES IDENTIFIED

### 🔴 CRITICAL ISSUE: PO Items Lookup
**Problem:** `GetPOItemsLookup()` shows ALL products from `Demo_Retail_Product`, including Internal (manufactured) products.

**Expected Behavior:** Should only show:
- Raw Materials (from `RawMaterials` table)
- External/Purchased Products (from `Demo_Retail_Product` WHERE `ProductType = 'External'`)

**Current Behavior:** Shows:
- Raw Materials ✅
- External Products ✅
- **Internal/Manufactured Products** ❌ (SHOULD NOT APPEAR)

**Fix Required:**
```sql
-- Add ProductType filter to the Products UNION
WHERE ISNULL(p.IsActive, 1) = 1 
  AND p.ProductType = 'External'  -- ADD THIS LINE
  AND p.BranchID = @BranchID
```

---

### 🟡 POTENTIAL ISSUE: Build My Product - Component Exclusion
**Problem:** `LoadProductsWithoutRecipe()` excludes products that are used as components in other BOMs.

**Impact:** If you want to create a sub-recipe (ingredient) that can be used in multiple products, it won't appear in the dropdown after being used once.

**Example Scenario:**
1. Create "Chocolate Ganache" as a product
2. Use it as an ingredient in "Chocolate Cake"
3. Now "Chocolate Ganache" won't appear when trying to create a recipe for it

**Fix Required (if sub-recipes should be allowed):**
Remove this line from the WHERE clause:
```sql
AND NOT EXISTS (SELECT 1 FROM BOMItems bi WHERE bi.ComponentProductID = p.ProductID)
```

---

## SUMMARY

| Form | Dropdown | Table(s) | Key Filters | Issue |
|------|----------|----------|-------------|-------|
| Build My Product | Product | Demo_Retail_Product | ProductType='Internal', NOT in BOMItems | ⚠️ Excludes sub-recipes |
| Build My Product | Category | ProductCategories | None | ✅ OK |
| Build My Product | Subcategory | ProductSubcategories | CategoryID | ✅ OK |
| Purchase Order | Supplier | Suppliers | IsActive=1, Branch-aware | ✅ OK |
| Purchase Order | Materials | RawMaterials + Demo_Retail_Product | IsActive=1 | 🔴 Missing ProductType filter |
| Purchase Order | Branch | Branches | IsActive=1 | ✅ OK |
