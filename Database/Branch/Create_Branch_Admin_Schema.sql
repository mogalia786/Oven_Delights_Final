-- Branch Admin Schema (idempotent)
-- Adds missing address/contact/tax fields to Branches
SET NOCOUNT ON;

IF OBJECT_ID('dbo.Branches','U') IS NULL
BEGIN
    -- Minimal create if table missing (fallback)
    CREATE TABLE dbo.Branches(
        ID INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(100) NOT NULL,
        BranchCode NVARCHAR(20) NULL,
        IsActive BIT NOT NULL DEFAULT(1)
    );
END;

-- Helper to add a column if missing
IF COL_LENGTH('dbo.Branches','AddressLine1') IS NULL ALTER TABLE dbo.Branches ADD AddressLine1 NVARCHAR(120) NULL;
IF COL_LENGTH('dbo.Branches','AddressLine2') IS NULL ALTER TABLE dbo.Branches ADD AddressLine2 NVARCHAR(120) NULL;
IF COL_LENGTH('dbo.Branches','City') IS NULL ALTER TABLE dbo.Branches ADD City NVARCHAR(80) NULL;
IF COL_LENGTH('dbo.Branches','Province') IS NULL ALTER TABLE dbo.Branches ADD Province NVARCHAR(80) NULL;
IF COL_LENGTH('dbo.Branches','PostalCode') IS NULL ALTER TABLE dbo.Branches ADD PostalCode NVARCHAR(12) NULL;
IF COL_LENGTH('dbo.Branches','Country') IS NULL ALTER TABLE dbo.Branches ADD Country NVARCHAR(80) NULL;
IF COL_LENGTH('dbo.Branches','Phone') IS NULL ALTER TABLE dbo.Branches ADD Phone NVARCHAR(40) NULL;
IF COL_LENGTH('dbo.Branches','Email') IS NULL ALTER TABLE dbo.Branches ADD Email NVARCHAR(120) NULL;
IF COL_LENGTH('dbo.Branches','TaxNumber') IS NULL ALTER TABLE dbo.Branches ADD TaxNumber NVARCHAR(40) NULL;
IF COL_LENGTH('dbo.Branches','BranchCode') IS NULL ALTER TABLE dbo.Branches ADD BranchCode NVARCHAR(20) NULL;
IF COL_LENGTH('dbo.Branches','IsActive') IS NULL ALTER TABLE dbo.Branches ADD IsActive BIT NOT NULL DEFAULT(1);

PRINT 'Branch Admin schema ensured.';
