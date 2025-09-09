-- 27_ManufacturingSubcategories.sql
-- Subcategories under ManufacturingCategories

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ManufacturingSubcategories' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.ManufacturingSubcategories (
        ID              INT IDENTITY(1,1) PRIMARY KEY,
        CategoryID      INT NOT NULL FOREIGN KEY REFERENCES dbo.ManufacturingCategories(ID),
        Code            VARCHAR(20) NOT NULL,
        Name            NVARCHAR(100) NOT NULL,
        IsActive        BIT NOT NULL DEFAULT(1),
        CreatedDate     DATETIME NOT NULL DEFAULT(GETDATE()),
        CreatedBy       INT NULL FOREIGN KEY REFERENCES dbo.Users(UserID),
        ModifiedDate    DATETIME NULL,
        ModifiedBy      INT NULL FOREIGN KEY REFERENCES dbo.Users(UserID),
        CONSTRAINT UX_ManufacturingSubcategories UNIQUE (CategoryID, Code)
    );
END;
GO
