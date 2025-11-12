-- Add FK constraint to Branches table
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys 
    WHERE name = 'FK_ContinuousPrinter_Branches' 
    AND parent_object_id = OBJECT_ID('dbo.ContinuousPrinterConfig')
)
BEGIN
    ALTER TABLE dbo.ContinuousPrinterConfig
    ADD CONSTRAINT FK_ContinuousPrinter_Branches 
    FOREIGN KEY (BranchID) REFERENCES dbo.Branches(BranchID);
    
    PRINT 'FK constraint added successfully';
END
ELSE
BEGIN
    PRINT 'FK constraint already exists';
END
GO
