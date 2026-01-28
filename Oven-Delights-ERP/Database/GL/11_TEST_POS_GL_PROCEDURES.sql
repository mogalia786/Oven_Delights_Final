-- =============================================
-- TEST SCRIPT FOR POS GL PROCEDURES
-- Tests all transaction types
-- =============================================

PRINT '========================================='
PRINT 'TESTING POS GL PROCEDURES'
PRINT '========================================='
PRINT ''

-- =============================================
-- TEST 1: CASH SALE
-- =============================================
PRINT '1. Testing Cash Sale (R115 cash, R60 cost)'
PRINT '-----------------------------------------'

EXEC sp_POS_PostSaleToGL
    @InvoiceNumber = '620999',
    @SaleDate = '2026-01-28',
    @BranchID = 2,
    @CashierID = 1,
    @Subtotal = 100.00,
    @TaxAmount = 15.00,
    @TotalAmount = 115.00,
    @CashAmount = 115.00,
    @CardAmount = 0.00,
    @EFTAmount = 0.00,
    @TotalCost = 60.00,
    @CreatedBy = 1

-- Verify journal
SELECT 'Cash Sale Journal:' AS Test
SELECT 
    jh.JournalNumber,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jh.JournalNumber = 'POS-620999'
ORDER BY jd.LineNumber

PRINT ''

-- =============================================
-- TEST 2: CARD SALE
-- =============================================
PRINT '2. Testing Card Sale (R115 card, R60 cost)'
PRINT '-----------------------------------------'

EXEC sp_POS_PostSaleToGL
    @InvoiceNumber = '620998',
    @SaleDate = '2026-01-28',
    @BranchID = 2,
    @CashierID = 1,
    @Subtotal = 100.00,
    @TaxAmount = 15.00,
    @TotalAmount = 115.00,
    @CashAmount = 0.00,
    @CardAmount = 115.00,
    @EFTAmount = 0.00,
    @TotalCost = 60.00,
    @CreatedBy = 1

-- Verify journal
SELECT 'Card Sale Journal:' AS Test
SELECT 
    jh.JournalNumber,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jh.JournalNumber = 'POS-620998'
ORDER BY jd.LineNumber

PRINT ''

-- =============================================
-- TEST 3: EFT SALE
-- =============================================
PRINT '3. Testing EFT Sale (R115 EFT, R60 cost)'
PRINT '-----------------------------------------'

EXEC sp_POS_PostSaleToGL
    @InvoiceNumber = '620997',
    @SaleDate = '2026-01-28',
    @BranchID = 2,
    @CashierID = 1,
    @Subtotal = 100.00,
    @TaxAmount = 15.00,
    @TotalAmount = 115.00,
    @CashAmount = 0.00,
    @CardAmount = 0.00,
    @EFTAmount = 115.00,
    @TotalCost = 60.00,
    @CreatedBy = 1

-- Verify journal
SELECT 'EFT Sale Journal:' AS Test
SELECT 
    jh.JournalNumber,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jh.JournalNumber = 'POS-620997'
ORDER BY jd.LineNumber

PRINT ''

-- =============================================
-- TEST 4: MIXED PAYMENT SALE
-- =============================================
PRINT '4. Testing Mixed Payment Sale (R50 cash + R65 card, R60 cost)'
PRINT '-----------------------------------------'

EXEC sp_POS_PostSaleToGL
    @InvoiceNumber = '620996',
    @SaleDate = '2026-01-28',
    @BranchID = 2,
    @CashierID = 1,
    @Subtotal = 100.00,
    @TaxAmount = 15.00,
    @TotalAmount = 115.00,
    @CashAmount = 50.00,
    @CardAmount = 65.00,
    @EFTAmount = 0.00,
    @TotalCost = 60.00,
    @CreatedBy = 1

-- Verify journal
SELECT 'Mixed Payment Sale Journal:' AS Test
SELECT 
    jh.JournalNumber,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jh.JournalNumber = 'POS-620996'
ORDER BY jd.LineNumber

PRINT ''

-- =============================================
-- TEST 5: ORDER DEPOSIT (CASH)
-- =============================================
PRINT '5. Testing Order Deposit (R200 cash)'
PRINT '-----------------------------------------'

EXEC sp_POS_PostOrderDepositToGL
    @OrderNumber = 'O-JHB-000123',
    @DepositDate = '2026-01-28',
    @BranchID = 2,
    @CashierID = 1,
    @DepositAmount = 200.00,
    @PaymentMethod = 'Cash',
    @CreatedBy = 1

-- Verify journal
SELECT 'Order Deposit Journal:' AS Test
SELECT 
    jh.JournalNumber,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jh.JournalNumber = 'DEP-000123'
ORDER BY jd.LineNumber

PRINT ''

-- =============================================
-- TEST 6: ORDER COLLECTION
-- =============================================
PRINT '6. Testing Order Collection (R500 total, R200 deposit, R300 card balance, R250 cost)'
PRINT '-----------------------------------------'

EXEC sp_POS_PostOrderCollectionToGL
    @OrderNumber = 'O-JHB-000123',
    @InvoiceNumber = '620995',
    @CollectionDate = '2026-01-29',
    @BranchID = 2,
    @CashierID = 1,
    @TotalAmount = 500.00,
    @Subtotal = 434.78,
    @TaxAmount = 65.22,
    @DepositAmount = 200.00,
    @BalanceAmount = 300.00,
    @BalancePaymentMethod = 'Card',
    @TotalCost = 250.00,
    @CreatedBy = 1

-- Verify journal
SELECT 'Order Collection Journal:' AS Test
SELECT 
    jh.JournalNumber,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jh.JournalNumber = 'ORD-620995'
ORDER BY jd.LineNumber

PRINT ''

-- =============================================
-- TEST 7: CASH REFUND
-- =============================================
PRINT '7. Testing Cash Refund (R115 cash refund, R60 cost)'
PRINT '-----------------------------------------'

EXEC sp_POS_PostRefundToGL
    @ReturnNumber = 'RET-620999',
    @RefundDate = '2026-01-28',
    @BranchID = 2,
    @CashierID = 1,
    @Subtotal = 100.00,
    @TaxAmount = 15.00,
    @TotalAmount = 115.00,
    @RefundMethod = 'Cash',
    @TotalCost = 60.00,
    @CreatedBy = 1

-- Verify journal
SELECT 'Cash Refund Journal:' AS Test
SELECT 
    jh.JournalNumber,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jh.JournalNumber = 'REF-620999'
ORDER BY jd.LineNumber

PRINT ''

-- =============================================
-- TEST 8: CARD REFUND
-- =============================================
PRINT '8. Testing Card Refund (R115 card refund, R60 cost)'
PRINT '-----------------------------------------'

EXEC sp_POS_PostRefundToGL
    @ReturnNumber = 'RET-620998',
    @RefundDate = '2026-01-28',
    @BranchID = 2,
    @CashierID = 1,
    @Subtotal = 100.00,
    @TaxAmount = 15.00,
    @TotalAmount = 115.00,
    @RefundMethod = 'Card',
    @TotalCost = 60.00,
    @CreatedBy = 1

-- Verify journal
SELECT 'Card Refund Journal:' AS Test
SELECT 
    jh.JournalNumber,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jh.JournalNumber = 'REF-620998'
ORDER BY jd.LineNumber

PRINT ''

-- =============================================
-- TEST 9: CASH DEPOSIT TO BANK
-- =============================================
PRINT '9. Testing Cash Deposit to Bank (R5000)'
PRINT '-----------------------------------------'

EXEC sp_POS_PostCashDepositToGL
    @DepositReference = '20260128-001',
    @DepositDate = '2026-01-28',
    @BranchID = 2,
    @DepositAmount = 5000.00,
    @CreatedBy = 1

-- Verify journal
SELECT 'Cash Deposit Journal:' AS Test
SELECT 
    jh.JournalNumber,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jh.JournalNumber = 'CDEP-20260128-001'
ORDER BY jd.LineNumber

PRINT ''

-- =============================================
-- TEST 10: EFT CLEARING
-- =============================================
PRINT '10. Testing EFT Clearing (R2300)'
PRINT '-----------------------------------------'

EXEC sp_POS_PostEFTClearingToGL
    @ClearingReference = '20260128-EFT-001',
    @ClearingDate = '2026-01-28',
    @BranchID = 2,
    @ClearingAmount = 2300.00,
    @CreatedBy = 1

-- Verify journal
SELECT 'EFT Clearing Journal:' AS Test
SELECT 
    jh.JournalNumber,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jh.JournalNumber = 'EFTC-20260128-EFT-001'
ORDER BY jd.LineNumber

PRINT ''

-- =============================================
-- SUMMARY: CHECK ALL GL ACCOUNT BALANCES
-- =============================================
PRINT '========================================='
PRINT 'GL ACCOUNT BALANCES AFTER ALL TESTS'
PRINT '========================================='

SELECT 
    coa.AccountCode,
    coa.AccountName,
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
WHERE coa.AccountCode IN ('1010', '1030', '1050', '1220', '2010', '2020', '2021', '4010', '4020', '5010')
    AND (jh.JournalNumber LIKE 'POS-%' 
         OR jh.JournalNumber LIKE 'DEP-%' 
         OR jh.JournalNumber LIKE 'ORD-%' 
         OR jh.JournalNumber LIKE 'REF-%'
         OR jh.JournalNumber LIKE 'CDEP-%'
         OR jh.JournalNumber LIKE 'EFTC-%'
         OR jh.JournalID IS NULL)
GROUP BY coa.AccountCode, coa.AccountName, coa.AccountType
ORDER BY coa.AccountCode

PRINT ''
PRINT '========================================='
PRINT 'TESTING COMPLETE'
PRINT '========================================='
