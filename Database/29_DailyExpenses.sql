-- 29_DailyExpenses.sql
-- Daily expense capture linked to ExpenseTypes and Branch

IF OBJECT_ID('dbo.DailyExpenses','U') IS NULL
BEGIN
    CREATE TABLE dbo.DailyExpenses (
        ExpenseID       INT IDENTITY(1,1) PRIMARY KEY,
        ExpenseTypeID   INT NOT NULL FOREIGN KEY REFERENCES dbo.ExpenseTypes(ExpenseTypeID),
        ExpenseDate     DATE NOT NULL,
        Amount          DECIMAL(18,2) NOT NULL,
        BranchID        INT NULL FOREIGN KEY REFERENCES dbo.Branches(BranchID),
        Reference       NVARCHAR(50) NULL,
        Description     NVARCHAR(255) NULL,
        CreatedBy       INT NULL FOREIGN KEY REFERENCES dbo.Users(UserID),
        CreatedDate     DATETIME NOT NULL DEFAULT(GETDATE())
    );

    CREATE INDEX IX_DailyExpenses_Date ON dbo.DailyExpenses(ExpenseDate);
    CREATE INDEX IX_DailyExpenses_Branch ON dbo.DailyExpenses(BranchID);
END
GO
