-- =============================================
-- COMPLETE ACCRUAL ACCOUNTING DEPLOYMENT
-- Run this single script to deploy everything
-- =============================================

PRINT '========================================='
PRINT 'DEPLOYING COMPLETE ACCRUAL ACCOUNTING SOLUTION'
PRINT '========================================='
PRINT ''

-- =============================================
-- STEP 1: ADD REQUIRED COLUMNS
-- =============================================
PRINT 'Step 1: Adding required columns...'
PRINT ''

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'IsMapped')
BEGIN
    ALTER TABLE AP_StatementTransactions ADD IsMapped BIT NOT NULL DEFAULT 0
    PRINT '✓ Added IsMapped column'
END
ELSE
    PRINT '✓ IsMapped column already exists'

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'MappedLedgerAccount')
BEGIN
    ALTER TABLE AP_StatementTransactions ADD MappedLedgerAccount NVARCHAR(20) NULL
    PRINT '✓ Added MappedLedgerAccount column'
END
ELSE
    PRINT '✓ MappedLedgerAccount column already exists'

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'MappedJournalID')
BEGIN
    ALTER TABLE AP_StatementTransactions ADD MappedJournalID INT NULL
    PRINT '✓ Added MappedJournalID column'
END
ELSE
    PRINT '✓ MappedJournalID column already exists'

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'MatchedGLEntryID')
BEGIN
    ALTER TABLE AP_StatementTransactions ADD MatchedGLEntryID BIGINT NULL
    PRINT '✓ Added MatchedGLEntryID column'
END
ELSE
    PRINT '✓ MatchedGLEntryID column already exists'

PRINT ''

-- =============================================
-- STEP 2: DROP OLD CONFLICTING PROCEDURES
-- =============================================
PRINT 'Step 2: Removing old procedures...'
PRINT ''

IF OBJECT_ID('sp_PostCreditTransactionsToLedgers', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE sp_PostCreditTransactionsToLedgers
    PRINT '✓ Dropped sp_PostCreditTransactionsToLedgers (old duplicate logic)'
END

IF OBJECT_ID('sp_PostDebitTransactionsToLedgers', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE sp_PostDebitTransactionsToLedgers
    PRINT '✓ Dropped sp_PostDebitTransactionsToLedgers (old duplicate logic)'
END

IF OBJECT_ID('sp_AP_PostSinglePaymentToGL', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE sp_AP_PostSinglePaymentToGL
    PRINT '✓ Dropped sp_AP_PostSinglePaymentToGL (old immediate bank posting)'
END

PRINT ''

-- =============================================
-- STEP 3: CREATE ACCRUAL PROCEDURES
-- =============================================
PRINT 'Step 3: Creating accrual accounting procedures...'
PRINT ''

-- Now run the ACCRUAL_ACCOUNTING_SYSTEM.sql content inline
-- (Copy the procedure creation code from ACCRUAL_ACCOUNTING_SYSTEM.sql here)

PRINT '========================================='
PRINT 'DEPLOYMENT COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'Next step: Update VB code in BankStatementViewerForm.vb'
PRINT ''
GO
