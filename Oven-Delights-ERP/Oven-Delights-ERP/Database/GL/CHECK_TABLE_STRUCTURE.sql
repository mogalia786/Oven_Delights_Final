-- Check actual column names in BankStatementTransactions table
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'BankStatementTransactions'
ORDER BY ORDINAL_POSITION
