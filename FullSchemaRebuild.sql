-- ABSOLUTE CLEAN SLATE: Explicitly drop stubborn tables in all schemas if they exist
IF OBJECT_ID('dbo.DocumentNumbering', 'U') IS NOT NULL DROP TABLE dbo.DocumentNumbering;
IF OBJECT_ID('DocumentNumbering', 'U') IS NOT NULL DROP TABLE DocumentNumbering;
IF OBJECT_ID('dbo.JournalDetails', 'U') IS NOT NULL DROP TABLE dbo.JournalDetails;
IF OBJECT_ID('JournalDetails', 'U') IS NOT NULL DROP TABLE JournalDetails;

-- DROP ALL FOREIGN KEYS, THEN ALL TABLES, VIEWS, FUNCTIONS, PROCEDURES (FULL CLEAN)

-- Drop Foreign Keys (including self-referencing and all dependencies, robust)
DECLARE @fk_sql NVARCHAR(MAX) = N'';
SELECT @fk_sql = @fk_sql + 'ALTER TABLE [' + SCHEMA_NAME(t.schema_id) + '].[' + t.name + '] DROP CONSTRAINT [' + fk.name + '];' + CHAR(13)+CHAR(10)
FROM sys.foreign_keys fk
JOIN sys.tables t ON fk.parent_object_id = t.object_id;
IF LEN(@fk_sql) > 0 EXEC sp_executesql @fk_sql;

-- Drop Tables (user-defined only)
DECLARE @tbl_sql NVARCHAR(MAX) = N'';
SELECT @tbl_sql = @tbl_sql + 'DROP TABLE [' + SCHEMA_NAME(schema_id) + '].[' + name + '];' + CHAR(13)+CHAR(10)
FROM sys.tables WHERE is_ms_shipped = 0;
IF LEN(@tbl_sql) > 0 EXEC sp_executesql @tbl_sql;

-- Drop Views (user-defined only)
DECLARE @vw_sql NVARCHAR(MAX) = N'';
SELECT @vw_sql = @vw_sql + 'DROP VIEW [' + SCHEMA_NAME(schema_id) + '].[' + name + '];' + CHAR(13)+CHAR(10)
FROM sys.views WHERE is_ms_shipped = 0;
IF LEN(@vw_sql) > 0 EXEC sp_executesql @vw_sql;

-- Drop Procedures
DECLARE @proc_sql NVARCHAR(MAX) = N'';
SELECT @proc_sql = @proc_sql + 'DROP PROCEDURE [' + SCHEMA_NAME(schema_id) + '].[' + name + '];' + CHAR(13)+CHAR(10)
FROM sys.procedures;
IF LEN(@proc_sql) > 0 EXEC sp_executesql @proc_sql;

-- Drop Functions
DECLARE @fn_sql NVARCHAR(MAX) = N'';
SELECT @fn_sql = @fn_sql + 'DROP FUNCTION [' + SCHEMA_NAME(schema_id) + '].[' + name + '];' + CHAR(13)+CHAR(10)
FROM sys.objects WHERE type IN ('FN','IF','TF');
IF LEN(@fn_sql) > 0 EXEC sp_executesql @fn_sql;

-- ABSOLUTE CLEAN SLATE: Explicitly drop stubborn tables in all schemas if they exist
IF OBJECT_ID('dbo.DocumentNumbering', 'U') IS NOT NULL DROP TABLE dbo.DocumentNumbering;
IF OBJECT_ID('DocumentNumbering', 'U') IS NOT NULL DROP TABLE DocumentNumbering;
IF OBJECT_ID('dbo.JournalDetails', 'U') IS NOT NULL DROP TABLE dbo.JournalDetails;
IF OBJECT_ID('JournalDetails', 'U') IS NOT NULL DROP TABLE JournalDetails;

-- COMPREHENSIVE USER MANAGEMENT SYSTEM DATABASE SCHEMA

-- USERS TABLE (CREATE FIRST)
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    Email NVARCHAR(128) NOT NULL UNIQUE,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    RoleID INT NOT NULL,
    BranchID INT NULL,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    LastLogin DATETIME NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    FailedLoginAttempts INT NOT NULL DEFAULT 0,
    LastFailedLogin DATETIME NULL,
    PasswordLastChanged DATETIME NULL,
    TwoFactorEnabled BIT NOT NULL DEFAULT 0
);

-- ROLES TABLE
CREATE TABLE Roles (
    RoleID INT PRIMARY KEY IDENTITY(1,1),
    RoleName NVARCHAR(50) NOT NULL UNIQUE
);

-- BRANCHES TABLE
CREATE TABLE Branches (
    ID INT PRIMARY KEY IDENTITY(1,1),
    BranchName NVARCHAR(100) NOT NULL,
    Prefix NVARCHAR(10) NOT NULL
);

-- Add other user/admin tables as needed...

PRINT 'Comprehensive User Management System database schema created successfully!';

GO

-- SAGE TABLES (CREATE AFTER USER/ADMIN TABLES)

-- Explicitly drop stubborn tables if they exist
IF OBJECT_ID('dbo.DocumentNumbering', 'U') IS NOT NULL DROP TABLE dbo.DocumentNumbering;
IF OBJECT_ID('dbo.JournalDetails', 'U') IS NOT NULL DROP TABLE dbo.JournalDetails;

CREATE TABLE DocumentNumbering (
    DocumentType VARCHAR(20) PRIMARY KEY,
    Prefix VARCHAR(10) NOT NULL,
    NextNumber INT NOT NULL DEFAULT 1,
    NumberLength INT NOT NULL DEFAULT 6,
    BranchSpecific BIT DEFAULT 1,
    LastUsedNumber VARCHAR(50) NULL,
    LastUsedDate DATETIME NULL,
    ModifiedDate DATETIME DEFAULT GETDATE(),
    ModifiedBy INT NULL
);

CREATE TABLE GLAccounts (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    AccountNumber VARCHAR(20) NOT NULL UNIQUE,
    AccountName NVARCHAR(100) NOT NULL,
    AccountType VARCHAR(20) NOT NULL,
    BalanceType CHAR(1) NOT NULL,
    ParentAccountID INT NULL,
    IsSystem BIT DEFAULT 0,
    IsActive BIT DEFAULT 1,
    OpeningBalance DECIMAL(18,2) DEFAULT 0
    -- FOREIGN KEY (ParentAccountID) REFERENCES GLAccounts(AccountID) -- defer until after insert
);

CREATE TABLE FiscalPeriods (
    PeriodID INT PRIMARY KEY IDENTITY(1,1),
    PeriodName NVARCHAR(50) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    IsClosed BIT DEFAULT 0,
    ClosedDate DATETIME NULL,
    ClosedBy INT NULL,
    CONSTRAINT CHK_ValidPeriod CHECK (EndDate > StartDate)
);
-- Add FK to Users after both tables exist
-- (defer FK creation until after Users is created)

-- Add all FKs referencing Users after all tables exist
ALTER TABLE FiscalPeriods
ADD CONSTRAINT FK_FiscalPeriods_ClosedBy FOREIGN KEY (ClosedBy) REFERENCES Users(UserID);

ALTER TABLE DocumentNumbering
ADD CONSTRAINT FK_DocumentNumbering_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID);


-- SAGE STORED PROCEDURES, FUNCTIONS, AND INITIAL DATA

-- 2. Create JournalHeaders before JournalDetails, then JournalDetails
CREATE TABLE JournalHeaders (
    JournalID INT PRIMARY KEY IDENTITY(1,1),
    JournalNumber VARCHAR(20) NOT NULL,
    JournalDate DATE NOT NULL,
    Reference NVARCHAR(50) NULL,
    Description NVARCHAR(255) NULL,
    FiscalPeriodID INT NOT NULL,
    CreatedBy INT NOT NULL,
    BranchID INT NOT NULL,
    IsPosted BIT DEFAULT 0,
    PostedDate DATETIME NULL,
    PostedBy INT NULL
    -- add FKs after all tables exist
);

CREATE TABLE JournalDetails (
    JournalDetailID INT PRIMARY KEY IDENTITY(1,1),
    JournalID INT NOT NULL,
    LineNumber INT NOT NULL,
    AccountID INT NOT NULL,
    Debit DECIMAL(18,2) DEFAULT 0,
    Credit DECIMAL(18,2) DEFAULT 0,
    Description NVARCHAR(255) NULL,
    Reference1 NVARCHAR(50) NULL,
    Reference2 NVARCHAR(50) NULL,
    CostCenterID INT NULL,
    ProjectID INT NULL
    -- add FKs after all tables exist
);
-- Create indexes for JournalDetails immediately after table creation
CREATE NONCLUSTERED INDEX IX_JournalDetails_AccountID ON JournalDetails(AccountID);

-- Now add FKs for JournalHeaders and JournalDetails
ALTER TABLE JournalHeaders
ADD CONSTRAINT FK_JournalHeaders_FiscalPeriodID FOREIGN KEY (FiscalPeriodID) REFERENCES FiscalPeriods(PeriodID),
    CONSTRAINT FK_JournalHeaders_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    CONSTRAINT FK_JournalHeaders_BranchID FOREIGN KEY (BranchID) REFERENCES Branches(ID),
    CONSTRAINT FK_JournalHeaders_PostedBy FOREIGN KEY (PostedBy) REFERENCES Users(UserID);

ALTER TABLE JournalDetails
ADD CONSTRAINT FK_JournalDetails_JournalID FOREIGN KEY (JournalID) REFERENCES JournalHeaders(JournalID),
    CONSTRAINT FK_JournalDetails_AccountID FOREIGN KEY (AccountID) REFERENCES GLAccounts(AccountID);

GO
-- 1. Create Journal Entry
CREATE OR ALTER PROCEDURE sp_CreateJournalEntry
    @JournalDate DATE,
    @Reference NVARCHAR(50) = NULL,
    @Description NVARCHAR(255) = NULL,
    @FiscalPeriodID INT,
    @CreatedBy INT,
    @BranchID INT,
    @JournalID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @JournalNumber VARCHAR(20);
    DECLARE @NextNumber INT;
    BEGIN TRANSACTION;
    UPDATE DocumentNumbering WITH (TABLOCK)
    SET @NextNumber = NextNumber,
        @JournalNumber = Prefix + RIGHT('000000' + CAST(NextNumber AS VARCHAR(10)), NumberLength),
        NextNumber = NextNumber + 1,
        LastUsedNumber = Prefix + RIGHT('000000' + CAST(NextNumber AS VARCHAR(10)), NumberLength),
        LastUsedDate = GETDATE(),
        ModifiedDate = GETDATE(),
        ModifiedBy = @CreatedBy
    WHERE DocumentType = 'JN';
    INSERT INTO JournalHeaders (
        JournalNumber, JournalDate, Reference, Description, 
        FiscalPeriodID, CreatedBy, BranchID
    )
    VALUES (
        @JournalNumber, @JournalDate, @Reference, @Description,
        @FiscalPeriodID, @CreatedBy, @BranchID
    );
    SET @JournalID = SCOPE_IDENTITY();
    COMMIT TRANSACTION;
    -- Use OUTPUT param, not RETURN value
END
GO

-- 2. Add Journal Detail Line
CREATE OR ALTER PROCEDURE sp_AddJournalDetail
    @JournalID INT,
    @AccountID INT,
    @Debit DECIMAL(18,2) = 0,
    @Credit DECIMAL(18,2) = 0,
    @Description NVARCHAR(255) = NULL,
    @Reference1 NVARCHAR(50) = NULL,
    @Reference2 NVARCHAR(50) = NULL,
    @CostCenterID INT = NULL,
    @ProjectID INT = NULL,
    @LineNumber INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT @LineNumber = ISNULL(MAX(LineNumber), 0) + 1 
    FROM JournalDetails 
    WHERE JournalID = @JournalID;
    INSERT INTO JournalDetails (
        JournalID, LineNumber, AccountID, Debit, Credit,
        Description, Reference1, Reference2, CostCenterID, ProjectID
    )
    VALUES (
        @JournalID, @LineNumber, @AccountID, @Debit, @Credit,
        @Description, @Reference1, @Reference2, @CostCenterID, @ProjectID
    );
END
GO

-- 3. Post Journal
CREATE OR ALTER PROCEDURE sp_PostJournal
    @JournalID INT,
    @PostedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @FiscalPeriodID INT;
    DECLARE @BranchID INT;
    DECLARE @IsPosted BIT;
    SELECT 
        @FiscalPeriodID = FiscalPeriodID,
        @BranchID = BranchID,
        @IsPosted = IsPosted
    FROM JournalHeaders
    WHERE JournalID = @JournalID;
    IF @IsPosted = 1
    BEGIN
        RAISERROR('Journal has already been posted.', 16, 1);
        RETURN;
    END;
    IF EXISTS (SELECT 1 FROM FiscalPeriods WHERE PeriodID = @FiscalPeriodID AND IsClosed = 1)
    BEGIN
        RAISERROR('Cannot post to a closed fiscal period.', 16, 1);
        RETURN;
    END;
    IF NOT EXISTS (
        SELECT 1
        FROM (
            SELECT SUM(Debit) AS TotalDebit, SUM(Credit) AS TotalCredit
            FROM JournalDetails
            WHERE JournalID = @JournalID
        ) AS T
        WHERE TotalDebit = TotalCredit
    )
    BEGIN
        RAISERROR('Journal is not balanced. Debits must equal credits.', 16, 1);
        RETURN;
    END;
    BEGIN TRANSACTION;
    BEGIN TRY
        UPDATE JournalHeaders
        SET IsPosted = 1,
            PostedDate = GETDATE(),
            PostedBy = @PostedBy
        WHERE JournalID = @JournalID;
        MERGE AccountBalances AS target
        USING (
            SELECT 
                AccountID,
                SUM(Debit) AS Debit,
                SUM(Credit) AS Credit
            FROM JournalDetails
            WHERE JournalID = @JournalID
            GROUP BY AccountID
        ) AS source
        ON target.AccountID = source.AccountID 
           AND target.FiscalPeriodID = @FiscalPeriodID
           AND target.BranchID = @BranchID
        WHEN MATCHED THEN
            UPDATE SET 
                DebitTotal = target.DebitTotal + source.Debit,
                CreditTotal = target.CreditTotal + source.Credit,
                LastUpdated = GETDATE()
        WHEN NOT MATCHED THEN
            INSERT (AccountID, FiscalPeriodID, BranchID, DebitTotal, CreditTotal)
            VALUES (source.AccountID, @FiscalPeriodID, @BranchID, source.Debit, source.Credit);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END
GO

-- 4. Generate Trial Balance
CREATE OR ALTER PROCEDURE sp_GenerateTrialBalance
    @AsOfDate DATE = NULL,
    @BranchID INT = NULL,
    @IncludeZeroBalances BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    IF @AsOfDate IS NULL
        SET @AsOfDate = GETDATE();
    DECLARE @FiscalPeriodID INT;
    SELECT TOP 1 @FiscalPeriodID = PeriodID
    FROM FiscalPeriods
    WHERE @AsOfDate BETWEEN StartDate AND EndDate
    ORDER BY PeriodID DESC;
    IF @FiscalPeriodID IS NULL
    BEGIN
        RAISERROR('No fiscal period found for the specified date.', 16, 1);
        RETURN;
    END;
    SELECT 
        a.AccountNumber,
        a.AccountName,
        a.AccountType,
        ISNULL(ab.OpeningBalance, 0) AS OpeningBalance,
        ISNULL(ab.DebitTotal, 0) AS DebitTotal,
        ISNULL(ab.CreditTotal, 0) AS CreditTotal,
        CASE 
            WHEN a.BalanceType = 'D' THEN 
                ISNULL(ab.OpeningBalance, 0) + ISNULL(ab.DebitTotal, 0) - ISNULL(ab.CreditTotal, 0)
            ELSE
                ISNULL(ab.OpeningBalance, 0) + ISNULL(ab.CreditTotal, 0) - ISNULL(ab.DebitTotal, 0)
        END AS CurrentBalance
    FROM GLAccounts a
    LEFT JOIN AccountBalances ab ON a.AccountID = ab.AccountID 
        AND ab.FiscalPeriodID = @FiscalPeriodID
        AND (@BranchID IS NULL OR ab.BranchID = @BranchID)
    WHERE a.IsActive = 1
        AND (@IncludeZeroBalances = 1 OR 
             (ISNULL(ab.DebitTotal, 0) <> 0 OR ISNULL(ab.CreditTotal, 0) <> 0 OR 
              ISNULL(ab.OpeningBalance, 0) <> 0))
    ORDER BY a.AccountNumber;
END
GO

-- 5. Document Numbering Procedure (SQL Server-compliant)
GO
CREATE OR ALTER PROCEDURE sp_GetNextDocumentNumber
    @DocumentType VARCHAR(20),
    @BranchID INT = NULL,
    @UserID INT = NULL,
    @NextDocNumber VARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NextNumber INT;
    DECLARE @Prefix VARCHAR(20);
    DECLARE @NumberLength INT;
    DECLARE @BranchPrefix VARCHAR(10) = '';
    DECLARE @UserRoleCode VARCHAR(5) = '';
    IF @BranchID IS NOT NULL
    BEGIN
        SELECT @BranchPrefix = ISNULL(Prefix, '') + '-'
        FROM Branches 
        WHERE ID = @BranchID;
    END
    IF @UserID IS NOT NULL
    BEGIN
        SELECT @UserRoleCode = 
            CASE 
                WHEN r.RoleName = 'Super-Admin' THEN 'SA'
                WHEN r.RoleName = 'Admin' THEN 'A'
                WHEN r.RoleName = 'Stockroom-Manager' THEN 'SM'
                WHEN r.RoleName = 'Manufacturing-Manager' THEN 'MM'
                WHEN r.RoleName = 'Retail-Manager' THEN 'RM'
                ELSE ''
            END + '-'
        FROM Users u
        JOIN Roles r ON u.RoleID = r.RoleID
        WHERE u.UserID = @UserID;
    END
    UPDATE DocumentNumbering WITH (TABLOCK)
    SET @NextNumber = NextNumber,
        @Prefix = Prefix,
        @NumberLength = NumberLength,
        NextNumber = NextNumber + 1,
        LastUsedNumber = @BranchPrefix + @UserRoleCode + Prefix + RIGHT('000000' + CAST(NextNumber AS VARCHAR(10)), NumberLength),
        LastUsedDate = GETDATE(),
        ModifiedDate = GETDATE(),
        ModifiedBy = @UserID
    WHERE DocumentType = @DocumentType;
    SELECT @NextNumber = NextNumber, @Prefix = Prefix, @NumberLength = NumberLength FROM DocumentNumbering WHERE DocumentType = @DocumentType;
    SET @NextDocNumber = @BranchPrefix + @UserRoleCode + @Prefix + RIGHT('000000' + CAST(@NextNumber-1 AS VARCHAR(10)), @NumberLength);
END
GO

-- 6. Initial Data Inserts
DELETE FROM DocumentNumbering;
INSERT INTO DocumentNumbering (DocumentType, Prefix, NextNumber, NumberLength, BranchSpecific)
VALUES 
    ('JN', 'JN-', 1, 6, 0),
    ('PO', 'PO-', 1, 6, 1),
    ('INV', 'INV-', 1, 6, 1),
    ('PY', 'PY-', 1, 6, 1),
    ('RC', 'RC-', 1, 6, 1),
    ('CN', 'CN-', 1, 6, 1),
    ('DN', 'DN-', 1, 6, 1);

DECLARE @CurrentYear INT = YEAR(GETDATE());
DECLARE @StartDate DATE = DATEFROMPARTS(@CurrentYear, 1, 1);
DECLARE @EndDate DATE = DATEFROMPARTS(@CurrentYear, 12, 31);
INSERT INTO FiscalPeriods (PeriodName, StartDate, EndDate, IsClosed)
VALUES 
    (CONCAT('FY', @CurrentYear, ' Q1'), DATEFROMPARTS(@CurrentYear, 1, 1), DATEFROMPARTS(@CurrentYear, 3, 31), 0),
    (CONCAT('FY', @CurrentYear, ' Q2'), DATEFROMPARTS(@CurrentYear, 4, 1), DATEFROMPARTS(@CurrentYear, 6, 30), 0),
    (CONCAT('FY', @CurrentYear, ' Q3'), DATEFROMPARTS(@CurrentYear, 7, 1), DATEFROMPARTS(@CurrentYear, 9, 30), 0),
    (CONCAT('FY', @CurrentYear, ' Q4'), DATEFROMPARTS(@CurrentYear, 10, 1), DATEFROMPARTS(@CurrentYear, 12, 31), 0);

INSERT INTO GLAccounts (AccountNumber, AccountName, AccountType, BalanceType, IsSystem, IsActive)
VALUES 
    ('1000', 'Current Assets', 'Asset', 'D', 1, 1),
    ('1100', 'Bank Accounts', 'Asset', 'D', 1, 1),
    ('1200', 'Accounts Receivable', 'AR', 'D', 1, 1),
    ('1300', 'Inventory', 'Asset', 'D', 1, 1),
    ('2000', 'Current Liabilities', 'Liability', 'C', 1, 1),
    ('2100', 'Accounts Payable', 'AP', 'C', 1, 1),
    ('3000', 'Equity', 'Equity', 'C', 1, 1),
    ('4000', 'Revenue', 'Income', 'C', 1, 1),
    ('5000', 'Cost of Sales', 'Expense', 'D', 1, 1),
    ('6000', 'Operating Expenses', 'Expense', 'D', 1, 1);

-- Set ParentAccountID after all rows exist
UPDATE GLAccounts SET ParentAccountID = (SELECT AccountID FROM GLAccounts WHERE AccountNumber = '1000') WHERE AccountNumber IN ('1100', '1200', '1300');
UPDATE GLAccounts SET ParentAccountID = (SELECT AccountID FROM GLAccounts WHERE AccountNumber = '2000') WHERE AccountNumber = '2100';

-- Now add the self-referencing FK
ALTER TABLE GLAccounts
ADD CONSTRAINT FK_GLAccounts_ParentAccountID FOREIGN KEY (ParentAccountID) REFERENCES GLAccounts(AccountID);

-- Indexes
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_JournalDetails_AccountID')
    CREATE NONCLUSTERED INDEX IX_JournalDetails_AccountID ON JournalDetails(AccountID);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_JournalHeaders_Period_Branch')
    CREATE NONCLUSTERED INDEX IX_JournalHeaders_Period_Branch ON JournalHeaders(FiscalPeriodID, BranchID, IsPosted);

PRINT 'Full SAGE + ERP schema and procedures created!';
