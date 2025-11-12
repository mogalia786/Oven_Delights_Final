-- Check actual table schemas to fix stored procedures

-- Check Inventory table structure
SELECT 'Inventory Table' AS TableName, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Inventory'
ORDER BY ORDINAL_POSITION;

-- Check Products table structure
SELECT 'Products Table' AS TableName, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Products'
ORDER BY ORDINAL_POSITION;

-- Check ManufacturingOrders table structure
SELECT 'ManufacturingOrders Table' AS TableName, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ManufacturingOrders'
ORDER BY ORDINAL_POSITION;

-- Check StockMovements table structure
SELECT 'StockMovements Table' AS TableName, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'StockMovements'
ORDER BY ORDINAL_POSITION;

-- Check Transactions table structure
SELECT 'Transactions Table' AS TableName, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Transactions'
ORDER BY ORDINAL_POSITION;

-- Check TransactionDetails table structure
SELECT 'TransactionDetails Table' AS TableName, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'TransactionDetails'
ORDER BY ORDINAL_POSITION;

-- Check PurchaseOrders table structure
SELECT 'PurchaseOrders Table' AS TableName, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'PurchaseOrders'
ORDER BY ORDINAL_POSITION;

-- Check SupplierInvoices table structure
SELECT 'SupplierInvoices Table' AS TableName, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SupplierInvoices'
ORDER BY ORDINAL_POSITION;
