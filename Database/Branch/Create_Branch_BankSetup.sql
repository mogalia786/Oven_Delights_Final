-- Branch Bank Setup Schema (idempotent)
-- Stores branch outbound payment banking details and export preferences
SET NOCOUNT ON;

IF OBJECT_ID('dbo.BranchBankSettings','U') IS NULL
BEGIN
    CREATE TABLE dbo.BranchBankSettings(
        BranchBankID INT IDENTITY(1,1) PRIMARY KEY,
        BranchID INT NOT NULL,
        BankName NVARCHAR(60) NOT NULL,              -- FNB, Standard Bank, ABSA, Nedbank
        AccountName NVARCHAR(120) NOT NULL,
        AccountNumber NVARCHAR(32) NOT NULL,
        BranchCode NVARCHAR(16) NOT NULL,            -- universal branch code (6-digit) or per-branch code
        AccountType NVARCHAR(20) NULL,               -- Current/Savings/etc
        DefaultPaymentFormat NVARCHAR(40) NOT NULL,  -- PAIN.001 | FNB_CSV | SBSA_CSV | ABSA_CSV | NEDBANK_CSV
        IsDefault BIT NOT NULL DEFAULT(0),
        RequireDualAuthorisation BIT NOT NULL DEFAULT(1),
        FileNamingPattern NVARCHAR(80) NULL,         -- e.g. PAY_{yyyyMMdd}_{batch}.csv
        MyReferenceTemplate NVARCHAR(50) NULL,       -- e.g. {BatchNo}-{InvNo}
        BeneficiaryReferenceTemplate NVARCHAR(50) NULL,
        EmailRemittanceFrom NVARCHAR(120) NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CreatedBy INT NULL,
        UpdatedAt DATETIME2 NULL,
        UpdatedBy INT NULL,
        CONSTRAINT FK_BranchBankSettings_Branch FOREIGN KEY (BranchID) REFERENCES dbo.Branches(BranchID)
    );
    CREATE INDEX IX_BranchBankSettings_Branch ON dbo.BranchBankSettings(BranchID);
    CREATE UNIQUE INDEX UX_BranchBankSettings_Default ON dbo.BranchBankSettings(BranchID) WHERE IsDefault = 1;
END
ELSE
BEGIN
    -- Ensure columns exist if table already present
    IF COL_LENGTH('dbo.BranchBankSettings','AccountType') IS NULL ALTER TABLE dbo.BranchBankSettings ADD AccountType NVARCHAR(20) NULL;
    IF COL_LENGTH('dbo.BranchBankSettings','DefaultPaymentFormat') IS NULL ALTER TABLE dbo.BranchBankSettings ADD DefaultPaymentFormat NVARCHAR(40) NOT NULL CONSTRAINT DF_BBS_DefaultPaymentFormat DEFAULT('PAIN.001');
    IF COL_LENGTH('dbo.BranchBankSettings','IsDefault') IS NULL ALTER TABLE dbo.BranchBankSettings ADD IsDefault BIT NOT NULL CONSTRAINT DF_BBS_IsDefault DEFAULT(0);
    IF COL_LENGTH('dbo.BranchBankSettings','RequireDualAuthorisation') IS NULL ALTER TABLE dbo.BranchBankSettings ADD RequireDualAuthorisation BIT NOT NULL CONSTRAINT DF_BBS_RequireDualAuth DEFAULT(1);
    IF COL_LENGTH('dbo.BranchBankSettings','FileNamingPattern') IS NULL ALTER TABLE dbo.BranchBankSettings ADD FileNamingPattern NVARCHAR(80) NULL;
    IF COL_LENGTH('dbo.BranchBankSettings','MyReferenceTemplate') IS NULL ALTER TABLE dbo.BranchBankSettings ADD MyReferenceTemplate NVARCHAR(50) NULL;
    IF COL_LENGTH('dbo.BranchBankSettings','BeneficiaryReferenceTemplate') IS NULL ALTER TABLE dbo.BranchBankSettings ADD BeneficiaryReferenceTemplate NVARCHAR(50) NULL;
    IF COL_LENGTH('dbo.BranchBankSettings','EmailRemittanceFrom') IS NULL ALTER TABLE dbo.BranchBankSettings ADD EmailRemittanceFrom NVARCHAR(120) NULL;
END;

PRINT 'Branch Bank Setup schema ensured.';
