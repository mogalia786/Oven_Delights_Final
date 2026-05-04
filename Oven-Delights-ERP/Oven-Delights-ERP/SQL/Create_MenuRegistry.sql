-- Menu Registry Table
-- Central registry of all menus and sub-menus in the system
-- This table is the single source of truth for menu structure

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'MenuRegistry')
BEGIN
    CREATE TABLE MenuRegistry (
        MenuID INT IDENTITY(1,1) PRIMARY KEY,
        MenuName NVARCHAR(100) NOT NULL,
        SubMenuName NVARCHAR(100) NULL, -- NULL means it's a main menu
        DisplayOrder INT NOT NULL DEFAULT 0,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedDate DATETIME DEFAULT GETDATE(),
        CONSTRAINT UQ_MenuRegistry UNIQUE (MenuName, SubMenuName)
    );
    
    PRINT 'MenuRegistry table created successfully';
END
ELSE
BEGIN
    PRINT 'MenuRegistry table already exists';
END
GO

-- Create index for faster lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_MenuRegistry_MenuName')
BEGIN
    CREATE INDEX IX_MenuRegistry_MenuName ON MenuRegistry(MenuName);
    PRINT 'Index IX_MenuRegistry_MenuName created';
END
GO

-- Insert all existing menus and sub-menus
PRINT 'Populating MenuRegistry with existing menus...';

-- Administration Menu
INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
SELECT 'Administration', NULL, 1, 1
WHERE NOT EXISTS (SELECT 1 FROM MenuRegistry WHERE MenuName = 'Administration' AND SubMenuName IS NULL);

IF NOT EXISTS (SELECT 1 FROM MenuRegistry WHERE MenuName = 'Administration' AND SubMenuName IS NOT NULL)
BEGIN
    INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
    VALUES 
        ('Administration', 'User Management', 1, 1),
        ('Administration', 'Role Management', 2, 1),
        ('Administration', 'Branch Management', 3, 1),
        ('Administration', 'System Settings', 4, 1),
        ('Administration', 'Audit Log', 5, 1),
        ('Administration', 'AI Testing Dashboard', 6, 1);
END

-- Accounting Menu
INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
SELECT 'Accounting', NULL, 2, 1
WHERE NOT EXISTS (SELECT 1 FROM MenuRegistry WHERE MenuName = 'Accounting' AND SubMenuName IS NULL);

IF NOT EXISTS (SELECT 1 FROM MenuRegistry WHERE MenuName = 'Accounting' AND SubMenuName IS NOT NULL)
BEGIN
    INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
    VALUES 
        ('Accounting', 'Chart of Accounts', 1, 1),
        ('Accounting', 'General Ledger', 2, 1),
        ('Accounting', 'Accounts Payable', 3, 1),
        ('Accounting', 'Accounts Receivable', 4, 1),
        ('Accounting', 'Bank Reconciliation', 5, 1),
        ('Accounting', 'Financial Reports', 6, 1),
        ('Accounting', 'SARS Compliance', 7, 1);
END

-- Manufacturing Menu
INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
SELECT 'Manufacturing', NULL, 3, 1
WHERE NOT EXISTS (SELECT 1 FROM MenuRegistry WHERE MenuName = 'Manufacturing' AND SubMenuName IS NULL);

IF NOT EXISTS (SELECT 1 FROM MenuRegistry WHERE MenuName = 'Manufacturing' AND SubMenuName IS NOT NULL)
BEGIN
    INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
    VALUES 
        ('Manufacturing', 'Bill of Materials', 1, 1),
        ('Manufacturing', 'Production Orders', 2, 1),
        ('Manufacturing', 'Work Orders', 3, 1),
        ('Manufacturing', 'Quality Control', 4, 1),
        ('Manufacturing', 'Manufacturing Reports', 5, 1);
END

-- Retail Menu
INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
SELECT 'Retail', NULL, 4, 1
WHERE NOT EXISTS (SELECT 1 FROM MenuRegistry WHERE MenuName = 'Retail' AND SubMenuName IS NULL);

IF NOT EXISTS (SELECT 1 FROM MenuRegistry WHERE MenuName = 'Retail' AND SubMenuName IS NOT NULL)
BEGIN
    INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
    VALUES 
        ('Retail', 'Products', 1, 1),
        ('Retail', 'Customers', 2, 1),
        ('Retail', 'Sales', 3, 1),
        ('Retail', 'Returns', 4, 1),
        ('Retail', 'Retail Reports', 5, 1);
END

-- Inventory Menu
INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
SELECT 'Inventory', NULL, 5, 1
WHERE NOT EXISTS (SELECT 1 FROM MenuRegistry WHERE MenuName = 'Inventory' AND SubMenuName IS NULL);

IF NOT EXISTS (SELECT 1 FROM MenuRegistry WHERE MenuName = 'Inventory' AND SubMenuName IS NOT NULL)
BEGIN
    INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
    VALUES 
        ('Inventory', 'Stock Management', 1, 1),
        ('Inventory', 'Purchase Orders', 2, 1),
        ('Inventory', 'Suppliers', 3, 1),
        ('Inventory', 'Stock Adjustments', 4, 1),
        ('Inventory', 'Stock Reports', 5, 1),
        ('Inventory', 'Inter-Branch Transfers', 6, 1);
END

PRINT 'MenuRegistry populated successfully';
GO

-- View to see menu structure
IF OBJECT_ID('vw_MenuStructure', 'V') IS NOT NULL
    DROP VIEW vw_MenuStructure;
GO

CREATE VIEW vw_MenuStructure AS
SELECT 
    MenuID,
    MenuName,
    SubMenuName,
    DisplayOrder,
    IsActive,
    CASE WHEN SubMenuName IS NULL THEN 'Main Menu' ELSE 'Sub Menu' END AS MenuType
FROM MenuRegistry
WHERE IsActive = 1;
GO

PRINT 'vw_MenuStructure view created successfully';
GO

-- Stored Procedure to add new menu
IF OBJECT_ID('sp_AddMenu', 'P') IS NOT NULL
    DROP PROCEDURE sp_AddMenu;
GO

CREATE PROCEDURE sp_AddMenu
    @MenuName NVARCHAR(100),
    @SubMenuName NVARCHAR(100) = NULL,
    @DisplayOrder INT = 0,
    @GrantToAllRoles BIT = 1  -- Default: grant access to all roles
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Insert into MenuRegistry
        INSERT INTO MenuRegistry (MenuName, SubMenuName, DisplayOrder, IsActive)
        VALUES (@MenuName, @SubMenuName, @DisplayOrder, 1);
        
        -- If GrantToAllRoles is true, create permissions for all roles (except Super Administrator)
        IF @GrantToAllRoles = 1
        BEGIN
            INSERT INTO RoleMenuPermissions (RoleID, MenuName, SubMenuName, HasAccess)
            SELECT 
                RoleID,
                @MenuName,
                @SubMenuName,
                1  -- Grant access by default
            FROM Roles 
            WHERE RoleName <> 'Super Administrator'
            AND NOT EXISTS (
                SELECT 1 FROM RoleMenuPermissions 
                WHERE RoleID = Roles.RoleID 
                AND MenuName = @MenuName 
                AND (SubMenuName = @SubMenuName OR (SubMenuName IS NULL AND @SubMenuName IS NULL))
            );
        END
        
        COMMIT TRANSACTION;
        
        PRINT 'Menu added successfully: ' + @MenuName + ISNULL(' > ' + @SubMenuName, '');
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT 'sp_AddMenu stored procedure created successfully';
GO

-- Query to see all menus
SELECT * FROM vw_MenuStructure ORDER BY MenuName, DisplayOrder;

PRINT '';
PRINT '===========================================';
PRINT 'Menu Registry Setup Complete!';
PRINT '===========================================';
PRINT '';
PRINT 'To add a new menu, use:';
PRINT 'EXEC sp_AddMenu @MenuName = ''YourMenu'', @SubMenuName = NULL, @DisplayOrder = 1';
PRINT '';
PRINT 'To add a sub-menu, use:';
PRINT 'EXEC sp_AddMenu @MenuName = ''YourMenu'', @SubMenuName = ''Your Sub-Menu'', @DisplayOrder = 1';
PRINT '';
