# Create Product Recipe Form - Complete Redesign

## Overview
Major refactoring of the Create Product Recipe form to unify component management and improve cost visibility with VAT and ADHOC charges.

---

## Key Changes

### 1. **Unified Components Section**
- **Removed**: Separate "Sub-Recipes" and "Packaging/Decorations" sections
- **Added**: Single "Components" dropdown and grid
- **Components Include**:
  - Sub-Recipes (only those with recipes saved in `Demo_SubRecipe_Master`)
  - Ingredients
  - Consumables
  - Packaging
  - Miscellaneous items

### 2. **Components Grid Columns**
| Column | Description |
|--------|-------------|
| ComponentID | Hidden - ProductID |
| ComponentType | Hidden - "SubRecipe" or "Other" |
| ComponentName | Component name |
| Category | Product category (visible) |
| Quantity | Editable quantity |
| CostPerUnit | Cost per unit (read-only) |
| TotalCost | Calculated total (read-only) |
| Edit | Button - Only enabled for sub-recipes |
| Delete | Button - Remove component |

### 3. **Edit Sub-Recipe On-The-Fly**
- Click "Edit" button on any sub-recipe component
- Opens `CreateSubRecipeForm` in edit mode
- After editing and saving:
  - Cost automatically refreshes
  - Consolidated BOM updates
  - Total costs recalculate

### 4. **Consolidated BOM (Auto-Generated)**
Shows complete ingredient breakdown:
- **Sub-recipes**: Expanded to show all ingredients
- **Direct components**: Ingredients, packaging, etc. added directly
- **Consolidation**: Same ingredients from multiple sources are summed

### 5. **Cost Display - 3 Sections**

**Section 1 (Green)** - Per Unit Cost:
```
1 UNIT: Excl VAT: R100.00 | VAT (15%): R15.00 | Incl VAT: R115.00
```

**Section 2 (Blue)** - Full Batch Cost:
```
BATCH (10 units): Excl VAT: R1000.00 | VAT (15%): R150.00 | Incl VAT: R1150.00
```

**Section 3 (Orange)** - With 15% ADHOC:
```
WITH ADHOC (+15%): Excl VAT: R115.00 | VAT (15%): R17.25 | Incl VAT: R132.25 per unit | Batch Total Incl VAT: R1322.50
```

---

## Technical Implementation

### Form Controls Changed
- `cboSubRecipe` → `cboComponent`
- `txtSubRecipeQty` → `txtComponentQty`
- `btnAddSubRecipe` → `btnAddComponent`
- `dgvSubRecipes` → `dgvComponents`
- `dgvPackaging` → **Removed**
- `lblBatchCost` → **Added** (new label for batch totals)

### Methods Updated

#### `LoadComponents()`
```sql
-- Loads all component types
-- For sub-recipes: Only shows those with recipes in Demo_SubRecipe_Master
SELECT MIN(p.ProductID), p.Name, p.Category
FROM Demo_Retail_Product p
LEFT JOIN Demo_SubRecipe_Master sr ON p.ProductID = sr.SubRecipeID
WHERE p.IsActive = 1
  AND (
    (Category LIKE '%ingredient%') OR
    (Category LIKE '%consumable%') OR
    (Category LIKE '%pack%') OR
    (Category LIKE '%misce%') OR
    ((Category LIKE '%sub%recipe%') AND sr.SubRecipeID IS NOT NULL)
  )
```

#### `btnAddComponent_Click()`
- Validates component selection
- Checks for duplicates (no duplicate components allowed)
- For sub-recipes: Validates recipe exists
- Gets cost based on type:
  - Sub-recipes: From `CalculateSubRecipeTotalCost()`
  - Others: From `Demo_Retail_Product.AverageCost`
- Adds to components grid
- Refreshes Consolidated BOM

#### `LoadConsolidatedBOM()`
- Processes all components in grid
- **Sub-recipes**: Expands to show ingredients using `GetSubRecipeIngredients()`
- **Other components**: Adds directly to consolidated list
- **Consolidation**: Sums quantities for duplicate ingredients
- Displays in `dgvConsolidatedBOM`

#### `CalculateTotalCost()`
- Sums all component costs
- Divides by batch quantity for per-unit cost
- Calculates 3 sections:
  1. Per unit with VAT
  2. Batch total with VAT
  3. With 15% ADHOC + VAT
- Updates 3 labels with color coding

#### `dgvComponents_CellContentClick()`
- **Edit button**: Opens sub-recipe for editing (sub-recipes only)
- **Delete button**: Removes component from grid
- After edit/delete: Refreshes Consolidated BOM and totals

### Database Integration
- Saves all components to `Demo_Product_BOM`
- `ComponentType` field stores "SubRecipe" or "Other"
- Existing stored procedures work without changes

---

## User Workflow

### Creating a Product Recipe

1. **Select Product**
   - Choose from manufactured products dropdown

2. **Set Batch Quantity**
   - Enter how many units this recipe makes

3. **Add Components**
   - Select from unified Components dropdown
   - Enter quantity
   - Click "Add Component"
   - Repeat for all components

4. **Edit Sub-Recipes (Optional)**
   - Click "Edit" button on any sub-recipe
   - Modify ingredients in popup
   - Save - costs auto-refresh

5. **Review Consolidated BOM**
   - Auto-generated ingredient breakdown
   - Shows total quantities needed

6. **Review Costs**
   - **Green**: Per unit cost
   - **Blue**: Batch cost
   - **Orange**: With ADHOC charges

7. **Enter Method**
   - Add production instructions

8. **Save Recipe**
   - All components saved to database
   - Costs calculated and stored

---

## Benefits

### For Users
✅ **Simpler Interface**: One dropdown instead of multiple sections  
✅ **More Flexible**: Add any component type (ingredients, packaging, etc.)  
✅ **On-the-Fly Editing**: Edit sub-recipes without leaving the form  
✅ **Better Visibility**: See complete ingredient breakdown  
✅ **Clear Costing**: 3 levels of cost with VAT breakdown  

### For Business
✅ **Accurate Costing**: Includes VAT and ADHOC charges  
✅ **Complete BOM**: All ingredients consolidated  
✅ **Flexible Recipes**: Mix sub-recipes with direct ingredients  
✅ **Cost Transparency**: See impact of ADHOC charges  

---

## Important Notes

### ADHOC Charges
- **Sub-Recipe Creation**: NO ADHOC charges (pure ingredient cost)
- **Product Recipe Creation**: 15% ADHOC charges applied
- This allows proper cost buildup from ingredients → sub-recipes → products

### VAT Handling
- All costs stored **EXCLUSIVE of VAT**
- VAT (15%) calculated for display only
- Standard South African VAT rate

### Component Types
- **SubRecipe**: Components from `Demo_SubRecipe_Master`
- **Other**: All other components (ingredients, packaging, etc.)

### Edit Functionality
- Only sub-recipes can be edited from this form
- Edit button disabled for other component types
- After editing, costs refresh automatically

---

## Files Modified

1. **CreateProductRecipeForm.vb**
   - Complete refactoring of component management
   - New unified components grid
   - 3-section cost display with VAT
   - Edit sub-recipe functionality

2. **CreateSubRecipeForm.vb**
   - Added `LoadSubRecipeForEditing()` method
   - Supports being opened for editing from product recipe form

3. **RecipeCostCalculationService.vb**
   - Fixed `GetSubRecipeIngredients()` to query correct table
   - Now reads from `Demo_SubRecipe_Ingredients`

---

## Testing Checklist

- [ ] Components dropdown shows all categories
- [ ] Sub-recipes only show if recipe exists
- [ ] Cannot add duplicate components
- [ ] Edit button works for sub-recipes
- [ ] Edit button disabled for other components
- [ ] Consolidated BOM shows all ingredients
- [ ] Consolidated BOM consolidates duplicates
- [ ] Cost calculations are correct
- [ ] VAT calculations are correct (15%)
- [ ] ADHOC calculations are correct (15%)
- [ ] Batch quantity affects per-unit cost
- [ ] Save stores all components correctly
- [ ] Load existing recipe works
- [ ] Delete component works
- [ ] Edit quantity recalculates costs

---

**Last Updated**: January 2026  
**ADHOC Rate**: 15%  
**VAT Rate**: 15%  
**Cost Basis**: Exclusive of VAT
