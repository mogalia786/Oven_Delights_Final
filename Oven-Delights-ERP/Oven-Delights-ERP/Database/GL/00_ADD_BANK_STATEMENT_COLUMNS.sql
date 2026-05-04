-- =============================================
-- ADD REQUIRED COLUMNS TO AP_STATEMENTTRANSACTIONS
-- Run this BEFORE ACCRUAL_ACCOUNTING_SYSTEM.sql
-- =============================================

PRINT '========================================='
PRINT 'ADDING COLUMNS TO AP_STATEMENTTRANSACTIONS'
PRINT '========================================='
PRINT ''

-- Add IsMapped column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'IsMapped')
BEGIN
    ALTER TABLE AP_StatementTransactions ADD IsMapped BIT NOT NULL DEFAULT 0
    PRINT '✓ Added IsMapped column'
END
ELSE
    PRINT '✓ IsMapped column already exists'

-- Add MappedLedgerAccount column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'MappedLedgerAccount')
BEGIN
    ALTER TABLE AP_StatementTransactions ADD MappedLedgerAccount NVARCHAR(20) NULL
    PRINT '✓ Added MappedLedgerAccount column'
END
ELSE
    PRINT '✓ MappedLedgerAccount column already exists'

-- Add MappedJournalID column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'MappedJournalID')
BEGIN
    ALTER TABLE AP_StatementTransactions ADD MappedJournalID INT NULL
    PRINT '✓ Added MappedJournalID column'
END
ELSE
    PRINT '✓ MappedJournalID column already exists'

-- Add MatchedGLEntryID column
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'MatchedGLEntryID')
BEGIN
    ALTER TABLE AP_StatementTransactions ADD MatchedGLEntryID BIGINT NULL
    PRINT '✓ Added MatchedGLEntryID column'
END
ELSE
    PRINT '✓ MatchedGLEntryID column already exists'

PRINT ''
PRINT '========================================='
PRINT 'COLUMNS ADDED SUCCESSFULLY'
PRINT '========================================='
PRINT ''
PRINT 'You can now run ACCRUAL_ACCOUNTING_SYSTEM.sql'
PRINT ''
GO
