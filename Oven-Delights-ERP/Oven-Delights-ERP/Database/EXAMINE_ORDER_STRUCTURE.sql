-- Examine POS_CustomOrders structure
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'POS_CustomOrders'
ORDER BY ORDINAL_POSITION;

-- Check how deposits are recorded in Demo_Sales
SELECT TOP 5
    SaleID,
    InvoiceNumber,
    BranchID,
    TotalAmount,
    PaymentMethod,
    SaleType,
    SaleDate,
    CashierID
FROM Demo_Sales
WHERE SaleType = 'OrderDeposit'
ORDER BY SaleDate DESC;

-- Check for Cancellation Fee product
SELECT 
    ProductID,
    Name,
    Category,
    ProductType
FROM Demo_Retail_Product
WHERE Name LIKE '%cancellation%' OR Name LIKE '%cancel%'
ORDER BY Name;

-- Sample order with deposit
SELECT TOP 1
    o.OrderID,
    o.OrderNumber,
    o.CustomerName,
    o.DepositAmount,
    o.TotalAmount,
    o.OrderStatus,
    o.BranchID,
    s.PaymentMethod,
    s.SaleID,
    s.TotalAmount AS DepositPaid
FROM POS_CustomOrders o
LEFT JOIN Demo_Sales s ON s.InvoiceNumber = o.OrderNumber AND s.SaleType = 'OrderDeposit'
WHERE o.OrderStatus IN ('New', 'Ready')
ORDER BY o.OrderDate DESC;
