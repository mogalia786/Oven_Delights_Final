-- =============================================
-- COMPREHENSIVE ACCOUNTING SYSTEM FOR OVEN DELIGHTS
-- Implements proper double-entry bookkeeping
-- Separates Cash on Hand from Bank
-- Tracks Customer Ledgers with full audit trail
-- =============================================
-- NOTE: Execute this script while connected to OvenDelightsERP database
-- Azure SQL does not support USE statements

-- =============================================
-- 1. CHART OF ACCOUNTS
-- =============================================
-- Drop ALL accounting objects to ensure clean slate
PRINT 'Dropping existing accounting objects...'

-- Drop views first
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_CashOnHandSummary]'))
    DROP VIEW [dbo].[vw_CashOnHandSummary]
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_CustomerBalances]'))
    DROP VIEW [dbo].[vw_CustomerBalances]
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_AccountBalances]'))
    DROP VIEW [dbo].[vw_AccountBalances]

-- Drop stored procedures
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_PostCustomerLedger]') AND type in (N'P'))
    DROP PROCEDURE [dbo].[sp_PostCustomerLedger]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_PostJournalEntry]') AND type in (N'P'))
    DROP PROCEDURE [dbo].[sp_PostJournalEntry]

-- Drop foreign key constraints that reference ChartOfAccounts
DECLARE @sql NVARCHAR(MAX) = ''
SELECT @sql = @sql + 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
              ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.foreign_keys
WHERE referenced_object_id = OBJECT_ID('ChartOfAccounts')

IF LEN(@sql) > 0
BEGIN
    EXEC sp_executesql @sql
    PRINT 'Dropped foreign key constraints referencing ChartOfAccounts'
END

-- Drop tables (in reverse dependency order)
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BankDeposits]') AND type in (N'U'))
    DROP TABLE [dbo].[BankDeposits]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CashRegister]') AND type in (N'U'))
    DROP TABLE [dbo].[CashRegister]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerLedger]') AND type in (N'U'))
    DROP TABLE [dbo].[CustomerLedger]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GeneralLedger]') AND type in (N'U'))
    DROP TABLE [dbo].[GeneralLedger]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChartOfAccounts]') AND type in (N'U'))
    DROP TABLE [dbo].[ChartOfAccounts]

PRINT 'All existing accounting objects dropped'
GO

CREATE TABLE [dbo].[ChartOfAccounts] (
    [AccountID] INT IDENTITY(1,1) PRIMARY KEY,
    [AccountCode] NVARCHAR(20) NOT NULL UNIQUE,
    [AccountName] NVARCHAR(200) NOT NULL,
    [AccountType] NVARCHAR(50) NOT NULL, -- Asset, Liability, Equity, Revenue, Expense
    [AccountCategory] NVARCHAR(100) NOT NULL, -- Cash, Bank, Receivables, Payables, Sales, etc.
    [ParentAccountID] INT NULL,
    [IsActive] BIT NOT NULL DEFAULT 1,
    [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_ChartOfAccounts_Parent FOREIGN KEY (ParentAccountID) REFERENCES ChartOfAccounts(AccountID)
)

PRINT 'ChartOfAccounts table created'
GO

-- Insert standard accounts
INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, AccountCategory) VALUES
    -- ASSETS
    ('1000', 'ASSETS', 'Asset', 'Header'),
    ('1100', 'Current Assets', 'Asset', 'Header'),
    ('1110', 'Cash on Hand', 'Asset', 'Cash'),
    ('1120', 'Bank - FNB Current Account', 'Asset', 'Bank'),
    ('1130', 'Accounts Receivable', 'Asset', 'Receivables'),
    ('1140', 'Customer Deposits Receivable', 'Asset', 'Receivables'),
    
    -- LIABILITIES
    ('2000', 'LIABILITIES', 'Liability', 'Header'),
    ('2100', 'Current Liabilities', 'Liability', 'Header'),
    ('2110', 'Accounts Payable', 'Liability', 'Payables'),
    ('2120', 'Customer Deposits', 'Liability', 'Customer Deposits'),
    ('2130', 'VAT Payable', 'Liability', 'Tax'),
    
    -- EQUITY
    ('3000', 'EQUITY', 'Equity', 'Header'),
    ('3100', 'Owner''s Equity', 'Equity', 'Equity'),
    ('3200', 'Retained Earnings', 'Equity', 'Equity'),
    
    -- REVENUE
    ('4000', 'REVENUE', 'Revenue', 'Header'),
    ('4100', 'Sales Revenue', 'Revenue', 'Sales'),
    ('4110', 'Cake Sales', 'Revenue', 'Sales'),
    ('4120', 'Retail Sales', 'Revenue', 'Sales'),
    ('4130', 'Cancellation Fee Revenue', 'Revenue', 'Sales'),
    
    -- EXPENSES
    ('5000', 'EXPENSES', 'Expense', 'Header'),
    ('5100', 'Cost of Goods Sold', 'Expense', 'COGS'),
    ('5200', 'Operating Expenses', 'Expense', 'Operating')

PRINT 'Chart of Accounts data inserted successfully'
GO

-- =============================================
-- 2. GENERAL LEDGER (Journal Entries)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GeneralLedger]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[GeneralLedger] (
        [EntryID] BIGINT IDENTITY(1,1) PRIMARY KEY,
        [JournalEntryNumber] NVARCHAR(50) NOT NULL,
        [TransactionDate] DATETIME NOT NULL DEFAULT GETDATE(),
        [AccountID] INT NOT NULL,
        [DebitAmount] DECIMAL(18,2) NOT NULL DEFAULT 0,
        [CreditAmount] DECIMAL(18,2) NOT NULL DEFAULT 0,
        [Description] NVARCHAR(500) NOT NULL,
        [ReferenceType] NVARCHAR(50) NULL, -- Order, Sale, Payment, Refund, etc.
        [ReferenceID] NVARCHAR(100) NULL, -- Order number, invoice number, etc.
        [BranchID] INT NULL,
        [CustomerID] INT NULL,
        [CreatedBy] NVARCHAR(100) NOT NULL,
        [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
        [IsReversed] BIT NOT NULL DEFAULT 0,
        [ReversalEntryID] BIGINT NULL,
        CONSTRAINT FK_GeneralLedger_Account FOREIGN KEY (AccountID) REFERENCES ChartOfAccounts(AccountID),
        CONSTRAINT CK_GeneralLedger_DebitOrCredit CHECK (DebitAmount >= 0 AND CreditAmount >= 0),
        CONSTRAINT CK_GeneralLedger_NotBoth CHECK (NOT (DebitAmount > 0 AND CreditAmount > 0))
    )
    
    CREATE INDEX IX_GeneralLedger_JournalEntry ON GeneralLedger(JournalEntryNumber)
    CREATE INDEX IX_GeneralLedger_Account ON GeneralLedger(AccountID, TransactionDate)
    CREATE INDEX IX_GeneralLedger_Reference ON GeneralLedger(ReferenceType, ReferenceID)
    CREATE INDEX IX_GeneralLedger_Customer ON GeneralLedger(CustomerID)
    
    PRINT 'General Ledger created successfully'
END
GO

-- =============================================
-- 3. CUSTOMER LEDGER
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerLedger]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[CustomerLedger] (
        [LedgerID] BIGINT IDENTITY(1,1) PRIMARY KEY,
        [CustomerID] INT NOT NULL,
        [CustomerName] NVARCHAR(200) NOT NULL,
        [AccountNumber] NVARCHAR(50) NOT NULL,
        [TransactionDate] DATETIME NOT NULL DEFAULT GETDATE(),
        [TransactionType] NVARCHAR(50) NOT NULL, -- Order, Deposit, Payment, Refund, Cancellation, Edit
        [ReferenceNumber] NVARCHAR(100) NOT NULL, -- Order number, invoice number
        [Description] NVARCHAR(500) NOT NULL,
        [DebitAmount] DECIMAL(18,2) NOT NULL DEFAULT 0, -- Increases what customer owes
        [CreditAmount] DECIMAL(18,2) NOT NULL DEFAULT 0, -- Decreases what customer owes
        [RunningBalance] DECIMAL(18,2) NOT NULL DEFAULT 0, -- Positive = customer owes us, Negative = we owe customer
        [BranchID] INT NOT NULL,
        [CreatedBy] NVARCHAR(100) NOT NULL,
        [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT CK_CustomerLedger_DebitOrCredit CHECK (DebitAmount >= 0 AND CreditAmount >= 0)
    )
    
    CREATE INDEX IX_CustomerLedger_Customer ON CustomerLedger(CustomerID, TransactionDate)
    CREATE INDEX IX_CustomerLedger_AccountNumber ON CustomerLedger(AccountNumber, TransactionDate)
    CREATE INDEX IX_CustomerLedger_Reference ON CustomerLedger(ReferenceNumber)
    
    PRINT 'Customer Ledger created successfully'
END
GO

-- =============================================
-- 4. CASH REGISTER (Daily Cash Tracking)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CashRegister]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[CashRegister] (
        [RegisterID] BIGINT IDENTITY(1,1) PRIMARY KEY,
        [BranchID] INT NOT NULL,
        [TillPointID] INT NOT NULL,
        [TransactionDate] DATETIME NOT NULL DEFAULT GETDATE(),
        [TransactionType] NVARCHAR(50) NOT NULL, -- Sale, Refund, Deposit, Withdrawal, BankDeposit
        [Amount] DECIMAL(18,2) NOT NULL,
        [PaymentMethod] NVARCHAR(50) NOT NULL, -- Cash, Card, EFT
        [ReferenceNumber] NVARCHAR(100) NULL,
        [Description] NVARCHAR(500) NULL,
        [CashierID] INT NOT NULL,
        [CashierName] NVARCHAR(100) NOT NULL,
        [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE()
    )
    
    CREATE INDEX IX_CashRegister_Branch ON CashRegister(BranchID, TransactionDate)
    CREATE INDEX IX_CashRegister_TillPoint ON CashRegister(TillPointID, TransactionDate)
    
    PRINT 'Cash Register created successfully'
END
GO

-- =============================================
-- 5. BANK DEPOSITS (Track when cash is deposited)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BankDeposits]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[BankDeposits] (
        [DepositID] INT IDENTITY(1,1) PRIMARY KEY,
        [DepositDate] DATE NOT NULL,
        [BranchID] INT NOT NULL,
        [DepositAmount] DECIMAL(18,2) NOT NULL,
        [DepositReference] NVARCHAR(100) NULL, -- Bank slip number
        [DepositedBy] NVARCHAR(100) NOT NULL,
        [BankAccountID] INT NOT NULL, -- Links to ChartOfAccounts
        [Notes] NVARCHAR(500) NULL,
        [IsReconciled] BIT NOT NULL DEFAULT 0,
        [ReconciledDate] DATETIME NULL,
        [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_BankDeposits_Account FOREIGN KEY (BankAccountID) REFERENCES ChartOfAccounts(AccountID)
    )
    
    CREATE INDEX IX_BankDeposits_Date ON BankDeposits(DepositDate)
    CREATE INDEX IX_BankDeposits_Branch ON BankDeposits(BranchID)
    
    PRINT 'Bank Deposits created successfully'
END
GO

-- =============================================
-- 6. Add columns to POS_CustomOrders for accounting
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[POS_CustomOrders]') AND name = 'CustomerLedgerID')
BEGIN
    ALTER TABLE POS_CustomOrders ADD CustomerLedgerID BIGINT NULL
    PRINT 'Added CustomerLedgerID to POS_CustomOrders'
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[POS_CustomOrders]') AND name = 'JournalEntryNumber')
BEGIN
    ALTER TABLE POS_CustomOrders ADD JournalEntryNumber NVARCHAR(50) NULL
    PRINT 'Added JournalEntryNumber to POS_CustomOrders'
END
GO

-- =============================================
-- 7. STORED PROCEDURE: Post Journal Entry
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_PostJournalEntry]') AND type in (N'P'))
    DROP PROCEDURE [dbo].[sp_PostJournalEntry]
GO

CREATE PROCEDURE [dbo].[sp_PostJournalEntry]
    @JournalEntryNumber NVARCHAR(50),
    @TransactionDate DATETIME,
    @Description NVARCHAR(500),
    @ReferenceType NVARCHAR(50),
    @ReferenceID NVARCHAR(100),
    @BranchID INT,
    @CustomerID INT = NULL,
    @CreatedBy NVARCHAR(100),
    @Entries NVARCHAR(MAX) -- JSON array of {AccountCode, DebitAmount, CreditAmount}
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @TotalDebits DECIMAL(18,2) = 0
        DECLARE @TotalCredits DECIMAL(18,2) = 0
        
        -- Parse JSON entries
        DECLARE @EntryTable TABLE (
            AccountCode NVARCHAR(20),
            DebitAmount DECIMAL(18,2),
            CreditAmount DECIMAL(18,2)
        )
        
        INSERT INTO @EntryTable (AccountCode, DebitAmount, CreditAmount)
        SELECT 
            JSON_VALUE(value, '$.AccountCode'),
            CAST(JSON_VALUE(value, '$.DebitAmount') AS DECIMAL(18,2)),
            CAST(JSON_VALUE(value, '$.CreditAmount') AS DECIMAL(18,2))
        FROM OPENJSON(@Entries)
        
        -- Calculate totals
        SELECT @TotalDebits = SUM(DebitAmount), @TotalCredits = SUM(CreditAmount)
        FROM @EntryTable
        
        -- Validate balanced entry
        IF ABS(@TotalDebits - @TotalCredits) > 0.01
        BEGIN
            DECLARE @ErrorMsg NVARCHAR(500) = 'Journal entry is not balanced. Debits: ' + CAST(@TotalDebits AS NVARCHAR(20)) + ', Credits: ' + CAST(@TotalCredits AS NVARCHAR(20))
            RAISERROR(@ErrorMsg, 16, 1)
            RETURN
        END
        
        -- Post entries
        INSERT INTO GeneralLedger (
            JournalEntryNumber, TransactionDate, AccountID, DebitAmount, CreditAmount,
            Description, ReferenceType, ReferenceID, BranchID, CustomerID, CreatedBy
        )
        SELECT 
            @JournalEntryNumber,
            @TransactionDate,
            coa.AccountID,
            et.DebitAmount,
            et.CreditAmount,
            @Description,
            @ReferenceType,
            @ReferenceID,
            @BranchID,
            @CustomerID,
            @CreatedBy
        FROM @EntryTable et
        INNER JOIN ChartOfAccounts coa ON et.AccountCode = coa.AccountCode
        
        COMMIT TRANSACTION
        
        SELECT 'SUCCESS' AS Result, @JournalEntryNumber AS JournalEntryNumber
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

PRINT 'sp_PostJournalEntry created successfully'
GO

-- =============================================
-- 8. STORED PROCEDURE: Post to Customer Ledger
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_PostCustomerLedger]') AND type in (N'P'))
    DROP PROCEDURE [dbo].[sp_PostCustomerLedger]
GO

CREATE PROCEDURE [dbo].[sp_PostCustomerLedger]
    @CustomerID INT,
    @CustomerName NVARCHAR(200),
    @AccountNumber NVARCHAR(50),
    @TransactionType NVARCHAR(50),
    @ReferenceNumber NVARCHAR(100),
    @Description NVARCHAR(500),
    @DebitAmount DECIMAL(18,2) = 0,
    @CreditAmount DECIMAL(18,2) = 0,
    @BranchID INT,
    @CreatedBy NVARCHAR(100),
    @LedgerID BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Get current balance
        DECLARE @CurrentBalance DECIMAL(18,2) = 0
        
        SELECT TOP 1 @CurrentBalance = RunningBalance
        FROM CustomerLedger
        WHERE AccountNumber = @AccountNumber
        ORDER BY LedgerID DESC
        
        -- Calculate new balance
        DECLARE @NewBalance DECIMAL(18,2) = @CurrentBalance + @DebitAmount - @CreditAmount
        
        -- Insert ledger entry
        INSERT INTO CustomerLedger (
            CustomerID, CustomerName, AccountNumber, TransactionDate, TransactionType,
            ReferenceNumber, Description, DebitAmount, CreditAmount, RunningBalance,
            BranchID, CreatedBy
        )
        VALUES (
            @CustomerID, @CustomerName, @AccountNumber, GETDATE(), @TransactionType,
            @ReferenceNumber, @Description, @DebitAmount, @CreditAmount, @NewBalance,
            @BranchID, @CreatedBy
        )
        
        SET @LedgerID = SCOPE_IDENTITY()
        
        COMMIT TRANSACTION
        
        SELECT @LedgerID AS LedgerID, @NewBalance AS NewBalance
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

PRINT 'sp_PostCustomerLedger created successfully'
GO

-- =============================================
-- 9. VIEW: Account Balances
-- =============================================
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_AccountBalances]'))
    DROP VIEW [dbo].[vw_AccountBalances]
GO

CREATE VIEW [dbo].[vw_AccountBalances]
AS
SELECT 
    coa.AccountID,
    coa.AccountCode,
    coa.AccountName,
    coa.AccountType,
    coa.AccountCategory,
    ISNULL(SUM(gl.DebitAmount), 0) AS TotalDebits,
    ISNULL(SUM(gl.CreditAmount), 0) AS TotalCredits,
    CASE 
        WHEN coa.AccountType IN ('Asset', 'Expense') 
            THEN ISNULL(SUM(gl.DebitAmount), 0) - ISNULL(SUM(gl.CreditAmount), 0)
        WHEN coa.AccountType IN ('Liability', 'Equity', 'Revenue')
            THEN ISNULL(SUM(gl.CreditAmount), 0) - ISNULL(SUM(gl.DebitAmount), 0)
        ELSE 0
    END AS Balance
FROM ChartOfAccounts coa
LEFT JOIN GeneralLedger gl ON coa.AccountID = gl.AccountID AND gl.IsReversed = 0
WHERE coa.IsActive = 1
GROUP BY coa.AccountID, coa.AccountCode, coa.AccountName, coa.AccountType, coa.AccountCategory
GO

PRINT 'vw_AccountBalances created successfully'
GO

-- =============================================
-- 10. VIEW: Customer Balances
-- =============================================
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_CustomerBalances]'))
    DROP VIEW [dbo].[vw_CustomerBalances]
GO

CREATE VIEW [dbo].[vw_CustomerBalances]
AS
SELECT 
    cl.AccountNumber,
    cl.CustomerName,
    cl.CustomerID,
    MAX(cl.BranchID) AS BranchID,
    MAX(cl.RunningBalance) AS CurrentBalance,
    SUM(CASE WHEN cl.TransactionType = 'Deposit' THEN cl.CreditAmount ELSE 0 END) AS TotalDeposits,
    COUNT(DISTINCT CASE WHEN cl.TransactionType = 'Order' THEN cl.ReferenceNumber END) AS ActiveOrders,
    MAX(cl.TransactionDate) AS LastTransactionDate
FROM (
    SELECT 
        AccountNumber,
        CustomerName,
        CustomerID,
        BranchID,
        TransactionType,
        ReferenceNumber,
        CreditAmount,
        TransactionDate,
        RunningBalance,
        ROW_NUMBER() OVER (PARTITION BY AccountNumber ORDER BY LedgerID DESC) AS rn
    FROM CustomerLedger
) cl
WHERE cl.rn = 1
GROUP BY cl.AccountNumber, cl.CustomerName, cl.CustomerID
GO

PRINT 'vw_CustomerBalances created successfully'
GO

-- =============================================
-- 11. VIEW: Cash on Hand Summary
-- =============================================
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_CashOnHandSummary]'))
    DROP VIEW [dbo].[vw_CashOnHandSummary]
GO

CREATE VIEW [dbo].[vw_CashOnHandSummary]
AS
SELECT 
    cr.BranchID,
    b.BranchName,
    SUM(CASE WHEN cr.PaymentMethod = 'Cash' AND cr.TransactionType IN ('Sale', 'Deposit') THEN cr.Amount ELSE 0 END) AS CashReceived,
    SUM(CASE WHEN cr.PaymentMethod = 'Cash' AND cr.TransactionType = 'Refund' THEN cr.Amount ELSE 0 END) AS CashRefunded,
    SUM(CASE WHEN cr.TransactionType = 'BankDeposit' THEN cr.Amount ELSE 0 END) AS CashDeposited,
    SUM(CASE WHEN cr.PaymentMethod = 'Cash' AND cr.TransactionType IN ('Sale', 'Deposit') THEN cr.Amount ELSE 0 END) -
    SUM(CASE WHEN cr.PaymentMethod = 'Cash' AND cr.TransactionType = 'Refund' THEN cr.Amount ELSE 0 END) -
    SUM(CASE WHEN cr.TransactionType = 'BankDeposit' THEN cr.Amount ELSE 0 END) AS CashOnHand
FROM CashRegister cr
INNER JOIN Branches b ON cr.BranchID = b.BranchID
GROUP BY cr.BranchID, b.BranchName
GO

PRINT 'vw_CashOnHandSummary created successfully'
GO

PRINT '=========================================='
PRINT 'ACCOUNTING SYSTEM SETUP COMPLETE!'
PRINT '=========================================='
PRINT 'Created:'
PRINT '- Chart of Accounts with standard accounts'
PRINT '- General Ledger for double-entry bookkeeping'
PRINT '- Customer Ledger for tracking customer balances'
PRINT '- Cash Register for daily cash tracking'
PRINT '- Bank Deposits for reconciliation'
PRINT '- Stored procedures for posting entries'
PRINT '- Views for account and customer balances'
PRINT '=========================================='
