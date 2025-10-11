-- =============================================
-- Cash Book Schema
-- Supports: Main Cash, Petty Cash, Sundries
-- Features: Float management, reconciliation, GL integration
-- =============================================

USE [Oven_Delights_Main]
GO

-- =============================================
-- 0. Ensure Required Tables Exist
-- =============================================

-- Ensure ChartOfAccounts exists
IF OBJECT_ID('dbo.ChartOfAccounts', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ChartOfAccounts (
        AccountID INT IDENTITY(1,1) PRIMARY KEY,
        AccountCode NVARCHAR(20) NOT NULL UNIQUE,
        AccountName NVARCHAR(200) NOT NULL,
        AccountType NVARCHAR(50) NOT NULL,
        ParentAccountID INT NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME2 DEFAULT GETDATE()
    );
    PRINT 'Created table: ChartOfAccounts';
END

-- Ensure Branches exists
IF OBJECT_ID('dbo.Branches', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Branches (
        BranchID INT IDENTITY(1,1) PRIMARY KEY,
        BranchName NVARCHAR(100) NOT NULL,
        BranchCode NVARCHAR(20) UNIQUE NOT NULL,
        Prefix NVARCHAR(10) NOT NULL DEFAULT 'BR',
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME2 DEFAULT GETDATE()
    );
    PRINT 'Created table: Branches';
    
    -- Insert default branch if none exist
    INSERT INTO Branches (BranchName, BranchCode, Prefix, IsActive)
    VALUES ('Main Branch', 'MAIN', 'MB', 1);
    PRINT 'Inserted default branch';
END

-- Ensure ExpenseCategories exists
IF OBJECT_ID('dbo.ExpenseCategories', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ExpenseCategories (
        CategoryID INT IDENTITY(1,1) PRIMARY KEY,
        CategoryName NVARCHAR(100) NOT NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME2 DEFAULT GETDATE()
    );
    PRINT 'Created table: ExpenseCategories';
    
    -- Insert default categories
    INSERT INTO ExpenseCategories (CategoryName, IsActive)
    VALUES 
        ('Office Supplies', 1),
        ('Transport/Fuel', 1),
        ('Refreshments', 1),
        ('Postage', 1),
        ('Cleaning', 1),
        ('Repairs & Maintenance', 1),
        ('Sundry Expenses', 1);
    PRINT 'Inserted default expense categories';
END

-- Ensure JournalHeaders exists
IF OBJECT_ID('dbo.JournalHeaders', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.JournalHeaders (
        JournalID INT IDENTITY(1,1) PRIMARY KEY,
        JournalNumber NVARCHAR(50) NOT NULL UNIQUE,
        BranchID INT NULL,
        JournalDate DATE NOT NULL,
        Reference NVARCHAR(100),
        Description NVARCHAR(500),
        IsPosted BIT NOT NULL DEFAULT 0,
        CreatedBy INT,
        CreatedDate DATETIME2 DEFAULT GETDATE(),
        PostedBy INT,
        PostedDate DATETIME2
    );
    PRINT 'Created table: JournalHeaders';
END

GO

-- =============================================
-- 1. CashBooks Table
-- =============================================
IF OBJECT_ID('dbo.CashBooks', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CashBooks (
        CashBookID INT IDENTITY(1,1) PRIMARY KEY,
        CashBookCode NVARCHAR(20) NOT NULL UNIQUE,
        CashBookName NVARCHAR(100) NOT NULL,
        CashBookType NVARCHAR(20) NOT NULL, -- Main, Petty, Sundries, Bank
        GLAccountID INT NOT NULL, -- Link to ChartOfAccounts
        BranchID INT NOT NULL,
        CurrentBalance DECIMAL(18,2) NOT NULL DEFAULT 0,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedBy INT,
        CreatedDate DATETIME2 DEFAULT GETDATE(),
        ModifiedBy INT,
        ModifiedDate DATETIME2,
        CONSTRAINT FK_CashBooks_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
        CONSTRAINT FK_CashBooks_GLAccount FOREIGN KEY (GLAccountID) REFERENCES ChartOfAccounts(AccountID),
        CONSTRAINT CK_CashBooks_Type CHECK (CashBookType IN ('Main', 'Petty', 'Sundries', 'Bank'))
    );
    
    CREATE INDEX IX_CashBooks_Branch ON dbo.CashBooks(BranchID);
    CREATE INDEX IX_CashBooks_Type ON dbo.CashBooks(CashBookType);
    
    PRINT 'Created table: CashBooks';
END
ELSE
BEGIN
    PRINT 'Table CashBooks already exists';
END
GO

-- =============================================
-- 2. CashBookTransactions Table
-- =============================================
IF OBJECT_ID('dbo.CashBookTransactions', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CashBookTransactions (
        TransactionID INT IDENTITY(1,1) PRIMARY KEY,
        CashBookID INT NOT NULL,
        TransactionDate DATE NOT NULL,
        TransactionType NVARCHAR(20) NOT NULL, -- Receipt, Payment
        ReferenceNumber NVARCHAR(50),
        Payee NVARCHAR(200),
        Description NVARCHAR(500),
        Amount DECIMAL(18,2) NOT NULL,
        CategoryID INT, -- Link to expense categories
        GLAccountID INT, -- Contra account
        PaymentMethod NVARCHAR(50), -- Cash, Card, EFT, Cheque
        VoucherNumber NVARCHAR(50),
        AuthorizedBy INT,
        Notes NVARCHAR(1000),
        JournalID INT, -- Link to posted journal
        IsPosted BIT DEFAULT 0,
        IsVoid BIT DEFAULT 0,
        VoidReason NVARCHAR(500),
        VoidedBy INT,
        VoidedDate DATETIME2,
        CreatedBy INT,
        CreatedDate DATETIME2 DEFAULT GETDATE(),
        ModifiedBy INT,
        ModifiedDate DATETIME2,
        CONSTRAINT FK_CashBookTrans_CashBook FOREIGN KEY (CashBookID) REFERENCES CashBooks(CashBookID),
        CONSTRAINT FK_CashBookTrans_Category FOREIGN KEY (CategoryID) REFERENCES ExpenseCategories(CategoryID),
        CONSTRAINT FK_CashBookTrans_GLAccount FOREIGN KEY (GLAccountID) REFERENCES ChartOfAccounts(AccountID),
        CONSTRAINT FK_CashBookTrans_Journal FOREIGN KEY (JournalID) REFERENCES JournalHeaders(JournalID),
        CONSTRAINT CK_CashBookTrans_Type CHECK (TransactionType IN ('Receipt', 'Payment')),
        CONSTRAINT CK_CashBookTrans_Amount CHECK (Amount > 0)
    );
    
    CREATE INDEX IX_CashBookTrans_CashBook ON dbo.CashBookTransactions(CashBookID);
    CREATE INDEX IX_CashBookTrans_Date ON dbo.CashBookTransactions(TransactionDate);
    CREATE INDEX IX_CashBookTrans_Type ON dbo.CashBookTransactions(TransactionType);
    CREATE INDEX IX_CashBookTrans_Posted ON dbo.CashBookTransactions(IsPosted);
    
    PRINT 'Created table: CashBookTransactions';
END
ELSE
BEGIN
    PRINT 'Table CashBookTransactions already exists';
END
GO

-- =============================================
-- 3. CashBookReconciliation Table
-- =============================================
IF OBJECT_ID('dbo.CashBookReconciliation', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CashBookReconciliation (
        ReconciliationID INT IDENTITY(1,1) PRIMARY KEY,
        CashBookID INT NOT NULL,
        ReconciliationDate DATE NOT NULL,
        OpeningBalance DECIMAL(18,2) NOT NULL,
        TotalReceipts DECIMAL(18,2) NOT NULL DEFAULT 0,
        TotalPayments DECIMAL(18,2) NOT NULL DEFAULT 0,
        ExpectedClosing DECIMAL(18,2) NOT NULL,
        ActualCount DECIMAL(18,2) NOT NULL,
        Variance DECIMAL(18,2) NOT NULL,
        VarianceReason NVARCHAR(500),
        ReconciledBy INT,
        ReconciledDate DATETIME2,
        IsApproved BIT DEFAULT 0,
        ApprovedBy INT,
        ApprovedDate DATETIME2,
        Notes NVARCHAR(1000),
        JournalID INT, -- For variance posting
        CONSTRAINT FK_CashBookRecon_CashBook FOREIGN KEY (CashBookID) REFERENCES CashBooks(CashBookID),
        CONSTRAINT FK_CashBookRecon_Journal FOREIGN KEY (JournalID) REFERENCES JournalHeaders(JournalID)
    );
    
    CREATE INDEX IX_CashBookRecon_CashBook ON dbo.CashBookReconciliation(CashBookID);
    CREATE INDEX IX_CashBookRecon_Date ON dbo.CashBookReconciliation(ReconciliationDate);
    
    PRINT 'Created table: CashBookReconciliation';
END
ELSE
BEGIN
    PRINT 'Table CashBookReconciliation already exists';
END
GO

-- =============================================
-- 4. PettyCashVouchers Table (Additional detail for petty cash)
-- =============================================
IF OBJECT_ID('dbo.PettyCashVouchers', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.PettyCashVouchers (
        VoucherID INT IDENTITY(1,1) PRIMARY KEY,
        TransactionID INT NOT NULL, -- Link to CashBookTransactions
        VoucherNumber NVARCHAR(50) NOT NULL UNIQUE,
        VoucherDate DATE NOT NULL,
        Payee NVARCHAR(200) NOT NULL,
        Amount DECIMAL(18,2) NOT NULL,
        Purpose NVARCHAR(500) NOT NULL,
        CategoryID INT,
        ReceiptAttached BIT DEFAULT 0,
        ReceiptFilePath NVARCHAR(500),
        AuthorizedBy INT,
        AuthorizedDate DATETIME2,
        CreatedBy INT,
        CreatedDate DATETIME2 DEFAULT GETDATE(),
        CONSTRAINT FK_PettyCashVoucher_Transaction FOREIGN KEY (TransactionID) REFERENCES CashBookTransactions(TransactionID),
        CONSTRAINT FK_PettyCashVoucher_Category FOREIGN KEY (CategoryID) REFERENCES ExpenseCategories(CategoryID)
    );
    
    CREATE INDEX IX_PettyCashVoucher_Date ON dbo.PettyCashVouchers(VoucherDate);
    CREATE INDEX IX_PettyCashVoucher_Transaction ON dbo.PettyCashVouchers(TransactionID);
    
    PRINT 'Created table: PettyCashVouchers';
END
ELSE
BEGIN
    PRINT 'Table PettyCashVouchers already exists';
END
GO

-- =============================================
-- 5. Insert Default Cash Books
-- =============================================

-- Ensure Cash Over/Short account exists
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5900')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('5900', 'Cash Over/Short', 'Expense', 1);
    PRINT 'Created account: Cash Over/Short';
END

-- Get account IDs
DECLARE @MainCashAcctID INT = (SELECT AccountID FROM ChartOfAccounts WHERE AccountCode = '1020' OR AccountName = 'Cash on Hand');
DECLARE @PettyCashAcctID INT = (SELECT AccountID FROM ChartOfAccounts WHERE AccountCode = '1025' OR AccountName = 'Petty Cash');
DECLARE @SundriesAcctID INT = (SELECT AccountID FROM ChartOfAccounts WHERE AccountCode = '1028' OR AccountName = 'Sundries Cash');

-- Create accounts if they don't exist
IF @MainCashAcctID IS NULL
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('1020', 'Cash on Hand', 'Asset', 1);
    SET @MainCashAcctID = SCOPE_IDENTITY();
    PRINT 'Created account: Cash on Hand';
END

IF @PettyCashAcctID IS NULL
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('1025', 'Petty Cash', 'Asset', 1);
    SET @PettyCashAcctID = SCOPE_IDENTITY();
    PRINT 'Created account: Petty Cash';
END

IF @SundriesAcctID IS NULL
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('1028', 'Sundries Cash', 'Asset', 1);
    SET @SundriesAcctID = SCOPE_IDENTITY();
    PRINT 'Created account: Sundries Cash';
END

-- Create default cash books for each branch
DECLARE @BranchID INT;
DECLARE branch_cursor CURSOR FOR 
    SELECT BranchID FROM Branches WHERE IsActive = 1;

OPEN branch_cursor;
FETCH NEXT FROM branch_cursor INTO @BranchID;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Main Cash Book
    IF NOT EXISTS (SELECT 1 FROM CashBooks WHERE CashBookCode = 'MAIN-' + CAST(@BranchID AS NVARCHAR) AND BranchID = @BranchID)
    BEGIN
        INSERT INTO CashBooks (CashBookCode, CashBookName, CashBookType, GLAccountID, BranchID, CurrentBalance, IsActive, CreatedDate)
        VALUES ('MAIN-' + CAST(@BranchID AS NVARCHAR), 'Main Cash Book', 'Main', @MainCashAcctID, @BranchID, 0, 1, GETDATE());
        PRINT 'Created Main Cash Book for Branch ' + CAST(@BranchID AS NVARCHAR);
    END
    
    -- Petty Cash Book
    IF NOT EXISTS (SELECT 1 FROM CashBooks WHERE CashBookCode = 'PETTY-' + CAST(@BranchID AS NVARCHAR) AND BranchID = @BranchID)
    BEGIN
        INSERT INTO CashBooks (CashBookCode, CashBookName, CashBookType, GLAccountID, BranchID, CurrentBalance, IsActive, CreatedDate)
        VALUES ('PETTY-' + CAST(@BranchID AS NVARCHAR), 'Petty Cash Book', 'Petty', @PettyCashAcctID, @BranchID, 0, 1, GETDATE());
        PRINT 'Created Petty Cash Book for Branch ' + CAST(@BranchID AS NVARCHAR);
    END
    
    -- Sundries Cash Book
    IF NOT EXISTS (SELECT 1 FROM CashBooks WHERE CashBookCode = 'SUNDRY-' + CAST(@BranchID AS NVARCHAR) AND BranchID = @BranchID)
    BEGIN
        INSERT INTO CashBooks (CashBookCode, CashBookName, CashBookType, GLAccountID, BranchID, CurrentBalance, IsActive, CreatedDate)
        VALUES ('SUNDRY-' + CAST(@BranchID AS NVARCHAR), 'Sundries Cash Book', 'Sundries', @SundriesAcctID, @BranchID, 0, 1, GETDATE());
        PRINT 'Created Sundries Cash Book for Branch ' + CAST(@BranchID AS NVARCHAR);
    END
    
    FETCH NEXT FROM branch_cursor INTO @BranchID;
END

CLOSE branch_cursor;
DEALLOCATE branch_cursor;

PRINT '';
PRINT '=============================================';
PRINT 'Cash Book Schema Created Successfully';
PRINT '=============================================';
PRINT 'Tables: CashBooks, CashBookTransactions, CashBookReconciliation, PettyCashVouchers';
PRINT 'Default cash books created for all active branches';
PRINT '=============================================';
GO
