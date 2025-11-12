"""
Quick Python script to split large INSERT statements into batches of 1000 rows
Usage: python split_sql.py
"""

import re

def split_insert_statement(input_file, output_file, batch_size=1000):
    print(f"Reading {input_file}...")
    
    with open(input_file, 'r', encoding='utf-8-sig') as f:
        content = f.read()
    
    # Find the INSERT INTO clause
    insert_match = re.search(r'(INSERT INTO #StagingImport.*?VALUES)\s*\n', content, re.IGNORECASE | re.DOTALL)
    if not insert_match:
        print("ERROR: Could not find INSERT INTO statement")
        return
    
    insert_clause = insert_match.group(1).strip()
    
    # Find where VALUES starts and extract everything after it
    values_start = content.find('VALUES', insert_match.start())
    if values_start == -1:
        print("ERROR: Could not find VALUES clause")
        return
    
    # Get everything after VALUES
    after_values = content[values_start + 6:].strip()
    
    # Remove trailing semicolon and GO
    after_values = re.sub(r';\s*GO.*$', '', after_values, flags=re.IGNORECASE | re.DOTALL).strip()
    after_values = after_values.rstrip(';').strip()
    
    # Parse rows - look for patterns like (...),
    rows = []
    current_pos = 0
    paren_depth = 0
    in_string = False
    string_char = None
    row_start = 0
    
    i = 0
    while i < len(after_values):
        c = after_values[i]
        
        # Handle string literals
        if c in ("'", '"'):
            if i > 0 and after_values[i-1] == '\\':
                i += 1
                continue
            if not in_string:
                in_string = True
                string_char = c
            elif c == string_char:
                in_string = False
                string_char = None
        
        if not in_string:
            if c == '(':
                if paren_depth == 0:
                    row_start = i
                paren_depth += 1
            elif c == ')':
                paren_depth -= 1
                if paren_depth == 0:
                    # Found complete row
                    row = after_values[row_start:i+1].strip()
                    rows.append(row)
        
        i += 1
    
    print(f"Found {len(rows)} rows")
    
    if len(rows) == 0:
        print("ERROR: No rows found!")
        return
    
    # Calculate batches
    total_batches = (len(rows) + batch_size - 1) // batch_size
    
    print(f"Splitting into {total_batches} batches of {batch_size} rows each...")
    
    # Write output
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("-- =====================================================\n")
        f.write("-- AUTO-GENERATED BATCHED INSERT STATEMENTS\n")
        f.write(f"-- Total Rows: {len(rows)}\n")
        f.write(f"-- Batch Size: {batch_size}\n")
        f.write(f"-- Total Batches: {total_batches}\n")
        f.write("-- =====================================================\n")
        f.write("-- NOTE: Connect to OvenDelightsERP database before running\n\n")
        
        # Write table creation from original file
        table_start = content.find('IF OBJECT_ID')
        table_end = content.find('GO', table_start)
        if table_start != -1 and table_end != -1:
            f.write(content[table_start:table_end].strip())
            f.write("\nGO\n\n")
        
        # Write batches
        for batch_num in range(total_batches):
            start_idx = batch_num * batch_size
            end_idx = min(start_idx + batch_size, len(rows))
            batch_rows = rows[start_idx:end_idx]
            
            f.write(f"-- BATCH {batch_num + 1} (Rows {start_idx + 1}-{end_idx})\n")
            # Only write INSERT clause without VALUES (it's already in insert_clause)
            f.write(insert_clause.replace('VALUES', '').strip() + "\n")
            f.write("VALUES\n")
            
            for i, row in enumerate(batch_rows):
                f.write(row)
                if i < len(batch_rows) - 1:
                    f.write(",\n")
                else:
                    f.write(";\n")
            
            f.write("GO\n\n")
            f.write(f"PRINT 'Batch {batch_num + 1} loaded ({len(batch_rows)} rows).';\n")
            f.write("GO\n\n")
        
        # Write the rest of the processing logic
        process_start = content.find('-- Add computed columns')
        if process_start != -1:
            f.write("\n")
            f.write(content[process_start:])
    
    print(f"Successfully created {output_file}")
    print(f"Total rows: {len(rows)}")
    print(f"Total batches: {total_batches}")

if __name__ == "__main__":
    input_file = r"c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\SQL\Simple_Direct_Import.sql"
    output_file = r"c:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\SQL\Batched_Import_Ready.sql"
    
    split_insert_statement(input_file, output_file, batch_size=1000)
    print("\nDone! Run Batched_Import_Ready.sql in SSMS")
