/* 20a_Seed_Test_Category_Subcategory.sql
Purpose: Seed one Product Category and one Subcategory for testing the Recipe Creator form.
This script is guarded and compatible with both Stockroom and Manufacturing schemas.
*/

SET NOCOUNT ON;
GO

/* Ensure ProductCategories exists (created by either 02_CreateStockroomSchema.sql or 10_Upgrade_Add_Manufacturing_Core.sql) */
IF OBJECT_ID('dbo.ProductCategories','U') IS NULL
BEGIN
    CREATE TABLE dbo.ProductCategories (
        CategoryID     INT IDENTITY(1,1) PRIMARY KEY,
        CategoryCode   NVARCHAR(20) NOT NULL UNIQUE,
        CategoryName   NVARCHAR(100) NOT NULL,
        IsActive       BIT NOT NULL DEFAULT 1,
        CreatedDate    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
    );
END
GO

/* Ensure ProductSubcategories exists (added by 10_Upgrade_Add_Manufacturing_Core.sql) */
IF OBJECT_ID('dbo.ProductSubcategories','U') IS NULL
BEGIN
    CREATE TABLE dbo.ProductSubcategories (
        SubcategoryID   INT IDENTITY(1,1) PRIMARY KEY,
        CategoryID      INT NOT NULL,
        SubcategoryCode NVARCHAR(30) NOT NULL,
        SubcategoryName NVARCHAR(100) NOT NULL,
        IsActive        BIT NOT NULL DEFAULT 1,
        CreatedDate     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_ProductSubcategories_Category FOREIGN KEY (CategoryID)
            REFERENCES dbo.ProductCategories(CategoryID),
        CONSTRAINT UQ_ProductSubcategories UNIQUE (CategoryID, SubcategoryCode)
    );
END
GO

DECLARE @CategoryCode NVARCHAR(20) = N'CAKE';
DECLARE @CategoryName NVARCHAR(100) = N'Cake';
DECLARE @SubcategoryCode NVARCHAR(30) = N'FCLC40';
DECLARE @SubcategoryName NVARCHAR(100) = N'Fresh Cream Lemon Cake 40cm';

/* Pick a valid UserID for CreatedBy if the column exists and is NOT NULL */
DECLARE @SeedUserID INT = NULL;
IF EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('dbo.ProductCategories') 
      AND name = 'CreatedBy'
)
BEGIN
    SELECT TOP 1 @SeedUserID = UserID 
    FROM dbo.Users 
    WHERE IsActive = 1 
    ORDER BY UserID;
    IF @SeedUserID IS NULL
        SELECT TOP 1 @SeedUserID = UserID FROM dbo.Users ORDER BY UserID;
    IF @SeedUserID IS NULL
    BEGIN
        RAISERROR('Cannot seed ProductCategories because CreatedBy is required and no Users exist. Please create a user first.', 16, 1);
        RETURN;
    END
END

DECLARE @CategoryID INT;

/* Insert category if missing */
IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE CategoryCode = @CategoryCode)
BEGIN
    IF COL_LENGTH('dbo.ProductCategories','CreatedBy') IS NOT NULL
    BEGIN
        INSERT INTO dbo.ProductCategories (CategoryCode, CategoryName, IsActive, CreatedBy)
        VALUES (@CategoryCode, @CategoryName, 1, @SeedUserID);
    END
    ELSE
    BEGIN
        INSERT INTO dbo.ProductCategories (CategoryCode, CategoryName, IsActive)
        VALUES (@CategoryCode, @CategoryName, 1);
    END
END

SELECT @CategoryID = CategoryID FROM dbo.ProductCategories WHERE CategoryCode = @CategoryCode;

/* Insert subcategory under the category if missing */
IF @CategoryID IS NOT NULL
AND NOT EXISTS (
    SELECT 1 FROM dbo.ProductSubcategories 
    WHERE CategoryID = @CategoryID AND SubcategoryCode = @SubcategoryCode)
BEGIN
    INSERT INTO dbo.ProductSubcategories (CategoryID, SubcategoryCode, SubcategoryName, IsActive)
    VALUES (@CategoryID, @SubcategoryCode, @SubcategoryName, 1);
END

PRINT 'Seeded Category=CAKE (Cake) and Subcategory=FCLC40 (Fresh Cream Lemon Cake 40cm).';
