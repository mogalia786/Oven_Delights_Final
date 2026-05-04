# Quick Import Guide - CSV to Database

## Problem Summary
The original import script had column name mismatches with your actual database schema. The fixed version uses dynamic column detection and correct naming.

## Solution: 3-Step Process

### Step 1: Run Schema Check (Optional but Recommended)
```sql
-- Run: Check_Table_Schemas.sql
-- This shows you the actual column names in your database
```

### Step 2: Generate SQL from CSV Files
1. Open ERP application
2. Navigate to: **Utilities → CSV to SQL Converter**
3. Click **"Convert CSV Files to SQL"**
4. Copy the generated SQL output

### Step 3: Run Fixed Import Script
1. Open **Fixed_Import_Script.sql** in SQL Server Management Studio
2. Find the section that says:
   ```sql
   PRINT '-- PASTE YOUR INSERT STATEMENTS HERE:';
   ```
3. **Paste** the SQL you copied from Step 2
4. **Execute** the entire script
5. Check the summary report at the end

---

## What Gets Imported

### ✅ Demo_Retail_Product
- All finished products (internal + external)
- Excludes raw materials and sub-assemblies
- Generates barcodes from Code field

### ✅ Demo_Retail_Variant
- One default variant per product
- Handles different column name variations (Name vs VariantName)

### ✅ Demo_Retail_Price
- Branch-specific pricing (OD200 and OD400)
- **SellingPrice**: InclVAT from CSV
- **SellingPriceExVAT**: Calculated (InclVAT / 1.15)
- **CostPrice**: Cost from CSV

### ✅ Demo_Retail_Stock
- Branch-specific stock records
- Initial QtyOnHand = 0
- Handles LastUpdated column if it exists

---

## Key Features of Fixed Script

### 1. Dynamic Column Detection
The script checks if columns exist before using them:
```sql
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Variant') AND name = 'VariantName')
```

### 2. Automatic Schema Updates
Adds missing columns automatically:
```sql
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Price') AND name = 'SellingPriceExVAT')
BEGIN
    ALTER TABLE Demo_Retail_Price ADD SellingPriceExVAT DECIMAL(18,2) NULL;
END
```

### 3. Barcode Generation
- **Internal products**: `2` + 8-digit padded Code
- **External products**: Uses existing barcode from CSV

### 4. VAT Calculations
- **InclVAT**: Direct from CSV (R115.00)
- **ExVAT**: Calculated (R115.00 / 1.15 = R100.00)

---

## Troubleshooting

### Error: "Invalid column name"
**Solution**: Run `Check_Table_Schemas.sql` to see actual column names, then update the Fixed_Import_Script.sql accordingly.

### Error: "Cannot insert NULL into column"
**Solution**: The column has a NOT NULL constraint. Check the schema and add a default value in the INSERT statement.

### No data imported (0 rows)
**Solution**: 
1. Check that you pasted the INSERT statements in the correct location
2. Verify the staging table has data: `SELECT * FROM #StagingImport`
3. Check the classification logic matches your categories

### Duplicate key errors
**Solution**: The script skips duplicates automatically using `NOT EXISTS` checks. If you still get errors, clear the tables first:
```sql
DELETE FROM Demo_Retail_Stock;
DELETE FROM Demo_Retail_Price;
DELETE FROM Demo_Retail_Variant;
DELETE FROM Demo_Retail_Product;
```

---

## Files Created

| File | Purpose |
|------|---------|
| `Check_Table_Schemas.sql` | Shows actual database column names |
| `Fixed_Import_Script.sql` | Main import script with dynamic column detection |
| `CSVToSQLConverter.vb` | Updated utility to generate staging INSERT statements |
| `Quick_Import_Guide.md` | This guide |

---

## Expected Results

After successful import, you should see:

```
========================================
       IMPORT SUMMARY REPORT
========================================

Demo_Retail_Product: 1379
Demo_Retail_Variant: 1379
Demo_Retail_Price: 2758 (2x products for 2 branches)
Demo_Retail_Stock: 2758 (2x products for 2 branches)

========================================
Import completed!
========================================
```

---

## Next Steps After Import

1. **Verify Data**: Check sample products in Demo_Retail_Product
2. **Test Barcodes**: Verify SKU field has correct barcodes
3. **Check Pricing**: Confirm SellingPrice and SellingPriceExVAT are correct
4. **Update Stock**: Use Stock Adjustment forms to set actual quantities
5. **Test POS**: Try scanning products in POS system

---

## Notes

- Initial stock levels are set to 0
- Both branches (OD200 and OD400) are imported
- Raw materials and sub-assemblies are excluded from POS tables
- Categories need manual mapping (CategoryID will be NULL initially)
