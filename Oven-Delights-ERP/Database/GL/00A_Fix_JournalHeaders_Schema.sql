-- =============================================
-- Fix JournalHeaders Schema Issues
-- =============================================
-- Increase JournalNumber column size to accommodate longer journal numbers
-- Fix CreatedBy column type if needed
-- =============================================

PRINT 'Checking JournalHeaders schema...'
GO

-- Check and fix JournalNumber column length
IF EXISTS (
    SELECT 1 
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID('JournalHeaders')
    AND c.name = 'JournalNumber'
    AND t.name = 'nvarchar'
    AND c.max_length < 100  -- max_length is in bytes, so 50 chars = 100 bytes for nvarchar
)
BEGIN
    PRINT 'Expanding JournalNumber column to NVARCHAR(50)...'
    ALTER TABLE JournalHeaders
    ALTER COLUMN JournalNumber NVARCHAR(50) NOT NULL
    PRINT '  ✓ JournalNumber column expanded'
END
ELSE
BEGIN
    PRINT '  ✓ JournalNumber column is already adequate size'
END
GO

-- Check CreatedBy column type
DECLARE @CreatedByType NVARCHAR(50)
SELECT @CreatedByType = t.name 
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('JournalHeaders')
AND c.name = 'CreatedBy'

IF @CreatedByType = 'int'
BEGIN
    PRINT 'WARNING: CreatedBy is INT type - this will cause conversion errors'
    PRINT 'Consider changing to NVARCHAR(100) to store usernames'
    PRINT 'For now, procedures will need to pass UserID instead of Username'
END
ELSE IF @CreatedByType = 'nvarchar' OR @CreatedByType = 'varchar'
BEGIN
    PRINT '  ✓ CreatedBy column is text type (correct)'
END
GO

PRINT 'JournalHeaders schema check completed'
GO
