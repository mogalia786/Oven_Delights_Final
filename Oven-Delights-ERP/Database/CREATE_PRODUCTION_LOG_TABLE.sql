-- Create ProductionLog table to track production details
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductionLog')
BEGIN
    CREATE TABLE ProductionLog (
        ProductionLogID INT IDENTITY(1,1) PRIMARY KEY,
        ReOrderBookID INT NOT NULL,
        ProductID INT NOT NULL,
        ProductName NVARCHAR(200) NOT NULL,
        Baker NVARCHAR(100) NOT NULL,
        ExpectedYield DECIMAL(18,2) NOT NULL,
        ActualYield DECIMAL(18,2) NOT NULL,
        ShortBy DECIMAL(18,2) NOT NULL,
        Reason NVARCHAR(MAX) NULL,
        CostOfSales DECIMAL(18,2) NOT NULL,
        ProductionDate DATETIME NOT NULL,
        BranchID INT NOT NULL,
        CONSTRAINT FK_ProductionLog_ReOrderBook FOREIGN KEY (ReOrderBookID) REFERENCES ReOrderBooks(ReOrderBookID),
        CONSTRAINT FK_ProductionLog_Product FOREIGN KEY (ProductID) REFERENCES Demo_Retail_Product(ProductID)
    )
    
    PRINT 'ProductionLog table created successfully'
END
ELSE
BEGIN
    PRINT 'ProductionLog table already exists'
END
GO
