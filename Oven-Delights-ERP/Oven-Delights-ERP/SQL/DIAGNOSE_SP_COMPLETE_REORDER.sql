/*
    DIAGNOSE sp_CompleteReOrderProduct
    
    Check what's actually wrong with the stored procedure
*/

PRINT '========================================';
PRINT 'DIAGNOSING sp_CompleteReOrderProduct';
PRINT '========================================';
PRINT '';

-- Get the full procedure definition
IF OBJECT_ID('sp_CompleteReOrderProduct', 'P') IS NOT NULL
BEGIN
    PRINT '✅ Procedure exists';
    PRINT '';
    PRINT 'PROCEDURE DEFINITION:';
    PRINT '----------------------------------------';
    
    DECLARE @ProcDef NVARCHAR(MAX);
    SELECT @ProcDef = OBJECT_DEFINITION(OBJECT_ID('sp_CompleteReOrderProduct'));
    
    -- Print the definition
    PRINT @ProcDef;
    PRINT '';
    PRINT '----------------------------------------';
    PRINT '';
    
    -- Check for specific issues
    IF @ProcDef LIKE '%Demo_Retail_Product%'
        PRINT '✅ Uses Demo_Retail_Product table';
    ELSE
        PRINT '❌ Does NOT use Demo_Retail_Product table';
        
    IF @ProcDef LIKE '%RetailStock%'
        PRINT '✅ Updates RetailStock table';
    ELSE
        PRINT '❌ Does NOT update RetailStock table';
        
    IF @ProcDef LIKE '%ReOrderBooks%'
        PRINT '✅ Uses ReOrderBooks (plural)';
    ELSE
        PRINT '❌ Uses wrong table name';
        
    IF @ProcDef LIKE '%@@TRANCOUNT%'
        PRINT '✅ Has transaction handling';
    ELSE
        PRINT '❌ Missing transaction handling';
END
ELSE
BEGIN
    PRINT '❌ Procedure does NOT exist!';
END
GO

PRINT '';
PRINT '========================================';
PRINT 'CHECKING TABLES REFERENCED';
PRINT '========================================';
PRINT '';

-- Check if tables exist
IF OBJECT_ID('ReOrderBooks', 'U') IS NOT NULL
    PRINT '✅ ReOrderBooks table exists';
ELSE
    PRINT '❌ ReOrderBooks table does NOT exist';

IF OBJECT_ID('ReOrderBookLines', 'U') IS NOT NULL
    PRINT '✅ ReOrderBookLines table exists';
ELSE
    PRINT '❌ ReOrderBookLines table does NOT exist';

IF OBJECT_ID('Demo_Retail_Product', 'U') IS NOT NULL
    PRINT '✅ Demo_Retail_Product table exists';
ELSE
    PRINT '❌ Demo_Retail_Product table does NOT exist';

IF OBJECT_ID('RetailStock', 'U') IS NOT NULL
    PRINT '✅ RetailStock table exists';
ELSE
    PRINT '❌ RetailStock table does NOT exist';

IF OBJECT_ID('StockMovements', 'U') IS NOT NULL
    PRINT '✅ StockMovements table exists';
ELSE
    PRINT '❌ StockMovements table does NOT exist';

PRINT '';
PRINT '✅ Diagnosis complete!';
