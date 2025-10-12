-- GL Core Stored Procedures (idempotent)
-- Azure SQL compatible
-- Timestamp: 10-Sep-2025 13:06 SAST

-- sp_CreateJournalEntry: inserts a journal header and returns @JournalID
IF OBJECT_ID('dbo.sp_CreateJournalEntry','P') IS NULL
    EXEC ('CREATE PROCEDURE dbo.sp_CreateJournalEntry AS RETURN 0');
GO
ALTER PROCEDURE dbo.sp_CreateJournalEntry
    @JournalDate     DATE,
    @Reference       VARCHAR(100) = NULL,
    @Description     VARCHAR(256) = NULL,
    @FiscalPeriodID  INT = NULL,
    @CreatedBy       INT = NULL,
    @BranchID        INT = NULL,
    @JournalID       INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Journals (JournalDate, JournalNumber, Reference, Description, FiscalPeriodID, BranchID, CreatedBy, CreatedAt, PostedBy, PostedAt, PostedFlag)
    VALUES (@JournalDate, NULL, @Reference, @Description, @FiscalPeriodID, @BranchID, @CreatedBy, SYSUTCDATETIME(), NULL, NULL, 0);
    SET @JournalID = CAST(SCOPE_IDENTITY() AS INT);
END
GO

-- sp_AddJournalDetail: inserts a journal line, sequential LineNumber per JournalID
IF OBJECT_ID('dbo.sp_AddJournalDetail','P') IS NULL
    EXEC ('CREATE PROCEDURE dbo.sp_AddJournalDetail AS RETURN 0');
GO
ALTER PROCEDURE dbo.sp_AddJournalDetail
    @JournalID     INT,
    @AccountID     INT,
    @Debit         DECIMAL(18,2),
    @Credit        DECIMAL(18,2),
    @Description   VARCHAR(256) = NULL,
    @Reference1    VARCHAR(100) = NULL,
    @Reference2    VARCHAR(100) = NULL,
    @CostCenterID  INT = NULL,
    @ProjectID     INT = NULL,
    @LineNumber    INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NextLine INT = 1;
    SELECT @NextLine = ISNULL(MAX(LineNumber),0) + 1 FROM dbo.JournalLines WHERE JournalID = @JournalID;
    INSERT INTO dbo.JournalLines (JournalID, LineNumber, AccountID, Debit, Credit, LineDescription, Reference1, Reference2, CostCenterID, ProjectID, ClearedFlag, StatementRef)
    VALUES (@JournalID, @NextLine, @AccountID, @Debit, @Credit, @Description, @Reference1, @Reference2, @CostCenterID, @ProjectID, 0, NULL);
    SET @LineNumber = @NextLine;
END
GO

-- sp_PostJournal: marks journal as posted
IF OBJECT_ID('dbo.sp_PostJournal','P') IS NULL
    EXEC ('CREATE PROCEDURE dbo.sp_PostJournal AS RETURN 0');
GO
ALTER PROCEDURE dbo.sp_PostJournal
    @JournalID INT,
    @PostedBy  INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Journals
    SET PostedFlag = 1,
        PostedBy = @PostedBy,
        PostedAt = SYSUTCDATETIME()
    WHERE JournalID = @JournalID;
END
GO
