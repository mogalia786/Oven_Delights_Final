# Recipe to BOM Workflow - Complete Guide

## ✅ SYSTEM IS READY AND WORKING!

Your new simplified recipe system is fully integrated with the BOM generation process. Here's how it all works together:

---

## 📋 WORKFLOW OVERVIEW

### 1. **Create Recipe (Build My Product Form)**
   - Navigate: **Manufacturing Menu → Build My Product**
   - Select an Internal product from the dropdown
   - Enter recipe details:
     - Recipe Name
     - Batch Yield (e.g., 12 units)
     - Batch UoM (e.g., "ea" for each)
   - Add ingredients:
     - **Raw Materials** (flour, butter, sugar, etc.)
     - **Sub-Assemblies** (other internal products used as components)
   - Enter Method/Instructions
   - Add Prep Time and Cook Time
   - **Save Recipe** ✅
   - **Print Recipe** 🖨️ (beautiful recipe card)
   - **Email Recipe** 📧

### 2. **Create Re-Order Book (Manager)**
   - Manager creates a re-order book via `ReOrderBookManagerForm`
   - Adds products that need to be manufactured
   - Specifies quantities required
   - Assigns to a Baker/Manufacturer
   - Posts the re-order book

### 3. **Baker Views Production Orders**
   - Baker opens their production view: `BakerProductionViewForm`
   - Sees all re-order books assigned to them
   - Clicks on a re-order book to see product lines
   - **Clicks "Request BOM"** button

### 4. **BOM Generation (AUTOMATIC)**
   When "Request BOM" is clicked:
   
   ✅ **System automatically:**
   - Queries the `Recipe` table for each product
   - Loads ingredients from `RecipeIngredient` table
   - Gets the `BatchYield` from the recipe
   - **Calculates quantities** based on production needs:
     ```
     Batches Needed = CEILING(Production Qty ÷ Batch Yield)
     Ingredient Qty = Qty Per Batch × Batches Needed
     ```
   - **Checks stock availability** for raw materials
   - Displays BOM with:
     - ✅ Green = Available in stock
     - ⚠️ Yellow/Red = Insufficient stock

### 5. **Example Calculation**
   ```
   Product: Bar One Round
   Recipe Batch Yield: 12 units
   Production Order: 50 units
   
   Calculation:
   - Batches Needed = CEILING(50 ÷ 12) = 5 batches
   
   Recipe Ingredients (per batch):
   - Flour: 2 kg
   - Butter: 0.5 kg
   - Sugar: 1 kg
   
   BOM Quantities (for 50 units):
   - Flour: 2 × 5 = 10 kg
   - Butter: 0.5 × 5 = 2.5 kg
   - Sugar: 1 × 5 = 5 kg
   ```

---

## 🔧 TECHNICAL DETAILS

### Database Tables Used:
1. **Recipe** - Header table with ProductID, RecipeName, BatchYield, Method, etc.
2. **RecipeIngredient** - Line items with MaterialID, SubAssemblyProductID, Quantity, UoM
3. **RawMaterials** - Raw material master data
4. **Demo_Retail_Product** - Product master (Internal products)
5. **RawMaterialStock** - Stock levels per branch

### Key Code Locations:
- **Recipe Builder Form**: `Forms\Manufacturing\RecipeBuilderForm.vb`
- **BOM Editor Form**: `Forms\Manufacturing\BOMEditorForm.vb`
  - Line 575-593: Recipe query logic
  - Line 1549-1590: Quantity calculation method
  - Line 1595-1647: Stock availability check
- **Baker Production View**: `Forms\Manufacturing\BakerProductionViewForm.vb`
  - Line 333-388: Request BOM button logic

### SQL Query (BOM Generation):
```sql
-- Check if Recipe exists
IF EXISTS (SELECT 1 FROM dbo.Recipe WHERE ProductID = @pid AND IsActive = 1)
BEGIN
    -- Load recipe ingredients
    SELECT 
        ri.LineNumber,
        COALESCE(
            CASE WHEN ri.IngredientType = 'RawMaterial' AND rm.MaterialID IS NOT NULL 
                 THEN CONCAT(rm.MaterialCode, ' - ', rm.MaterialName) END,
            CASE WHEN ri.IngredientType = 'SubAssembly' AND sp.ProductID IS NOT NULL 
                 THEN sp.Name END,
            ri.IngredientName,
            'Unknown Component'
        ) AS ComponentName,
        ri.Quantity AS QuantityPerBatch,
        ISNULL(ri.UoM, '') AS UoM,
        ri.MaterialID AS RawMaterialID
    FROM dbo.Recipe r
    INNER JOIN dbo.RecipeIngredient ri ON ri.RecipeID = r.RecipeID
    LEFT JOIN dbo.RawMaterials rm ON rm.MaterialID = ri.MaterialID
    LEFT JOIN dbo.Demo_Retail_Product sp ON sp.ProductID = ri.SubAssemblyProductID
    WHERE r.ProductID = @pid AND r.IsActive = 1
    ORDER BY ri.LineNumber;
END
```

---

## ✅ WHAT'S WORKING

1. ✅ Recipe creation with raw materials and sub-assemblies
2. ✅ Recipe saving to database
3. ✅ Recipe loading for existing products
4. ✅ BOM generation from recipes
5. ✅ Automatic quantity calculation based on batch yield
6. ✅ Stock availability checking
7. ✅ Print recipe card (beautiful format)
8. ✅ Email recipe functionality
9. ✅ Integration with baker workflow

---

## 📝 USER INSTRUCTIONS

### For Product Managers:
1. Create recipes for all internal products using "Build My Product"
2. Ensure batch yields are accurate
3. Verify all ingredients are in the system

### For Bakers/Manufacturers:
1. Open your production view
2. Select a re-order book
3. Click "Request BOM"
4. System will show you exactly what ingredients you need
5. Check stock availability (green = good, red = need to order)
6. Start production when ready

### For Stockroom:
1. When BOM is requested, fulfill ingredients to manufacturing
2. System tracks ingredient movement
3. Stock levels update automatically

---

## 🎉 COMPLETE INTEGRATION

The system now has:
- ✅ **Simple recipe management** (no more complex nodes)
- ✅ **Automatic BOM generation** from recipes
- ✅ **Smart quantity calculation** based on batch yields
- ✅ **Stock availability checking**
- ✅ **Beautiful recipe cards** for printing
- ✅ **Email functionality** for sharing recipes
- ✅ **Full integration** with manufacturing workflow

**Everything is connected and working!** 🚀

---

## 📞 SUPPORT

If a product doesn't show ingredients when generating BOM:
1. Check if a recipe exists for that product in "Build My Product"
2. Verify the recipe has ingredients added
3. Ensure the recipe is saved (not just drafted)
4. Check that the product is marked as "Internal" type

The system will show a message: "No recipe/BOM found for this product. Please create a recipe in 'Build My Product' first."
