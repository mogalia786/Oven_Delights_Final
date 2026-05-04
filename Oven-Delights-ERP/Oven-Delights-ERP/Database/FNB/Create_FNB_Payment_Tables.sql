-- =============================================
-- FNB Payment Execution API - Database Schema
-- Purpose: Track automated EFT payments via FNB API
-- =============================================

SET NOCOUNT ON;
GO

-- =============================================
-- Table: FNB_PaymentBatches
-- Stores payment batch submissions to FNB API
-- =============================================
IF OBJECT_ID('dbo.FNB_PaymentBatches', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.FNB_PaymentBatches (
        BatchID INT IDENTITY(1,1) PRIMARY KEY,
        
        -- Batch Identification
        MessageID NVARCHAR(50) UNIQUE NOT NULL,           -- Our unique reference (sent to FNB)
        InstructionID NVARCHAR(200),                      -- FNB's tracking reference (returned by API)
        
        -- Batch Details
        CreationDateTime DATETIME NOT NULL DEFAULT GETDATE(),
        InitiatingPartyName NVARCHAR(100) DEFAULT 'OVEN DELIGHTS PTY LTD',
        TotalNumberOfTransactions INT NOT NULL,
        TotalControlSum DECIMAL(18,2) NOT NULL,
        
        -- Processing Details
        RequestedExecutionDate DATE NOT NULL,
        ServiceLevelCode NVARCHAR(10) DEFAULT 'SDVA',    -- SDVA, NURG, URGP
        BatchBooking BIT DEFAULT 1,                       -- Single debit entry vs individual debits
        
        -- Status
        BatchStatus NVARCHAR(20) DEFAULT 'Pending',      -- Pending, ACCP, RJCT, PDNG, ACSC
        StatusCheckedDate DATETIME,
        
        -- Debtor (Our Account - Money Going Out)
        DebtorAccountNumber NVARCHAR(23) NOT NULL,
        DebtorAccountType NVARCHAR(10) DEFAULT 'CACC',
        DebtorBranchID NVARCHAR(10) DEFAULT '250655',
        
        -- Audit
        BranchID INT NOT NULL,                            -- FK to Branches
        CreatedBy INT NOT NULL,                           -- FK to Users
        CreatedDate DATETIME DEFAULT GETDATE(),
        SubmittedDate DATETIME,
        CompletedDate DATETIME,
        
        -- Error Handling
        RejectionReason NVARCHAR(MAX),
        ErrorDetails NVARCHAR(MAX),
        
        -- API Response (Full JSON for debugging)
        APIRequestJSON NVARCHAR(MAX),
        APIResponseJSON NVARCHAR(MAX),
        
        INDEX IX_MessageID (MessageID),
        INDEX IX_InstructionID (InstructionID),
        INDEX IX_BatchStatus (BatchStatus),
        INDEX IX_RequestedExecutionDate (RequestedExecutionDate),
        INDEX IX_BranchID (BranchID),
        INDEX IX_CreatedDate (CreatedDate)
    );
    
    PRINT 'Created table: FNB_PaymentBatches';
END
ELSE
BEGIN
    PRINT 'Table already exists: FNB_PaymentBatches';
END
GO

-- =============================================
-- Table: FNB_PaymentTransactions
-- Stores individual payment transactions within batches
-- =============================================
IF OBJECT_ID('dbo.FNB_PaymentTransactions', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.FNB_PaymentTransactions (
        PaymentTransactionID INT IDENTITY(1,1) PRIMARY KEY,
        BatchID INT NOT NULL,                             -- FK to FNB_PaymentBatches
        
        -- Transaction Identification
        EndToEndID NVARCHAR(50) NOT NULL,                 -- Our reference (invoice/payment number)
        
        -- Amount
        Currency NVARCHAR(3) DEFAULT 'ZAR',
        Amount DECIMAL(18,2) NOT NULL,
        
        -- Creditor (Supplier - Money Going In)
        CreditorName NVARCHAR(100) NOT NULL,
        CreditorAccountNumber NVARCHAR(23) NOT NULL,
        CreditorAccountType NVARCHAR(10) DEFAULT 'CACC',
        CreditorBranchID NVARCHAR(10),
        CreditorBIC NVARCHAR(20),
        
        -- Remittance
        RemittanceReference NVARCHAR(30),                 -- Reference on supplier statement
        RemittanceReference20 NVARCHAR(20),               -- First 20 chars (what's actually processed)
        ProofOfPaymentEmail NVARCHAR(100),
        
        -- Status
        TransactionStatus NVARCHAR(20) DEFAULT 'Pending', -- Pending, ACCC, RJCT, PDNG, ACSP
        StatusCheckedDate DATETIME,
        
        -- Linking to ERP
        SupplierID INT,                                   -- FK to Suppliers
        PurchaseInvoiceID INT,                            -- FK to PurchaseInvoices (if applicable)
        ExpenseBillID INT,                                -- FK to ExpenseBills (if applicable)
        PaymentType NVARCHAR(20),                         -- 'Supplier', 'Expense', 'Misc'
        
        -- Journal Entry
        JournalID INT,                                    -- FK to Journals (when posted)
        IsPosted BIT DEFAULT 0,
        PostedDate DATETIME,
        
        -- Error Handling
        RejectionReasonCode NVARCHAR(10),
        RejectionReasonText NVARCHAR(500),
        
        -- Audit
        CreatedDate DATETIME DEFAULT GETDATE(),
        ProcessedDate DATETIME,
        
        FOREIGN KEY (BatchID) REFERENCES dbo.FNB_PaymentBatches(BatchID),
        INDEX IX_BatchID (BatchID),
        INDEX IX_EndToEndID (EndToEndID),
        INDEX IX_TransactionStatus (TransactionStatus),
        INDEX IX_SupplierID (SupplierID),
        INDEX IX_PurchaseInvoiceID (PurchaseInvoiceID),
        INDEX IX_IsPosted (IsPosted)
    );
    
    PRINT 'Created table: FNB_PaymentTransactions';
END
ELSE
BEGIN
    PRINT 'Table already exists: FNB_PaymentTransactions';
END
GO

-- =============================================
-- Table: FNB_PaymentStatusLog
-- Audit trail of status changes
-- =============================================
IF OBJECT_ID('dbo.FNB_PaymentStatusLog', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.FNB_PaymentStatusLog (
        LogID INT IDENTITY(1,1) PRIMARY KEY,
        BatchID INT,
        PaymentTransactionID INT,
        
        StatusCheckDateTime DATETIME DEFAULT GETDATE(),
        PreviousStatus NVARCHAR(20),
        NewStatus NVARCHAR(20),
        StatusDetails NVARCHAR(MAX),
        
        CheckedBy INT,                                    -- FK to Users (or NULL for automated)
        
        INDEX IX_BatchID (BatchID),
        INDEX IX_PaymentTransactionID (PaymentTransactionID),
        INDEX IX_StatusCheckDateTime (StatusCheckDateTime)
    );
    
    PRINT 'Created table: FNB_PaymentStatusLog';
END
ELSE
BEGIN
    PRINT 'Table already exists: FNB_PaymentStatusLog';
END
GO

-- =============================================
-- Table: FNB_APICredentials
-- Stores encrypted API credentials per environment
-- =============================================
IF OBJECT_ID('dbo.FNB_APICredentials', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.FNB_APICredentials (
        CredentialID INT IDENTITY(1,1) PRIMARY KEY,
        
        Environment NVARCHAR(20) NOT NULL,                -- 'Sandbox', 'Production'
        ClientID NVARCHAR(50) NOT NULL,
        ClientSecret NVARCHAR(200) NOT NULL,              -- Should be encrypted
        
        BaseURL NVARCHAR(200) NOT NULL,
        TokenURL NVARCHAR(200) NOT NULL,
        
        DebtorAccountNumber NVARCHAR(23),                 -- Default debtor account for this environment
        DebtorBranchID NVARCHAR(10),
        
        IsActive BIT DEFAULT 1,
        IsSandbox BIT DEFAULT 0,
        
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedDate DATETIME,
        
        Notes NVARCHAR(MAX),                              -- e.g., "SANDBOX TESTING ONLY"
        
        INDEX IX_Environment (Environment),
        INDEX IX_IsActive (IsActive)
    );
    
    PRINT 'Created table: FNB_APICredentials';
END
ELSE
BEGIN
    PRINT 'Table already exists: FNB_APICredentials';
END
GO

-- =============================================
-- Insert Sandbox Credentials (FOR TESTING ONLY)
-- =============================================
IF NOT EXISTS (SELECT 1 FROM dbo.FNB_APICredentials WHERE Environment = 'Sandbox')
BEGIN
    INSERT INTO dbo.FNB_APICredentials (
        Environment,
        ClientID,
        ClientSecret,
        BaseURL,
        TokenURL,
        DebtorAccountNumber,
        DebtorBranchID,
        IsActive,
        IsSandbox,
        Notes
    )
    VALUES (
        'Sandbox',
        'E84OOE',
        '621NZsDknRDWjqf8sKhyH0ktjPXtbsr4',
        'https://api.i.fnb.co.za/apigateway',
        'https://api.i.fnb.co.za/apigateway/oauth2/token/v2',
        '63001723469',
        '250655',
        1,
        1,
        '*** SANDBOX TESTING ONLY - NOT FOR PRODUCTION USE ***'
    );
    
    PRINT 'Inserted Sandbox credentials';
END
GO

-- =============================================
-- Placeholder for Production Credentials
-- =============================================
IF NOT EXISTS (SELECT 1 FROM dbo.FNB_APICredentials WHERE Environment = 'Production')
BEGIN
    INSERT INTO dbo.FNB_APICredentials (
        Environment,
        ClientID,
        ClientSecret,
        BaseURL,
        TokenURL,
        DebtorAccountNumber,
        DebtorBranchID,
        IsActive,
        IsSandbox,
        Notes
    )
    VALUES (
        'Production',
        'PROD_CLIENT_ID',
        'PROD_CLIENT_SECRET',
        'https://api.fnb.co.za/apigateway',
        'https://api.fnb.co.za/apigateway/oauth2/token/v2',
        '00000000000',
        '250655',
        0,
        0,
        '*** PRODUCTION - Replace with actual credentials before activating ***'
    );
    
    PRINT 'Inserted Production credentials placeholder';
END
GO

PRINT '';
PRINT '==============================================';
PRINT 'FNB Payment Execution API schema created successfully';
PRINT '==============================================';
GO
