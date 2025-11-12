-- EXACT MenuRegistry based on MainDashboard.Designer.vb and MainDashboard.vb
-- This reflects the ACTUAL menu structure in the code

PRINT 'Clearing and rebuilding MenuRegistry from ACTUAL code...';

-- Clear existing data
DELETE FROM RoleMenuPermissions;
DELETE FROM MenuRegistry;

PRINT 'Cleared existing menu data';

-- ========================================
-- ADMINISTRATION MENU (from Designer)
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

PRINT 'Added Administration menu (6 sub-menus)';

-- ========================================
-- STOCKROOM MENU (from Designer)
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

PRINT 'Added Stockroom menu (7 sub-menus)';

-- ========================================
-- MANUFACTURING MENU (from SetupManufacturingMenu)
-- ========================================
INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES ('Manufacturing', NULL, 3, 1);

INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES 
    ('Manufacturing', 'Categories', 1, 1),
    ('Manufacturing', 'Subcategories', 2, 1),
    ('Manufacturing', 'Products', 3, 1),
    ('Manufacturing', 'Add Product', 4, 1),
    ('Manufacturing', 'Recipe Creator', 5, 1),
    ('Manufacturing', 'Build My Product', 6, 1),
    ('Manufacturing', 'Recipe Viewer', 7, 1),
    ('Manufacturing', 'BOM Management', 8, 1),
    ('Manufacturing', 'Complete Build', 9, 1),
    ('Manufacturing', 'MO Actions', 10, 1),
    ('Manufacturing', 'Orders', 11, 1);

PRINT 'Added Manufacturing menu (11 sub-menus)';

-- ========================================
-- RETAIL MENU (from SetupRetailMenus)
-- ========================================
INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES ('Retail', NULL, 4, 1);

INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES 
    ('Retail', 'POS', 1, 1),
    ('Retail', 'Products', 2, 1),
    ('Retail', 'Inventory (Retail Branch)', 3, 1),
    ('Retail', 'Transfers (IBT)', 4, 1),
    ('Retail', 'Purchasing', 5, 1),
    ('Retail', 'Manufacturing (Hand-off)', 6, 1),
    ('Retail', 'Reports', 7, 1),
    ('Retail', 'Accounting', 8, 1),
    ('Retail', 'Settings', 9, 1);

PRINT 'Added Retail menu (9 sub-menus)';

-- ========================================
-- ACCOUNTING MENU (from SetupAccountingMenus)
-- ========================================
INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES ('Accounting', NULL, 5, 1);

INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES 
    ('Accounting', 'Accounts Payable', 1, 1),
    ('Accounting', 'SARS Compliance', 2, 1),
    ('Accounting', 'General Ledger', 3, 1),
    ('Accounting', 'Reports', 4, 1);

PRINT 'Added Accounting menu (4 sub-menus)';

-- ========================================
-- UTILITIES MENU (from SetupUtilitiesMenu)
-- ========================================
INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES ('Utilities', NULL, 6, 1);

INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES 
    ('Utilities', 'Import Categories from CSV', 1, 1),
    ('Utilities', 'Import Products from CSV', 2, 1),
    ('Utilities', 'Import Suppliers from CSV', 3, 1),
    ('Utilities', 'Export Data (CSV)', 4, 1);

PRINT 'Added Utilities menu (4 sub-menus)';

-- ========================================
-- REPORTING MENU (no sub-menus in code)
-- ========================================
INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES ('Reporting', NULL, 7, 1);

PRINT 'Added Reporting menu (no sub-menus)';

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
PRINT '';
PRINT '===========================================';
PRINT 'MENU STRUCTURE SUMMARY:';
PRINT '===========================================';
SELECT 
    MenuName,
    COUNT(CASE WHEN SubMenuName IS NOT NULL THEN 1 END) AS SubMenuCount
FROM MenuRegistry
GROUP BY MenuName, DisplayOrder
ORDER BY DisplayOrder;

PRINT '';
PRINT 'Full menu listing:';
SELECT MenuName, SubMenuName, DisplayOrder 
FROM MenuRegistry 
ORDER BY DisplayOrder, MenuName, 
    CASE WHEN SubMenuName IS NULL THEN 0 ELSE 1 END,
    SubMenuName;

PRINT '';
PRINT '===========================================';
PRINT 'MenuRegistry Synced with ACTUAL Code!';
PRINT '===========================================';
