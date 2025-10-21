-- Add BranchID column to StockMovements table
-- This fixes the "Invalid column name 'BranchID'" error

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.StockMovements') AND name = 'BranchID')
BEGIN
    PRINT 'BranchID column already exists in StockMovements';
END
ELSE
BEGIN
    ALTER TABLE dbo.StockMovements
    ADD BranchID INT NULL;
    
    PRINT 'Added BranchID column to StockMovements';
END
GO

-- Update existing records with default branch (separate batch after column is added)
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.StockMovements') AND name = 'BranchID')
BEGIN
    UPDATE dbo.StockMovements
    SET BranchID = 1
    WHERE BranchID IS NULL;
    
    PRINT 'Updated existing StockMovements records with default BranchID';
END
GO

PRINT 'StockMovements table is ready';
GO
