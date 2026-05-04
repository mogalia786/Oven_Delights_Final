-- =============================================
-- CRITICAL: ACCOUNT CODE INCONSISTENCY ANALYSIS
-- =============================================

PRINT '========================================='
PRINT 'ACCOUNT CODE INCONSISTENCY ANALYSIS'
PRINT '========================================='
PRINT ''

-- Check what bank and cash account codes actually exist and are being used
PRINT 'Checking Bank Account codes...'
SELECT 
    AccountID,
    AccountCode,
    AccountName,
    AccountType,
    IsActive
FROM ChartOfAccounts
WHERE (AccountCode LIKE '10%' OR AccountCode LIKE '11%')
    AND (AccountName LIKE '%Bank%' OR AccountName LIKE '%Cash%')
ORDER BY AccountCode

PRINT ''
PRINT 'Checking which codes are used in POS procedures...'
PRINT 'POS procedures use:'
PRINT '  - Bank: 1010'
PRINT '  - Cash: 1030'
PRINT '  - EFT Debtors: 1050'
PRINT ''

PRINT 'Checking which codes are used in Bank Statement procedures...'
PRINT 'Bank Statement procedures use:'
PRINT '  - Bank: 1120'
PRINT '  - Cash: 1110'
PRINT ''

PRINT '========================================='
PRINT 'CRITICAL ISSUE IDENTIFIED'
PRINT '========================================='
PRINT ''
PRINT 'PROBLEM: Different procedures use different account codes for same accounts'
PRINT ''
PRINT 'IMPACT:'
PRINT '  1. POS card sales post to Bank 1010'
PRINT '  2. Bank statement reconciliation looks for Bank 1120'
PRINT '  3. These never match - causing duplicate entries'
PRINT ''
PRINT 'SOLUTION REQUIRED:'
PRINT '  1. Determine which account codes are ACTUALLY in use'
PRINT '  2. Standardize ALL procedures to use same codes'
PRINT '  3. Update Chart of Accounts if needed'
PRINT ''

-- Show current GL entries to see which codes are actually being used
PRINT 'Checking recent GL entries to see which accounts are actually being posted to...'
SELECT TOP 20
    gl.EntryID,
    gl.JournalEntryNumber,
    gl.AccountID,
    coa.AccountCode,
    coa.AccountName,
    gl.DebitAmount,
    gl.CreditAmount,
    gl.Description,
    gl.TransactionDate
FROM GeneralLedger gl
LEFT JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID
WHERE gl.TransactionDate >= DATEADD(day, -30, GETDATE())
ORDER BY gl.EntryID DESC

PRINT ''
PRINT '========================================='
PRINT 'RECOMMENDED ACTION'
PRINT '========================================='
PRINT ''
PRINT 'Based on the GL entries above, determine:'
PRINT '  1. Which Bank account code is actually in use (1010 or 1120)?'
PRINT '  2. Which Cash account code is actually in use (1030 or 1110)?'
PRINT ''
PRINT 'Then standardize ALL procedures to use the SAME codes'
PRINT ''
GO
