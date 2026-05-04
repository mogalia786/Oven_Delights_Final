-- Add Discount columns to SupplierInvoices table
-- This allows tracking both discount amount (in Rand) and discount percentage

USE [OvenDelightsERP]
GO

-- Check if DiscountAmount column exists, if not add it
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'SupplierInvoices' 
               AND COLUMN_NAME = 'DiscountAmount')
BEGIN
    ALTER TABLE dbo.SupplierInvoices
    ADD DiscountAmount DECIMAL(18,4) NULL DEFAULT 0;
    PRINT 'Added DiscountAmount column to SupplierInvoices';
END
ELSE
BEGIN
    PRINT 'DiscountAmount column already exists in SupplierInvoices';
END
GO

-- Check if DiscountPercent column exists, if not add it
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'SupplierInvoices' 
               AND COLUMN_NAME = 'DiscountPercent')
BEGIN
    ALTER TABLE dbo.SupplierInvoices
    ADD DiscountPercent DECIMAL(5,2) NULL DEFAULT 0;
    PRINT 'Added DiscountPercent column to SupplierInvoices';
END
ELSE
BEGIN
    PRINT 'DiscountPercent column already exists in SupplierInvoices';
END
GO

-- Update existing records to have 0 discount if NULL
UPDATE dbo.SupplierInvoices
SET DiscountAmount = 0
WHERE DiscountAmount IS NULL;

UPDATE dbo.SupplierInvoices
SET DiscountPercent = 0
WHERE DiscountPercent IS NULL;
GO

PRINT 'Discount columns added successfully to SupplierInvoices table';
GO
