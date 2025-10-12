-- Fix Retail Point of Sale Permissions - Local Version
-- Add Retail permissions for current user role

PRINT 'Adding Retail permissions for all admin roles...'

-- Get all admin-type roles
DECLARE @SuperAdminRoleID INT, @AdminRoleID INT

SELECT @SuperAdminRoleID = RoleID FROM Roles WHERE RoleName = 'Super Administrator'
SELECT @AdminRoleID = RoleID FROM Roles WHERE RoleName = 'Administrator'

-- Add Retail permissions for Super Administrator
IF @SuperAdminRoleID IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM RolePermissions WHERE RoleID = @SuperAdminRoleID AND ModuleName = 'Retail')
    BEGIN
        INSERT INTO RolePermissions (RoleID, ModuleName, CanRead, CanWrite, CanDelete)
        VALUES (@SuperAdminRoleID, 'Retail', 1, 1, 1)
        PRINT 'Added Retail permissions for Super Administrator'
    END
    ELSE
    BEGIN
        UPDATE RolePermissions 
        SET CanRead = 1, CanWrite = 1, CanDelete = 1
        WHERE RoleID = @SuperAdminRoleID AND ModuleName = 'Retail'
        PRINT 'Updated Retail permissions for Super Administrator'
    END
END

-- Add Retail permissions for Administrator
IF @AdminRoleID IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM RolePermissions WHERE RoleID = @AdminRoleID AND ModuleName = 'Retail')
    BEGIN
        INSERT INTO RolePermissions (RoleID, ModuleName, CanRead, CanWrite, CanDelete)
        VALUES (@AdminRoleID, 'Retail', 1, 1, 1)
        PRINT 'Added Retail permissions for Administrator'
    END
    ELSE
    BEGIN
        UPDATE RolePermissions 
        SET CanRead = 1, CanWrite = 1, CanDelete = 1
        WHERE RoleID = @AdminRoleID AND ModuleName = 'Retail'
        PRINT 'Updated Retail permissions for Administrator'
    END
END

-- Show final permissions
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

PRINT 'Retail permissions updated successfully!'
