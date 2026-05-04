# Complete GL Integration for Cost Tracking

## Overview

This implementation provides full General Ledger (GL) integration for cost tracking across the entire manufacturing and sales cycle:

1. **Sub-Recipe Manufacturing** - Tracks ingredient costs and updates sub-recipe values
2. **Product Manufacturing** - Tracks sub-recipe and ingredient costs, updates product values
3. **POS Sales** - Posts revenue and Cost of Goods Sold (COGS)

## Files Created

### 1. `sp_AddSubRecipeToInventory_WITH_GL.sql`
**Purpose**: Sub-recipe manufacturing with GL posting

**What it does**:
- Consumes ingredients from manufacturing stock
- Calculates total ingredient cost
- Adds sub-recipe to inventory
- Updates sub-recipe cost in `Demo_Retail_Product` table
- Posts GL entries:
  - **DR**: Manufacturing Inventory (1410) - Sub-recipe value
  - **CR**: Raw Materials Inventory (1400) - Ingredient costs

**Usage**: Called when baker completes sub-recipe production

### 2. `sp_CompleteProductManufacturing_WITH_GL.sql`
**Purpose**: Product manufacturing with GL posting

**What it does**:
- Consumes sub-recipes from `Demo_SubRecipe_Inventory` (FIFO)
- Consumes direct ingredients from manufacturing stock
- Calculates total product cost (sub-recipes + ingredients)
- Adds finished product to retail stock
- Updates product cost in `Demo_Retail_Product` table
- Posts GL entries:
  - **DR**: Finished Goods Inventory (1420) - Total product value
  - **CR**: Manufacturing Inventory (1410) - Sub-recipe costs
  - **CR**: Raw Materials Inventory (1400) - Direct ingredient costs

**Usage**: Called when manufacturer completes final product

### 3. `sp_ProcessPOSSale_WITH_COGS.sql`
**Purpose**: POS sales with COGS posting

**Contains two procedures**:

#### `sp_ProcessPOSSale`
- Creates sale transaction header
- Posts revenue GL entries:
  - **DR**: Cash/Debtors (1100/1200) - Selling price
  - **CR**: Sales Revenue (4000) - Selling price

#### `sp_ProcessPOSSaleLineItem`
- Processes each line item in the sale
- Reduces retail stock (Finished Goods)
- Posts COGS GL entries:
  - **DR**: Cost of Sales (5000) - Product cost
  - **CR**: Finished Goods Inventory (1420) - Product cost

**Usage**: Called when POS sale is completed

### 4. `DEPLOY_COMPLETE_GL_INTEGRATION.sql`
**Purpose**: Master deployment script

**What it does**:
- Verifies GL infrastructure exists
- Creates missing Chart of Accounts entries
- Provides deployment summary and instructions

## Chart of Accounts Structure

The integration uses the following accounts:

| Account Code | Account Name | Type | Purpose |
|--------------|--------------|------|---------|
| 1100 | Cash | Asset | Cash payments |
| 1200 | Accounts Receivable | Asset | Credit sales |
| 1400 | Raw Materials Inventory | Asset | Ingredient stock |
| 1410 | Manufacturing Inventory (WIP) | Asset | Sub-recipe stock |
| 1420 | Finished Goods Inventory | Asset | Retail product stock |
| 4000 | Sales Revenue | Revenue | Sale income |
| 5000 | Cost of Sales | Expense | COGS |

## Complete Flow Example

### Scenario: Manufacturing and Selling a Cake

#### Step 1: Manufacture Sub-Recipe (Cake Batter)
```sql
EXEC sp_AddSubRecipeToInventory
    @SubRecipeID = 123,
    @Quantity = 10,
    @BranchID = 1,
    @ManufacturedBy = 5
```

**GL Entries Posted**:
```
DR: Manufacturing Inventory (1410)    R500.00
CR: Raw Materials Inventory (1400)    R500.00
```

**Cost Update**:
- Sub-recipe unit cost: R50.00 (R500 / 10 units)
- Updated in `Demo_Retail_Product.AverageCost`

---

#### Step 2: Manufacture Product (Chocolate Cake)
```sql
EXEC sp_CompleteProductManufacturing
    @ProductID = 456,
    @Quantity = 5,
    @BranchID = 1,
    @ManufacturedBy = 5
```

**Consumes**:
- 5 units of Cake Batter (sub-recipe) @ R50 = R250
- 2kg of Chocolate (ingredient) @ R100/kg = R200
- Total cost: R450

**GL Entries Posted**:
```
DR: Finished Goods Inventory (1420)      R450.00
CR: Manufacturing Inventory (1410)       R250.00  (sub-recipe)
CR: Raw Materials Inventory (1400)       R200.00  (chocolate)
```

**Cost Update**:
- Product unit cost: R90.00 (R450 / 5 units)
- Updated in `Demo_Retail_Product.AverageCost`

---

#### Step 3: Sell Product at POS
```sql
-- Sale header
EXEC sp_ProcessPOSSale
    @BranchID = 1,
    @CashierID = 10,
    @PaymentMethod = 'Cash',
    @TotalAmount = 150.00

-- Sale line item
EXEC sp_ProcessPOSSaleLineItem
    @TransactionID = 789,
    @ProductID = 456,
    @Quantity = 1,
    @UnitPrice = 150.00,
    @LineTotal = 150.00,
    @BranchID = 1,
    @CashierID = 10
```

**GL Entries Posted**:
```
-- Revenue
DR: Cash (1100)                          R150.00
CR: Sales Revenue (4000)                 R150.00

-- COGS
DR: Cost of Sales (5000)                 R90.00
CR: Finished Goods Inventory (1420)      R90.00
```

**Result**:
- Gross Profit: R60.00 (R150 - R90)
- Gross Margin: 40%

## Deployment Instructions

### Prerequisites

1. **GL Infrastructure** must exist:
   - `Journals` table
   - `JournalDetails` table
   - `ChartOfAccounts` table
   - `sp_CreateJournalEntry` procedure
   - `sp_AddJournalDetail` procedure
   - `sp_PostJournal` procedure

2. If missing, run: `GL_Master_Setup.sql`

### Deployment Steps

1. **Run the individual SQL files** in this order:
   ```sql
   -- 1. Sub-recipe manufacturing
   :r sp_AddSubRecipeToInventory_WITH_GL.sql
   
   -- 2. Product manufacturing
   :r sp_CompleteProductManufacturing_WITH_GL.sql
   
   -- 3. POS sales with COGS
   :r sp_ProcessPOSSale_WITH_COGS.sql
   ```

2. **Verify deployment**:
   ```sql
   :r DEPLOY_COMPLETE_GL_INTEGRATION.sql
   ```

3. **Test the flow**:
   - Manufacture a sub-recipe
   - Check `Journals` and `JournalDetails` tables
   - Verify cost updated in `Demo_Retail_Product`
   - Manufacture a product using the sub-recipe
   - Check GL entries again
   - Complete a POS sale
   - Verify revenue and COGS posted

## Key Features

### Automatic Cost Calculation
- Sub-recipe costs calculated from ingredient costs
- Product costs calculated from sub-recipe + ingredient costs
- Costs automatically updated in `Demo_Retail_Product` table

### FIFO Inventory Management
- Sub-recipes consumed using First-In-First-Out method
- Oldest batches used first

### GL Posting
- All manufacturing and sales transactions post to GL
- Automatic journal creation and posting
- Proper debit/credit entries for all accounts

### Error Handling
- Validates stock availability before processing
- Rolls back transactions on error
- Returns detailed error messages

### Graceful Degradation
- If GL infrastructure doesn't exist, procedures still work
- GL posting is skipped but inventory management continues
- No errors thrown if GL tables/procedures missing

## Cost Flow Summary

```
Raw Materials (1400)
    ↓ (consumed)
Manufacturing Inventory (1410) - Sub-recipes
    ↓ (consumed)
Finished Goods (1420) - Products
    ↓ (sold)
Cost of Sales (5000) - COGS
```

## Reporting

After implementation, you can query:

### Sub-Recipe Costs
```sql
SELECT 
    ProductID,
    Name,
    AverageCost AS SubRecipeUnitCost,
    CurrentStock
FROM Demo_Retail_Product
WHERE Category LIKE '%sub%recipe%'
```

### Product Costs
```sql
SELECT 
    ProductID,
    Name,
    AverageCost AS ProductUnitCost,
    CurrentStock
FROM Demo_Retail_Product
WHERE ProductType = 'Internal'
  AND Category NOT LIKE '%ingredient%'
  AND Category NOT LIKE '%sub%recipe%'
```

### COGS by Period
```sql
SELECT 
    YEAR(j.JournalDate) AS Year,
    MONTH(j.JournalDate) AS Month,
    SUM(jd.Debit) AS TotalCOGS
FROM Journals j
INNER JOIN JournalDetails jd ON j.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE coa.AccountCode = '5000' -- Cost of Sales
GROUP BY YEAR(j.JournalDate), MONTH(j.JournalDate)
ORDER BY Year, Month
```

## Troubleshooting

### Issue: GL entries not posting
**Solution**: Check if GL infrastructure exists by running:
```sql
SELECT 
    CASE WHEN OBJECT_ID('dbo.Journals', 'U') IS NOT NULL THEN 'EXISTS' ELSE 'MISSING' END AS Journals,
    CASE WHEN OBJECT_ID('dbo.sp_CreateJournalEntry', 'P') IS NOT NULL THEN 'EXISTS' ELSE 'MISSING' END AS CreateJournalEntry
```

### Issue: Costs not updating
**Solution**: Verify `Demo_Retail_Product` table has `AverageCost` and `LastPaidPrice` columns

### Issue: Sub-recipe not found
**Solution**: Ensure sub-recipe exists in both `Demo_SubRecipe_Master` and `Demo_Retail_Product` tables

## Future Enhancements

1. **Variance Analysis**: Track standard vs actual costs
2. **Batch Costing**: Track costs per batch number
3. **Multi-currency**: Support for foreign currency transactions
4. **Cost Allocation**: Allocate overhead costs to products
5. **Profitability Analysis**: Product-level profit reporting

## Support

For issues or questions, refer to:
- `DEPLOY_COMPLETE_GL_INTEGRATION.sql` for deployment verification
- GL infrastructure documentation in `GL_Master_Setup.sql`
- Existing inventory flow documentation

---

**Last Updated**: January 14, 2026
**Version**: 1.0
**Author**: Cascade AI Assistant
