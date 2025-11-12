-- =============================================
-- QUICK CHECK: Verify Retail Stock After Completing Product
-- =============================================
-- Run this after completing a product to verify it updated correctly
-- =============================================

PRINT '🔍 Quick Retail Stock Check...';
PRINT '';

-- Check RetailStock table
PRINT '1️⃣ RetailStock Table:';
SELECT 
    rs.RetailStockID,
    p.ProductName,
    p.SKU,
    rs.Quantity,
    rs.StockType,
    b.BranchName,
    rs.LastUpdated,
    rs.UpdatedBy
FROM RetailStock rs
INNER JOIN Products p ON rs.ProductID = p.ProductID
LEFT JOIN Branches b ON rs.BranchID = b.BranchID
WHERE rs.StockType = 'Internal'
ORDER BY rs.LastUpdated DESC;

PRINT '';

-- Check Products.CurrentStock (if exists)
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'CurrentStock')
BEGIN
    PRINT '2️⃣ Products.CurrentStock:';
    SELECT 
        ProductID,
        ProductName,
        SKU,
        CurrentStock,
        ProductType
    FROM Products
    WHERE ProductType = 'Internal' AND CurrentStock > 0
    ORDER BY ProductID DESC;
END
ELSE
    PRINT '2️⃣ Products.CurrentStock column does not exist';

PRINT '';

-- Check latest StockMovements
PRINT '3️⃣ Latest Stock Movements (Production Complete):';
SELECT TOP 5
    sm.MovementDate,
    p.ProductName,
    sm.QuantityIn,
    sm.BalanceAfter,
    sm.ReferenceNumber,
    u.FirstName + ' ' + u.LastName AS CompletedBy
FROM StockMovements sm
INNER JOIN Products p ON sm.MaterialID = p.ProductID
LEFT JOIN Users u ON sm.CreatedBy = u.UserID
WHERE sm.MovementType = 'Production Complete'
ORDER BY sm.MovementID DESC;

PRINT '';
PRINT '✅ Check complete!';
