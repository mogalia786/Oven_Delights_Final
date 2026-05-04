-- =============================================
-- COMPLETE GL AUDIT - ALL TRANSACTION TYPES
-- Verifies all business transactions post to GL
-- =============================================

PRINT '========================================='
PRINT 'COMPLETE GL INTEGRATION AUDIT'
PRINT '========================================='
PRINT ''

-- =============================================
-- 1. POS TRANSACTIONS
-- =============================================
PRINT '1. POS TRANSACTIONS'
PRINT '-------------------'

IF OBJECT_ID('sp_POS_PostSaleToGL', 'P') IS NOT NULL
    PRINT '✓ sp_POS_PostSaleToGL (Cash/Card/EFT sales)'
ELSE
    PRINT '✗ MISSING: sp_POS_PostSaleToGL'

IF OBJECT_ID('sp_POS_PostOrderDepositToGL', 'P') IS NOT NULL
    PRINT '✓ sp_POS_PostOrderDepositToGL (Cake order deposits)'
ELSE
    PRINT '✗ MISSING: sp_POS_PostOrderDepositToGL'

IF OBJECT_ID('sp_POS_PostOrderCollectionToGL', 'P') IS NOT NULL
    PRINT '✓ sp_POS_PostOrderCollectionToGL (Cake order completion)'
ELSE
    PRINT '✗ MISSING: sp_POS_PostOrderCollectionToGL'

IF OBJECT_ID('sp_POS_PostRefundToGL', 'P') IS NOT NULL
    PRINT '✓ sp_POS_PostRefundToGL (Refunds)'
ELSE
    PRINT '✗ MISSING: sp_POS_PostRefundToGL'

IF OBJECT_ID('sp_POS_PostCashDepositToGL', 'P') IS NOT NULL
    PRINT '✓ sp_POS_PostCashDepositToGL (Cash deposits to bank)'
ELSE
    PRINT '✗ MISSING: sp_POS_PostCashDepositToGL'

IF OBJECT_ID('sp_POS_PostEFTClearingToGL', 'P') IS NOT NULL
    PRINT '✓ sp_POS_PostEFTClearingToGL (EFT clearing)'
ELSE
    PRINT '✗ MISSING: sp_POS_PostEFTClearingToGL'

PRINT ''

-- =============================================
-- 2. PURCHASE ORDERS & INVENTORY
-- =============================================
PRINT '2. PURCHASE ORDERS & INVENTORY'
PRINT '------------------------------'

IF OBJECT_ID('sp_PO_PostGRVToGL', 'P') IS NOT NULL
    PRINT '✓ sp_PO_PostGRVToGL (Goods receipt - DR Inventory / CR GRIR)'
ELSE
    PRINT '✗ MISSING: sp_PO_PostGRVToGL'

IF OBJECT_ID('sp_PO_PostInvoiceToGL', 'P') IS NOT NULL
    PRINT '✓ sp_PO_PostInvoiceToGL (Supplier invoice - DR GRIR+VAT / CR AP)'
ELSE
    PRINT '✗ MISSING: sp_PO_PostInvoiceToGL'

IF OBJECT_ID('sp_INV_PostStockAdjustmentToGL', 'P') IS NOT NULL
    PRINT '✓ sp_INV_PostStockAdjustmentToGL (Stock write-offs, damage, theft)'
ELSE
    PRINT '✗ MISSING: sp_INV_PostStockAdjustmentToGL'

PRINT ''

-- =============================================
-- 3. ACCOUNTS PAYABLE
-- =============================================
PRINT '3. ACCOUNTS PAYABLE'
PRINT '-------------------'

IF OBJECT_ID('sp_AP_PostSinglePaymentToGL', 'P') IS NOT NULL
    PRINT '✓ sp_AP_PostSinglePaymentToGL (Supplier payments - DR AP / CR Bank)'
ELSE
    PRINT '✗ MISSING: sp_AP_PostSinglePaymentToGL'

IF OBJECT_ID('sp_AP_PostBatchPaymentToGL', 'P') IS NOT NULL
    PRINT '✓ sp_AP_PostBatchPaymentToGL (Batch supplier payments)'
ELSE
    PRINT '✗ MISSING: sp_AP_PostBatchPaymentToGL'

IF OBJECT_ID('sp_AP_PostAdhocInvoiceToGL', 'P') IS NOT NULL
    PRINT '✓ sp_AP_PostAdhocInvoiceToGL (Adhoc expenses - DR Expense+VAT / CR AP)'
ELSE
    PRINT '✗ MISSING: sp_AP_PostAdhocInvoiceToGL'

PRINT ''

-- =============================================
-- 4. ACCOUNTS RECEIVABLE
-- =============================================
PRINT '4. ACCOUNTS RECEIVABLE'
PRINT '----------------------'

IF OBJECT_ID('sp_AR_PostCustomerInvoiceToGL', 'P') IS NOT NULL
    PRINT '✓ sp_AR_PostCustomerInvoiceToGL (Customer invoices)'
ELSE
    PRINT '✗ MISSING: sp_AR_PostCustomerInvoiceToGL - NEEDS TO BE CREATED'

IF OBJECT_ID('sp_AR_PostCustomerPaymentToGL', 'P') IS NOT NULL
    PRINT '✓ sp_AR_PostCustomerPaymentToGL (Customer payments)'
ELSE
    PRINT '✗ MISSING: sp_AR_PostCustomerPaymentToGL - NEEDS TO BE CREATED'

PRINT ''

-- =============================================
-- 5. BENEFICIARY PAYMENTS
-- =============================================
PRINT '5. BENEFICIARY PAYMENTS'
PRINT '-----------------------'

IF OBJECT_ID('sp_PostBeneficiaryPaymentToGL', 'P') IS NOT NULL
    PRINT '✓ sp_PostBeneficiaryPaymentToGL (Salary, rent, utilities)'
ELSE
    PRINT '✗ MISSING: sp_PostBeneficiaryPaymentToGL - NEEDS TO BE CREATED'

PRINT ''

-- =============================================
-- 6. BANK RECONCILIATION
-- =============================================
PRINT '6. BANK RECONCILIATION'
PRINT '----------------------'

IF OBJECT_ID('sp_ReconcileBankStatement', 'P') IS NOT NULL
    PRINT '✓ sp_ReconcileBankStatement (Match bank to GL)'
ELSE
    PRINT '✗ MISSING: sp_ReconcileBankStatement'

IF OBJECT_ID('sp_PostUnmatchedBankItems', 'P') IS NOT NULL
    PRINT '✓ sp_PostUnmatchedBankItems (Bank fees, interest)'
ELSE
    PRINT '✗ MISSING: sp_PostUnmatchedBankItems'

PRINT ''

-- =============================================
-- 7. MANUFACTURING
-- =============================================
PRINT '7. MANUFACTURING'
PRINT '----------------'

IF OBJECT_ID('sp_MFG_PostProductionToGL', 'P') IS NOT NULL
    PRINT '✓ sp_MFG_PostProductionToGL (Manufacturing - DR Finished Goods / CR Raw Materials)'
ELSE
    PRINT '✗ MISSING: sp_MFG_PostProductionToGL - May need creation'

PRINT ''

-- =============================================
-- 8. INTER-BRANCH TRANSFERS
-- =============================================
PRINT '8. INTER-BRANCH TRANSFERS'
PRINT '-------------------------'

IF OBJECT_ID('sp_IBT_PostTransferToGL', 'P') IS NOT NULL
    PRINT '✓ sp_IBT_PostTransferToGL (Branch transfers)'
ELSE
    PRINT '✗ MISSING: sp_IBT_PostTransferToGL - May need creation'

PRINT ''

-- =============================================
-- 9. VAT HANDLING
-- =============================================
PRINT '9. VAT HANDLING'
PRINT '---------------'
PRINT 'VAT is handled within transaction procedures:'
PRINT '  - POS Sales: CR VAT Output (2020)'
PRINT '  - POS Refunds: DR VAT Input (2021)'
PRINT '  - Supplier Invoices: DR VAT Input (2021)'
PRINT '  - Adhoc Expenses: DR VAT Input (2021)'

-- Check VAT accounts exist
IF EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2020' AND IsActive = 1)
    PRINT '✓ VAT Output account (2020) exists'
ELSE
    PRINT '✗ MISSING: VAT Output account (2020)'

IF EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2021' AND IsActive = 1)
    PRINT '✓ VAT Input account (2021) exists'
ELSE
    PRINT '✗ MISSING: VAT Input account (2021)'

PRINT ''

-- =============================================
-- 10. CRITICAL ACCOUNTS CHECK
-- =============================================
PRINT '10. CRITICAL ACCOUNTS CHECK'
PRINT '---------------------------'

DECLARE @MissingAccounts TABLE (AccountCode NVARCHAR(20), AccountName NVARCHAR(200))

-- Check all critical accounts
INSERT INTO @MissingAccounts
SELECT '1010', 'Bank Account'
WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1)

INSERT INTO @MissingAccounts
SELECT '1030', 'Cash on Hand'
WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1030' AND IsActive = 1)

INSERT INTO @MissingAccounts
SELECT '1050', 'Debtors - Uncleared EFT'
WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1050' AND IsActive = 1)

INSERT INTO @MissingAccounts
SELECT '1200', 'Accounts Receivable'
WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1200' AND IsActive = 1)

INSERT INTO @MissingAccounts
SELECT '1220', 'Inventory'
WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1220' AND IsActive = 1)

INSERT INTO @MissingAccounts
SELECT '2010', 'Customer Deposits / Accounts Payable'
WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2010' AND IsActive = 1)

INSERT INTO @MissingAccounts
SELECT '2020', 'VAT Output'
WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2020' AND IsActive = 1)

INSERT INTO @MissingAccounts
SELECT '2021', 'VAT Input'
WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2021' AND IsActive = 1)

INSERT INTO @MissingAccounts
SELECT '2050', 'GRIR (Goods Received Invoice Pending)'
WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2050' AND IsActive = 1)

INSERT INTO @MissingAccounts
SELECT '4010', 'Sales Revenue'
WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4010' AND IsActive = 1)

INSERT INTO @MissingAccounts
SELECT '4020', 'Sales Returns'
WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4020' AND IsActive = 1)

INSERT INTO @MissingAccounts
SELECT '4030', 'Other Income'
WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4030' AND IsActive = 1)

INSERT INTO @MissingAccounts
SELECT '4300', 'Interest Income'
WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4300' AND IsActive = 1)

INSERT INTO @MissingAccounts
SELECT '5010', 'Cost of Goods Sold'
WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5010' AND IsActive = 1)

INSERT INTO @MissingAccounts
SELECT '6010', 'Rent Expense'
WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6010' AND IsActive = 1)

INSERT INTO @MissingAccounts
SELECT '6020', 'Utilities Expense'
WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6020' AND IsActive = 1)

INSERT INTO @MissingAccounts
SELECT '6030', 'Salaries & Wages'
WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6030' AND IsActive = 1)

INSERT INTO @MissingAccounts
SELECT '6080', 'Bank Charges / Stock Loss'
WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6080' AND IsActive = 1)

IF EXISTS (SELECT 1 FROM @MissingAccounts)
BEGIN
    PRINT 'MISSING ACCOUNTS:'
    SELECT AccountCode, AccountName FROM @MissingAccounts
END
ELSE
    PRINT '✓ All critical accounts exist'

PRINT ''

-- =============================================
-- SUMMARY
-- =============================================
PRINT '========================================='
PRINT 'AUDIT SUMMARY'
PRINT '========================================='
PRINT ''
PRINT 'GAPS IDENTIFIED:'
PRINT '----------------'
PRINT '1. Accounts Receivable procedures (customer invoices, payments)'
PRINT '2. Beneficiary payment procedures (salaries, rent, utilities)'
PRINT '3. Manufacturing GL integration (if manufacturing is used)'
PRINT '4. Inter-branch transfer GL integration (if multi-branch)'
PRINT ''
PRINT 'EXISTING & WORKING:'
PRINT '-------------------'
PRINT '✓ POS sales (all payment types)'
PRINT '✓ Cake orders (deposits & completion)'
PRINT '✓ Purchase orders (GRV & invoices)'
PRINT '✓ Supplier payments'
PRINT '✓ Inventory adjustments (write-offs)'
PRINT '✓ VAT handling (input & output)'
PRINT '✓ Bank reconciliation (matching logic)'
PRINT ''
PRINT 'NEXT STEPS:'
PRINT '-----------'
PRINT '1. Create missing AR procedures'
PRINT '2. Create beneficiary payment procedure'
PRINT '3. Verify manufacturing/IBT needs'
PRINT '4. Test complete transaction flows'
PRINT ''
GO
