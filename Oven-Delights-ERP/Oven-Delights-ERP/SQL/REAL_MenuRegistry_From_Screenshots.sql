-- REAL MenuRegistry based on ACTUAL screenshots of running application
-- This reflects the TRUE menu structure

PRINT 'Clearing and rebuilding MenuRegistry from ACTUAL application...';

-- Clear existing data
DELETE FROM RoleMenuPermissions;
DELETE FROM MenuRegistry;

PRINT 'Cleared existing menu data';

-- ========================================
-- ADMINISTRATION MENU (7 sub-menus)
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
    ('Administration', 'System Settings', 6, 1),
    ('Administration', 'AI Testing Dashboard', 7, 1);

PRINT 'Added Administration menu (7 sub-menus)';

-- ========================================
-- STOCKROOM MENU (13 sub-menus)
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
    ('Stockroom', 'Stock Adjustments', 7, 1),
    ('Stockroom', 'Receive Supplies', 8, 1),
    ('Stockroom', 'Supply to Manufacturing (Fulfill Bundles)', 9, 1),
    ('Stockroom', 'Reports', 10, 1),
    ('Stockroom', 'GRV Management', 11, 1),
    ('Stockroom', 'Supply Invoices', 12, 1),
    ('Stockroom', 'Inter-Branch Transfer', 13, 1);

PRINT 'Added Stockroom menu (13 sub-menus)';

-- ========================================
-- MANUFACTURING MENU (15 sub-menus)
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
    ('Manufacturing', 'Orders', 11, 1),
    ('Manufacturing', 'Actions', 12, 1),
    ('Manufacturing', 'Master Data', 13, 1),
    ('Manufacturing', 'Producers Dashboard', 14, 1),
    ('Manufacturing', 'Complete Build (BOM)', 15, 1),
    ('Manufacturing', 'Production Schedule', 16, 1);

PRINT 'Added Manufacturing menu (16 sub-menus)';

-- ========================================
-- RETAIL MENU (14 sub-menus)
-- ========================================
INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES ('Retail', NULL, 4, 1);

INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES 
    ('Retail', 'Inventory', 1, 1),
    ('Retail', 'Products', 2, 1),
    ('Retail', 'POS', 3, 1),
    ('Retail', 'Inventory (Retail Branch)', 4, 1),
    ('Retail', 'Transfers (IBT)', 5, 1),
    ('Retail', 'Purchasing', 6, 1),
    ('Retail', 'Manufacturing (Hand-off)', 7, 1),
    ('Retail', 'Reports', 8, 1),
    ('Retail', 'Accounting', 9, 1),
    ('Retail', 'Settings', 10, 1),
    ('Retail', 'Point of Sale', 11, 1),
    ('Retail', 'Prices', 12, 1),
    ('Retail', 'Receiving', 13, 1);

PRINT 'Added Retail menu (13 sub-menus)';

-- ========================================
-- ACCOUNTING MENU (12 sub-menus)
-- ========================================
INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES ('Accounting', NULL, 5, 1);

INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
VALUES 
    ('Accounting', 'Master Data', 1, 1),
    ('Accounting', 'Cash Book', 2, 1),
    ('Accounting', 'Cash Book Journal (Legacy)', 3, 1),
    ('Accounting', 'Timesheet Entry', 4, 1),
    ('Accounting', 'Accounts Payable', 5, 1),
    ('Accounting', 'SARS Compliance', 6, 1),
    ('Accounting', 'General Ledger', 7, 1),
    ('Accounting', 'Reports', 8, 1),
    ('Accounting', 'Banking', 9, 1),
    ('Accounting', 'Viewers', 10, 1),
    ('Accounting', 'Payments', 11, 1),
    ('Accounting', 'Credit Notes', 12, 1);

PRINT 'Added Accounting menu (12 sub-menus)';

-- ========================================
-- UTILITIES MENU (4 sub-menus)
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
-- REPORTING MENU (no sub-menus visible)
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
PRINT 'MenuRegistry Synced with REAL Application!';
PRINT '===========================================';
