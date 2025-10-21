-- Update Supplier table to add missing columns for credit note functionality
-- Run this script to add ContactPerson and Phone columns if they don't exist

-- Check if ContactPerson column exists, if not add it
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'ContactPerson')
BEGIN
    ALTER TABLE Suppliers ADD ContactPerson NVARCHAR(100) NULL
    PRINT 'Added ContactPerson column to Suppliers table'
END
ELSE
BEGIN
    PRINT 'ContactPerson column already exists in Suppliers table'
END

-- Check if Phone column exists, if not add it
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'Phone')
BEGIN
    ALTER TABLE Suppliers ADD Phone NVARCHAR(50) NULL
    PRINT 'Added Phone column to Suppliers table'
END
ELSE
BEGIN
    PRINT 'Phone column already exists in Suppliers table'
END

-- Update existing suppliers with default values if needed
UPDATE Suppliers 
SET ContactPerson = 'N/A' 
WHERE ContactPerson IS NULL

UPDATE Suppliers 
SET Phone = 'N/A' 
WHERE Phone IS NULL

PRINT 'Supplier table update completed successfully'
