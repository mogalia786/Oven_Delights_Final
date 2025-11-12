-- Fix Retail_Stock foreign key to reference Demo_Retail_Product instead of Products

-- Find and drop ALL FK constraints that reference the old Products table
DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql = @sql + 'ALTER TABLE [' + OBJECT_SCHEMA_NAME(fk.parent_object_id) + '].[' + OBJECT_NAME(fk.parent_object_id) + '] DROP CONSTRAINT [' + fk.name + '];' + CHAR(13)
FROM sys.foreign_keys fk
INNER JOIN sys.tables t ON fk.referenced_object_id = t.object_id
WHERE t.name = 'Products';

IF LEN(@sql) > 0
BEGIN
    PRINT 'Dropping FK constraints that reference Products table:';
    PRINT @sql;
    EXEC sp_executesql @sql;
    PRINT 'All FK constraints to Products table dropped successfully!';
END
ELSE
BEGIN
    PRINT 'No FK constraints found referencing Products table.';
END

-- Check for orphaned records in Retail_Variant
SELECT 'Orphaned Retail_Variant records:' AS Info, COUNT(*) AS Count
FROM dbo.Retail_Variant rv
LEFT JOIN dbo.Demo_Retail_Product p ON p.ProductID = rv.ProductID
WHERE p.ProductID IS NULL;

-- Recreate FK on Retail_Variant to Demo_Retail_Product (if it doesn't exist)
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Retail_Variant_Demo_Retail_Product')
BEGIN
    ALTER TABLE dbo.Retail_Variant WITH NOCHECK
    ADD CONSTRAINT FK_Retail_Variant_Demo_Retail_Product
    FOREIGN KEY (ProductID) REFERENCES dbo.Demo_Retail_Product(ProductID);
    PRINT 'Created FK_Retail_Variant_Demo_Retail_Product';
END
ELSE
BEGIN
    PRINT 'FK_Retail_Variant_Demo_Retail_Product already exists - skipping';
END

-- Retail_Stock references VariantID, so it should be fine once Retail_Variant FK is fixed
PRINT 'Foreign keys updated successfully!';
