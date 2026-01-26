-- =============================================
-- Add FNB Sandbox Debtor Account to BankAccounts Table
-- This is YOUR company's bank account (where money comes FROM)
-- =============================================

USE Oven_Delights_Main
GO

PRINT 'Adding FNB Sandbox Debtor Account to BankAccounts table...'
GO

-- Check if sandbox account already exists
IF NOT EXISTS (SELECT 1 FROM BankAccounts WHERE AccountNumber = '63001723469')
BEGIN
    INSERT INTO BankAccounts (
        AccountName,
        AccountNumber,
        BankName,
        BranchCode,
        AccountType,
        CurrentBalance,
        IsActive,
        CreatedDate,
        Notes
    )
    VALUES (
        'FNB Main Operating Account - SANDBOX',
        '63001723469',                    -- Sandbox Debtor Account 1
        'First National Bank',
        '250655',
        'Current Account',
        0.00,                             -- Starting balance (sandbox - not real money)
        1,                                -- Active
        GETDATE(),
        '*** SANDBOX TESTING ACCOUNT - FNB Payment Execution API Integration ***'
    )
    
    PRINT 'Added FNB Sandbox Debtor Account: 63001723469'
END
ELSE
BEGIN
    PRINT 'FNB Sandbox Debtor Account already exists'
END
GO

-- Optionally add second sandbox debtor account
IF NOT EXISTS (SELECT 1 FROM BankAccounts WHERE AccountNumber = '63001731248')
BEGIN
    INSERT INTO BankAccounts (
        AccountName,
        AccountNumber,
        BankName,
        BranchCode,
        AccountType,
        CurrentBalance,
        IsActive,
        CreatedDate,
        Notes
    )
    VALUES (
        'FNB Secondary Account - SANDBOX',
        '63001731248',                    -- Sandbox Debtor Account 2
        'First National Bank',
        '250655',
        'Current Account',
        0.00,
        1,
        GETDATE(),
        '*** SANDBOX TESTING ACCOUNT - FNB Payment Execution API Integration ***'
    )
    
    PRINT 'Added FNB Sandbox Debtor Account 2: 63001731248'
END
ELSE
BEGIN
    PRINT 'FNB Sandbox Debtor Account 2 already exists'
END
GO

-- Verify accounts were added
PRINT ''
PRINT 'Current FNB Sandbox Accounts in BankAccounts table:'
SELECT 
    BankAccountID,
    AccountName,
    AccountNumber,
    BankName,
    BranchCode,
    CurrentBalance,
    IsActive
FROM BankAccounts
WHERE AccountNumber IN ('63001723469', '63001731248')
GO

PRINT ''
PRINT '=============================================='
PRINT 'FNB Sandbox Bank Accounts added successfully'
PRINT '=============================================='
PRINT ''
PRINT 'These accounts will now appear in the Bank Account dropdown'
PRINT 'on the Batch Invoice Payment form.'
PRINT ''
PRINT 'IMPORTANT: These are SANDBOX accounts for testing only.'
PRINT 'No real money will be transferred.'
PRINT '=============================================='
GO
