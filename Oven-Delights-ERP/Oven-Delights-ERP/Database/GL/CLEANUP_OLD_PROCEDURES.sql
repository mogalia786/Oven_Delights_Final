-- =============================================
-- CLEANUP OLD BANK RECONCILIATION PROCEDURES
-- Run this before ACCRUAL_ACCOUNTING_SYSTEM.sql
-- =============================================

PRINT '========================================='
PRINT 'REMOVING OLD PROCEDURES'
PRINT '========================================='
PRINT ''

-- Drop old procedures from BANK_RECONCILIATION_SOLUTION.sql
IF OBJECT_ID('sp_ReconcileBankStatement', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE sp_ReconcileBankStatement
    PRINT '✓ Dropped sp_ReconcileBankStatement'
END
ELSE
    PRINT '- sp_ReconcileBankStatement not found'

IF OBJECT_ID('sp_PostUnmatchedBankItems', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE sp_PostUnmatchedBankItems
    PRINT '✓ Dropped sp_PostUnmatchedBankItems'
END
ELSE
    PRINT '- sp_PostUnmatchedBankItems not found'

IF OBJECT_ID('sp_AutoMapBankTransactions', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE sp_AutoMapBankTransactions
    PRINT '✓ Dropped sp_AutoMapBankTransactions'
END
ELSE
    PRINT '- sp_AutoMapBankTransactions not found'

PRINT ''
PRINT '========================================='
PRINT 'CLEANUP COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'Now run ACCRUAL_ACCOUNTING_SYSTEM.sql'
PRINT ''
GO
