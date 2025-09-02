/*
Minimal Core Tables for Stockroom Module (Azure SQL friendly)
- Creates only the essential tables referenced by 02_CreateStockroomSchema.sql
- No USE, no DB create, no Service Broker; safe on Azure SQL / restricted envs
- Tables: Branches(BranchID PK), Users(UserID PK)
*/

SET NOCOUNT ON;

-- Branches (expected by FKs as dbo.Branches(BranchID))
IF OBJECT_ID('dbo.Branches','U') IS NULL
BEGIN
    CREATE TABLE dbo.Branches (
        BranchID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        BranchName NVARCHAR(100) NOT NULL,
        Prefix NVARCHAR(10) NOT NULL DEFAULT N'BR'
    );
    PRINT 'Created table dbo.Branches (minimal) with BranchID PK.';
END
ELSE
BEGIN
    PRINT 'Table dbo.Branches already exists.';
END

-- Users (expected by FKs in 02_CreateStockroomSchema.sql as dbo.Users(UserID))
IF OBJECT_ID('dbo.Users','U') IS NULL
BEGIN
    CREATE TABLE dbo.Users (
        UserID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        Username NVARCHAR(50) NULL,
        Email NVARCHAR(128) NULL,
        IsActive BIT NOT NULL DEFAULT 1
    );
    PRINT 'Created table dbo.Users (minimal).';
END
ELSE
BEGIN
    PRINT 'Table dbo.Users already exists.';
END

-- Ensure at least one user exists, used by some CreatedBy FKs
IF NOT EXISTS (SELECT 1 FROM dbo.Users)
BEGIN
    INSERT INTO dbo.Users (Username, Email, IsActive) VALUES (N'admin', N'admin@localhost', 1);
    PRINT 'Inserted minimal admin user.';
END

PRINT 'Minimal core tables are ready.';
