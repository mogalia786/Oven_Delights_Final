# RECIPE MANAGEMENT SYSTEM - WOW FACTOR FEATURE

## Overview
Professional two-tier recipe management system for confectionery manufacturing with dynamic cost calculation and BOM consolidation.

---

## System Architecture

### Two-Tier Hierarchy

```
TIER 1: SUB-RECIPES (Components)
├── Ingredients (flour, sugar, eggs, etc.)
├── Method/Instructions
├── Batch Quantity
└── Cost Per Sub-Recipe

TIER 2: PRODUCTS (Final Goods)
├── Sub-Recipes (multiple)
├── Packaging/Decorations/Toppings
├── Method/Assembly Instructions
├── Batch Quantity
└── Cost Per Product (CONSOLIDATED)
```

---

## Business Rules

### Critical Rules
1. **Cannot create Product Recipe without ALL Sub-Recipe recipes existing first**
2. **Cost dynamically updates** when Purchase Orders change Last Paid Price
3. **Unit breakdown**: All ingredients broken down to smallest unit (per gram/ml/unit)
4. **Consolidation**: Product BOM consolidates duplicate ingredients across ALL sub-recipes
5. **All costs EXCLUDE VAT** (from Demo_Retail_Price.LastPaidPrice)
6. **Real-time validation**: System checks if Sub-Recipe has recipe before allowing Product creation

### Cost Calculation Formula
```
Ingredient Cost = (LastPaidPrice ÷ Package Size) × Quantity Required

Example:
- Purchase: 500g Salt @ R10.00 (excl VAT)
- Cost Per Gram: R10.00 ÷ 500g = R0.02/g
- Recipe needs: 75g
- Ingredient Cost: R0.02 × 75g = R1.50
```

---

## Example Workflow

### Scenario: Creating Chocolate Cake Recipe

#### Step 1: Create Sub-Recipe "Chocolate Batter"
```
Sub-Recipe: Chocolate Batter
Batch Qty: 1 batch

Ingredients:
- 200g Flour       @ R0.05/g = R10.00
- 100g Sugar       @ R0.03/g = R3.00
- 50g Cocoa        @ R0.10/g = R5.00
- 3 Eggs           @ R2.50/egg = R7.50

Method:
1. Sift flour and cocoa together
2. Beat eggs and sugar until fluffy
3. Fold in dry ingredients
4. Mix until smooth

TOTAL COST PER BATCH: R25.50
```

#### Step 2: Create Sub-Recipe "Cream Filling"
```
Sub-Recipe: Cream Filling
Batch Qty: 1 batch

Ingredients:
- 100g Flour       @ R0.05/g = R5.00
- 150g Butter      @ R0.08/g = R12.00
- 75g Sugar        @ R0.03/g = R2.25
- 200ml Milk       @ R0.02/ml = R4.00

Method:
1. Melt butter in saucepan
2. Add flour and cook for 2 minutes
3. Gradually add milk, stirring constantly
4. Add sugar and cook until thick

TOTAL COST PER BATCH: R23.25
```

#### Step 3: Create Sub-Recipe "Chocolate Ganache"
```
Sub-Recipe: Chocolate Ganache
Batch Qty: 1 batch

Ingredients:
- 200g Dark Chocolate @ R0.15/g = R30.00
- 100ml Cream         @ R0.05/ml = R5.00

Method:
1. Heat cream until simmering
2. Pour over chopped chocolate
3. Stir until smooth and glossy

TOTAL COST PER BATCH: R35.00
```

#### Step 4: Create Product Recipe "Chocolate Cake"
```
Product: Chocolate Cake
Batch Qty: 1 cake

Sub-Recipes:
- 1 × Chocolate Batter    = R25.50
- 1 × Cream Filling       = R23.25
- 1 × Chocolate Ganache   = R35.00

Packaging & Decorations:
- Cake Box               = R5.00
- Ribbon                 = R2.00
- Cake Board             = R3.50

Method:
1. Bake chocolate batter in 2 layers
2. Cool completely
3. Spread cream filling between layers
4. Pour ganache over top
5. Decorate and package

CONSOLIDATED BOM (Auto-Generated):
┌─────────────────┬──────────┬──────────┐
│ Ingredient      │ Quantity │ Cost     │
├─────────────────┼──────────┼──────────┤
│ Flour           │ 300g     │ R15.00   │ (200g + 100g)
│ Sugar           │ 175g     │ R5.25    │ (100g + 75g)
│ Cocoa           │ 50g      │ R5.00    │
│ Eggs            │ 3        │ R7.50    │
│ Butter          │ 150g     │ R12.00   │
│ Milk            │ 200ml    │ R4.00    │
│ Dark Chocolate  │ 200g     │ R30.00   │
│ Cream           │ 100ml    │ R5.00    │
│ Cake Box        │ 1        │ R5.00    │
│ Ribbon          │ 1        │ R2.00    │
│ Cake Board      │ 1        │ R3.50    │
└─────────────────┴──────────┴──────────┘

TOTAL COST PER CAKE: R94.25
```

---

## Database Schema

### Demo_SubRecipe_BOM
Stores ingredient lists for each sub-recipe.

```sql
CREATE TABLE Demo_SubRecipe_BOM (
    BOMLineID INT IDENTITY(1,1) PRIMARY KEY,
    SubRecipeID INT NOT NULL,
    IngredientID INT NOT NULL,
    Quantity DECIMAL(18,4) NOT NULL,
    UnitOfMeasure VARCHAR(20) NOT NULL,
    CostPerUnit DECIMAL(18,4) NOT NULL,
    TotalCost AS (Quantity * CostPerUnit) PERSISTED,
    CreatedDate DATETIME DEFAULT GETDATE(),
    LastUpdated DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (SubRecipeID) REFERENCES Demo_Retail_Product(ProductID),
    FOREIGN KEY (IngredientID) REFERENCES Demo_Retail_Product(ProductID)
)
```

### Demo_SubRecipe_Master
Stores sub-recipe header information.

```sql
CREATE TABLE Demo_SubRecipe_Master (
    SubRecipeID INT PRIMARY KEY,
    Method NVARCHAR(MAX),
    BatchQty DECIMAL(18,4) DEFAULT 1,
    TotalCost DECIMAL(18,4),
    IsActive BIT DEFAULT 1,
    CreatedBy INT,
    CreatedDate DATETIME DEFAULT GETDATE(),
    LastUpdated DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (SubRecipeID) REFERENCES Demo_Retail_Product(ProductID)
)
```

### Demo_Product_BOM
Stores sub-recipe and packaging lists for each product.

```sql
CREATE TABLE Demo_Product_BOM (
    BOMLineID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    ComponentType VARCHAR(20) NOT NULL, -- 'SubRecipe' or 'Packaging'
    ComponentID INT NOT NULL,
    Quantity DECIMAL(18,4) NOT NULL,
    CostPerUnit DECIMAL(18,4) NOT NULL,
    TotalCost AS (Quantity * CostPerUnit) PERSISTED,
    CreatedDate DATETIME DEFAULT GETDATE(),
    LastUpdated DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ProductID) REFERENCES Demo_Retail_Product(ProductID),
    FOREIGN KEY (ComponentID) REFERENCES Demo_Retail_Product(ProductID)
)
```

### Demo_Product_Recipe_Master
Stores product recipe header information.

```sql
CREATE TABLE Demo_Product_Recipe_Master (
    ProductID INT PRIMARY KEY,
    Method NVARCHAR(MAX),
    BatchQty DECIMAL(18,4) DEFAULT 1,
    TotalCost DECIMAL(18,4),
    IsActive BIT DEFAULT 1,
    CreatedBy INT,
    CreatedDate DATETIME DEFAULT GETDATE(),
    LastUpdated DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ProductID) REFERENCES Demo_Retail_Product(ProductID)
)
```

### View: vw_Product_BOM_Consolidated
Consolidates all ingredients across sub-recipes for a product.

```sql
CREATE VIEW vw_Product_BOM_Consolidated AS
SELECT 
    pb.ProductID,
    p.Name AS ProductName,
    i.ProductID AS IngredientID,
    i.Name AS IngredientName,
    SUM(sb.Quantity * pb.Quantity) AS TotalQuantity,
    sb.UnitOfMeasure,
    MAX(sb.CostPerUnit) AS CostPerUnit,
    SUM(sb.Quantity * pb.Quantity * sb.CostPerUnit) AS TotalCost
FROM Demo_Product_BOM pb
INNER JOIN Demo_Retail_Product p ON pb.ProductID = p.ProductID
INNER JOIN Demo_SubRecipe_BOM sb ON pb.ComponentID = sb.SubRecipeID
INNER JOIN Demo_Retail_Product i ON sb.IngredientID = i.ProductID
WHERE pb.ComponentType = 'SubRecipe'
GROUP BY pb.ProductID, p.Name, i.ProductID, i.Name, sb.UnitOfMeasure
```

---

## Forms & Features

### 1. Create Sub-Recipe Form
**Menu Path**: Manufacturing > Products > Create Sub-Recipe

**Features**:
- Dropdown: Select Sub-Recipe (validates if recipe already exists)
- Dropdown: Select Ingredients (multi-select from ingredients category)
- Grid: Ingredient list with Qty, Unit, Cost/Unit, Total Cost
- TextBox: Method (multiline, rich text)
- TextBox: Batch Qty
- Label: **Total Cost Per Sub-Recipe** (auto-calculated)
- Buttons: Save, Print, Clear, Cancel

**Validation**:
- Check if recipe already exists for selected sub-recipe
- Ensure at least one ingredient selected
- Validate quantities > 0
- Ensure method is not empty

**Cost Calculation**:
- Fetch LastPaidPrice from Demo_Retail_Price (EXCLUDE VAT)
- Break down to smallest unit (per gram/ml/unit)
- Calculate: Quantity × CostPerUnit
- Sum all ingredient costs

---

### 2. Edit Sub-Recipe Form
**Menu Path**: Manufacturing > Products > Edit Sub-Recipe

**Features**:
- Dropdown: Select existing Sub-Recipe (only those with recipes)
- Load existing ingredients, method, batch qty
- Allow modifications
- Recalculate costs on changes
- Update database

---

### 3. Create Product Recipe Form
**Menu Path**: Manufacturing > Products > Create Product Recipe

**Features**:
- Dropdown: Select Product (validates if recipe already exists)
- Dropdown: Select Sub-Recipes (multi-select, **validates recipe exists**)
- Grid: Sub-Recipe list with Qty, Cost/Unit, Total Cost
- Dropdown: Select Packaging/Misc items
- Grid: Packaging list with Qty, Cost/Unit, Total Cost
- TextBox: Method (multiline, rich text)
- TextBox: Batch Qty
- Label: **Total Cost Per Product** (auto-calculated, consolidated)
- Panel: **Consolidated BOM Preview** (shows aggregated ingredients)
- Buttons: Save, Print, Clear, Cancel

**Critical Validation**:
- **GOLDEN RULE**: If ANY selected sub-recipe does NOT have a recipe, ABORT and show error
- User must create missing sub-recipe first
- Ensure at least one sub-recipe selected
- Validate quantities > 0

**Cost Calculation**:
- Sum all sub-recipe costs (Quantity × Sub-Recipe Total Cost)
- Add all packaging costs
- Display consolidated ingredient breakdown
- Show total cost per product

---

### 4. Edit Product Recipe Form
**Menu Path**: Manufacturing > Products > Edit Product Recipe

**Features**:
- Dropdown: Select existing Product (only those with recipes)
- Load existing sub-recipes, packaging, method, batch qty
- Allow modifications
- Recalculate costs on changes
- Update database

---

## BOM Generation for Manufacturing

### Workflow
When manufacturing request is made for a product:

1. **Lookup Product Recipe**
   - Check if recipe exists in Demo_Product_Recipe_Master
   - If not, show error: "Recipe not created for this product"

2. **Generate Consolidated BOM**
   - Query vw_Product_BOM_Consolidated
   - Get all ingredients with consolidated quantities
   - Include packaging items

3. **Create Manufacturing Order**
   - Generate BOM document
   - List all ingredients with quantities
   - Show total cost
   - Print production sheet

---

## Cost Update Mechanism

### Automatic Updates
When Purchase Order invoice is captured and LastPaidPrice changes:

1. **Trigger**: sp_UpdateRecipeCosts
2. **Process**:
   - Recalculate CostPerUnit for affected ingredients
   - Update Demo_SubRecipe_BOM.CostPerUnit
   - Recalculate Demo_SubRecipe_Master.TotalCost
   - Recalculate Demo_Product_Recipe_Master.TotalCost
3. **Result**: All recipe costs reflect current pricing

### Manual Refresh
- Button on forms: "Refresh Costs"
- Recalculates all costs based on current LastPaidPrice
- Updates all BOM tables

---

## Printing & Reports

### Sub-Recipe Production Sheet
```
╔══════════════════════════════════════════════════════════╗
║           OVEN DELIGHTS - SUB-RECIPE SHEET              ║
╠══════════════════════════════════════════════════════════╣
║ Sub-Recipe: Chocolate Batter                             ║
║ Batch Qty: 1 batch                                       ║
║ Date: 10 Jan 2026                                        ║
╠══════════════════════════════════════════════════════════╣
║ INGREDIENTS:                                             ║
║ ┌────────────────────┬──────────┬──────────────────────┐ ║
║ │ Ingredient         │ Quantity │ Cost                 │ ║
║ ├────────────────────┼──────────┼──────────────────────┤ ║
║ │ Flour              │ 200g     │ R10.00               │ ║
║ │ Sugar              │ 100g     │ R3.00                │ ║
║ │ Cocoa              │ 50g      │ R5.00                │ ║
║ │ Eggs               │ 3        │ R7.50                │ ║
║ └────────────────────┴──────────┴──────────────────────┘ ║
║                                                          ║
║ TOTAL COST: R25.50                                       ║
╠══════════════════════════════════════════════════════════╣
║ METHOD:                                                  ║
║ 1. Sift flour and cocoa together                         ║
║ 2. Beat eggs and sugar until fluffy                      ║
║ 3. Fold in dry ingredients                               ║
║ 4. Mix until smooth                                      ║
╠══════════════════════════════════════════════════════════╣
║ Baker: ________________  Date: ________  Time: ______    ║
║ Checked By: ________________                             ║
╚══════════════════════════════════════════════════════════╝
```

### Product Recipe Production Sheet
```
╔══════════════════════════════════════════════════════════╗
║           OVEN DELIGHTS - PRODUCT RECIPE SHEET          ║
╠══════════════════════════════════════════════════════════╣
║ Product: Chocolate Cake                                  ║
║ Batch Qty: 1 cake                                        ║
║ Date: 10 Jan 2026                                        ║
╠══════════════════════════════════════════════════════════╣
║ SUB-RECIPES REQUIRED:                                    ║
║ ┌────────────────────┬──────────┬──────────────────────┐ ║
║ │ Sub-Recipe         │ Quantity │ Cost                 │ ║
║ ├────────────────────┼──────────┼──────────────────────┤ ║
║ │ Chocolate Batter   │ 1        │ R25.50               │ ║
║ │ Cream Filling      │ 1        │ R23.25               │ ║
║ │ Chocolate Ganache  │ 1        │ R35.00               │ ║
║ └────────────────────┴──────────┴──────────────────────┘ ║
║                                                          ║
║ PACKAGING & DECORATIONS:                                 ║
║ ┌────────────────────┬──────────┬──────────────────────┐ ║
║ │ Item               │ Quantity │ Cost                 │ ║
║ ├────────────────────┼──────────┼──────────────────────┤ ║
║ │ Cake Box           │ 1        │ R5.00                │ ║
║ │ Ribbon             │ 1        │ R2.00                │ ║
║ │ Cake Board         │ 1        │ R3.50                │ ║
║ └────────────────────┴──────────┴──────────────────────┘ ║
╠══════════════════════════════════════════════════════════╣
║ CONSOLIDATED INGREDIENTS (BOM):                          ║
║ ┌────────────────────┬──────────┬──────────────────────┐ ║
║ │ Ingredient         │ Quantity │ Cost                 │ ║
║ ├────────────────────┼──────────┼──────────────────────┤ ║
║ │ Flour              │ 300g     │ R15.00               │ ║
║ │ Sugar              │ 175g     │ R5.25                │ ║
║ │ Cocoa              │ 50g      │ R5.00                │ ║
║ │ Eggs               │ 3        │ R7.50                │ ║
║ │ Butter             │ 150g     │ R12.00               │ ║
║ │ Milk               │ 200ml    │ R4.00                │ ║
║ │ Dark Chocolate     │ 200g     │ R30.00               │ ║
║ │ Cream              │ 100ml    │ R5.00                │ ║
║ └────────────────────┴──────────┴──────────────────────┘ ║
║                                                          ║
║ TOTAL COST: R94.25                                       ║
╠══════════════════════════════════════════════════════════╣
║ ASSEMBLY METHOD:                                         ║
║ 1. Bake chocolate batter in 2 layers                     ║
║ 2. Cool completely                                       ║
║ 3. Spread cream filling between layers                   ║
║ 4. Pour ganache over top                                 ║
║ 5. Decorate and package                                  ║
╠══════════════════════════════════════════════════════════╣
║ Baker: ________________  Date: ________  Time: ______    ║
║ Checked By: ________________                             ║
╚══════════════════════════════════════════════════════════╝
```

---

## Technical Implementation

### RecipeCostCalculationService.vb
Core service for all cost calculations.

**Methods**:
- `CalculateIngredientCostPerUnit(ingredientID, branchID)` - Returns cost per smallest unit
- `CalculateSubRecipeTotalCost(subRecipeID)` - Sums all ingredient costs
- `CalculateProductTotalCost(productID)` - Sums sub-recipes + packaging
- `GetConsolidatedBOM(productID)` - Returns aggregated ingredient list
- `RefreshAllRecipeCosts()` - Updates all recipes with current prices
- `ValidateSubRecipeExists(subRecipeID)` - Checks if recipe created

### BOMGenerationService.vb
Generates manufacturing BOMs from product recipes.

**Methods**:
- `GenerateBOMForProduct(productID, quantity)` - Creates manufacturing BOM
- `CheckRecipeExists(productID)` - Validates recipe before BOM generation
- `GetConsolidatedIngredients(productID)` - Returns ingredient list with totals
- `PrintProductionSheet(productID)` - Generates printable production sheet

---

## User Experience (UX)

### Visual Design
- **Modern, clean interface** with professional color scheme
- **Large, touch-friendly buttons** for bakery environment
- **Real-time cost updates** as ingredients are added
- **Color-coded grids**: Ingredients (blue), Sub-Recipes (green), Packaging (orange)
- **Visual alerts**: Red for missing recipes, Green for valid selections

### Workflow Optimization
- **Auto-save drafts** to prevent data loss
- **Quick ingredient search** with autocomplete
- **Recent items** dropdown for frequently used ingredients
- **Batch copy** feature to duplicate similar recipes
- **Print preview** before finalizing

### Error Handling
- **Clear error messages** with actionable guidance
- **Validation on every step** to prevent invalid data
- **Undo/Redo** functionality for recipe editing
- **Confirmation dialogs** before deleting recipes

---

## Integration Points

### Purchase Order System
- When invoice captured, trigger cost update
- Update LastPaidPrice in Demo_Retail_Price
- Automatically recalculate all affected recipes

### Manufacturing Module
- BOM generation pulls from Product Recipes
- Production sheets print from recipe data
- Stock deductions based on consolidated BOM

### Inventory Management
- Recipe costs feed into product pricing
- Ingredient usage tracked from BOM
- Stock alerts for low ingredient levels

---

## Future Enhancements

### Phase 2 Features
- **Recipe versioning** - Track recipe changes over time
- **Yield analysis** - Compare actual vs expected output
- **Waste tracking** - Record ingredient waste/spoilage
- **Nutritional information** - Calculate calories, allergens
- **Recipe costing history** - Track cost changes over time
- **Multi-language support** - Recipes in multiple languages
- **Photo attachments** - Add images to recipe steps
- **Video tutorials** - Link to instructional videos

### Advanced Analytics
- **Most profitable products** based on recipe costs
- **Ingredient usage trends** over time
- **Cost variance analysis** - Actual vs standard costs
- **Recipe optimization suggestions** - AI-powered cost reduction

---

## Success Metrics

### Key Performance Indicators (KPIs)
- **Recipe creation time**: < 5 minutes per sub-recipe
- **Cost accuracy**: 99%+ match with actual costs
- **User adoption**: 100% of bakers using system within 1 month
- **Error reduction**: 90% reduction in ingredient ordering errors
- **Time savings**: 50% reduction in BOM generation time

---

## Support & Training

### Training Materials
- Video tutorials for each form
- Step-by-step user guides
- Quick reference cards for bakers
- FAQ document

### Support Channels
- In-app help tooltips
- Dedicated support email
- Weekly training sessions
- User feedback form

---

## Conclusion

This Recipe Management System is the **HEART OF THE MANUFACTURING PROCESS**. It provides:

✅ **Professional recipe management** with two-tier hierarchy  
✅ **Dynamic cost calculation** based on real-time pricing  
✅ **Consolidated BOM generation** for accurate manufacturing  
✅ **Beautiful printable production sheets** for bakery floor  
✅ **Automatic cost updates** when prices change  
✅ **User-friendly interface** optimized for bakery environment  

**This is the WOW FACTOR feature that sets Oven Delights apart!**

---

*Document Version: 1.0*  
*Last Updated: 10 January 2026*  
*Author: Cascade AI Development Team*
