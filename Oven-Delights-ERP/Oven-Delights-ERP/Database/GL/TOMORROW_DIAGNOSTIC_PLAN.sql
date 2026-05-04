-- =============================================
-- COMPREHENSIVE POS GL DIAGNOSTIC PLAN
-- Run this tomorrow morning to identify all issues
-- =============================================

PRINT '========================================='
PRINT 'POS GL INTEGRATION DIAGNOSTIC'
PRINT 'Started: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT '========================================='
PRINT ''

-- =============================================
-- 1. VERIFY PROCEDURES EXIST
-- =============================================
PRINT '1. CHECKING STORED PROCEDURES'
PRINT '-----------------------------------------'

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_POS_PostSaleToGL' AND type = 'P')
    PRINT '✓ sp_POS_PostSaleToGL exists'
ELSE
    PRINT '✗ sp_POS_PostSaleToGL MISSING - DEPLOY 09_POS_Integration_Procedures.sql'

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_POS_PostRefundToGL' AND type = 'P')
    PRINT '✓ sp_POS_PostRefundToGL exists'
ELSE
    PRINT '✗ sp_POS_PostRefundToGL MISSING'

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'fn_GetCurrentFiscalPeriodID' AND type IN ('FN', 'IF', 'TF'))
    PRINT '✓ fn_GetCurrentFiscalPeriodID exists'
ELSE
    PRINT '✗ fn_GetCurrentFiscalPeriodID MISSING - CRITICAL ERROR'

PRINT ''

-- =============================================
-- 2. VERIFY GL ACCOUNTS EXIST
-- =============================================
PRINT '2. CHECKING GL ACCOUNTS'
PRINT '-----------------------------------------'

DECLARE @MissingAccounts TABLE (AccountCode NVARCHAR(10), AccountName NVARCHAR(100))

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('1010', 'Bank Account - Current')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1030' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('1030', 'Cash on Hand')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4010' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('4010', 'Sales Revenue - Retail')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2020' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('2020', 'VAT Output (Payable)')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2021' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('2021', 'VAT Input (Receivable)')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5010' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('5010', 'Cost of Goods Sold')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1220' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('1220', 'Inventory - Retail Stock')

IF EXISTS (SELECT 1 FROM @MissingAccounts)
BEGIN
    PRINT '✗ MISSING GL ACCOUNTS:'
    SELECT AccountCode, AccountName FROM @MissingAccounts
END
ELSE
    PRINT '✓ All required GL accounts exist'

PRINT ''

-- =============================================
-- 3. CHECK RECENT POS SALES
-- =============================================
PRINT '3. RECENT POS SALES (Last 7 days)'
PRINT '-----------------------------------------'

SELECT 
    InvoiceNumber,
    SaleDate,
    PaymentMethod,
    CashAmount,
    CardAmount,
    TotalAmount,
    BranchID
FROM Demo_Sales
WHERE SaleDate >= DATEADD(DAY, -7, GETDATE())
ORDER BY SaleDate DESC, InvoiceNumber DESC

PRINT ''

-- =============================================
-- 4. CHECK POS JOURNALS
-- =============================================
PRINT '4. POS JOURNALS IN GL'
PRINT '-----------------------------------------'

IF EXISTS (SELECT 1 FROM JournalHeaders WHERE JournalNumber LIKE 'POS-%')
BEGIN
    SELECT 
        jh.JournalNumber,
        jh.JournalDate,
        jh.Reference AS InvoiceNumber,
        jh.Description,
        jh.IsPosted,
        jh.BranchID
    FROM JournalHeaders jh
    WHERE jh.JournalNumber LIKE 'POS-%'
    ORDER BY jh.JournalID DESC
    
    PRINT ''
    PRINT 'Journal Details:'
    SELECT 
        jh.JournalNumber,
        jd.LineNumber,
        coa.AccountCode,
        coa.AccountName,
        jd.Debit,
        jd.Credit,
        jd.Description
    FROM JournalHeaders jh
    INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
    INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
    WHERE jh.JournalNumber LIKE 'POS-%'
    ORDER BY jh.JournalID DESC, jd.LineNumber
END
ELSE
BEGIN
    PRINT '✗ NO POS JOURNALS FOUND'
    PRINT 'This means GL posting is NOT working'
    PRINT ''
    PRINT 'POSSIBLE CAUSES:'
    PRINT '1. Procedure not deployed to Azure'
    PRINT '2. POS not rebuilt with GL posting code'
    PRINT '3. GL posting failing silently (check for errors)'
    PRINT '4. Fiscal period function missing or failing'
END

PRINT ''

-- =============================================
-- 5. CHECK GL ACCOUNT BALANCES
-- =============================================
PRINT '5. GL ACCOUNT BALANCES (POS-related accounts)'
PRINT '-----------------------------------------'

SELECT 
    coa.AccountCode,
    coa.AccountName,
    ISNULL(SUM(jd.Debit), 0) AS TotalDebits,
    ISNULL(SUM(jd.Credit), 0) AS TotalCredits,
    ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0) AS Balance
FROM ChartOfAccounts coa
LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
WHERE coa.AccountCode IN ('1010', '1030', '4010', '2020', '2021', '5010', '1220')
GROUP BY coa.AccountCode, coa.AccountName
ORDER BY coa.AccountCode

PRINT ''

-- =============================================
-- 6. TEST FISCAL PERIOD FUNCTION
-- =============================================
PRINT '6. TESTING FISCAL PERIOD FUNCTION'
PRINT '-----------------------------------------'

BEGIN TRY
    DECLARE @TestDate DATE = GETDATE()
    DECLARE @FiscalPeriodID INT
    
    IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'fn_GetCurrentFiscalPeriodID')
    BEGIN
        SELECT @FiscalPeriodID = dbo.fn_GetCurrentFiscalPeriodID(@TestDate)
        
        IF @FiscalPeriodID IS NULL
            PRINT '✗ Fiscal period function returned NULL - check FiscalPeriods table'
        ELSE
            PRINT '✓ Fiscal period function works - returned: ' + CAST(@FiscalPeriodID AS NVARCHAR)
    END
    ELSE
        PRINT '✗ Fiscal period function does not exist'
END TRY
BEGIN CATCH
    PRINT '✗ Fiscal period function ERROR: ' + ERROR_MESSAGE()
END CATCH

PRINT ''

-- =============================================
-- 7. MANUAL TEST OF GL POSTING PROCEDURE
-- =============================================
PRINT '7. MANUAL TEST OF sp_POS_PostSaleToGL'
PRINT '-----------------------------------------'

BEGIN TRY
    -- Get a recent sale to test with
    DECLARE @TestInvoice NVARCHAR(50)
    DECLARE @TestBranch INT
    DECLARE @TestCashier INT
    
    SELECT TOP 1
        @TestInvoice = InvoiceNumber,
        @TestBranch = BranchID,
        @TestCashier = ISNULL(CashierID, 1)
    FROM Demo_Sales
    WHERE SaleDate >= DATEADD(DAY, -7, GETDATE())
    ORDER BY SaleDate DESC
    
    IF @TestInvoice IS NOT NULL
    BEGIN
        PRINT 'Testing with invoice: ' + @TestInvoice
        
        EXEC sp_POS_PostSaleToGL
            @InvoiceNumber = @TestInvoice,
            @SaleDate = @TestDate,
            @BranchID = @TestBranch,
            @CashierID = @TestCashier,
            @Subtotal = 100.00,
            @TaxAmount = 15.00,
            @TotalAmount = 115.00,
            @CashAmount = 115.00,
            @CardAmount = 0.00,
            @TotalCost = 60.00,
            @CreatedBy = @TestCashier
        
        PRINT '✓ Procedure executed without error'
        PRINT 'Check JournalHeaders for new journal'
    END
    ELSE
        PRINT '✗ No recent sales found to test with'
END TRY
BEGIN CATCH
    PRINT '✗ PROCEDURE FAILED: ' + ERROR_MESSAGE()
    PRINT 'This is the root cause of GL posting failure'
END CATCH

PRINT ''

-- =============================================
-- 8. SUMMARY AND RECOMMENDATIONS
-- =============================================
PRINT '========================================='
PRINT 'DIAGNOSTIC COMPLETE'
PRINT 'Completed: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT '========================================='
PRINT ''
PRINT 'NEXT STEPS:'
PRINT '1. Review all ✗ errors above'
PRINT '2. Fix missing procedures/functions/accounts'
PRINT '3. Deploy updated procedures if needed'
PRINT '4. Rebuild POS application'
PRINT '5. Test with a new sale'
PRINT '6. Verify journal appears in JournalHeaders'
PRINT '7. Check GL Inquiry for account 4010 (Sales Revenue)'
PRINT ''
