-- Add ModifiedDate column to POS_CustomOrders if it doesn't exist

IF NOT EXISTS (
    SELECT * FROM sys.columns 
    WHERE object_id = OBJECT_ID('POS_CustomOrders') 
    AND name = 'ModifiedDate'
)
BEGIN
    ALTER TABLE POS_CustomOrders
    ADD ModifiedDate DATETIME NULL CONSTRAINT DF_POS_CustomOrders_ModifiedDate DEFAULT GETDATE();
    
    PRINT 'ModifiedDate column added to POS_CustomOrders';
END
ELSE
BEGIN
    PRINT 'ModifiedDate column already exists in POS_CustomOrders';
END
GO
