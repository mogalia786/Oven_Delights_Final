-- 28_ExpenseTypes.sql
-- Master list of expense types for daily expense capture

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ExpenseTypes' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.ExpenseTypes (
        ExpenseTypeID   INT IDENTITY(1,1) PRIMARY KEY,
        Code            VARCHAR(20) NOT NULL UNIQUE,
        Name            NVARCHAR(100) NOT NULL,
        IsActive        BIT NOT NULL DEFAULT(1),
        CreatedDate     DATETIME NOT NULL DEFAULT(GETDATE()),
        CreatedBy       INT NULL FOREIGN KEY REFERENCES dbo.Users(UserID),
        ModifiedDate    DATETIME NULL,
        ModifiedBy      INT NULL FOREIGN KEY REFERENCES dbo.Users(UserID)
    );
END;
GO
