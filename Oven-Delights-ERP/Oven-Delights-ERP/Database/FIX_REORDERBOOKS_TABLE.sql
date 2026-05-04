-- Fix ReOrderBooks table structure to match stored procedures
-- This script updates the existing table to use ManufacturerUserID instead of ManufacturerName

USE OvenDelightsERP
GO

PRINT 'Fixing ReOrderBooks table structure...'
GO

-- Check if ManufacturerName column exists (old structure)
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ReOrderBooks') AND name = 'ManufacturerName')
BEGIN
    PRINT 'Found old structure with ManufacturerName column'
    
    -- Add ManufacturerUserID column if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ReOrderBooks') AND name = 'ManufacturerUserID')
    BEGIN
        PRINT 'Adding ManufacturerUserID column...'
        ALTER TABLE ReOrderBooks ADD ManufacturerUserID INT NULL
        PRINT '✓ ManufacturerUserID column added'
    END
    
    -- Try to populate ManufacturerUserID from ManufacturerName if possible
    -- This is a best-effort migration - you may need to manually fix some records
    PRINT 'Attempting to migrate data from ManufacturerName to ManufacturerUserID...'
    UPDATE rb
    SET rb.ManufacturerUserID = u.UserID
    FROM ReOrderBooks rb
    INNER JOIN Users u ON rb.ManufacturerName = u.FirstName + ' ' + u.LastName
    WHERE rb.ManufacturerUserID IS NULL
    
    -- For any remaining NULL values, try to set a default or mark for manual review
    DECLARE @RecordsNeedingFix INT
    SELECT @RecordsNeedingFix = COUNT(*) FROM ReOrderBooks WHERE ManufacturerUserID IS NULL
    
    IF @RecordsNeedingFix > 0
    BEGIN
        PRINT 'WARNING: ' + CAST(@RecordsNeedingFix AS VARCHAR) + ' records could not be automatically migrated.'
        PRINT 'Setting ManufacturerUserID to first available Manufacturer user...'
        
        DECLARE @DefaultManufacturerID INT
        SELECT TOP 1 @DefaultManufacturerID = UserID 
        FROM Users 
        WHERE RoleID IN (SELECT RoleID FROM Roles WHERE RoleName = 'Manufacturer') 
        AND IsActive = 1
        
        IF @DefaultManufacturerID IS NOT NULL
        BEGIN
            UPDATE ReOrderBooks 
            SET ManufacturerUserID = @DefaultManufacturerID 
            WHERE ManufacturerUserID IS NULL
            PRINT '✓ Set default ManufacturerUserID for unmapped records'
        END
    END
    
    -- Make ManufacturerUserID NOT NULL
    ALTER TABLE ReOrderBooks ALTER COLUMN ManufacturerUserID INT NOT NULL
    PRINT '✓ ManufacturerUserID set to NOT NULL'
    
    -- Drop the old ManufacturerName column
    PRINT 'Dropping old ManufacturerName column...'
    ALTER TABLE ReOrderBooks DROP COLUMN ManufacturerName
    PRINT '✓ ManufacturerName column removed'
    
    -- Recreate index if needed
    IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ReOrderBooks_Manufacturer' AND object_id = OBJECT_ID('ReOrderBooks'))
    BEGIN
        DROP INDEX IX_ReOrderBooks_Manufacturer ON ReOrderBooks
    END
    
    CREATE INDEX IX_ReOrderBooks_Manufacturer ON ReOrderBooks(ManufacturerUserID, Status)
    PRINT '✓ Index recreated on ManufacturerUserID'
    
    PRINT ''
    PRINT '========================================='
    PRINT '✓ ReOrderBooks table structure updated!'
    PRINT '========================================='
END
ELSE
BEGIN
    PRINT 'Table already has correct structure (ManufacturerUserID column exists)'
END
GO
