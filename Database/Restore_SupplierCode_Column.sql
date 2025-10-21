-- =============================================
-- Restore SupplierCode Column to Suppliers Table
-- =============================================

PRINT 'Restoring SupplierCode column to Suppliers table...';
PRINT '';

-- Check if column does NOT exist
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('Suppliers') AND name = 'SupplierCode')
BEGIN
    -- Add the column back
    ALTER TABLE dbo.Suppliers ADD SupplierCode NVARCHAR(50) NULL;
    PRINT '✓ Added SupplierCode column';
    
    -- Generate SupplierCode for existing suppliers (use CompanyName or SupplierID)
    UPDATE Suppliers 
    SET SupplierCode = 'SUP' + RIGHT('00000' + CAST(SupplierID AS VARCHAR), 5)
    WHERE SupplierCode IS NULL;
    PRINT '✓ Generated SupplierCode for existing suppliers';
    
    -- Create unique index on SupplierCode
    CREATE UNIQUE INDEX IX_Suppliers_SupplierCode ON Suppliers(SupplierCode) WHERE SupplierCode IS NOT NULL;
    PRINT '✓ Created unique index on SupplierCode';
END
ELSE
BEGIN
    PRINT '- SupplierCode column already exists';
END

PRINT '';
PRINT '========================================';
PRINT 'SupplierCode column restored!';
PRINT '========================================';
