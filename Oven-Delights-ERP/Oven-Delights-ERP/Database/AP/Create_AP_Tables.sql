-- =============================================
-- Accounts Payable System - Database Tables
-- =============================================

-- 1. AP Categories (Payment Types)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AP_Categories')
BEGIN
    CREATE TABLE AP_Categories (
        CategoryID INT IDENTITY(1,1) PRIMARY KEY,
        CategoryName NVARCHAR(100) NOT NULL UNIQUE,
        Description NVARCHAR(500),
        GLAccountCode NVARCHAR(20), -- Links to Chart of Accounts
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedBy NVARCHAR(100),
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedBy NVARCHAR(100),
        ModifiedDate DATETIME
    )

    -- Insert default categories
    INSERT INTO AP_Categories (CategoryName, Description, GLAccountCode, IsActive)
    VALUES 
        ('Rent', 'Monthly rent payments', '6100', 1),
        ('Electricity', 'Electricity and utilities', '6200', 1),
        ('Water', 'Water and sewerage', '6210', 1),
        ('Bank Charges', 'Bank fees and charges', '6300', 1),
        ('Salaries', 'Employee salaries', '6400', 1),
        ('Suppliers', 'Supplier payments', '5000', 1),
        ('Insurance', 'Insurance premiums', '6500', 1),
        ('Maintenance', 'Repairs and maintenance', '6600', 1),
        ('Telephone', 'Telephone and internet', '6700', 1),
        ('Stationery', 'Office supplies', '6800', 1),
        ('Professional Fees', 'Legal, accounting, consulting', '6900', 1),
        ('Other', 'Miscellaneous expenses', '6999', 1)
END
GO

-- 2. AP Beneficiaries (Suppliers/Vendors)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AP_Beneficiaries')
BEGIN
    CREATE TABLE AP_Beneficiaries (
        BeneficiaryID INT IDENTITY(1,1) PRIMARY KEY,
        BeneficiaryName NVARCHAR(200) NOT NULL,
        BeneficiaryType NVARCHAR(50), -- Individual, Company
        RegistrationNumber NVARCHAR(50), -- Company registration or ID number
        TaxNumber NVARCHAR(50),
        
        -- Banking Details
        BankName NVARCHAR(100),
        BranchCode NVARCHAR(20),
        AccountNumber NVARCHAR(50),
        AccountType NVARCHAR(20), -- Cheque, Savings, Transmission
        AccountHolderName NVARCHAR(200),
        
        -- Contact Information
        ContactPerson NVARCHAR(100),
        Email NVARCHAR(100),
        Phone NVARCHAR(50),
        Mobile NVARCHAR(50),
        Address NVARCHAR(500),
        
        -- Default Settings
        DefaultCategoryID INT,
        PaymentTerms INT DEFAULT 30, -- Days
        
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedBy NVARCHAR(100),
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedBy NVARCHAR(100),
        ModifiedDate DATETIME,
        
        CONSTRAINT FK_Beneficiary_Category FOREIGN KEY (DefaultCategoryID) 
            REFERENCES AP_Categories(CategoryID)
    )
    
    -- Insert default sandbox test beneficiaries
    -- Using FNB Sandbox Test Accounts for testing
    INSERT INTO AP_Beneficiaries (
        BeneficiaryName, BeneficiaryType, BankName, BranchCode, 
        AccountNumber, AccountType, AccountHolderName,
        ContactPerson, Email, Phone, DefaultCategoryID, IsActive, CreatedBy, CreatedDate
    )
    VALUES 
        -- Sandbox Beneficiary 1 - For Rent/Utilities
        ('SANDBOX LANDLORD - TEST', 'Company', 'FNB', '250655', 
         '63001730117', 'Cheque', 'SANDBOX LANDLORD',
         'Test Contact 1', 'test1@sandbox.fnb.co.za', '0111234567', 
         (SELECT CategoryID FROM AP_Categories WHERE CategoryName = 'Rent'), 1, 'System', GETDATE()),
        
        -- Sandbox Beneficiary 2 - For Suppliers
        ('SANDBOX SUPPLIER - TEST', 'Company', 'FNB', '250655', 
         '63001731222', 'Cheque', 'SANDBOX SUPPLIER',
         'Test Contact 2', 'test2@sandbox.fnb.co.za', '0117654321', 
         (SELECT CategoryID FROM AP_Categories WHERE CategoryName = 'Suppliers'), 1, 'System', GETDATE()),
        
        -- Sandbox Beneficiary 3 - For Electricity
        ('SANDBOX ESKOM - TEST', 'Company', 'FNB', '250655', 
         '63001730117', 'Cheque', 'SANDBOX ESKOM',
         'Test Contact 3', 'test3@sandbox.fnb.co.za', '0119876543', 
         (SELECT CategoryID FROM AP_Categories WHERE CategoryName = 'Electricity'), 1, 'System', GETDATE()),
        
        -- Sandbox Beneficiary 4 - For Bank Charges
        ('SANDBOX BANK - TEST', 'Company', 'FNB', '250655', 
         '63001731222', 'Cheque', 'SANDBOX BANK',
         'Test Contact 4', 'test4@sandbox.fnb.co.za', '0115551234', 
         (SELECT CategoryID FROM AP_Categories WHERE CategoryName = 'Bank Charges'), 1, 'System', GETDATE()),
        
        -- Sandbox Beneficiary 5 - For Maintenance
        ('SANDBOX MAINTENANCE - TEST', 'Company', 'FNB', '250655', 
         '63001730117', 'Cheque', 'SANDBOX MAINTENANCE',
         'Test Contact 5', 'test5@sandbox.fnb.co.za', '0115559999', 
         (SELECT CategoryID FROM AP_Categories WHERE CategoryName = 'Maintenance'), 1, 'System', GETDATE())
    
    PRINT 'Default sandbox test beneficiaries created'
    PRINT '*** USING FNB SANDBOX TEST ACCOUNTS ***'
    PRINT '*** Account 1: 63001730117 ***'
    PRINT '*** Account 2: 63001731222 ***'
END
GO

-- 3. AP Invoices (Bills to Pay)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AP_Invoices')
BEGIN
    CREATE TABLE AP_Invoices (
        InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
        InvoiceNumber NVARCHAR(50) NOT NULL,
        BeneficiaryID INT NOT NULL,
        CategoryID INT NOT NULL,
        
        InvoiceDate DATE NOT NULL,
        DueDate DATE NOT NULL,
        Amount DECIMAL(18,2) NOT NULL,
        TaxAmount DECIMAL(18,2) DEFAULT 0,
        TotalAmount AS (Amount + TaxAmount) PERSISTED,
        
        Description NVARCHAR(500),
        Reference NVARCHAR(100),
        
        Status NVARCHAR(20) NOT NULL DEFAULT 'Pending', -- Pending, Paid, Cancelled, Overdue
        PaymentBatchID INT,
        PaymentDate DATETIME,
        
        -- Reconciliation
        StatementTransactionID INT,
        IsReconciled BIT DEFAULT 0,
        ReconciledDate DATETIME,
        ReconciledBy NVARCHAR(100),
        
        -- Audit
        CreatedBy NVARCHAR(100),
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedBy NVARCHAR(100),
        ModifiedDate DATETIME,
        
        CONSTRAINT FK_Invoice_Beneficiary FOREIGN KEY (BeneficiaryID) 
            REFERENCES AP_Beneficiaries(BeneficiaryID),
        CONSTRAINT FK_Invoice_Category FOREIGN KEY (CategoryID) 
            REFERENCES AP_Categories(CategoryID)
    )
    
    CREATE INDEX IX_AP_Invoices_Status ON AP_Invoices(Status)
    CREATE INDEX IX_AP_Invoices_DueDate ON AP_Invoices(DueDate)
    CREATE INDEX IX_AP_Invoices_Beneficiary ON AP_Invoices(BeneficiaryID)
END
GO

-- 4. AP Payment Batches
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AP_PaymentBatches')
BEGIN
    CREATE TABLE AP_PaymentBatches (
        BatchID INT IDENTITY(1,1) PRIMARY KEY,
        BatchNumber NVARCHAR(50) NOT NULL UNIQUE,
        BatchDate DATETIME NOT NULL DEFAULT GETDATE(),
        
        TotalInvoices INT NOT NULL,
        TotalAmount DECIMAL(18,2) NOT NULL,
        
        -- FNB API Integration
        InstructionID NVARCHAR(100), -- From FNB API response
        MessageID NVARCHAR(100),
        
        Status NVARCHAR(20) NOT NULL DEFAULT 'Pending', -- Pending, Submitted, Processing, Completed, Failed
        StatusMessage NVARCHAR(500),
        
        FNBRequestJSON NVARCHAR(MAX),
        FNBResponseJSON NVARCHAR(MAX),
        
        SubmittedDate DATETIME,
        CompletedDate DATETIME,
        
        CreatedBy NVARCHAR(100),
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedBy NVARCHAR(100),
        ModifiedDate DATETIME
    )
    
    CREATE INDEX IX_AP_PaymentBatches_Status ON AP_PaymentBatches(Status)
END
GO

-- 5. AP Payment Batch Items
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AP_PaymentBatchItems')
BEGIN
    CREATE TABLE AP_PaymentBatchItems (
        BatchItemID INT IDENTITY(1,1) PRIMARY KEY,
        BatchID INT NOT NULL,
        InvoiceID INT NOT NULL,
        
        Amount DECIMAL(18,2) NOT NULL,
        
        Status NVARCHAR(20) DEFAULT 'Pending', -- Pending, Success, Failed, Rejected
        StatusMessage NVARCHAR(500),
        RejectionReasonCode NVARCHAR(50),
        RejectionReasonText NVARCHAR(500),
        
        EndToEndID NVARCHAR(100), -- FNB transaction reference
        
        CreatedDate DATETIME DEFAULT GETDATE(),
        
        CONSTRAINT FK_BatchItem_Batch FOREIGN KEY (BatchID) 
            REFERENCES AP_PaymentBatches(BatchID),
        CONSTRAINT FK_BatchItem_Invoice FOREIGN KEY (InvoiceID) 
            REFERENCES AP_Invoices(InvoiceID)
    )
    
    CREATE INDEX IX_AP_PaymentBatchItems_Batch ON AP_PaymentBatchItems(BatchID)
    CREATE INDEX IX_AP_PaymentBatchItems_Invoice ON AP_PaymentBatchItems(InvoiceID)
END
GO

-- 6. AP Statement Transactions (from FNB API)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AP_StatementTransactions')
BEGIN
    CREATE TABLE AP_StatementTransactions (
        TransactionID INT IDENTITY(1,1) PRIMARY KEY,
        
        -- Account Information
        AccountNumber NVARCHAR(50) NOT NULL,
        AccountName NVARCHAR(200),
        
        -- Transaction Details
        TransactionDate DATE NOT NULL,
        BookingDateTime DATETIME,
        ValueDate DATE,
        
        Amount DECIMAL(18,2) NOT NULL,
        Currency NVARCHAR(10) DEFAULT 'ZAR',
        CreditDebitIndicator NVARCHAR(10), -- CRDT or DBIT
        
        Description NVARCHAR(500),
        Reference NVARCHAR(200),
        ServicerReference NVARCHAR(100),
        EndToEndID NVARCHAR(100),
        
        -- Transaction Codes
        BankTransactionDomainCode NVARCHAR(50),
        BankTransactionFamilyCode NVARCHAR(50),
        BankTransactionSubFamilyCode NVARCHAR(50),
        
        -- Related Party
        RelatedPartyName NVARCHAR(200),
        
        -- Mapping and Reconciliation
        MappedCategoryID INT,
        MappedInvoiceID INT,
        IsReconciled BIT DEFAULT 0,
        ReconciledDate DATETIME,
        ReconciledBy NVARCHAR(100),
        
        -- API Metadata
        StatementMessageID NVARCHAR(100),
        FetchedDate DATETIME DEFAULT GETDATE(),
        FetchedBy NVARCHAR(100),
        RawJSON NVARCHAR(MAX),
        
        CONSTRAINT FK_StatementTxn_Category FOREIGN KEY (MappedCategoryID) 
            REFERENCES AP_Categories(CategoryID),
        CONSTRAINT FK_StatementTxn_Invoice FOREIGN KEY (MappedInvoiceID) 
            REFERENCES AP_Invoices(InvoiceID)
    )
    
    CREATE INDEX IX_AP_StatementTransactions_Account ON AP_StatementTransactions(AccountNumber)
    CREATE INDEX IX_AP_StatementTransactions_Date ON AP_StatementTransactions(TransactionDate)
    CREATE INDEX IX_AP_StatementTransactions_Reconciled ON AP_StatementTransactions(IsReconciled)
END
GO

-- 7. AP GL Postings (Journal Entries)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AP_GLPostings')
BEGIN
    CREATE TABLE AP_GLPostings (
        PostingID INT IDENTITY(1,1) PRIMARY KEY,
        
        InvoiceID INT,
        PaymentBatchID INT,
        
        PostingDate DATE NOT NULL,
        Description NVARCHAR(500),
        
        DebitAccount NVARCHAR(20) NOT NULL,
        CreditAccount NVARCHAR(20) NOT NULL,
        Amount DECIMAL(18,2) NOT NULL,
        
        JournalEntryID INT, -- Links to main GL system
        
        CreatedBy NVARCHAR(100),
        CreatedDate DATETIME DEFAULT GETDATE(),
        
        CONSTRAINT FK_GLPosting_Invoice FOREIGN KEY (InvoiceID) 
            REFERENCES AP_Invoices(InvoiceID),
        CONSTRAINT FK_GLPosting_Batch FOREIGN KEY (PaymentBatchID) 
            REFERENCES AP_PaymentBatches(BatchID)
    )
    
    CREATE INDEX IX_AP_GLPostings_Invoice ON AP_GLPostings(InvoiceID)
    CREATE INDEX IX_AP_GLPostings_Batch ON AP_GLPostings(PaymentBatchID)
END
GO

PRINT 'Accounts Payable tables created successfully'
