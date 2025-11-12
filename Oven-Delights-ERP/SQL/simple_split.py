"""
Simple line-based splitter - just counts commas between rows
"""

input_file = r"c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\SQL\Simple_Direct_Import.sql"
output_file = r"c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\SQL\Batched_Import_Final.sql"

print("Reading file...")
with open(input_file, 'r', encoding='utf-8-sig') as f:
    lines = f.readlines()

# Find where INSERT VALUES starts
insert_start = None
values_start = None
processing_start = None

for i, line in enumerate(lines):
    if 'INSERT INTO #StagingImport' in line and insert_start is None:
        insert_start = i
    if insert_start and 'VALUES' in line and values_start is None:
        values_start = i
    if '-- Add computed columns' in line:
        processing_start = i
        break

if not insert_start or not values_start:
    print("ERROR: Could not find INSERT statement")
    exit(1)

print(f"Found INSERT at line {insert_start}, VALUES at line {values_start}")

# Get the header (everything before INSERT)
header = lines[:insert_start]

# Get INSERT clause
insert_clause = ''.join(lines[insert_start:values_start+1])

# Get data rows (between VALUES and processing)
data_lines = lines[values_start+1:processing_start]

# Get processing logic (everything after data)
processing = lines[processing_start:]

# Count rows by looking for lines that end with ),
row_count = 0
data_rows = []
current_row = []

for line in data_lines:
    current_row.append(line)
    stripped = line.strip()
    
    # Check if this line ends a row
    if stripped.endswith('),') or stripped.endswith(');'):
        data_rows.append(''.join(current_row))
        current_row = []
        row_count += 1

print(f"Found {row_count} data rows")

# Split into batches
batch_size = 1000
total_batches = (row_count + batch_size - 1) // batch_size

print(f"Creating {total_batches} batches...")

with open(output_file, 'w', encoding='utf-8') as f:
    # Write header
    f.write("-- =====================================================\n")
    f.write("-- BATCHED IMPORT - READY TO RUN\n")
    f.write(f"-- Total Rows: {row_count}\n")
    f.write(f"-- Batches: {total_batches}\n")
    f.write("-- =====================================================\n")
    f.write("-- NOTE: Connect to OvenDelightsERP database first\n\n")
    
    # Write table creation
    for line in header:
        if 'USE OvenDelightsERP' not in line:
            f.write(line)
    
    # Write batches
    for batch_num in range(total_batches):
        start_idx = batch_num * batch_size
        end_idx = min(start_idx + batch_size, row_count)
        batch_rows = data_rows[start_idx:end_idx]
        
        f.write(f"\n-- BATCH {batch_num + 1} (Rows {start_idx + 1}-{end_idx})\n")
        f.write(insert_clause)
        
        for i, row in enumerate(batch_rows):
            # Change last row's ), to ); 
            if i == len(batch_rows) - 1:
                row = row.replace('),', ');')
            f.write(row)
        
        f.write("GO\n\n")
        f.write(f"PRINT 'Batch {batch_num + 1} loaded ({len(batch_rows)} rows).';\n")
        f.write("GO\n\n")
    
    # Write processing logic
    for line in processing:
        f.write(line)

print(f"\nSuccess! Created {output_file}")
print(f"Total rows: {row_count}")
print(f"Total batches: {total_batches}")
