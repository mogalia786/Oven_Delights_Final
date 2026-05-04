# Fix Stockroom BOM Display Issue

## 🔴 PROBLEM
When submitting a BOM request from the new Recipe system, the stockroom fulfillment form shows:
- Only 1 line item instead of all ingredients
- Item name shows as "-" (blank)
- AvailableQty is empty
- RawMaterialID is missing
- Sub-assemblies are not showing

## 🔍 ROOT CAUSE
The stored procedure `sp_MO_CreateBundleFromBOM` is creating the Internal Order but not properly populating the `InternalOrderLines` table with the recipe ingredients.

## 📋 FLOW
1. User creates recipe in "Build My Product" ✅
2. Manager creates re-order book with product ✅
3. Baker clicks "Request BOM" ✅
4. BOMEditorForm calls `ManufacturingService.CreateBundleFromBOM()` ✅
5. Service calls stored procedure `sp_MO_CreateBundleFromBOM` ⚠️
6. Stored procedure creates `InternalOrderHeader` ✅
7. Stored procedure should create `InternalOrderLines` from Recipe ❌ **BROKEN**
8. Stockroom form loads from `InternalOrderLines` ❌ **SHOWS WRONG DATA**

## 🛠️ FIX REQUIRED

The stored procedure `sp_MO_CreateBundleFromBOM` needs to be updated to:

### Current Behavior (OLD):
- Queries `BOMHeader` and `BOMItems` tables
- These tables are from the old node-based system

### Required Behavior (NEW):
- Query `Recipe` and `RecipeIngredient` tables
- Calculate quantities based on `BatchYield`
- Insert into `InternalOrderLines` with proper structure:
  ```sql
  - LineNumber
  - ItemType ('RawMaterial' or 'Finished')
  - RawMaterialID (for raw materials)
  - ProductID (for sub-assemblies)
  - Quantity (calculated from recipe)
  - UoM
  ```

## 📝 SQL FIX

The stored procedure needs to be modified to use this logic:

```sql
-- For each product in the BOM request
FOR EACH @ProductID, @OutputQty IN @Items
BEGIN
    -- Get recipe and batch yield
    SELECT @RecipeID = RecipeID, @BatchYield = BatchYield
    FROM dbo.Recipe
    WHERE ProductID = @ProductID AND IsActive = 1
    
    -- Calculate batches needed
    SET @BatchesNeeded = CEILING(@OutputQty / @BatchYield)
    
    -- Insert ingredients into InternalOrderLines
    INSERT INTO dbo.InternalOrderLines 
    (
        InternalOrderID,
        LineNumber,
        ItemType,
        RawMaterialID,
        ProductID,
        Quantity,
        UoM
    )
    SELECT 
        @InternalOrderID,
        ROW_NUMBER() OVER (ORDER BY ri.LineNumber),
        CASE 
            WHEN ri.IngredientType = 'RawMaterial' THEN 'RawMaterial'
            WHEN ri.IngredientType = 'SubAssembly' THEN 'Finished'
            ELSE 'RawMaterial'
        END,
        ri.MaterialID,
        ri.SubAssemblyProductID,
        ri.Quantity * @BatchesNeeded,  -- Scale by batches needed
        ri.UoM
    FROM dbo.RecipeIngredient ri
    WHERE ri.RecipeID = @RecipeID
    ORDER BY ri.LineNumber
END
```

## 🎯 EXPECTED RESULT

After fix, stockroom form should show:
- ✅ All recipe ingredients (raw materials AND sub-assemblies)
- ✅ Correct item names from RawMaterials or Products table
- ✅ Calculated quantities based on batch yield
- ✅ Available stock quantities from RawMaterials.CurrentStock
- ✅ Proper RawMaterialID for stock checking

## 📍 FILES TO UPDATE

1. **Stored Procedure**: `sp_MO_CreateBundleFromBOM`
   - Location: SQL Server database
   - Action: Rewrite to query Recipe/RecipeIngredient instead of BOMHeader/BOMItems

2. **Alternative**: Update `ManufacturingService.CreateBundleFromBOM()`
   - Location: `Services\ManufacturingService.vb`
   - Action: Add VB.NET code to create InternalOrderLines directly from Recipe

## ⚡ QUICK FIX (VB.NET)

If you want to avoid changing the stored procedure, you can add this code after line 717 in `BOMEditorForm.vb`:

```vb
' After CreateBundleFromBOM call, manually populate InternalOrderLines from Recipe
If ioId > 0 Then
    Using cn As New SqlConnection(cs)
        cn.Open()
        
        ' Get recipe
        Dim sqlRecipe = "SELECT RecipeID, BatchYield FROM dbo.Recipe WHERE ProductID = @pid AND IsActive = 1"
        Using cmdRecipe As New SqlCommand(sqlRecipe, cn)
            cmdRecipe.Parameters.AddWithValue("@pid", pid)
            Using reader = cmdRecipe.ExecuteReader()
                If reader.Read() Then
                    Dim recipeID = reader.GetInt32(0)
                    Dim batchYield = reader.GetDecimal(1)
                    Dim batchesNeeded = Math.Ceiling(qty / batchYield)
                    reader.Close()
                    
                    ' Clear existing lines (if any)
                    Dim sqlClear = "DELETE FROM dbo.InternalOrderLines WHERE InternalOrderID = @ioId"
                    Using cmdClear As New SqlCommand(sqlClear, cn)
                        cmdClear.Parameters.AddWithValue("@ioId", ioId)
                        cmdClear.ExecuteNonQuery()
                    End Using
                    
                    ' Insert ingredients
                    Dim sqlInsert = "INSERT INTO dbo.InternalOrderLines (InternalOrderID, LineNumber, ItemType, RawMaterialID, ProductID, Quantity, UoM) " &
                                   "SELECT @ioId, ROW_NUMBER() OVER (ORDER BY ri.LineNumber), " &
                                   "CASE WHEN ri.IngredientType = 'RawMaterial' THEN 'RawMaterial' WHEN ri.IngredientType = 'SubAssembly' THEN 'Finished' ELSE 'RawMaterial' END, " &
                                   "ri.MaterialID, ri.SubAssemblyProductID, ri.Quantity * @batches, ri.UoM " &
                                   "FROM dbo.RecipeIngredient ri WHERE ri.RecipeID = @recipeID ORDER BY ri.LineNumber"
                    Using cmdInsert As New SqlCommand(sqlInsert, cn)
                        cmdInsert.Parameters.AddWithValue("@ioId", ioId)
                        cmdInsert.Parameters.AddWithValue("@recipeID", recipeID)
                        cmdInsert.Parameters.AddWithValue("@batches", batchesNeeded)
                        cmdInsert.ExecuteNonQuery()
                    End Using
                End If
            End Using
        End Using
    End Using
End If
```

## ✅ TESTING

After applying the fix:
1. Create a recipe with 2+ ingredients
2. Create re-order book with that product
3. Baker requests BOM
4. Open Stockroom → Internal Orders
5. Select the BOM
6. **Verify**: All ingredients show with correct names, quantities, and stock levels

---

**Priority**: HIGH - This blocks the entire stockroom fulfillment workflow!
