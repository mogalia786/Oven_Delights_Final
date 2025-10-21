-- Fix Manufacturing_InventoryMovements table - Add BranchID if missing
-- This fixes the "Invalid column name 'BranchID'" error when fulfilling BOMs

-- Check if table exists, if not create it
IF OBJECT_ID('dbo.Manufacturing_InventoryMovements','U') IS NULL
BEGIN
    CREATE TABLE dbo.Manufacturing_InventoryMovements (
        MovementID INT IDENTITY(1,1) PRIMARY KEY,
        MaterialID INT NOT NULL,
        BranchID INT NOT NULL,
        MovementType NVARCHAR(50) NOT NULL,
        Quantity DECIMAL(18,4) NOT NULL,
        UnitCost DECIMAL(18,4) NOT NULL DEFAULT 0,
        ReferenceType NVARCHAR(50) NULL,
        ReferenceID INT NULL,
        MovementDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy INT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
    );
    
    PRINT 'Created Manufacturing_InventoryMovements table with BranchID';
END
ELSE
BEGIN
    -- Table exists, check if BranchID column exists
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Manufacturing_InventoryMovements') AND name = 'BranchID')
    BEGIN
        ALTER TABLE dbo.Manufacturing_InventoryMovements
        ADD BranchID INT NOT NULL DEFAULT 1;
        
        PRINT 'Added BranchID column to Manufacturing_InventoryMovements';
    END
    ELSE
    BEGIN
        PRINT 'BranchID column already exists in Manufacturing_InventoryMovements';
    END
END
GO

PRINT 'Manufacturing_InventoryMovements table is ready for BOM fulfillment';
GO
