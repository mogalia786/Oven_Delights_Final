-- =============================================
-- Add BranchID to AP_Invoices Table
-- =============================================
-- BranchID is critical for multi-branch operations
-- =============================================

USE OvenDelightsERP
GO

PRINT 'Adding BranchID to AP_Invoices table...'
GO

-- Check if BranchID column already exists
IF NOT EXISTS (
    SELECT 1 
    FROM sys.columns 
    WHERE object_id = OBJECT_ID('AP_Invoices') 
    AND name = 'BranchID'
)
BEGIN
    -- Add BranchID column
    ALTER TABLE AP_Invoices
    ADD BranchID INT NOT NULL DEFAULT 1
    
    PRINT '  ✓ BranchID column added to AP_Invoices'
    
    -- Add foreign key constraint if Branches table exists
    IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Branches')
    BEGIN
        ALTER TABLE AP_Invoices
        ADD CONSTRAINT FK_Invoice_Branch FOREIGN KEY (BranchID) 
            REFERENCES Branches(BranchID)
        
        PRINT '  ✓ Foreign key constraint added'
    END
    ELSE
    BEGIN
        PRINT '  ⚠ Warning: Branches table not found. Foreign key not created.'
    END
    
    -- Create index for better query performance
    CREATE INDEX IX_AP_Invoices_Branch ON AP_Invoices(BranchID)
    PRINT '  ✓ Index created on BranchID'
    
    PRINT ''
    PRINT 'BranchID successfully added to AP_Invoices table'
    PRINT ''
    PRINT 'IMPORTANT: Update existing invoices to set correct BranchID'
    PRINT 'Example: UPDATE AP_Invoices SET BranchID = {CorrectBranchID} WHERE BranchID = 1'
END
ELSE
BEGIN
    PRINT '  ✓ BranchID column already exists in AP_Invoices'
END
GO

-- Verify the change
SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length AS MaxLength,
    c.is_nullable AS IsNullable
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('AP_Invoices')
AND c.name = 'BranchID'
GO

PRINT 'Verification complete'
GO
