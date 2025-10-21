-- 22_RecipeHierarchy.sql
SET NOCOUNT ON;

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'RecipeNode' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.RecipeNode (
        NodeID               INT IDENTITY(1,1) PRIMARY KEY,
        ProductID            INT NOT NULL REFERENCES dbo.Products(ProductID),
        ParentNodeID         INT NULL REFERENCES dbo.RecipeNode(NodeID),
        Level                INT NOT NULL DEFAULT(0),
        NodeKind             VARCHAR(20) NOT NULL, -- Component or Subcomponent
        ComponentID          INT NULL REFERENCES dbo.ComponentDefinition(ComponentID),
        ItemType             VARCHAR(20) NULL,     -- Raw Material / Decoration / Toppings / Accessories / Packaging / SubAssembly
        MaterialID           INT NULL,             -- FK to dbo.RawMaterials
        SubAssemblyProductID INT NULL,             -- FK to dbo.Products
        ItemName             NVARCHAR(200) NULL,   -- label when not Material/SubAssembly
        Qty                  DECIMAL(18,4) NULL,
        UoMID                INT NULL REFERENCES dbo.UoM(UoMID),
        Notes                NVARCHAR(500) NULL,
        SortOrder            INT NOT NULL DEFAULT(1),
        CreatedDate          DATETIME NOT NULL DEFAULT(GETDATE()),
        ModifiedDate         DATETIME NULL
    );
END

-- Indexes
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_RecipeNode_ProductID' AND object_id = OBJECT_ID('dbo.RecipeNode'))
BEGIN
    CREATE INDEX IX_RecipeNode_ProductID ON dbo.RecipeNode(ProductID, SortOrder);
END
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_RecipeNode_ParentNodeID' AND object_id = OBJECT_ID('dbo.RecipeNode'))
BEGIN
    CREATE INDEX IX_RecipeNode_ParentNodeID ON dbo.RecipeNode(ParentNodeID, SortOrder);
END
