-- Add PaperHeight column to PrinterConfig table if it doesn't exist

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'PrinterConfig' AND COLUMN_NAME = 'PaperHeight')
BEGIN
    ALTER TABLE PrinterConfig
    ADD PaperHeight INT NOT NULL DEFAULT 215 -- mm (215mm height for continuous paper)
    
    PRINT 'PaperHeight column added to PrinterConfig table'
END
ELSE
BEGIN
    PRINT 'PaperHeight column already exists in PrinterConfig table'
END
GO

-- Update existing records to have 215mm height
UPDATE PrinterConfig
SET PaperHeight = 215
WHERE PaperHeight IS NULL OR PaperHeight = 0

PRINT 'Updated existing PrinterConfig records with PaperHeight = 215mm'
GO
