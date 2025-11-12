# Menu Registry System - Dynamic Menu Management

## Overview
**Problem Solved:** Previously, adding new menus required updating hardcoded dictionaries in the code. Now, all menus are stored in a database table (`MenuRegistry`), making menu management dynamic and database-driven.

## Architecture

### **Central Menu Registry**
All menus and sub-menus are stored in the `MenuRegistry` table, which serves as the **single source of truth** for the entire system.

```
MenuRegistry Table
    ↓
RoleAccessManagementForm (reads menus)
    ↓
RoleMenuPermissions (stores role permissions)
    ↓
MainDashboard (applies permissions at runtime)
```

## Components

### 1. MenuRegistry Table
**File:** `SQL\Create_MenuRegistry.sql`

**Schema:**
```sql
MenuRegistry (
    MenuID INT PRIMARY KEY,
    MenuName NVARCHAR(100) NOT NULL,
    SubMenuName NVARCHAR(100) NULL,  -- NULL = main menu
    DisplayOrder INT DEFAULT 0,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME,
    ModifiedDate DATETIME
)
```

**Features:**
- Stores all menus and sub-menus
- DisplayOrder controls menu ordering
- IsActive flag for soft delete
- Unique constraint on (MenuName, SubMenuName)

### 2. Stored Procedure: sp_AddMenu
**Purpose:** Safely add new menus with automatic permission creation

**Parameters:**
- `@MenuName` - Main menu name (required)
- `@SubMenuName` - Sub-menu name (optional, NULL for main menu)
- `@DisplayOrder` - Sort order (default 0)
- `@GrantToAllRoles` - Auto-create permissions for all roles (default 1)

**Usage:**
```sql
-- Add main menu
EXEC sp_AddMenu @MenuName = 'Reports', @DisplayOrder = 6;

-- Add sub-menu
EXEC sp_AddMenu 
    @MenuName = 'Reports', 
    @SubMenuName = 'Sales Report', 
    @DisplayOrder = 1,
    @GrantToAllRoles = 1;
```

### 3. AddMenuDialog Form
**File:** `Forms\AddMenuDialog.vb`

**Features:**
- Simple dialog for adding menus
- Fields: Menu Name, Sub-Menu Name, Display Order
- Checkbox: "Grant access to all roles by default"
- Calls `sp_AddMenu` stored procedure
- Validates input before submission

### 4. Updated RoleAccessManagementForm
**File:** `Forms\RoleAccessManagementForm.vb`

**Changes:**
- `LoadMenuHierarchy()` now reads from `MenuRegistry` table
- Added "➕ ADD MENU" button
- TreeView automatically refreshes after adding menu
- No more hardcoded menu structure!

## Workflow

### **Adding a New Menu (UI Method)**

1. **Open Role Access Management**
   - Administration → Role Access Management

2. **Click "➕ ADD MENU" button**

3. **Fill in the form:**
   - **Main Menu Name:** e.g., "Reports"
   - **Sub-Menu Name:** (leave blank for main menu, or enter "Sales Report")
   - **Display Order:** 1, 2, 3, etc.
   - **Grant to all roles:** ✓ (checked by default)

4. **Click "✓ ADD MENU"**

5. **Result:**
   - Menu added to `MenuRegistry` table
   - Permissions auto-created for all roles (if checked)
   - TreeView refreshes immediately
   - Menu appears in MainDashboard on next login

### **Adding a New Menu (SQL Method)**

```sql
-- Step 1: Add main menu
EXEC sp_AddMenu 
    @MenuName = 'Reports', 
    @SubMenuName = NULL, 
    @DisplayOrder = 6,
    @GrantToAllRoles = 1;

-- Step 2: Add sub-menus
EXEC sp_AddMenu @MenuName = 'Reports', @SubMenuName = 'Sales Report', @DisplayOrder = 1;
EXEC sp_AddMenu @MenuName = 'Reports', @SubMenuName = 'Inventory Report', @DisplayOrder = 2;
EXEC sp_AddMenu @MenuName = 'Reports', @SubMenuName = 'Financial Report', @DisplayOrder = 3;
```

### **Adding Menu in Code (MainDashboard)**

When you add a menu item to `MainDashboard.Designer.vb`:

```vb
' Add to MenuStrip
Dim reportsMenu As New ToolStripMenuItem("Reports")
Me.MenuStrip1.Items.Add(reportsMenu)

' Add sub-menus
reportsMenu.DropDownItems.Add("Sales Report")
reportsMenu.DropDownItems.Add("Inventory Report")
```

**Then register it in database:**
```sql
EXEC sp_AddMenu @MenuName = 'Reports', @SubMenuName = NULL;
EXEC sp_AddMenu @MenuName = 'Reports', @SubMenuName = 'Sales Report';
EXEC sp_AddMenu @MenuName = 'Reports', @SubMenuName = 'Inventory Report';
```

**Or use the UI:** Click "➕ ADD MENU" button in Role Access Management

## Setup Instructions

### 1. Run SQL Scripts (in order)
```sql
-- First: Create RoleMenuPermissions table
C:\...\SQL\Create_RoleMenuPermissions.sql

-- Second: Create MenuRegistry table
C:\...\SQL\Create_MenuRegistry.sql
```

### 2. Add Forms to Visual Studio
1. Right-click `Forms` folder
2. Add → Existing Item
3. Select:
   - `Forms\RoleAccessManagementForm.vb`
   - `Forms\AddMenuDialog.vb`

### 3. Rebuild Solution

## Database Queries

### View all registered menus:
```sql
SELECT * FROM vw_MenuStructure 
ORDER BY MenuName, DisplayOrder;
```

### View menu permissions by role:
```sql
SELECT 
    r.RoleName,
    mr.MenuName,
    mr.SubMenuName,
    ISNULL(rmp.HasAccess, 1) AS HasAccess
FROM MenuRegistry mr
CROSS JOIN Roles r
LEFT JOIN RoleMenuPermissions rmp 
    ON r.RoleID = rmp.RoleID 
    AND mr.MenuName = rmp.MenuName 
    AND (mr.SubMenuName = rmp.SubMenuName OR (mr.SubMenuName IS NULL AND rmp.SubMenuName IS NULL))
WHERE r.RoleName <> 'Super Administrator'
ORDER BY r.RoleName, mr.MenuName, mr.DisplayOrder;
```

### Add menu with SQL:
```sql
EXEC sp_AddMenu 
    @MenuName = 'YourMenu', 
    @SubMenuName = 'Your Sub-Menu', 
    @DisplayOrder = 1,
    @GrantToAllRoles = 1;
```

### Deactivate a menu (soft delete):
```sql
UPDATE MenuRegistry 
SET IsActive = 0 
WHERE MenuName = 'OldMenu';
```

### Reorder menus:
```sql
UPDATE MenuRegistry 
SET DisplayOrder = 10 
WHERE MenuName = 'Reports' AND SubMenuName IS NULL;
```

## Benefits

✅ **No Code Changes** - Add menus without recompiling
✅ **Database-Driven** - Single source of truth
✅ **Auto-Permissions** - Optionally grant access to all roles
✅ **Easy Management** - UI dialog for adding menus
✅ **Flexible Ordering** - Control menu display order
✅ **Soft Delete** - Deactivate menus without losing data
✅ **Audit Trail** - CreatedDate and ModifiedDate tracked

## Comparison: Before vs After

### **Before (Hardcoded):**
```vb
' Had to update code every time
Dim menus As New Dictionary(Of String, List(Of String)) From {
    {"Administration", New List(Of String) From {"User Management", "Role Management"}},
    {"Accounting", New List(Of String) From {"Chart of Accounts", "General Ledger"}}
}
```
❌ Required code changes
❌ Required recompilation
❌ Required redeployment

### **After (Database-Driven):**
```sql
-- Just run SQL or use UI
EXEC sp_AddMenu @MenuName = 'NewMenu', @SubMenuName = 'New Sub-Menu';
```
✅ No code changes
✅ No recompilation
✅ Immediate effect

## Security

✅ **Super Administrator Bypass** - Always has full access
✅ **Transaction Safety** - Menu + permissions created atomically
✅ **Unique Constraints** - Prevents duplicate menus
✅ **Soft Delete** - Can reactivate menus if needed
✅ **Audit Trail** - Tracks when menus were created/modified

## Future Enhancements

Possible additions:
- Menu icons stored in database
- Menu descriptions/tooltips
- Menu categories/groups
- Menu visibility rules (beyond just permissions)
- Menu shortcuts/hotkeys
- Multi-language menu names

## Troubleshooting

### Menu not appearing in TreeView?
```sql
-- Check if menu is active
SELECT * FROM MenuRegistry WHERE MenuName = 'YourMenu';

-- Ensure IsActive = 1
UPDATE MenuRegistry SET IsActive = 1 WHERE MenuName = 'YourMenu';
```

### Menu greyed out for all roles?
```sql
-- Check permissions
SELECT * FROM RoleMenuPermissions WHERE MenuName = 'YourMenu';

-- Grant access to specific role
INSERT INTO RoleMenuPermissions (RoleID, MenuName, SubMenuName, HasAccess)
VALUES (2, 'YourMenu', NULL, 1);
```

### Menu order wrong?
```sql
-- Update display order
UPDATE MenuRegistry 
SET DisplayOrder = 5 
WHERE MenuName = 'YourMenu' AND SubMenuName = 'YourSubMenu';
```

## Notes

- Menu names must match **exactly** between `MenuRegistry` and `MainDashboard.Designer.vb`
- Use `&` in menu names for keyboard shortcuts (e.g., "&File" → Alt+F)
- DisplayOrder is per-menu (not global)
- Super Administrator is excluded from permission management
- Exit menu is hardcoded to always be accessible
