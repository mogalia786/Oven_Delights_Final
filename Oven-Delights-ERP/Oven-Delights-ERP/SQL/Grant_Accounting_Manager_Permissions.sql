-- Grant Accounting Menu Permissions to Accounting Manager Role
-- This script adds permissions for the Accounting Manager to access Accounting menus

-- First, get the RoleID for Accounting Manager
DECLARE @RoleID INT;
SELECT @RoleID = RoleID FROM Roles WHERE RoleName = 'Accounting Manager';

IF @RoleID IS NULL
BEGIN
    PRINT 'ERROR: Accounting Manager role not found. Please create the role first.';
END
ELSE
BEGIN
    PRINT 'Found Accounting Manager role with RoleID: ' + CAST(@RoleID AS VARCHAR(10));
    
    -- Delete existing permissions for this role (clean slate)
    DELETE FROM RoleMenuPermissions WHERE RoleID = @RoleID;
    PRINT 'Cleared existing permissions for Accounting Manager';
    
    -- Grant access to Accounting menu and all sub-menus
    -- Main Accounting menu
    INSERT INTO RoleMenuPermissions (RoleID, MenuName, SubMenuName, HasAccess)
    VALUES (@RoleID, 'Accounting', NULL, 1);
    
    -- Accounting sub-menus (add all accounting-related sub-menus)
    INSERT INTO RoleMenuPermissions (RoleID, MenuName, SubMenuName, HasAccess)
    SELECT @RoleID, MenuName, SubMenuName, 1
    FROM MenuRegistry
    WHERE MenuName = 'Accounting' AND SubMenuName IS NOT NULL;
    
    -- Also grant access to Administration > Dashboard (so they can see the dashboard)
    INSERT INTO RoleMenuPermissions (RoleID, MenuName, SubMenuName, HasAccess)
    VALUES 
        (@RoleID, 'Administration', NULL, 1),
        (@RoleID, 'Administration', 'Dashboard', 1);
    
    -- Grant access to Reporting menu (accounting managers typically need reports)
    INSERT INTO RoleMenuPermissions (RoleID, MenuName, SubMenuName, HasAccess)
    VALUES (@RoleID, 'Reporting', NULL, 1);
    
    INSERT INTO RoleMenuPermissions (RoleID, MenuName, SubMenuName, HasAccess)
    SELECT @RoleID, MenuName, SubMenuName, 1
    FROM MenuRegistry
    WHERE MenuName = 'Reporting' AND SubMenuName IS NOT NULL;
    
    PRINT 'Granted Accounting Manager permissions successfully';
    
    -- Show what was granted
    SELECT 
        r.RoleName,
        rmp.MenuName,
        rmp.SubMenuName,
        rmp.HasAccess
    FROM RoleMenuPermissions rmp
    INNER JOIN Roles r ON rmp.RoleID = r.RoleID
    WHERE rmp.RoleID = @RoleID
    ORDER BY rmp.MenuName, rmp.SubMenuName;
END
GO
