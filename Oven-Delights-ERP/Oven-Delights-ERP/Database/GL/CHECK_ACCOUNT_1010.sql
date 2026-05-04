-- Check all instances of account 1010
SELECT 
    AccountID,
    AccountCode,
    AccountName,
    IsControlAccount,
    IsSubsidiaryLedger,
    IsActive
FROM ChartOfAccounts
WHERE AccountCode = '1010'
ORDER BY AccountID
