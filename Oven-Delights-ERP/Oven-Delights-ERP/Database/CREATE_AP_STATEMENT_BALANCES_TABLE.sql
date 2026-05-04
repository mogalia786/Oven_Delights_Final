-- =============================================
-- Create AP_StatementBalances Table
-- Purpose: Store bank account balance information from FNB statements
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AP_StatementBalances]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[AP_StatementBalances](
        [BalanceID] [int] IDENTITY(1,1) NOT NULL,
        [AccountNumber] [nvarchar](50) NOT NULL,
        [BalanceType] [nvarchar](10) NULL,  -- OPBD (Opening Balance), CLBD (Closing Balance), etc.
        [Amount] [decimal](18, 2) NOT NULL,
        [Currency] [nvarchar](3) NULL DEFAULT 'ZAR',
        [CreditDebitIndicator] [nvarchar](10) NULL,  -- Credit or Debit
        [BalanceDate] [date] NULL,
        [FetchedBy] [nvarchar](100) NULL,
        [FetchedDate] [datetime] NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [PK_AP_StatementBalances] PRIMARY KEY CLUSTERED ([BalanceID] ASC)
    )

    PRINT 'Table AP_StatementBalances created successfully'
END
ELSE
BEGIN
    PRINT 'Table AP_StatementBalances already exists'
END
GO

-- Create index for faster lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_AP_StatementBalances_AccountDate' AND object_id = OBJECT_ID('AP_StatementBalances'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_AP_StatementBalances_AccountDate]
    ON [dbo].[AP_StatementBalances] ([AccountNumber], [BalanceDate] DESC)
    INCLUDE ([BalanceType], [Amount], [CreditDebitIndicator])
    
    PRINT 'Index IX_AP_StatementBalances_AccountDate created successfully'
END
GO

-- =============================================
-- Create View for Latest Balances
-- =============================================
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_AP_LatestAccountBalances')
    DROP VIEW [dbo].[vw_AP_LatestAccountBalances]
GO

CREATE VIEW [dbo].[vw_AP_LatestAccountBalances]
AS
SELECT 
    AccountNumber,
    MAX(CASE WHEN BalanceType = 'OPBD' THEN Amount END) AS OpeningBalance,
    MAX(CASE WHEN BalanceType = 'CLBD' THEN Amount END) AS ClosingBalance,
    MAX(CASE WHEN BalanceType = 'OPBD' THEN CreditDebitIndicator END) AS OpeningBalanceType,
    MAX(CASE WHEN BalanceType = 'CLBD' THEN CreditDebitIndicator END) AS ClosingBalanceType,
    MAX(BalanceDate) AS BalanceDate,
    MAX(FetchedDate) AS LastFetchedDate
FROM (
    SELECT 
        AccountNumber,
        BalanceType,
        Amount,
        CreditDebitIndicator,
        BalanceDate,
        FetchedDate,
        ROW_NUMBER() OVER (PARTITION BY AccountNumber, BalanceType ORDER BY BalanceDate DESC, FetchedDate DESC) AS rn
    FROM AP_StatementBalances
) ranked
WHERE rn = 1
GROUP BY AccountNumber
GO

PRINT 'View vw_AP_LatestAccountBalances created successfully'
GO

-- =============================================
-- Sample Query to View Balances
-- =============================================
/*
-- View all balances for an account
SELECT 
    BalanceID,
    AccountNumber,
    BalanceType,
    CASE 
        WHEN BalanceType = 'OPBD' THEN 'Opening Balance'
        WHEN BalanceType = 'CLBD' THEN 'Closing Balance'
        ELSE BalanceType
    END AS BalanceDescription,
    Amount,
    Currency,
    CreditDebitIndicator,
    BalanceDate,
    FetchedBy,
    FetchedDate
FROM AP_StatementBalances
WHERE AccountNumber = '63001723469'
ORDER BY BalanceDate DESC, FetchedDate DESC

-- View latest balances using the view
SELECT 
    AccountNumber,
    OpeningBalance,
    ClosingBalance,
    CASE 
        WHEN OpeningBalanceType = 'Credit' THEN 'Positive'
        WHEN OpeningBalanceType = 'Debit' THEN 'Negative'
        ELSE OpeningBalanceType
    END AS OpeningStatus,
    CASE 
        WHEN ClosingBalanceType = 'Credit' THEN 'Positive'
        WHEN ClosingBalanceType = 'Debit' THEN 'Negative'
        ELSE ClosingBalanceType
    END AS ClosingStatus,
    BalanceDate,
    LastFetchedDate
FROM vw_AP_LatestAccountBalances
WHERE AccountNumber = '63001723469'
*/
