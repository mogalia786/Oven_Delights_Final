-- Create General Ledger View
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_GeneralLedger')
    DROP VIEW vw_GeneralLedger
GO

CREATE VIEW vw_GeneralLedger AS
SELECT 
    ae.EntryID,
    ae.EntryDate,
    ae.EntryType,
    ae.ReferenceNumber,
    ae.AccountCode,
    coa.AccountName,
    coa.AccountType,
    ae.DebitAmount,
    ae.CreditAmount,
    (ae.DebitAmount - ae.CreditAmount) AS NetAmount,
    ae.Description,
    b.BranchName,
    ae.BranchID,
    ae.CreatedBy,
    ae.CreatedDate
FROM AccountingEntries ae
INNER JOIN ChartOfAccounts coa ON ae.AccountCode = coa.AccountCode
LEFT JOIN Branches b ON ae.BranchID = b.BranchID
WHERE coa.IsActive = 1
GO

PRINT 'General Ledger view created successfully'
GO

-- Create Trial Balance View
IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_TrialBalance')
    DROP VIEW vw_TrialBalance
GO

CREATE VIEW vw_TrialBalance AS
SELECT 
    coa.AccountCode,
    coa.AccountName,
    coa.AccountType,
    ISNULL(SUM(ae.DebitAmount), 0) AS TotalDebit,
    ISNULL(SUM(ae.CreditAmount), 0) AS TotalCredit,
    ISNULL(SUM(ae.DebitAmount - ae.CreditAmount), 0) AS Balance,
    ae.BranchID,
    b.BranchName
FROM ChartOfAccounts coa
LEFT JOIN AccountingEntries ae ON coa.AccountCode = ae.AccountCode
LEFT JOIN Branches b ON ae.BranchID = b.BranchID
WHERE coa.IsActive = 1
GROUP BY coa.AccountCode, coa.AccountName, coa.AccountType, ae.BranchID, b.BranchName
GO

PRINT 'Trial Balance view created successfully'
GO
