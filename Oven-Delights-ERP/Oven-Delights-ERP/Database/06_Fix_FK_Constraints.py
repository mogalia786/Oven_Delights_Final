"""
Fix Foreign Key Constraints
Drop old FK pointing to ProductCategories, create new FK pointing to Categories
"""

import pyodbc

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

def fix_constraints():
    try:
        conn = pyodbc.connect(conn_str)
        cursor = conn.cursor()
        
        print("\n" + "="*60)
        print("FIXING FOREIGN KEY CONSTRAINTS")
        print("="*60 + "\n")
        
        # Step 1: Drop old FK constraints on Demo_Retail_Product
        print("Step 1: Dropping old FK constraints...")
        
        cursor.execute("""
            IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Demo_Retail_Product_CategoryID')
            BEGIN
                ALTER TABLE Demo_Retail_Product DROP CONSTRAINT FK_Demo_Retail_Product_CategoryID
                PRINT '  - Dropped FK_Demo_Retail_Product_CategoryID'
            END
        """)
        
        cursor.execute("""
            IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Demo_Retail_Product_Category')
            BEGIN
                ALTER TABLE Demo_Retail_Product DROP CONSTRAINT FK_Demo_Retail_Product_Category
                PRINT '  - Dropped FK_Demo_Retail_Product_Category'
            END
        """)
        
        cursor.execute("""
            IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Demo_Retail_Product_SubCategory')
            BEGIN
                ALTER TABLE Demo_Retail_Product DROP CONSTRAINT FK_Demo_Retail_Product_SubCategory
                PRINT '  - Dropped FK_Demo_Retail_Product_SubCategory'
            END
        """)
        
        conn.commit()
        print("  + Old constraints dropped\n")
        
        # Step 2: Create new FK constraints pointing to Categories/SubCategories
        print("Step 2: Creating new FK constraints...")
        
        cursor.execute("""
            IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Demo_Retail_Product_Categories_New')
            BEGIN
                ALTER TABLE Demo_Retail_Product
                ADD CONSTRAINT FK_Demo_Retail_Product_Categories_New
                FOREIGN KEY (CategoryID) REFERENCES dbo.Categories(CategoryID)
                PRINT '  + Created FK to Categories'
            END
        """)
        
        cursor.execute("""
            IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Demo_Retail_Product_SubCategories_New')
            BEGIN
                ALTER TABLE Demo_Retail_Product
                ADD CONSTRAINT FK_Demo_Retail_Product_SubCategories_New
                FOREIGN KEY (SubCategoryID) REFERENCES dbo.SubCategories(SubCategoryID)
                PRINT '  + Created FK to SubCategories'
            END
        """)
        
        conn.commit()
        print("  + New constraints created\n")
        
        # Step 5: Verify
        print("Step 5: Verifying constraints...")
        cursor.execute("""
            SELECT 
                fk.name AS ConstraintName,
                OBJECT_NAME(fk.parent_object_id) AS TableName,
                COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ColumnName,
                OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable,
                COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ReferencedColumn
            FROM sys.foreign_keys fk
            INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
            WHERE OBJECT_NAME(fk.parent_object_id) = 'Demo_Retail_Product'
                AND COL_NAME(fkc.parent_object_id, fkc.parent_column_id) IN ('CategoryID', 'SubCategoryID')
        """)
        
        for row in cursor.fetchall():
            print(f"  {row[0]}: {row[1]}.{row[2]} -> {row[3]}.{row[4]}")
        
        cursor.close()
        conn.close()
        
        print("\n" + "="*60)
        print("SUCCESS! FK Constraints Fixed")
        print("="*60 + "\n")
        
        return True
        
    except Exception as e:
        print(f"\nERROR: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    fix_constraints()
