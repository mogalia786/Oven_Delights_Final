-- Add QtyCompleted column to POS_CustomOrderItems table
-- This tracks how many cakes have been manufactured for each order item

USE OvenDelightsDB
GO

-- Check if column already exists
IF NOT EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'POS_CustomOrderItems' 
    AND COLUMN_NAME = 'QtyCompleted'
)
BEGIN
    ALTER TABLE POS_CustomOrderItems
    ADD QtyCompleted INT NOT NULL DEFAULT 0;
    
    PRINT 'QtyCompleted column added to POS_CustomOrderItems table';
END
ELSE
BEGIN
    PRINT 'QtyCompleted column already exists in POS_CustomOrderItems table';
END
GO
