-- =============================================
-- Add ItemCode and ItemName to CreditNoteLines
-- These fields are crucial for reporting and display
-- =============================================

-- Check if columns already exist before adding
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.CreditNoteLines') AND name = 'ItemCode')
BEGIN
    ALTER TABLE dbo.CreditNoteLines
    ADD ItemCode NVARCHAR(50) NULL;
    
    PRINT 'Added ItemCode column to CreditNoteLines';
END
ELSE
BEGIN
    PRINT 'ItemCode column already exists in CreditNoteLines';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.CreditNoteLines') AND name = 'ItemName')
BEGIN
    ALTER TABLE dbo.CreditNoteLines
    ADD ItemName NVARCHAR(200) NULL;
    
    PRINT 'Added ItemName column to CreditNoteLines';
END
ELSE
BEGIN
    PRINT 'ItemName column already exists in CreditNoteLines';
END

-- Update existing records with ItemCode and ItemName from RawMaterials
-- Only update if MaterialID exists (for raw materials)
UPDATE cnl
SET 
    cnl.ItemCode = rm.MaterialCode,
    cnl.ItemName = rm.MaterialName
FROM dbo.CreditNoteLines cnl
INNER JOIN dbo.RawMaterials rm ON cnl.MaterialID = rm.MaterialID
WHERE cnl.MaterialID IS NOT NULL
  AND (cnl.ItemCode IS NULL OR cnl.ItemName IS NULL);

PRINT 'Updated existing CreditNoteLines with ItemCode and ItemName from RawMaterials';

-- Note: If you have ProductID column and Products table, uncomment below:
-- UPDATE cnl
-- SET 
--     cnl.ItemCode = p.ProductCode,
--     cnl.ItemName = p.ProductName
-- FROM dbo.CreditNoteLines cnl
-- INNER JOIN dbo.Products p ON cnl.ProductID = p.ProductID
-- WHERE cnl.ProductID IS NOT NULL
--   AND (cnl.ItemCode IS NULL OR cnl.ItemName IS NULL);
-- 
-- PRINT 'Updated existing CreditNoteLines with ItemCode and ItemName from Products';

PRINT '';
PRINT '========================================';
PRINT 'CreditNoteLines table updated successfully';
PRINT 'ItemCode and ItemName columns added';
PRINT 'Existing records populated';
PRINT '========================================';
GO
