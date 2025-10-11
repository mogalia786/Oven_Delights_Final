-- =============================================
-- General Ledger Views and Stored Procedures
-- For viewing ledgers, journals, and account activity
-- =============================================

USE [Oven_Delights_Main]
GO

-- =============================================
-- 1. View: Trial Balance
-- =============================================
IF OBJECT_ID('dbo.vw_TrialBalance', 'V') IS NOT NULL
    DROP VIEW dbo.vw_TrialBalance;
GO

CREATE VIEW dbo.vw_TrialBalance
AS
SELECT 
    coa.AccountID,
    coa.AccountCode,
    coa.AccountName,
    coa.AccountType,
    coa.ParentAccountID,
    ISNULL(SUM(CASE WHEN jd.Debit > 0 THEN jd.Debit ELSE 0 END), 0) AS TotalDebit,
    ISNULL(SUM(CASE WHEN jd.Credit > 0 THEN jd.Credit ELSE 0 END), 0) AS TotalCredit,
    ISNULL(SUM(jd.Debit - jd.Credit), 0) AS NetBalance,
    COUNT(jd.JournalDetailID) AS TransactionCount
FROM (
    SELECT AccountID, AccountCode, AccountName, AccountType, ParentAccountID, IsActive FROM ChartOfAccounts WHERE OBJECT_ID('ChartOfAccounts', 'U') IS NOT NULL
    UNION ALL
    SELECT AccountID, AccountNumber AS AccountCode, AccountName, AccountType, ParentAccountID, IsActive FROM GLAccounts WHERE OBJECT_ID('GLAccounts', 'U') IS NOT NULL
) coa
LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID AND jh.IsPosted = 1
WHERE coa.IsActive = 1
GROUP BY coa.AccountID, coa.AccountCode, coa.AccountName, coa.AccountType, coa.ParentAccountID;
GO

PRINT 'Created view: vw_TrialBalance';
GO

-- =============================================
-- 2. Stored Procedure: Get Trial Balance
-- =============================================
IF OBJECT_ID('dbo.sp_GetTrialBalance', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetTrialBalance;
GO

CREATE PROCEDURE dbo.sp_GetTrialBalance
    @FromDate DATE = NULL,
    @ToDate DATE = NULL,
    @BranchID INT = NULL,
    @AccountType NVARCHAR(50) = NULL,
    @ShowZeroBalances BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        coa.AccountCode,
        coa.AccountName,
        coa.AccountType,
        ISNULL(SUM(CASE WHEN jd.Debit > 0 THEN jd.Debit ELSE 0 END), 0) AS TotalDebit,
        ISNULL(SUM(CASE WHEN jd.Credit > 0 THEN jd.Credit ELSE 0 END), 0) AS TotalCredit,
        ISNULL(SUM(jd.Debit - jd.Credit), 0) AS NetBalance,
        COUNT(jd.JournalDetailID) AS TransactionCount
    FROM (
        SELECT AccountID, AccountCode, AccountName, AccountType, IsActive FROM ChartOfAccounts WHERE OBJECT_ID('ChartOfAccounts', 'U') IS NOT NULL
        UNION ALL
        SELECT AccountID, AccountNumber AS AccountCode, AccountName, AccountType, IsActive FROM GLAccounts WHERE OBJECT_ID('GLAccounts', 'U') IS NOT NULL
    ) coa
    LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
    LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
    WHERE coa.IsActive = 1
      AND jh.IsPosted = 1
      AND (@FromDate IS NULL OR jh.JournalDate >= @FromDate)
      AND (@ToDate IS NULL OR jh.JournalDate <= @ToDate)
      AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
      AND (@AccountType IS NULL OR coa.AccountType = @AccountType)
    GROUP BY coa.AccountCode, coa.AccountName, coa.AccountType
    HAVING @ShowZeroBalances = 1 OR ISNULL(SUM(jd.Debit - jd.Credit), 0) <> 0
    ORDER BY coa.AccountCode;
END
GO

PRINT 'Created procedure: sp_GetTrialBalance';
GO

-- =============================================
-- 3. Stored Procedure: Get Account Ledger
-- =============================================
IF OBJECT_ID('dbo.sp_GetAccountLedger', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetAccountLedger;
GO

CREATE PROCEDURE dbo.sp_GetAccountLedger
    @AccountID INT,
    @FromDate DATE = NULL,
    @ToDate DATE = NULL,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get opening balance
    DECLARE @OpeningBalance DECIMAL(18,2) = 0;
    
    IF @FromDate IS NOT NULL
    BEGIN
        SELECT @OpeningBalance = ISNULL(SUM(jd.Debit - jd.Credit), 0)
        FROM JournalDetails jd
        INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
        WHERE jd.AccountID = @AccountID
          AND jh.IsPosted = 1
          AND jh.JournalDate < @FromDate
          AND (@BranchID IS NULL OR jh.BranchID = @BranchID);
    END
    
    -- Get transactions with running balance
    SELECT 
        jh.JournalDate,
        jh.JournalNumber,
        jh.Reference,
        jh.Description,
        jd.Debit,
        jd.Credit,
        @OpeningBalance + SUM(jd.Debit - jd.Credit) OVER (ORDER BY jh.JournalDate, jh.JournalID) AS RunningBalance,
        jh.JournalID,
        jh.BranchID,
        b.BranchName,
        jd.Description AS LineDescription
    FROM JournalDetails jd
    INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
    LEFT JOIN Branches b ON jh.BranchID = b.BranchID
    WHERE jd.AccountID = @AccountID
      AND jh.IsPosted = 1
      AND (@FromDate IS NULL OR jh.JournalDate >= @FromDate)
      AND (@ToDate IS NULL OR jh.JournalDate <= @ToDate)
      AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
    ORDER BY jh.JournalDate, jh.JournalID;
    
    -- Return summary
    SELECT 
        @OpeningBalance AS OpeningBalance,
        ISNULL(SUM(CASE WHEN jd.Debit > 0 THEN jd.Debit ELSE 0 END), 0) AS TotalDebits,
        ISNULL(SUM(CASE WHEN jd.Credit > 0 THEN jd.Credit ELSE 0 END), 0) AS TotalCredits,
        @OpeningBalance + ISNULL(SUM(jd.Debit - jd.Credit), 0) AS ClosingBalance,
        COUNT(*) AS TransactionCount
    FROM JournalDetails jd
    INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
    WHERE jd.AccountID = @AccountID
      AND jh.IsPosted = 1
      AND (@FromDate IS NULL OR jh.JournalDate >= @FromDate)
      AND (@ToDate IS NULL OR jh.JournalDate <= @ToDate)
      AND (@BranchID IS NULL OR jh.BranchID = @BranchID);
END
GO

PRINT 'Created procedure: sp_GetAccountLedger';
GO

-- =============================================
-- 4. Stored Procedure: Get Journal Entry Detail
-- =============================================
IF OBJECT_ID('dbo.sp_GetJournalEntryDetail', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetJournalEntryDetail;
GO

CREATE PROCEDURE dbo.sp_GetJournalEntryDetail
    @JournalID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get journal header
    SELECT 
        jh.JournalID,
        jh.JournalNumber,
        jh.JournalDate,
        jh.Reference,
        jh.Description,
        jh.IsPosted,
        jh.BranchID,
        b.BranchName,
        jh.CreatedBy,
        CAST(jh.CreatedBy AS NVARCHAR(50)) AS CreatedByName,
        jh.CreatedDate,
        jh.PostedBy,
        CAST(jh.PostedBy AS NVARCHAR(50)) AS PostedByName,
        jh.PostedDate
    FROM JournalHeaders jh
    LEFT JOIN Branches b ON jh.BranchID = b.BranchID
    WHERE jh.JournalID = @JournalID;
    
    -- Get journal lines
    SELECT 
        jd.JournalDetailID,
        jd.AccountID,
        coa.AccountCode,
        coa.AccountName,
        coa.AccountType,
        jd.Debit,
        jd.Credit,
        jd.Description
    FROM JournalDetails jd
    LEFT JOIN (
        SELECT AccountID, AccountCode, AccountName, AccountType FROM ChartOfAccounts WHERE OBJECT_ID('ChartOfAccounts', 'U') IS NOT NULL
        UNION ALL
        SELECT AccountID, AccountNumber AS AccountCode, AccountName, AccountType FROM GLAccounts WHERE OBJECT_ID('GLAccounts', 'U') IS NOT NULL
    ) coa ON jd.AccountID = coa.AccountID
    WHERE jd.JournalID = @JournalID
    ORDER BY jd.JournalDetailID;
    
    -- Get totals
    SELECT 
        SUM(Debit) AS TotalDebit,
        SUM(Credit) AS TotalCredit,
        CASE WHEN SUM(Debit) = SUM(Credit) THEN 1 ELSE 0 END AS IsBalanced
    FROM JournalDetails
    WHERE JournalID = @JournalID;
END
GO

PRINT 'Created procedure: sp_GetJournalEntryDetail';
GO

-- =============================================
-- 5. Stored Procedure: Get Journal Register
-- =============================================
IF OBJECT_ID('dbo.sp_GetJournalRegister', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetJournalRegister;
GO

CREATE PROCEDURE dbo.sp_GetJournalRegister
    @FromDate DATE = NULL,
    @ToDate DATE = NULL,
    @BranchID INT = NULL,
    @IsPosted BIT = NULL,
    @CreatedBy INT = NULL,
    @SearchText NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        jh.JournalID,
        jh.JournalNumber,
        jh.JournalDate,
        jh.Reference,
        jh.Description,
        jh.IsPosted,
        jh.BranchID,
        b.BranchName,
        jh.CreatedBy,
        CAST(jh.CreatedBy AS NVARCHAR(50)) AS CreatedByName,
        jh.CreatedDate,
        jh.PostedBy,
        CAST(jh.PostedBy AS NVARCHAR(50)) AS PostedByName,
        jh.PostedDate,
        (SELECT SUM(Debit) FROM JournalDetails WHERE JournalID = jh.JournalID) AS TotalAmount,
        (SELECT COUNT(*) FROM JournalDetails WHERE JournalID = jh.JournalID) AS LineCount
    FROM JournalHeaders jh
    LEFT JOIN Branches b ON jh.BranchID = b.BranchID
    WHERE (@FromDate IS NULL OR jh.JournalDate >= @FromDate)
      AND (@ToDate IS NULL OR jh.JournalDate <= @ToDate)
      AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
      AND (@IsPosted IS NULL OR jh.IsPosted = @IsPosted)
      AND (@CreatedBy IS NULL OR jh.CreatedBy = @CreatedBy)
      AND (@SearchText IS NULL OR jh.Reference LIKE '%' + @SearchText + '%' OR jh.Description LIKE '%' + @SearchText + '%' OR jh.JournalNumber LIKE '%' + @SearchText + '%')
    ORDER BY jh.JournalDate DESC, jh.JournalID DESC;
END
GO

PRINT 'Created procedure: sp_GetJournalRegister';
GO

-- =============================================
-- 6. Stored Procedure: Get Account Activity Summary
-- =============================================
IF OBJECT_ID('dbo.sp_GetAccountActivitySummary', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetAccountActivitySummary;
GO

CREATE PROCEDURE dbo.sp_GetAccountActivitySummary
    @AccountID INT,
    @FromDate DATE,
    @ToDate DATE,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get opening balance
    DECLARE @OpeningBalance DECIMAL(18,2);
    SELECT @OpeningBalance = ISNULL(SUM(jd.Debit - jd.Credit), 0)
    FROM JournalDetails jd
    INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
    WHERE jd.AccountID = @AccountID
      AND jh.IsPosted = 1
      AND jh.JournalDate < @FromDate
      AND (@BranchID IS NULL OR jh.BranchID = @BranchID);
    
    -- Get period activity
    SELECT 
        @OpeningBalance AS OpeningBalance,
        ISNULL(SUM(jd.Debit), 0) AS TotalDebits,
        ISNULL(SUM(jd.Credit), 0) AS TotalCredits,
        ISNULL(SUM(jd.Debit - jd.Credit), 0) AS NetChange,
        @OpeningBalance + ISNULL(SUM(jd.Debit - jd.Credit), 0) AS ClosingBalance,
        COUNT(*) AS TransactionCount,
        CASE WHEN COUNT(*) > 0 THEN ISNULL(SUM(jd.Debit + jd.Credit), 0) / COUNT(*) ELSE 0 END AS AverageTransaction
    FROM JournalDetails jd
    INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
    WHERE jd.AccountID = @AccountID
      AND jh.IsPosted = 1
      AND jh.JournalDate BETWEEN @FromDate AND @ToDate
      AND (@BranchID IS NULL OR jh.BranchID = @BranchID);
    
    -- Get monthly breakdown
    SELECT 
        YEAR(jh.JournalDate) AS Year,
        MONTH(jh.JournalDate) AS Month,
        DATENAME(MONTH, jh.JournalDate) AS MonthName,
        SUM(jd.Debit) AS MonthlyDebits,
        SUM(jd.Credit) AS MonthlyCredits,
        SUM(jd.Debit - jd.Credit) AS MonthlyNet,
        COUNT(*) AS MonthlyTransactions
    FROM JournalDetails jd
    INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
    WHERE jd.AccountID = @AccountID
      AND jh.IsPosted = 1
      AND jh.JournalDate BETWEEN @FromDate AND @ToDate
      AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
    GROUP BY YEAR(jh.JournalDate), MONTH(jh.JournalDate), DATENAME(MONTH, jh.JournalDate)
    ORDER BY YEAR(jh.JournalDate), MONTH(jh.JournalDate);
END
GO

PRINT 'Created procedure: sp_GetAccountActivitySummary';
GO

PRINT '';
PRINT '=============================================';
PRINT 'Ledger Views and Procedures Created Successfully';
PRINT '=============================================';
PRINT 'Views: vw_TrialBalance';
PRINT 'Procedures: sp_GetTrialBalance, sp_GetAccountLedger, sp_GetJournalEntryDetail, sp_GetJournalRegister, sp_GetAccountActivitySummary';
PRINT '=============================================';
GO
