-- Fix DEFAULT constraints on ALL tables used in the transaction
SET QUOTED_IDENTIFIER ON;
GO

-- Fix StockMovements table
PRINT 'Fixing StockMovements table...';
DECLARE @sql NVARCHAR(MAX) = '';
SELECT @sql += 'ALTER TABLE StockMovements DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.default_constraints
WHERE parent_object_id = OBJECT_ID('StockMovements');

IF @sql <> ''
BEGIN
    EXEC sp_executesql @sql;
    PRINT 'Dropped StockMovements default constraints';
END

-- Recreate StockMovements constraints with QUOTED_IDENTIFIER ON
ALTER TABLE StockMovements ADD CONSTRAINT DF_StockMovements_CreatedDate DEFAULT (GETDATE()) FOR CreatedDate;
PRINT 'Recreated StockMovements constraints';

-- Fix GoodsReceivedNotes table
PRINT 'Fixing GoodsReceivedNotes table...';
SET @sql = '';
SELECT @sql += 'ALTER TABLE GoodsReceivedNotes DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.default_constraints
WHERE parent_object_id = OBJECT_ID('GoodsReceivedNotes');

IF @sql <> ''
BEGIN
    EXEC sp_executesql @sql;
    PRINT 'Dropped GoodsReceivedNotes default constraints';
END

-- Recreate GoodsReceivedNotes constraints with QUOTED_IDENTIFIER ON
ALTER TABLE GoodsReceivedNotes ADD CONSTRAINT DF_GoodsReceivedNotes_CreatedDate DEFAULT (GETDATE()) FOR CreatedDate;
PRINT 'Recreated GoodsReceivedNotes constraints';

PRINT '';
PRINT 'ALL TABLE CONSTRAINTS FIXED';
