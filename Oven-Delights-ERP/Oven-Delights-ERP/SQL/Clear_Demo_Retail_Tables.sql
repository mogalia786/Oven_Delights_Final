-- =====================================================
-- Clear Demo_Retail Tables Safely
-- =====================================================
-- This script clears all Demo_Retail data in the correct order
-- to avoid foreign key constraint violations

PRINT 'Starting to clear Demo_Retail tables...';
GO

-- Note: We'll delete in correct order instead of disabling constraints
-- Azure SQL Database doesn't support sp_MSforeachtable

-- Delete from child tables first
PRINT 'Deleting from Demo_Retail_Stock...';
DELETE FROM Demo_Retail_Stock;
PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' rows deleted from Demo_Retail_Stock.';
GO

PRINT 'Deleting from Demo_Retail_Price...';
DELETE FROM Demo_Retail_Price;
PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' rows deleted from Demo_Retail_Price.';
GO

PRINT 'Deleting from Demo_Retail_Variant...';
DELETE FROM Demo_Retail_Variant;
PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' rows deleted from Demo_Retail_Variant.';
GO

-- Delete from related tables if they exist
IF OBJECT_ID('Demo_ReturnDetails', 'U') IS NOT NULL
BEGIN
    PRINT 'Deleting from Demo_ReturnDetails...';
    DELETE FROM Demo_ReturnDetails;
    PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' rows deleted from Demo_ReturnDetails.';
END
GO

IF OBJECT_ID('Demo_Retail_ProductImage', 'U') IS NOT NULL
BEGIN
    PRINT 'Deleting from Demo_Retail_ProductImage...';
    DELETE FROM Demo_Retail_ProductImage;
    PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' rows deleted from Demo_Retail_ProductImage.';
END
GO

IF OBJECT_ID('POS_InvoiceLines', 'U') IS NOT NULL
BEGIN
    PRINT 'Deleting from POS_InvoiceLines (Demo_Retail products only)...';
    DELETE FROM POS_InvoiceLines 
    WHERE ProductID IN (SELECT ProductID FROM Demo_Retail_Product);
    PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' rows deleted from POS_InvoiceLines.';
END
GO

IF OBJECT_ID('ReturnLineItems', 'U') IS NOT NULL
BEGIN
    PRINT 'Deleting from ReturnLineItems (Demo_Retail products only)...';
    DELETE FROM ReturnLineItems 
    WHERE ProductID IN (SELECT ProductID FROM Demo_Retail_Product);
    PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' rows deleted from ReturnLineItems.';
END
GO

-- Skip Demo_Sales - it has FK dependencies with Invoices table
-- Demo_Sales is not part of Demo_Retail product data anyway

-- Finally delete from parent table
PRINT 'Deleting from Demo_Retail_Product...';
DELETE FROM Demo_Retail_Product;
PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' rows deleted from Demo_Retail_Product.';
GO

-- Constraints remain enabled (we deleted in correct order)

PRINT '';
PRINT '========================================';
PRINT 'Demo_Retail tables cleared successfully!';
PRINT '========================================';
GO

-- Show current counts
SELECT 'Demo_Retail_Product' AS TableName, COUNT(*) AS [RowCount] FROM Demo_Retail_Product
UNION ALL
SELECT 'Demo_Retail_Variant', COUNT(*) FROM Demo_Retail_Variant
UNION ALL
SELECT 'Demo_Retail_Price', COUNT(*) FROM Demo_Retail_Price
UNION ALL
SELECT 'Demo_Retail_Stock', COUNT(*) FROM Demo_Retail_Stock;
GO
