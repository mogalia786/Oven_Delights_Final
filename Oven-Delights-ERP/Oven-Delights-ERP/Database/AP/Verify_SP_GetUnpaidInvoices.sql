-- =============================================
-- Verify sp_GetUnpaidInvoices Stored Procedure
-- =============================================

PRINT '=============================================='
PRINT 'STORED PROCEDURE VERIFICATION'
PRINT '=============================================='
PRINT ''

-- Check if stored procedure exists
IF OBJECT_ID('dbo.sp_GetUnpaidInvoices', 'P') IS NOT NULL
BEGIN
    PRINT '✓ sp_GetUnpaidInvoices exists'
    PRINT ''
    
    -- Show the stored procedure definition
    PRINT 'Current stored procedure definition:'
    PRINT ''
    SELECT OBJECT_DEFINITION(OBJECT_ID('dbo.sp_GetUnpaidInvoices'))
    PRINT ''
END
ELSE
BEGIN
    PRINT '✗ sp_GetUnpaidInvoices does NOT exist!'
    PRINT ''
    PRINT 'ACTION REQUIRED: Run the sp_GetUnpaidInvoices.sql script to create it'
END

PRINT ''
PRINT '=============================================='
PRINT 'TEST EXECUTION:'
PRINT ''

-- Execute the stored procedure
EXEC sp_GetUnpaidInvoices @SupplierID = 0

PRINT ''
PRINT '=============================================='
PRINT 'EXPECTED RESULTS:'
PRINT 'Should show invoices from AP_Invoices table'
PRINT 'With Status = ''Pending'' or ''Overdue'''
PRINT 'Joined to AP_Beneficiaries table'
PRINT ''
PRINT 'If results show different table or Status = ''Unpaid'':'
PRINT '- The stored procedure definition is outdated'
PRINT '- Re-run sp_GetUnpaidInvoices.sql to update it'
PRINT '=============================================='
GO
