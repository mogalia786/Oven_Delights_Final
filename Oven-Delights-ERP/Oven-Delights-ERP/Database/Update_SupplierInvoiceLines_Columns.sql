-- Add missing columns to SupplierInvoiceLines table for Edit Invoice functionality
-- This script is idempotent and can be run multiple times safely

USE OvenDelightsERP
GO

-- Add LineNumber column if it doesn't exist
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.SupplierInvoiceLines') AND name = 'LineNumber')
BEGIN
    ALTER TABLE dbo.SupplierInvoiceLines
    ADD LineNumber INT NULL
    
    PRINT 'Added LineNumber column to SupplierInvoiceLines'
END
ELSE
BEGIN
    PRINT 'LineNumber column already exists in SupplierInvoiceLines'
END
GO

-- Add ProductCode column if it doesn't exist
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.SupplierInvoiceLines') AND name = 'ProductCode')
BEGIN
    ALTER TABLE dbo.SupplierInvoiceLines
    ADD ProductCode NVARCHAR(50) NULL
    
    PRINT 'Added ProductCode column to SupplierInvoiceLines'
END
ELSE
BEGIN
    PRINT 'ProductCode column already exists in SupplierInvoiceLines'
END
GO

-- Add ProductName column if it doesn't exist
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.SupplierInvoiceLines') AND name = 'ProductName')
BEGIN
    ALTER TABLE dbo.SupplierInvoiceLines
    ADD ProductName NVARCHAR(200) NULL
    
    PRINT 'Added ProductName column to SupplierInvoiceLines'
END
ELSE
BEGIN
    PRINT 'ProductName column already exists in SupplierInvoiceLines'
END
GO

-- Add UnitPrice column if it doesn't exist (rename from UnitCost)
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.SupplierInvoiceLines') AND name = 'UnitPrice')
BEGIN
    -- Check if UnitCost exists and rename it
    IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.SupplierInvoiceLines') AND name = 'UnitCost')
    BEGIN
        EXEC sp_rename 'dbo.SupplierInvoiceLines.UnitCost', 'UnitPrice', 'COLUMN'
        PRINT 'Renamed UnitCost to UnitPrice in SupplierInvoiceLines'
    END
    ELSE
    BEGIN
        ALTER TABLE dbo.SupplierInvoiceLines
        ADD UnitPrice DECIMAL(18,4) NULL
        PRINT 'Added UnitPrice column to SupplierInvoiceLines'
    END
END
ELSE
BEGIN
    PRINT 'UnitPrice column already exists in SupplierInvoiceLines'
END
GO

-- Update LineNumber for existing records (if any exist without line numbers)
UPDATE dbo.SupplierInvoiceLines
SET LineNumber = ROW_NUMBER() OVER (PARTITION BY InvoiceID ORDER BY InvoiceLineID)
WHERE LineNumber IS NULL
GO

PRINT 'SupplierInvoiceLines table updated successfully'
GO
