"""
Convert CSV to SQL INSERT statements with proper escaping
"""
import csv
import sys

def escape_sql_value(value, is_numeric=False):
    """Properly escape values for SQL"""
    if value is None or value == '' or str(value).strip() == '':
        return 'NULL'
    
    str_value = str(value).strip()
    
    # If we expect a numeric value
    if is_numeric:
        try:
            # Remove commas and convert to float
            num_value = float(str_value.replace(',', ''))
            return str(num_value)
        except ValueError:
            return 'NULL'
    else:
        # It's a string, escape single quotes
        escaped = str_value.replace("'", "''")
        return f"'{escaped}'"

def csv_to_sql(csv_file, output_file, batch_size=1000):
    """Convert CSV to batched SQL INSERT statements"""
    
    print(f"Reading {csv_file}...")
    
    # Read CSV with proper encoding
    encodings = ['utf-8-sig', 'utf-8', 'latin-1', 'cp1252']
    data = None
    
    for encoding in encodings:
        try:
            with open(csv_file, 'r', encoding=encoding) as f:
                reader = csv.reader(f)
                data = list(reader)
                print(f"Successfully read with encoding: {encoding}")
                break
        except (UnicodeDecodeError, UnicodeError):
            continue
    
    if data is None:
        print("ERROR: Could not read CSV file")
        return
    
    if len(data) < 2:
        print("ERROR: CSV file has no data")
        return
    
    headers = data[0]
    rows = data[1:]
    
    print(f"Found {len(rows)} data rows")
    print(f"Columns: {', '.join(headers)}")
    
    # Map CSV columns to SQL columns
    # CSV: Item Code, BARCODE, ITEM DESCRIPTION, CATERGORY, item catergory, Ingredients, Item Description, Whse, Cost, Incl Price, (extra cols)
    # SQL: Cost, Warehouse, Ingredients, ItemDescription, Category, ItemCategory, Barcode, ItemDescription2, Col9, ItemCode, InclPrice, Treatment, Branch
    csv_to_sql_map = {
        'Item Code': 9,      # ItemCode
        'BARCODE': 6,        # Barcode
        'ITEM DESCRIPTION': 3,  # ItemDescription
        'CATERGORY': 4,      # Category
        'item catergory': 5, # ItemCategory
        'Ingredients': 2,    # Ingredients
        'Item Description': 7,  # ItemDescription2
        'Whse': 1,          # Warehouse
        'Cost': 0,          # Cost
        'Incl Price': 10,   # InclPrice
    }
    
    print(f"Column mapping: {csv_to_sql_map}")
    
    # Calculate batches
    total_batches = (len(rows) + batch_size - 1) // batch_size
    
    print(f"Creating {total_batches} batches of {batch_size} rows each...")
    
    # Write SQL file
    with open(output_file, 'w', encoding='utf-8') as f:
        # Write header
        f.write("-- =====================================================\n")
        f.write("-- AUTO-GENERATED BATCHED INSERT STATEMENTS\n")
        f.write(f"-- Total Rows: {len(rows)}\n")
        f.write(f"-- Batch Size: {batch_size}\n")
        f.write(f"-- Total Batches: {total_batches}\n")
        f.write("-- =====================================================\n\n")
        
        # Create staging table
        f.write("IF OBJECT_ID('tempdb..#StagingImport') IS NOT NULL DROP TABLE #StagingImport;\n")
        f.write("CREATE TABLE #StagingImport (\n")
        f.write("    Cost DECIMAL(18,4),\n")
        f.write("    Warehouse NVARCHAR(50),\n")
        f.write("    Ingredients NVARCHAR(MAX),\n")
        f.write("    ItemDescription NVARCHAR(500),\n")
        f.write("    Category NVARCHAR(100),\n")
        f.write("    ItemCategory NVARCHAR(50),\n")
        f.write("    Barcode NVARCHAR(50),\n")
        f.write("    ItemDescription2 NVARCHAR(500),\n")
        f.write("    Col9 NVARCHAR(50),\n")
        f.write("    ItemCode NVARCHAR(50),\n")
        f.write("    InclPrice DECIMAL(18,2),\n")
        f.write("    Treatment NVARCHAR(50),\n")
        f.write("    Branch NVARCHAR(100)\n")
        f.write(");\n")
        f.write("GO\n\n")
        
        # Write batches
        for batch_num in range(total_batches):
            start_idx = batch_num * batch_size
            end_idx = min(start_idx + batch_size, len(rows))
            batch_rows = rows[start_idx:end_idx]
            
            f.write(f"-- BATCH {batch_num + 1} (Rows {start_idx + 1}-{end_idx})\n")
            f.write("INSERT INTO #StagingImport (Cost, Warehouse, Ingredients, ItemDescription, Category, ItemCategory, Barcode, ItemDescription2, Col9, ItemCode, InclPrice, Treatment, Branch)\n")
            f.write("VALUES\n")
            
            for i, row in enumerate(batch_rows):
                # Ensure row has enough columns
                while len(row) < len(headers):
                    row.append('')
                
                # Build VALUES clause in correct SQL order
                # CSV: Item Code(0), BARCODE(1), ITEM DESCRIPTION(2), CATERGORY(3), item catergory(4), Ingredients(5), Item Description(6), Whse(7), Cost(8), Incl Price(9)
                # SQL: Cost, Warehouse, Ingredients, ItemDescription, Category, ItemCategory, Barcode, ItemDescription2, Col9, ItemCode, InclPrice, Treatment, Branch
                sql_values = [
                    escape_sql_value(row[8], is_numeric=True),   # Cost (DECIMAL)
                    escape_sql_value(row[7], is_numeric=False),  # Warehouse (NVARCHAR)
                    escape_sql_value(row[5], is_numeric=False),  # Ingredients (NVARCHAR)
                    escape_sql_value(row[2], is_numeric=False),  # ItemDescription (NVARCHAR)
                    escape_sql_value(row[3], is_numeric=False),  # Category (NVARCHAR)
                    escape_sql_value(row[4], is_numeric=False),  # ItemCategory (NVARCHAR)
                    escape_sql_value(row[1], is_numeric=False),  # Barcode (NVARCHAR) - treat as string even if it's "0"
                    escape_sql_value(row[6], is_numeric=False),  # ItemDescription2 (NVARCHAR)
                    'NULL',                                      # Col9
                    escape_sql_value(row[0], is_numeric=False),  # ItemCode (NVARCHAR)
                    escape_sql_value(row[9], is_numeric=True),   # InclPrice (DECIMAL)
                    'NULL',                                      # Treatment
                    escape_sql_value(row[7], is_numeric=False)   # Branch (NVARCHAR)
                ]
                
                f.write(f"({', '.join(sql_values)})")
                
                if i < len(batch_rows) - 1:
                    f.write(",\n")
                else:
                    f.write(";\n")
            
            f.write("GO\n\n")
            f.write(f"PRINT 'Batch {batch_num + 1} loaded ({len(batch_rows)} rows).';\n")
            f.write("GO\n\n")
    
    print(f"\nSuccessfully created {output_file}")
    print(f"Total rows: {len(rows)}")
    print(f"Total batches: {total_batches}")
    print("\nNext: Run this SQL file, then run Complete_Import_Script.sql")

if __name__ == "__main__":
    csv_file = r"C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\StockItems with Prices and descriptions\Combined_Inventory.csv"
    output_file = r"C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\SQL\Batched_Import_Ready.sql"
    
    csv_to_sql(csv_file, output_file, batch_size=1000)
