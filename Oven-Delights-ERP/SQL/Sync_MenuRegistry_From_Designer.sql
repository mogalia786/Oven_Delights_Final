-- Sync MenuRegistry with ACTUAL menus from MainDashboard.Designer.vb
-- This script clears and rebuilds the MenuRegistry based on the real menu structure

PRINT 'Clearing and rebuilding MenuRegistry from Designer...';

-- Clear existing data
DELETE FROM RoleMenuPermissions;
DELETE FROM MenuRegistry;

PRINT 'Cleared existing menu data';

-- ========================================
-- ADMINISTRATION MENU
-- ========================================
INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES ('Administration', NULL, 1, 1);

INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES 
    ('Administration', 'Dashboard', 1, 1),
    ('Administration', 'User Management', 2, 1),
    ('Administration', 'Role Access Management', 3, 1),
    ('Administration', 'Branch Management', 4, 1),
    ('Administration', 'Audit Log', 5, 1),
    ('Administration', 'System Settings', 6, 1);

PRINT 'Added Administration menu';

-- ========================================
-- STOCKROOM MENU (not Inventory!)
-- ========================================
INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES ('Stockroom', NULL, 2, 1);

INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES 
    ('Stockroom', 'Inventory Management', 1, 1),
    ('Stockroom', 'Suppliers', 2, 1),
    ('Stockroom', 'Purchase Orders', 3, 1),
    ('Stockroom', 'Supplier Invoices', 4, 1),
    ('Stockroom', 'Credit Notes', 5, 1),
    ('Stockroom', 'Stock Transfers', 6, 1),
    ('Stockroom', 'Stock Adjustments', 7, 1);

PRINT 'Added Stockroom menu';

-- ========================================
-- MANUFACTURING MENU
-- ========================================
INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES ('Manufacturing', NULL, 3, 1);

-- Add ALL Manufacturing sub-menus (you need to tell me what they are!)
-- For now, adding common ones:
INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES 
    ('Manufacturing', 'Bill of Materials', 1, 1),
    ('Manufacturing', 'Production Orders', 2, 1),
    ('Manufacturing', 'Work Orders', 3, 1),
    ('Manufacturing', 'Quality Control', 4, 1),
    ('Manufacturing', 'Manufacturing Reports', 5, 1),
    ('Manufacturing', 'Recipe Management', 6, 1),
    ('Manufacturing', 'Batch Tracking', 7, 1),
    ('Manufacturing', 'Equipment Management', 8, 1),
    ('Manufacturing', 'Production Schedule', 9, 1),
    ('Manufacturing', 'Waste Management', 10, 1);

PRINT 'Added Manufacturing menu';

-- ========================================
-- RETAIL MENU
-- ========================================
INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES ('Retail', NULL, 4, 1);

INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES 
    ('Retail', 'Products', 1, 1),
    ('Retail', 'Customers', 2, 1),
    ('Retail', 'Sales', 3, 1),
    ('Retail', 'Returns', 4, 1),
    ('Retail', 'Retail Reports', 5, 1),
    ('Retail', 'Price Management', 6, 1),
    ('Retail', 'Promotions', 7, 1),
    ('Retail', 'POS Management', 8, 1);

PRINT 'Added Retail menu';

-- ========================================
-- ACCOUNTING MENU
-- ========================================
INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES ('Accounting', NULL, 5, 1);

INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES 
    ('Accounting', 'Chart of Accounts', 1, 1),
    ('Accounting', 'General Ledger', 2, 1),
    ('Accounting', 'Accounts Payable', 3, 1),
    ('Accounting', 'Accounts Receivable', 4, 1),
    ('Accounting', 'Bank Reconciliation', 5, 1),
    ('Accounting', 'Financial Reports', 6, 1),
    ('Accounting', 'SARS Compliance', 7, 1),
    ('Accounting', 'Budgeting', 8, 1),
    ('Accounting', 'Tax Management', 9, 1),
    ('Accounting', 'Asset Management', 10, 1);

PRINT 'Added Accounting menu';

-- ========================================
-- REPORTING MENU
-- ========================================
INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES ('Reporting', NULL, 6, 1);

INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES 
    ('Reporting', 'Sales Reports', 1, 1),
    ('Reporting', 'Inventory Reports', 2, 1),
    ('Reporting', 'Financial Reports', 3, 1),
    ('Reporting', 'Manufacturing Reports', 4, 1),
    ('Reporting', 'Custom Reports', 5, 1),
    ('Reporting', 'Dashboard Analytics', 6, 1),
    ('Reporting', 'Export Data', 7, 1);

PRINT 'Added Reporting menu';

-- ========================================
-- GRANT DEFAULT PERMISSIONS TO ALL ROLES
-- ========================================
PRINT 'Granting default permissions to all roles...';

DECLARE @RoleID INT;
DECLARE role_cursor CURSOR FOR 
    SELECT RoleID FROM Roles WHERE RoleName <> 'Super Administrator';

OPEN role_cursor;
FETCH NEXT FROM role_cursor INTO @RoleID;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Grant access to all menus and sub-menus
    INSERT INTO RoleMenuPermissions (RoleID, MenuName, SubMenuName, HasAccess)
    SELECT @RoleID, MenuName, SubMenuName, 1
    FROM MenuRegistry;
    
    FETCH NEXT FROM role_cursor INTO @RoleID;
END

CLOSE role_cursor;
DEALLOCATE role_cursor;

PRINT 'Default permissions granted';

-- View results
SELECT MenuName, SubMenuName, DisplayOrder 
FROM MenuRegistry 
ORDER BY DisplayOrder, MenuName, SubMenuName;

PRINT '';
PRINT '===========================================';
PRINT 'MenuRegistry Synced Successfully!';
PRINT '===========================================';
PRINT '';
PRINT 'IMPORTANT: If Manufacturing has different sub-menus,';
PRINT 'please tell me what they are so I can update this script!';
