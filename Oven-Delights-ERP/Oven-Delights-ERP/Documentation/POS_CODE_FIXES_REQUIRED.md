# POS Code Fixes Required

## Overview
The POS needs to be updated to use Demo_Retail_Product instead of the old Products table.

## Critical Changes Needed

### 1. Table Name Changes
- Change: FROM dbo.Products → FROM dbo.Demo_Retail_Product
- Stock Table: Use dbo.RetailStock (not Retail_Stock with underscore)

### 2. Column Name Changes
- p.ProductName → p.Name
- p.ProductCode → p.SKU
- p.BaseUoM → Use 'ea' as default or rs.UnitOfMeasure

### 3. Stock Query Changes
OLD: LEFT JOIN dbo.Retail_Stock s ON s.VariantID = rv.VariantID
NEW: LEFT JOIN dbo.RetailStock rs ON rs.ProductID = p.ProductID AND rs.BranchID = @bid

### 4. Branch Filtering
Ensure all queries include branch filtering:
WHERE (p.BranchID = @BranchID OR p.BranchID IS NULL)
AND rs.BranchID = @BranchID

### 5. Product Type Filtering
POS should only show external (retail) products:
WHERE p.ProductType = 'External'

## Files to Check
- POSMainForm.vb
- POSDataService.vb
- ProductLookupForm.vb

## Testing Steps
1. Run POS_INTEGRATION_CHECK.sql to verify database schema
2. Update POS code with above changes
3. Test product lookup by SKU
4. Verify stock levels show correctly per branch
5. Test sale completion updates stock in RetailStock table
