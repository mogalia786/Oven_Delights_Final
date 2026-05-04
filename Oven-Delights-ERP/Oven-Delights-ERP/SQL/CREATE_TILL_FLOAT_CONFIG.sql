-- Create Till Float Configuration Table
-- =====================================
-- Stores the opening cash float for each till point at each branch

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'TillFloatConfig')
BEGIN
    CREATE TABLE TillFloatConfig (
        FloatConfigID INT IDENTITY(1,1) PRIMARY KEY,
        BranchID INT NOT NULL,
        TillPointID INT NOT NULL,
        FloatAmount DECIMAL(18,2) NOT NULL DEFAULT 0.00,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy NVARCHAR(100),
        ModifiedDate DATETIME,
        ModifiedBy NVARCHAR(100),
        
        -- Ensure one float config per till
        CONSTRAINT UQ_TillFloat UNIQUE (BranchID, TillPointID),
        
        -- Foreign key to Branches
        CONSTRAINT FK_TillFloat_Branch FOREIGN KEY (BranchID) 
            REFERENCES Branches(BranchID)
    );
    
    PRINT '✓ TillFloatConfig table created successfully';
    
    -- Insert default float amounts for existing tills
    INSERT INTO TillFloatConfig (BranchID, TillPointID, FloatAmount, CreatedBy)
    SELECT DISTINCT 
        BranchID,
        TillPointID,
        500.00 AS FloatAmount,  -- Default R500 float
        'SYSTEM' AS CreatedBy
    FROM TillPoints
    WHERE IsActive = 1;
    
    PRINT '✓ Default float amounts inserted for existing tills';
END
ELSE
BEGIN
    PRINT '! TillFloatConfig table already exists';
END
GO

-- View to see current float configuration
SELECT 
    tfc.FloatConfigID,
    b.BranchName,
    tfc.TillPointID,
    tfc.FloatAmount,
    tfc.IsActive,
    tfc.CreatedDate,
    tfc.ModifiedDate
FROM TillFloatConfig tfc
INNER JOIN Branches b ON tfc.BranchID = b.BranchID
ORDER BY b.BranchName, tfc.TillPointID;
GO
