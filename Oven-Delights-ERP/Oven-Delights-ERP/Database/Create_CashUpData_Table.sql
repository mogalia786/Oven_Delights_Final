-- =============================================
-- Create CashUpData Table
-- Stores End of Day cash denomination counts and totals per till
-- Supports multiple cashier submissions and finalization
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'U' AND name = 'CashUpData')
BEGIN
    CREATE TABLE CashUpData (
        CashUpID INT IDENTITY(1,1) PRIMARY KEY,
        BranchID INT NOT NULL,
        TillNumber NVARCHAR(50) NOT NULL,
        CashUpDate DATE NOT NULL,
        CashierName NVARCHAR(100) NOT NULL,
        
        -- Denomination counts
        Count_R200 INT DEFAULT 0,
        Count_R100 INT DEFAULT 0,
        Count_R50 INT DEFAULT 0,
        Count_R20 INT DEFAULT 0,
        Count_R10 INT DEFAULT 0,
        Count_R5 INT DEFAULT 0,
        Count_R2 INT DEFAULT 0,
        Count_R1 INT DEFAULT 0,
        Count_50c INT DEFAULT 0,
        Count_20c INT DEFAULT 0,
        Count_10c INT DEFAULT 0,
        Count_5c INT DEFAULT 0,
        
        -- Calculated totals
        ExpectedCash DECIMAL(18,2) NOT NULL,
        ActualCash DECIMAL(18,2) NOT NULL,
        Variance DECIMAL(18,2) NOT NULL,
        
        -- Status
        IsFinalized BIT DEFAULT 0,
        FinalizedDate DATETIME NULL,
        FinalizedBy NVARCHAR(100) NULL,
        
        -- Audit
        CreatedDate DATETIME DEFAULT GETDATE(),
        CreatedBy NVARCHAR(100) NULL,
        LastModifiedDate DATETIME DEFAULT GETDATE(),
        LastModifiedBy NVARCHAR(100) NULL,
        
        -- Constraints
        CONSTRAINT UQ_CashUpData_BranchTillDate UNIQUE (BranchID, TillNumber, CashUpDate)
    )
    
    PRINT 'CashUpData table created successfully'
END
ELSE
BEGIN
    PRINT 'CashUpData table already exists'
END
GO

-- Create index for faster queries
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_CashUpData_Date_Finalized')
BEGIN
    CREATE INDEX IX_CashUpData_Date_Finalized 
    ON CashUpData(CashUpDate, IsFinalized)
    PRINT 'Index IX_CashUpData_Date_Finalized created'
END
GO

PRINT ''
PRINT 'CashUpData table structure:'
PRINT '  - Stores denomination counts for each till per day'
PRINT '  - Supports partial submissions (multiple cashiers at different times)'
PRINT '  - IsFinalized = 0: Can edit and update'
PRINT '  - IsFinalized = 1: Locked, read-only'
PRINT '  - Unique constraint: One record per Branch/Till/Date'
PRINT ''
