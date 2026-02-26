-- =============================================
-- Check AP_Invoices for Electricity Payment
-- =============================================

PRINT '=============================================='
PRINT 'Checking AP_Invoices Table'
PRINT '=============================================='
PRINT ''

-- Check if table exists
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AP_Invoices')
BEGIN
    PRINT '❌ ERROR: AP_Invoices table does not exist!'
    RETURN
END

-- Get total count
DECLARE @TotalCount INT
SELECT @TotalCount = COUNT(*) FROM AP_Invoices

PRINT 'Total Records in AP_Invoices: ' + CAST(@TotalCount AS VARCHAR)
PRINT ''

IF @TotalCount = 0
BEGIN
    PRINT '❌ NO INVOICES FOUND!'
    PRINT 'The AP_Invoices table is EMPTY.'
END
ELSE
BEGIN
    PRINT '✓ Found ' + CAST(@TotalCount AS VARCHAR) + ' invoice(s)'
    PRINT ''
    
    PRINT 'ALL Invoices (Most Recent First):'
    SELECT 
        InvoiceID,
        InvoiceNumber,
        BeneficiaryID,
        CategoryID,
        InvoiceDate,
        DueDate,
        Amount,
        TaxAmount,
        TotalAmount,
        Status,
        Description,
        Reference,
        CreatedDate,
        CreatedBy
    FROM AP_Invoices
    ORDER BY InvoiceID DESC
    
    PRINT ''
    PRINT 'Invoices by Status:'
    SELECT 
        Status,
        COUNT(*) AS Count,
        SUM(TotalAmount) AS TotalAmount
    FROM AP_Invoices
    GROUP BY Status
    
    PRINT ''
    PRINT 'Invoices Captured Today:'
    SELECT 
        InvoiceID,
        InvoiceNumber,
        InvoiceDate,
        TotalAmount,
        Status,
        Description,
        CreatedDate
    FROM AP_Invoices
    WHERE CAST(CreatedDate AS DATE) = CAST(GETDATE() AS DATE)
    ORDER BY InvoiceID DESC
    
    PRINT ''
    PRINT 'Outstanding (Unpaid) Invoices:'
    SELECT 
        InvoiceID,
        InvoiceNumber,
        InvoiceDate,
        DueDate,
        TotalAmount,
        Status,
        Description
    FROM AP_Invoices
    WHERE Status IN ('Pending', 'Approved', 'Outstanding')
    ORDER BY InvoiceDate DESC
END

PRINT ''
PRINT '=============================================='
PRINT 'Check Complete'
PRINT '=============================================='
GO
