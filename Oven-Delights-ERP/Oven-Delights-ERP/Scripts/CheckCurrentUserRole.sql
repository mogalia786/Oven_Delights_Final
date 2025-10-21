-- Check current user role and permissions
SELECT 'Current User Info:' AS Info

-- Show all users and their roles
SELECT 
    u.Username,
    r.RoleName,
    u.UserID,
    r.RoleID
FROM Users u
INNER JOIN Roles r ON u.RoleID = r.RoleID
ORDER BY u.Username

SELECT '' AS Separator

-- Show all role permissions for Retail module
SELECT 'Retail Module Permissions:' AS Info
SELECT 
    r.RoleName,
    rp.ModuleName,
    rp.CanRead,
    rp.CanWrite,
    rp.CanDelete
FROM RolePermissions rp
INNER JOIN Roles r ON rp.RoleID = r.RoleID
WHERE rp.ModuleName = 'Retail'
ORDER BY r.RoleName

SELECT '' AS Separator

-- Show all modules and permissions for admin roles
SELECT 'All Permissions for Admin Roles:' AS Info
SELECT 
    r.RoleName,
    rp.ModuleName,
    rp.CanRead,
    rp.CanWrite,
    rp.CanDelete
FROM RolePermissions rp
INNER JOIN Roles r ON rp.RoleID = r.RoleID
WHERE r.RoleName LIKE '%Admin%'
ORDER BY r.RoleName, rp.ModuleName
