-- =============================================
-- MINIMAL GL INFRASTRUCTURE SETUP
-- Creates only the essential tables and procedures needed for GL integration
-- =============================================

PRINT '========================================';
PRINT 'SETTING UP MINIMAL GL INFRASTRUCTURE';
PRINT '========================================';
PRINT '';

-- =============================================
-- 1. Create ChartOfAccounts table if not exists
-- =============================================
IF OBJECT_ID('dbo.ChartOfAccounts', 'U') IS NULL
BEGIN
    PRINT 'Creating ChartOfAccounts table...';
    
    CREATE TABLE dbo.ChartOfAccounts (
        AccountID INT IDENTITY(1,1) PRIMARY KEY,
        AccountCode NVARCHAR(20) NOT NULL UNIQUE,
        AccountName NVARCHAR(200) NOT NULL,
        AccountType NVARCHAR(50) NOT NULL, -- Asset, Liability, Equity, Revenue, Expense
        ParentAccountID INT NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedBy INT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        FOREIGN KEY (ParentAccountID) REFERENCES ChartOfAccounts(AccountID)
    );
    
    PRINT '✓ ChartOfAccounts table created';
END
ELSE
BEGIN
    PRINT '  ChartOfAccounts table already exists';
END
GO

-- =============================================
-- 2. Create Journals table if not exists
-- =============================================
IF OBJECT_ID('dbo.Journals', 'U') IS NULL
BEGIN
    PRINT 'Creating Journals table...';
    
    CREATE TABLE dbo.Journals (
        JournalID INT IDENTITY(1,1) PRIMARY KEY,
        JournalDate DATE NOT NULL,
        JournalNumber NVARCHAR(50) NULL,
        Reference NVARCHAR(50) NULL,
        Description NVARCHAR(255) NULL,
        FiscalPeriodID INT NULL,
        BranchID INT NULL,
        CreatedBy INT NOT NULL,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
        PostedBy INT NULL,
        PostedAt DATETIME NULL,
        PostedFlag BIT NOT NULL DEFAULT 0
    );
    
    PRINT '✓ Journals table created';
END
ELSE
BEGIN
    PRINT '  Journals table already exists';
END
GO

-- =============================================
-- 3. Create JournalDetails table if not exists
-- =============================================
IF OBJECT_ID('dbo.JournalDetails', 'U') IS NULL
BEGIN
    PRINT 'Creating JournalDetails table...';
    
    CREATE TABLE dbo.JournalDetails (
        JournalDetailID INT IDENTITY(1,1) PRIMARY KEY,
        JournalID INT NOT NULL,
        LineNumber INT NOT NULL,
        AccountID INT NOT NULL,
        Debit DECIMAL(18,2) NOT NULL DEFAULT 0,
        Credit DECIMAL(18,2) NOT NULL DEFAULT 0,
        Description NVARCHAR(255) NULL,
        FOREIGN KEY (JournalID) REFERENCES Journals(JournalID),
        FOREIGN KEY (AccountID) REFERENCES ChartOfAccounts(AccountID)
    );
    
    PRINT '✓ JournalDetails table created';
END
ELSE
BEGIN
    PRINT '  JournalDetails table already exists';
END
GO

-- =============================================
-- 4. Create sp_CreateJournalEntry
-- =============================================
IF OBJECT_ID('dbo.sp_CreateJournalEntry', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_CreateJournalEntry;
GO

CREATE PROCEDURE dbo.sp_CreateJournalEntry
    @JournalDate DATE,
    @Reference NVARCHAR(50) = NULL,
    @Description NVARCHAR(255) = NULL,
    @FiscalPeriodID INT = NULL,
    @BranchID INT = NULL,
    @CreatedBy INT,
    @JournalID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO dbo.Journals (
        JournalDate, 
        JournalNumber, 
        Reference, 
        Description, 
        FiscalPeriodID, 
        BranchID, 
        CreatedBy, 
        CreatedAt, 
        PostedBy, 
        PostedAt, 
        PostedFlag
    )
    VALUES (
        @JournalDate, 
        NULL, 
        @Reference, 
        @Description, 
        @FiscalPeriodID, 
        @BranchID, 
        @CreatedBy, 
        GETDATE(), 
        NULL, 
        NULL, 
        0
    );
    
    SET @JournalID = SCOPE_IDENTITY();
END
GO

PRINT '✓ Created sp_CreateJournalEntry';
GO

-- =============================================
-- 5. Create sp_AddJournalDetail
-- =============================================
IF OBJECT_ID('dbo.sp_AddJournalDetail', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_AddJournalDetail;
GO

CREATE PROCEDURE dbo.sp_AddJournalDetail
    @JournalID INT,
    @AccountID INT,
    @Debit DECIMAL(18,2) = 0,
    @Credit DECIMAL(18,2) = 0,
    @Description NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @LineNumber INT;
    
    SELECT @LineNumber = ISNULL(MAX(LineNumber), 0) + 1
    FROM dbo.JournalDetails
    WHERE JournalID = @JournalID;
    
    INSERT INTO dbo.JournalDetails (
        JournalID, 
        LineNumber, 
        AccountID, 
        Debit, 
        Credit, 
        Description
    )
    VALUES (
        @JournalID, 
        @LineNumber, 
        @AccountID, 
        @Debit, 
        @Credit, 
        @Description
    );
END
GO

PRINT '✓ Created sp_AddJournalDetail';
GO

-- =============================================
-- 6. Create sp_PostJournal
-- =============================================
IF OBJECT_ID('dbo.sp_PostJournal', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_PostJournal;
GO

CREATE PROCEDURE dbo.sp_PostJournal
    @JournalID INT,
    @PostedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE dbo.Journals
    SET PostedFlag = 1,
        PostedBy = @PostedBy,
        PostedAt = GETDATE()
    WHERE JournalID = @JournalID;
END
GO

PRINT '✓ Created sp_PostJournal';
GO

-- =============================================
-- 7. Create sp_GetJournalEntryDetail
-- =============================================
IF OBJECT_ID('dbo.sp_GetJournalEntryDetail', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetJournalEntryDetail;
GO

CREATE PROCEDURE dbo.sp_GetJournalEntryDetail
    @JournalID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        j.JournalID,
        j.JournalDate,
        j.JournalNumber,
        j.Reference,
        j.Description AS JournalDescription,
        j.PostedFlag,
        j.PostedBy,
        j.PostedAt,
        jd.JournalDetailID,
        jd.LineNumber,
        jd.AccountID,
        coa.AccountCode,
        coa.AccountName,
        jd.Debit,
        jd.Credit,
        jd.Description AS LineDescription
    FROM Journals j
    INNER JOIN JournalDetails jd ON j.JournalID = jd.JournalID
    INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
    WHERE j.JournalID = @JournalID
    ORDER BY jd.LineNumber;
END
GO

PRINT '✓ Created sp_GetJournalEntryDetail';
GO

-- =============================================
-- 8. Create sp_GetAccountLedger
-- =============================================
IF OBJECT_ID('dbo.sp_GetAccountLedger', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetAccountLedger;
GO

CREATE PROCEDURE dbo.sp_GetAccountLedger
    @AccountID INT,
    @FromDate DATE = NULL,
    @ToDate DATE = NULL,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get account details
    DECLARE @AccountCode NVARCHAR(20);
    DECLARE @AccountName NVARCHAR(200);
    
    SELECT @AccountCode = AccountCode, @AccountName = AccountName
    FROM ChartOfAccounts
    WHERE AccountID = @AccountID;
    
    -- Calculate opening balance (transactions before FromDate)
    DECLARE @OpeningBalance DECIMAL(18,2) = 0;
    
    IF @FromDate IS NOT NULL
    BEGIN
        SELECT @OpeningBalance = ISNULL(SUM(jd.Debit - jd.Credit), 0)
        FROM JournalDetails jd
        INNER JOIN Journals j ON jd.JournalID = j.JournalID
        WHERE jd.AccountID = @AccountID
          AND j.PostedFlag = 1
          AND j.JournalDate < @FromDate
          AND (@BranchID IS NULL OR j.BranchID = @BranchID);
    END
    
    -- Get transactions
    SELECT 
        j.JournalDate AS Date,
        j.JournalNumber AS [Journal #],
        j.Reference,
        jd.Description,
        jd.Debit,
        jd.Credit,
        @OpeningBalance + SUM(jd.Debit - jd.Credit) OVER (ORDER BY j.JournalDate, j.JournalID, jd.LineNumber) AS Balance,
        j.BranchID AS BranchID
    FROM JournalDetails jd
    INNER JOIN Journals j ON jd.JournalID = j.JournalID
    WHERE jd.AccountID = @AccountID
      AND j.PostedFlag = 1
      AND (@FromDate IS NULL OR j.JournalDate >= @FromDate)
      AND (@ToDate IS NULL OR j.JournalDate <= @ToDate)
      AND (@BranchID IS NULL OR j.BranchID = @BranchID)
    ORDER BY j.JournalDate, j.JournalID, jd.LineNumber;
END
GO

PRINT '✓ Created sp_GetAccountLedger';
GO

-- =============================================
-- 9. Insert Essential Accounts
-- =============================================
PRINT '';
PRINT 'Inserting essential Chart of Accounts...';

-- Cash
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1100')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, CreatedBy, CreatedDate)
    VALUES ('1100', 'Cash', 'Asset', 1, 1, GETDATE());
    PRINT '  ✓ 1100 - Cash';
END

-- Accounts Receivable
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1200')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, CreatedBy, CreatedDate)
    VALUES ('1200', 'Accounts Receivable', 'Asset', 1, 1, GETDATE());
    PRINT '  ✓ 1200 - Accounts Receivable';
END

-- Raw Materials Inventory
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1400')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, CreatedBy, CreatedDate)
    VALUES ('1400', 'Raw Materials Inventory', 'Asset', 1, 1, GETDATE());
    PRINT '  ✓ 1400 - Raw Materials Inventory';
END

-- Manufacturing Inventory (WIP)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1410')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, CreatedBy, CreatedDate)
    VALUES ('1410', 'Manufacturing Inventory (WIP)', 'Asset', 1, 1, GETDATE());
    PRINT '  ✓ 1410 - Manufacturing Inventory (WIP)';
END

-- Finished Goods Inventory
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1420')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, CreatedBy, CreatedDate)
    VALUES ('1420', 'Finished Goods Inventory', 'Asset', 1, 1, GETDATE());
    PRINT '  ✓ 1420 - Finished Goods Inventory';
END

-- Sales Revenue
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4000')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, CreatedBy, CreatedDate)
    VALUES ('4000', 'Sales Revenue', 'Revenue', 1, 1, GETDATE());
    PRINT '  ✓ 4000 - Sales Revenue';
END

-- Cost of Sales
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5000')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, CreatedBy, CreatedDate)
    VALUES ('5000', 'Cost of Sales', 'Expense', 1, 1, GETDATE());
    PRINT '  ✓ 5000 - Cost of Sales';
END

PRINT '';
PRINT '========================================';
PRINT 'MINIMAL GL INFRASTRUCTURE SETUP COMPLETE';
PRINT '========================================';
PRINT '';
PRINT 'Tables Created:';
PRINT '  - ChartOfAccounts';
PRINT '  - Journals';
PRINT '  - JournalDetails';
PRINT '';
PRINT 'Procedures Created:';
PRINT '  - sp_CreateJournalEntry';
PRINT '  - sp_AddJournalDetail';
PRINT '  - sp_PostJournal';
PRINT '  - sp_GetJournalEntryDetail';
PRINT '  - sp_GetAccountLedger';
PRINT '';
PRINT 'Accounts Created:';
PRINT '  - 1100: Cash';
PRINT '  - 1200: Accounts Receivable';
PRINT '  - 1400: Raw Materials Inventory';
PRINT '  - 1410: Manufacturing Inventory (WIP)';
PRINT '  - 1420: Finished Goods Inventory';
PRINT '  - 4000: Sales Revenue';
PRINT '  - 5000: Cost of Sales';
PRINT '';
PRINT 'You can now run the GL integration stored procedures.';
PRINT '========================================';
GO
