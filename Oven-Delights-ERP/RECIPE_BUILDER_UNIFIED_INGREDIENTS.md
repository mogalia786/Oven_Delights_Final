# RECIPE BUILDER - UNIFIED INGREDIENT SYSTEM

## THE ROOT PROBLEM (NOW FIXED!)

When building a product recipe, there were TWO separate buttons:
- ❌ "Add Raw Material" - showed only basic ingredients (Flour, Sugar, etc.)
- ❌ "Add Sub-Assembly" - showed only sub-recipes (Dough Mix, Filling, etc.)

This caused confusion and made it seem like raw materials and sub-recipes were different things stored in different places.

## THE SOLUTION

**ONE UNIFIED SYSTEM:**
- ✅ Single "Add Ingredient" button
- ✅ Shows BOTH raw materials AND sub-recipes in ONE list
- ✅ All stored in the same `RawMaterials` table
- ✅ Differentiated by `MaterialType` column

## WHAT WAS CHANGED

### 1. RawMaterialSelectorDialog.vb
**BEFORE:**
```vb
Me.Text = "Select Raw Material"
Dim sql = "SELECT rm.MaterialID, rm.MaterialCode, rm.MaterialName, ... FROM dbo.RawMaterials ..."
```

**AFTER:**
```vb
Me.Text = "Select Ingredient (Raw Material or Sub-Recipe)"
Dim sql = "SELECT rm.MaterialID, rm.MaterialCode, rm.MaterialName, rm.MaterialType, ... FROM dbo.RawMaterials ..."
```

**Changes:**
- ✅ Updated dialog title to clarify it includes sub-recipes
- ✅ Added `MaterialType` column to show what type each ingredient is
- ✅ Widened dialog to accommodate new column

### 2. RecipeBuilderForm.vb
**BEFORE:**
```vb
Private btnAddRawMaterial As Button  ' "Add Raw Material"
Private btnAddSubAssembly As Button  ' "Add Sub-Assembly"
```

**AFTER:**
```vb
Private btnAddRawMaterial As Button  ' "Add Ingredient" (includes both!)
' REMOVED: btnAddSubAssembly
```

**Changes:**
- ✅ Removed "Add Sub-Assembly" button completely
- ✅ Renamed "Add Raw Material" to "Add Ingredient"
- ✅ Removed `OnAddSubAssembly` method
- ✅ Removed event handler for deleted button

## HOW IT WORKS NOW

### The RawMaterials Table Structure:
```sql
RawMaterials
├── MaterialID (Primary Key)
├── MaterialCode
├── MaterialName
├── MaterialType  ← KEY FIELD!
│   ├── 'Raw' → Basic ingredients (Flour, Sugar, Butter)
│   ├── 'Sub Recipe' → Pre-made components (Dough Mix, Filling)
│   └── 'Ingredient' → Other materials
├── CurrentStock (legacy - for compatibility)
└── ... other fields
```

### The Recipe Building Flow:
1. User clicks **"Add Ingredient"** button
2. Dialog opens showing ALL items from `RawMaterials` table
3. Grid displays:
   - MaterialCode
   - MaterialName
   - **MaterialType** (shows "Raw", "Sub Recipe", etc.)
   - UoMCode
4. User selects any ingredient (raw or sub-recipe)
5. Ingredient is added to recipe with:
   - `MaterialID` populated
   - `IngredientType` = "RawMaterial" (even for sub-recipes!)
   - `SubAssemblyID` = NULL

### When Recipe is Saved:
```vb
' All ingredients (including sub-recipes) are saved to RecipeIngredient table
INSERT INTO RecipeIngredient (RecipeID, MaterialID, Quantity, UoM, IngredientType)
VALUES (@RecipeID, @MaterialID, @Qty, @UoM, 'RawMaterial')
```

### When BOM is Requested:
```vb
' BOMEditorForm loads ALL ingredients from RecipeIngredient
' Checks stock in StockroomStock table for the branch
SELECT ... FROM RecipeIngredient ri
INNER JOIN RawMaterials rm ON rm.MaterialID = ri.MaterialID
WHERE ri.RecipeID = @RecipeID
```

### When PO is Created for Shortages:
```vb
' PO lines are created with MaterialID for ALL ingredients
INSERT INTO PurchaseOrderLines (PurchaseOrderID, MaterialID, ItemSource, OrderedQuantity)
VALUES (@POID, @MaterialID, 'RM', @Qty)
```

### When Invoice is Captured (GRV):
```vb
' GetPurchaseOrderLines returns MaterialID for all ingredients
' InvoiceCaptureForm updates StockroomStock for the branch
UPDATE StockroomStock 
SET Quantity = Quantity + @ReceivedQty
WHERE ProductID = @MaterialID AND BranchID = @BranchID
```

## DATABASE SCHEMA

### Key Tables:
1. **RawMaterials** - Single source of truth for ALL ingredients
   - Contains both raw materials AND sub-recipes
   - Differentiated by `MaterialType` field

2. **Recipe** - Defines what products can be made
   - Links to `Demo_Retail_Product` table

3. **RecipeIngredient** - Lists ingredients for each recipe
   - Uses `MaterialID` to reference `RawMaterials`
   - Stores quantity and UoM

4. **StockroomStock** - Branch-specific inventory
   - Uses `ProductID` (which is actually `MaterialID` from RawMaterials)
   - Tracks quantity per branch

5. **PurchaseOrderLines** - PO line items
   - Uses `MaterialID` for ingredients
   - Uses `ProductID` for external products
   - `ItemSource` = 'RM' for raw materials/sub-recipes

## BENEFITS OF UNIFIED SYSTEM

1. **Simplicity** - One button, one dialog, one table
2. **Consistency** - All ingredients treated the same way
3. **No Confusion** - Clear that sub-recipes are just special ingredients
4. **Easier Maintenance** - Less code, fewer forms, fewer bugs
5. **Better UX** - Users don't need to know the difference between "raw material" and "sub-assembly"

## TESTING CHECKLIST

- [ ] Open Recipe Builder form
- [ ] Verify only ONE "Add Ingredient" button exists (no "Add Sub-Assembly")
- [ ] Click "Add Ingredient"
- [ ] Verify dialog title says "Select Ingredient (Raw Material or Sub-Recipe)"
- [ ] Verify grid shows MaterialType column
- [ ] Verify both raw materials AND sub-recipes appear in the list
- [ ] Select a raw material (e.g., Flour) - should add successfully
- [ ] Select a sub-recipe (e.g., Dough Mix) - should add successfully
- [ ] Save recipe
- [ ] Create BOM request for baker
- [ ] Verify shortage report shows BOTH raw materials and sub-recipes
- [ ] Create PO from shortages
- [ ] Capture invoice (GRV)
- [ ] Verify stock updates in StockroomStock for BOTH types
- [ ] Request BOM again - should not show shortage

## IMPORTANT NOTES

- Sub-recipes are NOT stored in a separate table
- Sub-recipes are NOT products in Demo_Retail_Product
- Sub-recipes ARE ingredients in RawMaterials table
- The term "Sub-Assembly" is legacy and should be avoided
- Use "Sub-Recipe" or "Ingredient" instead
- All ingredients use MaterialID, not ProductID
- StockroomStock.ProductID actually refers to RawMaterials.MaterialID

## NEXT STEPS

1. **Run SQL Migration**: `SQL\FIX_STOCKROOM_STOCK_SYNC.sql`
   - Populates StockroomStock from RawMaterials.CurrentStock
   - Standardizes MaterialType values

2. **Rebuild Application**
   - Clean Solution
   - Rebuild Solution

3. **Test Complete Flow**
   - Recipe → BOM → Shortage → PO → GRV → Stock Update

4. **Move to POS Development**
   - Once ERP stock management is working correctly
