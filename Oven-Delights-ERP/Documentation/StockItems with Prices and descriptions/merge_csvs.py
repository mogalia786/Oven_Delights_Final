import csv
import os

# File paths
od200_file = r'C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\StockItems with Prices and descriptions\OD200.csv'
od400_file = r'C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\StockItems with Prices and descriptions\OD400.csv'
output_file = r'C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\StockItems with Prices and descriptions\Combined_Inventory.csv'

print("Merging OD200.csv and OD400.csv...")

# Function to read CSV with multiple encoding attempts
def read_csv_file(filepath):
    encodings = ['utf-8-sig', 'utf-8', 'latin-1', 'cp1252', 'iso-8859-1']
    for encoding in encodings:
        try:
            with open(filepath, 'r', encoding=encoding) as f:
                reader = csv.reader(f)
                data = list(reader)
                print(f"  - Successfully read with encoding: {encoding}")
                return data
        except (UnicodeDecodeError, UnicodeError):
            continue
    raise Exception(f"Could not read {filepath} with any encoding")

# Read and combine both files
combined_data = []
header = None

# Read OD200
print(f"Reading {od200_file}...")
od200_data = read_csv_file(od200_file)
header = od200_data[0]  # Get header

# Find the Whse column index
whse_index = None
for i, col in enumerate(header):
    if col.strip().lower() in ['whse', 'warehouse']:
        whse_index = i
        break

if whse_index is None:
    print("WARNING: Could not find Whse/Warehouse column, will add it at the end")
    header.append('Whse')
    whse_index = len(header) - 1

od200_count = 0
for row in od200_data[1:]:
    if row and any(row):  # Skip empty rows
        # Ensure row has enough columns
        while len(row) <= whse_index:
            row.append('')
        # Set Warehouse to OD200
        row[whse_index] = 'OD200'
        combined_data.append(row)
        od200_count += 1
print(f"  - Loaded {od200_count} records from OD200")

# Read OD400
print(f"Reading {od400_file}...")
od400_data = read_csv_file(od400_file)
od400_count = 0
for row in od400_data[1:]:  # Skip header
    if row and any(row):  # Skip empty rows
        # Ensure row has enough columns
        while len(row) <= whse_index:
            row.append('')
        # Set Warehouse to OD400
        row[whse_index] = 'OD400'
        combined_data.append(row)
        od400_count += 1
print(f"  - Loaded {od400_count} records from OD400")

# Write combined file
print(f"Writing combined file to {output_file}...")
with open(output_file, 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerows(combined_data)

print(f"\n✓ Successfully merged!")
print(f"  - OD200: {od200_count} records")
print(f"  - OD400: {od400_count} records")
print(f"  - Total: {len(combined_data)} records")
print(f"\nOutput file: {output_file}")
