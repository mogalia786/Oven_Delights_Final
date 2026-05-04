-- =============================================
-- BANK STATEMENT RECONCILIATION SYSTEM
-- Purpose: Automated bank statement matching and GL posting
-- Features: FNB integration, auto-matching, beneficiary management
-- =============================================
-- NOTE: Connect to OvenDelightsERP database BEFORE executing this script
-- (Azure SQL does not support USE statements)
-- GO

-- =============================================
-- TABLE 1: Beneficiaries (Adhoc Payment Recipients)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Beneficiaries]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Beneficiaries] (
        BeneficiaryID INT IDENTITY(1,1) PRIMARY KEY,
        BeneficiaryName NVARCHAR(200) NOT NULL,
        BeneficiaryType NVARCHAR(50) NOT NULL, -- 'Supplier', 'Individual', 'Company', 'Government'
        Category NVARCHAR(100) NOT NULL, -- 'Rent', 'Electricity', 'Water', 'Insurance', 'Professional Fees', etc.
        BankName NVARCHAR(100),
        AccountNumber NVARCHAR(50),
        BranchCode NVARCHAR(20),
        AccountType NVARCHAR(50), -- 'Cheque', 'Savings', 'Transmission'
        TaxNumber NVARCHAR(50),
        ContactPerson NVARCHAR(100),
        PhoneNumber NVARCHAR(20),
        EmailAddress NVARCHAR(100),
        PhysicalAddress NVARCHAR(500),
        IsActive BIT DEFAULT 1,
        CreatedBy NVARCHAR(100),
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedBy NVARCHAR(100),
        ModifiedDate DATETIME,
        Notes NVARCHAR(MAX)
    )
    PRINT 'Table Beneficiaries created successfully'
END
GO

-- =============================================
-- TABLE 2: Beneficiary Payments
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BeneficiaryPayments]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[BeneficiaryPayments] (
        PaymentID INT IDENTITY(1,1) PRIMARY KEY,
        BeneficiaryID INT NOT NULL FOREIGN KEY REFERENCES Beneficiaries(BeneficiaryID),
        PaymentReference NVARCHAR(50) UNIQUE NOT NULL, -- Auto-generated: BEN-2026-001234
        PaymentDate DATE NOT NULL,
        Amount DECIMAL(18,2) NOT NULL,
        Description NVARCHAR(500),
        Category NVARCHAR(100) NOT NULL, -- Same as beneficiary category
        PaymentMethod NVARCHAR(50) DEFAULT 'EFT', -- 'EFT', 'Cash', 'Cheque'
        Status NVARCHAR(50) DEFAULT 'Pending', -- 'Pending', 'Approved', 'Sent to Bank', 'Paid', 'Cancelled'
        ApprovedBy NVARCHAR(100),
        ApprovedDate DATETIME,
        SentToBankDate DATETIME,
        PaidDate DATETIME,
        BankTransactionRef NVARCHAR(100), -- FNB transaction reference
        BankStatementLineID INT, -- Link to bank statement line
        ExpenseAccountID INT, -- Link to Chart of Accounts
        CreatedBy NVARCHAR(100),
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedBy NVARCHAR(100),
        ModifiedDate DATETIME,
        Notes NVARCHAR(MAX)
    )
    PRINT 'Table BeneficiaryPayments created successfully'
END
GO

-- =============================================
-- TABLE 3: Payment Batches
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaymentBatches]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[PaymentBatches] (
        BatchID INT IDENTITY(1,1) PRIMARY KEY,
        BatchNumber NVARCHAR(50) UNIQUE NOT NULL, -- Auto-generated: BATCH-2026-001
        BatchDate DATE NOT NULL,
        TotalAmount DECIMAL(18,2) NOT NULL,
        TotalPayments INT NOT NULL,
        Status NVARCHAR(50) DEFAULT 'Draft', -- 'Draft', 'Approved', 'Sent to Bank', 'Completed', 'Cancelled'
        PaymentType NVARCHAR(50) NOT NULL, -- 'Supplier', 'Beneficiary', 'Mixed'
        ApprovedBy NVARCHAR(100),
        ApprovedDate DATETIME,
        SentToBankDate DATETIME,
        CompletedDate DATETIME,
        BankBatchRef NVARCHAR(100), -- FNB batch reference
        CreatedBy NVARCHAR(100),
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedBy NVARCHAR(100),
        ModifiedDate DATETIME,
        Notes NVARCHAR(MAX)
    )
    PRINT 'Table PaymentBatches created successfully'
END
GO

-- =============================================
-- TABLE 4: Payment Batch Items
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaymentBatchItems]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[PaymentBatchItems] (
        BatchItemID INT IDENTITY(1,1) PRIMARY KEY,
        BatchID INT NOT NULL FOREIGN KEY REFERENCES PaymentBatches(BatchID),
        PaymentType NVARCHAR(50) NOT NULL, -- 'Supplier', 'Beneficiary'
        ReferenceID INT NOT NULL, -- SupplierInvoiceID or BeneficiaryPaymentID
        PaymentReference NVARCHAR(50) NOT NULL, -- SUP-xxx or BEN-xxx
        Amount DECIMAL(18,2) NOT NULL,
        RecipientName NVARCHAR(200) NOT NULL,
        BankName NVARCHAR(100),
        AccountNumber NVARCHAR(50),
        BranchCode NVARCHAR(20),
        Status NVARCHAR(50) DEFAULT 'Pending', -- 'Pending', 'Sent', 'Paid', 'Failed'
        CreatedDate DATETIME DEFAULT GETDATE()
    )
    PRINT 'Table PaymentBatchItems created successfully'
END
GO

-- =============================================
-- TABLE 5: Bank Accounts
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BankAccounts]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[BankAccounts] (
        BankAccountID INT IDENTITY(1,1) PRIMARY KEY,
        AccountName NVARCHAR(200) NOT NULL,
        BankName NVARCHAR(100) NOT NULL,
        AccountNumber NVARCHAR(50) NOT NULL,
        BranchCode NVARCHAR(20),
        AccountType NVARCHAR(50), -- 'Cheque', 'Savings', 'Credit Card'
        Currency NVARCHAR(10) DEFAULT 'ZAR',
        CurrentBalance DECIMAL(18,2) DEFAULT 0,
        GLAccountID INT, -- Link to Chart of Accounts (Bank account in GL)
        IsActive BIT DEFAULT 1,
        IsPrimaryAccount BIT DEFAULT 0,
        FNBAccountID NVARCHAR(100), -- FNB API account identifier
        LastStatementDate DATE,
        LastStatementBalance DECIMAL(18,2),
        CreatedBy NVARCHAR(100),
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedBy NVARCHAR(100),
        ModifiedDate DATETIME
    )
    PRINT 'Table BankAccounts created successfully'
END
GO

-- =============================================
-- TABLE 6: Bank Statement Transactions
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BankStatementTransactions]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[BankStatementTransactions] (
        StatementLineID INT IDENTITY(1,1) PRIMARY KEY,
        BankAccountID INT NOT NULL FOREIGN KEY REFERENCES BankAccounts(BankAccountID),
        TransactionDate DATE NOT NULL,
        ValueDate DATE,
        Description NVARCHAR(500) NOT NULL,
        BankReference NVARCHAR(100),
        DebitAmount DECIMAL(18,2) DEFAULT 0,
        CreditAmount DECIMAL(18,2) DEFAULT 0,
        Balance DECIMAL(18,2),
        TransactionType NVARCHAR(50), -- 'Debit', 'Credit', 'Fee', 'Interest'
        Status NVARCHAR(50) DEFAULT 'Unmatched', -- 'Unmatched', 'Matched', 'Posted', 'Ignored'
        MatchedPaymentRef NVARCHAR(50), -- SUP-xxx or BEN-xxx
        MatchedPaymentType NVARCHAR(50), -- 'Supplier', 'Beneficiary', 'Customer', 'Manual'
        MatchedReferenceID INT, -- ID of matched payment
        MatchedBy NVARCHAR(100),
        MatchedDate DATETIME,
        PostedToGL BIT DEFAULT 0,
        PostedBy NVARCHAR(100),
        PostedDate DATETIME,
        GLBatchID INT, -- Link to GL posting batch
        ImportedDate DATETIME DEFAULT GETDATE(),
        ImportedBy NVARCHAR(100),
        Notes NVARCHAR(MAX)
    )
    PRINT 'Table BankStatementTransactions created successfully'
END
GO

-- =============================================
-- TABLE 7: Bank Statement Import Log
-- =============================================
-- NOTE: Connect to OvenDelightsERP database before executing this script
-- (Azure SQL does not support USE statements)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BankStatementImportLog]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[BankStatementImportLog] (
        ImportID INT IDENTITY(1,1) PRIMARY KEY,
        BankAccountID INT NOT NULL FOREIGN KEY REFERENCES BankAccounts(BankAccountID),
        ImportDate DATETIME DEFAULT GETDATE(),
        ImportedBy NVARCHAR(100),
        StatementStartDate DATE,
        StatementEndDate DATE,
        TotalTransactions INT,
        TotalDebits DECIMAL(18,2),
        TotalCredits DECIMAL(18,2),
        OpeningBalance DECIMAL(18,2),
        ClosingBalance DECIMAL(18,2),
        AutoMatchedCount INT DEFAULT 0,
        UnmatchedCount INT DEFAULT 0,
        ImportSource NVARCHAR(50), -- 'FNB API', 'CSV Upload', 'Manual Entry'
        FileName NVARCHAR(500),
        Status NVARCHAR(50) DEFAULT 'Completed', -- 'Completed', 'Partial', 'Failed'
        ErrorMessage NVARCHAR(MAX)
    )
    PRINT 'Table BankStatementImportLog created successfully'
END
GO

-- =============================================
-- TABLE 8: Supplier Invoices (Enhanced)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SupplierInvoices]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[SupplierInvoices] (
        InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
        SupplierID INT NOT NULL,
        InvoiceNumber NVARCHAR(50) NOT NULL,
        InvoiceDate DATE NOT NULL,
        DueDate DATE NOT NULL,
        Amount DECIMAL(18,2) NOT NULL,
        TaxAmount DECIMAL(18,2) DEFAULT 0,
        TotalAmount DECIMAL(18,2) NOT NULL,
        PaymentReference NVARCHAR(50) UNIQUE NOT NULL, -- Auto-generated: SUP-2026-001234
        Status NVARCHAR(50) DEFAULT 'Pending', -- 'Pending', 'Approved', 'Sent to Bank', 'Paid', 'Cancelled'
        ApprovedBy NVARCHAR(100),
        ApprovedDate DATETIME,
        SentToBankDate DATETIME,
        PaidDate DATETIME,
        BankTransactionRef NVARCHAR(100),
        BankStatementLineID INT,
        SupplierLedgerAccountID INT, -- Link to Chart of Accounts
        CreatedBy NVARCHAR(100),
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedBy NVARCHAR(100),
        ModifiedDate DATETIME,
        Notes NVARCHAR(MAX)
    )
    PRINT 'Table SupplierInvoices created successfully'
END
GO

-- =============================================
-- Enhance SupplierInvoices table
-- =============================================
PRINT 'Enhancing SupplierInvoices table...'
GO

-- Add payment tracking columns if they don't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('SupplierInvoices') AND name = 'PaymentReference')
BEGIN
    ALTER TABLE SupplierInvoices ADD PaymentReference NVARCHAR(50)
    PRINT ' Added PaymentReference column to SupplierInvoices'
END
ELSE
    PRINT ' PaymentReference column already exists in SupplierInvoices'
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('SupplierInvoices') AND name = 'Status')
BEGIN
    ALTER TABLE SupplierInvoices ADD Status NVARCHAR(50) DEFAULT 'Pending'
    PRINT ' Added Status column to SupplierInvoices'
END
ELSE
    PRINT ' Status column already exists in SupplierInvoices'
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('SupplierInvoices') AND name = 'SentToBankDate')
BEGIN
    ALTER TABLE SupplierInvoices ADD SentToBankDate DATETIME
    PRINT ' Added SentToBankDate column to SupplierInvoices'
END
ELSE
    PRINT ' SentToBankDate column already exists in SupplierInvoices'
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('SupplierInvoices') AND name = 'PaidDate')
BEGIN
    ALTER TABLE SupplierInvoices ADD PaidDate DATETIME
    PRINT ' Added PaidDate column to SupplierInvoices'
END
ELSE
    PRINT ' PaidDate column already exists in SupplierInvoices'
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('SupplierInvoices') AND name = 'BankStatementLineID')
BEGIN
    ALTER TABLE SupplierInvoices ADD BankStatementLineID INT
    PRINT ' Added BankStatementLineID column to SupplierInvoices'
END
ELSE
    PRINT ' BankStatementLineID column already exists in SupplierInvoices'
GO

-- Create indexes for performance (only if columns exist)
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('SupplierInvoices') AND name = 'Status')
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_SupplierInvoices_Status')
    BEGIN
        CREATE INDEX IX_SupplierInvoices_Status ON SupplierInvoices(Status)
        PRINT ' Created index IX_SupplierInvoices_Status'
    END
    ELSE
        PRINT ' Index IX_SupplierInvoices_Status already exists'
END
GO

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('SupplierInvoices') AND name = 'PaymentReference')
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_SupplierInvoices_PaymentReference')
    BEGIN
        CREATE INDEX IX_SupplierInvoices_PaymentReference ON SupplierInvoices(PaymentReference)
        PRINT ' Created index IX_SupplierInvoices_PaymentReference'
    END
    ELSE
        PRINT ' Index IX_SupplierInvoices_PaymentReference already exists'
END
GO

-- =============================================
-- INDEXES for Performance
-- =============================================
-- Only create indexes if tables and columns exist
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'BankStatementTransactions' AND type = 'U')
    AND EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('BankStatementTransactions') AND name = 'Status')
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_BankStatementTransactions_Status')
    BEGIN
        CREATE INDEX IX_BankStatementTransactions_Status ON BankStatementTransactions(Status)
        PRINT '✓ Created index IX_BankStatementTransactions_Status'
    END
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'BankStatementTransactions' AND type = 'U')
    AND EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('BankStatementTransactions') AND name = 'TransactionDate')
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_BankStatementTransactions_TransactionDate')
    BEGIN
        CREATE INDEX IX_BankStatementTransactions_TransactionDate ON BankStatementTransactions(TransactionDate)
        PRINT '✓ Created index IX_BankStatementTransactions_TransactionDate'
    END
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'BankStatementTransactions' AND type = 'U')
    AND EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('BankStatementTransactions') AND name = 'Description')
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_BankStatementTransactions_Description')
    BEGIN
        CREATE INDEX IX_BankStatementTransactions_Description ON BankStatementTransactions(Description)
        PRINT '✓ Created index IX_BankStatementTransactions_Description'
    END
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'BeneficiaryPayments' AND type = 'U')
    AND EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('BeneficiaryPayments') AND name = 'Status')
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_BeneficiaryPayments_Status')
    BEGIN
        CREATE INDEX IX_BeneficiaryPayments_Status ON BeneficiaryPayments(Status)
        PRINT '✓ Created index IX_BeneficiaryPayments_Status'
    END
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'BeneficiaryPayments' AND type = 'U')
    AND EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('BeneficiaryPayments') AND name = 'PaymentReference')
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_BeneficiaryPayments_PaymentReference')
    BEGIN
        CREATE INDEX IX_BeneficiaryPayments_PaymentReference ON BeneficiaryPayments(PaymentReference)
        PRINT '✓ Created index IX_BeneficiaryPayments_PaymentReference'
    END
END
GO

PRINT '========================================='
PRINT 'Bank Reconciliation System Schema Created Successfully'
PRINT '========================================='
GO
