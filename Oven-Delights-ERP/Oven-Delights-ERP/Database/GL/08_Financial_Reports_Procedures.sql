-- =============================================
-- Financial Reports Stored Procedures
-- =============================================

-- =============================================
-- sp_GL_GetTrialBalance - Generate Trial Balance
-- =============================================
CREATE OR ALTER PROCEDURE sp_GL_GetTrialBalance
    @AsOfDate DATE = NULL,
    @BranchID INT = NULL,
    @IncludeZeroBalances BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @AsOfDate IS NULL SET @AsOfDate = GETDATE()
    
    SELECT 
        coa.AccountCode,
        coa.AccountName,
        coa.AccountType,
        coa.OpeningBalance,
        ISNULL(SUM(CASE WHEN jd.Debit > 0 THEN jd.Debit ELSE 0 END), 0) AS TotalDebits,
        ISNULL(SUM(CASE WHEN jd.Credit > 0 THEN jd.Credit ELSE 0 END), 0) AS TotalCredits,
        coa.OpeningBalance + 
            ISNULL(SUM(jd.Debit), 0) - 
            ISNULL(SUM(jd.Credit), 0) AS ClosingBalance
    FROM ChartOfAccounts coa
    LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
    LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
    WHERE coa.IsActive = 1
        AND (jh.JournalDate IS NULL OR jh.JournalDate <= @AsOfDate)
        AND (jh.IsPosted IS NULL OR jh.IsPosted = 1)
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID OR jh.BranchID IS NULL)
    GROUP BY 
        coa.AccountCode,
        coa.AccountName,
        coa.AccountType,
        coa.OpeningBalance
    HAVING 
        @IncludeZeroBalances = 1 OR
        (coa.OpeningBalance + ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0)) <> 0
    ORDER BY coa.AccountCode
END
GO

-- =============================================
-- sp_GL_GetProfitLoss - Generate Profit & Loss Statement
-- =============================================
CREATE OR ALTER PROCEDURE sp_GL_GetProfitLoss
    @FromDate DATE,
    @ToDate DATE,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Revenue
    SELECT 
        'Revenue' AS Section,
        coa.AccountCode,
        coa.AccountName,
        ISNULL(SUM(jd.Credit), 0) - ISNULL(SUM(jd.Debit), 0) AS Amount
    FROM ChartOfAccounts coa
    LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
    LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
    WHERE coa.AccountType = 'Revenue'
        AND coa.IsActive = 1
        AND jh.JournalDate BETWEEN @FromDate AND @ToDate
        AND jh.IsPosted = 1
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID OR jh.BranchID IS NULL)
    GROUP BY coa.AccountCode, coa.AccountName
    
    UNION ALL
    
    -- Cost of Sales
    SELECT 
        'Cost of Sales' AS Section,
        coa.AccountCode,
        coa.AccountName,
        ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0) AS Amount
    FROM ChartOfAccounts coa
    LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
    LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
    WHERE coa.AccountType = 'Cost of Sales'
        AND coa.IsActive = 1
        AND jh.JournalDate BETWEEN @FromDate AND @ToDate
        AND jh.IsPosted = 1
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID OR jh.BranchID IS NULL)
    GROUP BY coa.AccountCode, coa.AccountName
    
    UNION ALL
    
    -- Expenses
    SELECT 
        'Expenses' AS Section,
        coa.AccountCode,
        coa.AccountName,
        ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0) AS Amount
    FROM ChartOfAccounts coa
    LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
    LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
    WHERE coa.AccountType = 'Expense'
        AND coa.IsActive = 1
        AND jh.JournalDate BETWEEN @FromDate AND @ToDate
        AND jh.IsPosted = 1
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID OR jh.BranchID IS NULL)
    GROUP BY coa.AccountCode, coa.AccountName
    
    ORDER BY Section, AccountCode
END
GO

-- =============================================
-- sp_GL_GetBalanceSheet - Generate Balance Sheet
-- =============================================
CREATE OR ALTER PROCEDURE sp_GL_GetBalanceSheet
    @AsOfDate DATE = NULL,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @AsOfDate IS NULL SET @AsOfDate = GETDATE()
    
    -- Assets
    SELECT 
        'Assets' AS Section,
        coa.AccountCode,
        coa.AccountName,
        coa.OpeningBalance + 
            ISNULL(SUM(jd.Debit), 0) - 
            ISNULL(SUM(jd.Credit), 0) AS Balance
    FROM ChartOfAccounts coa
    LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
    LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
    WHERE coa.AccountType = 'Asset'
        AND coa.IsActive = 1
        AND (jh.JournalDate IS NULL OR jh.JournalDate <= @AsOfDate)
        AND (jh.IsPosted IS NULL OR jh.IsPosted = 1)
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID OR jh.BranchID IS NULL)
    GROUP BY coa.AccountCode, coa.AccountName, coa.OpeningBalance
    
    UNION ALL
    
    -- Liabilities
    SELECT 
        'Liabilities' AS Section,
        coa.AccountCode,
        coa.AccountName,
        coa.OpeningBalance + 
            ISNULL(SUM(jd.Credit), 0) - 
            ISNULL(SUM(jd.Debit), 0) AS Balance
    FROM ChartOfAccounts coa
    LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
    LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
    WHERE coa.AccountType = 'Liability'
        AND coa.IsActive = 1
        AND (jh.JournalDate IS NULL OR jh.JournalDate <= @AsOfDate)
        AND (jh.IsPosted IS NULL OR jh.IsPosted = 1)
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID OR jh.BranchID IS NULL)
    GROUP BY coa.AccountCode, coa.AccountName, coa.OpeningBalance
    
    UNION ALL
    
    -- Equity
    SELECT 
        'Equity' AS Section,
        coa.AccountCode,
        coa.AccountName,
        coa.OpeningBalance + 
            ISNULL(SUM(jd.Credit), 0) - 
            ISNULL(SUM(jd.Debit), 0) AS Balance
    FROM ChartOfAccounts coa
    LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
    LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
    WHERE coa.AccountType = 'Equity'
        AND coa.IsActive = 1
        AND (jh.JournalDate IS NULL OR jh.JournalDate <= @AsOfDate)
        AND (jh.IsPosted IS NULL OR jh.IsPosted = 1)
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID OR jh.BranchID IS NULL)
    GROUP BY coa.AccountCode, coa.AccountName, coa.OpeningBalance
    
    ORDER BY Section, AccountCode
END
GO

-- =============================================
-- sp_GL_GetAccountLedger - Get ledger for specific account
-- =============================================
CREATE OR ALTER PROCEDURE sp_GL_GetAccountLedger
    @AccountCode NVARCHAR(20),
    @FromDate DATE = NULL,
    @ToDate DATE = NULL,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @FromDate IS NULL SET @FromDate = '1900-01-01'
    IF @ToDate IS NULL SET @ToDate = GETDATE()
    
    DECLARE @AccountID INT
    
    SELECT @AccountID = AccountID 
    FROM ChartOfAccounts 
    WHERE AccountCode = @AccountCode
    
    IF @AccountID IS NULL
    BEGIN
        RAISERROR('Account code %s not found', 16, 1, @AccountCode)
        RETURN
    END
    
    SELECT 
        jh.JournalDate,
        jh.JournalNumber,
        jh.Reference,
        jd.Description,
        jd.Debit,
        jd.Credit,
        SUM(jd.Debit - jd.Credit) OVER (ORDER BY jh.JournalDate, jh.JournalID, jd.LineNumber) AS RunningBalance
    FROM JournalDetails jd
    INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
    WHERE jd.AccountID = @AccountID
        AND jh.JournalDate BETWEEN @FromDate AND @ToDate
        AND jh.IsPosted = 1
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID OR jh.BranchID IS NULL)
    ORDER BY jh.JournalDate, jh.JournalID, jd.LineNumber
END
GO

PRINT 'Financial Reports procedures created successfully'
GO
