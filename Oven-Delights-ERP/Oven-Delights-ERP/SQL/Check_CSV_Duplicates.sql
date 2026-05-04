-- Check for duplicate Item Codes in the original CSV
-- This requires re-running the staging import to check

-- For now, check if there are any duplicate Codes in Demo_Retail_Product
SELECT 
    Code,
    COUNT(*) AS DuplicateCount
FROM Demo_Retail_Product
GROUP BY Code
HAVING COUNT(*) > 1;

-- Check the Combined_Inventory.csv for duplicates
-- You need to manually check this file or run this Python script:

/*
Python script to check duplicates in CSV:

import pandas as pd

# Read CSV
df = pd.read_csv(r'C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\StockItems with Prices and descriptions\Combined_Inventory.csv')

# Count total rows
print(f"Total rows in CSV: {len(df)}")

# Count by Whse
print("\nRows by warehouse:")
print(df['Whse'].value_counts())

# Check for duplicate Item Codes within each warehouse
print("\nDuplicate Item Codes in OD200:")
od200_dupes = df[df['Whse'] == 'OD200']['Item Code'].value_counts()
print(f"Duplicates: {len(od200_dupes[od200_dupes > 1])}")
if len(od200_dupes[od200_dupes > 1]) > 0:
    print(od200_dupes[od200_dupes > 1].head(10))

print("\nDuplicate Item Codes in OD400:")
od400_dupes = df[df['Whse'] == 'OD400']['Item Code'].value_counts()
print(f"Duplicates: {len(od400_dupes[od400_dupes > 1])}")
if len(od400_dupes[od400_dupes > 1]) > 0:
    print(od400_dupes[od400_dupes > 1].head(10))
*/

-- Expected vs Actual
SELECT 
    'OD200 Expected' AS Source, 1378 AS Count
UNION ALL
SELECT 'OD200 Actual', COUNT(*) FROM Demo_Retail_Product WHERE Code LIKE 'AC%'
UNION ALL
SELECT 'OD200 Missing', 1378 - COUNT(*) FROM Demo_Retail_Product WHERE Code LIKE 'AC%'
UNION ALL
SELECT 'OD400 Expected', 1355
UNION ALL
SELECT 'OD400 Actual', COUNT(*) FROM Demo_Retail_Product WHERE Code LIKE 'UM%'
UNION ALL
SELECT 'OD400 Missing', 1355 - COUNT(*) FROM Demo_Retail_Product WHERE Code LIKE 'UM%';
