-- 25_GLAccountMappings.sql
-- Creates a generic mappings table to link functional keys to GLAccounts, with optional branch override

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'GLAccountMappings' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.GLAccountMappings (
        MappingID       INT           IDENTITY(1,1) NOT NULL PRIMARY KEY,
        MappingKey      VARCHAR(50)   NOT NULL,
        AccountID       INT           NULL FOREIGN KEY REFERENCES dbo.GLAccounts(AccountID),
        BranchID        INT           NULL FOREIGN KEY REFERENCES dbo.Branches(ID),
        ModifiedDate    DATETIME      NOT NULL DEFAULT(GETDATE()),
        ModifiedBy      INT           NULL FOREIGN KEY REFERENCES dbo.Users(UserID)
    );

    -- Enforce uniqueness per key when BranchID IS NULL (global)
    CREATE UNIQUE NONCLUSTERED INDEX UX_GLAccountMappings_Global
        ON dbo.GLAccountMappings(MappingKey)
        WHERE BranchID IS NULL;

    -- Enforce uniqueness per key/branch when BranchID IS NOT NULL
    CREATE UNIQUE NONCLUSTERED INDEX UX_GLAccountMappings_ByBranch
        ON dbo.GLAccountMappings(MappingKey, BranchID)
        WHERE BranchID IS NOT NULL;
END
GO

-- No seed rows inserted to avoid invalid AccountID references; use admin UI to populate.
GO

-- View for convenience
IF OBJECT_ID('dbo.vw_GLAccountMappings', 'V') IS NULL
EXEC('CREATE VIEW dbo.vw_GLAccountMappings AS SELECT MappingKey, AccountID, BranchID FROM dbo.GLAccountMappings');
GO
