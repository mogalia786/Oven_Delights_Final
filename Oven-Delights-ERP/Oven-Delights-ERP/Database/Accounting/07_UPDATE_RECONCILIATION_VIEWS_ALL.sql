-- =============================================
-- UPDATE RECONCILIATION VIEWS FOR ALL ENTITY TYPES
-- Extends reconciliation to cover ALL subsidiary ledgers:
-- - Suppliers, Customers, Tenants, Landlords, etc.
-- =============================================
-- Run this AFTER 06_CREATE_ALL_SUBSIDIARY_LEDGERS.sql
-- =============================================

PRINT '=========================================='
PRINT 'UPDATING RECONCILIATION VIEWS - ALL ENTITIES'
PRINT '=========================================='
PRINT ''

-- =============================================
-- 1. VIEW: Customer Balances (Accounts Receivable)
-- =============================================
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_CustomerBalances')
    DROP VIEW vw_CustomerBalances;
GO

CREATE VIEW vw_CustomerBalances
AS
SELECT 
    coa.AccountID,
    coa.AccountCode,
    coa.AccountName,
    coa.CustomerID,
    ISNULL(SUM(jl.Debit), 0) AS TotalDebits,
    ISNULL(SUM(jl.Credit), 0) AS TotalCredits,
    ISNULL(SUM(jl.Debit - jl.Credit), 0) AS Balance,
    COUNT(DISTINCT jl.JournalID) AS TransactionCount,
    MAX(jh.JournalDate) AS LastTransactionDate
FROM ChartOfAccounts coa
LEFT JOIN JournalLines jl ON coa.AccountID = jl.AccountID
LEFT JOIN JournalHeaders jh ON jl.JournalID = jh.JournalID AND jh.IsPosted = 1
WHERE coa.IsSubsidiaryLedger = 1
  AND coa.CustomerID IS NOT NULL
GROUP BY 
    coa.AccountID,
    coa.AccountCode,
    coa.AccountName,
    coa.CustomerID;
GO

PRINT '✓ Created vw_CustomerBalances';

-- =============================================
-- 2. VIEW: All Entity Balances (Generic)
-- =============================================
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_AllEntityBalances')
    DROP VIEW vw_AllEntityBalances;
GO

CREATE VIEW vw_AllEntityBalances
AS
SELECT 
    coa.AccountID,
    coa.AccountCode,
    coa.AccountName,
    CASE 
        WHEN coa.SupplierID IS NOT NULL THEN 'Supplier'
        WHEN coa.CustomerID IS NOT NULL THEN 'Customer'
        WHEN coa.TenantID IS NOT NULL THEN 'Tenant'
        WHEN coa.LandlordID IS NOT NULL THEN 'Landlord'
        ELSE 'Other'
    END AS EntityType,
    COALESCE(coa.SupplierID, coa.CustomerID, coa.TenantID, coa.LandlordID) AS EntityID,
    COALESCE(s.CompanyName, coa.AccountName) AS EntityName,
    coa.AccountType,
    coa.NormalBalance,
    ISNULL(SUM(jl.Debit), 0) AS TotalDebits,
    ISNULL(SUM(jl.Credit), 0) AS TotalCredits,
    CASE 
        WHEN coa.NormalBalance = 'DR' THEN ISNULL(SUM(jl.Debit - jl.Credit), 0)
        WHEN coa.NormalBalance = 'CR' THEN ISNULL(SUM(jl.Credit - jl.Debit), 0)
        ELSE ISNULL(SUM(jl.Debit - jl.Credit), 0)
    END AS Balance,
    COUNT(DISTINCT jl.JournalID) AS TransactionCount,
    MAX(jh.JournalDate) AS LastTransactionDate
FROM ChartOfAccounts coa
LEFT JOIN Suppliers s ON coa.SupplierID = s.SupplierID
LEFT JOIN JournalLines jl ON coa.AccountID = jl.AccountID
LEFT JOIN JournalHeaders jh ON jl.JournalID = jh.JournalID AND jh.IsPosted = 1
WHERE coa.IsSubsidiaryLedger = 1
GROUP BY 
    coa.AccountID,
    coa.AccountCode,
    coa.AccountName,
    coa.SupplierID,
    coa.CustomerID,
    coa.TenantID,
    coa.LandlordID,
    coa.AccountType,
    coa.NormalBalance,
    s.CompanyName;
GO

PRINT '✓ Created vw_AllEntityBalances';

-- =============================================
-- 3. VIEW: Enhanced Subsidiary Ledger Reconciliation
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
        coa.AccountType,
        coa.NormalBalance,
        CASE 
            WHEN coa.NormalBalance = 'DR' THEN ISNULL(SUM(jl.Debit - jl.Credit), 0)
            WHEN coa.NormalBalance = 'CR' THEN ISNULL(SUM(jl.Credit - jl.Debit), 0)
            ELSE ISNULL(SUM(jl.Debit - jl.Credit), 0)
        END AS ControlBalance
    FROM ChartOfAccounts coa
    LEFT JOIN JournalLines jl ON coa.AccountID = jl.AccountID
    LEFT JOIN JournalHeaders jh ON jl.JournalID = jh.JournalID AND jh.IsPosted = 1
    WHERE coa.IsControlAccount = 1
    GROUP BY coa.AccountID, coa.AccountCode, coa.AccountName, coa.AccountType, coa.NormalBalance
),
SubsidiaryTotal AS (
    SELECT 
        coa.ControlAccountID,
        CASE 
            WHEN ctrl.NormalBalance = 'DR' THEN ISNULL(SUM(jl.Debit - jl.Credit), 0)
            WHEN ctrl.NormalBalance = 'CR' THEN ISNULL(SUM(jl.Credit - jl.Debit), 0)
            ELSE ISNULL(SUM(jl.Debit - jl.Credit), 0)
        END AS SubsidiaryBalance,
        COUNT(DISTINCT coa.AccountID) AS SubsidiaryAccountCount
    FROM ChartOfAccounts coa
    LEFT JOIN ChartOfAccounts ctrl ON coa.ControlAccountID = ctrl.AccountID
    LEFT JOIN JournalLines jl ON coa.AccountID = jl.AccountID
    LEFT JOIN JournalHeaders jh ON jl.JournalID = jh.JournalID AND jh.IsPosted = 1
    WHERE coa.IsSubsidiaryLedger = 1
    GROUP BY coa.ControlAccountID, ctrl.NormalBalance
)
SELECT 
    ctrl.ControlAccountCode,
    ctrl.ControlAccountName,
    ctrl.AccountType,
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

PRINT '✓ Updated vw_SubsidiaryLedgerReconciliation';

-- =============================================
-- 4. VIEW: Customer Ledger Detail
-- =============================================
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_CustomerLedgerDetail')
    DROP VIEW vw_CustomerLedgerDetail;
GO

CREATE VIEW vw_CustomerLedgerDetail
AS
SELECT 
    jh.JournalDate,
    jh.JournalNumber,
    jh.Reference,
    jh.Description AS JournalDescription,
    coa.AccountCode,
    coa.AccountName,
    coa.CustomerID,
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
WHERE jh.IsPosted = 1
  AND coa.IsSubsidiaryLedger = 1
  AND coa.CustomerID IS NOT NULL;
GO

PRINT '✓ Created vw_CustomerLedgerDetail';

-- =============================================
-- 5. VIEW: Rent Income Detail (Tenants)
-- =============================================
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_RentIncomeDetail')
    DROP VIEW vw_RentIncomeDetail;
GO

CREATE VIEW vw_RentIncomeDetail
AS
SELECT 
    jh.JournalDate,
    jh.JournalNumber,
    jh.Reference,
    jh.Description AS JournalDescription,
    coa.AccountCode,
    coa.AccountName,
    coa.TenantID,
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
WHERE jh.IsPosted = 1
  AND coa.AccountCode LIKE '4200%'  -- Rent Income accounts
  AND coa.IsSubsidiaryLedger = 1;
GO

PRINT '✓ Created vw_RentIncomeDetail';

-- =============================================
-- 6. VIEW: Rent Expense Detail (Landlords)
-- =============================================
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_RentExpenseDetail')
    DROP VIEW vw_RentExpenseDetail;
GO

CREATE VIEW vw_RentExpenseDetail
AS
SELECT 
    jh.JournalDate,
    jh.JournalNumber,
    jh.Reference,
    jh.Description AS JournalDescription,
    coa.AccountCode,
    coa.AccountName,
    coa.LandlordID,
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
WHERE jh.IsPosted = 1
  AND coa.AccountCode LIKE '5200%'  -- Rent Expense accounts
  AND coa.IsSubsidiaryLedger = 1;
GO

PRINT '✓ Created vw_RentExpenseDetail';

-- =============================================
-- 7. VIEW: Entity Type Summary
-- =============================================
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_EntityTypeSummary')
    DROP VIEW vw_EntityTypeSummary;
GO

CREATE VIEW vw_EntityTypeSummary
AS
SELECT 
    EntityType,
    AccountType,
    COUNT(*) AS EntityCount,
    SUM(CASE WHEN Balance > 0 THEN 1 ELSE 0 END) AS EntitiesWithBalance,
    SUM(Balance) AS TotalBalance,
    MAX(LastTransactionDate) AS MostRecentTransaction
FROM vw_AllEntityBalances
GROUP BY EntityType, AccountType;
GO

PRINT '✓ Created vw_EntityTypeSummary';

PRINT ''
PRINT '=========================================='
PRINT 'TESTING UPDATED VIEWS'
PRINT '=========================================='
PRINT ''

-- Test reconciliation for all control accounts
PRINT 'Reconciliation Status (ALL Control Accounts):'
SELECT * FROM vw_SubsidiaryLedgerReconciliation
ORDER BY ControlAccountCode;

PRINT ''
PRINT 'Entity Type Summary:'
SELECT * FROM vw_EntityTypeSummary
ORDER BY EntityType;

PRINT ''
PRINT '=========================================='
PRINT 'RECONCILIATION VIEWS UPDATED!'
PRINT '=========================================='
PRINT ''
PRINT 'Available Views:'
PRINT '- vw_SupplierBalances: Individual supplier balances'
PRINT '- vw_CustomerBalances: Individual customer balances'
PRINT '- vw_AllEntityBalances: All subsidiary ledgers (suppliers, customers, etc.)'
PRINT '- vw_SubsidiaryLedgerReconciliation: Control vs subsidiary totals (ALL)'
PRINT '- vw_AccountBalances: All account balances'
PRINT '- vw_TrialBalance: Trial balance report'
PRINT '- vw_SupplierLedgerDetail: Detailed supplier transactions'
PRINT '- vw_CustomerLedgerDetail: Detailed customer transactions'
PRINT '- vw_RentIncomeDetail: Detailed rent income transactions'
PRINT '- vw_RentExpenseDetail: Detailed rent expense transactions'
PRINT '- vw_EntityTypeSummary: Summary by entity type'
PRINT ''
PRINT 'Next Steps:'
PRINT '1. Run 08_CREATE_ALL_POSTING_PROCEDURES.sql'
PRINT '2. Test all views with your data'
PRINT '3. Verify all reconciliations are balanced'
PRINT ''
