-- GL System Accounts Seed (idempotent)
-- Azure SQL compatible
-- Timestamp: 10-Sep-2025 13:04 SAST

IF OBJECT_ID('dbo.SystemAccounts','U') IS NULL
BEGIN
    CREATE TABLE dbo.SystemAccounts (
        SysKey    VARCHAR(64) NOT NULL PRIMARY KEY,
        AccountID INT NULL
    );
END
GO

;WITH Keys(SysKey) AS (
    SELECT 'AP_CONTROL' UNION ALL
    SELECT 'AR_CONTROL' UNION ALL
    SELECT 'INVENTORY' UNION ALL
    SELECT 'GRNI' UNION ALL
    SELECT 'PURCHASE_RETURNS' UNION ALL
    SELECT 'SALES' UNION ALL
    SELECT 'SALES_RETURNS' UNION ALL
    SELECT 'COS' UNION ALL
    SELECT 'VAT_INPUT' UNION ALL
    SELECT 'VAT_OUTPUT' UNION ALL
    SELECT 'BANK_DEFAULT' UNION ALL
    SELECT 'BANK_CHARGES' UNION ALL
    SELECT 'ROUNDING'
)
MERGE dbo.SystemAccounts AS tgt
USING Keys AS src
ON tgt.SysKey = src.SysKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (SysKey, AccountID) VALUES (src.SysKey, NULL)
-- Note: we intentionally do not delete extra keys; no action when not matched by source
;
GO
