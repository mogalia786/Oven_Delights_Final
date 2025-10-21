-- Add OrderType field to POS_CustomOrders table
-- Distinguishes between 'Order' (general bakery items) and 'Cake' (custom cakes)

IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'POS_CustomOrders' 
    AND COLUMN_NAME = 'OrderType'
)
BEGIN
    ALTER TABLE POS_CustomOrders
    ADD OrderType VARCHAR(20) NOT NULL DEFAULT 'Order'
    CONSTRAINT CHK_OrderType CHECK (OrderType IN ('Order', 'Cake'));
    
    PRINT 'OrderType column added successfully';
END
ELSE
BEGIN
    PRINT 'OrderType column already exists';
END
GO

-- Add ManufacturingInstructions field to POS_CustomOrders table
-- Stores detailed specifications for custom cake orders

IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'POS_CustomOrders' 
    AND COLUMN_NAME = 'ManufacturingInstructions'
)
BEGIN
    ALTER TABLE POS_CustomOrders
    ADD ManufacturingInstructions NVARCHAR(MAX) NULL;
    
    PRINT 'ManufacturingInstructions column added successfully';
END
ELSE
BEGIN
    PRINT 'ManufacturingInstructions column already exists';
END
GO

-- Add BranchName field to POS_CustomOrders table
-- Stores branch name for display on receipts

IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'POS_CustomOrders' 
    AND COLUMN_NAME = 'BranchName'
)
BEGIN
    ALTER TABLE POS_CustomOrders
    ADD BranchName NVARCHAR(100) NULL;
    
    PRINT 'BranchName column added successfully';
END
ELSE
BEGIN
    PRINT 'BranchName column already exists';
END
GO

-- Add CreatedBy field to POS_CustomOrders table
-- Stores cashier name who created the order

IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'POS_CustomOrders' 
    AND COLUMN_NAME = 'CreatedBy'
)
BEGIN
    ALTER TABLE POS_CustomOrders
    ADD CreatedBy NVARCHAR(100) NULL;
    
    PRINT 'CreatedBy column added successfully';
END
ELSE
BEGIN
    PRINT 'CreatedBy column already exists';
END
GO

-- Update existing orders based on order number pattern
UPDATE POS_CustomOrders
SET OrderType = CASE 
    WHEN OrderNumber LIKE '%-CCAKE-%' THEN 'Cake'
    WHEN OrderNumber LIKE '%-CAKE-%' THEN 'Cake'
    WHEN OrderNumber LIKE 'CAKE%' THEN 'Cake'
    ELSE 'Order'
END
WHERE OrderType IS NULL OR OrderType = 'Order';

PRINT 'Existing orders updated based on order number pattern';
GO

-- Show what we have
SELECT 
    OrderNumber, 
    OrderType, 
    OrderStatus,
    CustomerName,
    CONVERT(VARCHAR, ReadyDate, 106) AS ReadyDate
FROM POS_CustomOrders
ORDER BY OrderDate DESC;
GO

-- Note: Order number formats:
-- General Orders: O-BranchPrefix-000001 (OrderType='Order')
-- Custom Cake Orders: O-BranchPrefix-CCAKE-000001 (OrderType='Cake')
GO
