-- Create Production Shortage Log table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductionShortageLog')
BEGIN
    CREATE TABLE ProductionShortageLog (
        LogID INT IDENTITY(1,1) PRIMARY KEY,
        ReOrderBookID INT NOT NULL,
        Reason NVARCHAR(500) NOT NULL,
        ApprovedBy NVARCHAR(100) NOT NULL,
        LogDate DATETIME NOT NULL,
        CONSTRAINT FK_ProductionShortageLog_ReOrderBooks FOREIGN KEY (ReOrderBookID) REFERENCES ReOrderBooks(ReOrderBookID)
    )
    
    CREATE INDEX IX_ProductionShortageLog_ReOrderBookID ON ProductionShortageLog(ReOrderBookID)
    CREATE INDEX IX_ProductionShortageLog_LogDate ON ProductionShortageLog(LogDate)
    
    PRINT 'Created ProductionShortageLog table'
END
ELSE
BEGIN
    PRINT 'ProductionShortageLog table already exists'
END
