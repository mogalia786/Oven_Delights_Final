-- 23_Attributes.sql
SET NOCOUNT ON;

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'AttributeDefinition' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.AttributeDefinition (
        AttributeID    INT IDENTITY(1,1) PRIMARY KEY,
        AttributeName  NVARCHAR(100) NOT NULL UNIQUE,
        DataType       VARCHAR(20) NOT NULL DEFAULT('text'), -- text, number, bool, list
        IsActive       BIT NOT NULL DEFAULT(1),
        CreatedDate    DATETIME NOT NULL DEFAULT(GETDATE())
    );
END

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ComponentItemAttribute' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.ComponentItemAttribute (
        ComponentItemID INT NOT NULL REFERENCES dbo.ComponentItem(ComponentItemID),
        AttributeID     INT NOT NULL REFERENCES dbo.AttributeDefinition(AttributeID),
        ValueText       NVARCHAR(400) NULL,
        ValueNumber     DECIMAL(18,4) NULL,
        ValueBool       BIT NULL,
        PRIMARY KEY (ComponentItemID, AttributeID)
    );
END

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'RecipeNodeAttribute' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.RecipeNodeAttribute (
        NodeID          INT NOT NULL REFERENCES dbo.RecipeNode(NodeID),
        AttributeID     INT NOT NULL REFERENCES dbo.AttributeDefinition(AttributeID),
        ValueText       NVARCHAR(400) NULL,
        ValueNumber     DECIMAL(18,4) NULL,
        ValueBool       BIT NULL,
        PRIMARY KEY (NodeID, AttributeID)
    );
END
