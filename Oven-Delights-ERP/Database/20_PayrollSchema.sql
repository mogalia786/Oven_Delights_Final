-- Payroll schema for Oven Delights ERP
-- Creates core tables for payroll periods, runs and per-employee entries
-- Assumes existing tables: Users(UserID), Branches(ID), Staff(StaffID)

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayrollPeriods]') AND type in (N'U'))
BEGIN
    CREATE TABLE dbo.PayrollPeriods (
        PeriodID        INT IDENTITY(1,1) PRIMARY KEY,
        PeriodName      NVARCHAR(50) NOT NULL,
        StartDate       DATE NOT NULL,
        EndDate         DATE NOT NULL,
        IsClosed        BIT NOT NULL DEFAULT 0,
        ClosedDate      DATETIME NULL,
        ClosedBy        INT NULL REFERENCES dbo.Users(UserID)
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayrollRuns]') AND type in (N'U'))
BEGIN
    CREATE TABLE dbo.PayrollRuns (
        RunID           INT IDENTITY(1,1) PRIMARY KEY,
        PeriodID        INT NOT NULL REFERENCES dbo.PayrollPeriods(PeriodID),
        BranchID        INT NULL REFERENCES dbo.Branches(BranchID),
        Description     NVARCHAR(255) NULL,
        CreatedBy       INT NOT NULL REFERENCES dbo.Users(UserID),
        CreatedDate     DATETIME NOT NULL DEFAULT GETDATE(),
        PostedJournalID INT NULL REFERENCES dbo.JournalHeaders(JournalID)
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayrollEntries]') AND type in (N'U'))
BEGIN
    CREATE TABLE dbo.PayrollEntries (
        EntryID         INT IDENTITY(1,1) PRIMARY KEY,
        RunID           INT NULL REFERENCES dbo.PayrollRuns(RunID),
        PeriodID        INT NOT NULL REFERENCES dbo.PayrollPeriods(PeriodID),
        StaffID         INT NOT NULL,
        BranchID        INT NULL REFERENCES dbo.Branches(BranchID),
        SalaryType      NVARCHAR(20) NULL,
        BasePay         DECIMAL(18,2) NOT NULL DEFAULT 0,
        Allowances      DECIMAL(18,2) NOT NULL DEFAULT 0,
        Overtime        DECIMAL(18,2) NOT NULL DEFAULT 0,
        Bonuses         DECIMAL(18,2) NOT NULL DEFAULT 0,
        Deductions      DECIMAL(18,2) NOT NULL DEFAULT 0,
        SickDays        DECIMAL(9,2) NOT NULL DEFAULT 0,
        LeaveDays       DECIMAL(9,2) NOT NULL DEFAULT 0,
        GrossPay        AS (BasePay + Allowances + Overtime + Bonuses) PERSISTED,
        NetPay          AS ((BasePay + Allowances + Overtime + Bonuses) - Deductions) PERSISTED,
        Notes           NVARCHAR(255) NULL,
        CreatedBy       INT NOT NULL REFERENCES dbo.Users(UserID),
        CreatedDate     DATETIME NOT NULL DEFAULT GETDATE()
    );
    -- Optional FK if Staff table exists
    IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Staff]') AND type in (N'U'))
    BEGIN
        ALTER TABLE dbo.PayrollEntries WITH NOCHECK ADD CONSTRAINT FK_PayrollEntries_Staff FOREIGN KEY (StaffID) REFERENCES dbo.Staff(StaffID);
    END
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayrollSettings]') AND type in (N'U'))
BEGIN
    CREATE TABLE dbo.PayrollSettings (
        SettingKey      NVARCHAR(64) NOT NULL PRIMARY KEY,
        SettingValue    NVARCHAR(256) NULL,
        ModifiedDate    DATETIME NOT NULL DEFAULT GETDATE(),
        ModifiedBy      INT NULL REFERENCES dbo.Users(UserID)
    );

    INSERT INTO dbo.PayrollSettings(SettingKey, SettingValue)
    VALUES
        ('PayrollExpenseAccountID', NULL),
        ('PayrollLiabilityAccountID', NULL),
        ('BANK_DEFAULT', NULL);
END
GO

-- Stored procedure stub to post a payroll run to journals
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_PostPayrollRun]') AND type in (N'P'))
EXEC ('
CREATE PROCEDURE dbo.sp_PostPayrollRun
    @RunID INT,
    @JournalDate DATE,
    @CreatedBy INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;
    -- This is a stub; business-specific account selection and splitting can be added.
    -- Aggregate amounts
    DECLARE @ExpenseAcc INT = TRY_CAST((SELECT SettingValue FROM dbo.PayrollSettings WHERE SettingKey = ''PayrollExpenseAccountID'') AS INT);
    DECLARE @LiabilityAcc INT = TRY_CAST((SELECT SettingValue FROM dbo.PayrollSettings WHERE SettingKey = ''PayrollLiabilityAccountID'') AS INT);
    IF @ExpenseAcc IS NULL OR @LiabilityAcc IS NULL
    BEGIN
        RAISERROR(''Payroll expense/liability accounts not configured'', 16, 1);
        RETURN;
    END

    DECLARE @TotalGross DECIMAL(18,2) = (SELECT SUM(GrossPay) FROM dbo.PayrollEntries WHERE RunID = @RunID);
    DECLARE @TotalNet   DECIMAL(18,2) = (SELECT SUM(NetPay)   FROM dbo.PayrollEntries WHERE RunID = @RunID);

    -- Resolve FiscalPeriodID from JournalDate if possible
    DECLARE @FiscalPeriodID INT = (SELECT TOP (1) PeriodID FROM dbo.FiscalPeriods WHERE @JournalDate BETWEEN StartDate AND EndDate ORDER BY StartDate DESC);
    DECLARE @JournalID INT;
    EXEC dbo.sp_CreateJournalEntry @JournalDate=@JournalDate, @Reference=@RunID, @Description=''Payroll Accrual'',
        @FiscalPeriodID=@FiscalPeriodID, @CreatedBy=@CreatedBy, @BranchID=@BranchID, @JournalID=@JournalID OUTPUT;

    -- Prepare text references to avoid inline CONVERT syntax issues
    DECLARE @RunIDText NVARCHAR(20) = CONVERT(NVARCHAR(20), @RunID);

    -- Expense DR
    EXEC dbo.sp_AddJournalDetail @JournalID=@JournalID, @AccountID=@ExpenseAcc, @Debit=@TotalGross, @Credit=0, @Description=''Payroll Expense'',
        @Reference1=''PAYROLL'', @Reference2=@RunIDText, @CostCenterID=NULL, @ProjectID=NULL;

    -- Liability CR (net pay)
    EXEC dbo.sp_AddJournalDetail @JournalID=@JournalID, @AccountID=@LiabilityAcc, @Debit=0, @Credit=@TotalNet, @Description=''Payroll Liability'',
        @Reference1=''PAYROLL'', @Reference2=@RunIDText, @CostCenterID=NULL, @ProjectID=NULL;

    UPDATE dbo.PayrollRuns SET PostedJournalID=@JournalID WHERE RunID=@RunID;
END
');
GO
