-- =============================================
-- Delete the incorrectly created sp_CreatePaymentBatch
-- The system should use sp_AP_CreatePaymentBatch instead
-- =============================================

IF OBJECT_ID('dbo.sp_CreatePaymentBatch', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.sp_CreatePaymentBatch
    PRINT 'Dropped incorrect sp_CreatePaymentBatch procedure'
END
ELSE
BEGIN
    PRINT 'sp_CreatePaymentBatch does not exist - nothing to drop'
END
GO

PRINT ''
PRINT 'The system should use sp_AP_CreatePaymentBatch instead'
PRINT 'BatchPaymentForm.vb needs to be updated to call the correct procedure'
GO
