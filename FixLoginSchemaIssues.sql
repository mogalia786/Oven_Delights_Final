-- Add missing columns to Users table if they don't exist
IF NOT EXISTS (SELECT * FROM sys.columns 
               WHERE object_id = OBJECT_ID(N'[dbo].[Users]') 
               AND name = 'IsLockedOut')
BEGIN
    ALTER TABLE [dbo].[Users]
    ADD IsLockedOut BIT NOT NULL DEFAULT 0;
    PRINT 'Added IsLockedOut column to Users table';
END
ELSE
BEGIN
    PRINT 'IsLockedOut column already exists in Users table';
END

IF NOT EXISTS (SELECT * FROM sys.columns 
               WHERE object_id = OBJECT_ID(N'[dbo].[Users]') 
               AND name = 'LockoutEnd')
BEGIN
    ALTER TABLE [dbo].[Users]
    ADD LockoutEnd DATETIME2 NULL;
    PRINT 'Added LockoutEnd column to Users table';
END
ELSE
BEGIN
    PRINT 'LockoutEnd column already exists in Users table';
END

-- Ensure FailedLoginAttempts has a default value
IF EXISTS (SELECT * FROM sys.columns 
           WHERE object_id = OBJECT_ID(N'[dbo].[Users]') 
           AND name = 'FailedLoginAttempts' 
           AND columnproperty(object_id, 'FailedLoginAttempts', 'AllowsNull') = 1)
BEGIN
    -- Update any NULL values to 0
    UPDATE [dbo].[Users] 
    SET FailedLoginAttempts = 0 
    WHERE FailedLoginAttempts IS NULL;
    
    -- Alter column to be NOT NULL with default 0
    ALTER TABLE [dbo].[Users]
    ALTER COLUMN FailedLoginAttempts INT NOT NULL;
    
    ALTER TABLE [dbo].[Users]
    ADD CONSTRAINT DF_Users_FailedLoginAttempts DEFAULT 0 FOR FailedLoginAttempts;
    
    PRINT 'Updated FailedLoginAttempts column to be NOT NULL with default 0';
END

-- Verify the schema changes
SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length,
    c.is_nullable,
    CASE WHEN d.definition IS NOT NULL THEN 'DEFAULT ' + d.definition ELSE '' END AS DefaultValue
FROM 
    sys.columns c
INNER JOIN 
    sys.types t ON c.user_type_id = t.user_type_id
LEFT JOIN
    sys.default_constraints d ON c.default_object_id = d.object_id
WHERE 
    c.object_id = OBJECT_ID('Users')
    AND c.name IN ('IsLockedOut', 'LockoutEnd', 'FailedLoginAttempts');

-- Check for any users that need their FailedLoginAttempts reset (if they were locked out but the lockout has expired)
UPDATE [dbo].[Users]
SET 
    IsLockedOut = 0,
    LockoutEnd = NULL,
    FailedLoginAttempts = 0
WHERE 
    IsLockedOut = 1 
    AND LockoutEnd IS NOT NULL 
    AND LockoutEnd < GETUTCDATE();

PRINT 'Reset expired account lockouts';
