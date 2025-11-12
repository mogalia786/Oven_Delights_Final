# Role-Based Menu Access Control System

## Overview
Comprehensive role-based access control system that allows administrators to control which menus and sub-menus each role can access in the ERP system.

## Components Created

### 1. Database Table: `RoleMenuPermissions`
**File:** `SQL\Create_RoleMenuPermissions.sql`

**Schema:**
- `PermissionID` - Primary key
- `RoleID` - Foreign key to Roles table
- `MenuName` - Main menu name (e.g., "Administration", "Accounting")
- `SubMenuName` - Sub-menu name (NULL for main menu permissions)
- `HasAccess` - Boolean flag (1 = enabled, 0 = disabled/greyed out)
- `CreatedDate`, `ModifiedDate` - Audit timestamps

**Features:**
- Unique constraint on (RoleID, MenuName, SubMenuName)
- Cascade delete when role is deleted
- Indexed for fast lookups
- View `vw_RoleMenuAccess` for easy querying

### 2. Role Access Management Form
**File:** `Forms\RoleAccessManagementForm.vb`

**Features:**
- Professional UI with company branding
- Role dropdown (excludes Super Administrator)
- TreeView with checkboxes showing menu hierarchy
- Real-time permission loading and saving
- Hierarchical checkbox logic:
  - Uncheck main menu → All sub-menus auto-uncheck
  - Check main menu → User can selectively check/uncheck sub-menus

**Menu Structure:**
- **Administration**: User Management, Role Management, Branch Management, System Settings, Audit Log, AI Testing Dashboard
- **Accounting**: Chart of Accounts, General Ledger, Accounts Payable, Accounts Receivable, Bank Reconciliation, Financial Reports, SARS Compliance
- **Manufacturing**: Bill of Materials, Production Orders, Work Orders, Quality Control, Manufacturing Reports
- **Retail**: Products, Customers, Sales, Returns, Retail Reports
- **Inventory**: Stock Management, Purchase Orders, Suppliers, Stock Adjustments, Stock Reports, Inter-Branch Transfers

**Note:** Exit menu is excluded - always accessible to all users

### 3. Runtime Permission Enforcement
**File:** `MainDashboard.vb` (lines 2191-2266)

**Method:** `ApplyRoleBasedMenuPermissions()`

**Features:**
- Called automatically on dashboard load
- Super Administrator bypasses all checks (full access)
- Loads permissions from database for current user's role
- Applies to MenuStrip:
  - Disabled menus → `Enabled = False`, `ForeColor = Gray`
  - Enabled menus → `Enabled = True`, `ForeColor = Black`
- Hierarchical enforcement:
  - If main menu disabled → All sub-menus disabled
  - If main menu enabled → Check individual sub-menu permissions
- Exit menu always remains enabled

## Setup Instructions

### 1. Run SQL Script
```sql
-- Execute this in SQL Server Management Studio
C:\...\SQL\Create_RoleMenuPermissions.sql
```

This will:
- Create `RoleMenuPermissions` table
- Create `vw_RoleMenuAccess` view
- Set default permissions for Super Administrator

### 2. Add Form to Visual Studio
1. Right-click `Forms` folder in Solution Explorer
2. Add → Existing Item
3. Select `Forms\RoleAccessManagementForm.vb`

### 3. Add Menu Item to Administration Menu
In MainDashboard.Designer.vb or through designer:
```vb
' Add to Administration menu
Dim roleAccessMenuItem As New ToolStripMenuItem("Role Access Management")
AddHandler roleAccessMenuItem.Click, AddressOf OpenRoleAccessManagement
AdministrationToolStripMenuItem.DropDownItems.Add(roleAccessMenuItem)
```

Add handler method in MainDashboard.vb:
```vb
Private Sub OpenRoleAccessManagement(sender As Object, e As EventArgs)
    Try
        Dim roleAccessForm As New RoleAccessManagementForm()
        roleAccessForm.MdiParent = Me
        roleAccessForm.Show()
        roleAccessForm.WindowState = FormWindowState.Maximized
    Catch ex As Exception
        MessageBox.Show($"Error opening Role Access Management: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
    End Try
End Sub
```

### 4. Rebuild Solution
- Build → Rebuild Solution

## Usage

### For Administrators:
1. Login as Super Administrator
2. Navigate to: **Administration → Role Access Management**
3. Select a role from dropdown (e.g., "Accountant", "Retail Manager")
4. Check/uncheck menus and sub-menus as needed
5. Click **💾 SAVE PERMISSIONS**
6. Users with that role will see updated access on next login

### For Regular Users:
- Login with assigned role
- Dashboard loads with menus greyed out based on permissions
- Disabled menus cannot be clicked
- Exit menu always available

## Permission Logic

### Checkbox Behavior:
1. **Uncheck Main Menu:**
   - All sub-menus automatically unchecked
   - User cannot access main menu or any sub-menus

2. **Check Main Menu:**
   - User can now selectively check/uncheck sub-menus
   - Only checked sub-menus will be accessible

3. **Save:**
   - All permissions saved to database
   - Applied on user's next login

### Runtime Behavior:
- **Super Administrator:** All menus enabled (no restrictions)
- **Other Roles:** Menus enabled/disabled based on saved permissions
- **Greyed Out Menus:** `Enabled = False`, `ForeColor = Gray`
- **Exit Menu:** Always enabled for all users

## Database Queries

### View all role permissions:
```sql
SELECT * FROM vw_RoleMenuAccess 
ORDER BY RoleName, MenuName, SubMenuName;
```

### Check specific role permissions:
```sql
SELECT MenuName, SubMenuName, HasAccess 
FROM RoleMenuPermissions 
WHERE RoleID = (SELECT RoleID FROM Roles WHERE RoleName = 'Accountant');
```

### Grant full access to a role:
```sql
-- Example: Grant Accountant full access to Accounting menu
INSERT INTO RoleMenuPermissions (RoleID, MenuName, SubMenuName, HasAccess)
SELECT 
    (SELECT RoleID FROM Roles WHERE RoleName = 'Accountant'),
    'Accounting',
    NULL,
    1;
```

## Security Features

✅ **Super Administrator Bypass** - Full access, no restrictions
✅ **Database-Driven** - Permissions stored securely in database
✅ **Cascade Delete** - Permissions auto-deleted when role deleted
✅ **Audit Trail** - CreatedDate and ModifiedDate tracked
✅ **UI Enforcement** - Greyed out menus cannot be clicked
✅ **Exit Always Available** - Users can always logout

## Benefits

✅ **Granular Control** - Control access at menu and sub-menu level
✅ **Easy Management** - Visual tree interface for permission management
✅ **Immediate Effect** - Changes apply on next user login
✅ **Professional UI** - Modern, intuitive interface
✅ **Scalable** - Works with any number of roles and menus
✅ **Secure** - Database-driven, cannot be bypassed in UI

## Notes

- Super Administrator role is excluded from role selection dropdown
- Exit menu is hardcoded to always be accessible
- Permissions are loaded once on dashboard load (not dynamic during session)
- Users must logout and login again to see permission changes
- Menu names must match exactly between form and database (case-insensitive comparison used)
