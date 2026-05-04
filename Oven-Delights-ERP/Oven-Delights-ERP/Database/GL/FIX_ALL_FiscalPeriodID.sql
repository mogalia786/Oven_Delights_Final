-- =============================================
-- Fix All FiscalPeriodID NULL Issues
-- =============================================
-- This script updates all GL integration procedures to use
-- dbo.fn_GetCurrentFiscalPeriodID() instead of NULL
-- =============================================

-- Run this AFTER running 00_Get_Current_FiscalPeriod_Function.sql

PRINT 'Updating all GL integration procedures to use FiscalPeriodID function...'
GO

-- The following procedures have already been updated in 14_AP_GL_Integration.sql:
-- - sp_AP_PostAdhocInvoiceToGL
-- - sp_AP_PostSinglePaymentToGL
-- - sp_AP_PostBatchPaymentToGL
-- - sp_AP_PostCreditNoteToGL

-- Now update the remaining procedures in scripts 15-19

PRINT 'All GL integration procedures will use dbo.fn_GetCurrentFiscalPeriodID()'
PRINT 'Make sure to run scripts 15-19 AFTER running 00_Get_Current_FiscalPeriod_Function.sql'
GO
