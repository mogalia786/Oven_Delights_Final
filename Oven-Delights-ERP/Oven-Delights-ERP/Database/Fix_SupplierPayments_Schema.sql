-- Fix SupplierPayments table schema to ensure PaymentAmount column exists
-- This script checks for the column and adds it if missing

-- Check if PaymentAmount column exists
IF NOT EXISTS (
    SELECT 1 
    FROM sys.columns 
    WHERE object_id = OBJECT_ID('dbo.SupplierPayments') 
    AND name = 'PaymentAmount'
)
BEGIN
    PRINT 'PaymentAmount column does not exist. Checking for alternative column names...'
    
    -- Check if there's an 'Amount' column instead
    IF EXISTS (
        SELECT 1 
        FROM sys.columns 
        WHERE object_id = OBJECT_ID('dbo.SupplierPayments') 
        AND name = 'Amount'
    )
    BEGIN
        PRINT 'Found Amount column. Renaming to PaymentAmount...'
        EXEC sp_rename 'dbo.SupplierPayments.Amount', 'PaymentAmount', 'COLUMN'
        PRINT 'Column renamed successfully.'
    END
    ELSE
    BEGIN
        PRINT 'No Amount column found. Adding PaymentAmount column...'
        ALTER TABLE dbo.SupplierPayments
        ADD PaymentAmount DECIMAL(18,4) NOT NULL DEFAULT(0)
        PRINT 'PaymentAmount column added successfully.'
    END
END
ELSE
BEGIN
    PRINT 'PaymentAmount column already exists.'
END
GO

-- Display current schema
PRINT ''
PRINT 'Current SupplierPayments table schema:'
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SupplierPayments'
ORDER BY ORDINAL_POSITION
GO
