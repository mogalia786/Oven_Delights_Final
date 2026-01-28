-- Check if the latest cash sale created a GL journal

-- 1. Most recent sale
SELECT TOP 1
    InvoiceNumber,
    SaleDate,
    PaymentMethod,
    CashAmount,
    CardAmount,
    TotalAmount
FROM Demo_Sales
ORDER BY SaleDate DESC, InvoiceNumber DESC

-- 2. Check for corresponding GL journal
DECLARE @LatestInvoice NVARCHAR(50)
SELECT TOP 1 @LatestInvoice = InvoiceNumber
FROM Demo_Sales
ORDER BY SaleDate DESC, InvoiceNumber DESC

DECLARE @ExpectedJournalNumber NVARCHAR(20)
SET @ExpectedJournalNumber = 'POS-' + RIGHT(@LatestInvoice, CHARINDEX('-', REVERSE(@LatestInvoice)) - 1)

PRINT 'Latest Invoice: ' + @LatestInvoice
PRINT 'Expected Journal: ' + @ExpectedJournalNumber
PRINT ''

-- 3. Check if journal exists
IF EXISTS (SELECT 1 FROM JournalHeaders WHERE JournalNumber = @ExpectedJournalNumber)
BEGIN
    PRINT '✓ GL Journal EXISTS for latest sale'
    
    -- Show journal details
    SELECT 
        jh.JournalNumber,
        jh.JournalDate,
        jh.Description,
        jd.LineNumber,
        coa.AccountCode,
        coa.AccountName,
        jd.Debit,
        jd.Credit,
        jd.Description AS LineDescription
    FROM JournalHeaders jh
    INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
    INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
    WHERE jh.JournalNumber = @ExpectedJournalNumber
    ORDER BY jd.LineNumber
END
ELSE
BEGIN
    PRINT '✗ NO GL Journal found for latest sale'
    PRINT 'GL posting may have failed silently'
END
