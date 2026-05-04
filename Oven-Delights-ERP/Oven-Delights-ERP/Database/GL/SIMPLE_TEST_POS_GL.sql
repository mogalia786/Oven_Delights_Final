-- Simple test: Does the procedure work now?

EXEC sp_POS_PostSaleToGL
    @InvoiceNumber = 'INV-PH-TILL-01-999999',
    @SaleDate = '2026-01-27',
    @BranchID = 6,
    @CashierID = 23,
    @Subtotal = 100.00,
    @TaxAmount = 15.00,
    @TotalAmount = 115.00,
    @CashAmount = 0.00,
    @CardAmount = 115.00,
    @TotalCost = 60.00,
    @CreatedBy = 23

-- Check if journal was created
SELECT TOP 5 
    JournalNumber,
    JournalDate,
    Description,
    BranchID
FROM JournalHeaders 
WHERE JournalNumber LIKE 'POS-%' 
ORDER BY JournalID DESC

-- If no results, check ALL recent journals
IF NOT EXISTS (SELECT 1 FROM JournalHeaders WHERE JournalNumber LIKE 'POS-%')
BEGIN
    PRINT 'No POS journals found. Showing all recent journals:'
    SELECT TOP 10 
        JournalNumber,
        JournalDate,
        Description
    FROM JournalHeaders 
    ORDER BY JournalID DESC
END
