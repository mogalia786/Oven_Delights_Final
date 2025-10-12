-- GL Core Reporting Views (idempotent)
-- Azure SQL compatible
-- Timestamp: 10-Sep-2025 13:08 SAST

-- v_JournalLines_ByJournal
IF OBJECT_ID('dbo.v_JournalLines_ByJournal','V') IS NOT NULL
    DROP VIEW dbo.v_JournalLines_ByJournal;
GO
CREATE VIEW dbo.v_JournalLines_ByJournal
AS
SELECT 
    j.JournalID,
    j.JournalDate,
    j.Reference,
    j.Description,
    j.PostedFlag,
    jl.LineNumber,
    jl.AccountID,
    jl.Debit,
    jl.Credit,
    jl.LineDescription,
    jl.Reference1,
    jl.Reference2
FROM dbo.Journals j
INNER JOIN dbo.JournalLines jl ON jl.JournalID = j.JournalID;
GO

-- v_JournalLines_ByAccountWithRunning
IF OBJECT_ID('dbo.v_JournalLines_ByAccountWithRunning','V') IS NOT NULL
    DROP VIEW dbo.v_JournalLines_ByAccountWithRunning;
GO
CREATE VIEW dbo.v_JournalLines_ByAccountWithRunning
AS
SELECT 
    jl.AccountID,
    j.JournalDate,
    j.JournalID,
    jl.LineNumber,
    jl.Debit,
    jl.Credit,
    (SUM(jl.Debit - jl.Credit) OVER (PARTITION BY jl.AccountID ORDER BY j.JournalDate, j.JournalID, jl.LineNumber ROWS UNBOUNDED PRECEDING)) AS RunningBalance,
    jl.LineDescription,
    j.Reference,
    j.Description
FROM dbo.JournalLines jl
INNER JOIN dbo.Journals j ON j.JournalID = jl.JournalID;
GO

-- v_TrialBalance
IF OBJECT_ID('dbo.v_TrialBalance','V') IS NOT NULL
    DROP VIEW dbo.v_TrialBalance;
GO
CREATE VIEW dbo.v_TrialBalance
AS
SELECT 
    a.AccountID,
    a.AccountCode,
    a.AccountName,
    SUM(jl.Debit)   AS TotalDebit,
    SUM(jl.Credit)  AS TotalCredit,
    SUM(jl.Debit - jl.Credit) AS Balance
FROM dbo.Accounts a
LEFT JOIN dbo.JournalLines jl ON jl.AccountID = a.AccountID
LEFT JOIN dbo.Journals j ON j.JournalID = jl.JournalID
GROUP BY a.AccountID, a.AccountCode, a.AccountName;
GO

-- v_IncomeStatement (Revenue, Expense)
IF OBJECT_ID('dbo.v_IncomeStatement','V') IS NOT NULL
    DROP VIEW dbo.v_IncomeStatement;
GO
CREATE VIEW dbo.v_IncomeStatement
AS
SELECT 
    a.AccountID,
    a.AccountCode,
    a.AccountName,
    a.AccountType,
    SUM(ISNULL(jl.Debit,0))   AS TotalDebit,
    SUM(ISNULL(jl.Credit,0))  AS TotalCredit,
    SUM(ISNULL(jl.Debit,0) - ISNULL(jl.Credit,0)) AS Balance
FROM dbo.Accounts a
LEFT JOIN dbo.JournalLines jl ON jl.AccountID = a.AccountID
LEFT JOIN dbo.Journals j ON j.JournalID = jl.JournalID
WHERE a.AccountType IN ('Revenue','Expense')
GROUP BY a.AccountID, a.AccountCode, a.AccountName, a.AccountType;
GO

-- v_BalanceSheet (Asset, Liability, Equity)
IF OBJECT_ID('dbo.v_BalanceSheet','V') IS NOT NULL
    DROP VIEW dbo.v_BalanceSheet;
GO
CREATE VIEW dbo.v_BalanceSheet
AS
SELECT 
    a.AccountID,
    a.AccountCode,
    a.AccountName,
    a.AccountType,
    SUM(ISNULL(jl.Debit,0))   AS TotalDebit,
    SUM(ISNULL(jl.Credit,0))  AS TotalCredit,
    SUM(ISNULL(jl.Debit,0) - ISNULL(jl.Credit,0)) AS Balance
FROM dbo.Accounts a
LEFT JOIN dbo.JournalLines jl ON jl.AccountID = a.AccountID
LEFT JOIN dbo.Journals j ON j.JournalID = jl.JournalID
WHERE a.AccountType IN ('Asset','Liability','Equity')
GROUP BY a.AccountID, a.AccountCode, a.AccountName, a.AccountType;
GO

-- v_AR_AgeAnalysis (by AccountType = 'Asset')
IF OBJECT_ID('dbo.v_AR_AgeAnalysis','V') IS NOT NULL
    DROP VIEW dbo.v_AR_AgeAnalysis;
GO
CREATE VIEW dbo.v_AR_AgeAnalysis
AS
WITH Base AS (
    SELECT a.AccountID, a.AccountCode, a.AccountName, j.JournalDate, (jl.Debit - jl.Credit) AS Amount
    FROM dbo.Accounts a
    INNER JOIN dbo.JournalLines jl ON jl.AccountID = a.AccountID
    INNER JOIN dbo.Journals j ON j.JournalID = jl.JournalID
    WHERE a.AccountType = 'Asset'
)
SELECT 
    AccountID,
    AccountCode,
    AccountName,
    SUM(CASE WHEN DATEDIFF(day, JournalDate, CAST(SYSUTCDATETIME() AS date)) <= 30 THEN Amount ELSE 0 END) AS Bucket_0_30,
    SUM(CASE WHEN DATEDIFF(day, JournalDate, CAST(SYSUTCDATETIME() AS date)) BETWEEN 31 AND 60 THEN Amount ELSE 0 END) AS Bucket_31_60,
    SUM(CASE WHEN DATEDIFF(day, JournalDate, CAST(SYSUTCDATETIME() AS date)) BETWEEN 61 AND 90 THEN Amount ELSE 0 END) AS Bucket_61_90,
    SUM(CASE WHEN DATEDIFF(day, JournalDate, CAST(SYSUTCDATETIME() AS date)) > 90 THEN Amount ELSE 0 END) AS Bucket_90_plus,
    SUM(Amount) AS Total
FROM Base
GROUP BY AccountID, AccountCode, AccountName;
GO

-- v_AP_AgeAnalysis (by AccountType = 'Liability')
IF OBJECT_ID('dbo.v_AP_AgeAnalysis','V') IS NOT NULL
    DROP VIEW dbo.v_AP_AgeAnalysis;
GO
CREATE VIEW dbo.v_AP_AgeAnalysis
AS
WITH Base AS (
    SELECT a.AccountID, a.AccountCode, a.AccountName, j.JournalDate, (jl.Credit - jl.Debit) AS Amount
    FROM dbo.Accounts a
    INNER JOIN dbo.JournalLines jl ON jl.AccountID = a.AccountID
    INNER JOIN dbo.Journals j ON j.JournalID = jl.JournalID
    WHERE a.AccountType = 'Liability'
)
SELECT 
    AccountID,
    AccountCode,
    AccountName,
    SUM(CASE WHEN DATEDIFF(day, JournalDate, CAST(SYSUTCDATETIME() AS date)) <= 30 THEN Amount ELSE 0 END) AS Bucket_0_30,
    SUM(CASE WHEN DATEDIFF(day, JournalDate, CAST(SYSUTCDATETIME() AS date)) BETWEEN 31 AND 60 THEN Amount ELSE 0 END) AS Bucket_31_60,
    SUM(CASE WHEN DATEDIFF(day, JournalDate, CAST(SYSUTCDATETIME() AS date)) BETWEEN 61 AND 90 THEN Amount ELSE 0 END) AS Bucket_61_90,
    SUM(CASE WHEN DATEDIFF(day, JournalDate, CAST(SYSUTCDATETIME() AS date)) > 90 THEN Amount ELSE 0 END) AS Bucket_90_plus,
    SUM(Amount) AS Total
FROM Base
GROUP BY AccountID, AccountCode, AccountName;
GO
