-- Fix the price sync issue between ERP and POS

PRINT '=== Step 1: Check what vw_POS_Products returns for BC Chocolate Gateaux ==='
SELECT 
    ProductID,
    ItemCode,
    ProductName,
    SellingPrice,
    QtyOnHand,
    BranchID
FROM vw_POS_Products
WHERE ProductName LIKE '%Chocolate Gateaux%'
  AND ItemCode LIKE '%BC%'
  AND BranchID = 6

PRINT ''
PRINT '=== Step 2: Check if view definition is correct ==='
EXEC sp_helptext 'vw_POS_Products'

PRINT ''
PRINT '=== Step 3: Manually insert price record for BC Chocolate Gateaux ==='
-- Get the ProductID
DECLARE @ProductID INT
SELECT @ProductID = ProductID 
FROM Demo_Retail_Product 
WHERE Name LIKE '%Chocolate Gateaux%' 
  AND SKU LIKE '%BC%'
  AND BranchID = 6

IF @ProductID IS NOT NULL
BEGIN
    PRINT 'ProductID found: ' + CAST(@ProductID AS VARCHAR)
    
    -- Insert/Update price record
    IF EXISTS (SELECT 1 FROM Demo_Retail_Price WHERE ProductID = @ProductID AND BranchID = 6)
    BEGIN
        UPDATE Demo_Retail_Price 
        SET SellingPrice = 200.00,
            EffectiveFrom = GETDATE()
        WHERE ProductID = @ProductID AND BranchID = 6
        PRINT '✓ Updated existing price to R 200.00'
    END
    ELSE
    BEGIN
        INSERT INTO Demo_Retail_Price (ProductID, BranchID, SellingPrice, CostPrice, EffectiveFrom, CreatedAt)
        VALUES (@ProductID, 6, 200.00, 0, GETDATE(), GETDATE())
        PRINT '✓ Inserted new price record at R 200.00'
    END
    
    PRINT ''
    PRINT '=== Step 4: Verify the fix ==='
    SELECT 
        ProductID,
        ItemCode,
        ProductName,
        SellingPrice,
        QtyOnHand,
        BranchID
    FROM vw_POS_Products
    WHERE ProductID = @ProductID
      AND BranchID = 6
    
    PRINT ''
    PRINT 'Price should now show R 200.00 on POS!'
END
ELSE
BEGIN
    PRINT 'ERROR: BC Chocolate Gateaux not found in Demo_Retail_Product for BranchID 6'
END
