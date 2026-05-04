-- =============================================
-- CREATE RECONCILIATION VIEWS
-- Views to verify subsidiary ledgers = control accounts
-- =============================================
-- Run this AFTER 03_FIX_AP_INVOICES_TABLE.sql
-- =============================================

PRINT '=========================================='
PRINT 'CREATING RECONCILIATION VIEWS'
PRINT '=========================================='
PRINT ''

-- =============================================
-- 1. VIEW: Supplier Balances from General Ledger
-- =============================================
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_SupplierBalances')
    DROP VIEW vw_SupplierBalances;
GO

CREATE VIEW vw_SupplierBalances
AS
SELECT 
    coa.AccountID,
    coa.AccountCode,
    coa.AccountName,
    coa.SupplierID,
    s.SupplierName,
    s.ContactPerson,
    s.Email,
    s.Phone,
    ISNULL(SUM(jl.Credit), 0) AS TotalCredits,
    ISNULL(SUM(jl.Debit), 0) AS TotalDebits,
    ISNULL(SUM(jl.Credit - jl.Debit), 0) AS Balance,
    COUNT(DISTINCT jl.JournalID) AS TransactionCount,
    MAX(jh.JournalDate) AS LastTransactionDate
FROM ChartOfAccounts coa
INNER JOIN Suppliers s ON coa.SupplierID = s.SupplierID
LEFT JOIN JournalLines jl ON coa.AccountID = jl.AccountID
LEFT JOIN JournalHeaders jh ON jl.JournalID = jh.JournalID AND jh.IsPosted = 1
WHERE coa.IsSubsidiaryLedger = 1
  AND coa.SupplierID IS NOT NULL
GROUP BY 
    coa.AccountID,
    coa.AccountCode,
    coa.AccountName,
    coa.SupplierID,
    s.SupplierName,
    s.ContactPerson,
    s.Email,
    s.Phone;
GO

PRINT '✓ Created vw_SupplierBalances';

-- =============================================
-- 2. VIEW: Subsidiary Ledger Reconciliation
-- =============================================
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_SubsidiaryLedgerReconciliation')
    DROP VIEW vw_SubsidiaryLedgerReconciliation;
GO

CREATE VIEW vw_SubsidiaryLedgerReconciliation
AS
WITH ControlAccountBalance AS (
    SELECT 
        coa.AccountID AS ControlAccountID,
        coa.AccountCode AS ControlAccountCode,
        coa.AccountName AS ControlAccountName,
        ISNULL(SUM(jl.Credit - jl.Debit), 0) AS ControlBalance
    FROM ChartOfAccounts coa
    LEFT JOIN JournalLines jl ON coa.AccountID = jl.AccountID
    LEFT JOIN JournalHeaders jh ON jl.JournalID = jh.JournalID AND jh.IsPosted = 1
    WHERE coa.IsControlAccount = 1
    GROUP BY coa.AccountID, coa.AccountCode, coa.AccountName
),
SubsidiaryTotal AS (
    SELECT 
        coa.ControlAccountID,
        ISNULL(SUM(jl.Credit - jl.Debit), 0) AS SubsidiaryBalance,
        COUNT(DISTINCT coa.AccountID) AS SubsidiaryAccountCount
    FROM ChartOfAccounts coa
    LEFT JOIN JournalLines jl ON coa.AccountID = jl.AccountID
    LEFT JOIN JournalHeaders jh ON jl.JournalID = jh.JournalID AND jh.IsPosted = 1
    WHERE coa.IsSubsidiaryLedger = 1
    GROUP BY coa.ControlAccountID
)
SELECT 
    ctrl.ControlAccountCode,
    ctrl.ControlAccountName,
    ctrl.ControlBalance,
    ISNULL(sub.SubsidiaryBalance, 0) AS SubsidiaryBalance,
    ISNULL(sub.SubsidiaryAccountCount, 0) AS SubsidiaryAccountCount,
    ctrl.ControlBalance - ISNULL(sub.SubsidiaryBalance, 0) AS Difference,
    CASE 
        WHEN ABS(ctrl.ControlBalance - ISNULL(sub.SubsidiaryBalance, 0)) < 0.01 THEN 'BALANCED'
        ELSE 'OUT OF BALANCE'
    END AS Status
FROM ControlAccountBalance ctrl
LEFT JOIN SubsidiaryTotal sub ON ctrl.ControlAccountID = sub.ControlAccountID;
GO

PRINT '✓ Created vw_SubsidiaryLedgerReconciliation';

-- =============================================
-- 3. VIEW: Account Balances (All Accounts)
-- =============================================
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_AccountBalances')
    DROP VIEW vw_AccountBalances;
GO

CREATE VIEW vw_AccountBalances
AS
SELECT 
    coa.AccountID,
    coa.AccountCode,
    coa.AccountName,
    coa.AccountType,
    coa.IsControlAccount,
    coa.IsSubsidiaryLedger,
    coa.NormalBalance,
    ISNULL(SUM(jl.Debit), 0) AS TotalDebits,
    ISNULL(SUM(jl.Credit), 0) AS TotalCredits,
    CASE 
        WHEN coa.NormalBalance = 'DR' THEN ISNULL(SUM(jl.Debit - jl.Credit), 0)
        WHEN coa.NormalBalance = 'CR' THEN ISNULL(SUM(jl.Credit - jl.Debit), 0)
        ELSE ISNULL(SUM(jl.Debit - jl.Credit), 0)
    END AS Balance,
    COUNT(DISTINCT jl.JournalID) AS TransactionCount
FROM ChartOfAccounts coa
LEFT JOIN JournalLines jl ON coa.AccountID = jl.AccountID
LEFT JOIN JournalHeaders jh ON jl.JournalID = jh.JournalID AND jh.IsPosted = 1
WHERE coa.IsActive = 1
GROUP BY 
    coa.AccountID,
    coa.AccountCode,
    coa.AccountName,
    coa.AccountType,
    coa.IsControlAccount,
    coa.IsSubsidiaryLedger,
    coa.NormalBalance;
GO

PRINT '✓ Created vw_AccountBalances';

-- =============================================
-- 4. VIEW: Trial Balance
-- =============================================
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_TrialBalance')
    DROP VIEW vw_TrialBalance;
GO

CREATE VIEW vw_TrialBalance
AS
SELECT 
    coa.AccountCode,
    coa.AccountName,
    coa.AccountType,
    ISNULL(SUM(jl.Debit), 0) AS Debit,
    ISNULL(SUM(jl.Credit), 0) AS Credit,
    CASE 
        WHEN coa.AccountType IN ('Asset', 'Expense') THEN ISNULL(SUM(jl.Debit - jl.Credit), 0)
        WHEN coa.AccountType IN ('Liability', 'Equity', 'Revenue') THEN ISNULL(SUM(jl.Credit - jl.Debit), 0)
        ELSE 0
    END AS Balance
FROM ChartOfAccounts coa
LEFT JOIN JournalLines jl ON coa.AccountID = jl.AccountID
LEFT JOIN JournalHeaders jh ON jl.JournalID = jh.JournalID AND jh.IsPosted = 1
WHERE coa.IsActive = 1
  AND coa.IsSubsidiaryLedger = 0  -- Exclude subsidiary ledgers from trial balance
GROUP BY 
    coa.AccountCode,
    coa.AccountName,
    coa.AccountType
HAVING ISNULL(SUM(jl.Debit), 0) <> 0 OR ISNULL(SUM(jl.Credit), 0) <> 0;
GO

PRINT '✓ Created vw_TrialBalance';

-- =============================================
-- 5. VIEW: Supplier Ledger Detail
-- =============================================
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_SupplierLedgerDetail')
    DROP VIEW vw_SupplierLedgerDetail;
GO

CREATE VIEW vw_SupplierLedgerDetail
AS
SELECT 
    jh.JournalDate,
    jh.JournalNumber,
    jh.Reference,
    jh.Description AS JournalDescription,
    coa.AccountCode,
    coa.AccountName,
    s.SupplierID,
    s.SupplierName,
    jl.LineDescription,
    jl.Debit,
    jl.Credit,
    jl.Reference1,
    jl.Reference2,
    jh.BranchID,
    jh.CreatedBy,
    jh.PostedDate
FROM JournalLines jl
INNER JOIN JournalHeaders jh ON jl.JournalID = jh.JournalID
INNER JOIN ChartOfAccounts coa ON jl.AccountID = coa.AccountID
INNER JOIN Suppliers s ON coa.SupplierID = s.SupplierID
WHERE jh.IsPosted = 1
  AND coa.IsSubsidiaryLedger = 1
  AND coa.SupplierID IS NOT NULL;
GO

PRINT '✓ Created vw_SupplierLedgerDetail';

PRINT ''
PRINT '=========================================='
PRINT 'TESTING RECONCILIATION VIEWS'
PRINT '=========================================='
PRINT ''

-- Test 1: Show supplier balances
PRINT 'Supplier Balances:'
SELECT * FROM vw_SupplierBalances ORDER BY Balance DESC;

PRINT ''
PRINT 'Subsidiary Ledger Reconciliation:'
SELECT * FROM vw_SubsidiaryLedgerReconciliation;

PRINT ''
PRINT 'Trial Balance Summary:'
SELECT 
    AccountType,
    SUM(Debit) AS TotalDebit,
    SUM(Credit) AS TotalCredit,
    SUM(Balance) AS NetBalance
FROM vw_TrialBalance
GROUP BY AccountType
ORDER BY AccountType;

PRINT ''
PRINT '=========================================='
PRINT 'RECONCILIATION VIEWS CREATED!'
PRINT '=========================================='
PRINT ''
PRINT 'Available Views:'
PRINT '- vw_SupplierBalances: Individual supplier balances'
PRINT '- vw_SubsidiaryLedgerReconciliation: Control vs subsidiary totals'
PRINT '- vw_AccountBalances: All account balances'
PRINT '- vw_TrialBalance: Trial balance report'
PRINT '- vw_SupplierLedgerDetail: Detailed supplier transactions'
PRINT ''
PRINT 'Next Steps:'
PRINT '1. Run 05_CREATE_ACCOUNTING_PROCEDURES.sql'
PRINT '2. Test the views with your data'
PRINT '3. Verify reconciliation is balanced'
PRINT ''
