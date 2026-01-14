-- =============================================
-- Create table to store user's choice about using sub-recipe stock
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ReOrderBook_SubRecipeUsage')
BEGIN
    CREATE TABLE ReOrderBook_SubRecipeUsage (
        UsageID INT IDENTITY(1,1) PRIMARY KEY,
        ReOrderBookID INT NOT NULL,
        SubRecipeID INT NOT NULL,
        UseStock BIT NOT NULL, -- True = Use from stock, False = Request fresh ingredients
        CreatedDate DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_SubRecipeUsage_ReOrderBook FOREIGN KEY (ReOrderBookID) REFERENCES ReOrderBooks(ReOrderBookID),
        CONSTRAINT FK_SubRecipeUsage_SubRecipe FOREIGN KEY (SubRecipeID) REFERENCES Demo_Retail_Product(ProductID)
    )
    
    PRINT 'Table ReOrderBook_SubRecipeUsage created successfully'
END
ELSE
BEGIN
    PRINT 'Table ReOrderBook_SubRecipeUsage already exists'
END
GO
