-- Add missing menus to MenuRegistry
-- Run this after Create_MenuRegistry.sql

PRINT 'Adding missing menus to MenuRegistry...';

-- Utilities Menu (if it exists in your system)
IF NOT EXISTS (SELECT 1 FROM MenuRegistry WHERE MenuName = 'Utilities' AND SubMenuName IS NULL)
BEGIN
    INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
    VALUES ('Utilities', NULL, 6, 1);
    PRINT 'Added Utilities main menu';
END

-- Add Utilities sub-menus (adjust based on your actual sub-menus)
IF NOT EXISTS (SELECT 1 FROM MenuRegistry WHERE MenuName = 'Utilities' AND SubMenuName IS NOT NULL)
BEGIN
    INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
    VALUES 
        ('Utilities', 'Data Export', 1, 1),
        ('Utilities', 'Data Import', 2, 1),
        ('Utilities', 'Backup & Restore', 3, 1),
        ('Utilities', 'System Maintenance', 4, 1);
    PRINT 'Added Utilities sub-menus';
END

-- Reporting Menu
IF NOT EXISTS (SELECT 1 FROM MenuRegistry WHERE MenuName = 'Reporting' AND SubMenuName IS NULL)
BEGIN
    INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
    VALUES ('Reporting', NULL, 7, 1);
    PRINT 'Added Reporting main menu';
END

-- Add Reporting sub-menus (adjust based on your actual sub-menus)
IF NOT EXISTS (SELECT 1 FROM MenuRegistry WHERE MenuName = 'Reporting' AND SubMenuName IS NOT NULL)
BEGIN
    INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
    VALUES 
        ('Reporting', 'Sales Reports', 1, 1),
        ('Reporting', 'Inventory Reports', 2, 1),
        ('Reporting', 'Financial Reports', 3, 1),
        ('Reporting', 'Custom Reports', 4, 1);
    PRINT 'Added Reporting sub-menus';
END

-- Update Stockroom to Inventory (if you want to rename it)
-- Option 1: Update existing Stockroom entries to Inventory
UPDATE MenuRegistry 
SET MenuName = 'Inventory'
WHERE MenuName = 'Stockroom';

PRINT 'Renamed Stockroom to Inventory in MenuRegistry';

-- Update permissions table to match
UPDATE RoleMenuPermissions
SET MenuName = 'Inventory'
WHERE MenuName = 'Stockroom';

PRINT 'Renamed Stockroom to Inventory in RoleMenuPermissions';

-- Grant default access to all roles for new menus
DECLARE @RoleID INT;
DECLARE role_cursor CURSOR FOR 
    SELECT RoleID FROM Roles WHERE RoleName <> 'Super Administrator';

OPEN role_cursor;
FETCH NEXT FROM role_cursor INTO @RoleID;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Utilities
    IF NOT EXISTS (SELECT 1 FROM RoleMenuPermissions WHERE RoleID = @RoleID AND MenuName = 'Utilities' AND SubMenuName IS NULL)
    BEGIN
        INSERT INTO RoleMenuPermissions (RoleID, MenuName, SubMenuName, HasAccess)
        VALUES (@RoleID, 'Utilities', NULL, 1);
        
        INSERT INTO RoleMenuPermissions (RoleID, MenuName, SubMenuName, HasAccess)
        VALUES 
            (@RoleID, 'Utilities', 'Data Export', 1),
            (@RoleID, 'Utilities', 'Data Import', 1),
            (@RoleID, 'Utilities', 'Backup & Restore', 1),
            (@RoleID, 'Utilities', 'System Maintenance', 1);
    END
    
    -- Reporting
    IF NOT EXISTS (SELECT 1 FROM RoleMenuPermissions WHERE RoleID = @RoleID AND MenuName = 'Reporting' AND SubMenuName IS NULL)
    BEGIN
        INSERT INTO RoleMenuPermissions (RoleID, MenuName, SubMenuName, HasAccess)
        VALUES (@RoleID, 'Reporting', NULL, 1);
        
        INSERT INTO RoleMenuPermissions (RoleID, MenuName, SubMenuName, HasAccess)
        VALUES 
            (@RoleID, 'Reporting', 'Sales Reports', 1),
            (@RoleID, 'Reporting', 'Inventory Reports', 1),
            (@RoleID, 'Reporting', 'Financial Reports', 1),
            (@RoleID, 'Reporting', 'Custom Reports', 1);
    END
    
    FETCH NEXT FROM role_cursor INTO @RoleID;
END

CLOSE role_cursor;
DEALLOCATE role_cursor;

PRINT 'Granted default permissions for new menus';

-- View results
SELECT * FROM vw_MenuStructure ORDER BY MenuName, DisplayOrder;

PRINT '';
PRINT '===========================================';
PRINT 'Missing Menus Added Successfully!';
PRINT '===========================================';
