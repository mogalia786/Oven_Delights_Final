-- =============================================
-- PHASE 1.3: TEST AP WORKFLOW & VERIFY GL ENTRIES
-- Comprehensive testing with double-entry validation
-- =============================================

PRINT '========================================='
PRINT 'PHASE 1.3: TESTING AP WORKFLOW'
PRINT '========================================='
PRINT ''

-- =============================================
-- TEST 1: ADHOC INVOICE (Rent Expense)
-- =============================================
PRINT 'TEST 1: Adhoc Invoice - Rent Expense'
PRINT '-------------------------------------'
PRINT 'Expected Journal Entry:'
PRINT 'DR 6010 Rent Expense        R10,000.00'
PRINT 'DR 2021 VAT Input            R1,500.00'
PRINT 'CR 2030 Accounts Payable              R11,500.00'
PRINT ''

EXEC sp_AP_PostAdhocInvoiceToGL
    @InvoiceID = 1,
    @InvoiceNumber = 'INV-RENT-001',
    @InvoiceDate = '2026-01-28',
    @SupplierName = 'ABC Property Management',
    @BranchID = 2,
    @SubtotalAmount = 10000.00,
    @VATAmount = 1500.00,
    @TotalAmount = 11500.00,
    @ExpenseAccountCode = '6010',
    @CreatedBy = 1

-- Verify journal entry
PRINT ''
PRINT 'Actual Journal Entry:'
SELECT 
    jh.JournalNumber,
    jh.JournalDate,
    jh.Description,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit,
    jd.Description AS LineDescription
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jh.JournalNumber = 'AP-INV-RENT-001'
ORDER BY jd.LineNumber

-- Verify double-entry (Debits = Credits)
PRINT ''
PRINT 'Double-Entry Verification:'
SELECT 
    jh.JournalNumber,
    SUM(jd.Debit) AS TotalDebits,
    SUM(jd.Credit) AS TotalCredits,
    SUM(jd.Debit) - SUM(jd.Credit) AS Difference,
    CASE 
        WHEN SUM(jd.Debit) = SUM(jd.Credit) THEN '✓ BALANCED'
        ELSE '✗ OUT OF BALANCE'
    END AS Status
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
WHERE jh.JournalNumber = 'AP-INV-RENT-001'
GROUP BY jh.JournalNumber

PRINT ''
PRINT '========================================='
PRINT ''

-- =============================================
-- TEST 2: ADHOC INVOICE (Utilities)
-- =============================================
PRINT 'TEST 2: Adhoc Invoice - Utilities'
PRINT '----------------------------------'
PRINT 'Expected Journal Entry:'
PRINT 'DR 6020 Utilities Expense    R2,500.00'
PRINT 'DR 2021 VAT Input              R375.00'
PRINT 'CR 2030 Accounts Payable              R2,875.00'
PRINT ''

EXEC sp_AP_PostAdhocInvoiceToGL
    @InvoiceID = 2,
    @InvoiceNumber = 'INV-UTIL-001',
    @InvoiceDate = '2026-01-28',
    @SupplierName = 'City Power',
    @BranchID = 2,
    @SubtotalAmount = 2500.00,
    @VATAmount = 375.00,
    @TotalAmount = 2875.00,
    @ExpenseAccountCode = '6020',
    @CreatedBy = 1

PRINT ''
PRINT 'Actual Journal Entry:'
SELECT 
    jh.JournalNumber,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jh.JournalNumber = 'AP-INV-UTIL-001'
ORDER BY jd.LineNumber

PRINT ''
PRINT 'Double-Entry Verification:'
SELECT 
    jh.JournalNumber,
    SUM(jd.Debit) AS TotalDebits,
    SUM(jd.Credit) AS TotalCredits,
    SUM(jd.Debit) - SUM(jd.Credit) AS Difference,
    CASE 
        WHEN SUM(jd.Debit) = SUM(jd.Credit) THEN '✓ BALANCED'
        ELSE '✗ OUT OF BALANCE'
    END AS Status
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
WHERE jh.JournalNumber = 'AP-INV-UTIL-001'
GROUP BY jh.JournalNumber

PRINT ''
PRINT '========================================='
PRINT ''

-- =============================================
-- TEST 3: SINGLE PAYMENT (EFT)
-- =============================================
PRINT 'TEST 3: Single Payment - EFT'
PRINT '----------------------------'
PRINT 'Expected Journal Entry:'
PRINT 'DR 2030 Accounts Payable    R11,500.00'
PRINT 'CR 1010 Bank                          R11,500.00'
PRINT ''

EXEC sp_AP_PostSinglePaymentToGL
    @InvoiceID = 1,
    @PaymentNumber = 'PAY-001',
    @PaymentDate = '2026-01-29',
    @SupplierName = 'ABC Property Management',
    @Amount = 11500.00,
    @PaymentMethod = 'EFT',
    @BranchID = 2,
    @CreatedBy = 1

PRINT ''
PRINT 'Actual Journal Entry:'
SELECT 
    jh.JournalNumber,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jh.JournalNumber = 'PAY-PAY-001'
ORDER BY jd.LineNumber

PRINT ''
PRINT 'Double-Entry Verification:'
SELECT 
    jh.JournalNumber,
    SUM(jd.Debit) AS TotalDebits,
    SUM(jd.Credit) AS TotalCredits,
    SUM(jd.Debit) - SUM(jd.Credit) AS Difference,
    CASE 
        WHEN SUM(jd.Debit) = SUM(jd.Credit) THEN '✓ BALANCED'
        ELSE '✗ OUT OF BALANCE'
    END AS Status
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
WHERE jh.JournalNumber = 'PAY-PAY-001'
GROUP BY jh.JournalNumber

PRINT ''
PRINT '========================================='
PRINT ''

-- =============================================
-- TEST 4: CREDIT NOTE
-- =============================================
PRINT 'TEST 4: Credit Note - Utilities Reversal'
PRINT '----------------------------------------'
PRINT 'Expected Journal Entry:'
PRINT 'DR 2030 Accounts Payable     R2,875.00'
PRINT 'CR 6020 Utilities Expense              R2,500.00'
PRINT 'CR 2021 VAT Input                        R375.00'
PRINT ''

EXEC sp_AP_PostCreditNoteToGL
    @CreditNoteID = 1,
    @CreditNoteNumber = 'CN-001',
    @CreditNoteDate = '2026-01-30',
    @SupplierName = 'City Power',
    @BranchID = 2,
    @SubtotalAmount = 2500.00,
    @VATAmount = 375.00,
    @TotalAmount = 2875.00,
    @ExpenseAccountCode = '6020',
    @CreatedBy = 1

PRINT ''
PRINT 'Actual Journal Entry:'
SELECT 
    jh.JournalNumber,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jh.JournalNumber = 'CN-CN-001'
ORDER BY jd.LineNumber

PRINT ''
PRINT 'Double-Entry Verification:'
SELECT 
    jh.JournalNumber,
    SUM(jd.Debit) AS TotalDebits,
    SUM(jd.Credit) AS TotalCredits,
    SUM(jd.Debit) - SUM(jd.Credit) AS Difference,
    CASE 
        WHEN SUM(jd.Debit) = SUM(jd.Credit) THEN '✓ BALANCED'
        ELSE '✗ OUT OF BALANCE'
    END AS Status
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
WHERE jh.JournalNumber = 'CN-CN-001'
GROUP BY jh.JournalNumber

PRINT ''
PRINT '========================================='
PRINT ''

-- =============================================
-- SUMMARY: ACCOUNT BALANCES AFTER AP TESTS
-- =============================================
PRINT 'ACCOUNT BALANCES AFTER AP TESTS'
PRINT '================================'
PRINT ''

SELECT 
    coa.AccountCode,
    coa.AccountName,
    coa.AccountType,
    ISNULL(SUM(jd.Debit), 0) AS TotalDebits,
    ISNULL(SUM(jd.Credit), 0) AS TotalCredits,
    ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0) AS Balance,
    CASE 
        WHEN coa.AccountType IN ('Asset', 'Expense') THEN 
            CASE WHEN ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0) >= 0 THEN 'Normal' ELSE 'Abnormal' END
        WHEN coa.AccountType IN ('Liability', 'Revenue') THEN
            CASE WHEN ISNULL(SUM(jd.Debit), 0) - ISNULL(SUM(jd.Credit), 0) <= 0 THEN 'Normal' ELSE 'Abnormal' END
        ELSE 'Check'
    END AS BalanceType
FROM ChartOfAccounts coa
LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
WHERE coa.AccountCode IN ('1010', '2030', '2021', '6010', '6020')
    AND (jh.JournalNumber LIKE 'AP-%' 
         OR jh.JournalNumber LIKE 'PAY-%' 
         OR jh.JournalNumber LIKE 'CN-%'
         OR jh.JournalID IS NULL)
GROUP BY coa.AccountCode, coa.AccountName, coa.AccountType
ORDER BY coa.AccountCode

PRINT ''
PRINT '========================================='
PRINT 'VERIFICATION: ACCOUNT 2010 vs 2030'
PRINT '========================================='
PRINT ''
PRINT 'Checking that Account 2010 has NO AP transactions...'
PRINT ''

SELECT 
    jh.JournalNumber,
    jh.JournalDate,
    jh.Description,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE coa.AccountCode = '2010'
    AND (jh.JournalNumber LIKE 'AP-%' 
         OR jh.JournalNumber LIKE 'PAY-%' 
         OR jh.JournalNumber LIKE 'CN-%')

IF @@ROWCOUNT = 0
    PRINT '✓ CORRECT: Account 2010 has no AP transactions'
ELSE
    PRINT '✗ ERROR: Account 2010 still has AP transactions!'

PRINT ''
PRINT 'Checking that Account 2030 has AP transactions...'
PRINT ''

SELECT 
    jh.JournalNumber,
    jh.JournalDate,
    jh.Description,
    SUM(jd.Debit) AS TotalDebits,
    SUM(jd.Credit) AS TotalCredits
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE coa.AccountCode = '2030'
    AND (jh.JournalNumber LIKE 'AP-%' 
         OR jh.JournalNumber LIKE 'PAY-%' 
         OR jh.JournalNumber LIKE 'CN-%')
GROUP BY jh.JournalNumber, jh.JournalDate, jh.Description
ORDER BY jh.JournalDate

IF @@ROWCOUNT > 0
    PRINT '✓ CORRECT: Account 2030 has AP transactions'
ELSE
    PRINT '✗ ERROR: Account 2030 has no AP transactions!'

PRINT ''
PRINT '========================================='
PRINT 'OVERALL TRIAL BALANCE CHECK'
PRINT '========================================='
PRINT ''

SELECT 
    'Total Debits' AS Description,
    SUM(jd.Debit) AS Amount
FROM JournalDetails jd
INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
WHERE jh.JournalNumber LIKE 'AP-%' 
   OR jh.JournalNumber LIKE 'PAY-%' 
   OR jh.JournalNumber LIKE 'CN-%'

UNION ALL

SELECT 
    'Total Credits' AS Description,
    SUM(jd.Credit) AS Amount
FROM JournalDetails jd
INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
WHERE jh.JournalNumber LIKE 'AP-%' 
   OR jh.JournalNumber LIKE 'PAY-%' 
   OR jh.JournalNumber LIKE 'CN-%'

UNION ALL

SELECT 
    'Difference (Should be 0)' AS Description,
    SUM(jd.Debit) - SUM(jd.Credit) AS Amount
FROM JournalDetails jd
INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
WHERE jh.JournalNumber LIKE 'AP-%' 
   OR jh.JournalNumber LIKE 'PAY-%' 
   OR jh.JournalNumber LIKE 'CN-%'

PRINT ''
PRINT '========================================='
PRINT 'PHASE 1.3 TESTING COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'Summary:'
PRINT '- 4 test transactions executed'
PRINT '- All journals verified for double-entry (Debits = Credits)'
PRINT '- Account 2010 reserved for Customer Deposits only'
PRINT '- Account 2030 used for Accounts Payable'
PRINT '- Trial balance verified'
PRINT ''
