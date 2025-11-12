# RETAIL STOCK FIX - SIMPLE STEPS

## The Problem
Products show 0 qty after completing production because `sp_CompleteReOrderProduct` wasn't updating the retail stock tables.

## The Solution - 3 Simple Steps

### Step 1: Check Your Schema (Optional but Recommended)
Run this to see what tables/columns you have:
```sql
SQL\CHECK_PRODUCTS_SCHEMA.sql
```

This will show you:
- What columns exist in Products table
- What stock tables exist (RetailStock, Retail_Stock, etc.)

### Step 2: Apply the Universal Fix
Run this script - it works with ANY schema:
```sql
SQL\FIX_RETAIL_STOCK_UNIVERSAL.sql
```

This script:
- ✅ Checks what exists in YOUR database first
- ✅ Updates `sp_CompleteReOrderProduct` to update ALL relevant tables
- ✅ No schema errors - it adapts to your database

### Step 3: Test It
1. Complete a product in the baker dashboard
2. Run this quick check:
```sql
SQL\CHECK_RETAIL_STOCK_NOW.sql
```

You should now see the product with quantity > 0!

## What the Fix Does

When a baker completes a product, the stored procedure now:

1. ✅ Creates `StockMovements` record (audit trail)
2. ✅ Updates `RetailStock` table (if exists)
3. ✅ Updates `Retail_Stock` table (if exists with underscore)
4. ✅ Updates `Products.CurrentStock` (if column exists)
5. ✅ Updates `Products.StockOnHand` (if column exists)

The procedure checks what exists in YOUR database and updates accordingly!

## Verification Queries

### Quick Check - Show All Retail Stock
```sql
-- If you have RetailStock table
SELECT 
    p.ProductName,
    rs.Quantity,
    rs.LastUpdated
FROM RetailStock rs
INNER JOIN Products p ON rs.ProductID = p.ProductID
WHERE rs.StockType = 'Internal'
ORDER BY rs.LastUpdated DESC;
```

### Check Products Table (if it has stock columns)
```sql
-- Check if Products has CurrentStock
SELECT 
    ProductName,
    SKU,
    CurrentStock
FROM Products
WHERE CurrentStock > 0;

-- OR if it has StockOnHand
SELECT 
    ProductName,
    SKU,
    StockOnHand
FROM Products
WHERE StockOnHand > 0;
```

### Check Stock Movements (Audit Trail)
```sql
SELECT TOP 10
    sm.MovementDate,
    p.ProductName,
    sm.QuantityIn,
    sm.BalanceAfter,
    u.FirstName + ' ' + u.LastName AS CompletedBy
FROM StockMovements sm
INNER JOIN Products p ON sm.MaterialID = p.ProductID
LEFT JOIN Users u ON sm.CreatedBy = u.UserID
WHERE sm.MovementType = 'Production Complete'
ORDER BY sm.MovementID DESC;
```

## Troubleshooting

### Problem: Still showing 0 qty
**Solution:** 
1. Check if the stored procedure was actually updated:
```sql
SELECT OBJECT_DEFINITION(OBJECT_ID('sp_CompleteReOrderProduct'));
```
Look for "UPDATE RetailStock" or "UPDATE Products" in the code.

2. Check if there are any errors in the stored procedure execution:
```sql
-- Check ReOrderBookLines for RetailStockUpdated flag
SELECT 
    ProductName,
    QuantityCompleted,
    RetailStockUpdated,
    CompletedDate
FROM ReOrderBookLines
WHERE LineStatus = 'Completed'
ORDER BY CompletedDate DESC;
```

If `RetailStockUpdated = 0` or NULL, the stock update failed.

### Problem: "Invalid column name" errors
**Solution:** Use the universal fix script (`FIX_RETAIL_STOCK_UNIVERSAL.sql`) - it checks what exists first and only updates what's available.

### Problem: Don't know which table stores retail stock
**Solution:** Run `CHECK_PRODUCTS_SCHEMA.sql` to see all tables and columns.

## Summary

**Before Fix:**
- ❌ Only StockMovements updated (audit only)
- ❌ Products show 0 qty
- ❌ Retail stock not updated

**After Fix:**
- ✅ StockMovements updated (audit trail)
- ✅ RetailStock/Retail_Stock updated (actual inventory)
- ✅ Products.CurrentStock/StockOnHand updated (if exists)
- ✅ Products show correct quantities
- ✅ Works with ANY database schema

**Just run `FIX_RETAIL_STOCK_UNIVERSAL.sql` and you're done!**
