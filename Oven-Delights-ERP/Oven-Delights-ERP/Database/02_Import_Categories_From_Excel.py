"""
Import Categories and SubCategories from Excel to SQL Server
Maps: Main Category -> Categories
      Sub Category -> SubCategories
"""

import csv
from collections import defaultdict
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

def extract_categories(rows):
    """Extract unique categories and subcategories"""
    categories = {}  # {CategoryName: {subcategories: set(), display_order: int}}
    
    for row in rows:
        main_cat = (row.get('Main Category') or '').strip()
        sub_cat = (row.get('Sub Category') or '').strip()
        
        if main_cat:
            if main_cat not in categories:
                categories[main_cat] = {'subcategories': set(), 'display_order': len(categories) + 1}
            
            if sub_cat:
                categories[main_cat]['subcategories'].add(sub_cat)
    
    return categories

def import_to_database(categories):
    """Import categories and subcategories to SQL Server"""
    try:
        conn = pyodbc.connect(conn_str)
        cursor = conn.cursor()
        
        print(f"\n{'='*60}")
        print("IMPORTING CATEGORIES AND SUBCATEGORIES")
        print(f"{'='*60}\n")
        
        # Create tables if they don't exist and add missing columns
        print("Creating/updating tables...")
        
        # Create Categories table if not exists
        cursor.execute("""
            IF OBJECT_ID('dbo.Categories', 'U') IS NULL
            BEGIN
                CREATE TABLE dbo.Categories (
                    CategoryID      INT IDENTITY(1,1) PRIMARY KEY,
                    CategoryName    NVARCHAR(100) NOT NULL UNIQUE,
                    IsActive        BIT NOT NULL DEFAULT 1,
                    CreatedDate     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
                )
            END
        """)
        
        # Add DisplayOrder column if missing
        cursor.execute("""
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Categories') AND name = 'DisplayOrder')
            BEGIN
                ALTER TABLE Categories ADD DisplayOrder INT NULL
            END
        """)
        
        # Add UpdatedDate column if missing
        cursor.execute("""
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Categories') AND name = 'UpdatedDate')
            BEGIN
                ALTER TABLE Categories ADD UpdatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
            END
        """)
        
        # Create SubCategories table if not exists
        cursor.execute("""
            IF OBJECT_ID('dbo.SubCategories', 'U') IS NULL
            BEGIN
                CREATE TABLE dbo.SubCategories (
                    SubCategoryID   INT IDENTITY(1,1) PRIMARY KEY,
                    CategoryID      INT NOT NULL,
                    SubCategoryName NVARCHAR(100) NOT NULL,
                    IsActive        BIT NOT NULL DEFAULT 1,
                    CreatedDate     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
                    CONSTRAINT FK_SubCategories_Category 
                        FOREIGN KEY (CategoryID) REFERENCES dbo.Categories(CategoryID),
                    CONSTRAINT UQ_SubCategories_Name 
                        UNIQUE (CategoryID, SubCategoryName)
                )
            END
        """)
        
        # Add DisplayOrder column to SubCategories if missing
        cursor.execute("""
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('SubCategories') AND name = 'DisplayOrder')
            BEGIN
                ALTER TABLE SubCategories ADD DisplayOrder INT NULL
            END
        """)
        
        # Add UpdatedDate column to SubCategories if missing
        cursor.execute("""
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('SubCategories') AND name = 'UpdatedDate')
            BEGIN
                ALTER TABLE SubCategories ADD UpdatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
            END
        """)
        
        conn.commit()
        print("  Tables ready\n")
        
        # Import Categories
        print("Importing Categories...")
        category_count = 0
        for cat_name, cat_data in sorted(categories.items()):
            # Check if exists
            cursor.execute("SELECT CategoryID FROM Categories WHERE CategoryName = ?", cat_name)
            existing = cursor.fetchone()
            
            if not existing:
                cursor.execute(
                    "INSERT INTO Categories (CategoryName, DisplayOrder, IsActive) VALUES (?, ?, 1)",
                    cat_name, cat_data['display_order']
                )
                category_count += 1
                print(f"  + {cat_name}")
        
        conn.commit()
        print(f"\n{category_count} categories imported.\n")
        
        # Import SubCategories
        print("Importing SubCategories...")
        subcategory_count = 0
        
        for cat_name, cat_data in sorted(categories.items()):
            # Get CategoryID
            cursor.execute("SELECT CategoryID FROM Categories WHERE CategoryName = ?", cat_name)
            cat_row = cursor.fetchone()
            
            if cat_row:
                category_id = cat_row[0]
                
                for idx, sub_name in enumerate(sorted(cat_data['subcategories']), 1):
                    if sub_name:  # Skip empty subcategories
                        # Check if exists
                        cursor.execute(
                            "SELECT SubCategoryID FROM SubCategories WHERE CategoryID = ? AND SubCategoryName = ?",
                            category_id, sub_name
                        )
                        existing = cursor.fetchone()
                        
                        if not existing:
                            cursor.execute(
                                "INSERT INTO SubCategories (CategoryID, SubCategoryName, DisplayOrder, IsActive) VALUES (?, ?, ?, 1)",
                                category_id, sub_name, idx
                            )
                            subcategory_count += 1
                            print(f"  + {cat_name} > {sub_name}")
        
        conn.commit()
        print(f"\n{subcategory_count} subcategories imported.\n")
        
        # Summary
        print(f"{'='*60}")
        print("SUMMARY")
        print(f"{'='*60}")
        cursor.execute("SELECT COUNT(*) FROM Categories")
        total_cats = cursor.fetchone()[0]
        cursor.execute("SELECT COUNT(*) FROM SubCategories")
        total_subs = cursor.fetchone()[0]
        
        print(f"Total Categories: {total_cats}")
        print(f"Total SubCategories: {total_subs}")
        print(f"{'='*60}\n")
        
        cursor.close()
        conn.close()
        
        return True
        
    except Exception as e:
        print(f"ERROR: {e}")
        import traceback
        traceback.print_exc()
        return False

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
    
    # Extract categories
    print("\nExtracting categories and subcategories...")
    categories = extract_categories(all_rows)
    
    print(f"  Found {len(categories)} main categories")
    total_subs = sum(len(cat['subcategories']) for cat in categories.values())
    print(f"  Found {total_subs} subcategories")
    
    # Show preview
    print("\nPreview:")
    for cat_name in sorted(list(categories.keys())[:5]):
        cat_data = categories[cat_name]
        print(f"  {cat_name} ({len(cat_data['subcategories'])} subcategories)")
        for sub in sorted(list(cat_data['subcategories'])[:3]):
            if sub:
                print(f"    - {sub}")
    
    # Import to database
    print("\nImporting to database...")
    success = import_to_database(categories)
    
    if success:
        print("\nSUCCESS! Categories and SubCategories imported.")
    else:
        print("\nFAILED! Check errors above.")

if __name__ == "__main__":
    main()
