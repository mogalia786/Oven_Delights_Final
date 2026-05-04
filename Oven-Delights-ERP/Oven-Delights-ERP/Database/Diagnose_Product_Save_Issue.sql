-- =============================================
-- DIAGNOSTIC: Why aren't products saving?
-- =============================================

PRINT '=== STEP 1: Check if stored procedure exists ==='
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_SaveProductToAllBranches')
BEGIN
    PRINT '✓ sp_SaveProductToAllBranches EXISTS'
END
ELSE
BEGIN
    PRINT '✗ sp_SaveProductToAllBranches DOES NOT EXIST - THIS IS THE PROBLEM!'
    PRINT 'You MUST run sp_SaveProductToAllBranches.sql first!'
END

PRINT ''
PRINT '=== STEP 2: Check for Macaroni Cake ==='
SELECT COUNT(*) AS MacaroniCount FROM Demo_Retail_Product WHERE Name LIKE '%macaroni%'
IF (SELECT COUNT(*) FROM Demo_Retail_Product WHERE Name LIKE '%macaroni%') = 0
    PRINT '✗ Macaroni Cake NOT FOUND'
ELSE
    PRINT '✓ Macaroni Cake found'

PRINT ''
PRINT '=== STEP 3: Check for Romany Cream ==='
SELECT COUNT(*) AS RomanyCount FROM Demo_Retail_Product WHERE Name LIKE '%romany%'
IF (SELECT COUNT(*) FROM Demo_Retail_Product WHERE Name LIKE '%romany%') = 0
    PRINT '✗ Romany Cream NOT FOUND'
ELSE
    PRINT '✓ Romany Cream found'

PRINT ''
PRINT '=== STEP 4: Test the stored procedure manually ==='
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_SaveProductToAllBranches')
BEGIN
    PRINT 'Testing sp_SaveProductToAllBranches with test data...'
    
    DECLARE @TestProductID INT
    
    EXEC sp_SaveProductToAllBranches
        @ProductName = 'TEST PRODUCT - DELETE ME',
        @ProductCode = 'TEST001',
        @SKU = NULL,
        @CategoryID = 1,
        @SubcategoryID = NULL,
        @ItemType = 'Internal',
        @IsActive = 1,
        @CostPrice = 10.00,
        @SellingPrice = 20.00,
        @ProductImage = NULL,
        @CreatedBy = 'Diagnostic Test',
        @NewProductID = @TestProductID OUTPUT
    
    IF @TestProductID > 0
    BEGIN
        PRINT '✓ Stored procedure works! Test ProductID: ' + CAST(@TestProductID AS NVARCHAR)
        
        -- Check how many branches it created
        SELECT COUNT(*) AS BranchCount FROM Demo_Retail_Product WHERE ProductID = @TestProductID
        
        -- Clean up test product
        DELETE FROM Demo_Retail_Price WHERE ProductID = @TestProductID
        DELETE FROM Demo_Retail_Product WHERE ProductID = @TestProductID
        PRINT '✓ Test product cleaned up'
    END
    ELSE
    BEGIN
        PRINT '✗ Stored procedure failed to create product'
    END
END
ELSE
BEGIN
    PRINT '✗ Cannot test - stored procedure does not exist'
END

PRINT ''
PRINT '=== STEP 5: Check Branches table ==='
SELECT BranchID, BranchName, IsActive FROM Branches ORDER BY BranchID

PRINT ''
PRINT '=== STEP 6: Check Demo_Retail_Product structure ==='
SELECT TOP 1 * FROM Demo_Retail_Product

PRINT ''
PRINT '=== STEP 7: Check Demo_Retail_Price structure ==='
SELECT TOP 1 * FROM Demo_Retail_Price

PRINT ''
PRINT '=== DIAGNOSIS COMPLETE ==='
PRINT 'If sp_SaveProductToAllBranches does NOT exist:'
PRINT '  1. Open Azure SQL Query Editor'
PRINT '  2. Run Create_ProductPriceHistory_Table.sql'
PRINT '  3. Run sp_SaveProductToAllBranches.sql'
PRINT '  4. Rebuild ERP application'
PRINT '  5. Try adding product again'
PRINT ''
PRINT 'If sp_SaveProductToAllBranches EXISTS but test failed:'
PRINT '  - Check error message above'
PRINT '  - Verify Branches table has active branches'
PRINT '  - Verify Demo_Retail_Product and Demo_Retail_Price tables exist'
