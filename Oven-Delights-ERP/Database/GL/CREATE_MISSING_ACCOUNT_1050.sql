-- Create missing GL account 1050 - Debtors (Uncleared EFT)

INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
VALUES ('1050', 'Debtors - Uncleared EFT', 'Asset', 1);

PRINT '✓ Created account 1050 - Debtors (Uncleared EFT)'

-- Verify creation
SELECT AccountCode, AccountName, AccountType, IsActive
FROM ChartOfAccounts
WHERE AccountCode = '1050'
