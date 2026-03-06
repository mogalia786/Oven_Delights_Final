-- =============================================
-- Add BranchID column to AP_PaymentBatches table
-- =============================================

SET NOCOUNT ON;
GO

PRINT 'Checking if BranchID column exists in AP_PaymentBatches...';
GO

-- Check if column already exists
IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'AP_PaymentBatches' 
    AND COLUMN_NAME = 'BranchID'
)
BEGIN
    PRINT 'Adding BranchID column to AP_PaymentBatches...';
    
    ALTER TABLE AP_PaymentBatches
    ADD BranchID INT NULL;
    
    PRINT '✓ BranchID column added successfully';
    
    -- Add foreign key constraint if Branches table exists
    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Branches')
    BEGIN
        PRINT 'Adding foreign key constraint to Branches table...';
        
        ALTER TABLE AP_PaymentBatches
        ADD CONSTRAINT FK_AP_PaymentBatches_Branches 
        FOREIGN KEY (BranchID) REFERENCES Branches(BranchID);
        
        PRINT '✓ Foreign key constraint added';
    END
    ELSE
    BEGIN
        PRINT '⚠ Branches table not found - skipping foreign key constraint';
    END
END
ELSE
BEGIN
    PRINT '✓ BranchID column already exists';
END
GO

PRINT '';
PRINT 'Verifying table structure...';
GO

-- Show table structure
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'AP_PaymentBatches'
ORDER BY ORDINAL_POSITION;
GO

PRINT '';
PRINT '========================================';
PRINT 'Script completed successfully!';
PRINT '========================================';
GO
