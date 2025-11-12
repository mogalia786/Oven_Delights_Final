-- ========================================
-- FIX LEDGERS TABLE STRUCTURE
-- Add missing columns to Ledgers table
-- ========================================

-- Remove USE statement for Azure SQL
-- USE OvenDelightsERP;
-- GO

PRINT '========================================';
PRINT 'FIXING LEDGERS TABLE STRUCTURE';
PRINT '========================================';
PRINT '';

-- Check current structure
PRINT 'Current Ledgers table columns:';
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Ledgers'
ORDER BY ORDINAL_POSITION;

PRINT '';
PRINT 'Adding missing columns...';

-- Add LedgerCode if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Ledgers' AND COLUMN_NAME = 'LedgerCode')
BEGIN
    ALTER TABLE Ledgers ADD LedgerCode NVARCHAR(20) NULL;
    PRINT '  ✓ Added LedgerCode column';
END
ELSE
BEGIN
    PRINT '  ✓ LedgerCode column exists';
END

-- Add LedgerName if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Ledgers' AND COLUMN_NAME = 'LedgerName')
BEGIN
    ALTER TABLE Ledgers ADD LedgerName NVARCHAR(200) NULL;
    PRINT '  ✓ Added LedgerName column';
END
ELSE
BEGIN
    PRINT '  ✓ LedgerName column exists';
END

-- Add AccountID if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Ledgers' AND COLUMN_NAME = 'AccountID')
BEGIN
    ALTER TABLE Ledgers ADD AccountID INT NULL;
    PRINT '  ✓ Added AccountID column';
END
ELSE
BEGIN
    PRINT '  ✓ AccountID column exists';
END

-- Add AccountCode if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Ledgers' AND COLUMN_NAME = 'AccountCode')
BEGIN
    ALTER TABLE Ledgers ADD AccountCode NVARCHAR(20) NULL;
    PRINT '  ✓ Added AccountCode column';
END
ELSE
BEGIN
    PRINT '  ✓ AccountCode column exists';
END

-- Add AccountName if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Ledgers' AND COLUMN_NAME = 'AccountName')
BEGIN
    ALTER TABLE Ledgers ADD AccountName NVARCHAR(200) NULL;
    PRINT '  ✓ Added AccountName column';
END
ELSE
BEGIN
    PRINT '  ✓ AccountName column exists';
END

-- Add LedgerType if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Ledgers' AND COLUMN_NAME = 'LedgerType')
BEGIN
    ALTER TABLE Ledgers ADD LedgerType NVARCHAR(50) NULL;
    PRINT '  ✓ Added LedgerType column';
END
ELSE
BEGIN
    PRINT '  ✓ LedgerType column exists';
END

-- Add IsActive if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Ledgers' AND COLUMN_NAME = 'IsActive')
BEGIN
    ALTER TABLE Ledgers ADD IsActive BIT NOT NULL DEFAULT 1;
    PRINT '  ✓ Added IsActive column';
END
ELSE
BEGIN
    PRINT '  ✓ IsActive column exists';
END

-- Add CreatedBy if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Ledgers' AND COLUMN_NAME = 'CreatedBy')
BEGIN
    ALTER TABLE Ledgers ADD CreatedBy NVARCHAR(100) NULL;
    PRINT '  ✓ Added CreatedBy column';
END
ELSE
BEGIN
    PRINT '  ✓ CreatedBy column exists';
END

-- Add CreatedDate if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Ledgers' AND COLUMN_NAME = 'CreatedDate')
BEGIN
    ALTER TABLE Ledgers ADD CreatedDate DATETIME NULL DEFAULT GETDATE();
    PRINT '  ✓ Added CreatedDate column';
END
ELSE
BEGIN
    PRINT '  ✓ CreatedDate column exists';
END

-- Add ModifiedBy if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Ledgers' AND COLUMN_NAME = 'ModifiedBy')
BEGIN
    ALTER TABLE Ledgers ADD ModifiedBy NVARCHAR(100) NULL;
    PRINT '  ✓ Added ModifiedBy column';
END
ELSE
BEGIN
    PRINT '  ✓ ModifiedBy column exists';
END

-- Add ModifiedDate if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'Ledgers' AND COLUMN_NAME = 'ModifiedDate')
BEGIN
    ALTER TABLE Ledgers ADD ModifiedDate DATETIME NULL;
    PRINT '  ✓ Added ModifiedDate column';
END
ELSE
BEGIN
    PRINT '  ✓ ModifiedDate column exists';
END

PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION';
PRINT '========================================';

SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Ledgers'
ORDER BY ORDINAL_POSITION;

PRINT '';
PRINT '✓ LEDGERS TABLE STRUCTURE FIXED!';
PRINT '';
PRINT 'Now run: SETUP_INVENTORY_LEDGERS.sql';
GO
