-- =============================================
-- Check ALL Beneficiary Payments (No Filters)
-- =============================================

PRINT '=============================================='
PRINT 'Checking ALL Beneficiary Payments'
PRINT '=============================================='
PRINT ''

-- Check if table exists
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BeneficiaryPayments')
BEGIN
    PRINT '❌ ERROR: BeneficiaryPayments table does not exist!'
    RETURN
END

-- Get total count
DECLARE @TotalCount INT
SELECT @TotalCount = COUNT(*) FROM BeneficiaryPayments

PRINT 'Total Records in BeneficiaryPayments: ' + CAST(@TotalCount AS VARCHAR)
PRINT ''

IF @TotalCount = 0
BEGIN
    PRINT '❌ NO PAYMENTS FOUND!'
    PRINT ''
    PRINT 'The BeneficiaryPayments table is EMPTY.'
    PRINT ''
    PRINT 'This means the electricity payment was NOT saved to this table.'
    PRINT ''
    PRINT 'Possible causes:'
    PRINT '  1. Payment was saved to a different table (e.g., SupplierInvoices, ExpenseBills)'
    PRINT '  2. Form is not saving data correctly'
    PRINT '  3. Database connection issue'
    PRINT ''
    PRINT 'Check these tables instead:'
    PRINT ''
    
    -- Check SupplierInvoices
    DECLARE @SupplierInvCount INT
    SELECT @SupplierInvCount = COUNT(*) 
    FROM SupplierInvoices 
    WHERE CAST(InvoiceDate AS DATE) = CAST(GETDATE() AS DATE)
    
    IF @SupplierInvCount > 0
    BEGIN
        PRINT '✓ Found ' + CAST(@SupplierInvCount AS VARCHAR) + ' supplier invoices captured today:'
        SELECT TOP 5
            InvoiceID,
            InvoiceNumber,
            SupplierID,
            InvoiceDate,
            TotalAmount,
            Status
        FROM SupplierInvoices
        WHERE CAST(InvoiceDate AS DATE) = CAST(GETDATE() AS DATE)
        ORDER BY InvoiceID DESC
    END
    ELSE
    BEGIN
        PRINT '  SupplierInvoices (today): 0 records'
    END
    
    PRINT ''
    
    -- Check if Beneficiaries exist
    DECLARE @BeneficiaryCount INT
    SELECT @BeneficiaryCount = COUNT(*) FROM Beneficiaries
    PRINT 'Beneficiaries in system: ' + CAST(@BeneficiaryCount AS VARCHAR)
    
    IF @BeneficiaryCount > 0
    BEGIN
        PRINT ''
        PRINT 'Available Beneficiaries:'
        SELECT TOP 10
            BeneficiaryID,
            BeneficiaryName,
            Category,
            IsActive
        FROM Beneficiaries
        ORDER BY BeneficiaryID DESC
    END
    
END
ELSE
BEGIN
    PRINT '✓ Found ' + CAST(@TotalCount AS VARCHAR) + ' payment(s)'
    PRINT ''
    PRINT 'ALL Payments (Most Recent First):'
    SELECT 
        PaymentID,
        PaymentReference,
        PaymentDate,
        Amount,
        Status,
        Category,
        Description,
        BeneficiaryID,
        CreatedDate,
        CreatedBy
    FROM BeneficiaryPayments
    ORDER BY PaymentID DESC
    
    PRINT ''
    PRINT 'Payments by Status:'
    SELECT 
        Status,
        COUNT(*) AS Count,
        SUM(Amount) AS TotalAmount
    FROM BeneficiaryPayments
    GROUP BY Status
    
    PRINT ''
    PRINT 'Payments Captured Today:'
    SELECT 
        PaymentID,
        PaymentReference,
        PaymentDate,
        Amount,
        Status,
        Category,
        Description,
        CreatedDate
    FROM BeneficiaryPayments
    WHERE CAST(CreatedDate AS DATE) = CAST(GETDATE() AS DATE)
    ORDER BY PaymentID DESC
END

PRINT ''
PRINT '=============================================='
PRINT 'Check Complete'
PRINT '=============================================='
GO
