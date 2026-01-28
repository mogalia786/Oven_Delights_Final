-- =============================================
-- DIAGNOSTIC SCRIPT - POS GL POSTING
-- Run this on Azure to check if POS sales are posting to GL
-- =============================================

PRINT '========================================='
PRINT 'POS GL POSTING DIAGNOSTIC'
PRINT '========================================='
PRINT ''

-- 1. Check if stored procedure exists
PRINT '1. Checking if sp_POS_PostSaleToGL exists...'
IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_POS_PostSaleToGL')
    PRINT '   ✓ Procedure EXISTS'
ELSE
    PRINT '   ✗ Procedure DOES NOT EXIST - Deploy 09_POS_Integration_Procedures.sql'
PRINT ''

-- 2. Check if fiscal period function exists
PRINT '2. Checking if fn_GetCurrentFiscalPeriodID exists...'
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'fn_GetCurrentFiscalPeriodID' AND type = 'FN')
    PRINT '   ✓ Function EXISTS'
ELSE
    PRINT '   ✗ Function DOES NOT EXIST - Deploy 00_Get_Current_FiscalPeriod_Function.sql'
PRINT ''

-- 3. Check required GL accounts exist
PRINT '3. Checking required GL accounts...'
DECLARE @MissingAccounts TABLE (AccountCode NVARCHAR(10), AccountName NVARCHAR(100))

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('1010', 'Bank Account')
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1030' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('1030', 'Cash on Hand')
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4010' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('4010', 'Sales Revenue')
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2020' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('2020', 'VAT Output')
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5010' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('5010', 'Cost of Goods Sold')
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1220' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('1220', 'Retail Inventory')

IF EXISTS (SELECT 1 FROM @MissingAccounts)
BEGIN
    PRINT '   ✗ MISSING ACCOUNTS:'
    SELECT '   - ' + AccountCode + ': ' + AccountName FROM @MissingAccounts
    PRINT '   Deploy 20_Create_Missing_GL_Accounts.sql'
END
ELSE
    PRINT '   ✓ All required accounts exist'
PRINT ''

-- 4. Check recent POS sales
PRINT '4. Checking recent POS sales (last 5)...'
IF EXISTS (SELECT 1 FROM Demo_Sales)
BEGIN
    SELECT TOP 5 
        InvoiceNumber, 
        SaleDate, 
        TotalAmount,
        PaymentMethod,
        BranchID
    FROM Demo_Sales 
    ORDER BY SaleDate DESC
    PRINT ''
END
ELSE
    PRINT '   No sales found in Demo_Sales table'
PRINT ''

-- 5. Check if POS sales have corresponding GL journals
PRINT '5. Checking if POS sales have GL journal entries...'
IF EXISTS (SELECT 1 FROM JournalHeaders WHERE JournalNumber LIKE 'POS-%')
BEGIN
    PRINT '   ✓ POS journals found:'
    SELECT TOP 5
        JournalNumber,
        JournalDate,
        Description,
        BranchID
    FROM JournalHeaders
    WHERE JournalNumber LIKE 'POS-%'
    ORDER BY JournalID DESC
    PRINT ''
END
ELSE
BEGIN
    PRINT '   ✗ NO POS journals found in JournalHeaders'
    PRINT '   This means POS is NOT posting to GL'
    PRINT ''
    PRINT '   POSSIBLE CAUSES:'
    PRINT '   1. POS application not rebuilt after code changes'
    PRINT '   2. GL posting procedure not deployed to Azure'
    PRINT '   3. GL posting is failing silently (check POS Debug output)'
END
PRINT ''

-- 6. Check GL account balances
PRINT '6. Current GL Account Balances (relevant accounts)...'
SELECT 
    coa.AccountCode,
    coa.AccountName,
    ISNULL(SUM(jd.DebitAmount), 0) AS TotalDebits,
    ISNULL(SUM(jd.CreditAmount), 0) AS TotalCredits,
    ISNULL(SUM(jd.DebitAmount), 0) - ISNULL(SUM(jd.CreditAmount), 0) AS Balance
FROM ChartOfAccounts coa
LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
WHERE coa.AccountCode IN ('1010', '1030', '4010', '2020', '5010', '1220')
GROUP BY coa.AccountCode, coa.AccountName
ORDER BY coa.AccountCode
PRINT ''

-- 7. Test the procedure manually
PRINT '7. Testing sp_POS_PostSaleToGL with sample data...'
PRINT '   (This will create a test journal entry)'
BEGIN TRY
    DECLARE @TestInvoice NVARCHAR(50) = 'TEST-POS-' + CONVERT(NVARCHAR, GETDATE(), 112)
    
    EXEC sp_POS_PostSaleToGL
        @InvoiceNumber = @TestInvoice,
        @SaleDate = '2026-01-27',
        @BranchID = 1,
        @CashierID = 1,
        @Subtotal = 100.00,
        @TaxAmount = 15.00,
        @TotalAmount = 115.00,
        @CashAmount = 115.00,
        @CardAmount = 0.00,
        @TotalCost = 60.00,
        @CreatedBy = 1
    
    PRINT '   ✓ Test procedure executed successfully'
    PRINT '   Check JournalHeaders for journal: ' + @TestInvoice
END TRY
BEGIN CATCH
    PRINT '   ✗ Test procedure FAILED:'
    PRINT '   Error: ' + ERROR_MESSAGE()
END CATCH
PRINT ''

PRINT '========================================='
PRINT 'DIAGNOSTIC COMPLETE'
PRINT '========================================='
