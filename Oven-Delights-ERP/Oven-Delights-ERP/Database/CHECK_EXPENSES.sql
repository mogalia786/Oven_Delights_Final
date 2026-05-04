-- =============================================
-- Check Why Expenses Show Zero on Dashboard
-- =============================================

PRINT '=============================================='
PRINT 'Checking BeneficiaryPayments for Expenses'
PRINT '=============================================='
PRINT ''

-- Check if BeneficiaryPayments table exists
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BeneficiaryPayments')
BEGIN
    PRINT '❌ ERROR: BeneficiaryPayments table does not exist!'
    PRINT 'Please run CREATE_BANK_RECONCILIATION_SYSTEM.sql first'
END
ELSE
BEGIN
    PRINT '✓ BeneficiaryPayments table exists'
    PRINT ''
    
    -- Check total count
    DECLARE @TotalCount INT
    SELECT @TotalCount = COUNT(*) FROM BeneficiaryPayments
    PRINT 'Total BeneficiaryPayments records: ' + CAST(@TotalCount AS VARCHAR)
    
    IF @TotalCount = 0
    BEGIN
        PRINT ''
        PRINT '⚠ WARNING: No beneficiary payments found!'
        PRINT 'You need to capture an expense payment first.'
        PRINT ''
        PRINT 'To test, you can insert a sample electricity payment:'
        PRINT ''
        PRINT '-- First, check if beneficiary exists'
        PRINT 'SELECT * FROM Beneficiaries WHERE BeneficiaryName LIKE ''%Electric%'''
        PRINT ''
        PRINT '-- If no beneficiary exists, create one first'
    END
    ELSE
    BEGIN
        PRINT ''
        PRINT 'Current Month Payments (All Statuses):'
        SELECT 
            PaymentID,
            PaymentReference,
            PaymentDate,
            Amount,
            Status,
            Category,
            Description
        FROM BeneficiaryPayments
        WHERE MONTH(PaymentDate) = MONTH(GETDATE())
          AND YEAR(PaymentDate) = YEAR(GETDATE())
        ORDER BY PaymentDate DESC
        
        PRINT ''
        PRINT 'Current Month UNPAID Payments (Dashboard Query):'
        SELECT 
            PaymentID,
            PaymentReference,
            PaymentDate,
            Amount,
            Status,
            Category,
            Description
        FROM BeneficiaryPayments
        WHERE Status IN ('Pending', 'Approved', 'Sent to Bank')
          AND MONTH(PaymentDate) = MONTH(GETDATE())
          AND YEAR(PaymentDate) = YEAR(GETDATE())
        ORDER BY PaymentDate DESC
        
        PRINT ''
        PRINT 'Total Unpaid Expenses (MTD):'
        SELECT ISNULL(SUM(Amount), 0) AS TotalExpenses
        FROM BeneficiaryPayments
        WHERE Status IN ('Pending', 'Approved', 'Sent to Bank')
          AND MONTH(PaymentDate) = MONTH(GETDATE())
          AND YEAR(PaymentDate) = YEAR(GETDATE())
    END
END

PRINT ''
PRINT '=============================================='
PRINT 'Check Complete'
PRINT '=============================================='
GO
