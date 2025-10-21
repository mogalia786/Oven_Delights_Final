# NIGHT WORK - SYSTEMATIC FIX ALL FEATURES

## MANUFACTURING MODULE

### 1. Categories
- **Should:** Manage product categories (Add/Edit/Delete)
- **Check:** Form loads, CRUD works, data saves to Categories table

### 2. Subcategories  
- **Should:** Manage subcategories under categories
- **Check:** Cascading from categories works, saves to Subcategories table

### 3. Products
- **Should:** Manage manufactured products
- **Check:** Links to categories, saves to Products table with ItemType='Manufactured'

### 4. Recipe Creator
- **Should:** Create recipes with components and subcomponents
- **Check:** Tree structure works, saves to RecipeTemplate, RecipeComponent tables

### 5. Build My Product
- **Should:** Build products using recipes, calculate costs
- **Check:** Recipe tree loads, cost calculation works, saves to RecipeNode

### 6. BOM Management
- **Should:** Create/manage Bill of Materials
- **Check:** Generate BOM, submit to stockroom, track status

### 7. Complete Build
- **Should:** Mark builds as complete, move to retail stock
- **Check:** Updates Retail_Stock, posts to ledgers

### 8. MO Actions
- **Should:** Manufacturing Order actions
- **Check:** Create/update MOs, track status

## STOCKROOM MODULE

### 1. Inventory
- **Should:** View raw materials and external products stock
- **Check:** Shows RawMaterials.CurrentStock, filters work

### 2. Internal Orders
- **Should:** Fulfill BOM requests from manufacturing/retail
- **Check:** Load orders, fulfill, update stock

### 3. Purchase Orders
- **Should:** Create POs to suppliers
- **Check:** Add lines, calculate totals, save

### 4. GRV/Invoice
- **Should:** Receive goods, capture invoices
- **Check:** Update stock (RawMaterials OR Retail_Stock based on type)

### 5. Inter-Branch Transfer
- **Should:** Transfer stock between branches, update ledgers
- **Check:** Branch dropdowns, stock update, ledger posting

## RETAIL MODULE

### 1. POS
- **Should:** Process sales, deduct stock
- **Check:** Retail_Stock.QtyOnHand decreases, Retail_StockMovements records

### 2. Products
- **Should:** View retail products
- **Check:** Shows Products with stock from Retail_Stock

### 3. Low Stock
- **Should:** Show products below reorder point
- **Check:** Filters by branch, shows correct stock levels

### 4. Reorder Dashboard
- **Should:** Manage reorders
- **Check:** Creates internal orders, tracks status

## ACCOUNTING MODULE

### 1. Supplier Payment
- **Should:** Pay supplier invoices
- **Check:** Loads SupplierInvoices, processes payment, updates ledger

### 2. Expenses
- **Should:** Record expenses
- **Check:** Saves to Expenses table, posts to GL

### 3. Cash Book
- **Should:** Manage cash transactions (float, petty cash, sundries)
- **Check:** Records cash in/out, reconciles

## FIXES TO APPLY

1. Remove ALL namespace wrappers I added
2. Fix BuildProductForm SaveProductRecipe
3. Verify all table/column names match schema
4. Add dropdown filtering where missing
5. Test each feature end-to-end
