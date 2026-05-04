-- Create BOM (Bill of Materials) tables

-- Main BOM Header
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BOM_Header')
BEGIN
    CREATE TABLE BOM_Header (
        BOMID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        ProductName NVARCHAR(255) NOT NULL,
        ProductCode NVARCHAR(50),
        BatchSize DECIMAL(18,2) NOT NULL DEFAULT 1,
        TotalCost DECIMAL(18,2) NOT NULL DEFAULT 0,
        TotalCostWithVAT DECIMAL(18,2) NOT NULL DEFAULT 0,
        MethodInstructions NVARCHAR(MAX),
        CreatedBy NVARCHAR(100),
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedBy NVARCHAR(100),
        ModifiedDate DATETIME,
        IsActive BIT DEFAULT 1,
        CONSTRAINT FK_BOM_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
    );
END

-- BOM Line Items (ingredients, sub-recipes, other items)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BOM_Lines')
BEGIN
    CREATE TABLE BOM_Lines (
        BOMLineID INT IDENTITY(1,1) PRIMARY KEY,
        BOMID INT NOT NULL,
        ItemID INT NOT NULL,
        ProductName NVARCHAR(255) NOT NULL,
        ProductType NVARCHAR(50) NOT NULL, -- 'Ingredient', 'Sub-Recipe', 'Other'
        SubRecipeName NVARCHAR(255),
        Quantity DECIMAL(18,2) NOT NULL,
        UnitOfMeasure NVARCHAR(50),
        UnitCost DECIMAL(18,2) NOT NULL DEFAULT 0,
        TotalCost DECIMAL(18,2) NOT NULL DEFAULT 0,
        IsVatable BIT DEFAULT 1,
        LineNumber INT,
        CONSTRAINT FK_BOMLines_Header FOREIGN KEY (BOMID) REFERENCES BOM_Header(BOMID) ON DELETE CASCADE,
        CONSTRAINT FK_BOMLines_Product FOREIGN KEY (ItemID) REFERENCES Products(ProductID)
    );
END

-- Create indexes
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_BOM_Header_ProductID')
    CREATE INDEX IX_BOM_Header_ProductID ON BOM_Header(ProductID);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_BOM_Lines_BOMID')
    CREATE INDEX IX_BOM_Lines_BOMID ON BOM_Lines(BOMID);

PRINT 'BOM tables created successfully';
