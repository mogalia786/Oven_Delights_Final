# BRANCH-SPECIFIC MATERIALS - FINAL FIX

## THE REAL ISSUE (NOW UNDERSTOOD!)

The MaterialCode has a **BRANCH PREFIX**:
- **AC-** = Ayesha Centre materials
- **UM-** = Umhlanga materials
- Each branch has its own set of materials

**PROBLEM:** The "Add Components" dialog was showing ALL materials from ALL branches, not just the current branch's materials!

## THE SOLUTION

### RawMaterialSelectorDialog.vb - LoadMaterials Method

**BEFORE:**
```vb
Dim sql = "SELECT ... FROM dbo.RawMaterials rm WHERE rm.IsActive = 1"
' Shows ALL materials regardless of branch
```

**AFTER:**
```vb
' Get current branch prefix
Dim branchPrefix As String = ""
Dim currentBranchId As Integer = AppSession.CurrentBranchID
Using cmdPrefix As New SqlCommand("SELECT BranchPrefix FROM Branches WHERE BranchID = @bid", cn)
    branchPrefix = Convert.ToString(cmdPrefix.ExecuteScalar())
End Using

' Filter by branch prefix
Dim sql = "SELECT ... FROM dbo.RawMaterials rm WHERE rm.IsActive = 1"
If Not String.IsNullOrEmpty(branchPrefix) Then
    sql &= " AND rm.MaterialCode LIKE @prefix"  ' e.g., 'AC-%'
End If
```

## HOW IT WORKS NOW

1. **User logs into Ayesha Centre** (BranchID = 1)
   - System gets BranchPrefix = 'AC'
   - Dialog shows ONLY materials where MaterialCode starts with 'AC-'
   - Examples: AC-FLOUR, AC-SUGAR, AC-DOUGH-MIX

2. **User logs into Umhlanga** (BranchID = 2)
   - System gets BranchPrefix = 'UM'
   - Dialog shows ONLY materials where MaterialCode starts with 'UM-'
   - Examples: UM-FLOUR, UM-SUGAR, UM-DOUGH-MIX

3. **No Distinction Between Types**
   - Raw materials and sub-recipes are treated EXACTLY the same
   - Both use MaterialCode with branch prefix
   - Both stored in same RawMaterials table
   - Both filtered by same branch prefix logic

## DATABASE REQUIREMENTS

### Branches Table Must Have:
```sql
CREATE TABLE Branches (
    BranchID INT PRIMARY KEY,
    BranchName NVARCHAR(100),
    BranchPrefix NVARCHAR(10),  -- 'AC', 'UM', etc.
    ...
)
```

### RawMaterials Table Structure:
```sql
CREATE TABLE RawMaterials (
    MaterialID INT PRIMARY KEY,
    MaterialCode NVARCHAR(50),  -- Format: 'AC-FLOUR', 'UM-SUGAR', etc.
    MaterialName NVARCHAR(200),
    MaterialType NVARCHAR(50),  -- 'Raw', 'Sub Recipe', 'Ingredient'
    IsActive BIT,
    ...
)
```

### Example Data:
```sql
-- Ayesha Centre Materials
INSERT INTO RawMaterials (MaterialCode, MaterialName, MaterialType)
VALUES 
    ('AC-FLOUR', 'Flour', 'Raw'),
    ('AC-SUGAR', 'Sugar', 'Raw'),
    ('AC-DOUGH-MIX', 'Dough Mix', 'Sub Recipe')

-- Umhlanga Materials  
INSERT INTO RawMaterials (MaterialCode, MaterialName, MaterialType)
VALUES 
    ('UM-FLOUR', 'Flour', 'Raw'),
    ('UM-SUGAR', 'Sugar', 'Raw'),
    ('UM-DOUGH-MIX', 'Dough Mix', 'Sub Recipe')
```

## BENEFITS

1. **Branch Isolation** - Each branch only sees their own materials
2. **No Confusion** - Users don't see materials from other branches
3. **Simplified UI** - No need to distinguish between raw materials and sub-recipes
4. **Consistent Naming** - MaterialCode prefix makes branch ownership clear
5. **Scalable** - Easy to add new branches with new prefixes

## TESTING

1. **Login to Ayesha Centre**
   - Open Recipe Builder
   - Click "Add Components"
   - Verify ONLY materials starting with 'AC-' appear

2. **Login to Umhlanga**
   - Open Recipe Builder
   - Click "Add Components"
   - Verify ONLY materials starting with 'UM-' appear

3. **Check Both Types Show**
   - Verify both raw materials (Flour, Sugar) AND sub-recipes (Dough Mix) appear
   - Verify MaterialType column shows the type

## SQL TO VERIFY BRANCH PREFIXES

```sql
-- Check if Branches table has BranchPrefix column
SELECT 
    BranchID,
    BranchName,
    BranchPrefix
FROM Branches
ORDER BY BranchID

-- Check MaterialCode format in RawMaterials
SELECT 
    LEFT(MaterialCode, CHARINDEX('-', MaterialCode + '-') - 1) AS Prefix,
    COUNT(*) AS Count
FROM RawMaterials
WHERE IsActive = 1
GROUP BY LEFT(MaterialCode, CHARINDEX('-', MaterialCode + '-') - 1)
ORDER BY Prefix

-- Show materials by branch prefix
SELECT 
    CASE 
        WHEN MaterialCode LIKE 'AC-%' THEN 'Ayesha Centre'
        WHEN MaterialCode LIKE 'UM-%' THEN 'Umhlanga'
        ELSE 'Unknown Branch'
    END AS Branch,
    MaterialType,
    COUNT(*) AS Count
FROM RawMaterials
WHERE IsActive = 1
GROUP BY 
    CASE 
        WHEN MaterialCode LIKE 'AC-%' THEN 'Ayesha Centre'
        WHEN MaterialCode LIKE 'UM-%' THEN 'Umhlanga'
        ELSE 'Unknown Branch'
    END,
    MaterialType
ORDER BY Branch, MaterialType
```

## IMPORTANT NOTES

1. **BranchPrefix is REQUIRED** - If Branches table doesn't have this column, add it:
   ```sql
   ALTER TABLE Branches ADD BranchPrefix NVARCHAR(10)
   UPDATE Branches SET BranchPrefix = 'AC' WHERE BranchName LIKE '%Ayesha%'
   UPDATE Branches SET BranchPrefix = 'UM' WHERE BranchName LIKE '%Umhlanga%'
   ```

2. **MaterialCode Format** - Must follow pattern: `PREFIX-NAME`
   - Correct: `AC-FLOUR`, `UM-SUGAR`
   - Wrong: `ACFLOUR`, `Flour-AC`

3. **No Type Distinction** - System treats all materials the same:
   - Raw materials and sub-recipes both use same prefix
   - Both filtered by same logic
   - Both stored in same table
   - MaterialType column is for information only, not filtering

4. **StockroomStock Table** - Also uses branch-specific logic:
   - Each material has stock per branch
   - Uses BranchID for filtering
   - MaterialCode prefix ensures correct materials per branch
