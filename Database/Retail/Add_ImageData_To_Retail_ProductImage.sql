-- Adds ImageData VARBINARY(MAX) to dbo.Retail_ProductImage if it does not exist
SET NOCOUNT ON;

IF COL_LENGTH('dbo.Retail_ProductImage','ImageData') IS NULL
BEGIN
    ALTER TABLE dbo.Retail_ProductImage
        ADD ImageData VARBINARY(MAX) NULL;
END;

PRINT 'Checked/added ImageData column on dbo.Retail_ProductImage.';
