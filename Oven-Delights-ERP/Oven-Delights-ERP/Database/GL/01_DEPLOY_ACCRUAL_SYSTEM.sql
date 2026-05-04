-- =============================================
-- DEPLOY ACCRUAL ACCOUNTING SYSTEM
-- Run this to get the correct procedures for your model
-- =============================================

PRINT '========================================='
PRINT 'DEPLOYING ACCRUAL ACCOUNTING SYSTEM'
PRINT '========================================='
PRINT ''

-- Drop old/conflicting procedures from BANK_RECONCILIATION_SOLUTION.sql
PRINT 'Removing old procedures...'

IF OBJECT_ID('sp_ReconcileBankStatement', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE sp_ReconcileBankStatement
    PRINT '✓ Dropped sp_ReconcileBankStatement (old matching logic)'
END

IF OBJECT_ID('sp_PostUnmatchedBankItems', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE sp_PostUnmatchedBankItems
    PRINT '✓ Dropped sp_PostUnmatchedBankItems (old logic)'
END

IF OBJECT_ID('sp_AutoMapBankTransactions', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE sp_AutoMapBankTransactions
    PRINT '✓ Dropped sp_AutoMapBankTransactions (old logic)'
END

PRINT ''
PRINT 'Now run ACCRUAL_ACCOUNTING_SYSTEM.sql to create the correct procedures'
PRINT ''
GO
