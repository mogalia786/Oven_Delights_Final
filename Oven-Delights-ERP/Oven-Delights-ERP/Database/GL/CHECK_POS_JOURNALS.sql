-- Quick check: Are POS sales posting to GL?

-- 1. Recent POS sales
SELECT TOP 10 
    InvoiceNumber, 
    SaleDate, 
    TotalAmount,
    BranchID,
    CashierID
FROM Demo_Sales 
ORDER BY SaleDate DESC, InvoiceNumber DESC

-- 2. Check for POS journals
SELECT TOP 10
    JournalNumber,
    JournalDate,
    Description,
    BranchID,
    CreatedBy
FROM JournalHeaders
WHERE JournalNumber LIKE 'POS-%'
ORDER BY JournalID DESC

-- 3. If no POS journals, check ALL recent journals
IF NOT EXISTS (SELECT 1 FROM JournalHeaders WHERE JournalNumber LIKE 'POS-%')
BEGIN
    PRINT 'NO POS JOURNALS FOUND - Showing all recent journals:'
    SELECT TOP 10
        JournalNumber,
        JournalDate,
        Description,
        BranchID
    FROM JournalHeaders
    ORDER BY JournalID DESC
END

-- 4. Check if procedure exists
IF NOT EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'sp_POS_PostSaleToGL')
    PRINT 'ERROR: sp_POS_PostSaleToGL does NOT exist!'
ELSE
    PRINT 'sp_POS_PostSaleToGL exists'

-- 5. Check GL accounts
SELECT AccountCode, AccountName, IsActive
FROM ChartOfAccounts
WHERE AccountCode IN ('1010', '1030', '4010', '2020', '5010', '1220')
ORDER BY AccountCode
