-- Check existing database schema for Roles and related tables
-- Run this first to see what columns actually exist

-- Check if Roles table exists and its structure
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Roles')
BEGIN
    PRINT 'Roles table exists. Columns:'
    SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Roles'
    ORDER BY ORDINAL_POSITION
END
ELSE
    PRINT 'Roles table does not exist'

PRINT ''

-- Check if Permissions table exists and its structure
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Permissions')
BEGIN
    PRINT 'Permissions table exists. Columns:'
    SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Permissions'
    ORDER BY ORDINAL_POSITION
END
ELSE
    PRINT 'Permissions table does not exist'

PRINT ''

-- Check if RolePermissions table exists and its structure
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'RolePermissions')
BEGIN
    PRINT 'RolePermissions table exists. Columns:'
    SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'RolePermissions'
    ORDER BY ORDINAL_POSITION
END
ELSE
    PRINT 'RolePermissions table does not exist'

PRINT ''

-- Show existing roles
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Roles')
BEGIN
    PRINT 'Existing roles:'
    SELECT * FROM Roles
END

PRINT ''

-- Show existing permissions (if table exists)
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Permissions')
BEGIN
    PRINT 'Existing permissions:'
    SELECT * FROM Permissions
END
