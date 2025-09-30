-- Fix Retail Point of Sale Permissions
-- Check current user role and add Retail permissions

PRINT 'Checking current user role and Retail permissions...'

-- Show current user session info
SELECT 'Current Session Info:' AS Info
SELECT 
    u.Username,
    r.RoleName,
    u.UserID,
    r.RoleID
FROM Users u
INNER JOIN Roles r ON u.RoleID = r.RoleID
WHERE u.Username = 'admin' OR u.Username = 'superadmin'

PRINT ''
PRINT 'Current Retail permissions:'

-- Show current Retail permissions
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

PRINT ''
PRINT 'Adding/Updating Retail permissions for Super Administrator...'

-- Get Super Administrator role ID
DECLARE @SuperAdminRoleID INT
SELECT @SuperAdminRoleID = RoleID FROM Roles WHERE RoleName = 'Super Administrator'

IF @SuperAdminRoleID IS NOT NULL
BEGIN
    -- Check if Retail permission already exists
    IF EXISTS (SELECT 1 FROM RolePermissions WHERE RoleID = @SuperAdminRoleID AND ModuleName = 'Retail')
    BEGIN
        -- Update existing permission
        UPDATE RolePermissions 
        SET CanRead = 1, CanWrite = 1, CanDelete = 1
        WHERE RoleID = @SuperAdminRoleID AND ModuleName = 'Retail'
        PRINT 'Updated existing Retail permissions for Super Administrator'
    END
    ELSE
    BEGIN
        -- Insert new permission
        INSERT INTO RolePermissions (RoleID, ModuleName, CanRead, CanWrite, CanDelete)
        VALUES (@SuperAdminRoleID, 'Retail', 1, 1, 1)
        PRINT 'Added new Retail permissions for Super Administrator'
    END
END
ELSE
BEGIN
    PRINT 'ERROR: Super Administrator role not found!'
END

-- Also add for Administrator role if it exists
DECLARE @AdminRoleID INT
SELECT @AdminRoleID = RoleID FROM Roles WHERE RoleName = 'Administrator'

IF @AdminRoleID IS NOT NULL
BEGIN
    -- Check if Retail permission already exists
    IF EXISTS (SELECT 1 FROM RolePermissions WHERE RoleID = @AdminRoleID AND ModuleName = 'Retail')
    BEGIN
        -- Update existing permission
        UPDATE RolePermissions 
        SET CanRead = 1, CanWrite = 1, CanDelete = 1
        WHERE RoleID = @AdminRoleID AND ModuleName = 'Retail'
        PRINT 'Updated existing Retail permissions for Administrator'
    END
    ELSE
    BEGIN
        -- Insert new permission
        INSERT INTO RolePermissions (RoleID, ModuleName, CanRead, CanWrite, CanDelete)
        VALUES (@AdminRoleID, 'Retail', 1, 1, 1)
        PRINT 'Added new Retail permissions for Administrator'
    END
END

PRINT ''
PRINT 'Final Retail permissions:'

-- Show final Retail permissions
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

PRINT ''
PRINT 'Retail permissions fix completed!'
