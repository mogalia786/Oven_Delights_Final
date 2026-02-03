-- Check PaymentBatchItems table structure
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'PaymentBatchItems'
ORDER BY ORDINAL_POSITION
GO

-- Show sample data
SELECT TOP 5 * FROM PaymentBatchItems
GO

-- Check if InvoiceID exists and has data
SELECT 
    BatchItemID,
    BatchID,
    CASE 
        WHEN COLUMNPROPERTY(OBJECT_ID('PaymentBatchItems'), 'InvoiceID', 'ColumnId') IS NOT NULL THEN 'InvoiceID column exists'
        ELSE 'InvoiceID column MISSING'
    END AS InvoiceIDCheck
FROM PaymentBatchItems
WHERE 1=0
GO
