import pandas as pd

# Check OD200.csv
print("=" * 60)
print("CHECKING OD200.csv")
print("=" * 60)

try:
    df_od200 = pd.read_csv('OD200.csv', encoding='utf-8-sig')
    total_rows = len(df_od200)
    print(f"Total rows: {total_rows}")
    
    # Check for duplicates in Item Code column
    item_code_col = 'Item Code'
    if item_code_col in df_od200.columns:
        duplicates = df_od200[df_od200.duplicated(subset=[item_code_col], keep=False)]
        unique_count = df_od200[item_code_col].nunique()
        duplicate_count = total_rows - unique_count
        
        print(f"Unique Item Codes: {unique_count}")
        print(f"Duplicate Item Codes: {duplicate_count}")
        print(f"Expected: 1378")
        print(f"Difference: {1378 - unique_count}")
        
        if len(duplicates) > 0:
            print(f"\nFound {len(duplicates)} duplicate rows:")
            print(duplicates[[item_code_col, 'ITEM DESCRIPTION']].head(20))
    else:
        print(f"Column '{item_code_col}' not found. Available columns:")
        print(df_od200.columns.tolist())
except Exception as e:
    print(f"Error reading OD200.csv: {e}")

print("\n")
print("=" * 60)
print("CHECKING OD400.csv")
print("=" * 60)

try:
    df_od400 = pd.read_csv('OD400.csv', encoding='utf-8-sig')
    total_rows = len(df_od400)
    print(f"Total rows: {total_rows}")
    
    # Check for duplicates in Item Code column
    item_code_col = 'Item Code'
    if item_code_col in df_od400.columns:
        duplicates = df_od400[df_od400.duplicated(subset=[item_code_col], keep=False)]
        unique_count = df_od400[item_code_col].nunique()
        duplicate_count = total_rows - unique_count
        
        print(f"Unique Item Codes: {unique_count}")
        print(f"Duplicate Item Codes: {duplicate_count}")
        print(f"Expected: 1355")
        print(f"Difference: {1355 - unique_count}")
        
        if len(duplicates) > 0:
            print(f"\nFound {len(duplicates)} duplicate rows:")
            print(duplicates[[item_code_col, 'ITEM DESCRIPTION']].head(20))
    else:
        print(f"Column '{item_code_col}' not found. Available columns:")
        print(df_od400.columns.tolist())
except Exception as e:
    print(f"Error reading OD400.csv: {e}")

print("\n")
print("=" * 60)
print("SUMMARY")
print("=" * 60)
print("If duplicates exist, the import script removed them.")
print("If no duplicates, the missing records may be due to:")
print("1. Empty/invalid Item Codes")
print("2. Records filtered during import (e.g., missing required fields)")
