"""
Map Products to Categories and SubCategories
Updates both Demo_Retail_Product and Products tables
"""

import csv
import pyodbc

# File paths
pos_csv = r"C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Database\Copy of ITEM LIST NEW 2025 updated_Point Of Sale.csv"
backend_csv = r"C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Database\Copy of ITEM LIST NEW 2025 updated_Back End.csv"

# Database connection
conn_str = (
    "Driver={ODBC Driver 17 for SQL Server};"
    "Server=tcp:mogalia.database.windows.net,1433;"
    "Database=Oven_Delights_Main;"
    "Uid=faroq786;"
    "Pwd=Faroq#786;"
    "Encrypt=yes;"
    "TrustServerCertificate=no;"
    "Connection Timeout=30;"
)

def read_excel_data(csv_path):
    """Read CSV and return list of rows"""
    with open(csv_path, 'r', encoding='utf-8-sig') as f:
        reader = csv.DictReader(f)
        return list(reader)

def update_demo_retail_product(conn, excel_data):
    """Update Demo_Retail_Product with ProductCode, CategoryID, SubCategoryID"""
    cursor = conn.cursor()
    
    print(f"\n{'='*60}")
    print("UPDATING Demo_Retail_Product")
    print(f"{'='*60}\n")
    
    # Step 0: Add columns if they don't exist
    print("Step 0: Adding columns if needed...")
    
    cursor.execute("""
        IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Product') AND name = 'ProductCode')
        BEGIN
            ALTER TABLE Demo_Retail_Product ADD ProductCode NVARCHAR(50) NULL
        END
    """)
    
    cursor.execute("""
        IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Product') AND name = 'CategoryID')
        BEGIN
            ALTER TABLE Demo_Retail_Product ADD CategoryID INT NULL
        END
    """)
    
    cursor.execute("""
        IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Product') AND name = 'SubCategoryID')
        BEGIN
            ALTER TABLE Demo_Retail_Product ADD SubCategoryID INT NULL
        END
    """)
    
    cursor.execute("""
        IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Product') AND name = 'BranchID')
        BEGIN
            ALTER TABLE Demo_Retail_Product ADD BranchID INT NULL
        END
    """)
    
    conn.commit()
    print("  + Columns ready\n")
    
    # Step 1: Extract ProductCode from Code field
    print("Step 1: Extracting ProductCode from Code...")
    cursor.execute("""
        UPDATE Demo_Retail_Product
        SET ProductCode = CASE 
            WHEN Code LIKE 'AC%' THEN SUBSTRING(Code, 3, LEN(Code))
            WHEN Code LIKE 'UM%' THEN SUBSTRING(Code, 3, LEN(Code))
            ELSE Code
        END
        WHERE ProductCode IS NULL AND Code IS NOT NULL
    """)
    conn.commit()
    print(f"  + {cursor.rowcount} records updated with ProductCode\n")
    
    # Step 2: Map CategoryID and SubCategoryID
    print("Step 2: Mapping CategoryID and SubCategoryID...")
    
    updated_count = 0
    skipped_count = 0
    error_count = 0
    
    for row in excel_data:
        item_code = (row.get('I+1:1579TEM CCODE') or row.get('ITEM CCODE') or '').strip()
        main_cat = (row.get('Main Category') or '').strip()
        sub_cat = (row.get('Sub Category') or '').strip()
        
        if not item_code or not main_cat:
            skipped_count += 1
            continue
        
        try:
            # Get CategoryID
            cursor.execute("SELECT CategoryID FROM Categories WHERE CategoryName = ?", main_cat)
            cat_row = cursor.fetchone()
            
            if not cat_row:
                print(f"  ! Category not found: {main_cat}")
                error_count += 1
                continue
            
            category_id = cat_row[0]
            subcategory_id = None
            
            # Get SubCategoryID if subcategory exists
            if sub_cat:
                cursor.execute(
                    "SELECT SubCategoryID FROM SubCategories WHERE CategoryID = ? AND SubCategoryName = ?",
                    category_id, sub_cat
                )
                sub_row = cursor.fetchone()
                if sub_row:
                    subcategory_id = sub_row[0]
            
            # Update Demo_Retail_Product
            cursor.execute("""
                UPDATE Demo_Retail_Product
                SET CategoryID = ?, SubCategoryID = ?
                WHERE ProductCode = ?
            """, category_id, subcategory_id, item_code)
            
            if cursor.rowcount > 0:
                updated_count += cursor.rowcount
            
        except Exception as e:
            print(f"  ! Error mapping {item_code}: {e}")
            error_count += 1
    
    conn.commit()
    
    print(f"\n  + {updated_count} Demo_Retail_Product records mapped")
    print(f"  - {skipped_count} records skipped (missing data)")
    print(f"  - {error_count} errors\n")
    
    cursor.close()
    return updated_count

def update_products_master(conn, excel_data):
    """Update Products (Master) with CategoryID, SubCategoryID"""
    cursor = conn.cursor()
    
    # Check if Products table exists
    cursor.execute("SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Products'")
    if cursor.fetchone()[0] == 0:
        print("! Products table not found - skipping master table update\n")
        cursor.close()
        return 0
    
    print(f"\n{'='*60}")
    print("UPDATING Products (Master Table)")
    print(f"{'='*60}\n")
    
    # Add columns if they don't exist
    print("Adding columns if needed...")
    
    cursor.execute("""
        IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'CategoryID')
        BEGIN
            ALTER TABLE Products ADD CategoryID INT NULL
        END
    """)
    
    cursor.execute("""
        IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'SubCategoryID')
        BEGIN
            ALTER TABLE Products ADD SubCategoryID INT NULL
        END
    """)
    
    conn.commit()
    print("  + Columns ready\n")
    
    updated_count = 0
    skipped_count = 0
    error_count = 0
    
    for row in excel_data:
        item_code = (row.get('I+1:1579TEM CCODE') or row.get('ITEM CCODE') or '').strip()
        main_cat = (row.get('Main Category') or '').strip()
        sub_cat = (row.get('Sub Category') or '').strip()
        
        if not item_code or not main_cat:
            skipped_count += 1
            continue
        
        try:
            # Get CategoryID
            cursor.execute("SELECT CategoryID FROM Categories WHERE CategoryName = ?", main_cat)
            cat_row = cursor.fetchone()
            
            if not cat_row:
                error_count += 1
                continue
            
            category_id = cat_row[0]
            subcategory_id = None
            
            # Get SubCategoryID if subcategory exists
            if sub_cat:
                cursor.execute(
                    "SELECT SubCategoryID FROM SubCategories WHERE CategoryID = ? AND SubCategoryName = ?",
                    category_id, sub_cat
                )
                sub_row = cursor.fetchone()
                if sub_row:
                    subcategory_id = sub_row[0]
            
            # Update Products
            cursor.execute("""
                UPDATE Products
                SET CategoryID = ?, SubCategoryID = ?
                WHERE ProductCode = ?
            """, category_id, subcategory_id, item_code)
            
            if cursor.rowcount > 0:
                updated_count += cursor.rowcount
            
        except Exception as e:
            error_count += 1
    
    conn.commit()
    
    print(f"  + {updated_count} Products (Master) records mapped")
    print(f"  - {skipped_count} records skipped (missing data)")
    print(f"  - {error_count} errors\n")
    
    cursor.close()
    return updated_count

def verify_mapping(conn):
    """Verify the mapping results"""
    cursor = conn.cursor()
    
    print(f"\n{'='*60}")
    print("VERIFICATION")
    print(f"{'='*60}\n")
    
    # Demo_Retail_Product summary
    print("Demo_Retail_Product by Category:")
    cursor.execute("""
        SELECT 
            ISNULL(c.CategoryName, 'NO CATEGORY') AS Category,
            ISNULL(sc.SubCategoryName, 'NO SUBCATEGORY') AS SubCategory,
            COUNT(*) AS ProductCount
        FROM Demo_Retail_Product drp
        LEFT JOIN Categories c ON c.CategoryID = drp.CategoryID
        LEFT JOIN SubCategories sc ON sc.SubCategoryID = drp.SubCategoryID
        GROUP BY c.CategoryName, sc.SubCategoryName
        ORDER BY c.CategoryName, sc.SubCategoryName
    """)
    
    for row in cursor.fetchall():
        print(f"  {row[0]:30} > {row[1]:30} : {row[2]:4} products")
    
    # Products (Master) summary
    cursor.execute("SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Products'")
    if cursor.fetchone()[0] > 0:
        print("\nProducts (Master) by Category:")
        cursor.execute("""
            SELECT 
                ISNULL(c.CategoryName, 'NO CATEGORY') AS Category,
                ISNULL(sc.SubCategoryName, 'NO SUBCATEGORY') AS SubCategory,
                COUNT(*) AS ProductCount
            FROM Products p
            LEFT JOIN Categories c ON c.CategoryID = p.CategoryID
            LEFT JOIN SubCategories sc ON sc.SubCategoryID = p.SubCategoryID
            GROUP BY c.CategoryName, sc.SubCategoryName
            ORDER BY c.CategoryName, sc.SubCategoryName
        """)
        
        for row in cursor.fetchall():
            print(f"  {row[0]:30} > {row[1]:30} : {row[2]:4} products")
    
    cursor.close()

def main():
    print("Reading Excel data...")
    
    # Read both sheets
    pos_rows = read_excel_data(pos_csv)
    backend_rows = read_excel_data(backend_csv)
    
    print(f"  POS products: {len(pos_rows)}")
    print(f"  Backend products: {len(backend_rows)}")
    
    # Combine
    all_rows = pos_rows + backend_rows
    print(f"  Total products: {len(all_rows)}")
    
    try:
        # Connect to database
        print("\nConnecting to database...")
        conn = pyodbc.connect(conn_str)
        print("  + Connected")
        
        # Update Demo_Retail_Product
        demo_count = update_demo_retail_product(conn, all_rows)
        
        # Update Products (Master)
        master_count = update_products_master(conn, all_rows)
        
        # Verify
        verify_mapping(conn)
        
        conn.close()
        
        print(f"\n{'='*60}")
        print("SUCCESS!")
        print(f"{'='*60}")
        print(f"Demo_Retail_Product: {demo_count} records mapped")
        print(f"Products (Master): {master_count} records mapped")
        print(f"{'='*60}\n")
        
    except Exception as e:
        print(f"\nERROR: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()
