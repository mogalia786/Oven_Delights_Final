-- =============================================
-- FIX MENU REGISTRY SCHEMA
-- =============================================
-- The MenuRegistry table has wrong columns
-- Code expects: MenuName, SubMenuName
-- Table has: MenuPath, MenuLevel
-- This script recreates the table with correct schema
-- =============================================

PRINT '========================================='
PRINT 'FIXING MENU REGISTRY SCHEMA'
PRINT '========================================='
PRINT ''

-- Drop existing table if it has wrong schema
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'MenuRegistry')
BEGIN
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('MenuRegistry') AND name = 'MenuPath')
    BEGIN
        PRINT 'Dropping old MenuRegistry table with wrong schema...'
        DROP TABLE MenuRegistry
        PRINT '✓ Old table dropped'
        PRINT ''
    END
    ELSE
    BEGIN
        PRINT 'MenuRegistry already has correct schema'
        PRINT ''
        GOTO SkipCreate
    END
END

-- Create table with correct schema
PRINT 'Creating MenuRegistry with correct schema...'
CREATE TABLE MenuRegistry (
    MenuID INT IDENTITY(1,1) PRIMARY KEY,
    MenuName NVARCHAR(100) NOT NULL,
    SubMenuName NVARCHAR(100) NULL,
    DisplayOrder INT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE()
)

PRINT '✓ MenuRegistry table created'
PRINT ''

SkipCreate:

PRINT '========================================='
PRINT 'FIX COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'MenuRegistry table now has correct schema:'
PRINT '  - MenuName (main menu)'
PRINT '  - SubMenuName (sub menu, NULL for main menus)'
PRINT '  - DisplayOrder'
PRINT '  - IsActive'
PRINT ''
