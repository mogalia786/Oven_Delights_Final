-- List all GL accounts to find the correct ones for GL Inquiry

SELECT 
    AccountCode,
    AccountName,
    AccountType,
    IsActive
FROM ChartOfAccounts
WHERE AccountCode LIKE '4%' OR AccountCode LIKE '2%'
ORDER BY AccountCode
