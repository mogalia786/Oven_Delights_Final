# Simplified Ingredient System - No More Sub-Assemblies

## Overview
The system has been simplified to treat ALL ingredients uniformly, eliminating the complexity of "sub-assemblies". Both raw materials (flour, butter, etc.) and sub-recipes (pre-made components) are now stored and managed in the **RawMaterials** table.

## Key Changes

### 1. Unified Ingredient Storage
- **RawMaterials table** now contains:
  - Regular ingredients (MaterialType = 'Ingredient', 'Dry Goods', etc.)
  - Sub-recipes (MaterialType = 'Sub Recipe', 'Sub Recipie', etc.)
- All are treated as "ingredients" for manufacturing purposes

### 2. Recipe System Simplified
**BOMEditorForm.vb - LoadBOM()**
- Query only selects from `RecipeIngredient.MaterialID`
- No more `SubAssemblyProductID` logic
- All ingredients joined to `RawMaterials` table
- Display format: `MaterialCode - MaterialName`

**BOMEditorForm.vb - OnSubmit()**
- InternalOrderLines insertion simplified:
  - `ItemType` = 'RawMaterial' for ALL ingredients
  - `RawMaterialID` = `ri.MaterialID`
  - `ProductID` = NULL (not used)
  - Filter: `WHERE ri.MaterialID IS NOT NULL`

### 3. Stock Checking Simplified
**BOMEditorForm.vb - CheckIngredientAvailability()**
- Single stock check: `RawMaterials.CurrentStock`
- No more separate checks for sub-assemblies in RetailStock
- All ingredients (including sub-recipes) checked in one place

### 4. Stockroom Fulfillment Simplified
**InternalOrdersForm.vb - LoadLinesForSelected() & PreselectInternalOrder()**
- Query simplified to INNER JOIN only `RawMaterials`
- No more CASE statements for different item types
- No more joins to `Demo_Retail_Product`
- Display: `MaterialCode - MaterialName` for ALL items
- Stock availability: `RawMaterials.CurrentStock` for ALL items

### 5. Manufacturing Report Fixed
**ManufacturingStockReportForm.vb**
- Removed `StockroomService` dependency
- Loads branches directly from database
- Uses `ISNULL(rm.UnitOfMeasure, rm.BaseUnit)` for UoM
- All null checks added to prevent errors

### 6. Stockroom Report Fixed
**StockroomStockReportForm.vb**
- Uses `MaterialType` instead of non-existent `MaterialCategories`
- Shows all items from `RawMaterials` table
- Highlights low stock items in red

## Benefits

### ✅ Simpler
- One table for all ingredients (`RawMaterials`)
- One stock location (Stockroom)
- One fulfillment process
- No complex type checking

### ✅ More Reliable
- No "Unknown Component" errors
- No missing sub-assembly data
- Consistent naming across all forms
- Single source of truth for stock levels

### ✅ Easier to Maintain
- Less code duplication
- Fewer joins in queries
- Clearer data flow
- Easier to understand for users

## Data Migration Notes

If you have existing sub-assemblies in the system:
1. They should be added to `RawMaterials` table with `MaterialType = 'Sub Recipe'`
2. Update `RecipeIngredient` to reference them via `MaterialID` (not `SubAssemblyProductID`)
3. Ensure they have proper stock levels in `RawMaterials.CurrentStock`

## Stock Flow

```
Purchase Order (Ingredients/Sub-Recipes)
    ↓
Stockroom (RawMaterials.CurrentStock)
    ↓
Issue to Manufacturing (BOM Fulfillment)
    ↓
Manufacturing WIP (Manufacturing_Inventory)
    ↓
Complete Production
    ↓
Retail Stock (RetailStock - finished products only)
```

## Testing Checklist

- [ ] Create recipe with regular ingredients
- [ ] Create recipe with sub-recipes (MaterialType = 'Sub Recipe')
- [ ] Request BOM - verify all items show with proper names
- [ ] Check shortage report - verify sub-recipes show stock levels
- [ ] Fulfill BOM - verify stock reduces from RawMaterials
- [ ] View Manufacturing Stock Report - no errors
- [ ] View Stockroom Stock Report - shows all materials including sub-recipes
