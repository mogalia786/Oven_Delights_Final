-- Add Missing Columns to Accounting Tables
-- ==========================================

PRINT 'Adding missing columns to accounting tables...';
PRINT '';

-- Add CreatedBy to ChartOfAccounts if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'CreatedBy')
BEGIN
    ALTER TABLE ChartOfAccounts ADD CreatedBy NVARCHAR(100) NULL;
    PRINT '✓ Added CreatedBy to ChartOfAccounts';
END
ELSE
BEGIN
    PRINT '! CreatedBy already exists in ChartOfAccounts';
END
GO

-- Add CreatedDate to ChartOfAccounts if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'CreatedDate')
BEGIN
    ALTER TABLE ChartOfAccounts ADD CreatedDate DATETIME NULL DEFAULT GETDATE();
    PRINT '✓ Added CreatedDate to ChartOfAccounts';
END
ELSE
BEGIN
    PRINT '! CreatedDate already exists in ChartOfAccounts';
END
GO

-- Add ModifiedBy to ChartOfAccounts if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'ModifiedBy')
BEGIN
    ALTER TABLE ChartOfAccounts ADD ModifiedBy NVARCHAR(100) NULL;
    PRINT '✓ Added ModifiedBy to ChartOfAccounts';
END
ELSE
BEGIN
    PRINT '! ModifiedBy already exists in ChartOfAccounts';
END
GO

-- Add ModifiedDate to ChartOfAccounts if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'ModifiedDate')
BEGIN
    ALTER TABLE ChartOfAccounts ADD ModifiedDate DATETIME NULL;
    PRINT '✓ Added ModifiedDate to ChartOfAccounts';
END
ELSE
BEGIN
    PRINT '! ModifiedDate already exists in ChartOfAccounts';
END
GO

-- Add IsActive to ChartOfAccounts if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'IsActive')
BEGIN
    ALTER TABLE ChartOfAccounts ADD IsActive BIT NOT NULL DEFAULT 1;
    PRINT '✓ Added IsActive to ChartOfAccounts';
END
ELSE
BEGIN
    PRINT '! IsActive already exists in ChartOfAccounts';
END
GO

PRINT '';
PRINT '========================================';
PRINT 'Verification - ChartOfAccounts columns:';
PRINT '========================================';

SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ChartOfAccounts'
ORDER BY ORDINAL_POSITION;

PRINT '';
PRINT '✓ All columns added successfully!';
GO
