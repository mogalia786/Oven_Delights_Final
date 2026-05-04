-- =============================================
-- CREATE INTERNAL ORDER TABLES FOR BOM WORKFLOW
-- =============================================
-- These tables handle ingredient requests from Manufacturing to Stockroom

USE OvenDelightsERP;
GO

-- InternalOrderHeader: Tracks ingredient requests (BOM requests)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'InternalOrderHeader')
BEGIN
    CREATE TABLE InternalOrderHeader (
        InternalOrderID INT IDENTITY(1,1) PRIMARY KEY,
        InternalOrderNo NVARCHAR(50) NOT NULL UNIQUE,
        RequestDate DATETIME NOT NULL DEFAULT GETDATE(),
        RequestedBy INT NULL, -- UserID of requester (Baker/Manufacturer)
        FromLocationID INT NULL, -- Stockroom location
        ToLocationID INT NULL, -- Manufacturing location
        Status NVARCHAR(20) NOT NULL DEFAULT 'Open', -- Open, Issued, Fulfilled, Cancelled
        Priority NVARCHAR(20) NULL,
        Notes NVARCHAR(MAX) NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CreatedBy NVARCHAR(100) NULL,
        ModifiedDate DATETIME NULL,
        ModifiedBy NVARCHAR(100) NULL,
        FulfilledDate DATETIME NULL,
        FulfilledBy NVARCHAR(100) NULL
    );
    
    PRINT '✅ InternalOrderHeader table created';
END
ELSE
    PRINT '⚠️ InternalOrderHeader table already exists';
GO

-- InternalOrderLines: Line items for each ingredient request
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'InternalOrderLines')
BEGIN
    CREATE TABLE InternalOrderLines (
        InternalOrderLineID INT IDENTITY(1,1) PRIMARY KEY,
        InternalOrderID INT NOT NULL,
        LineNumber INT NOT NULL,
        MaterialID INT NULL, -- RawMaterials.MaterialID
        ProductID INT NULL, -- For sub-assemblies
        ItemDescription NVARCHAR(200) NULL,
        QuantityRequested DECIMAL(18,3) NOT NULL,
        QuantityIssued DECIMAL(18,3) NULL DEFAULT 0,
        UoM NVARCHAR(20) NULL,
        Notes NVARCHAR(500) NULL,
        CONSTRAINT FK_InternalOrderLines_Header FOREIGN KEY (InternalOrderID) 
            REFERENCES InternalOrderHeader(InternalOrderID) ON DELETE CASCADE
    );
    
    PRINT '✅ InternalOrderLines table created';
END
ELSE
    PRINT '⚠️ InternalOrderLines table already exists';
GO

-- InventoryLocations: Stockroom and Manufacturing locations
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'InventoryLocations')
BEGIN
    CREATE TABLE InventoryLocations (
        LocationID INT IDENTITY(1,1) PRIMARY KEY,
        LocationCode NVARCHAR(20) NOT NULL UNIQUE,
        LocationName NVARCHAR(100) NOT NULL,
        LocationType NVARCHAR(20) NOT NULL, -- STOCKROOM, MANUFACTURING, RETAIL
        BranchID INT NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
    );
    
    PRINT '✅ InventoryLocations table created';
    
    -- Insert default locations
    INSERT INTO InventoryLocations (LocationCode, LocationName, LocationType, BranchID)
    SELECT 'STOCKROOM', 'Stockroom', 'STOCKROOM', BranchID FROM Branches WHERE BranchID = 1;
    
    INSERT INTO InventoryLocations (LocationCode, LocationName, LocationType, BranchID)
    SELECT 'MANUFACTURING', 'Manufacturing', 'MANUFACTURING', BranchID FROM Branches WHERE BranchID = 1;
    
    INSERT INTO InventoryLocations (LocationCode, LocationName, LocationType, BranchID)
    SELECT 'RETAIL', 'Retail Floor', 'RETAIL', BranchID FROM Branches WHERE BranchID = 1;
    
    PRINT '✅ Default inventory locations created';
END
ELSE
    PRINT '⚠️ InventoryLocations table already exists';
GO

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ INTERNAL ORDER TABLES CREATED!';
PRINT '   - InternalOrderHeader (BOM requests)';
PRINT '   - InternalOrderLines (Ingredient line items)';
PRINT '   - InventoryLocations (Stockroom/Manufacturing/Retail)';
PRINT '';
PRINT '🎯 Now run the BOM stored procedures script';
PRINT '═══════════════════════════════════════════════';
