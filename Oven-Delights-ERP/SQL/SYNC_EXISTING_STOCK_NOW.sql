-- Sync the existing 20 units from Demo_Retail_Product.CurrentStock to Demo_Retail_Stock.QtyOnHand
-- This is for ProductID 56082 (Bar One Slice)

DECLARE @ProductID INT = 56082;
DECLARE @BranchID INT = 6;
DECLARE @CurrentStock DECIMAL(18,2);
DECLARE @VariantID INT;

-- Get current stock from Demo_Retail_Product
SELECT @CurrentStock = CurrentStock
FROM dbo.Demo_Retail_Product
WHERE ProductID = @ProductID AND BranchID = @BranchID;

-- Get or create VariantID from Demo_Retail_Variant
SELECT @VariantID = VariantID
FROM dbo.Demo_Retail_Variant
WHERE ProductID = @ProductID;

IF @VariantID IS NULL
BEGIN
    INSERT INTO dbo.Demo_Retail_Variant (ProductID) VALUES (@ProductID);
    SET @VariantID = SCOPE_IDENTITY();
    PRINT 'Created VariantID: ' + CAST(@VariantID AS VARCHAR);
END

-- Update or insert into Demo_Retail_Stock
IF EXISTS (SELECT 1 FROM dbo.Demo_Retail_Stock WHERE VariantID = @VariantID AND BranchID = @BranchID)
BEGIN
    UPDATE dbo.Demo_Retail_Stock
    SET QtyOnHand = @CurrentStock
    WHERE VariantID = @VariantID AND BranchID = @BranchID;
    PRINT 'Updated Demo_Retail_Stock.QtyOnHand to ' + CAST(@CurrentStock AS VARCHAR);
END
ELSE
BEGIN
    INSERT INTO dbo.Demo_Retail_Stock (VariantID, BranchID, QtyOnHand, ReorderPoint)
    VALUES (@VariantID, @BranchID, @CurrentStock, 0);
    PRINT 'Inserted into Demo_Retail_Stock with QtyOnHand = ' + CAST(@CurrentStock AS VARCHAR);
END

-- Verify the update
SELECT 'vw_POS_Products AFTER UPDATE' AS Info, ProductID, ItemCode, ProductName, QtyOnHand, BranchID
FROM vw_POS_Products
WHERE ProductID = @ProductID;
