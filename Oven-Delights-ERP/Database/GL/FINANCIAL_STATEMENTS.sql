-- =============================================
-- FINANCIAL STATEMENTS
-- Profit & Loss (Income Statement) and Balance Sheet
-- =============================================

SET NOCOUNT ON
GO

PRINT ''
PRINT '========================================='
PRINT 'CREATING FINANCIAL STATEMENT PROCEDURES'
PRINT '========================================='
PRINT ''

-- =============================================
-- 1. PROFIT & LOSS STATEMENT (INCOME STATEMENT)
-- =============================================

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_GL_ProfitAndLoss' AND type = 'P')
    DROP PROCEDURE sp_GL_ProfitAndLoss
GO

CREATE PROCEDURE sp_GL_ProfitAndLoss
    @FromDate DATE = NULL,
    @ToDate DATE = NULL,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON
    
    -- Default to current month if no dates provided
    IF @FromDate IS NULL SET @FromDate = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
    IF @ToDate IS NULL SET @ToDate = CAST(GETDATE() AS DATE)
    
    -- Calculate totals
    DECLARE @TotalRevenue DECIMAL(18,2), @TotalCOGS DECIMAL(18,2), @TotalExpenses DECIMAL(18,2)
    DECLARE @GrossProfit DECIMAL(18,2), @NetProfit DECIMAL(18,2)
    
    -- Revenue (Credit side)
    SELECT @TotalRevenue = ISNULL(SUM(jd.Credit) - SUM(jd.Debit), 0)
    FROM ChartOfAccounts coa
    LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
    LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID 
        AND jh.JournalDate BETWEEN @FromDate AND @ToDate
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
    WHERE coa.IsActive = 1 AND coa.AccountType = 'Revenue'
    
    -- COGS (Debit side)
    SELECT @TotalCOGS = ISNULL(SUM(jd.Debit) - SUM(jd.Credit), 0)
    FROM ChartOfAccounts coa
    LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
    LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID 
        AND jh.JournalDate BETWEEN @FromDate AND @ToDate
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
    WHERE coa.IsActive = 1 AND coa.AccountCode LIKE '5%'
    
    -- Operating Expenses (Debit side)
    SELECT @TotalExpenses = ISNULL(SUM(jd.Debit) - SUM(jd.Credit), 0)
    FROM ChartOfAccounts coa
    LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
    LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID 
        AND jh.JournalDate BETWEEN @FromDate AND @ToDate
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
    WHERE coa.IsActive = 1 AND coa.AccountCode LIKE '6%'
    
    SET @GrossProfit = @TotalRevenue - @TotalCOGS
    SET @NetProfit = @GrossProfit - @TotalExpenses
    
    -- Return T-Account format: DEBIT side | CREDIT side
    SELECT 
        'DEBIT' AS Side,
        DebitAccount AS AccountName,
        DebitAmount AS Amount,
        SortOrder
    FROM (
        -- DEBIT SIDE: Expenses and COGS
        SELECT 'Cost of Goods Sold' AS DebitAccount, @TotalCOGS AS DebitAmount, 1 AS SortOrder
        UNION ALL
        SELECT 'Operating Expenses', @TotalExpenses, 2
        UNION ALL
        SELECT 'NET PROFIT (if profit)', CASE WHEN @NetProfit > 0 THEN @NetProfit ELSE 0 END, 3
    ) AS DebitSide
    WHERE DebitAmount > 0
    
    UNION ALL
    
    SELECT 
        'CREDIT' AS Side,
        CreditAccount AS AccountName,
        CreditAmount AS Amount,
        SortOrder
    FROM (
        -- CREDIT SIDE: Revenue
        SELECT 'Sales Revenue' AS CreditAccount, @TotalRevenue AS CreditAmount, 1 AS SortOrder
        UNION ALL
        SELECT 'NET LOSS (if loss)', CASE WHEN @NetProfit < 0 THEN ABS(@NetProfit) ELSE 0 END, 2
    ) AS CreditSide
    WHERE CreditAmount > 0
    
    ORDER BY Side DESC, SortOrder
END
GO

PRINT '✓ Created sp_GL_ProfitAndLoss'
GO

-- =============================================
-- 2. BALANCE SHEET
-- =============================================

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_GL_BalanceSheet' AND type = 'P')
    DROP PROCEDURE sp_GL_BalanceSheet
GO

CREATE PROCEDURE sp_GL_BalanceSheet
    @AsOfDate DATE = NULL,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON
    
    -- Default to today if no date provided
    IF @AsOfDate IS NULL SET @AsOfDate = CAST(GETDATE() AS DATE)
    
    -- Calculate totals
    DECLARE @TotalAssets DECIMAL(18,2), @TotalLiabilities DECIMAL(18,2), @TotalEquity DECIMAL(18,2)
    
    -- Assets (Debit side)
    SELECT @TotalAssets = ISNULL(SUM(jd.Debit) - SUM(jd.Credit), 0)
    FROM ChartOfAccounts coa
    LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
    LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID 
        AND jh.JournalDate <= @AsOfDate
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
    WHERE coa.IsActive = 1 AND coa.AccountType = 'Asset'
    
    -- Liabilities (Credit side)
    SELECT @TotalLiabilities = ISNULL(SUM(jd.Credit) - SUM(jd.Debit), 0)
    FROM ChartOfAccounts coa
    LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
    LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID 
        AND jh.JournalDate <= @AsOfDate
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
    WHERE coa.IsActive = 1 AND coa.AccountType = 'Liability'
    
    -- Equity (Credit side)
    SELECT @TotalEquity = ISNULL(SUM(jd.Credit) - SUM(jd.Debit), 0)
    FROM ChartOfAccounts coa
    LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
    LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID 
        AND jh.JournalDate <= @AsOfDate
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
    WHERE coa.IsActive = 1 AND coa.AccountType = 'Equity'
    
    -- Return T-Account format: DEBIT side (Assets) | CREDIT side (Liabilities + Equity)
    SELECT 
        'DEBIT' AS Side,
        DebitAccount AS AccountName,
        DebitAmount AS Amount,
        SortOrder
    FROM (
        -- DEBIT SIDE: Assets
        SELECT 'Current Assets' AS DebitAccount, 
               ISNULL((SELECT SUM(jd.Debit) - SUM(jd.Credit)
                       FROM ChartOfAccounts coa
                       LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
                       LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID 
                           AND jh.JournalDate <= @AsOfDate
                           AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
                       WHERE coa.IsActive = 1 
                         AND coa.AccountType = 'Asset'
                         AND coa.AccountCode LIKE '1[0-4]%'), 0) AS DebitAmount,
               1 AS SortOrder
        UNION ALL
        SELECT 'Fixed Assets',
               ISNULL((SELECT SUM(jd.Debit) - SUM(jd.Credit)
                       FROM ChartOfAccounts coa
                       LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
                       LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID 
                           AND jh.JournalDate <= @AsOfDate
                           AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
                       WHERE coa.IsActive = 1 
                         AND coa.AccountType = 'Asset'
                         AND coa.AccountCode LIKE '1[5-9]%'), 0),
               2
        UNION ALL
        SELECT 'TOTAL ASSETS', @TotalAssets, 3
    ) AS DebitSide
    WHERE DebitAmount <> 0 OR DebitAccount = 'TOTAL ASSETS'
    
    UNION ALL
    
    SELECT 
        'CREDIT' AS Side,
        CreditAccount AS AccountName,
        CreditAmount AS Amount,
        SortOrder
    FROM (
        -- CREDIT SIDE: Liabilities and Equity
        SELECT 'Current Liabilities' AS CreditAccount,
               ISNULL((SELECT SUM(jd.Credit) - SUM(jd.Debit)
                       FROM ChartOfAccounts coa
                       LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
                       LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID 
                           AND jh.JournalDate <= @AsOfDate
                           AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
                       WHERE coa.IsActive = 1 
                         AND coa.AccountType = 'Liability'
                         AND coa.AccountCode LIKE '2[0-4]%'), 0) AS CreditAmount,
               1 AS SortOrder
        UNION ALL
        SELECT 'Long-term Liabilities',
               ISNULL((SELECT SUM(jd.Credit) - SUM(jd.Debit)
                       FROM ChartOfAccounts coa
                       LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
                       LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID 
                           AND jh.JournalDate <= @AsOfDate
                           AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
                       WHERE coa.IsActive = 1 
                         AND coa.AccountType = 'Liability'
                         AND coa.AccountCode LIKE '2[5-9]%'), 0),
               2
        UNION ALL
        SELECT 'Owner''s Equity', @TotalEquity, 3
        UNION ALL
        SELECT 'TOTAL LIABILITIES + EQUITY', @TotalLiabilities + @TotalEquity, 4
    ) AS CreditSide
    WHERE CreditAmount <> 0 OR CreditAccount LIKE 'TOTAL%'
    
    ORDER BY Side DESC, SortOrder
END
GO

PRINT '✓ Created sp_GL_BalanceSheet'
GO

PRINT ''
PRINT '========================================='
PRINT 'FINANCIAL STATEMENTS COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'Usage Examples:'
PRINT ''
PRINT '-- Profit & Loss for current month:'
PRINT 'EXEC sp_GL_ProfitAndLoss'
PRINT ''
PRINT '-- Profit & Loss for specific period:'
PRINT 'EXEC sp_GL_ProfitAndLoss @FromDate = ''2026-01-01'', @ToDate = ''2026-01-31'''
PRINT ''
PRINT '-- Profit & Loss for specific branch:'
PRINT 'EXEC sp_GL_ProfitAndLoss @FromDate = ''2026-01-01'', @ToDate = ''2026-01-31'', @BranchID = 1'
PRINT ''
PRINT '-- Balance Sheet as of today:'
PRINT 'EXEC sp_GL_BalanceSheet'
PRINT ''
PRINT '-- Balance Sheet as of specific date:'
PRINT 'EXEC sp_GL_BalanceSheet @AsOfDate = ''2026-01-31'''
PRINT ''
PRINT '-- Balance Sheet for specific branch:'
PRINT 'EXEC sp_GL_BalanceSheet @AsOfDate = ''2026-01-31'', @BranchID = 1'
PRINT ''
