-- 21_ComponentLibrary.sql
SET NOCOUNT ON;

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ComponentDefinition' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.ComponentDefinition (
        ComponentID       INT IDENTITY(1,1) PRIMARY KEY,
        ComponentName     NVARCHAR(200) NOT NULL,
        Description       NVARCHAR(500) NULL,
        IsActive          BIT NOT NULL DEFAULT(1),
        CreatedDate       DATETIME NOT NULL DEFAULT(GETDATE()),
        ModifiedDate      DATETIME NULL
    );
END

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ComponentItem' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.ComponentItem (
        ComponentItemID   INT IDENTITY(1,1) PRIMARY KEY,
        ComponentID       INT NOT NULL REFERENCES dbo.ComponentDefinition(ComponentID),
        ItemType          VARCHAR(20) NOT NULL, -- Raw Material / Decoration / Toppings / Accessories / Packaging / SubAssembly
        MaterialID        INT NULL,            -- FK to dbo.RawMaterials when ItemType = Raw Material
        SubAssemblyProductID INT NULL,         -- FK to dbo.Products when ItemType = SubAssembly
        ItemName          NVARCHAR(200) NULL,  -- Free-text label for non-material, non-subassembly cases
        DefaultQty        DECIMAL(18,4) NULL,
        UoMID             INT NULL REFERENCES dbo.UoM(UoMID),
        Notes             NVARCHAR(500) NULL,
        SortOrder         INT NOT NULL DEFAULT(1)
    );
END

-- Indexes
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ComponentItem_ComponentID' AND object_id = OBJECT_ID('dbo.ComponentItem'))
BEGIN
    CREATE INDEX IX_ComponentItem_ComponentID ON dbo.ComponentItem(ComponentID, SortOrder);
END
