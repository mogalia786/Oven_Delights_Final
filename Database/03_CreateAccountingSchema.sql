-- =============================================
-- Accounting Core Schema (GL, Fiscal Periods, Journals)
-- Sage-style: segmented COA ready, period control, batch journals
-- =============================================
SET NOCOUNT ON;
GO

USE [Oven_Delights_Main];
GO

-- GLAccounts
IF OBJECT_ID('dbo.GLAccounts', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.GLAccounts (
        AccountID           INT IDENTITY(1,1) PRIMARY KEY,
        AccountNumber       VARCHAR(20) NOT NULL UNIQUE,
        AccountName         NVARCHAR(100) NOT NULL,
        AccountType         VARCHAR(20) NOT NULL,         -- Asset, Liability, Equity, Revenue, Expense
        BalanceType         CHAR(1) NOT NULL,             -- 'D' or 'C'
        ParentAccountID     INT NULL REFERENCES dbo.GLAccounts(AccountID),
        IsSystem            BIT NOT NULL DEFAULT(0),
        IsActive            BIT NOT NULL DEFAULT(1),
        OpeningBalance      DECIMAL(18,2) NOT NULL DEFAULT(0),
        CreatedDate         DATETIME NOT NULL DEFAULT(GETDATE()),
        CreatedBy           INT NULL,
        ModifiedDate        DATETIME NULL,
        ModifiedBy          INT NULL
    );
END
GO

-- FiscalPeriods
IF OBJECT_ID('dbo.FiscalPeriods', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.FiscalPeriods (
        PeriodID        INT IDENTITY(1,1) PRIMARY KEY,
        PeriodName      NVARCHAR(50) NOT NULL,
        StartDate       DATE NOT NULL,
        EndDate         DATE NOT NULL,
        IsClosed        BIT NOT NULL DEFAULT(0),
        ClosedDate      DATETIME NULL,
        ClosedBy        INT NULL
    );
    ALTER TABLE dbo.FiscalPeriods WITH CHECK ADD CONSTRAINT CK_FiscalPeriods_DateRange CHECK (StartDate <= EndDate);
END
GO

-- JournalHeaders
IF OBJECT_ID('dbo.JournalHeaders', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.JournalHeaders (
        JournalID       INT IDENTITY(1,1) PRIMARY KEY,
        JournalNumber   VARCHAR(20) NULL,
        JournalDate     DATE NOT NULL,
        Reference       NVARCHAR(50) NULL,
        Description     NVARCHAR(255) NULL,
        FiscalPeriodID  INT NOT NULL REFERENCES dbo.FiscalPeriods(PeriodID),
        CreatedBy       INT NOT NULL,
        BranchID        INT NOT NULL,
        IsPosted        BIT NOT NULL DEFAULT(0),
        PostedDate      DATETIME NULL,
        PostedBy        INT NULL,
        CreatedDate     DATETIME NOT NULL DEFAULT(GETDATE())
    );
END
GO

-- JournalDetails
IF OBJECT_ID('dbo.JournalDetails', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.JournalDetails (
        JournalDetailID INT IDENTITY(1,1) PRIMARY KEY,
        JournalID       INT NOT NULL REFERENCES dbo.JournalHeaders(JournalID) ON DELETE CASCADE,
        LineNumber      INT NOT NULL,
        AccountID       INT NOT NULL REFERENCES dbo.GLAccounts(AccountID),
        Debit           DECIMAL(18,2) NOT NULL DEFAULT(0),
        Credit          DECIMAL(18,2) NOT NULL DEFAULT(0),
        Description     NVARCHAR(255) NULL,
        Reference1      NVARCHAR(50) NULL,
        Reference2      NVARCHAR(50) NULL,
        CostCenterID    INT NULL,
        ProjectID       INT NULL
    );
    CREATE INDEX IX_JournalDetails_AccountID ON dbo.JournalDetails(AccountID);
END
GO

-- sp_CreateJournalEntry
IF OBJECT_ID('dbo.sp_CreateJournalEntry', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_CreateJournalEntry;
GO
CREATE PROCEDURE dbo.sp_CreateJournalEntry
    @JournalDate    DATE,
    @Reference      NVARCHAR(50) = NULL,
    @Description    NVARCHAR(255) = NULL,
    @FiscalPeriodID INT,
    @CreatedBy      INT,
    @BranchID       INT,
    @JournalID      INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.FiscalPeriods WHERE PeriodID = @FiscalPeriodID AND @JournalDate BETWEEN StartDate AND EndDate AND IsClosed = 0)
        THROW 50000, 'Posting date is not in an open Fiscal Period.', 1;

    INSERT INTO dbo.JournalHeaders (JournalDate, Reference, Description, FiscalPeriodID, CreatedBy, BranchID)
    VALUES (@JournalDate, @Reference, @Description, @FiscalPeriodID, @CreatedBy, @BranchID);

    SET @JournalID = SCOPE_IDENTITY();
END
GO

-- sp_AddJournalDetail
IF OBJECT_ID('dbo.sp_AddJournalDetail', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_AddJournalDetail;
GO
CREATE PROCEDURE dbo.sp_AddJournalDetail
    @JournalID   INT,
    @AccountID   INT,
    @Debit       DECIMAL(18,2) = 0,
    @Credit      DECIMAL(18,2) = 0,
    @Description NVARCHAR(255) = NULL,
    @Reference1  NVARCHAR(50) = NULL,
    @Reference2  NVARCHAR(50) = NULL,
    @CostCenterID INT = NULL,
    @ProjectID    INT = NULL,
    @LineNumber   INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NextLine INT = (SELECT ISNULL(MAX(LineNumber),0) + 1 FROM dbo.JournalDetails WHERE JournalID = @JournalID);

    INSERT INTO dbo.JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2, CostCenterID, ProjectID)
    VALUES (@JournalID, @NextLine, @AccountID, @Debit, @Credit, @Description, @Reference1, @Reference2, @CostCenterID, @ProjectID);

    SET @LineNumber = @NextLine;
END
GO

-- sp_PostJournal
IF OBJECT_ID('dbo.sp_PostJournal', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_PostJournal;
GO
CREATE PROCEDURE dbo.sp_PostJournal
    @JournalID INT,
    @PostedBy  INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validate exists and not posted
    IF NOT EXISTS (SELECT 1 FROM dbo.JournalHeaders WHERE JournalID = @JournalID)
        THROW 50001, 'Journal not found.', 1;

    IF EXISTS (SELECT 1 FROM dbo.JournalHeaders WHERE JournalID = @JournalID AND IsPosted = 1)
        THROW 50002, 'Journal already posted.', 1;

    -- Validate balanced
    DECLARE @TotD DECIMAL(18,2) = (SELECT ISNULL(SUM(Debit),0) FROM dbo.JournalDetails WHERE JournalID = @JournalID);
    DECLARE @TotC DECIMAL(18,2) = (SELECT ISNULL(SUM(Credit),0) FROM dbo.JournalDetails WHERE JournalID = @JournalID);
    IF (@TotD <> @TotC)
        THROW 50003, 'Journal is not balanced.', 1;

    -- Mark as posted
    UPDATE dbo.JournalHeaders
      SET IsPosted = 1,
          PostedDate = GETDATE(),
          PostedBy = @PostedBy
    WHERE JournalID = @JournalID;

    -- Note: Balances are derived from detail; no direct GLAccounts balance updates here
END
GO

-- sp_GenerateTrialBalance (as-of date)
IF OBJECT_ID('dbo.sp_GenerateTrialBalance', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GenerateTrialBalance;
GO
CREATE PROCEDURE dbo.sp_GenerateTrialBalance
    @AsOfDate      DATE,
    @BranchID      INT = NULL,
    @IncludeZeroBalances BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH PostedJournals AS (
        SELECT h.JournalID
        FROM dbo.JournalHeaders h
        WHERE h.IsPosted = 1 AND h.JournalDate <= @AsOfDate
          AND (@BranchID IS NULL OR h.BranchID = @BranchID)
    )
    SELECT 
        a.AccountID,
        a.AccountNumber,
        a.AccountName,
        a.AccountType,
        SUM(d.Debit) AS TotalDebit,
        SUM(d.Credit) AS TotalCredit,
        (a.OpeningBalance + SUM(d.Debit) - SUM(d.Credit)) AS ClosingBalance
    FROM dbo.GLAccounts a
    LEFT JOIN dbo.JournalDetails d ON d.AccountID = a.AccountID AND d.JournalID IN (SELECT JournalID FROM PostedJournals)
    GROUP BY a.AccountID, a.AccountNumber, a.AccountName, a.AccountType, a.OpeningBalance
    HAVING (@IncludeZeroBalances = 1) OR (SUM(ISNULL(d.Debit,0) - ISNULL(d.Credit,0)) <> 0);
END
GO

-- =============================================
-- DocumentNumbering (ensure exists/upgrade) and sp_GetNextDocumentNumber
-- Mirrors logic from Stockroom schema with upgrade safety
-- =============================================

-- Create table if missing (target structure)
IF OBJECT_ID('dbo.DocumentNumbering','U') IS NULL
BEGIN
    CREATE TABLE dbo.DocumentNumbering (
        DocumentNumberingID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_DocumentNumbering PRIMARY KEY,
        DocumentType        NVARCHAR(20) NOT NULL,
        BranchID            INT NULL,
        ModuleCode          NVARCHAR(5) NOT NULL CONSTRAINT DF_DocNum_ModuleCode DEFAULT N'ST',
        Prefix              NVARCHAR(10) NULL,
        NextNumber          INT NOT NULL CONSTRAINT DF_DocNum_NextNumber DEFAULT 1,
        NumberLength        INT NOT NULL CONSTRAINT DF_DocNum_NumberLength DEFAULT 6,
        LastUsedNumber      NVARCHAR(50) NULL,
        LastUsedDate        DATETIME2 NULL,
        ModifiedDate        DATETIME2 NOT NULL CONSTRAINT DF_DocNum_ModifiedDate DEFAULT SYSUTCDATETIME(),
        ModifiedBy          INT NULL
    );
END
GO

/* Ensure existing DocumentNumbering table has required columns and indexes (upgrade path) */
IF OBJECT_ID('dbo.DocumentNumbering','U') IS NOT NULL
BEGIN
    -- Add missing columns
    IF COL_LENGTH('dbo.DocumentNumbering', 'DocumentNumberingID') IS NULL
    BEGIN
        ALTER TABLE dbo.DocumentNumbering ADD DocumentNumberingID INT IDENTITY(1,1) NULL;
        -- Add PK if not present
        IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_DocumentNumbering' AND parent_object_id = OBJECT_ID('dbo.DocumentNumbering'))
            ALTER TABLE dbo.DocumentNumbering ADD CONSTRAINT PK_DocumentNumbering PRIMARY KEY (DocumentNumberingID);
    END
    IF COL_LENGTH('dbo.DocumentNumbering', 'BranchID') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD BranchID INT NULL;
    IF COL_LENGTH('dbo.DocumentNumbering', 'ModuleCode') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD ModuleCode NVARCHAR(5) NOT NULL CONSTRAINT DF_DocNum_ModuleCode DEFAULT N'ST';
    IF COL_LENGTH('dbo.DocumentNumbering', 'Prefix') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD Prefix NVARCHAR(10) NULL;
    ELSE IF EXISTS (
        SELECT 1 FROM sys.columns 
        WHERE object_id = OBJECT_ID('dbo.DocumentNumbering') 
          AND name = 'Prefix' AND is_nullable = 0
    )
        ALTER TABLE dbo.DocumentNumbering ALTER COLUMN Prefix NVARCHAR(10) NULL;
    IF COL_LENGTH('dbo.DocumentNumbering', 'NextNumber') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD NextNumber INT NOT NULL CONSTRAINT DF_DocNum_NextNumber DEFAULT 1;
    IF COL_LENGTH('dbo.DocumentNumbering', 'NumberLength') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD NumberLength INT NOT NULL CONSTRAINT DF_DocNum_NumberLength DEFAULT 6;
    IF COL_LENGTH('dbo.DocumentNumbering', 'LastUsedNumber') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD LastUsedNumber NVARCHAR(50) NULL;
    IF COL_LENGTH('dbo.DocumentNumbering', 'LastUsedDate') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD LastUsedDate DATETIME2 NULL;
    IF COL_LENGTH('dbo.DocumentNumbering', 'ModifiedDate') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD ModifiedDate DATETIME2 NOT NULL CONSTRAINT DF_DocNum_ModifiedDate DEFAULT SYSUTCDATETIME();
    IF COL_LENGTH('dbo.DocumentNumbering', 'ModifiedBy') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD ModifiedBy INT NULL;

    -- Foreign keys via dynamic SQL to avoid parse-time errors
    DECLARE @sql NVARCHAR(MAX);
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_DocumentNumbering_Branch')
       AND COL_LENGTH('dbo.DocumentNumbering','BranchID') IS NOT NULL
       AND OBJECT_ID('dbo.Branches','U') IS NOT NULL
    BEGIN
        SET @sql = N'ALTER TABLE dbo.DocumentNumbering ADD CONSTRAINT FK_DocumentNumbering_Branch FOREIGN KEY (BranchID) REFERENCES dbo.Branches(BranchID);';
        EXEC(@sql);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_DocumentNumbering_ModifiedBy')
       AND COL_LENGTH('dbo.DocumentNumbering','ModifiedBy') IS NOT NULL
       AND OBJECT_ID('dbo.Users','U') IS NOT NULL
    BEGIN
        SET @sql = N'ALTER TABLE dbo.DocumentNumbering ADD CONSTRAINT FK_DocumentNumbering_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.Users(UserID);';
        EXEC(@sql);
    END

    -- Unique indexes (filtered) if missing, created via dynamic SQL
    IF COL_LENGTH('dbo.DocumentNumbering','BranchID') IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UX_DocumentNumbering_DocType_Branch' AND object_id = OBJECT_ID('dbo.DocumentNumbering'))
        BEGIN
            SET @sql = N'CREATE UNIQUE INDEX UX_DocumentNumbering_DocType_Branch ON dbo.DocumentNumbering(DocumentType, BranchID) WHERE BranchID IS NOT NULL;';
            EXEC(@sql);
        END
        IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UX_DocumentNumbering_DocType_Global' AND object_id = OBJECT_ID('dbo.DocumentNumbering'))
        BEGIN
            SET @sql = N'CREATE UNIQUE INDEX UX_DocumentNumbering_DocType_Global ON dbo.DocumentNumbering(DocumentType) WHERE BranchID IS NULL;';
            EXEC(@sql);
        END
    END
    ELSE
    BEGIN
        -- No BranchID column: create a simple unique index on DocumentType
        IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UX_DocumentNumbering_DocType_Global' AND object_id = OBJECT_ID('dbo.DocumentNumbering'))
        BEGIN
            SET @sql = N'CREATE UNIQUE INDEX UX_DocumentNumbering_DocType_Global ON dbo.DocumentNumbering(DocumentType);';
            EXEC(@sql);
        END
    END
END;
GO

-- Recreate sp_GetNextDocumentNumber with branch/global fallback and module mapping
IF OBJECT_ID('dbo.sp_GetNextDocumentNumber','P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetNextDocumentNumber;
GO
CREATE PROCEDURE dbo.sp_GetNextDocumentNumber
    @DocumentType   NVARCHAR(20),
    @BranchID       INT,
    @UserID         INT,
    @NextDocNumber  NVARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ModuleCode NVARCHAR(5);
    SET @ModuleCode = CASE
        WHEN @DocumentType IN (N'PO', N'GRN', N'ADJ', N'TRF') THEN N'ST'
        WHEN @DocumentType IN (N'INV') THEN N'R'
        ELSE N'ST'
    END;

    DECLARE @BranchPrefix NVARCHAR(10);
    SELECT @BranchPrefix = COALESCE(NULLIF(LTRIM(RTRIM(Prefix)), N''), UPPER(LEFT(BranchName, 2)))
    FROM dbo.Branches WHERE ID = @BranchID;
    IF @BranchPrefix IS NULL SET @BranchPrefix = N'BR';

    DECLARE @NumberLength INT, @Next INT, @Prefix NVARCHAR(10);

    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @hasBranchId BIT = CASE WHEN COL_LENGTH('dbo.DocumentNumbering','BranchID') IS NULL THEN 0 ELSE 1 END;

        IF @hasBranchId = 1
        BEGIN
            DECLARE @UsedGlobal BIT = 0;

            -- Try branch-specific row first
            SELECT TOP 1 @Next = NextNumber, @NumberLength = NumberLength, @Prefix = Prefix, @ModuleCode = ModuleCode
            FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK)
            WHERE DocumentType = @DocumentType AND BranchID = @BranchID;

            IF @Next IS NULL
            BEGIN
                -- Try global row (BranchID IS NULL) next
                SELECT TOP 1 @Next = NextNumber, @NumberLength = NumberLength, @Prefix = Prefix, @ModuleCode = ModuleCode
                FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK)
                WHERE DocumentType = @DocumentType AND BranchID IS NULL;

                IF @Next IS NOT NULL SET @UsedGlobal = 1;
            END

            IF @Next IS NULL
            BEGIN
                -- No existing row; attempt to insert branch-specific. If PK exists on DocumentType only, this may fail; fallback to global row.
                BEGIN TRY
                    INSERT INTO dbo.DocumentNumbering(DocumentType, BranchID, ModuleCode, Prefix, NextNumber, NumberLength, ModifiedBy)
                    VALUES(@DocumentType, @BranchID, @ModuleCode, N'', 1, 6, @UserID);

                    -- Load inserted values
                    SELECT TOP 1 @Next = NextNumber, @NumberLength = NumberLength, @Prefix = Prefix, @ModuleCode = ModuleCode
                    FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK)
                    WHERE DocumentType = @DocumentType AND BranchID = @BranchID;
                END TRY
                BEGIN CATCH
                    -- Likely PK on DocumentType only; use/create global row instead
                    IF NOT EXISTS (SELECT 1 FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK) WHERE DocumentType = @DocumentType AND BranchID IS NULL)
                    BEGIN
                        INSERT INTO dbo.DocumentNumbering(DocumentType, BranchID, ModuleCode, Prefix, NextNumber, NumberLength, ModifiedBy)
                        VALUES(@DocumentType, NULL, @ModuleCode, N'', 1, 6, @UserID);
                    END
                    SELECT TOP 1 @Next = NextNumber, @NumberLength = NumberLength, @Prefix = Prefix, @ModuleCode = ModuleCode
                    FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK)
                    WHERE DocumentType = @DocumentType AND BranchID IS NULL;
                    SET @UsedGlobal = 1;
                    -- Clear the error
                    IF XACT_STATE() <> -1
                        DECLARE @dummy INT; -- no-op to continue
                END CATCH
            END

            IF @NumberLength IS NULL SET @NumberLength = 6;
            IF @Next IS NULL SET @Next = 1;

            DECLARE @NumberPart NVARCHAR(20) = RIGHT(REPLICATE(N'0', @NumberLength) + CAST(@Next AS NVARCHAR(20)), @NumberLength);
            DECLARE @Built NVARCHAR(50) = @BranchPrefix + N'-' + @ModuleCode + N'-' + @DocumentType + N'-' + @NumberPart;

            IF @UsedGlobal = 1
            BEGIN
                UPDATE dbo.DocumentNumbering
                  SET NextNumber = @Next + 1,
                      LastUsedNumber = @Built,
                      LastUsedDate = SYSUTCDATETIME(),
                      ModifiedDate = SYSUTCDATETIME(),
                      ModifiedBy = @UserID
                WHERE DocumentType = @DocumentType AND BranchID IS NULL;
            END
            ELSE
            BEGIN
                UPDATE dbo.DocumentNumbering
                  SET NextNumber = @Next + 1,
                      LastUsedNumber = @Built,
                      LastUsedDate = SYSUTCDATETIME(),
                      ModifiedDate = SYSUTCDATETIME(),
                      ModifiedBy = @UserID
                WHERE DocumentType = @DocumentType AND BranchID = @BranchID;
            END

            SET @NextDocNumber = @Built;
        END
        ELSE
        BEGIN
            -- Fallback: table without BranchID (global numbering only)
            IF NOT EXISTS (SELECT 1 FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK)
                           WHERE DocumentType = @DocumentType)
            BEGIN
                INSERT INTO dbo.DocumentNumbering(DocumentType, ModuleCode, Prefix, NextNumber, NumberLength, ModifiedBy)
                VALUES(@DocumentType, @ModuleCode, N'', 1, 6, @UserID);
            END

            SELECT TOP 1 @Next = NextNumber, @NumberLength = NumberLength, @Prefix = Prefix, @ModuleCode = ModuleCode
            FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK)
            WHERE DocumentType = @DocumentType;

            IF @NumberLength IS NULL SET @NumberLength = 6;
            IF @Next IS NULL SET @Next = 1;

            DECLARE @NumberPart2 NVARCHAR(20) = RIGHT(REPLICATE(N'0', @NumberLength) + CAST(@Next AS NVARCHAR(20)), @NumberLength);
            DECLARE @Built2 NVARCHAR(50) = @BranchPrefix + N'-' + @ModuleCode + N'-' + @DocumentType + N'-' + @NumberPart2;

            UPDATE dbo.DocumentNumbering
              SET NextNumber = @Next + 1,
                  LastUsedNumber = @Built2,
                  LastUsedDate = SYSUTCDATETIME(),
                  ModifiedDate = SYSUTCDATETIME(),
                  ModifiedBy = @UserID
            WHERE DocumentType = @DocumentType;

            SET @NextDocNumber = @Built2;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

PRINT 'Accounting core schema and procedures created/updated successfully.';
