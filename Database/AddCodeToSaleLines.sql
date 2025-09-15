-- Add Code field to Retail_SaleLines table to track product codes in sales
-- Run this after AddCodeFieldsToProducts.sql

-- Check if Retail_SaleLines table exists first
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Retail_SaleLines')
BEGIN
    -- Add Code field to Retail_SaleLines table
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Retail_SaleLines' AND COLUMN_NAME = 'Code')
    BEGIN
        ALTER TABLE dbo.Retail_SaleLines 
        ADD Code NVARCHAR(20) NULL
        
        PRINT 'Added Code field to Retail_SaleLines table'
    END
    ELSE
        PRINT 'Code field already exists in Retail_SaleLines table'

    -- Update existing sale lines with codes from products (if any exist)
    UPDATE sl 
    SET Code = p.Code
    FROM dbo.Retail_SaleLines sl
    INNER JOIN dbo.Retail_Product p ON p.ProductID = sl.ProductID
    WHERE sl.Code IS NULL AND p.Code IS NOT NULL

    PRINT 'Updated existing sale lines with product codes'
END
ELSE
BEGIN
    PRINT 'Retail_SaleLines table does not exist - skipping Code field addition'
    PRINT 'This table will be created automatically when first sale is processed'
END
