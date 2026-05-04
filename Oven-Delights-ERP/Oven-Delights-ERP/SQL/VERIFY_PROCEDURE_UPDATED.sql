-- =============================================
-- VERIFY: Check if sp_CompleteReOrderProduct was updated
-- =============================================

PRINT '🔍 Checking if stored procedure was updated...';
PRINT '';

-- Check if procedure exists
IF OBJECT_ID('sp_CompleteReOrderProduct', 'P') IS NOT NULL
BEGIN
    PRINT '✅ sp_CompleteReOrderProduct exists';
    PRINT '';
    
    -- Get the procedure definition
    DECLARE @ProcDef NVARCHAR(MAX);
    SELECT @ProcDef = OBJECT_DEFINITION(OBJECT_ID('sp_CompleteReOrderProduct'));
    
    -- Check if it has the RetailStock update code
    IF @ProcDef LIKE '%UPDATE RetailStock%'
    BEGIN
        PRINT '✅ Procedure contains RetailStock update code';
    END
    ELSE
    BEGIN
        PRINT '❌ Procedure does NOT contain RetailStock update code!';
        PRINT '   The procedure was not updated correctly.';
        PRINT '   Run FIX_RETAIL_STOCK_SAFE.sql again.';
    END
    
    -- Check if it accepts INT for @CompletedBy
    IF @ProcDef LIKE '%@CompletedBy INT%'
    BEGIN
        PRINT '✅ Procedure accepts @CompletedBy as INT (correct)';
    END
    ELSE IF @ProcDef LIKE '%@CompletedBy NVARCHAR%'
    BEGIN
        PRINT '⚠️  Procedure still accepts @CompletedBy as NVARCHAR (old version)';
        PRINT '   Run FIX_RETAIL_STOCK_SAFE.sql to update it.';
    END
    
    PRINT '';
    PRINT '═══════════════════════════════════════════════';
    PRINT 'Procedure Definition (first 500 chars):';
    PRINT SUBSTRING(@ProcDef, 1, 500);
    PRINT '...';
END
ELSE
BEGIN
    PRINT '❌ sp_CompleteReOrderProduct does NOT exist!';
    PRINT '   Run FIX_RETAIL_STOCK_SAFE.sql to create it.';
END

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '📋 NEXT STEPS:';
PRINT '';
PRINT 'If procedure was NOT updated:';
PRINT '1. Run FIX_RETAIL_STOCK_SAFE.sql';
PRINT '2. Complete a product in Baker Production View';
PRINT '3. Check RetailStock table again';
PRINT '';
PRINT 'If procedure WAS updated but RetailStock is empty:';
PRINT '1. You need to complete a NEW product';
PRINT '2. Old completed products will not retroactively update';
PRINT '3. Only NEW completions will update RetailStock';
PRINT '═══════════════════════════════════════════════';
