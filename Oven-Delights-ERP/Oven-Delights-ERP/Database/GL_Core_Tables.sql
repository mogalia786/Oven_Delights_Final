-- Timestamp: 10-Sep-2025 07:37 SAST
-- GL Core Tables (idempotent)

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Accounts' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.Accounts (
        AccountID        INT IDENTITY(1,1) PRIMARY KEY,
        AccountCode      VARCHAR(32) NOT NULL UNIQUE,
        AccountName      VARCHAR(128) NOT NULL,
        AccountType      VARCHAR(32) NOT NULL, -- Asset, Liability, Equity, Revenue, Expense
        ParentAccountID  INT NULL,
        IsActive         BIT NOT NULL DEFAULT(1)
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Journals' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.Journals (
        JournalID     INT IDENTITY(1,1) PRIMARY KEY,
        JournalDate   DATE NOT NULL,
        JournalNumber VARCHAR(50) NULL,
        Reference     VARCHAR(100) NULL,
        Description   VARCHAR(256) NULL,
        FiscalPeriodID INT NULL,
        BranchID      INT NULL,
        CreatedBy     INT NULL,
        CreatedAt     DATETIME NOT NULL DEFAULT(GETDATE()),
        PostedBy      INT NULL,
        PostedAt      DATETIME NULL,
        PostedFlag    BIT NOT NULL DEFAULT(0)
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'JournalLines' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.JournalLines (
        JournalLineID INT IDENTITY(1,1) PRIMARY KEY,
        JournalID     INT NOT NULL,
        LineNumber    INT NOT NULL,
        AccountID     INT NOT NULL,
        Debit         DECIMAL(18,2) NOT NULL DEFAULT(0),
        Credit        DECIMAL(18,2) NOT NULL DEFAULT(0),
        LineDescription VARCHAR(256) NULL,
        Reference1    VARCHAR(100) NULL,
        Reference2    VARCHAR(100) NULL,
        CostCenterID  INT NULL,
        ProjectID     INT NULL,
        ClearedFlag   BIT NOT NULL DEFAULT(0),
        StatementRef  VARCHAR(100) NULL,
        CONSTRAINT FK_JournalLines_Journals FOREIGN KEY (JournalID) REFERENCES dbo.Journals(JournalID),
        CONSTRAINT FK_JournalLines_Accounts FOREIGN KEY (AccountID) REFERENCES dbo.Accounts(AccountID)
    );
    CREATE UNIQUE INDEX IX_JournalLines_UQ ON dbo.JournalLines(JournalID, LineNumber);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'SystemAccounts' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.SystemAccounts (
        SysKey    VARCHAR(64) NOT NULL PRIMARY KEY,
        AccountID INT NULL
    );
END
GO
