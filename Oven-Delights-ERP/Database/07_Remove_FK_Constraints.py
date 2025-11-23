"""
Remove FK Constraints - Work without them
CategoryID and SubCategoryID will work as simple lookup fields
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

def remove_all_fk_constraints():
    try:
        conn = pyodbc.connect(conn_str)
        cursor = conn.cursor()
        
        print("\n" + "="*60)
        print("REMOVING ALL FK CONSTRAINTS ON CategoryID/SubCategoryID")
        print("="*60 + "\n")
        
        print("Removing FK constraints from Demo_Retail_Product...")
        
        # Get all FK constraints on Demo_Retail_Product related to CategoryID/SubCategoryID
        cursor.execute("""
            SELECT fk.name
            FROM sys.foreign_keys fk
            INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
            WHERE OBJECT_NAME(fk.parent_object_id) = 'Demo_Retail_Product'
                AND COL_NAME(fkc.parent_object_id, fkc.parent_column_id) IN ('CategoryID', 'SubCategoryID')
        """)
        
        constraints = [row[0] for row in cursor.fetchall()]
        
        for constraint_name in constraints:
            try:
                cursor.execute(f"ALTER TABLE Demo_Retail_Product DROP CONSTRAINT [{constraint_name}]")
                print(f"  - Dropped {constraint_name}")
            except Exception as e:
                print(f"  ! Error dropping {constraint_name}: {e}")
        
        conn.commit()
        
        if constraints:
            print(f"\n  + Removed {len(constraints)} FK constraints")
        else:
            print("  + No FK constraints found")
        
        # Do the same for Products table if it exists
        cursor.execute("SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Products'")
        if cursor.fetchone()[0] > 0:
            print("\nRemoving FK constraints from Products...")
            
            cursor.execute("""
                SELECT fk.name
                FROM sys.foreign_keys fk
                INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
                WHERE OBJECT_NAME(fk.parent_object_id) = 'Products'
                    AND COL_NAME(fkc.parent_object_id, fkc.parent_column_id) IN ('CategoryID', 'SubCategoryID')
            """)
            
            constraints = [row[0] for row in cursor.fetchall()]
            
            for constraint_name in constraints:
                try:
                    cursor.execute(f"ALTER TABLE Products DROP CONSTRAINT [{constraint_name}]")
                    print(f"  - Dropped {constraint_name}")
                except Exception as e:
                    print(f"  ! Error dropping {constraint_name}: {e}")
            
            conn.commit()
            
            if constraints:
                print(f"\n  + Removed {len(constraints)} FK constraints from Products")
            else:
                print("  + No FK constraints found on Products")
        
        cursor.close()
        conn.close()
        
        print("\n" + "="*60)
        print("SUCCESS! All FK Constraints Removed")
        print("CategoryID and SubCategoryID now work as simple lookup fields")
        print("="*60 + "\n")
        
        return True
        
    except Exception as e:
        print(f"\nERROR: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    remove_all_fk_constraints()
