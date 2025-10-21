-- =============================================
-- Manufacturing Inventory Table
-- Tracks raw materials issued to manufacturing (WIP)
-- =============================================

IF OBJECT_ID('dbo.Manufacturing_Inventory','U') IS NULL
BEGIN
    CREATE TABLE dbo.Manufacturing_Inventory (
        ManufacturingInventoryID INT IDENTITY(1,1) PRIMARY KEY,
        MaterialID INT NOT NULL,
        BranchID INT NOT NULL,
        QtyOnHand DECIMAL(18,4) NOT NULL DEFAULT(0),
        AverageCost DECIMAL(18,4) NOT NULL DEFAULT(0),
        LastUpdated DATETIME NOT NULL DEFAULT(GETDATE()),
        UpdatedBy INT NULL,
        CONSTRAINT FK_ManufacturingInventory_Material FOREIGN KEY (MaterialID) REFERENCES RawMaterials(MaterialID),
        CONSTRAINT FK_ManufacturingInventory_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
        CONSTRAINT UQ_ManufacturingInventory_Material_Branch UNIQUE (MaterialID, BranchID)
    );
    
    PRINT 'Created table: Manufacturing_Inventory';
END
ELSE
BEGIN
    PRINT 'Table Manufacturing_Inventory already exists';
END
GO

-- =============================================
-- Manufacturing Inventory Movements (Audit Trail)
-- =============================================

IF OBJECT_ID('dbo.Manufacturing_InventoryMovements','U') IS NULL
BEGIN
    CREATE TABLE dbo.Manufacturing_InventoryMovements (
        MovementID INT IDENTITY(1,1) PRIMARY KEY,
        MaterialID INT NOT NULL,
        BranchID INT NOT NULL,
        MovementType NVARCHAR(50) NOT NULL, -- 'Issue', 'Return', 'Consumed', 'Adjustment'
        QtyDelta DECIMAL(18,4) NOT NULL,
        CostPerUnit DECIMAL(18,4) NOT NULL DEFAULT(0),
        MovementDate DATETIME NOT NULL DEFAULT(GETDATE()),
        Reference NVARCHAR(100) NULL,
        Notes NVARCHAR(500) NULL,
        CreatedBy INT NULL,
        CONSTRAINT FK_ManufacturingMovements_Material FOREIGN KEY (MaterialID) REFERENCES RawMaterials(MaterialID),
        CONSTRAINT FK_ManufacturingMovements_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    );
    
    CREATE INDEX IX_ManufacturingMovements_Material ON dbo.Manufacturing_InventoryMovements(MaterialID);
    CREATE INDEX IX_ManufacturingMovements_Branch ON dbo.Manufacturing_InventoryMovements(BranchID);
    CREATE INDEX IX_ManufacturingMovements_Date ON dbo.Manufacturing_InventoryMovements(MovementDate);
    
    PRINT 'Created table: Manufacturing_InventoryMovements';
END
ELSE
BEGIN
    PRINT 'Table Manufacturing_InventoryMovements already exists';
END
GO

-- =============================================
-- Add Image column to Products table if missing
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Products') AND name = 'ProductImage')
BEGIN
    ALTER TABLE dbo.Products
    ADD ProductImage VARBINARY(MAX) NULL;
    
    PRINT 'Added ProductImage column to Products table';
END
ELSE
BEGIN
    PRINT 'ProductImage column already exists in Products table';
END
GO

PRINT 'Manufacturing Inventory schema creation completed';
