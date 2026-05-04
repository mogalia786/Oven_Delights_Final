-- =============================================
-- Verify Electricity Payment Exists and Status
-- =============================================

PRINT '=============================================='
PRINT 'Checking for Electricity Payment'
PRINT '=============================================='
PRINT ''

-- Check all beneficiary payments
PRINT 'ALL Beneficiary Payments:'
SELECT 
    PaymentID,
    PaymentReference,
    PaymentDate,
    Amount,
    Status,
    Category,
    Description,
    MONTH(PaymentDate) AS PaymentMonth,
    YEAR(PaymentDate) AS PaymentYear,
    MONTH(GETDATE()) AS CurrentMonth,
    YEAR(GETDATE()) AS CurrentYear
FROM BeneficiaryPayments
ORDER BY PaymentDate DESC

PRINT ''
PRINT '=============================================='
PRINT 'Dashboard Query (Unpaid Expenses MTD):'
PRINT '=============================================='
PRINT ''

-- Exact query from Financial Dashboard
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
PRINT 'Total Amount (Dashboard will show this):'
SELECT ISNULL(SUM(Amount), 0) AS TotalExpenses
FROM BeneficiaryPayments
WHERE Status IN ('Pending', 'Approved', 'Sent to Bank')
  AND MONTH(PaymentDate) = MONTH(GETDATE())
  AND YEAR(PaymentDate) = YEAR(GETDATE())

PRINT ''
PRINT '=============================================='
PRINT 'Possible Issues:'
PRINT '=============================================='
PRINT ''

-- Check if payment date is in current month
DECLARE @PaymentCount INT
DECLARE @CurrentMonthCount INT

SELECT @PaymentCount = COUNT(*) FROM BeneficiaryPayments
SELECT @CurrentMonthCount = COUNT(*) 
FROM BeneficiaryPayments
WHERE MONTH(PaymentDate) = MONTH(GETDATE())
  AND YEAR(PaymentDate) = YEAR(GETDATE())

PRINT 'Total Payments in System: ' + CAST(@PaymentCount AS VARCHAR)
PRINT 'Payments in Current Month: ' + CAST(@CurrentMonthCount AS VARCHAR)

IF @PaymentCount > 0 AND @CurrentMonthCount = 0
BEGIN
    PRINT ''
    PRINT '⚠ WARNING: Payment exists but NOT in current month!'
    PRINT 'Check the PaymentDate - it may be in a different month/year'
    PRINT ''
    PRINT 'Payment Dates Found:'
    SELECT 
        FORMAT(PaymentDate, 'MMMM yyyy') AS PaymentMonth,
        COUNT(*) AS Count
    FROM BeneficiaryPayments
    GROUP BY FORMAT(PaymentDate, 'MMMM yyyy'), YEAR(PaymentDate), MONTH(PaymentDate)
    ORDER BY YEAR(PaymentDate) DESC, MONTH(PaymentDate) DESC
END

-- Check status
DECLARE @PaidCount INT
SELECT @PaidCount = COUNT(*) 
FROM BeneficiaryPayments
WHERE Status = 'Paid'

IF @PaidCount > 0
BEGIN
    PRINT ''
    PRINT '⚠ WARNING: Some payments have Status = ''Paid'''
    PRINT 'Paid payments do NOT show on dashboard (only Pending, Approved, Sent to Bank)'
    PRINT ''
    PRINT 'Paid Payments:'
    SELECT 
        PaymentReference,
        PaymentDate,
        Amount,
        Status,
        Category
    FROM BeneficiaryPayments
    WHERE Status = 'Paid'
END

PRINT ''
PRINT '=============================================='
PRINT 'Verification Complete'
PRINT '=============================================='
GO
