# PO AND BAKER ISSUES - DIAGNOSIS & FIX

## Issue 1: LastPaidPrice Not Showing in PO

### Current Implementation
The PO form **ALREADY HAS** LastPaidPrice functionality:
- `PurchaseOrderForm.vb` line 432: Fetches LastPaidPrice from GRN
- `StockroomService.GetLastPaidPrice()`: Queries GoodsReceivedNotes for last price paid to supplier
- Automatically populates UnitCost field if empty

### How It Works
```vb
' When you select a material in PO:
1. System queries: SELECT TOP 1 UnitCost FROM GRNLines 
   WHERE SupplierID = @supplier AND MaterialID = @material
   ORDER BY ReceivedDate DESC
2. Populates "Last Paid" column (read-only, gray text)
3. If UnitCost is empty, auto-fills it with LastPaidPrice
```

### Why It Might Not Be Working

#### Scenario A: No Previous GRN for This Supplier+Material
If you've never received this material from this supplier before, LastPaidPrice will be 0.

**Check:**
```sql
-- See if you have GRN history for a material:
SELECT 
    g.GRNID,
    g.GRNNumber,
    g.SupplierID,
    s.CompanyName AS SupplierName,
    gl.MaterialID,
    rm.MaterialName,
    gl.UnitCost AS LastPaidPrice,
    g.ReceivedDate
FROM GoodsReceivedNotes g
INNER JOIN GRNLines gl ON gl.GRNID = g.GRNID
INNER JOIN RawMaterials rm ON rm.MaterialID = gl.MaterialID
LEFT JOIN Suppliers s ON s.SupplierID = g.SupplierID
WHERE gl.MaterialID = <YOUR_MATERIAL_ID>  -- Replace with actual ID
  AND g.SupplierID = <YOUR_SUPPLIER_ID>   -- Replace with actual ID
ORDER BY g.ReceivedDate DESC;
```

#### Scenario B: LastPaidPrice Column Not Visible
The column might be hidden or scrolled off-screen.

**Check:**
- Scroll right in the PO grid
- Look for "Last Paid" column (gray text, read-only)
- It's between "Est. Unit Price" and "Last Cost"

#### Scenario C: Products vs Raw Materials
LastPaidPrice works for **Raw Materials** only. For **Products**, it uses `Products.LastPaidPrice` column.

**Check:**
```sql
-- For Products:
SELECT 
    ProductID,
    ProductName,
    ItemType,
    LastPaidPrice,
    AverageCost
FROM Products
WHERE ProductID = <YOUR_PRODUCT_ID>;
```

### Solution

#### If No GRN History:
The system is working correctly - there's no history to show. After you receive goods via GRN, future POs will show the last paid price.

#### If Column Hidden:
Resize or scroll the grid to see the "Last Paid" column.

#### If You Want to Set Initial Prices:
Update RawMaterials or Products table:
```sql
-- For Raw Materials:
UPDATE RawMaterials 
SET LastPaidPrice = <PRICE>, 
    LastCost = <PRICE>
WHERE MaterialID = <ID>;

-- For Products:
UPDATE Products 
SET LastPaidPrice = <PRICE>, 
    AverageCost = <PRICE>
WHERE ProductID = <ID>;
```

---

## Issue 2: Baker "Muhammmad Mall" Not Appearing

### Diagnosis Steps

Run this diagnostic script:
```sql
SQL\CHECK_BAKER_ISSUE.sql
```

This will check:
1. Does the user exist?
2. Is the name spelled correctly?
3. Is the user active (IsActive = 1)?
4. Does the user have the Manufacturer role?
5. Is the user in the correct branch?

### Common Causes

#### Cause 1: User Not Active
```sql
-- Check if user is inactive:
SELECT UserID, FirstName, LastName, IsActive
FROM Users
WHERE (FirstName LIKE '%Muhammad%' OR LastName LIKE '%Mall%');

-- If IsActive = 0, activate the user:
UPDATE Users 
SET IsActive = 1 
WHERE UserID = <ID>;
```

#### Cause 2: Wrong Role
```sql
-- Check user's role:
SELECT 
    u.UserID,
    u.FirstName + ' ' + u.LastName AS FullName,
    r.RoleName,
    u.IsActive
FROM Users u
INNER JOIN Roles r ON r.RoleID = u.RoleID
WHERE (u.FirstName LIKE '%Muhammad%' OR u.LastName LIKE '%Mall%');

-- If not Manufacturer, assign the role:
UPDATE Users 
SET RoleID = (SELECT RoleID FROM Roles WHERE RoleName = 'Manufacturer')
WHERE UserID = <ID>;
```

#### Cause 3: Name Spelling
The query in forms uses:
```vb
SELECT UserID, FirstName + ' ' + LastName AS FullName 
FROM Users 
WHERE RoleID IN (SELECT RoleID FROM Roles WHERE RoleName = 'Manufacturer') 
  AND IsActive = 1 
ORDER BY FirstName
```

Check exact spelling in database:
```sql
-- List all manufacturers:
SELECT 
    UserID,
    FirstName,
    LastName,
    FirstName + ' ' + LastName AS FullName,
    IsActive
FROM Users
WHERE RoleID = (SELECT RoleID FROM Roles WHERE RoleName = 'Manufacturer')
ORDER BY FirstName, LastName;
```

#### Cause 4: Branch Filter (for some forms)
Some forms filter by branch. Check if user is in the correct branch:
```sql
SELECT 
    UserID,
    FirstName + ' ' + LastName AS FullName,
    BranchID,
    IsActive
FROM Users
WHERE (FirstName LIKE '%Muhammad%' OR LastName LIKE '%Mall%');
```

### Quick Fix

If you find the user but they're not appearing:

```sql
-- 1. Activate user
UPDATE Users SET IsActive = 1 WHERE UserID = <ID>;

-- 2. Assign Manufacturer role
UPDATE Users 
SET RoleID = (SELECT RoleID FROM Roles WHERE RoleName = 'Manufacturer')
WHERE UserID = <ID>;

-- 3. Verify
SELECT 
    u.UserID,
    u.FirstName + ' ' + u.LastName AS FullName,
    r.RoleName,
    u.IsActive,
    u.BranchID
FROM Users u
INNER JOIN Roles r ON r.RoleID = u.RoleID
WHERE u.UserID = <ID>;
```

---

## Testing Checklist

### Test LastPaidPrice in PO:
1. Create a new Purchase Order
2. Select a supplier
3. Add a material that you've received before
4. Check "Last Paid" column - should show previous price
5. If "Est. Unit Price" is empty, it should auto-fill with last paid price

### Test Baker Appearing:
1. Run `CHECK_BAKER_ISSUE.sql`
2. Verify user exists and is active
3. Verify user has Manufacturer role
4. Open Re-Order Book Manager
5. Check baker dropdown - "Muhammmad Mall" should appear
6. Open Baker Production View
7. User should be able to log in as this baker

---

## Summary

### LastPaidPrice:
- ✅ Already implemented in PO form
- ✅ Fetches from GRN history
- ✅ Auto-fills UnitCost if empty
- ⚠️ Only works if you have GRN history for that supplier+material

### Baker Not Appearing:
- Run `CHECK_BAKER_ISSUE.sql` to diagnose
- Most likely: User is inactive OR doesn't have Manufacturer role
- Fix: Activate user and assign correct role
