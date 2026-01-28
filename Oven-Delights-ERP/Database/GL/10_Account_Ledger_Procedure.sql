-- =============================================
-- Account Ledger Stored Procedure
-- =============================================

CREATE OR ALTER PROCEDURE sp_GetAccountLedger
    @AccountID INT,
    @FromDate DATE = NULL,
    @ToDate DATE = NULL,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get opening balance
    DECLARE @OpeningBalance DECIMAL(18,2) = 0
    
    IF @FromDate IS NOT NULL
    BEGIN
        SELECT @OpeningBalance = ISNULL(SUM(jd.Debit - jd.Credit), 0)
        FROM JournalDetails jd
        INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
        WHERE jd.AccountID = @AccountID
          AND jh.IsPosted = 1
          AND jh.JournalDate < @FromDate
          AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
    END
    
    -- Get ledger transactions with running balance
    ;WITH LedgerCTE AS (
        SELECT 
            jh.JournalID,
            jh.JournalDate,
            jh.JournalNumber,
            jh.Reference,
            jh.Description,
            jh.BranchID,
            jd.Description AS LineDescription,
            jd.Debit,
            jd.Credit,
            ROW_NUMBER() OVER (ORDER BY jh.JournalDate, jh.JournalID, jd.LineNumber) AS RowNum
        FROM JournalDetails jd
        INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
        WHERE jd.AccountID = @AccountID
          AND jh.IsPosted = 1
          AND (@FromDate IS NULL OR jh.JournalDate >= @FromDate)
          AND (@ToDate IS NULL OR jh.JournalDate <= @ToDate)
          AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
    )
    SELECT 
        JournalID,
        JournalDate,
        JournalNumber,
        Reference,
        Description,
        BranchID,
        LineDescription,
        Debit,
        Credit,
        @OpeningBalance + SUM(Debit - Credit) OVER (ORDER BY RowNum ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningBalance
    FROM LedgerCTE
    ORDER BY JournalDate, JournalID
    
    -- Get summary
    SELECT 
        @OpeningBalance AS OpeningBalance,
        ISNULL(SUM(jd.Debit), 0) AS TotalDebits,
        ISNULL(SUM(jd.Credit), 0) AS TotalCredits,
        @OpeningBalance + ISNULL(SUM(jd.Debit - jd.Credit), 0) AS ClosingBalance,
        COUNT(*) AS TransactionCount
    FROM JournalDetails jd
    INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
    WHERE jd.AccountID = @AccountID
      AND jh.IsPosted = 1
      AND (@FromDate IS NULL OR jh.JournalDate >= @FromDate)
      AND (@ToDate IS NULL OR jh.JournalDate <= @ToDate)
      AND (@BranchID IS NULL OR jh.BranchID = @BranchID)
END
GO

PRINT 'Account Ledger procedure created successfully'
GO

-- =============================================
-- Journal Entry Detail Stored Procedure
-- =============================================

CREATE OR ALTER PROCEDURE sp_GetJournalEntryDetail
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
        jh.CreatedBy,
        jh.PostedBy,
        jh.PostedDate,
        b.BranchName
    FROM JournalHeaders jh
    LEFT JOIN Branches b ON jh.BranchID = b.BranchID
    WHERE jh.JournalID = @JournalID
    
    -- Get journal lines
    SELECT 
        jd.JournalDetailID,
        jd.LineNumber,
        jd.AccountID,
        coa.AccountCode,
        coa.AccountName,
        coa.AccountType,
        jd.Debit,
        jd.Credit,
        jd.Description
    FROM JournalDetails jd
    INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
    WHERE jd.JournalID = @JournalID
    ORDER BY jd.LineNumber
    
    -- Get totals
    SELECT 
        SUM(Debit) AS TotalDebit,
        SUM(Credit) AS TotalCredit,
        CASE WHEN ABS(SUM(Debit) - SUM(Credit)) < 0.01 THEN 1 ELSE 0 END AS IsBalanced
    FROM JournalDetails
    WHERE JournalID = @JournalID
END
GO

PRINT 'Journal Entry Detail procedure created successfully'
GO
