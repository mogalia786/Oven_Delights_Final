# SQL Scripts Execution Order

Run these SQL scripts in your SQL Management Studio in the exact order listed:

## STEP 1: Check Database Schema (Optional but Recommended)
**File:** `CheckExistingSchema.sql`
- Run this first to see your current database structure
- This helps verify what tables and columns exist

## STEP 2: Create Teller Role
**File:** `CreateTellerRole.sql`
- Creates the Teller role in the Roles table
- Simple insert that only adds RoleName (fixed to match your schema)

## STEP 3: Add Code Fields to Product Tables
**File:** `AddCodeFieldsToProducts.sql`
- Adds Code field to Retail_Product table
- Adds Code field to Stockroom_Product table (if exists)
- Adds Code field to Manufacturing_Product table (if exists)
- Creates unique index on Retail_Product.Code
- Populates Code field with sequential values (00001, 00002, etc.)

## STEP 4: Add Code Field to Sale Lines
**File:** `AddCodeToSaleLines.sql`
- Adds Code field to Retail_SaleLines table
- Updates existing sale lines with product codes

## STEP 5: Verification (Optional)
Run this query to verify everything worked:

```sql
-- Check Teller role was created
SELECT * FROM Roles WHERE RoleName = 'Teller'

-- Check Code field was added to products
SELECT TOP 10 ProductID, Code, SKU, Name 
FROM Retail_Product 
WHERE Code IS NOT NULL
ORDER BY Code

-- Check Code field exists in sale lines table
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Retail_SaleLines' AND COLUMN_NAME = 'Code'
```

## Summary
1. `CheckExistingSchema.sql` (optional)
2. `CreateTellerRole.sql`
3. `AddCodeFieldsToProducts.sql`
4. `AddCodeToSaleLines.sql`
5. Run verification queries
