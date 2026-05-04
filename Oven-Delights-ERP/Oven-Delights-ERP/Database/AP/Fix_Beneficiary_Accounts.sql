-- =============================================
-- Fix Beneficiary Account Numbers
-- =============================================

PRINT '=============================================='
PRINT 'FIXING BENEFICIARY ACCOUNT NUMBERS'
PRINT '=============================================='
PRINT ''

-- Show current beneficiary accounts
PRINT 'Current beneficiary accounts:'
SELECT 
    BeneficiaryID,
    BeneficiaryName,
    AccountNumber AS CurrentAccount,
    BankName
FROM AP_Beneficiaries
ORDER BY BeneficiaryID
GO

PRINT ''
PRINT '=============================================='
PRINT 'Updating beneficiaries with wrong account numbers...'
PRINT ''

-- Update Durban Electricity to use test beneficiary account
UPDATE AP_Beneficiaries
SET AccountNumber = '63001730117',
    BranchCode = '250655'
WHERE BeneficiaryName = 'Durban Electricity'
  AND AccountNumber = '63001723469'

IF @@ROWCOUNT > 0
    PRINT '✓ Updated Durban Electricity to use beneficiary account 63001730117'
ELSE
    PRINT '- Durban Electricity already has correct account or not found'

PRINT ''

-- Update any other beneficiaries using your business accounts
UPDATE AP_Beneficiaries
SET AccountNumber = '63001731222',
    BranchCode = '250655'
WHERE AccountNumber IN ('63001723469', '63001731248')
  AND BeneficiaryName <> 'Durban Electricity'

IF @@ROWCOUNT > 0
    PRINT '✓ Updated other beneficiaries to use beneficiary account 63001731222'
ELSE
    PRINT '- No other beneficiaries needed updating'

PRINT ''
PRINT '=============================================='
PRINT 'Updated beneficiary accounts:'
SELECT 
    BeneficiaryID,
    BeneficiaryName,
    AccountNumber AS UpdatedAccount,
    BranchCode,
    BankName
FROM AP_Beneficiaries
ORDER BY BeneficiaryID
GO

PRINT ''
PRINT '=============================================='
PRINT 'SUMMARY:'
PRINT ''
PRINT 'FNB Test Accounts:'
PRINT '  Your Business (Debtor): 63001723469, 63001731248'
PRINT '  Beneficiaries (Creditor): 63001730117, 63001731222'
PRINT ''
PRINT 'All beneficiaries should now use: 63001730117 or 63001731222'
PRINT '=============================================='
GO
