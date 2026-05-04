-- =============================================
-- DIAGNOSE SUPPLIER LEDGER ISSUE
-- Check if supplier subsidiary ledgers exist and are linked correctly
-- =============================================

PRINT ''
PRINT '========================================='
PRINT 'SUPPLIER LEDGER DIAGNOSTIC'
PRINT '========================================='
PRINT ''

-- 1. Check if supplier subsidiary ledgers exist in ChartOfAccounts
PRINT 'Step 1: Checking supplier subsidiary ledgers in ChartOfAccounts...'
PRINT ''

SELECT 
    AccountCode,
    AccountName,
    AccountType,
    SupplierID,
    IsSubsidiaryLedger,
    IsActive
FROM ChartOfAccounts
WHERE AccountCode LIKE '2100%'
   OR (IsSubsidiaryLedger = 1 AND AccountType = 'Liability')
ORDER BY AccountCode

PRINT ''

-- 2. Check AP_Invoices and their beneficiaries
PRINT 'Step 2: Checking AP_Invoices and beneficiaries...'
PRINT ''

SELECT TOP 20
    i.InvoiceID,
    i.InvoiceNumber,
    i.BeneficiaryID,
    b.BeneficiaryName,
    i.TotalAmount,
    i.Status,
    i.InvoiceDate
FROM AP_Invoices i
LEFT JOIN AP_Beneficiaries b ON i.BeneficiaryID = b.BeneficiaryID
ORDER BY i.InvoiceDate DESC

PRINT ''

-- 3. Check if beneficiaries are linked to ChartOfAccounts
PRINT 'Step 3: Checking beneficiary to ChartOfAccounts linkage...'
PRINT ''

SELECT 
    b.BeneficiaryID,
    b.BeneficiaryName,
    coa.AccountCode,
    coa.AccountName,
    coa.IsSubsidiaryLedger
FROM AP_Beneficiaries b
LEFT JOIN ChartOfAccounts coa ON b.BeneficiaryID = coa.SupplierID
ORDER BY b.BeneficiaryName

PRINT ''

-- 4. Check recent bank statement transactions
PRINT 'Step 4: Checking recent bank statement transactions...'
PRINT ''

SELECT TOP 20
    TransactionID,
    TransactionDate,
    Description,
    Reference,
    Amount,
    CreditDebitIndicator,
    IsReconciled,
    IsMapped,
    MappedLedgerAccount
FROM AP_StatementTransactions
WHERE CreditDebitIndicator = 'Debit'
ORDER BY TransactionDate DESC

PRINT ''

-- 5. Check GeneralLedger entries for supplier accounts
PRINT 'Step 5: Checking GeneralLedger entries for supplier accounts...'
PRINT ''

SELECT TOP 20
    JournalEntryNumber,
    AccountID,
    TransactionDate,
    Description,
    DebitAmount,
    CreditAmount,
    ReferenceID
FROM GeneralLedger
WHERE AccountID LIKE '2100%'
ORDER BY TransactionDate DESC

PRINT ''
PRINT '========================================='
PRINT 'DIAGNOSTIC COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'Analysis:'
PRINT '1. If no supplier subsidiary ledgers exist in ChartOfAccounts, they need to be created'
PRINT '2. If beneficiaries are not linked to ChartOfAccounts (SupplierID), create the linkage'
PRINT '3. If MappedLedgerAccount shows generic accounts (2100), invoice matching is failing'
PRINT '4. If GeneralLedger shows only 2100 (not 2100-XXX), subsidiary ledgers are not being used'
PRINT ''
