-- Update RolePermissions table with ALL current menu items
-- Run this to ensure all menus are available for permission assignment

-- First, let's see what's currently in RolePermissions
SELECT DISTINCT ModuleName FROM RolePermissions ORDER BY ModuleName;

-- Insert all menu items if they don't exist (for Super Administrator role)
-- Get Super Admin RoleID
DECLARE @SuperAdminRoleID INT = (SELECT TOP 1 RoleID FROM Roles WHERE RoleName = 'Super Administrator');

-- Insert all menus with full permissions for Super Admin
IF @SuperAdminRoleID IS NOT NULL
BEGIN
    -- Main Modules
    IF NOT EXISTS (SELECT 1 FROM RolePermissions WHERE RoleID = @SuperAdminRoleID AND ModuleName = 'Administration')
        INSERT INTO RolePermissions (RoleID, ModuleName, CanRead, CanWrite) VALUES (@SuperAdminRoleID, 'Administration', 1, 1);
    
    IF NOT EXISTS (SELECT 1 FROM RolePermissions WHERE RoleID = @SuperAdminRoleID AND ModuleName = 'Stockroom')
        INSERT INTO RolePermissions (RoleID, ModuleName, CanRead, CanWrite) VALUES (@SuperAdminRoleID, 'Stockroom', 1, 1);
    
    IF NOT EXISTS (SELECT 1 FROM RolePermissions WHERE RoleID = @SuperAdminRoleID AND ModuleName = 'Manufacturing')
        INSERT INTO RolePermissions (RoleID, ModuleName, CanRead, CanWrite) VALUES (@SuperAdminRoleID, 'Manufacturing', 1, 1);
    
    IF NOT EXISTS (SELECT 1 FROM RolePermissions WHERE RoleID = @SuperAdminRoleID AND ModuleName = 'Retail')
        INSERT INTO RolePermissions (RoleID, ModuleName, CanRead, CanWrite) VALUES (@SuperAdminRoleID, 'Retail', 1, 1);
    
    IF NOT EXISTS (SELECT 1 FROM RolePermissions WHERE RoleID = @SuperAdminRoleID AND ModuleName = 'Accounting')
        INSERT INTO RolePermissions (RoleID, ModuleName, CanRead, CanWrite) VALUES (@SuperAdminRoleID, 'Accounting', 1, 1);
    
    IF NOT EXISTS (SELECT 1 FROM RolePermissions WHERE RoleID = @SuperAdminRoleID AND ModuleName = 'Reporting')
        INSERT INTO RolePermissions (RoleID, ModuleName, CanRead, CanWrite) VALUES (@SuperAdminRoleID, 'Reporting', 1, 1);
    
    IF NOT EXISTS (SELECT 1 FROM RolePermissions WHERE RoleID = @SuperAdminRoleID AND ModuleName = 'Utilities')
        INSERT INTO RolePermissions (RoleID, ModuleName, CanRead, CanWrite) VALUES (@SuperAdminRoleID, 'Utilities', 1, 1);

    PRINT 'Super Administrator permissions updated successfully!';
END
ELSE
BEGIN
    PRINT 'Super Administrator role not found!';
END

-- Show all current permissions for Super Admin
SELECT ModuleName, CanRead, CanWrite 
FROM RolePermissions 
WHERE RoleID = @SuperAdminRoleID 
ORDER BY ModuleName;
