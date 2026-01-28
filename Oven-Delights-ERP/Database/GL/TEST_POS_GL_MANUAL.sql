-- Manual test of sp_POS_PostSaleToGL with actual data

-- Test 1: Check if function exists and works
PRINT 'Testing fn_GetCurrentFiscalPeriodID...'
BEGIN TRY
    DECLARE @TestPeriodID INT = dbo.fn_GetCurrentFiscalPeriodID(GETDATE())
    PRINT 'Function returned: ' + CAST(@TestPeriodID AS NVARCHAR)
END TRY
BEGIN CATCH
    PRINT 'ERROR: ' + ERROR_MESSAGE()
END CATCH
PRINT ''

-- Test 2: Try to call the procedure with today's sale data
PRINT 'Testing sp_POS_PostSaleToGL with sample data...'
BEGIN TRY
    EXEC sp_POS_PostSaleToGL
        @InvoiceNumber = 'INV-PH-TILL-01-000056',
        @SaleDate = '2026-01-19',
        @BranchID = 6,
        @CashierID = 23,
        @Subtotal = 130.43,
        @TaxAmount = 19.57,
        @TotalAmount = 150.00,
        @CashAmount = 0.00,
        @CardAmount = 150.00,
        @TotalCost = 75.00,
        @CreatedBy = 23
    
    PRINT 'SUCCESS: Procedure executed'
    
    -- Check if journal was created
    IF EXISTS (SELECT 1 FROM JournalHeaders WHERE JournalNumber = 'POS-INV-PH-TILL-01-000056')
        PRINT 'Journal created successfully'
    ELSE
        PRINT 'WARNING: Procedure ran but no journal found'
END TRY
BEGIN CATCH
    PRINT 'ERROR calling procedure:'
    PRINT 'Message: ' + ERROR_MESSAGE()
    PRINT 'Line: ' + CAST(ERROR_LINE() AS NVARCHAR)
    PRINT 'Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A')
END CATCH
