-- =============================================
-- Update Test Bank Account to FNB Sandbox Account
-- =============================================

-- Update existing test account to use correct FNB sandbox account number
UPDATE BankAccounts
SET AccountNumber = '63001723469',
    AccountName = 'Test Business Account - FNB (62123456789)',
    BranchCode = '250655',
    FNBAccountID = 'FNB-SANDBOX-001'
WHERE AccountNumber = '62123456789'

IF @@ROWCOUNT > 0
    PRINT '✓ Updated test bank account to FNB sandbox account: 63001723469'
ELSE
    PRINT '⚠ No account with number 62123456789 found'

-- If no account was updated, check if sandbox account already exists
IF NOT EXISTS (SELECT 1 FROM BankAccounts WHERE AccountNumber = '63001723469')
BEGIN
    PRINT ''
    PRINT 'Creating new FNB sandbox account...'
    
    DECLARE @BankGLAcctID INT
    SELECT @BankGLAcctID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1120'
    
    INSERT INTO BankAccounts (
        AccountName, 
        BankName, 
        AccountNumber, 
        BranchCode, 
        AccountType, 
        Currency, 
        GLAccountID, 
        IsActive, 
        IsPrimaryAccount, 
        FNBAccountID
    )
    VALUES (
        'Test Business Account - FNB (62123456789)', 
        'FNB', 
        '63001723469', 
        '250655', 
        'Cheque', 
        'ZAR', 
        @BankGLAcctID, 
        1, 
        1, 
        'FNB-SANDBOX-001'
    )
    
    PRINT '✓ Created FNB sandbox account: 63001723469'
END
ELSE
BEGIN
    PRINT '✓ FNB sandbox account already exists: 63001723469'
END

PRINT ''
PRINT 'Verification:'
SELECT 
    BankAccountID,
    AccountName,
    BankName,
    AccountNumber,
    BranchCode,
    FNBAccountID,
    IsActive
FROM BankAccounts
WHERE AccountNumber IN ('62123456789', '63001723469')
ORDER BY AccountNumber

PRINT ''
PRINT '=============================================='
PRINT 'Bank Account Update Complete'
PRINT '=============================================='
GO
