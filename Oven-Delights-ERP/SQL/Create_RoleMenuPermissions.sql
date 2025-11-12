-- Role Menu Permissions Table
-- Stores which menus and sub-menus each role can access

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'RoleMenuPermissions')
BEGIN
    CREATE TABLE RoleMenuPermissions (
        PermissionID INT IDENTITY(1,1) PRIMARY KEY,
        RoleID INT NOT NULL,
        MenuName NVARCHAR(100) NOT NULL,
        SubMenuName NVARCHAR(100) NULL, -- NULL means it's a main menu permission
        HasAccess BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedDate DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_RoleMenuPermissions_Role FOREIGN KEY (RoleID) REFERENCES Roles(RoleID) ON DELETE CASCADE,
        CONSTRAINT UQ_RoleMenuPermissions UNIQUE (RoleID, MenuName, SubMenuName)
    );
    
    PRINT 'RoleMenuPermissions table created successfully';
END
ELSE
BEGIN
    PRINT 'RoleMenuPermissions table already exists';
END
GO

-- Create index for faster lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_RoleMenuPermissions_RoleID')
BEGIN
    CREATE INDEX IX_RoleMenuPermissions_RoleID ON RoleMenuPermissions(RoleID);
    PRINT 'Index IX_RoleMenuPermissions_RoleID created';
END
GO

-- Grant Super Administrator full access to all menus by default
DECLARE @SuperAdminRoleID INT;
SELECT @SuperAdminRoleID = RoleID FROM Roles WHERE RoleName = 'Super Administrator';

IF @SuperAdminRoleID IS NOT NULL
BEGIN
    -- Insert default permissions for Super Administrator (all menus enabled)
    -- Main menus
    INSERT INTO RoleMenuPermissions (RoleID, MenuName, SubMenuName, HasAccess)
    SELECT @SuperAdminRoleID, 'Administration', NULL, 1
    WHERE NOT EXISTS (SELECT 1 FROM RoleMenuPermissions WHERE RoleID = @SuperAdminRoleID AND MenuName = 'Administration' AND SubMenuName IS NULL);
    
    INSERT INTO RoleMenuPermissions (RoleID, MenuName, SubMenuName, HasAccess)
    SELECT @SuperAdminRoleID, 'Accounting', NULL, 1
    WHERE NOT EXISTS (SELECT 1 FROM RoleMenuPermissions WHERE RoleID = @SuperAdminRoleID AND MenuName = 'Accounting' AND SubMenuName IS NULL);
    
    INSERT INTO RoleMenuPermissions (RoleID, MenuName, SubMenuName, HasAccess)
    SELECT @SuperAdminRoleID, 'Manufacturing', NULL, 1
    WHERE NOT EXISTS (SELECT 1 FROM RoleMenuPermissions WHERE RoleID = @SuperAdminRoleID AND MenuName = 'Manufacturing' AND SubMenuName IS NULL);
    
    INSERT INTO RoleMenuPermissions (RoleID, MenuName, SubMenuName, HasAccess)
    SELECT @SuperAdminRoleID, 'Retail', NULL, 1
    WHERE NOT EXISTS (SELECT 1 FROM RoleMenuPermissions WHERE RoleID = @SuperAdminRoleID AND MenuName = 'Retail' AND SubMenuName IS NULL);
    
    INSERT INTO RoleMenuPermissions (RoleID, MenuName, SubMenuName, HasAccess)
    SELECT @SuperAdminRoleID, 'Inventory', NULL, 1
    WHERE NOT EXISTS (SELECT 1 FROM RoleMenuPermissions WHERE RoleID = @SuperAdminRoleID AND MenuName = 'Inventory' AND SubMenuName IS NULL);
    
    PRINT 'Super Administrator default permissions created';
END
GO

-- View to check role permissions
IF OBJECT_ID('vw_RoleMenuAccess', 'V') IS NOT NULL
    DROP VIEW vw_RoleMenuAccess;
GO

CREATE VIEW vw_RoleMenuAccess AS
SELECT 
    r.RoleID,
    r.RoleName,
    rmp.MenuName,
    rmp.SubMenuName,
    rmp.HasAccess
FROM Roles r
LEFT JOIN RoleMenuPermissions rmp ON r.RoleID = rmp.RoleID;
GO

PRINT 'vw_RoleMenuAccess view created successfully';
GO

-- Query to see all role permissions
SELECT * FROM vw_RoleMenuAccess ORDER BY RoleName, MenuName, SubMenuName;
