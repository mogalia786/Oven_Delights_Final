-- =============================================
-- Check if price history was recorded for Salt Bale
-- =============================================

PRINT '=== 1. Check ProductPriceHistory table ==='
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductPriceHistory')
BEGIN
    PRINT '✓ ProductPriceHistory table exists'
    
    SELECT TOP 10 
        ProductID,
        SKU,
        ProductName,
        SupplierName,
        InvoiceNumber,
        InvoiceDate,
        CostPrice,
        Quantity,
        BranchID,
        CapturedDate
    FROM ProductPriceHistory
    ORDER BY CapturedDate DESC
    
    PRINT ''
    PRINT 'Total records: ' + CAST((SELECT COUNT(*) FROM ProductPriceHistory) AS NVARCHAR)
END
ELSE
BEGIN
    PRINT '✗ ProductPriceHistory table DOES NOT EXIST!'
END

PRINT ''
PRINT '=== 2. Check for Salt Bale specifically ==='
SELECT 
    ProductID,
    Name,
    BranchID,
    ProductType,
    IsActive
FROM Demo_Retail_Product
WHERE Name LIKE '%salt%bale%'

PRINT ''
PRINT '=== 3. Check Demo_Retail_Price for Salt Bale ==='
SELECT 
    p.ProductID,
    p.Name,
    rp.BranchID,
    rp.CostPrice,
    rp.SellingPrice,
    rp.EffectiveFrom
FROM Demo_Retail_Product p
LEFT JOIN Demo_Retail_Price rp ON p.ProductID = rp.ProductID AND p.BranchID = rp.BranchID
WHERE p.Name LIKE '%salt%bale%'

PRINT ''
PRINT '=== 4. Test sp_GetLatestProductPrice ==='
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_GetLatestProductPrice')
BEGIN
    PRINT '✓ sp_GetLatestProductPrice exists'
    
    -- Get ProductID for Salt Bale
    DECLARE @ProductID INT
    SELECT TOP 1 @ProductID = ProductID FROM Demo_Retail_Product WHERE Name LIKE '%salt%bale%'
    
    IF @ProductID IS NOT NULL
    BEGIN
        PRINT 'Testing with ProductID: ' + CAST(@ProductID AS NVARCHAR)
        
        EXEC sp_GetLatestProductPrice 
            @ProductID = @ProductID,
            @BranchID = 6  -- AYESHA CENTRE
    END
    ELSE
    BEGIN
        PRINT '✗ Salt Bale product not found'
    END
END
ELSE
BEGIN
    PRINT '✗ sp_GetLatestProductPrice DOES NOT EXIST!'
END

PRINT ''
PRINT '=== 5. Check recent SupplierInvoices ==='
SELECT TOP 5
    InvoiceID,
    InvoiceNumber,
    SupplierID,
    BranchID,
    InvoiceDate,
    TotalAmount,
    Status
FROM SupplierInvoices
ORDER BY InvoiceDate DESC

PRINT ''
PRINT '=== DIAGNOSIS ==='
PRINT 'If ProductPriceHistory is empty:'
PRINT '  - The invoice capture did not call sp_RecordProductPriceFromInvoice'
PRINT '  - You need to rebuild the ERP with the updated InvoiceGRVForm.vb'
PRINT ''
PRINT 'If sp_GetLatestProductPrice does not exist:'
PRINT '  - Run Create_ProductPriceHistory_Table.sql'
PRINT ''
PRINT 'If price shows 0.00 in PO:'
PRINT '  - Check that ProductID matches between tables'
PRINT '  - Check that BranchID is correct (AYESHA CENTRE = 6)'
