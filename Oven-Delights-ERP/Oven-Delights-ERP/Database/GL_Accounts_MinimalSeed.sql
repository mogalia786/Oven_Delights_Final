-- Minimal GL Accounts Seed for quick SystemAccounts mapping (idempotent)
-- Azure SQL compatible
-- Timestamp: 10-Sep-2025 13:49 SAST

IF OBJECT_ID('dbo.Accounts','U') IS NULL
BEGIN
    RAISERROR('Accounts table missing. Run GL_Core_Tables.sql first.', 16, 1);
    RETURN;
END

-- Ensure key accounts exist by AccountCode; insert if missing
MERGE dbo.Accounts AS tgt
USING (VALUES
    ('1000','Inventory','Asset', NULL, 1),
    ('1001','GRNI Clearing','Asset', NULL, 1),
    ('1100','Bank - Default','Asset', NULL, 1),
    ('2000','Accounts Payable Control','Liability', NULL, 1),
    ('3000','Accounts Receivable Control','Asset', NULL, 1),
    ('4000','Sales','Revenue', NULL, 1),
    ('4001','Sales Returns','Revenue', NULL, 1),
    ('5000','Cost of Sales','Expense', NULL, 1),
    ('2100','VAT Input','Asset', NULL, 1),
    ('4100','VAT Output','Liability', NULL, 1),
    ('6100','Bank Charges','Expense', NULL, 1),
    ('6900','Rounding','Expense', NULL, 1)
) AS src(AccountCode, AccountName, AccountType, ParentAccountID, IsActive)
ON tgt.AccountCode = src.AccountCode
WHEN NOT MATCHED BY TARGET THEN
    INSERT (AccountCode, AccountName, AccountType, ParentAccountID, IsActive)
    VALUES (src.AccountCode, src.AccountName, src.AccountType, src.ParentAccountID, src.IsActive);
GO

-- Auto-map SystemAccounts based on these standard AccountCodes
IF OBJECT_ID('dbo.SystemAccounts','U') IS NULL
BEGIN
    RAISERROR('SystemAccounts table missing. Run GL_SystemAccounts_Seed.sql first.', 16, 1);
    RETURN;
END

UPDATE sa SET AccountID = a.AccountID
FROM dbo.SystemAccounts sa
JOIN dbo.Accounts a ON a.AccountCode = '2000'
WHERE sa.SysKey = 'AP_CONTROL' AND (sa.AccountID IS NULL OR sa.AccountID = 0);

UPDATE sa SET AccountID = a.AccountID
FROM dbo.SystemAccounts sa
JOIN dbo.Accounts a ON a.AccountCode = '3000'
WHERE sa.SysKey = 'AR_CONTROL' AND (sa.AccountID IS NULL OR sa.AccountID = 0);

UPDATE sa SET AccountID = a.AccountID
FROM dbo.SystemAccounts sa
JOIN dbo.Accounts a ON a.AccountCode = '1000'
WHERE sa.SysKey = 'INVENTORY' AND (sa.AccountID IS NULL OR sa.AccountID = 0);

UPDATE sa SET AccountID = a.AccountID
FROM dbo.SystemAccounts sa
JOIN dbo.Accounts a ON a.AccountCode = '1001'
WHERE sa.SysKey = 'GRNI' AND (sa.AccountID IS NULL OR sa.AccountID = 0);

UPDATE sa SET AccountID = a.AccountID
FROM dbo.SystemAccounts sa
JOIN dbo.Accounts a ON a.AccountCode = '4000'
WHERE sa.SysKey = 'SALES' AND (sa.AccountID IS NULL OR sa.AccountID = 0);

UPDATE sa SET AccountID = a.AccountID
FROM dbo.SystemAccounts sa
JOIN dbo.Accounts a ON a.AccountCode = '4001'
WHERE sa.SysKey = 'SALES_RETURNS' AND (sa.AccountID IS NULL OR sa.AccountID = 0);

UPDATE sa SET AccountID = a.AccountID
FROM dbo.SystemAccounts sa
JOIN dbo.Accounts a ON a.AccountCode = '5000'
WHERE sa.SysKey = 'COS' AND (sa.AccountID IS NULL OR sa.AccountID = 0);

UPDATE sa SET AccountID = a.AccountID
FROM dbo.SystemAccounts sa
JOIN dbo.Accounts a ON a.AccountCode = '2100'
WHERE sa.SysKey = 'VAT_INPUT' AND (sa.AccountID IS NULL OR sa.AccountID = 0);

UPDATE sa SET AccountID = a.AccountID
FROM dbo.SystemAccounts sa
JOIN dbo.Accounts a ON a.AccountCode = '4100'
WHERE sa.SysKey = 'VAT_OUTPUT' AND (sa.AccountID IS NULL OR sa.AccountID = 0);

UPDATE sa SET AccountID = a.AccountID
FROM dbo.SystemAccounts sa
JOIN dbo.Accounts a ON a.AccountCode = '1100'
WHERE sa.SysKey = 'BANK_DEFAULT' AND (sa.AccountID IS NULL OR sa.AccountID = 0);

UPDATE sa SET AccountID = a.AccountID
FROM dbo.SystemAccounts sa
JOIN dbo.Accounts a ON a.AccountCode = '6100'
WHERE sa.SysKey = 'BANK_CHARGES' AND (sa.AccountID IS NULL OR sa.AccountID = 0);

UPDATE sa SET AccountID = a.AccountID
FROM dbo.SystemAccounts sa
JOIN dbo.Accounts a ON a.AccountCode = '6900'
WHERE sa.SysKey = 'ROUNDING' AND (sa.AccountID IS NULL OR sa.AccountID = 0);
GO
