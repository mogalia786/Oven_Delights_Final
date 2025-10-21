# Manufacturing Module
## User Training Manual - Complete Guide

**Version:** 1.0  
**Last Updated:** October 2025  
**Module:** Manufacturing Management

---

## Table of Contents

1. [Module Overview](#module-overview)
2. [Menu Structure](#menu-structure)
3. [Categories](#categories)
4. [Subcategories](#subcategories)
5. [Products](#products)
6. [Recipe Creator](#recipe-creator)
7. [Build My Product](#build-my-product)
8. [BOM Management](#bom-management)
9. [Complete Build](#complete-build)
10. [MO Actions](#mo-actions)
11. [Production Schedule](#production-schedule)

---

## Module Overview

### Purpose

The Manufacturing module manages the complete production cycle from recipe creation through to finished goods. It controls:

- Product recipes and formulations
- Bill of Materials (BOM)
- Production orders
- Material requisitions
- Work-in-progress tracking
- Finished goods completion
- Manufacturing inventory

### Who Can Access

**Primary Users:**
- Production Manager (full access)
- Production Supervisor (execution)
- Quality Control (inspection)
- Recipe Developer (formulations)

### Manufacturing Flow

```
Recipe Creation → BOM Setup → Issue Materials → Production → 
Complete Build → Quality Check → Move to Retail Stock
```

**Inventory Movement:**
```
Stockroom_Inventory (Raw Materials)
         ↓
Manufacturing_Inventory (Work in Progress)
         ↓
Retail_Products_Inventory (Finished Goods)
```

---

## Menu Structure

```
Manufacturing
├── Catalog
│   ├── Categories
│   └── Subcategories
├── Products
├── Recipe Creator
├── Build My Product
├── BOM Management
├── Complete Build
├── MO Actions
└── Production Schedule
```

---

## Categories

### Purpose
Organize products into main categories for classification and reporting.

### Accessing Categories

1. Click **Manufacturing** → **Catalog** → **Categories**
2. Categories management form opens

**📸 Screenshot Required:** `Manufacturing_Categories_List.png`
- Show categories grid with columns
- Highlight toolbar buttons
- Show sample categories (Breads, Cakes, Pastries)

### Categories List View

**Grid Columns:**
- **Category ID:** Unique identifier
- **Category Name:** Name of category
- **Description:** What products belong here
- **Product Count:** Number of products in category
- **Active:** Yes/No status
- **Created Date:** When created

**Toolbar Buttons:**
- **New Category:** Add new category
- **Edit:** Modify selected category
- **Deactivate:** Disable category
- **Refresh:** Reload list

### Creating a New Category

#### Step 1: Open New Category Form

1. Click **New Category** button
2. Category entry form opens

**📸 Screenshot Required:** `Manufacturing_Category_New.png`
- Show blank category form
- Highlight required fields
- Show validation indicators

#### Step 2: Enter Category Details

**Required Fields:**
- **Category Name:** Descriptive name
  * Example: "Breads"
  * Example: "Cakes"
  * Example: "Pastries"
  * Must be unique

- **Description:** What belongs in this category
  * Example: "All bread products including loaves, rolls, and buns"
  * Helps users understand classification

**Optional Fields:**
- **Display Order:** Sequence for display (1, 2, 3...)
- **Icon/Image:** Category icon for visual identification
- **Parent Category:** If creating subcategory structure

#### Step 3: Save Category

1. Review entered information
2. Click **Save**
3. Category created
4. Appears in category list
5. Available for product assignment

**📸 Screenshot Required:** `Manufacturing_Category_Saved.png`
- Show confirmation message
- Show new category in list
- Highlight the saved category

### Editing Categories

**To Edit:**
1. Select category in list
2. Click **Edit** button
3. Modify information
4. Click **Save**

**Can Change:**
- Category name
- Description
- Display order
- Icon/image

**Cannot Change:**
- Category ID (system generated)

### Deactivating Categories

**When to Deactivate:**
- Category no longer used
- Products moved to different category
- Consolidating categories

**Deactivate Process:**
1. Select category
2. Click **Deactivate**
3. System checks if products assigned
4. If products exist:
   - Must reassign products first
   - Or deactivate products
5. Confirm deactivation
6. Category marked inactive

---

## Subcategories

### Purpose
Further classify products within categories for detailed organization.

### Accessing Subcategories

1. Click **Manufacturing** → **Catalog** → **Subcategories**
2. Subcategories management form opens

**📸 Screenshot Required:** `Manufacturing_Subcategories_List.png`
- Show subcategories grid
- Show parent category column
- Show sample subcategories

### Subcategories List View

**Grid Columns:**
- **Subcategory ID:** Unique identifier
- **Parent Category:** Which category it belongs to
- **Subcategory Name:** Name
- **Description:** Details
- **Product Count:** Products in subcategory
- **Active:** Status

### Creating Subcategory

#### Step 1: Open New Subcategory Form

1. Click **New Subcategory** button
2. Subcategory form opens

**📸 Screenshot Required:** `Manufacturing_Subcategory_New.png`
- Show form with parent category dropdown
- Show required fields

#### Step 2: Enter Subcategory Details

**Required Fields:**
- **Parent Category:** Select from dropdown
  * Example: Category = "Breads"
  
- **Subcategory Name:** Specific classification
  * Example: "White Breads"
  * Example: "Whole Wheat Breads"
  * Example: "Specialty Breads"

- **Description:** What products belong here
  * Example: "All white bread products"

#### Step 3: Save Subcategory

1. Review information
2. Click **Save**
3. Subcategory created
4. Available for product assignment

**Example Category Structure:**
```
Breads (Category)
├── White Breads (Subcategory)
├── Whole Wheat Breads (Subcategory)
└── Specialty Breads (Subcategory)

Cakes (Category)
├── Sponge Cakes (Subcategory)
├── Chocolate Cakes (Subcategory)
└── Fruit Cakes (Subcategory)
```

---

## Products

### Purpose
Manage manufactured product catalog and specifications.

### Accessing Products

1. Click **Manufacturing** → **Products**
2. Products management form opens

**📸 Screenshot Required:** `Manufacturing_Products_List.png`
- Show products grid with all columns
- Show filter options
- Show sample products

### Products List View

**Grid Columns:**
- **Product Code:** SKU (e.g., i-BREAD-001)
- **Product Name:** Full name
- **Category:** Main category
- **Subcategory:** Sub-classification
- **Status:** Active/Inactive
- **Has Recipe:** Yes/No
- **Standard Cost:** Manufacturing cost
- **Retail Price:** Selling price
- **Created Date:** When added

**Filter Options:**
- By category
- By subcategory
- By status (Active/Inactive)
- By has recipe (Yes/No)
- Search by name or code

### Creating a New Product

#### Step 1: Open New Product Form

1. Click **New Product** button
2. Product entry form opens

**📸 Screenshot Required:** `Manufacturing_Product_New.png`
- Show complete product form
- Highlight all sections
- Show tabs if multiple

#### Step 2: Enter Basic Information

**Product Identification:**
- **Product Code:** Unique SKU
  * Prefix with "i" for internal products
  * Example: i-BREAD-WHITE-001
  * Auto-generated or manual

- **Product Name:** Descriptive name
  * Example: "White Sandwich Bread 800g"
  * Include size/weight

- **Short Name:** Abbreviated name
  * For labels and receipts
  * Example: "White Bread 800g"

**Classification:**
- **Category:** Select main category
  * Example: Breads

- **Subcategory:** Select subcategory
  * Example: White Breads

⚠️ **Important:** Category and Subcategory are MANDATORY for all manufactured products.

#### Step 3: Enter Product Specifications

**Physical Specifications:**
- **Unit of Measure:** Each, Kg, Litre, etc.
  * Example: Each (for loaves)

- **Net Weight:** Product weight
  * Example: 800g

- **Gross Weight:** Including packaging
  * Example: 850g

- **Dimensions:** Length × Width × Height
  * For packaging and storage

**Packaging:**
- **Package Type:** Bag, Box, Tray, etc.
- **Units per Package:** How many per pack
- **Shelf Life:** Days before expiry
  * Example: 7 days for bread

#### Step 4: Set Pricing

**Cost Information:**
- **Standard Cost:** Target manufacturing cost
  * Calculated from recipe
  * Or estimated initially

- **Average Cost:** Actual average cost
  * Auto-calculated from production

**Selling Prices:**
- **Retail Price:** Price to customers
  * Example: R25.00

- **Wholesale Price:** Price to wholesale customers
  * Example: R20.00

- **Markup %:** Percentage above cost
  * Auto-calculated or manual

**📸 Screenshot Required:** `Manufacturing_Product_Pricing.png`
- Show pricing section
- Show cost vs price comparison
- Show markup calculation

#### Step 5: Add Product Image

**Upload Image:**
1. Click **Upload Image** button
2. Browse to product photo
3. Select image file
4. Image uploads and displays

**Image Guidelines:**
- Clear product photo
- White background preferred
- Square format (800×800px)
- Shows finished product
- Used in POS and catalogs

**📸 Screenshot Required:** `Manufacturing_Product_Image.png`
- Show product with uploaded image
- Show image preview
- Show upload button

#### Step 6: Set Production Parameters

**Production Settings:**
- **Batch Size:** Standard production quantity
  * Example: 50 loaves per batch

- **Production Time:** Minutes to produce batch
  * Example: 180 minutes (3 hours)

- **Cooling Time:** Minutes to cool
  * Example: 60 minutes

- **Quality Control Required:** Yes/No
  * Inspection before release

**Storage Requirements:**
- **Storage Conditions:** Ambient/Chilled/Frozen
- **Storage Location:** Where to store finished goods
- **Minimum Stock Level:** Safety stock
- **Maximum Stock Level:** Don't exceed

#### Step 7: Save Product

1. Review all information
2. Verify category and subcategory selected
3. Click **Save**
4. Product created
5. Ready for recipe creation

**📸 Screenshot Required:** `Manufacturing_Product_Saved.png`
- Show confirmation message
- Show product in list
- Highlight new product

**Post-Save:**
- Product appears in products list
- Available for recipe creation
- Can create BOM
- Can start production

---

## Recipe Creator

### Purpose
Create detailed recipes/formulations for manufactured products.

### Accessing Recipe Creator

1. Click **Manufacturing** → **Recipe Creator**
2. Recipe creator form opens

**📸 Screenshot Required:** `Manufacturing_RecipeCreator_Main.png`
- Show recipe creator interface
- Show product selection
- Show ingredients section

### Understanding Recipes

**What is a Recipe?**
- List of ingredients (raw materials)
- Quantities required
- Production instructions
- Yield information
- Cost calculation

**Recipe vs BOM:**
- **Recipe:** Detailed formulation with instructions
- **BOM:** Simplified material list for production
- Recipe can generate BOM automatically

### Creating a Recipe

#### Step 1: Select Product

1. Click **Select Product** button
2. Search for product
3. Select product from list
4. Product details load

**📸 Screenshot Required:** `Manufacturing_RecipeCreator_ProductSelect.png`
- Show product search dialog
- Show product selection
- Show selected product details

#### Step 2: Set Recipe Header

**Recipe Information:**
- **Recipe Name:** Descriptive name
  * Example: "White Sandwich Bread - Standard Recipe"

- **Recipe Version:** Version number
  * Example: 1.0
  * Increment for recipe changes

- **Batch Size:** How much this recipe makes
  * Example: 50 loaves

- **Recipe Type:** Standard/Alternative/Seasonal
  * Standard: Regular production
  * Alternative: Substitute recipe
  * Seasonal: Special occasions

**📸 Screenshot Required:** `Manufacturing_RecipeCreator_Header.png`
- Show recipe header section
- Show all fields filled
- Show batch size prominently

#### Step 3: Add Ingredients

**Add Raw Materials:**
1. Click **Add Ingredient** button
2. Search for raw material
3. Select from stockroom inventory
4. Enter quantity required

**For Each Ingredient:**
- **Ingredient Name:** From stockroom
  * Example: Cake Flour

- **Quantity:** Amount needed
  * Example: 25kg

- **Unit:** Unit of measure
  * Example: Kg

- **Cost per Unit:** Current cost
  * Auto-loaded from stockroom

- **Line Cost:** Qty × Cost per Unit
  * Auto-calculated

- **Percentage:** % of total recipe
  * Auto-calculated

- **Notes:** Special instructions
  * Example: "Sift before use"

**📸 Screenshot Required:** `Manufacturing_RecipeCreator_Ingredients.png`
- Show ingredients grid
- Show multiple ingredients
- Show cost calculations
- Highlight total cost

**Example Bread Recipe:**
| Ingredient | Quantity | Unit | Cost/Unit | Line Cost | % |
|------------|----------|------|-----------|-----------|---|
| Cake Flour | 25kg | Kg | R15.00 | R375.00 | 50% |
| Water | 15L | L | R0.10 | R1.50 | 30% |
| Yeast | 500g | g | R0.50 | R250.00 | 1% |
| Salt | 400g | g | R0.02 | R8.00 | 0.8% |
| Sugar | 1kg | Kg | R12.00 | R12.00 | 2% |
| Butter | 2kg | Kg | R80.00 | R160.00 | 4% |
| **Total** | | | | **R806.50** | **100%** |

**Cost per Unit:**
- Total Cost: R806.50
- Batch Size: 50 loaves
- Cost per Loaf: R16.13

#### Step 4: Add Production Instructions

**Step-by-Step Instructions:**
1. Click **Instructions** tab
2. Add production steps in sequence

**Example Instructions:**
```
Step 1: Mixing (15 minutes)
- Combine flour, salt, sugar in mixer
- Mix on low speed for 2 minutes

Step 2: Kneading (20 minutes)
- Add water gradually
- Add yeast mixture
- Knead until smooth and elastic

Step 3: First Proof (60 minutes)
- Cover dough
- Let rise in warm place
- Until doubled in size

Step 4: Shaping (30 minutes)
- Punch down dough
- Divide into 50 portions
- Shape into loaves
- Place in greased pans

Step 5: Second Proof (45 minutes)
- Cover shaped loaves
- Let rise until doubled

Step 6: Baking (30 minutes)
- Preheat oven to 180°C
- Bake for 30 minutes
- Until golden brown

Step 7: Cooling (60 minutes)
- Remove from pans
- Cool on racks
- Do not package while hot
```

**📸 Screenshot Required:** `Manufacturing_RecipeCreator_Instructions.png`
- Show instructions section
- Show step-by-step format
- Show timing for each step

#### Step 5: Set Quality Standards

**Quality Control Parameters:**
- **Visual Inspection:** What to check
  * Color: Golden brown
  * Shape: Uniform, no cracks
  * Size: Consistent

- **Weight Check:** Target weight ± tolerance
  * Target: 800g
  * Tolerance: ±20g

- **Texture:** Expected texture
  * Soft, fluffy interior
  * Crisp crust

- **Taste Test:** Flavor profile
  * Slightly sweet
  * No off-flavors

**📸 Screenshot Required:** `Manufacturing_RecipeCreator_Quality.png`
- Show quality standards section
- Show checkpoints
- Show acceptance criteria

#### Step 6: Add Notes and Allergens

**Recipe Notes:**
- Special considerations
- Common issues and solutions
- Tips for best results
- Storage instructions

**Allergen Information:**
- [ ] Contains Gluten (Wheat)
- [ ] Contains Dairy (Butter)
- [ ] Contains Eggs
- [ ] Contains Nuts
- [ ] Contains Soy
- [ ] Other allergens

**📸 Screenshot Required:** `Manufacturing_RecipeCreator_Allergens.png`
- Show allergen checkboxes
- Show notes section
- Show warnings

#### Step 7: Calculate and Review

**Recipe Summary:**
- Total ingredient cost
- Cost per unit
- Batch yield
- Production time
- Shelf life

**Cost Analysis:**
```
Total Ingredient Cost: R806.50
Batch Size: 50 loaves
Cost per Loaf: R16.13
Retail Price: R25.00
Gross Profit: R8.87 (35.5%)
```

**📸 Screenshot Required:** `Manufacturing_RecipeCreator_Summary.png`
- Show cost summary
- Show profitability analysis
- Show yield information

#### Step 8: Save Recipe

1. Review all sections
2. Verify calculations correct
3. Click **Save Recipe**
4. Recipe saved
5. Can generate BOM from recipe

**📸 Screenshot Required:** `Manufacturing_RecipeCreator_Saved.png`
- Show save confirmation
- Show recipe in recipe list
- Show "Generate BOM" button

---

## Build My Product

### Purpose
Quick product creation with basic recipe for simple products.

### Accessing Build My Product

1. Click **Manufacturing** → **Build My Product**
2. Build product wizard opens

**📸 Screenshot Required:** `Manufacturing_BuildProduct_Main.png`
- Show wizard interface
- Show step indicators
- Show current step highlighted

### Build My Product Wizard

**When to Use:**
- Simple products
- Quick setup needed
- Basic recipe
- Standard production

**Wizard Steps:**
1. Product Information
2. Select Ingredients
3. Set Quantities
4. Review and Save

### Step 1: Product Information

**Enter Product Details:**
- Product name
- Category (MANDATORY)
- Subcategory (MANDATORY)
- Batch size
- Target cost

**📸 Screenshot Required:** `Manufacturing_BuildProduct_Step1.png`
- Show product information form
- Highlight mandatory fields
- Show validation

⚠️ **Critical:** Category and Subcategory MUST be selected. System will not proceed without them.

### Step 2: Select Ingredients

**Choose Raw Materials:**
1. Browse stockroom inventory
2. Select ingredients needed
3. Click **Add** for each

**📸 Screenshot Required:** `Manufacturing_BuildProduct_Step2.png`
- Show ingredient selection
- Show stockroom browser
- Show selected ingredients list

### Step 3: Set Quantities

**Enter Quantities:**
- For each ingredient
- Quantity needed per batch
- Unit of measure
- Cost auto-calculates

**📸 Screenshot Required:** `Manufacturing_BuildProduct_Step3.png`
- Show quantity entry
- Show cost calculation
- Show total cost

### Step 4: Review and Save

**Review Summary:**
- Product details
- Ingredients list
- Total cost
- Cost per unit

**Save Actions:**
1. Click **Save Product**
2. Product created
3. Basic recipe created
4. BOM auto-generated
5. Ready for production

**📸 Screenshot Required:** `Manufacturing_BuildProduct_Complete.png`
- Show completion screen
- Show success message
- Show next steps

**Post-Creation:**
- Product added to catalog
- Recipe available
- BOM created
- Can start production immediately

---

## BOM Management

### Purpose
Manage Bill of Materials for production orders.

### Accessing BOM Management

1. Click **Manufacturing** → **BOM Management**
2. BOM management form opens

**📸 Screenshot Required:** `Manufacturing_BOM_List.png`
- Show BOM list grid
- Show product column
- Show status column

### Understanding BOM

**What is a BOM?**
- Bill of Materials
- List of components needed
- Quantities required
- Used for production orders
- Simpler than full recipe

**BOM vs Recipe:**
- **BOM:** Material list only
- **Recipe:** Materials + instructions
- BOM generated from recipe
- Or created standalone

### BOM List View

**Grid Columns:**
- **BOM Number:** Unique identifier
- **Product:** What it's for
- **Version:** BOM version
- **Status:** Active/Inactive/Draft
- **Total Cost:** Material cost
- **Created Date:** When created
- **Last Modified:** Last update

### Creating a BOM

#### Step 1: Open New BOM Form

1. Click **New BOM** button
2. BOM form opens

**📸 Screenshot Required:** `Manufacturing_BOM_New.png`
- Show blank BOM form
- Show product selection
- Show materials section

#### Step 2: Select Product

**Choose Product:**
1. Click **Select Product**
2. Search for product
3. Select from list
4. Product details load

**Options:**
- Create from existing recipe (recommended)
- Create from scratch
- Copy from existing BOM

**📸 Screenshot Required:** `Manufacturing_BOM_ProductSelect.png`
- Show product selection dialog
- Show "Create from Recipe" option
- Show selected product

#### Step 3: Add Materials

**If Creating from Recipe:**
- Materials auto-populate
- Quantities pre-filled
- Can adjust if needed

**If Creating from Scratch:**
1. Click **Add Material**
2. Select raw material
3. Enter quantity
4. Repeat for all materials

**📸 Screenshot Required:** `Manufacturing_BOM_Materials.png`
- Show materials grid
- Show quantities
- Show costs
- Show total

#### Step 4: Set BOM Parameters

**BOM Settings:**
- **Batch Size:** Production quantity
  * Example: 50 units

- **Scrap Factor:** Expected waste %
  * Example: 5% waste
  * System adds 5% to quantities

- **Lead Time:** Production time
  * Example: 4 hours

**📸 Screenshot Required:** `Manufacturing_BOM_Settings.png`
- Show BOM parameters
- Show scrap factor
- Show lead time

#### Step 5: Save BOM

1. Review all materials
2. Verify quantities
3. Check total cost
4. Click **Save BOM**
5. BOM activated

**📸 Screenshot Required:** `Manufacturing_BOM_Saved.png`
- Show save confirmation
- Show BOM in list
- Show active status

**Post-Save:**
- BOM available for production
- Can create production orders
- Materials can be issued

---

## Complete Build

### Purpose
Complete production and move finished goods to retail stock.

### Accessing Complete Build

1. Click **Manufacturing** → **Complete Build**
2. Complete build form opens

**📸 Screenshot Required:** `Manufacturing_CompleteBuild_Main.png`
- Show complete build interface
- Show pending builds list
- Show completion form

### Complete Build Process

**When to Use:**
- Production finished
- Quality check passed
- Ready to move to retail
- Update inventory

### Step 1: Select Production Order

**Find Build to Complete:**
1. View list of in-progress builds
2. Filter by:
   - Product
   - Date started
   - Batch number
3. Select build to complete

**📸 Screenshot Required:** `Manufacturing_CompleteBuild_SelectBuild.png`
- Show builds list
- Show filter options
- Show selected build

### Step 2: Enter Completion Details

**Completion Information:**
- **Completion Date:** When finished
- **Actual Quantity Produced:** Units completed
  * May differ from planned
  * Due to waste, quality issues

- **Good Units:** Passed quality check
- **Rejected Units:** Failed quality
- **Waste/Scrap:** Material waste

**📸 Screenshot Required:** `Manufacturing_CompleteBuild_Details.png`
- Show completion form
- Show quantity fields
- Show quality sections

### Step 3: Quality Inspection

**Quality Check:**
- [ ] Visual inspection passed
- [ ] Weight check passed
- [ ] Taste test passed (if applicable)
- [ ] Packaging check passed
- [ ] Label check passed

**Inspector:**
- Inspector name
- Inspection date
- Sign-off

**📸 Screenshot Required:** `Manufacturing_CompleteBuild_Quality.png`
- Show quality checklist
- Show inspector fields
- Show pass/fail indicators

### Step 4: Calculate Costs

**Cost Calculation:**
```
Materials Used: R806.50
Labor Cost: R200.00
Overhead: R100.00
Total Manufacturing Cost: R1,106.50

Units Produced: 48 (2 rejected)
Cost per Unit: R23.05
```

**📸 Screenshot Required:** `Manufacturing_CompleteBuild_Costs.png`
- Show cost breakdown
- Show per-unit cost
- Show comparison to standard

### Step 5: Complete Build

**Complete Process:**
1. Review all information
2. Verify quantities correct
3. Click **Complete Build**
4. System processes:

**System Actions:**
1. **Reduce Manufacturing Inventory:**
   - Raw materials consumed
   - Removed from Manufacturing_Inventory

2. **Increase Retail Stock:**
   - Finished goods added
   - Added to Retail_Products_Inventory
   - Available for sale

3. **Create GL Entries:**
   ```
   Debit:  Finished Goods Inventory
   Credit: Manufacturing Inventory
   Amount: Total manufacturing cost
   ```

4. **Update Production Order:**
   - Status: Completed
   - Actual vs planned recorded
   - Variances noted

**📸 Screenshot Required:** `Manufacturing_CompleteBuild_Success.png`
- Show completion confirmation
- Show inventory updated message
- Show next steps

**Post-Completion:**
- Finished goods in retail stock
- Available for sale
- Production order closed
- Costs recorded

---

## MO Actions

### Purpose
Manage Manufacturing Orders (production orders).

### Accessing MO Actions

1. Click **Manufacturing** → **MO Actions**
2. MO actions form opens

**📸 Screenshot Required:** `Manufacturing_MOActions_Main.png`
- Show MO list
- Show action buttons
- Show status indicators

### Manufacturing Order Statuses

**Status Flow:**
```
Draft → Approved → Materials Issued → In Production → 
Completed → Quality Check → Released to Stock
```

### MO Actions Available

**Actions:**
- **Create MO:** New production order
- **Approve MO:** Authorize production
- **Issue Materials:** Release materials to production
- **Start Production:** Begin manufacturing
- **Pause Production:** Temporary stop
- **Resume Production:** Continue after pause
- **Complete Production:** Finish manufacturing
- **Cancel MO:** Cancel order

**📸 Screenshot Required:** `Manufacturing_MOActions_ActionButtons.png`
- Show all action buttons
- Show enabled/disabled states
- Show tooltips

### Creating Manufacturing Order

#### Step 1: New MO

1. Click **Create MO** button
2. MO form opens

**📸 Screenshot Required:** `Manufacturing_MOActions_NewMO.png`
- Show MO creation form
- Show all fields
- Show BOM selection

#### Step 2: Enter MO Details

**MO Information:**
- **MO Number:** Auto-generated
- **Product:** Select product
- **BOM:** Select BOM version
- **Quantity:** How many to produce
- **Required Date:** When needed
- **Priority:** Normal/High/Urgent

**📸 Screenshot Required:** `Manufacturing_MOActions_MODetails.png`
- Show MO details form
- Show quantity calculation
- Show material requirements

#### Step 3: Save and Approve

1. Click **Save MO**
2. MO created with status "Draft"
3. Click **Approve MO**
4. Status changes to "Approved"
5. Ready for material issue

**📸 Screenshot Required:** `Manufacturing_MOActions_Approved.png`
- Show approved MO
- Show status change
- Show next action available

### Issuing Materials

**Issue Materials to Production:**
1. Select approved MO
2. Click **Issue Materials**
3. System checks stockroom availability
4. Materials moved to manufacturing inventory

**Inventory Movement:**
```
From: Stockroom_Inventory
To:   Manufacturing_Inventory
```

**📸 Screenshot Required:** `Manufacturing_MOActions_IssueMaterials.png`
- Show material issue screen
- Show availability check
- Show confirmation

### Starting Production

**Start Production:**
1. Select MO with materials issued
2. Click **Start Production**
3. Enter start time
4. Assign production team
5. Status: "In Production"

**📸 Screenshot Required:** `Manufacturing_MOActions_StartProduction.png`
- Show start production dialog
- Show team assignment
- Show start time

### Monitoring Production

**Production Dashboard:**
- Current status
- Time elapsed
- Expected completion
- Issues/delays

**📸 Screenshot Required:** `Manufacturing_MOActions_Monitor.png`
- Show production dashboard
- Show progress indicators
- Show alerts if any

---

## Production Schedule

### Purpose
Plan and schedule production activities.

### Accessing Production Schedule

1. Click **Manufacturing** → **Production Schedule**
2. Production schedule opens

**📸 Screenshot Required:** `Manufacturing_ProductionSchedule_Main.png`
- Show calendar view
- Show scheduled productions
- Show capacity indicators

### Schedule View

**View Options:**
- Daily view
- Weekly view
- Monthly view
- Gantt chart

**📸 Screenshot Required:** `Manufacturing_ProductionSchedule_Calendar.png`
- Show calendar with scheduled items
- Show color coding
- Show capacity bars

### Scheduling Production

**Schedule New Production:**
1. Click date on calendar
2. Select product
3. Enter quantity
4. System checks:
   - Material availability
   - Production capacity
   - Equipment availability
5. Confirm schedule

**📸 Screenshot Required:** `Manufacturing_ProductionSchedule_New.png`
- Show scheduling dialog
- Show availability checks
- Show conflicts if any

### Capacity Planning

**View Capacity:**
- Production capacity per day
- Scheduled vs available
- Bottlenecks identified
- Recommendations

**📸 Screenshot Required:** `Manufacturing_ProductionSchedule_Capacity.png`
- Show capacity chart
- Show utilization %
- Show recommendations

---

## Manufacturing Module Summary

### Key Takeaways

✅ **Product Setup**
- Create categories and subcategories
- Add products with specifications
- Upload product images

✅ **Recipe Management**
- Create detailed recipes
- Calculate costs
- Add production instructions
- Set quality standards

✅ **BOM Management**
- Generate from recipes
- Manage material lists
- Control versions

✅ **Production Execution**
- Issue materials
- Track production
- Complete builds
- Move to retail stock

✅ **Production Planning**
- Schedule production
- Monitor capacity
- Track orders

### Common Tasks Quick Reference

| Task | Steps |
|------|-------|
| Add Product | Manufacturing → Products → New Product |
| Create Recipe | Manufacturing → Recipe Creator → Select Product |
| Create BOM | Manufacturing → BOM Management → New BOM |
| Complete Build | Manufacturing → Complete Build → Select Build |
| Schedule Production | Manufacturing → Production Schedule → Click Date |

### Critical Reminders

⚠️ **Category & Subcategory:**
- MANDATORY for all products
- Must be selected before saving
- Cannot proceed without them

⚠️ **Inventory Flow:**
- Stockroom → Manufacturing → Retail
- Track at each stage
- Don't skip steps

⚠️ **Cost Tracking:**
- Accurate recipe costs
- Track actual vs standard
- Monitor variances

### Support and Help

**Need Help?**
- Press F1 for context-sensitive help
- Check [User Manual Index](USER_MANUAL_00_INDEX.md)
- Contact Production Manager
- IT Support: support@ovendelights.co.za

---

**Next Module:** [Retail Management](USER_MANUAL_05_RETAIL.md)

---

**Document Version:** 1.0  
**Last Updated:** October 2025  
**Next Review:** January 2026
