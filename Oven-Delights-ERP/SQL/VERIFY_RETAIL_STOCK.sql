-- =============================================
-- VERIFY RETAIL STOCK UPDATES
-- =============================================
-- This script checks if completed products are updating retail stock correctly
-- =============================================

PRINT '🔍 Checking Retail Stock Updates...';
PRINT '';

-- =============================================
-- STEP 1: Check StockMovements for Production Complete entries
-- =============================================
PRINT '1️⃣ Checking StockMovements for Production Complete:';
SELECT TOP 10
    sm.MovementID,
    sm.MovementDate,
    sm.MaterialID,
    p.ProductName,
    sm.MovementType,
    sm.QuantityIn,
    sm.BalanceAfter,
    sm.InventoryArea,
    sm.ReferenceType,
    sm.ReferenceNumber,
    sm.CreatedBy,
    u.FirstName + ' ' + u.LastName AS CreatedByName
FROM StockMovements sm
LEFT JOIN Products p ON sm.MaterialID = p.ProductID
LEFT JOIN Users u ON sm.CreatedBy = u.UserID
WHERE sm.MovementType = 'Production Complete'
ORDER BY sm.MovementID DESC;

IF @@ROWCOUNT = 0
BEGIN
    PRINT '❌ NO Production Complete movements found!';
    PRINT '   This means sp_CompleteReOrderProduct is not creating stock movements.';
END
ELSE
BEGIN
    PRINT '✅ Production Complete movements found';
END

PRINT '';

-- =============================================
-- STEP 2: Check what retail stock tables exist
-- =============================================
PRINT '2️⃣ Checking which retail stock tables exist:';

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Retail_Stock')
    PRINT '✅ Retail_Stock table exists';
ELSE
    PRINT '❌ Retail_Stock table does NOT exist';

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Products_Inventory')
    PRINT '✅ Products_Inventory table exists';
ELSE
    PRINT '❌ Products_Inventory table does NOT exist';

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Products')
BEGIN
    PRINT '✅ Products table exists';
    
    -- Check if Products table has stock columns
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'CurrentStock')
        PRINT '   ✅ Products.CurrentStock column exists';
    ELSE
        PRINT '   ❌ Products.CurrentStock column does NOT exist';
        
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'StockOnHand')
        PRINT '   ✅ Products.StockOnHand column exists';
    ELSE
        PRINT '   ❌ Products.StockOnHand column does NOT exist';
END

PRINT '';

-- =============================================
-- STEP 3: Check Retail_Stock table (if exists)
-- =============================================
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Retail_Stock')
BEGIN
    PRINT '3️⃣ Checking Retail_Stock table:';
    
    EXEC('
    SELECT TOP 10
        rs.*,
        p.ProductName
    FROM Retail_Stock rs
    LEFT JOIN Products p ON rs.ProductID = p.ProductID
    ORDER BY rs.LastUpdated DESC;
    ');
    
    IF @@ROWCOUNT = 0
        PRINT '⚠️  Retail_Stock table is EMPTY';
    ELSE
        PRINT '✅ Retail_Stock has data';
END
ELSE
BEGIN
    PRINT '3️⃣ Retail_Stock table does not exist - skipping';
END

PRINT '';

-- =============================================
-- STEP 4: Check Products table stock levels
-- =============================================
PRINT '4️⃣ Checking Products table stock levels:';

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'CurrentStock')
BEGIN
    SELECT TOP 10
        ProductID,
        ProductName,
        SKU,
        CurrentStock,
        ProductType
    FROM Products
    WHERE ProductType = 'Internal'
    ORDER BY ProductID DESC;
    
    PRINT '';
    PRINT 'Summary of Internal Products:';
    SELECT 
        COUNT(*) AS TotalInternalProducts,
        SUM(CASE WHEN CurrentStock > 0 THEN 1 ELSE 0 END) AS ProductsWithStock,
        SUM(CASE WHEN CurrentStock = 0 THEN 1 ELSE 0 END) AS ProductsWithZeroStock
    FROM Products
    WHERE ProductType = 'Internal';
END
ELSE IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'StockOnHand')
BEGIN
    SELECT TOP 10
        ProductID,
        ProductName,
        SKU,
        StockOnHand,
        ProductType
    FROM Products
    WHERE ProductType = 'Internal'
    ORDER BY ProductID DESC;
    
    PRINT '';
    PRINT 'Summary of Internal Products:';
    SELECT 
        COUNT(*) AS TotalInternalProducts,
        SUM(CASE WHEN StockOnHand > 0 THEN 1 ELSE 0 END) AS ProductsWithStock,
        SUM(CASE WHEN StockOnHand = 0 THEN 1 ELSE 0 END) AS ProductsWithZeroStock
    FROM Products
    WHERE ProductType = 'Internal';
END
ELSE
BEGIN
    PRINT '❌ Products table has NO stock columns!';
    PRINT '   Stock is likely tracked in a separate table.';
END

PRINT '';

-- =============================================
-- STEP 5: Check ReOrderBookLines completion status
-- =============================================
PRINT '5️⃣ Checking ReOrderBookLines completion:';

SELECT TOP 10
    rol.ReOrderLineID,
    rob.ReOrderNumber,
    rol.ProductName,
    rol.QuantityOrdered,
    rol.QuantityCompleted,
    rol.LineStatus,
    rol.CompletedBy,
    rol.CompletedDate,
    rol.RetailStockUpdated,
    rol.RetailStockUpdateDate
FROM ReOrderBookLines rol
INNER JOIN ReOrderBooks rob ON rol.ReOrderBookID = rob.ReOrderBookID
WHERE rol.LineStatus = 'Completed'
ORDER BY rol.CompletedDate DESC;

IF @@ROWCOUNT = 0
BEGIN
    PRINT '❌ NO completed re-order book lines found!';
    PRINT '   Have you completed any products yet?';
END
ELSE
BEGIN
    PRINT '✅ Completed re-order book lines found';
    
    -- Check if RetailStockUpdated flag is set
    DECLARE @NotUpdated INT;
    SELECT @NotUpdated = COUNT(*)
    FROM ReOrderBookLines
    WHERE LineStatus = 'Completed' AND (RetailStockUpdated IS NULL OR RetailStockUpdated = 0);
    
    IF @NotUpdated > 0
    BEGIN
        PRINT '⚠️  WARNING: ' + CAST(@NotUpdated AS NVARCHAR) + ' completed lines have RetailStockUpdated = 0 or NULL';
        PRINT '   This means the stock update may have failed.';
    END
END

PRINT '';

-- =============================================
-- STEP 6: Cross-check: Completed products vs Stock Movements
-- =============================================
PRINT '6️⃣ Cross-checking completed products with stock movements:';

SELECT 
    rol.ProductID,
    rol.ProductName,
    rol.QuantityCompleted,
    rol.CompletedDate,
    sm.MovementID,
    sm.QuantityIn AS StockMovementQty,
    sm.BalanceAfter,
    CASE 
        WHEN sm.MovementID IS NULL THEN '❌ NO STOCK MOVEMENT'
        WHEN rol.QuantityCompleted <> sm.QuantityIn THEN '⚠️  QUANTITY MISMATCH'
        ELSE '✅ OK'
    END AS Status
FROM ReOrderBookLines rol
LEFT JOIN StockMovements sm ON 
    sm.MaterialID = rol.ProductID 
    AND sm.MovementType = 'Production Complete'
    AND CAST(sm.MovementDate AS DATE) = CAST(rol.CompletedDate AS DATE)
WHERE rol.LineStatus = 'Completed'
ORDER BY rol.CompletedDate DESC;

PRINT '';

-- =============================================
-- STEP 7: Check if there's a separate retail stock view or procedure
-- =============================================
PRINT '7️⃣ Checking for retail stock views/procedures:';

IF EXISTS (SELECT * FROM sys.views WHERE name LIKE '%Retail%Stock%')
BEGIN
    SELECT name AS ViewName
    FROM sys.views
    WHERE name LIKE '%Retail%Stock%';
    PRINT '✅ Found retail stock views';
END
ELSE
    PRINT '❌ No retail stock views found';

IF EXISTS (SELECT * FROM sys.procedures WHERE name LIKE '%Retail%Stock%')
BEGIN
    SELECT name AS ProcedureName
    FROM sys.procedures
    WHERE name LIKE '%Retail%Stock%';
    PRINT '✅ Found retail stock procedures';
END
ELSE
    PRINT '❌ No retail stock procedures found';

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '📋 DIAGNOSIS SUMMARY:';
PRINT '';
PRINT 'Check the results above to identify the issue:';
PRINT '';
PRINT '1. If NO Production Complete movements → sp_CompleteReOrderProduct not working';
PRINT '2. If movements exist but stock is 0 → Need to update Products table directly';
PRINT '3. If Retail_Stock table exists → Need to update that table too';
PRINT '4. If Products has no stock columns → Stock tracked elsewhere';
PRINT '';
PRINT '💡 SOLUTION:';
PRINT 'Based on the results, you may need to:';
PRINT '- Update sp_CompleteReOrderProduct to also update Products.CurrentStock';
PRINT '- Update sp_CompleteReOrderProduct to also update Retail_Stock table';
PRINT '- Create a trigger to sync StockMovements → Products';
PRINT '═══════════════════════════════════════════════';
