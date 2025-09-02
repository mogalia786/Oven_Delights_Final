-- Link table between Products and RecipeTemplate (non-invasive)
IF OBJECT_ID('dbo.ProductRecipe','U') IS NULL
BEGIN
    CREATE TABLE dbo.ProductRecipe (
        ProductID INT NOT NULL,
        RecipeTemplateID INT NOT NULL,
        VariantID INT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        CONSTRAINT PK_ProductRecipe PRIMARY KEY (ProductID, RecipeTemplateID),
        CONSTRAINT FK_ProductRecipe_Product FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID),
        CONSTRAINT FK_ProductRecipe_Recipe FOREIGN KEY (RecipeTemplateID) REFERENCES dbo.RecipeTemplate(RecipeTemplateID),
        CONSTRAINT FK_ProductRecipe_User FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID)
    );
END
GO
