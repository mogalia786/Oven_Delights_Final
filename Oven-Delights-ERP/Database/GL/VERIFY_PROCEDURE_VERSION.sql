-- Check if the updated procedure is deployed on Azure

-- 1. Check procedure definition for the shortened journal number logic
SELECT 
    OBJECT_NAME(object_id) AS ProcedureName,
    CASE 
        WHEN definition LIKE '%DECLARE @SequenceNumber NVARCHAR(10) = RIGHT(@InvoiceNumber, CHARINDEX(''-'', REVERSE(@InvoiceNumber)) - 1)%' 
        THEN '✓ UPDATED VERSION (with shortened journal number)'
        ELSE '✗ OLD VERSION (still using full invoice number)'
    END AS Version,
    create_date AS Created
FROM sys.sql_modules
WHERE object_id = OBJECT_ID('sp_POS_PostSaleToGL')

-- 2. Show the actual journal number generation code
PRINT ''
PRINT 'Current journal number generation code:'
PRINT '========================================'
SELECT definition
FROM sys.sql_modules
WHERE object_id = OBJECT_ID('sp_POS_PostSaleToGL')
