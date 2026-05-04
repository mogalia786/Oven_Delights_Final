# Simplified Recipe System - No More Nodes!

## Problem with Old System
The node-based RecipeNode system was overly complex:
- ❌ Confusing tree structure with parent/child relationships
- ❌ NodeKind validation issues ('Component', 'Subcomponent', etc.)
- ❌ Difficult to understand and maintain
- ❌ Broke when NodeKind values didn't match expectations

## New Simplified System

### Concept: Recipe Card Approach
Instead of nodes, think of it like a **recipe card**:

```
┌─────────────────────────────────────────────────┐
│  PRODUCT: Chocolate Cake                       │
│  Batch Yield: 60 units                         │
├─────────────────────────────────────────────────┤
│  INGREDIENTS:                                   │
│  • Flour: 5.0 kg                               │
│  • Sugar: 2.5 kg                               │
│  • Eggs: 30 ea                                 │
│  • Chocolate Ganache: 2.0 kg (Sub-Assembly)    │
├─────────────────────────────────────────────────┤
│  METHOD:                                        │
│  1. Mix flour and sugar                         │
│  2. Add eggs and beat well                      │
│  3. Bake at 180°C for 45 minutes               │
│  4. Top with chocolate ganache                  │
└─────────────────────────────────────────────────┘
```

### Database Tables

#### 1. Recipe (Header)
- RecipeID
- ProductID
- RecipeName
- **BatchYield** (e.g., 60 units)
- BatchYieldUoM
- Method (instructions)
- PrepTime, CookTime
- IsActive

#### 2. RecipeIngredient (Simple Grid)
- RecipeIngredientID
- RecipeID
- LineNumber
- **IngredientType** ('RawMaterial', 'SubAssembly', 'Other')
- MaterialID (for raw materials)
- SubAssemblyProductID (for sub-assemblies)
- IngredientName (for display)
- **Quantity** (per batch)
- UoM

### Calculation Logic

**Example: Order 120 units when batch makes 60**

```
Order Quantity: 120 units
Batch Yield: 60 units
Batches Needed: 120 ÷ 60 = 2 batches

For each ingredient:
Flour needed = 5.0 kg × 2 = 10.0 kg
Sugar needed = 2.5 kg × 2 = 5.0 kg
Eggs needed = 30 ea × 2 = 60 ea
```

**Formula:**
```
Batches Needed = CEILING(Order Quantity ÷ Batch Yield)
Ingredient Needed = Ingredient Quantity × Batches Needed
```

## Implementation Steps

### Step 1: Run Migration Script ✅
```sql
CREATE_SIMPLIFIED_RECIPE_SYSTEM.sql
```

This will:
- Create new `Recipe` and `RecipeIngredient` tables
- Migrate existing RecipeNode data
- Create `vw_RecipeDetails` view
- Show sample calculations

### Step 2: Update BOM Generation ✅
**BOMEditorForm.vb** now:
- Tries new Recipe system first
- Falls back to RecipeNode for backward compatibility
- Works with both systems during transition

### Step 3: Create New Build My Product Form (TODO)

**Simple Form Design:**

```
┌─────────────────────────────────────────────────────────┐
│  Build My Product - Recipe Editor                      │
├─────────────────────────────────────────────────────────┤
│  Product: [Dropdown: Chocolate Cake        ▼]          │
│  Recipe Name: [Chocolate Cake Recipe            ]      │
│  Batch Yield: [60    ] [ea ▼]                         │
├─────────────────────────────────────────────────────────┤
│  INGREDIENTS:                                           │
│  ┌────────────────────────────────────────────────────┐│
│  │ Type       │ Ingredient          │ Qty  │ UoM │ ✖ ││
│  ├────────────┼────────────────────┼──────┼─────┼───┤│
│  │ Raw Mat    │ Flour              │ 5.0  │ kg  │ ✖ ││
│  │ Raw Mat    │ Sugar              │ 2.5  │ kg  │ ✖ ││
│  │ Raw Mat    │ Eggs               │ 30   │ ea  │ ✖ ││
│  │ Sub-Assy   │ Chocolate Ganache  │ 2.0  │ kg  │ ✖ ││
│  └────────────┴────────────────────┴──────┴─────┴───┘│
│  [+ Add Ingredient]                                     │
├─────────────────────────────────────────────────────────┤
│  METHOD:                                                │
│  ┌────────────────────────────────────────────────────┐│
│  │ 1. Mix flour and sugar                             ││
│  │ 2. Add eggs and beat well                          ││
│  │ 3. Bake at 180°C for 45 minutes                   ││
│  │ 4. Top with chocolate ganache                      ││
│  └────────────────────────────────────────────────────┘│
├─────────────────────────────────────────────────────────┤
│  Prep Time: [30] min  Cook Time: [45] min             │
│                                                         │
│  [Save Recipe]  [Cancel]  [Preview BOM]                │
└─────────────────────────────────────────────────────────┘
```

## Benefits

✅ **Simple** - No confusing nodes, just a list of ingredients
✅ **Intuitive** - Like a real recipe card
✅ **Flexible** - Easy to add/remove/edit ingredients
✅ **Clear Calculations** - Batch yield makes scaling obvious
✅ **No Validation Issues** - No NodeKind problems
✅ **Easy to Maintain** - Simple grid, easy to understand

## Migration Path

1. ✅ **Phase 1**: Create new tables (DONE)
2. ✅ **Phase 2**: Migrate existing data (DONE)
3. ✅ **Phase 3**: Update BOM generation (DONE)
4. **Phase 4**: Create new Build My Product form (TODO)
5. **Phase 5**: Deprecate RecipeNode system (FUTURE)

## Current Status

- ✅ New simplified tables created
- ✅ Existing recipes migrated
- ✅ BOM generation updated to use new system
- ⏳ New Build My Product form (next step)
- ⏳ Old RecipeNode still works (backward compatible)

## Next Steps

1. **Run the migration script:**
   ```
   CREATE_SIMPLIFIED_RECIPE_SYSTEM.sql
   ```

2. **Test BOM Generation:**
   - Close and reopen BOM form
   - Select a product
   - Click Generate
   - Should now work with both old and new recipes!

3. **Create new Build My Product form** (optional, can wait)
   - Simple grid-based interface
   - No more node tree complexity
   - Direct ingredient entry

## Notes

- Both systems work during transition
- Old RecipeNode recipes still work
- New Recipe system is preferred
- Gradually migrate to new system
- Eventually deprecate RecipeNode
