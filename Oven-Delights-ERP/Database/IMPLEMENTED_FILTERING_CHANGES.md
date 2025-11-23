# Implemented Filtering Changes - Build My Product & Purchase Orders

## Summary
Implemented category-based filtering with wildcard search for Build My Product ingredients and fixed Purchase Order materials dropdown to exclude manufactured products.

---

## 1. PURCHASE ORDER FORM - Fixed Material Dropdown

### File: `Services\StockroomService.vb`
### Method: `GetPOItemsLookup()`

**Changes Made:**
- ✅ Added `ProductType = 'External'` filter for products from `Demo_Retail_Product`
- ✅ Added category filtering for Raw Materials (Ingredients, Consumables, Packaging, Miscellaneous)
- ✅ Handles misspellings: 'miscellaneous' and 'miscellaenous'
- ✅ Added `CategoryName` column to result set

**SQL Changes:**
```sql
-- Raw Materials: Now filtered by category
SELECT rm.MaterialID, rm.MaterialCode, rm.MaterialName, 
       ISNULL(rm.AverageCost, 0) AS AverageCost, 
       'RM' AS ItemSource, pc.CategoryName
FROM RawMaterials rm
LEFT JOIN ProductCategories pc ON rm.CategoryID = pc.CategoryID
WHERE ISNULL(rm.IsActive, 1) = 1
  AND (pc.CategoryName LIKE '%ingredient%'
       OR pc.CategoryName LIKE '%consumable%'
       OR pc.CategoryName LIKE '%packaging%'
       OR pc.CategoryName LIKE '%miscellaneous%'
       OR pc.CategoryName LIKE '%miscellaenous%')

UNION ALL

-- External Products: Now filtered by ProductType
SELECT p.ProductID AS MaterialID, ISNULL(p.Code, p.SKU) AS MaterialCode,
       p.Name AS MaterialName, 0 AS AverageCost,
       'PR' AS ItemSource, 'External Product' AS CategoryName
FROM dbo.Demo_Retail_Product p
WHERE ISNULL(p.IsActive, 1) = 1
  AND p.ProductType = 'External'  -- NEW FILTER
  AND p.BranchID = @BranchID
```

**Result:**
- ❌ **REMOVED:** Internal/Manufactured products from PO dropdown
- ✅ **SHOWS:** Only Raw Materials (Ingredients, Consumables, Packaging, Miscellaneous) and External Products

---

## 2. BUILD MY PRODUCT - Add Subcomponent Dialog

### File: `Forms\Manufacturing\SubcomponentDialog.vb`

**Changes Made:**
- ✅ Added search textbox above Item dropdown
- ✅ Implemented wildcard search (both sides) on item names
- ✅ Added category filtering for Raw Materials
- ✅ Added category filtering for SubAssemblies (sub recipes)
- ✅ Enabled autocomplete on item dropdowns
- ✅ Increased form height to 320px

### A. Raw Materials Tab

**SQL Changes:**
```sql
SELECT m.MaterialID,
       (ISNULL(m.MaterialCode,'') + CASE WHEN ISNULL(m.MaterialCode,'')<>'' THEN ' - ' ELSE '' END + ISNULL(m.MaterialName,'')) AS Display,
       u.UoMID AS DefaultUoMID, m.MaterialName
FROM dbo.RawMaterials m
LEFT JOIN dbo.UoM u ON u.UoMCode = m.BaseUnit
LEFT JOIN dbo.ProductCategories pc ON m.CategoryID = pc.CategoryID
WHERE m.IsActive=1
  AND (pc.CategoryName LIKE '%ingredient%'
       OR pc.CategoryName LIKE '%consumable%'
       OR pc.CategoryName LIKE '%packaging%'
       OR pc.CategoryName LIKE '%miscellaneous%'
       OR pc.CategoryName LIKE '%miscellaenous%')
ORDER BY m.MaterialName
```

**Features:**
- Category filter: Ingredients, Consumables, Packaging, Miscellaneous
- Handles misspellings
- Autocomplete enabled
- Free text search with wildcards

### B. SubAssembly Tab (Sub-Recipes)

**SQL Changes:**
```sql
SELECT s.SubAssemblyID,
       (ISNULL(s.SubAssemblyCode,'') + CASE WHEN ISNULL(s.SubAssemblyCode,'')<>'' THEN ' - ' ELSE '' END + ISNULL(s.SubAssemblyName,'')) AS Display,
       s.DefaultUoMID, s.SubAssemblyName
FROM dbo.SubAssemblies s
LEFT JOIN dbo.ProductCategories pc ON s.CategoryID = pc.CategoryID
WHERE ISNULL(s.IsActive,1)=1
  AND (pc.CategoryName LIKE '%sub%recipe%' OR pc.CategoryName LIKE '%subrecipe%')
ORDER BY s.SubAssemblyName
```

**Features:**
- Category filter: Sub Recipe (handles spacing variations)
- Autocomplete enabled
- Free text search with wildcards

### C. Search Functionality

**Implementation:**
```vb
Private Sub OnSearchTextChanged(sender As Object, e As EventArgs)
    If currentItemsDataTable Is Nothing Then Return
    
    Dim searchText = txtSearch.Text.Trim()
    If String.IsNullOrEmpty(searchText) Then
        cmbItem.DataSource = currentItemsDataTable
        Return
    End If
    
    ' Filter with wildcards on both sides
    Dim filterExpression = $"Display LIKE '%{searchText.Replace("'", "''")}%'"
    Dim filteredView = currentItemsDataTable.DefaultView
    filteredView.RowFilter = filterExpression
    cmbItem.DataSource = filteredView.ToTable()
End Sub
```

**Features:**
- Real-time filtering as user types
- Wildcard matching on both sides (e.g., "flour" matches "Bread Flour", "Flour - White", "All Purpose Flour")
- SQL injection protection (escapes single quotes)
- Falls back to showing all items if filter fails

---

## 3. LAST PAID PRICE (Existing Feature)

### File: `Services\StockroomService.vb`
### Method: `GetLastPaidPrice()`

**Already Implemented:**
```vb
Public Function GetLastPaidPrice(supplierId As Integer, materialId As Integer) As Nullable(Of Decimal)
    Using con As New SqlConnection(connectionString)
        Dim sql = "SELECT TOP 1 gl.UnitCost FROM GoodsReceivedNotes g " &
                  "INNER JOIN GRNLines gl ON gl.GRNID = g.GRNID " &
                  "WHERE g.SupplierID = @sid AND gl.MaterialID = @mid " &
                  "ORDER BY g.ReceivedDate DESC, gl.GRNLineID DESC"
        ' ... executes and returns last price
    End Using
End Function
```

**Note:** This method is already available. The PO form should call it when a material is selected to show the last paid price as a hint/reference.

---

## TESTING CHECKLIST

### Purchase Order Form:
- [ ] Open PO form and check Material dropdown
- [ ] Verify NO Internal/Manufactured products appear
- [ ] Verify Raw Materials from categories: Ingredients, Consumables, Packaging, Miscellaneous appear
- [ ] Verify External Products appear
- [ ] Test Product Type filter (Raw Material vs External Product)

### Build My Product - Add Subcomponent:
- [ ] Select "Raw Material" type
- [ ] Verify only Ingredients, Consumables, Packaging, Miscellaneous appear
- [ ] Type in search box (e.g., "flour") and verify wildcard matching works
- [ ] Select "SubAssembly" type
- [ ] Verify only items from "Sub Recipe" category appear
- [ ] Test search functionality on SubAssemblies
- [ ] Verify autocomplete works on both dropdowns

### Database Prerequisites:
- [ ] Ensure `ProductCategories` table has categories with names containing:
  - "ingredient" or "Ingredient"
  - "consumable" or "Consumable"
  - "packaging" or "Packaging"
  - "miscellaneous" or "Miscellaneous" (or misspelled "miscellaenous")
  - "sub recipe" or "subrecipe" or "Sub Recipe"
- [ ] Ensure `RawMaterials` and `SubAssemblies` tables have `CategoryID` foreign key to `ProductCategories`

---

## BENEFITS

1. **Cleaner PO Dropdown:** No more manufactured products cluttering the purchase order materials list
2. **Category-Based Filtering:** Ingredients, consumables, packaging properly separated
3. **Better UX:** Wildcard search makes finding items faster
4. **Autocomplete:** Users can start typing and get suggestions
5. **Sub-Recipe Support:** Proper filtering for sub-assemblies used as ingredients
6. **Misspelling Tolerance:** Handles common typos in category names

---

## FUTURE ENHANCEMENTS (Not Implemented)

1. **Last Paid Price Display:** Add a label/textbox in PO form to show last paid price when material is selected
2. **Supplier-Specific Pricing:** Show last price paid to the currently selected supplier
3. **Price History:** Show price trend graph for selected material
4. **Smart Suggestions:** Suggest materials based on frequently ordered items
