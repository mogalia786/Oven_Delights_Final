# SQL Batch Splitter - User Guide

## Overview
The SQL Batch Splitter automatically splits large INSERT statements into batches of 1000 rows (or your specified size) to avoid SQL Server's 1000-row limit.

## How to Use

### Step 1: Open the Tool
1. In the ERP application, go to **Utilities → SQL Batch Splitter**
2. The form will open with input and output sections

### Step 2: Load Your Large INSERT Statement

**Option A: Paste Directly**
- Copy your large INSERT statement from the CSV to SQL Converter
- Paste it into the **INPUT** text box

**Option B: Load from File**
- Click **"Load from File"** button
- Select your SQL file containing the large INSERT statement

### Step 3: Configure Batch Size (Optional)
- Default batch size is **1000 rows** (recommended)
- You can change this to any value between 1 and 1000
- Lower values = more batches, but safer for very large datasets

### Step 4: Split the Statement
- Click the **"Split into Batches"** button
- The tool will automatically:
  - Parse your INSERT statement
  - Extract all value rows
  - Split them into batches
  - Generate properly formatted SQL with GO statements

### Step 5: Use the Output

**Option A: Copy to Clipboard**
- Click **"Copy to Clipboard"**
- Paste directly into your SQL script or SSMS

**Option B: Save to File**
- Click **"Save to File"**
- Choose location and filename
- File is ready to run in SSMS

## Example

### INPUT (Large INSERT with 2700 rows):
```sql
INSERT INTO #StagingImport (Cost, Warehouse, ItemDescription, ...)
VALUES
(0.0000, 'OD200', 'Product 1', ...),
(0.0000, 'OD200', 'Product 2', ...),
... (2700 rows total)
;
```

### OUTPUT (Split into 3 Batches):
```sql
-- =====================================================
-- AUTO-GENERATED BATCHED INSERT STATEMENTS
-- Total Rows: 2700
-- Batch Size: 1000
-- Total Batches: 3
-- =====================================================

-- BATCH 1 (Rows 1-1000)
INSERT INTO #StagingImport (Cost, Warehouse, ItemDescription, ...)
VALUES
(0.0000, 'OD200', 'Product 1', ...),
(0.0000, 'OD200', 'Product 2', ...),
... (1000 rows)
;
GO

PRINT 'Batch 1 loaded (1000 rows).';
GO

-- BATCH 2 (Rows 1001-2000)
INSERT INTO #StagingImport (Cost, Warehouse, ItemDescription, ...)
VALUES
(0.0000, 'OD200', 'Product 1001', ...),
... (1000 rows)
;
GO

PRINT 'Batch 2 loaded (1000 rows).';
GO

-- BATCH 3 (Rows 2001-2700)
INSERT INTO #StagingImport (Cost, Warehouse, ItemDescription, ...)
VALUES
(0.0000, 'OD200', 'Product 2001', ...),
... (700 rows)
;
GO

PRINT 'Batch 3 loaded (700 rows).';
GO
```

## Complete Import Workflow

### 1. Generate INSERT Statements
- Use **Utilities → CSV to SQL Converter**
- Load your CSV files (OD200_Ayesha_Centre.csv, OD400_Umhlanga.csv)
- Click "Convert CSV Files to SQL"
- Copy the generated INSERT statements

### 2. Split into Batches
- Open **Utilities → SQL Batch Splitter**
- Paste the INSERT statements from step 1
- Click "Split into Batches"
- Copy or save the batched output

### 3. Run the Import
- Open `Simple_Direct_Import.sql` or `Import_With_Batching.sql`
- Connect to OvenDelightsERP database in SSMS
- Paste the batched INSERT statements in the designated section
- Run the complete script

### 4. Verify Import
Check the summary report at the end:
```
========================================
       IMPORT SUMMARY
========================================
Products: 1234
Variants: 1234
Prices: 2468
Stock: 2468
```

## Features

✅ **Automatic Parsing** - Handles complex INSERT statements with nested parentheses and string literals

✅ **Configurable Batch Size** - Set any batch size from 1 to 1000 rows

✅ **Progress Tracking** - Each batch includes a PRINT statement showing rows loaded

✅ **Error Prevention** - Avoids SQL Server's 1000-row limit error

✅ **Clean Output** - Properly formatted SQL with GO statements and comments

✅ **Multiple Output Options** - Copy to clipboard or save to file

## Tips

💡 **For Very Large Datasets (10,000+ rows)**
- Consider using batch size of 500 for better performance
- Run during off-peak hours

💡 **Handling Errors**
- If parsing fails, check for unmatched parentheses or quotes
- Ensure your INSERT statement is complete (has VALUES clause)

💡 **Best Practices**
- Always test with a small batch first
- Keep the original unbatched SQL as backup
- Verify row counts match after import

## Troubleshooting

### "No INSERT INTO statement found"
- Ensure your input contains a valid INSERT INTO clause
- Check that you copied the complete statement

### "No VALUES clause found"
- Make sure your INSERT statement includes the VALUES keyword
- Don't paste only the data rows without the INSERT INTO part

### Output looks incorrect
- Verify your input SQL is properly formatted
- Check for special characters or unusual formatting
- Try with a smaller sample first

## Support

For issues or questions:
1. Check the `Import_Errors_Fixed.md` documentation
2. Review the `Quick_Import_Guide.md` for complete workflow
3. Verify your CSV data format matches expected structure
