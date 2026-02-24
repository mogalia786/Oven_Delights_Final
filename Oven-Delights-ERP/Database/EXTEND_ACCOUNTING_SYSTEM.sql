-- =============================================
-- EXTEND ACCOUNTING SYSTEM
-- Adds Supplier Ledgers, Adhoc Transactions, and Bank Reconciliation
-- =============================================
-- NOTE: Execute this script while connected to OvenDelightsERP database
-- Azure SQL does not support USE statements

-- Drop existing extended objects to ensure clean slate
PRINT 'Dropping existing extended accounting objects...'

-- Drop views
IF OBJECT_ID('vw_AccountsPayableSummary', 'V') IS NOT NULL
    DROP VIEW vw_AccountsPayableSummary
IF OBJECT_ID('vw_UnreconciledBankTransactions', 'V') IS NOT NULL
    DROP VIEW vw_UnreconciledBankTransactions
IF OBJECT_ID('vw_SupplierBalances', 'V') IS NOT NULL
    DROP VIEW vw_SupplierBalances

-- Drop stored procedures
IF OBJECT_ID('sp_PostSupplierLedger', 'P') IS NOT NULL
    DROP PROCEDURE sp_PostSupplierLedger

-- Drop all FK constraints that might prevent table drops
DECLARE @sql NVARCHAR(MAX) = ''
SELECT @sql = @sql + 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
              ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.foreign_keys
WHERE referenced_object_id IN (
    OBJECT_ID('SupplierPayments'),
    OBJECT_ID('AdhocPayments'),
    OBJECT_ID('AdhocInvoices')
)

IF LEN(@sql) > 0
BEGIN
    EXEC sp_executesql @sql
    PRINT 'Dropped foreign key constraints'
END

-- Drop tables (in correct dependency order)
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'BankStatementReconciliation')
    DROP TABLE BankStatementReconciliation
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'SupplierPayments')
    DROP TABLE SupplierPayments
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'AdhocInvoiceItems')
    DROP TABLE AdhocInvoiceItems
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'AdhocPayments')
    DROP TABLE AdhocPayments
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'AdhocInvoices')
    DROP TABLE AdhocInvoices
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'SupplierLedger')
    DROP TABLE SupplierLedger

PRINT 'Existing extended accounting objects dropped'
GO

-- =============================================
-- 1. SUPPLIER LEDGER TABLE
-- =============================================
BEGIN
    CREATE TABLE SupplierLedger (
        LedgerID INT IDENTITY(1,1) PRIMARY KEY,
        SupplierID INT NOT NULL,
        SupplierName NVARCHAR(200) NOT NULL,
        SupplierCode NVARCHAR(50),
        TransactionDate DATETIME NOT NULL DEFAULT GETDATE(),
        TransactionType NVARCHAR(50) NOT NULL, -- 'Invoice', 'Payment', 'CreditNote', 'DebitNote', 'OpeningBalance'
        ReferenceNumber NVARCHAR(100),
        Description NVARCHAR(500),
        DebitAmount DECIMAL(18,2) NOT NULL DEFAULT 0, -- Increases what we owe
        CreditAmount DECIMAL(18,2) NOT NULL DEFAULT 0, -- Decreases what we owe (payments)
        RunningBalance DECIMAL(18,2) NOT NULL DEFAULT 0, -- Positive = we owe supplier
        BranchID INT NOT NULL,
        CreatedBy NVARCHAR(100),
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        IsReversed BIT NOT NULL DEFAULT 0,
        ReversedBy NVARCHAR(100),
        ReversedDate DATETIME,
        ReversalReason NVARCHAR(500),
        
        CONSTRAINT CK_SupplierLedger_Amounts CHECK (
            (DebitAmount >= 0 AND CreditAmount = 0) OR 
            (CreditAmount >= 0 AND DebitAmount = 0)
        )
    )
    
    CREATE INDEX IX_SupplierLedger_Supplier ON SupplierLedger(SupplierID, SupplierCode)
    CREATE INDEX IX_SupplierLedger_Date ON SupplierLedger(TransactionDate)
    CREATE INDEX IX_SupplierLedger_Type ON SupplierLedger(TransactionType)
    
    PRINT 'SupplierLedger table created successfully'
END
GO

-- =============================================
-- 2. ADHOC INVOICES TABLE
-- =============================================
CREATE TABLE AdhocInvoices (
        InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
        InvoiceNumber NVARCHAR(50) NOT NULL UNIQUE,
        InvoiceDate DATETIME NOT NULL DEFAULT GETDATE(),
        CustomerID INT,
        CustomerName NVARCHAR(200) NOT NULL,
        CustomerPhone NVARCHAR(50),
        CustomerEmail NVARCHAR(200),
        AccountNumber NVARCHAR(50),
        
        SubTotal DECIMAL(18,2) NOT NULL,
        TaxAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
        TotalAmount DECIMAL(18,2) NOT NULL,
        AmountPaid DECIMAL(18,2) NOT NULL DEFAULT 0,
        BalanceDue DECIMAL(18,2) NOT NULL,
        
        InvoiceStatus NVARCHAR(50) NOT NULL DEFAULT 'Unpaid', -- 'Unpaid', 'PartiallyPaid', 'Paid', 'Cancelled'
        DueDate DATETIME,
        Notes NVARCHAR(1000),
        
        BranchID INT NOT NULL,
        CreatedBy NVARCHAR(100),
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        LastModifiedBy NVARCHAR(100),
        LastModifiedDate DATETIME,
        
        JournalEntryNumber NVARCHAR(50), -- Link to GeneralLedger
        
        CONSTRAINT CK_AdhocInvoices_Amounts CHECK (TotalAmount >= 0 AND AmountPaid >= 0 AND BalanceDue >= 0)
    )
    
    CREATE INDEX IX_AdhocInvoices_Number ON AdhocInvoices(InvoiceNumber)
    CREATE INDEX IX_AdhocInvoices_Customer ON AdhocInvoices(CustomerID, AccountNumber)
    CREATE INDEX IX_AdhocInvoices_Status ON AdhocInvoices(InvoiceStatus)
    CREATE INDEX IX_AdhocInvoices_Date ON AdhocInvoices(InvoiceDate)
    
    PRINT 'AdhocInvoices table created successfully'
GO

-- =============================================
-- 3. ADHOC INVOICE ITEMS TABLE
-- =============================================
CREATE TABLE AdhocInvoiceItems (
        ItemID INT IDENTITY(1,1) PRIMARY KEY,
        InvoiceID INT NOT NULL,
        ProductID INT,
        Description NVARCHAR(500) NOT NULL,
        Quantity DECIMAL(18,3) NOT NULL,
        UnitPrice DECIMAL(18,2) NOT NULL,
        LineTotal DECIMAL(18,2) NOT NULL,
        TaxRate DECIMAL(5,2) NOT NULL DEFAULT 0,
        
        CONSTRAINT FK_AdhocInvoiceItems_Invoice FOREIGN KEY (InvoiceID) 
            REFERENCES AdhocInvoices(InvoiceID) ON DELETE CASCADE
    )
    
    CREATE INDEX IX_AdhocInvoiceItems_Invoice ON AdhocInvoiceItems(InvoiceID)
    
    PRINT 'AdhocInvoiceItems table created successfully'
GO

-- =============================================
-- 4. ADHOC PAYMENTS TABLE
-- =============================================
CREATE TABLE AdhocPayments (
        PaymentID INT IDENTITY(1,1) PRIMARY KEY,
        PaymentNumber NVARCHAR(50) NOT NULL UNIQUE,
        PaymentDate DATETIME NOT NULL DEFAULT GETDATE(),
        
        CustomerID INT,
        CustomerName NVARCHAR(200) NOT NULL,
        AccountNumber NVARCHAR(50),
        
        InvoiceID INT, -- NULL if payment on account
        InvoiceNumber NVARCHAR(50),
        
        PaymentAmount DECIMAL(18,2) NOT NULL,
        PaymentMethod NVARCHAR(50) NOT NULL, -- 'Cash', 'Card', 'EFT', 'Cheque'
        
        -- FNB Integration fields
        IsBankTransfer BIT NOT NULL DEFAULT 0, -- TRUE if EFT/Card
        BankReference NVARCHAR(100), -- FNB transaction reference
        IsReconciled BIT NOT NULL DEFAULT 0, -- TRUE when matched to bank statement
        ReconciledDate DATETIME,
        ReconciledBy NVARCHAR(100),
        
        Notes NVARCHAR(1000),
        
        BranchID INT NOT NULL,
        CreatedBy NVARCHAR(100),
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        
        JournalEntryNumber NVARCHAR(50), -- Link to GeneralLedger
        
        CONSTRAINT FK_AdhocPayments_Invoice FOREIGN KEY (InvoiceID) 
            REFERENCES AdhocInvoices(InvoiceID),
        CONSTRAINT CK_AdhocPayments_Amount CHECK (PaymentAmount > 0)
    )
    
    CREATE INDEX IX_AdhocPayments_Number ON AdhocPayments(PaymentNumber)
    CREATE INDEX IX_AdhocPayments_Customer ON AdhocPayments(CustomerID, AccountNumber)
    CREATE INDEX IX_AdhocPayments_Invoice ON AdhocPayments(InvoiceID)
    CREATE INDEX IX_AdhocPayments_Reconciliation ON AdhocPayments(IsReconciled, IsBankTransfer)
    CREATE INDEX IX_AdhocPayments_Date ON AdhocPayments(PaymentDate)
    
    PRINT 'AdhocPayments table created successfully'
GO

-- =============================================
-- 5. BANK STATEMENT RECONCILIATION TABLE
-- =============================================
CREATE TABLE BankStatementReconciliation (
        ReconciliationID INT IDENTITY(1,1) PRIMARY KEY,
        
        -- Bank Statement Details
        StatementDate DATETIME NOT NULL,
        BankReference NVARCHAR(100) NOT NULL,
        BankDescription NVARCHAR(500),
        TransactionType NVARCHAR(50), -- 'Credit', 'Debit'
        Amount DECIMAL(18,2) NOT NULL,
        
        -- Reconciliation Status
        IsReconciled BIT NOT NULL DEFAULT 0,
        ReconciliationType NVARCHAR(50), -- 'AdhocPayment', 'SupplierPayment', 'OrderDeposit', 'OrderCollection', 'Manual'
        
        -- Links to internal transactions
        AdhocPaymentID INT,
        SupplierPaymentID INT,
        OrderID INT,
        ManualJournalNumber NVARCHAR(50),
        
        ReconciledDate DATETIME,
        ReconciledBy NVARCHAR(100),
        ReconciliationNotes NVARCHAR(1000),
        
        BranchID INT NOT NULL,
        ImportedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ImportedBy NVARCHAR(100),
        
        CONSTRAINT FK_BankRecon_AdhocPayment FOREIGN KEY (AdhocPaymentID) 
            REFERENCES AdhocPayments(PaymentID),
        CONSTRAINT CK_BankRecon_Amount CHECK (Amount <> 0)
    )
    
    CREATE INDEX IX_BankRecon_Date ON BankStatementReconciliation(StatementDate)
    CREATE INDEX IX_BankRecon_Reference ON BankStatementReconciliation(BankReference)
    CREATE INDEX IX_BankRecon_Status ON BankStatementReconciliation(IsReconciled)
    CREATE INDEX IX_BankRecon_Type ON BankStatementReconciliation(ReconciliationType)
    
    PRINT 'BankStatementReconciliation table created successfully'
GO

-- =============================================
-- 6. SUPPLIER PAYMENTS TABLE
-- =============================================
CREATE TABLE SupplierPayments (
        PaymentID INT IDENTITY(1,1) PRIMARY KEY,
        PaymentNumber NVARCHAR(50) NOT NULL UNIQUE,
        PaymentDate DATETIME NOT NULL DEFAULT GETDATE(),
        
        SupplierID INT NOT NULL,
        SupplierName NVARCHAR(200) NOT NULL,
        SupplierCode NVARCHAR(50),
        
        PaymentAmount DECIMAL(18,2) NOT NULL,
        PaymentMethod NVARCHAR(50) NOT NULL, -- 'Cash', 'EFT', 'Cheque'
        
        -- FNB Integration fields
        IsBankTransfer BIT NOT NULL DEFAULT 0,
        BankReference NVARCHAR(100),
        IsReconciled BIT NOT NULL DEFAULT 0,
        ReconciledDate DATETIME,
        ReconciledBy NVARCHAR(100),
        
        Notes NVARCHAR(1000),
        
        BranchID INT NOT NULL,
        CreatedBy NVARCHAR(100),
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        
        JournalEntryNumber NVARCHAR(50),
        
        CONSTRAINT CK_SupplierPayments_Amount CHECK (PaymentAmount > 0)
    )
    
    CREATE INDEX IX_SupplierPayments_Number ON SupplierPayments(PaymentNumber)
    CREATE INDEX IX_SupplierPayments_Supplier ON SupplierPayments(SupplierID, SupplierCode)
    CREATE INDEX IX_SupplierPayments_Reconciliation ON SupplierPayments(IsReconciled, IsBankTransfer)
    CREATE INDEX IX_SupplierPayments_Date ON SupplierPayments(PaymentDate)
    
    PRINT 'SupplierPayments table created successfully'
GO

-- =============================================
-- 7. ADD NEW ACCOUNTS TO CHART OF ACCOUNTS
-- =============================================

-- Accounts Payable - Suppliers
IF NOT EXISTS (SELECT * FROM ChartOfAccounts WHERE AccountCode = '2110')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, AccountCategory, ParentAccountID, IsActive)
    VALUES ('2110', 'Accounts Payable - Suppliers', 'Liability', 'Payables', NULL, 1)
    PRINT 'Added Accounts Payable - Suppliers account'
END

-- Adhoc Sales Revenue
IF NOT EXISTS (SELECT * FROM ChartOfAccounts WHERE AccountCode = '4120')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, AccountCategory, ParentAccountID, IsActive)
    VALUES ('4120', 'Adhoc Sales Revenue', 'Revenue', 'Sales', NULL, 1)
    PRINT 'Added Adhoc Sales Revenue account'
END

-- Bank Charges
IF NOT EXISTS (SELECT * FROM ChartOfAccounts WHERE AccountCode = '6110')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, AccountCategory, ParentAccountID, IsActive)
    VALUES ('6110', 'Bank Charges', 'Expense', 'Operating', NULL, 1)
    PRINT 'Added Bank Charges account'
END

-- Unreconciled Transactions (suspense account)
IF NOT EXISTS (SELECT * FROM ChartOfAccounts WHERE AccountCode = '1130')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, AccountCategory, ParentAccountID, IsActive)
    VALUES ('1130', 'Unreconciled Bank Transactions', 'Asset', 'Bank', NULL, 1)
    PRINT 'Added Unreconciled Bank Transactions account'
END

GO

-- =============================================
-- 8. STORED PROCEDURE: Post Supplier Ledger Entry
-- =============================================
IF OBJECT_ID('sp_PostSupplierLedger', 'P') IS NOT NULL
    DROP PROCEDURE sp_PostSupplierLedger
GO

CREATE PROCEDURE sp_PostSupplierLedger
    @SupplierID INT,
    @SupplierName NVARCHAR(200),
    @SupplierCode NVARCHAR(50),
    @TransactionType NVARCHAR(50),
    @ReferenceNumber NVARCHAR(100),
    @Description NVARCHAR(500),
    @DebitAmount DECIMAL(18,2),
    @CreditAmount DECIMAL(18,2),
    @BranchID INT,
    @CreatedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON
    
    DECLARE @RunningBalance DECIMAL(18,2)
    DECLARE @PreviousBalance DECIMAL(18,2)
    
    -- Get previous balance
    SELECT TOP 1 @PreviousBalance = RunningBalance
    FROM SupplierLedger
    WHERE SupplierID = @SupplierID OR SupplierCode = @SupplierCode
    ORDER BY LedgerID DESC
    
    SET @PreviousBalance = ISNULL(@PreviousBalance, 0)
    
    -- Calculate new balance (Debit increases what we owe, Credit decreases)
    SET @RunningBalance = @PreviousBalance + @DebitAmount - @CreditAmount
    
    -- Insert ledger entry
    INSERT INTO SupplierLedger (
        SupplierID, SupplierName, SupplierCode, TransactionDate, TransactionType,
        ReferenceNumber, Description, DebitAmount, CreditAmount, RunningBalance,
        BranchID, CreatedBy
    )
    VALUES (
        @SupplierID, @SupplierName, @SupplierCode, GETDATE(), @TransactionType,
        @ReferenceNumber, @Description, @DebitAmount, @CreditAmount, @RunningBalance,
        @BranchID, @CreatedBy
    )
    
    RETURN @RunningBalance
END
GO

PRINT 'sp_PostSupplierLedger created successfully'
GO

-- =============================================
-- 9. VIEW: Supplier Balances Summary
-- =============================================
IF OBJECT_ID('vw_SupplierBalances', 'V') IS NOT NULL
    DROP VIEW vw_SupplierBalances
GO

CREATE VIEW vw_SupplierBalances AS
SELECT 
    SupplierID,
    SupplierName,
    SupplierCode,
    RunningBalance AS CurrentBalance,
    TransactionDate AS LastTransactionDate,
    BranchID
FROM (
    SELECT 
        SupplierID,
        SupplierName,
        SupplierCode,
        RunningBalance,
        TransactionDate,
        BranchID,
        ROW_NUMBER() OVER (PARTITION BY SupplierID, SupplierCode ORDER BY LedgerID DESC) AS rn
    FROM SupplierLedger
    WHERE IsReversed = 0
) AS Latest
WHERE rn = 1
GO

PRINT 'vw_SupplierBalances view created successfully'
GO

-- =============================================
-- 10. VIEW: Unreconciled Bank Transactions
-- =============================================
IF OBJECT_ID('vw_UnreconciledBankTransactions', 'V') IS NOT NULL
    DROP VIEW vw_UnreconciledBankTransactions
GO

CREATE VIEW vw_UnreconciledBankTransactions AS
SELECT 
    ReconciliationID,
    StatementDate,
    BankReference,
    BankDescription,
    TransactionType,
    Amount,
    ImportedDate,
    BranchID,
    DATEDIFF(DAY, StatementDate, GETDATE()) AS DaysUnreconciled
FROM BankStatementReconciliation
WHERE IsReconciled = 0
GO

PRINT 'vw_UnreconciledBankTransactions view created successfully'
GO

-- =============================================
-- 11. VIEW: Accounts Payable Summary
-- =============================================
IF OBJECT_ID('vw_AccountsPayableSummary', 'V') IS NOT NULL
    DROP VIEW vw_AccountsPayableSummary
GO

CREATE VIEW vw_AccountsPayableSummary AS
SELECT 
    BranchID,
    COUNT(DISTINCT SupplierID) AS TotalSuppliers,
    SUM(CASE WHEN CurrentBalance > 0 THEN CurrentBalance ELSE 0 END) AS TotalPayable,
    SUM(CASE WHEN CurrentBalance < 0 THEN ABS(CurrentBalance) ELSE 0 END) AS TotalPrepaid,
    SUM(CASE WHEN CurrentBalance > 0 THEN 1 ELSE 0 END) AS SuppliersOwed,
    SUM(CASE WHEN CurrentBalance < 0 THEN 1 ELSE 0 END) AS SuppliersPrepaid
FROM vw_SupplierBalances
GROUP BY BranchID
GO

PRINT 'vw_AccountsPayableSummary view created successfully'
GO

PRINT ''
PRINT '========================================='
PRINT 'ACCOUNTING SYSTEM EXTENSION COMPLETED'
PRINT '========================================='
PRINT 'Created:'
PRINT '  - SupplierLedger table'
PRINT '  - AdhocInvoices and AdhocInvoiceItems tables'
PRINT '  - AdhocPayments table'
PRINT '  - BankStatementReconciliation table'
PRINT '  - SupplierPayments table'
PRINT '  - Additional Chart of Accounts entries'
PRINT '  - sp_PostSupplierLedger stored procedure'
PRINT '  - vw_SupplierBalances view'
PRINT '  - vw_UnreconciledBankTransactions view'
PRINT '  - vw_AccountsPayableSummary view'
PRINT '========================================='
