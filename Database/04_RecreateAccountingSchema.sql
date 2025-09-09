-- =============================================
-- Clean Recreate: Accounting Schema + Document Numbering (Idempotent)
-- Run in Oven_Delights_Main. Safe to run multiple times.
-- =============================================
SET NOCOUNT ON;
GO

USE [Oven_Delights_Main];
GO

-- =============================================
-- Core Tables (create if missing)
-- =============================================
IF OBJECT_ID('dbo.GLAccounts', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.GLAccounts (
        AccountID           INT IDENTITY(1,1) PRIMARY KEY,
        AccountNumber       VARCHAR(20) NOT NULL UNIQUE,
        AccountName         NVARCHAR(100) NOT NULL,
        AccountType         VARCHAR(20) NOT NULL,
        BalanceType         CHAR(1) NOT NULL,
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
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_JournalDetails_AccountID' AND object_id = OBJECT_ID('dbo.JournalDetails'))
        CREATE INDEX IX_JournalDetails_AccountID ON dbo.JournalDetails(AccountID);
END
GO

-- =============================================
-- DocumentNumbering (create new or upgrade existing)
-- =============================================
-- Create sequence used for surrogate key when upgrading legacy tables
IF OBJECT_ID('dbo.Seq_DocumentNumberingID','SO') IS NULL
    CREATE SEQUENCE dbo.Seq_DocumentNumberingID START WITH 1 INCREMENT BY 1;
GO

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
ELSE
BEGIN
    -- Upgrade path (no IDENTITY ALTER). Use sequence-backed default + backfill.
    IF COL_LENGTH('dbo.DocumentNumbering', 'DocumentNumberingID') IS NULL
    BEGIN
        ALTER TABLE dbo.DocumentNumbering
          ADD DocumentNumberingID INT NULL CONSTRAINT DF_DocNum_ID DEFAULT (NEXT VALUE FOR dbo.Seq_DocumentNumberingID);

        -- Only backfill if the column is NOT an IDENTITY and there are NULLs to fill
        DECLARE @isIdent INT = ISNULL(COLUMNPROPERTY(OBJECT_ID('dbo.DocumentNumbering'), 'DocumentNumberingID', 'IsIdentity'), 0);
        IF @isIdent = 0 AND EXISTS (SELECT 1 FROM dbo.DocumentNumbering WITH (READUNCOMMITTED) WHERE DocumentNumberingID IS NULL)
        BEGIN
            ;WITH c AS (
                SELECT DocumentNumberingID FROM dbo.DocumentNumbering WITH (TABLOCKX)
            )
            UPDATE c SET DocumentNumberingID = NEXT VALUE FOR dbo.Seq_DocumentNumberingID
            WHERE DocumentNumberingID IS NULL;
        END

        ALTER TABLE dbo.DocumentNumbering ALTER COLUMN DocumentNumberingID INT NOT NULL;

        IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'PK_DocumentNumbering' AND parent_object_id = OBJECT_ID('dbo.DocumentNumbering'))
            ALTER TABLE dbo.DocumentNumbering ADD CONSTRAINT PK_DocumentNumbering PRIMARY KEY (DocumentNumberingID);
    END

    -- Drop legacy PK on DocumentType if present and not on the surrogate
    DECLARE @legacyPk SYSNAME = (
        SELECT TOP 1 kc.name
        FROM sys.key_constraints kc
        WHERE kc.type = 'PK' AND kc.parent_object_id = OBJECT_ID('dbo.DocumentNumbering')
          AND kc.name <> 'PK_DocumentNumbering'
    );
    IF @legacyPk IS NOT NULL
    BEGIN
        DECLARE @sqlDropPk NVARCHAR(MAX) = N'ALTER TABLE dbo.DocumentNumbering DROP CONSTRAINT ' + QUOTENAME(@legacyPk) + N';';
        EXEC (@sqlDropPk);
    END

    -- Ensure columns
    IF COL_LENGTH('dbo.DocumentNumbering', 'BranchID') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD BranchID INT NULL;
    IF COL_LENGTH('dbo.DocumentNumbering', 'ModuleCode') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD ModuleCode NVARCHAR(5) NOT NULL CONSTRAINT DF_DocNum_ModuleCode DEFAULT N'ST';
    IF COL_LENGTH('dbo.DocumentNumbering', 'Prefix') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD Prefix NVARCHAR(10) NULL;
    ELSE IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.DocumentNumbering') AND name = 'Prefix' AND is_nullable = 0)
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
END
GO

-- FKs (dynamic SQL) and unique indexes
DECLARE @sql NVARCHAR(MAX);
IF COL_LENGTH('dbo.DocumentNumbering','BranchID') IS NOT NULL
   AND OBJECT_ID('dbo.Branches','U') IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_DocumentNumbering_Branch')
BEGIN
    SET @sql = N'ALTER TABLE dbo.DocumentNumbering ADD CONSTRAINT FK_DocumentNumbering_Branch FOREIGN KEY (BranchID) REFERENCES dbo.Branches(BranchID)';
    EXEC(@sql);
END
IF COL_LENGTH('dbo.DocumentNumbering','ModifiedBy') IS NOT NULL
   AND OBJECT_ID('dbo.Users','U') IS NOT NULL
   AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_DocumentNumbering_ModifiedBy')
BEGIN
    SET @sql = N'ALTER TABLE dbo.DocumentNumbering ADD CONSTRAINT FK_DocumentNumbering_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.Users(UserID)';
    EXEC(@sql);
END

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
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UX_DocumentNumbering_DocType_Global' AND object_id = OBJECT_ID('dbo.DocumentNumbering'))
    BEGIN
        SET @sql = N'CREATE UNIQUE INDEX UX_DocumentNumbering_DocType_Global ON dbo.DocumentNumbering(DocumentType);';
        EXEC(@sql);
    END
END
GO

-- =============================================
-- Procedures (drop and recreate)
-- =============================================
IF OBJECT_ID('dbo.sp_CreateJournalEntry', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_CreateJournalEntry;
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

IF OBJECT_ID('dbo.sp_AddJournalDetail', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_AddJournalDetail;
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

IF OBJECT_ID('dbo.sp_PostJournal', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_PostJournal;
GO
CREATE PROCEDURE dbo.sp_PostJournal
    @JournalID INT,
    @PostedBy  INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM dbo.JournalHeaders WHERE JournalID = @JournalID)
        THROW 50001, 'Journal not found.', 1;
    IF EXISTS (SELECT 1 FROM dbo.JournalHeaders WHERE JournalID = @JournalID AND IsPosted = 1)
        THROW 50002, 'Journal already posted.', 1;
    DECLARE @TotD DECIMAL(18,2) = (SELECT ISNULL(SUM(Debit),0) FROM dbo.JournalDetails WHERE JournalID = @JournalID);
    DECLARE @TotC DECIMAL(18,2) = (SELECT ISNULL(SUM(Credit),0) FROM dbo.JournalDetails WHERE JournalID = @JournalID);
    IF (@TotD <> @TotC) THROW 50003, 'Journal is not balanced.', 1;
    UPDATE dbo.JournalHeaders
      SET IsPosted = 1,
          PostedDate = GETDATE(),
          PostedBy = @PostedBy
    WHERE JournalID = @JournalID;
END
GO

IF OBJECT_ID('dbo.sp_GenerateTrialBalance', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_GenerateTrialBalance;
GO
CREATE PROCEDURE dbo.sp_GenerateTrialBalance
    @AsOfDate      DATE,
    @BranchID      INT = NULL,
    @IncludeZeroBalances BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    ;WITH PostedJournals AS (
        SELECT h.JournalID FROM dbo.JournalHeaders h
        WHERE h.IsPosted = 1 AND h.JournalDate <= @AsOfDate AND (@BranchID IS NULL OR h.BranchID = @BranchID)
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

IF OBJECT_ID('dbo.sp_GetNextDocumentNumber','P') IS NOT NULL DROP PROCEDURE dbo.sp_GetNextDocumentNumber;
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
    SELECT @BranchPrefix = COALESCE(NULLIF(LTRIM(RTRIM(Prefix)), N''), UPPER(LEFT(BranchName, 2))) FROM dbo.Branches WHERE ID = @BranchID;
    IF @BranchPrefix IS NULL SET @BranchPrefix = N'BR';

    DECLARE @NumberLength INT, @Next INT, @Prefix NVARCHAR(10);

    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @hasBranchId BIT = CASE WHEN COL_LENGTH('dbo.DocumentNumbering','BranchID') IS NULL THEN 0 ELSE 1 END;

        IF @hasBranchId = 1
        BEGIN
            DECLARE @UsedGlobal BIT = 0;
            SELECT TOP 1 @Next = NextNumber, @NumberLength = NumberLength, @Prefix = Prefix, @ModuleCode = ModuleCode
            FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK)
            WHERE DocumentType = @DocumentType AND BranchID = @BranchID;

            IF @Next IS NULL
            BEGIN
                SELECT TOP 1 @Next = NextNumber, @NumberLength = NumberLength, @Prefix = Prefix, @ModuleCode = ModuleCode
                FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK)
                WHERE DocumentType = @DocumentType AND BranchID IS NULL;
                IF @Next IS NOT NULL SET @UsedGlobal = 1;
            END

            IF @Next IS NULL
            BEGIN
                BEGIN TRY
                    INSERT INTO dbo.DocumentNumbering(DocumentType, BranchID, ModuleCode, Prefix, NextNumber, NumberLength, ModifiedBy)
                    VALUES(@DocumentType, @BranchID, @ModuleCode, N'', 1, 6, @UserID);
                    SELECT TOP 1 @Next = NextNumber, @NumberLength = NumberLength, @Prefix = Prefix, @ModuleCode = ModuleCode
                    FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK)
                    WHERE DocumentType = @DocumentType AND BranchID = @BranchID;
                END TRY
                BEGIN CATCH
                    IF NOT EXISTS (SELECT 1 FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK) WHERE DocumentType = @DocumentType AND BranchID IS NULL)
                    BEGIN
                        INSERT INTO dbo.DocumentNumbering(DocumentType, BranchID, ModuleCode, Prefix, NextNumber, NumberLength, ModifiedBy)
                        VALUES(@DocumentType, NULL, @ModuleCode, N'', 1, 6, @UserID);
                    END
                    SELECT TOP 1 @Next = NextNumber, @NumberLength = NumberLength, @Prefix = Prefix, @ModuleCode = ModuleCode
                    FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK)
                    WHERE DocumentType = @DocumentType AND BranchID IS NULL;
                    SET @UsedGlobal = 1;
                END CATCH
            END

            IF @NumberLength IS NULL SET @NumberLength = 6;
            IF @Next IS NULL SET @Next = 1;

            DECLARE @NumberPart NVARCHAR(20) = RIGHT(REPLICATE(N'0', @NumberLength) + CAST(@Next AS NVARCHAR(20)), @NumberLength);
            DECLARE @Built NVARCHAR(50) = @BranchPrefix + N'-' + @ModuleCode + N'-' + @DocumentType + N'-' + @NumberPart;

            IF @UsedGlobal = 1
                UPDATE dbo.DocumentNumbering SET NextNumber = @Next + 1, LastUsedNumber = @Built, LastUsedDate = SYSUTCDATETIME(), ModifiedDate = SYSUTCDATETIME(), ModifiedBy = @UserID
                WHERE DocumentType = @DocumentType AND BranchID IS NULL;
            ELSE
                UPDATE dbo.DocumentNumbering SET NextNumber = @Next + 1, LastUsedNumber = @Built, LastUsedDate = SYSUTCDATETIME(), ModifiedDate = SYSUTCDATETIME(), ModifiedBy = @UserID
                WHERE DocumentType = @DocumentType AND BranchID = @BranchID;

            SET @NextDocNumber = @Built;
        END
        ELSE
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK) WHERE DocumentType = @DocumentType)
            BEGIN
                INSERT INTO dbo.DocumentNumbering(DocumentType, ModuleCode, Prefix, NextNumber, NumberLength, ModifiedBy)
                VALUES(@DocumentType, @ModuleCode, N'', 1, 6, @UserID);
            END

            SELECT TOP 1 @Next = NextNumber, @NumberLength = NumberLength, @Prefix = Prefix, @ModuleCode = ModuleCode
            FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK) WHERE DocumentType = @DocumentType;

            IF @NumberLength IS NULL SET @NumberLength = 6;
            IF @Next IS NULL SET @Next = 1;

            DECLARE @NumberPart2 NVARCHAR(20) = RIGHT(REPLICATE(N'0', @NumberLength) + CAST(@Next AS NVARCHAR(20)), @NumberLength);
            DECLARE @Built2 NVARCHAR(50) = @BranchPrefix + N'-' + @ModuleCode + N'-' + @DocumentType + N'-' + @NumberPart2;

            UPDATE dbo.DocumentNumbering SET NextNumber = @Next + 1, LastUsedNumber = @Built2, LastUsedDate = SYSUTCDATETIME(), ModifiedDate = SYSUTCDATETIME(), ModifiedBy = @UserID
            WHERE DocumentType = @DocumentType;

            SET @NextDocNumber = @Built2;
        END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT 'Recreate Accounting Schema completed.';
