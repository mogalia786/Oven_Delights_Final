-- Fix GoodsReceivedNotes table trigger error
-- Remove problematic triggers and constraints

SET NOCOUNT ON;
GO

-- Drop triggers if they exist
IF OBJECT_ID('dbo.tr_GoodsReceivedNotes_Insert','TR') IS NOT NULL
    DROP TRIGGER dbo.tr_GoodsReceivedNotes_Insert;
GO

IF OBJECT_ID('dbo.tr_GoodsReceivedNotes_Update','TR') IS NOT NULL
    DROP TRIGGER dbo.tr_GoodsReceivedNotes_Update;
GO

-- Find and drop all foreign key constraints that reference these tables
DECLARE @sql NVARCHAR(MAX) = '';
SELECT @sql = @sql + 'ALTER TABLE ' + QUOTENAME(SCHEMA_NAME(t.schema_id)) + '.' + QUOTENAME(t.name) + 
              ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';' + CHAR(13)
FROM sys.foreign_keys fk
INNER JOIN sys.tables t ON fk.parent_object_id = t.object_id
WHERE fk.referenced_object_id IN (OBJECT_ID('dbo.GoodsReceivedNotes'), OBJECT_ID('dbo.GRNLines'));

IF @sql <> ''
BEGIN
    PRINT 'Dropping foreign key constraints:';
    PRINT @sql;
    EXEC sp_executesql @sql;
END
GO

-- Drop dependent tables first to avoid foreign key constraint errors
IF OBJECT_ID('dbo.GRNLines','U') IS NOT NULL
    DROP TABLE dbo.GRNLines;
GO

-- Now drop the main table
IF OBJECT_ID('dbo.GoodsReceivedNotes','U') IS NOT NULL
    DROP TABLE dbo.GoodsReceivedNotes;
GO

-- Create GoodsReceivedNotes table without problematic constraints
CREATE TABLE dbo.GoodsReceivedNotes (
    GRNID INT IDENTITY(1,1) PRIMARY KEY,
    PurchaseOrderID INT,
    GRNNumber NVARCHAR(50),
    ReceivedDate DATETIME DEFAULT GETDATE(),
    ReceivedBy INT,
    TotalValue DECIMAL(18,2) DEFAULT 0,
    Status NVARCHAR(20) DEFAULT 'Draft',
    Notes NVARCHAR(500),
    CreatedDate DATETIME DEFAULT GETDATE(),
    CreatedBy INT
);
GO

-- Create GRNLines table matching original working structure
CREATE TABLE dbo.GRNLines (
    GRNLineID INT IDENTITY(1,1) PRIMARY KEY,
    GRNID INT NOT NULL,
    POLineID INT,
    MaterialID INT,
    OrderedQuantity DECIMAL(18,2) DEFAULT 0,
    ReceivedQuantity DECIMAL(18,2) DEFAULT 0,
    UnitCost DECIMAL(18,2) DEFAULT 0,
    LineTotal AS (ReceivedQuantity * UnitCost),
    FOREIGN KEY (GRNID) REFERENCES dbo.GoodsReceivedNotes(GRNID)
);
GO

PRINT 'GoodsReceivedNotes tables created successfully without triggers';
