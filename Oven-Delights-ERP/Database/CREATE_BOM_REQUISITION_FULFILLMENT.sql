-- Add fulfillment tracking to ReOrderBooks table
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ReOrderBooks') AND name = 'FulfilledDate')
BEGIN
    ALTER TABLE ReOrderBooks ADD FulfilledDate DATETIME NULL
    PRINT 'Added FulfilledDate column'
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ReOrderBooks') AND name = 'FulfilledBy')
BEGIN
    ALTER TABLE ReOrderBooks ADD FulfilledBy NVARCHAR(100) NULL
    PRINT 'Added FulfilledBy column'
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ReOrderBooks') AND name = 'InternalOrderID')
BEGIN
    ALTER TABLE ReOrderBooks ADD InternalOrderID INT NULL
    PRINT 'Added InternalOrderID column'
END

-- Create BOM Requisition Fulfillment Lines table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BOMRequisitionFulfillment')
BEGIN
    CREATE TABLE BOMRequisitionFulfillment (
        FulfillmentID INT IDENTITY(1,1) PRIMARY KEY,
        ReOrderBookID INT NOT NULL,
        IngredientName NVARCHAR(255) NOT NULL,
        QuantityRequired DECIMAL(18,4) NOT NULL,
        QuantityFulfilled DECIMAL(18,4) NOT NULL DEFAULT 0,
        UnitOfMeasure NVARCHAR(50) NOT NULL,
        FulfilledDate DATETIME NULL,
        FulfilledBy NVARCHAR(100) NULL,
        Notes NVARCHAR(500) NULL,
        CONSTRAINT FK_BOMRequisitionFulfillment_ReOrderBooks FOREIGN KEY (ReOrderBookID) REFERENCES ReOrderBooks(ReOrderBookID)
    )
    
    CREATE INDEX IX_BOMRequisitionFulfillment_ReOrderBookID ON BOMRequisitionFulfillment(ReOrderBookID)
    
    PRINT 'Created BOMRequisitionFulfillment table'
END

PRINT 'BOM Requisition Fulfillment schema created successfully'
