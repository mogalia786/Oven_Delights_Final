# ItemType Standards for Products Table

## Product Classification

### ItemType Values:
1. **'internal'** - Products manufactured in-house (requires recipes in RecipeNode table)
2. **'external'** - Ready-made products purchased from suppliers for resale
3. **'Manufactured'** - Legacy value (being phased out, treat as 'internal')

## Updated Forms:

### BuildProductForm.vb
- **LoadProductsWithoutRecipe()**: Now queries `ItemType IN ('internal', 'Manufactured')`
- **ResolveOrCreateProduct()**: Creates new products with `ItemType = 'internal'`

### RecipeViewerForm.vb
- **LoadRecipes()**: Filters by `ItemType IN ('internal', 'Manufactured')`
- Shows only products that have recipes in RecipeNode table

### BOMEditorForm.vb
- No ItemType filtering (reads from RecipeNode table directly)

## Database Schema:

### Products Table
- **ItemType** column should contain: 'internal', 'external', or legacy 'Manufactured'
- **RecipeCreated** column: Currently contains UoM values (needs cleanup)
- **RecipeMethod** column: Stores recipe instructions (TEXT/NVARCHAR(MAX))

### RecipeNode Table
- Stores the actual recipe structure (bill of materials)
- Used by BOM system to create material requests

## Ledger Prefixes (from memory):
- Internal products: prefix with "i"
- External products: prefix with "x"

## Migration Notes:
- Existing products with `ItemType = 'Manufactured'` should be updated to 'internal'
- Forms now accept both values for backward compatibility
- New products will be created with 'internal'
