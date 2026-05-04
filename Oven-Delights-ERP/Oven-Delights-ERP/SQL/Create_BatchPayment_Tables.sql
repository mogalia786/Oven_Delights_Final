-- =============================================
-- BATCH INVOICE PAYMENT SYSTEM
-- Tables for managing batch payments to suppliers
-- =============================================

-- =============================================
-- 1. PAYMENT BATCHES (Header)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PaymentBatches')
BEGIN
    CREATE TABLE PaymentBatches (
        BatchID INT IDENTITY(1,1) PRIMARY KEY,
        BatchNumber NVARCHAR(50) NOT NULL UNIQUE,
        BatchDate DATE NOT NULL,
        PaymentDate DATE NOT NULL,
        PaymentMethod NVARCHAR(20) NOT NULL, -- 'EFT', 'Check', 'Cash'
        BankAccountID INT NULL,
        TotalAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
        InvoiceCount INT NOT NULL DEFAULT 0,
        Status NVARCHAR(20) NOT NULL DEFAULT 'Draft', -- 'Draft', 'Approved', 'Paid', 'Cancelled'
        Notes NVARCHAR(500) NULL,
        CreatedBy NVARCHAR(100) NOT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ApprovedBy NVARCHAR(100) NULL,
        ApprovedDate DATETIME NULL,
        PaidBy NVARCHAR(100) NULL,
        PaidDate DATETIME NULL,
        CONSTRAINT CK_PaymentBatch_Status CHECK (Status IN ('Draft', 'Approved', 'Paid', 'Cancelled')),
        CONSTRAINT CK_PaymentBatch_Method CHECK (PaymentMethod IN ('EFT', 'Check', 'Cash', 'Wire Transfer'))
    );
    PRINT '✅ PaymentBatches table created';
END
ELSE
    PRINT '⚠️ PaymentBatches table already exists';
GO

-- =============================================
-- 2. PAYMENT BATCH ITEMS (Detail)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PaymentBatchItems')
BEGIN
    CREATE TABLE PaymentBatchItems (
        BatchItemID INT IDENTITY(1,1) PRIMARY KEY,
        BatchID INT NOT NULL,
        InvoiceID INT NOT NULL,
        SupplierID INT NOT NULL,
        InvoiceNumber NVARCHAR(50) NOT NULL,
        InvoiceDate DATE NOT NULL,
        DueDate DATE NULL,
        InvoiceAmount DECIMAL(18,2) NOT NULL,
        AmountPaid DECIMAL(18,2) NOT NULL,
        DiscountTaken DECIMAL(18,2) NOT NULL DEFAULT 0,
        Notes NVARCHAR(500) NULL,
        CONSTRAINT FK_BatchItems_Batch FOREIGN KEY (BatchID) REFERENCES PaymentBatches(BatchID) ON DELETE CASCADE
    );
    PRINT '✅ PaymentBatchItems table created';
END
ELSE
    PRINT '⚠️ PaymentBatchItems table already exists';
GO

-- =============================================
-- 3. SUPPLIER PAYMENTS (Payment Transactions)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'SupplierPayments')
BEGIN
    CREATE TABLE SupplierPayments (
        PaymentID INT IDENTITY(1,1) PRIMARY KEY,
        PaymentNumber NVARCHAR(50) NOT NULL UNIQUE,
        BatchID INT NULL,
        SupplierID INT NOT NULL,
        PaymentDate DATE NOT NULL,
        PaymentMethod NVARCHAR(20) NOT NULL,
        Amount DECIMAL(18,2) NOT NULL,
        CheckNumber NVARCHAR(50) NULL,
        ReferenceNumber NVARCHAR(100) NULL,
        BankAccountID INT NULL,
        Notes NVARCHAR(500) NULL,
        JournalEntryID INT NULL,
        CreatedBy NVARCHAR(100) NOT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_SupplierPayments_Batch FOREIGN KEY (BatchID) REFERENCES PaymentBatches(BatchID)
    );
    PRINT '✅ SupplierPayments table created';
END
ELSE
    PRINT '⚠️ SupplierPayments table already exists';
GO

-- =============================================
-- 4. SUPPLIER INVOICE PAYMENTS (Link invoices to payments)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'SupplierInvoicePayments')
BEGIN
    CREATE TABLE SupplierInvoicePayments (
        InvoicePaymentID INT IDENTITY(1,1) PRIMARY KEY,
        PaymentID INT NOT NULL,
        InvoiceID INT NOT NULL,
        AmountApplied DECIMAL(18,2) NOT NULL,
        DiscountTaken DECIMAL(18,2) NOT NULL DEFAULT 0,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_InvoicePayments_Payment FOREIGN KEY (PaymentID) REFERENCES SupplierPayments(PaymentID) ON DELETE CASCADE
    );
    PRINT '✅ SupplierInvoicePayments table created';
END
ELSE
    PRINT '⚠️ SupplierInvoicePayments table already exists';
GO

-- =============================================
-- 5. BANK ACCOUNTS (If not exists)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BankAccounts')
BEGIN
    CREATE TABLE BankAccounts (
        BankAccountID INT IDENTITY(1,1) PRIMARY KEY,
        AccountName NVARCHAR(100) NOT NULL,
        AccountNumber NVARCHAR(50) NOT NULL,
        BankName NVARCHAR(100) NOT NULL,
        BranchCode NVARCHAR(20) NULL,
        CurrentBalance DECIMAL(18,2) NOT NULL DEFAULT 0,
        GLAccountID INT NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
    );
    PRINT '✅ BankAccounts table created';
    
    -- Insert default bank account
    INSERT INTO BankAccounts (AccountName, AccountNumber, BankName, BranchCode, CurrentBalance)
    VALUES ('Main Operating Account', '1234567890', 'Standard Bank', '250655', 0.00);
    PRINT '✅ Default bank account inserted';
END
ELSE
    PRINT '⚠️ BankAccounts table already exists';
GO

-- =============================================
-- 6. SUPPLIER INVOICES (If not exists - for tracking)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'SupplierInvoices')
BEGIN
    CREATE TABLE SupplierInvoices (
        InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
        InvoiceNumber NVARCHAR(50) NOT NULL,
        SupplierID INT NOT NULL,
        InvoiceDate DATE NOT NULL,
        DueDate DATE NULL,
        TotalAmount DECIMAL(18,2) NOT NULL,
        AmountPaid DECIMAL(18,2) NOT NULL DEFAULT 0,
        AmountDue AS (TotalAmount - AmountPaid) PERSISTED,
        Status NVARCHAR(20) NOT NULL DEFAULT 'Unpaid', -- 'Unpaid', 'Partial', 'Paid'
        CreatedBy NVARCHAR(100) NOT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT CK_SupplierInvoice_Status CHECK (Status IN ('Unpaid', 'Partial', 'Paid', 'Cancelled'))
    );
    PRINT '✅ SupplierInvoices table created';
END
ELSE
    PRINT '⚠️ SupplierInvoices table already exists';
GO

-- =============================================
-- 7. CREATE INDEXES
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_PaymentBatches_Status')
    CREATE INDEX IX_PaymentBatches_Status ON PaymentBatches(Status);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_PaymentBatches_BatchDate')
    CREATE INDEX IX_PaymentBatches_BatchDate ON PaymentBatches(BatchDate);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_SupplierPayments_SupplierID')
    CREATE INDEX IX_SupplierPayments_SupplierID ON SupplierPayments(SupplierID);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_SupplierInvoices_Status')
    CREATE INDEX IX_SupplierInvoices_Status ON SupplierInvoices(Status);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_SupplierInvoices_DueDate')
    CREATE INDEX IX_SupplierInvoices_DueDate ON SupplierInvoices(DueDate);

PRINT '✅ Indexes created';
GO

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ BATCH PAYMENT SYSTEM TABLES CREATED!';
PRINT '   - PaymentBatches';
PRINT '   - PaymentBatchItems';
PRINT '   - SupplierPayments';
PRINT '   - SupplierInvoicePayments';
PRINT '   - BankAccounts';
PRINT '   - SupplierInvoices';
PRINT '═══════════════════════════════════════════════';
