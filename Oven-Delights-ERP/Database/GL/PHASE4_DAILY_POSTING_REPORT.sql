-- =============================================
-- PHASE 4: DAILY POSTING REPORT
-- View all GL postings with double-entry verification
-- =============================================

PRINT '========================================='
PRINT 'PHASE 4: DAILY POSTING REPORT'
PRINT '========================================='
PRINT ''

-- =============================================
-- Drop existing procedures if they exist
-- =============================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_GL_DailyPostingReport' AND type = 'P')
    DROP PROCEDURE sp_GL_DailyPostingReport
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_GL_TrialBalance' AND type = 'P')
    DROP PROCEDURE sp_GL_TrialBalance
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_GL_AccountLedger' AND type = 'P')
    DROP PROCEDURE sp_GL_AccountLedger
GO

PRINT '✓ Dropped old procedures (if existed)'
PRINT ''
GO

-- =============================================
-- sp_GL_DailyPostingReport
-- Show all GL postings for a date range
-- =============================================
CREATE PROCEDURE sp_GL_DailyPostingReport
    @FromDate DATE = NULL,
    @ToDate DATE = NULL,
    @BranchID INT = NULL,
    @AccountCode NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON
    
    -- Default to today if no dates provided
    IF @FromDate IS NULL SET @FromDate = CAST(GETDATE() AS DATE)
    IF @ToDate IS NULL SET @ToDate = CAST(GETDATE() AS DATE)
    
    -- Main report: All journal entries
    SELECT 
        jh.JournalID,
        jh.JournalNumber,
        jh.JournalDate,
        jh.Reference,
        jh.Description AS JournalDescription,
        b.BranchName,
        jd.LineNumber,
        coa.AccountCode,
        coa.AccountName,
        coa.AccountType,
        jd.Debit,
        jd.Credit,
        jd.Description AS LineDescription,
        jd.Reference1,
        jd.Reference2,
        u.Username AS CreatedBy,
        CASE 
            WHEN jh.JournalNumber LIKE 'POS-%' THEN 'POS Sale'
            WHEN jh.JournalNumber LIKE 'POS-DEP-%' THEN 'POS Order Deposit'
            WHEN jh.JournalNumber LIKE 'POS-COL-%' THEN 'POS Order Collection'
            WHEN jh.JournalNumber LIKE 'POS-REF-%' THEN 'POS Refund'
            WHEN jh.JournalNumber LIKE 'CASH-DEP-%' THEN 'Cash Deposit'
            WHEN jh.JournalNumber LIKE 'EFTC-%' THEN 'EFT Clearing'
            WHEN jh.JournalNumber LIKE 'AP-%' THEN 'AP Invoice'
            WHEN jh.JournalNumber LIKE 'PAY-%' THEN 'AP Payment'
            WHEN jh.JournalNumber LIKE 'BP-%' THEN 'AP Batch Payment'
            WHEN jh.JournalNumber LIKE 'CN-%' THEN 'Credit Note'
            WHEN jh.JournalNumber LIKE 'IBT-R-%' THEN 'IBT Receipt'
            WHEN jh.JournalNumber LIKE 'IBT-P-%' THEN 'IBT Payment'
            WHEN jh.JournalNumber LIKE 'IBT-S-%' THEN 'IBT Settlement'
            WHEN jh.JournalNumber LIKE 'ADJ-%' THEN 'Stock Adjustment'
            WHEN jh.JournalNumber LIKE 'WST-%' THEN 'Wastage'
            WHEN jh.JournalNumber LIKE 'GRV-%' THEN 'Goods Receipt'
            WHEN jh.JournalNumber LIKE 'MFG-%' THEN 'Manufacturing'
            ELSE 'Other'
        END AS TransactionType
    FROM JournalHeaders jh
    INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
    INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
    LEFT JOIN Branches b ON jh.BranchID = b.BranchID
    LEFT JOIN Users u ON jh.CreatedBy = u.UserID
    WHERE jh.JournalDate BETWEEN @FromDate AND @ToDate
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
        AND (@AccountCode IS NULL OR coa.AccountCode = @AccountCode)
    ORDER BY jh.JournalDate, jh.JournalNumber, jd.LineNumber
    
    -- Summary by transaction type
    PRINT ''
    PRINT 'SUMMARY BY TRANSACTION TYPE'
    PRINT '============================'
    
    SELECT 
        CASE 
            WHEN jh.JournalNumber LIKE 'POS-%' THEN 'POS Sale'
            WHEN jh.JournalNumber LIKE 'POS-DEP-%' THEN 'POS Order Deposit'
            WHEN jh.JournalNumber LIKE 'POS-COL-%' THEN 'POS Order Collection'
            WHEN jh.JournalNumber LIKE 'POS-REF-%' THEN 'POS Refund'
            WHEN jh.JournalNumber LIKE 'CASH-DEP-%' THEN 'Cash Deposit'
            WHEN jh.JournalNumber LIKE 'EFTC-%' THEN 'EFT Clearing'
            WHEN jh.JournalNumber LIKE 'AP-%' THEN 'AP Invoice'
            WHEN jh.JournalNumber LIKE 'PAY-%' THEN 'AP Payment'
            WHEN jh.JournalNumber LIKE 'BP-%' THEN 'AP Batch Payment'
            WHEN jh.JournalNumber LIKE 'CN-%' THEN 'Credit Note'
            WHEN jh.JournalNumber LIKE 'IBT-R-%' THEN 'IBT Receipt'
            WHEN jh.JournalNumber LIKE 'IBT-P-%' THEN 'IBT Payment'
            WHEN jh.JournalNumber LIKE 'IBT-S-%' THEN 'IBT Settlement'
            WHEN jh.JournalNumber LIKE 'ADJ-%' THEN 'Stock Adjustment'
            WHEN jh.JournalNumber LIKE 'WST-%' THEN 'Wastage'
            WHEN jh.JournalNumber LIKE 'GRV-%' THEN 'Goods Receipt'
            WHEN jh.JournalNumber LIKE 'MFG-%' THEN 'Manufacturing'
            ELSE 'Other'
        END AS TransactionType,
        COUNT(DISTINCT jh.JournalID) AS TransactionCount,
        SUM(jd.Debit) AS TotalDebits,
        SUM(jd.Credit) AS TotalCredits
    FROM JournalHeaders jh
    INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
    WHERE jh.JournalDate BETWEEN @FromDate AND @ToDate
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
    GROUP BY 
        CASE 
            WHEN jh.JournalNumber LIKE 'POS-%' THEN 'POS Sale'
            WHEN jh.JournalNumber LIKE 'POS-DEP-%' THEN 'POS Order Deposit'
            WHEN jh.JournalNumber LIKE 'POS-COL-%' THEN 'POS Order Collection'
            WHEN jh.JournalNumber LIKE 'POS-REF-%' THEN 'POS Refund'
            WHEN jh.JournalNumber LIKE 'CASH-DEP-%' THEN 'Cash Deposit'
            WHEN jh.JournalNumber LIKE 'EFTC-%' THEN 'EFT Clearing'
            WHEN jh.JournalNumber LIKE 'AP-%' THEN 'AP Invoice'
            WHEN jh.JournalNumber LIKE 'PAY-%' THEN 'AP Payment'
            WHEN jh.JournalNumber LIKE 'BP-%' THEN 'AP Batch Payment'
            WHEN jh.JournalNumber LIKE 'CN-%' THEN 'Credit Note'
            WHEN jh.JournalNumber LIKE 'IBT-R-%' THEN 'IBT Receipt'
            WHEN jh.JournalNumber LIKE 'IBT-P-%' THEN 'IBT Payment'
            WHEN jh.JournalNumber LIKE 'IBT-S-%' THEN 'IBT Settlement'
            WHEN jh.JournalNumber LIKE 'ADJ-%' THEN 'Stock Adjustment'
            WHEN jh.JournalNumber LIKE 'WST-%' THEN 'Wastage'
            WHEN jh.JournalNumber LIKE 'GRV-%' THEN 'Goods Receipt'
            WHEN jh.JournalNumber LIKE 'MFG-%' THEN 'Manufacturing'
            ELSE 'Other'
        END
    ORDER BY TransactionType
    
    -- Double-entry verification
    PRINT ''
    PRINT 'DOUBLE-ENTRY VERIFICATION'
    PRINT '========================='
    
    SELECT 
        jh.JournalNumber,
        jh.JournalDate,
        jh.Description,
        SUM(jd.Debit) AS TotalDebits,
        SUM(jd.Credit) AS TotalCredits,
        SUM(jd.Debit) - SUM(jd.Credit) AS Difference,
        CASE 
            WHEN SUM(jd.Debit) = SUM(jd.Credit) THEN '✓ BALANCED'
            ELSE '✗ OUT OF BALANCE'
        END AS Status
    FROM JournalHeaders jh
    INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
    WHERE jh.JournalDate BETWEEN @FromDate AND @ToDate
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
    GROUP BY jh.JournalNumber, jh.JournalDate, jh.Description
    HAVING SUM(jd.Debit) <> SUM(jd.Credit)  -- Show only unbalanced entries
    ORDER BY jh.JournalDate, jh.JournalNumber
    
    IF @@ROWCOUNT = 0
        PRINT '✓ All journal entries are balanced (Debits = Credits)'
    ELSE
        PRINT '✗ WARNING: Some journal entries are out of balance!'
END
GO

PRINT '✓ Created sp_GL_DailyPostingReport'
GO

-- =============================================
-- sp_GL_TrialBalance
-- Generate trial balance for verification
-- =============================================
CREATE PROCEDURE sp_GL_TrialBalance
    @AsOfDate DATE = NULL,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON
    
    -- Default to today if no date provided
    IF @AsOfDate IS NULL SET @AsOfDate = CAST(GETDATE() AS DATE)
    
    SELECT 
        coa.AccountCode,
        coa.AccountName,
        coa.AccountType,
        ISNULL(SUM(jd.Debit), 0) AS TotalDebits,
        ISNULL(SUM(jd.Credit), 0) AS TotalCredits,
        ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0) AS Balance,
        CASE 
            WHEN coa.AccountType IN ('Asset', 'Expense') THEN 
                CASE 
                    WHEN ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0) >= 0 THEN 'Normal Debit'
                    ELSE 'Abnormal Credit'
                END
            WHEN coa.AccountType IN ('Liability', 'Revenue', 'Equity') THEN
                CASE 
                    WHEN ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0) <= 0 THEN 'Normal Credit'
                    ELSE 'Abnormal Debit'
                END
            ELSE 'Check'
        END AS BalanceType,
        CASE 
            WHEN ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0) >= 0 
            THEN ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0)
            ELSE 0
        END AS DebitBalance,
        CASE 
            WHEN ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0) < 0 
            THEN ABS(ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0))
            ELSE 0
        END AS CreditBalance
    FROM ChartOfAccounts coa
    LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
    LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID AND jh.JournalDate <= @AsOfDate
    WHERE coa.IsActive = 1
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID OR jh.BranchID IS NULL)
    GROUP BY coa.AccountCode, coa.AccountName, coa.AccountType
    ORDER BY coa.AccountCode
    
    -- Trial balance totals
    PRINT ''
    PRINT 'TRIAL BALANCE TOTALS'
    PRINT '===================='
    
    SELECT 
        'Total Debit Balances' AS Description,
        SUM(CASE WHEN AccountBalance >= 0 THEN AccountBalance ELSE 0 END) AS Amount
    FROM (
        SELECT 
            coa.AccountID,
            ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0) AS AccountBalance
        FROM ChartOfAccounts coa
        LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
        LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID AND jh.JournalDate <= @AsOfDate
        WHERE coa.IsActive = 1
            AND (@BranchID IS NULL OR jh.BranchID = @BranchID OR jh.BranchID IS NULL)
        GROUP BY coa.AccountID
    ) AS Balances
    
    UNION ALL
    
    SELECT 
        'Total Credit Balances' AS Description,
        SUM(CASE WHEN AccountBalance < 0 THEN ABS(AccountBalance) ELSE 0 END) AS Amount
    FROM (
        SELECT 
            coa.AccountID,
            ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0) AS AccountBalance
        FROM ChartOfAccounts coa
        LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
        LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID AND jh.JournalDate <= @AsOfDate
        WHERE coa.IsActive = 1
            AND (@BranchID IS NULL OR jh.BranchID = @BranchID OR jh.BranchID IS NULL)
        GROUP BY coa.AccountID
    ) AS Balances
    
    -- Verify trial balance
    DECLARE @TotalDebits DECIMAL(18,2)
    DECLARE @TotalCredits DECIMAL(18,2)
    
    SELECT @TotalDebits = SUM(CASE WHEN AccountBalance >= 0 THEN AccountBalance ELSE 0 END)
    FROM (
        SELECT 
            coa.AccountID,
            ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0) AS AccountBalance
        FROM ChartOfAccounts coa
        LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
        LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID AND jh.JournalDate <= @AsOfDate
        WHERE coa.IsActive = 1
            AND (@BranchID IS NULL OR jh.BranchID = @BranchID OR jh.BranchID IS NULL)
        GROUP BY coa.AccountID
    ) AS Balances
    
    SELECT @TotalCredits = SUM(CASE WHEN AccountBalance < 0 THEN ABS(AccountBalance) ELSE 0 END)
    FROM (
        SELECT 
            coa.AccountID,
            ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0) AS AccountBalance
        FROM ChartOfAccounts coa
        LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
        LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID AND jh.JournalDate <= @AsOfDate
        WHERE coa.IsActive = 1
            AND (@BranchID IS NULL OR jh.BranchID = @BranchID OR jh.BranchID IS NULL)
        GROUP BY coa.AccountID
    ) AS Balances
    
    IF @TotalDebits = @TotalCredits
        PRINT '✓ Trial Balance is BALANCED'
    ELSE
        PRINT '✗ Trial Balance is OUT OF BALANCE'
END
GO

PRINT '✓ Created sp_GL_TrialBalance'
GO

-- =============================================
-- sp_GL_AccountLedger
-- Show detailed ledger for a specific account
-- =============================================
CREATE PROCEDURE sp_GL_AccountLedger
    @AccountCode NVARCHAR(20),
    @FromDate DATE = NULL,
    @ToDate DATE = NULL,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON
    
    -- Default to current month if no dates provided
    IF @FromDate IS NULL SET @FromDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
    IF @ToDate IS NULL SET @ToDate = CAST(GETDATE() AS DATE)
    
    -- Get opening balance
    DECLARE @OpeningBalance DECIMAL(18,2)
    
    SELECT @OpeningBalance = ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0)
    FROM JournalDetails jd
    INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
    INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
    WHERE coa.AccountCode = @AccountCode
        AND jh.JournalDate < @FromDate
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
    
    -- Show account details
    SELECT 
        AccountCode,
        AccountName,
        AccountType,
        @OpeningBalance AS OpeningBalance
    FROM ChartOfAccounts
    WHERE AccountCode = @AccountCode
    
    -- Show transactions
    SELECT 
        jh.JournalDate,
        jh.JournalNumber,
        jh.Reference,
        jh.Description AS JournalDescription,
        jd.Description AS LineDescription,
        jd.Debit,
        jd.Credit,
        @OpeningBalance + SUM(jd.Debit - jd.Credit) OVER (ORDER BY jh.JournalDate, jh.JournalNumber, jd.LineNumber) AS RunningBalance
    FROM JournalHeaders jh
    INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
    INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
    WHERE coa.AccountCode = @AccountCode
        AND jh.JournalDate BETWEEN @FromDate AND @ToDate
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
    ORDER BY jh.JournalDate, jh.JournalNumber, jd.LineNumber
    
    -- Show closing balance
    DECLARE @ClosingBalance DECIMAL(18,2)
    
    SELECT @ClosingBalance = ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0)
    FROM JournalDetails jd
    INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
    INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
    WHERE coa.AccountCode = @AccountCode
        AND jh.JournalDate <= @ToDate
        AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
    
    SELECT 
        'Closing Balance' AS Description,
        @ClosingBalance AS Amount
END
GO

PRINT '✓ Created sp_GL_AccountLedger'
GO

PRINT ''
PRINT '========================================='
PRINT 'PHASE 4 COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'Created Procedures:'
PRINT '1. sp_GL_DailyPostingReport - View all GL postings with verification'
PRINT '2. sp_GL_TrialBalance - Generate trial balance (Debits = Credits)'
PRINT '3. sp_GL_AccountLedger - Detailed ledger for specific account'
PRINT ''
PRINT 'Usage Examples:'
PRINT ''
PRINT '-- View today''s postings:'
PRINT 'EXEC sp_GL_DailyPostingReport'
PRINT ''
PRINT '-- View postings for date range:'
PRINT 'EXEC sp_GL_DailyPostingReport @FromDate = ''2026-01-01'', @ToDate = ''2026-01-31'''
PRINT ''
PRINT '-- View trial balance:'
PRINT 'EXEC sp_GL_TrialBalance'
PRINT ''
PRINT '-- View account ledger:'
PRINT 'EXEC sp_GL_AccountLedger @AccountCode = ''1010'''
PRINT ''
