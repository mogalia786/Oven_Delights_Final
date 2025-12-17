-- =============================================
-- Menu Registry System for Role-Based Access Control
-- =============================================

-- Drop existing table if exists
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MenuRegistry]') AND type in (N'U'))
BEGIN
    DROP TABLE [dbo].[MenuRegistry]
    PRINT 'Dropped existing MenuRegistry table'
END
GO

-- Create MenuRegistry table
CREATE TABLE [dbo].[MenuRegistry] (
    [MenuID] INT IDENTITY(1,1) PRIMARY KEY,
    [MenuPath] NVARCHAR(500) NOT NULL UNIQUE, -- e.g., "Retail > IBT > Request Products > New Request"
    [MenuLevel] INT NOT NULL, -- 1=Top, 2=Sub, 3=Sub-Sub, etc.
    [ParentPath] NVARCHAR(500) NULL, -- Parent menu path
    [DisplayName] NVARCHAR(200) NOT NULL,
    [ModuleName] NVARCHAR(100) NOT NULL, -- e.g., "Retail", "Administration"
    [IsActive] BIT NOT NULL DEFAULT 1,
    [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
    [UpdatedDate] DATETIME NOT NULL DEFAULT GETDATE()
);
GO

PRINT 'MenuRegistry table created successfully'
GO

-- Insert all current menus
DELETE FROM MenuRegistry;
GO

-- ADMINISTRATION MENUS
INSERT INTO MenuRegistry (MenuPath, MenuLevel, ParentPath, DisplayName, ModuleName) VALUES
('Administration', 1, NULL, 'Administration', 'Administration'),
('Administration > User Management', 2, 'Administration', 'User Management', 'Administration'),
('Administration > Role Management', 2, 'Administration', 'Role Management', 'Administration'),
('Administration > Branch Management', 2, 'Administration', 'Branch Management', 'Administration'),
('Administration > System Settings', 2, 'Administration', 'System Settings', 'Administration'),
('Administration > Audit Log', 2, 'Administration', 'Audit Log', 'Administration'),
('Administration > AI Testing Dashboard', 2, 'Administration', 'AI Testing Dashboard', 'Administration');
GO

-- STOCKROOM MENUS
INSERT INTO MenuRegistry (MenuPath, MenuLevel, ParentPath, DisplayName, ModuleName) VALUES
('Stockroom', 1, NULL, 'Stockroom', 'Stockroom'),
('Stockroom > Products', 2, 'Stockroom', 'Products', 'Stockroom'),
('Stockroom > Categories', 2, 'Stockroom', 'Categories', 'Stockroom'),
('Stockroom > Suppliers', 2, 'Stockroom', 'Suppliers', 'Stockroom'),
('Stockroom > Purchase Orders', 2, 'Stockroom', 'Purchase Orders', 'Stockroom'),
('Stockroom > Goods Received', 2, 'Stockroom', 'Goods Received', 'Stockroom'),
('Stockroom > Stock Adjustments', 2, 'Stockroom', 'Stock Adjustments', 'Stockroom'),
('Stockroom > Stock Reports', 2, 'Stockroom', 'Stock Reports', 'Stockroom');
GO

-- MANUFACTURING MENUS
INSERT INTO MenuRegistry (MenuPath, MenuLevel, ParentPath, DisplayName, ModuleName) VALUES
('Manufacturing', 1, NULL, 'Manufacturing', 'Manufacturing'),
('Manufacturing > Build My Product', 2, 'Manufacturing', 'Build My Product', 'Manufacturing'),
('Manufacturing > Bill of Materials', 2, 'Manufacturing', 'Bill of Materials', 'Manufacturing'),
('Manufacturing > Re-Order Books', 2, 'Manufacturing', 'Re-Order Books', 'Manufacturing'),
('Manufacturing > Production Orders', 2, 'Manufacturing', 'Production Orders', 'Manufacturing'),
('Manufacturing > Baker Dashboard', 2, 'Manufacturing', 'Baker Dashboard', 'Manufacturing'),
('Manufacturing > Orders', 2, 'Manufacturing', 'Orders', 'Manufacturing'),
('Manufacturing > Orders > Cake Orders', 3, 'Manufacturing > Orders', 'Cake Orders', 'Manufacturing'),
('Manufacturing > Orders > Cake Orders > New Cake Orders', 4, 'Manufacturing > Orders > Cake Orders', 'New Cake Orders', 'Manufacturing'),
('Manufacturing > Orders > Cake Orders > Ready Cake Orders', 4, 'Manufacturing > Orders > Cake Orders', 'Ready Cake Orders', 'Manufacturing'),
('Manufacturing > Orders > Cake Orders > All Cake Orders', 4, 'Manufacturing > Orders > Cake Orders', 'All Cake Orders', 'Manufacturing'),
('Manufacturing > Orders > General Orders', 3, 'Manufacturing > Orders', 'General Orders', 'Manufacturing'),
('Manufacturing > Orders > General Orders > New General Orders', 4, 'Manufacturing > Orders > General Orders', 'New General Orders', 'Manufacturing'),
('Manufacturing > Orders > General Orders > Ready General Orders', 4, 'Manufacturing > Orders > General Orders', 'Ready General Orders', 'Manufacturing'),
('Manufacturing > Orders > General Orders > All General Orders', 4, 'Manufacturing > Orders > General Orders', 'All General Orders', 'Manufacturing');
GO

-- RETAIL MENUS
INSERT INTO MenuRegistry (MenuPath, MenuLevel, ParentPath, DisplayName, ModuleName) VALUES
('Retail', 1, NULL, 'Retail', 'Retail'),
('Retail > Products', 2, 'Retail', 'Products', 'Retail'),
('Retail > Prices', 2, 'Retail', 'Prices', 'Retail'),
('Retail > Inventory', 2, 'Retail', 'Inventory', 'Retail'),
('Retail > Receiving', 2, 'Retail', 'Receiving', 'Retail'),
('Retail > Reports', 2, 'Retail', 'Reports', 'Retail');
GO

-- IBT (INTER-BRANCH TRANSFER) MENUS
INSERT INTO MenuRegistry (MenuPath, MenuLevel, ParentPath, DisplayName, ModuleName) VALUES
('Retail > IBT (Inter-Branch Transfer)', 2, 'Retail', 'IBT (Inter-Branch Transfer)', 'Retail'),
('Retail > IBT (Inter-Branch Transfer) > Request Products', 3, 'Retail > IBT (Inter-Branch Transfer)', 'Request Products', 'Retail'),
('Retail > IBT (Inter-Branch Transfer) > Request Products > New Request', 4, 'Retail > IBT (Inter-Branch Transfer) > Request Products', 'New Request', 'Retail'),
('Retail > IBT (Inter-Branch Transfer) > Request Products > My Requests Status', 4, 'Retail > IBT (Inter-Branch Transfer) > Request Products', 'My Requests Status', 'Retail'),
('Retail > IBT (Inter-Branch Transfer) > Request Products > In-Transit to Me', 4, 'Retail > IBT (Inter-Branch Transfer) > Request Products', 'In-Transit to Me', 'Retail'),
('Retail > IBT (Inter-Branch Transfer) > Request Products > Receive Delivery', 4, 'Retail > IBT (Inter-Branch Transfer) > Request Products', 'Receive Delivery', 'Retail'),
('Retail > IBT (Inter-Branch Transfer) > Requested Products', 3, 'Retail > IBT (Inter-Branch Transfer)', 'Requested Products', 'Retail'),
('Retail > IBT (Inter-Branch Transfer) > Requested Products > Pending Approval', 4, 'Retail > IBT (Inter-Branch Transfer) > Requested Products', 'Pending Approval', 'Retail'),
('Retail > IBT (Inter-Branch Transfer) > Requested Products > Create Delivery Note', 4, 'Retail > IBT (Inter-Branch Transfer) > Requested Products', 'Create Delivery Note', 'Retail'),
('Retail > IBT (Inter-Branch Transfer) > Requested Products > Dispatched by Me', 4, 'Retail > IBT (Inter-Branch Transfer) > Requested Products', 'Dispatched by Me', 'Retail'),
('Retail > IBT (Inter-Branch Transfer) > Delivered Items (All)', 3, 'Retail > IBT (Inter-Branch Transfer)', 'Delivered Items (All)', 'Retail'),
('Retail > IBT (Inter-Branch Transfer) > Inter-Branch Ledger', 3, 'Retail > IBT (Inter-Branch Transfer)', 'Inter-Branch Ledger', 'Retail');
GO

-- ACCOUNTING MENUS
INSERT INTO MenuRegistry (MenuPath, MenuLevel, ParentPath, DisplayName, ModuleName) VALUES
('Accounting', 1, NULL, 'Accounting', 'Accounting'),
('Accounting > Chart of Accounts', 2, 'Accounting', 'Chart of Accounts', 'Accounting'),
('Accounting > General Ledger', 2, 'Accounting', 'General Ledger', 'Accounting'),
('Accounting > Journals', 2, 'Accounting', 'Journals', 'Accounting'),
('Accounting > Accounts Payable', 2, 'Accounting', 'Accounts Payable', 'Accounting'),
('Accounting > Accounts Receivable', 2, 'Accounting', 'Accounts Receivable', 'Accounting'),
('Accounting > Bank Reconciliation', 2, 'Accounting', 'Bank Reconciliation', 'Accounting'),
('Accounting > Financial Statements', 2, 'Accounting', 'Financial Statements', 'Accounting');
GO

-- REPORTING MENUS
INSERT INTO MenuRegistry (MenuPath, MenuLevel, ParentPath, DisplayName, ModuleName) VALUES
('Reporting', 1, NULL, 'Reporting', 'Reporting'),
('Reporting > Sales Reports', 2, 'Reporting', 'Sales Reports', 'Reporting'),
('Reporting > Inventory Reports', 2, 'Reporting', 'Inventory Reports', 'Reporting'),
('Reporting > Production Reports', 2, 'Reporting', 'Production Reports', 'Reporting'),
('Reporting > Financial Reports', 2, 'Reporting', 'Financial Reports', 'Reporting'),
('Reporting > Custom Reports', 2, 'Reporting', 'Custom Reports', 'Reporting');
GO

-- UTILITIES MENUS
INSERT INTO MenuRegistry (MenuPath, MenuLevel, ParentPath, DisplayName, ModuleName) VALUES
('Utilities', 1, NULL, 'Utilities', 'Utilities'),
('Utilities > Import Categories from CSV', 2, 'Utilities', 'Import Categories from CSV', 'Utilities'),
('Utilities > Import Products from CSV', 2, 'Utilities', 'Import Products from CSV', 'Utilities'),
('Utilities > Import Suppliers from CSV', 2, 'Utilities', 'Import Suppliers from CSV', 'Utilities'),
('Utilities > Export Data (CSV)', 2, 'Utilities', 'Export Data (CSV)', 'Utilities');
GO

PRINT 'Menu registry populated with all current menus'
GO

-- Create view for easy querying
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_MenuHierarchy]'))
    DROP VIEW [dbo].[vw_MenuHierarchy]
GO

CREATE VIEW [dbo].[vw_MenuHierarchy]
AS
SELECT 
    MenuID,
    MenuPath,
    MenuLevel,
    ParentPath,
    DisplayName,
    ModuleName,
    IsActive,
    CASE MenuLevel
        WHEN 1 THEN DisplayName
        WHEN 2 THEN '  → ' + DisplayName
        WHEN 3 THEN '    → ' + DisplayName
        WHEN 4 THEN '      → ' + DisplayName
        ELSE '        → ' + DisplayName
    END AS HierarchicalDisplay
FROM MenuRegistry
WHERE IsActive = 1
GO

PRINT 'Menu hierarchy view created'
GO

-- Query to see all menus
SELECT * FROM vw_MenuHierarchy ORDER BY MenuPath;
GO

DECLARE @MenuCount INT;
SELECT @MenuCount = COUNT(*) FROM MenuRegistry;

PRINT '============================================='
PRINT 'Menu Registry System Created Successfully!'
PRINT 'Total Menus Registered: ' + CAST(@MenuCount AS VARCHAR(10))
PRINT '============================================='
GO
