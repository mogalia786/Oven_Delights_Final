-- =============================================
-- Add FNB Sandbox Debtor Account to BankAccounts Table
-- Fixed version - matches actual table structure
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
        CurrentBalance,
        IsActive,
        CreatedDate
    )
    VALUES (
        'FNB Main Operating Account - SANDBOX',
        '63001723469',
        'First National Bank',
        '250655',
        0.00,
        1,
        GETDATE()
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
        CurrentBalance,
        IsActive,
        CreatedDate
    )
    VALUES (
        'FNB Secondary Account - SANDBOX',
        '63001731248',
        'First National Bank',
        '250655',
        0.00,
        1,
        GETDATE()
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
GO
