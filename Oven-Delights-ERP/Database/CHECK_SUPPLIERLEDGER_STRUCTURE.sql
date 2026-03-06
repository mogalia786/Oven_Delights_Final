-- Check SupplierLedger table structure
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SupplierLedger'
ORDER BY ORDINAL_POSITION;

-- Check if the table exists
SELECT 
    CASE WHEN EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SupplierLedger') 
    THEN 'SupplierLedger table EXISTS' 
    ELSE 'SupplierLedger table DOES NOT EXIST' 
    END AS TableStatus;

-- If table doesn't exist, check for similar tables
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME LIKE '%Supplier%' OR TABLE_NAME LIKE '%Ledger%'
ORDER BY TABLE_NAME;
