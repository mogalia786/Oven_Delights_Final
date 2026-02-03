-- =============================================
-- Check Supplier Bank Account Configuration
-- =============================================

PRINT '=============================================='
PRINT 'SUPPLIER BANK ACCOUNT CHECK'
PRINT '=============================================='
PRINT ''

PRINT 'Suppliers with bank account details:'
SELECT 
    SupplierID,
    CompanyName,
    BankAccountNumber,
    BankName,
    BankBranchCode,
    ProofOfPaymentEmail
FROM Suppliers
WHERE BankAccountNumber IS NOT NULL
ORDER BY SupplierID
GO

PRINT ''
PRINT '=============================================='
PRINT 'CRITICAL ISSUE CHECK:'
PRINT ''

DECLARE @YourBusinessAccount NVARCHAR(20) = '63001723469'
DECLARE @ProblemCount INT

SELECT @ProblemCount = COUNT(*)
FROM Suppliers
WHERE BankAccountNumber = @YourBusinessAccount

IF @ProblemCount > 0
BEGIN
    PRINT '✗✗✗ CRITICAL ERROR FOUND ✗✗✗'
    PRINT ''
    PRINT 'The following suppliers have YOUR business account number:'
    PRINT ''
    
    SELECT 
        SupplierID,
        CompanyName,
        BankAccountNumber AS WrongAccount
    FROM Suppliers
    WHERE BankAccountNumber = @YourBusinessAccount
    
    PRINT ''
    PRINT 'This means you are paying YOURSELF instead of the supplier!'
    PRINT ''
    PRINT 'FIX REQUIRED:'
    PRINT '1. Update each supplier with their REAL bank account number'
    PRINT '2. Use FNB test beneficiary accounts for testing:'
    PRINT '   - 63001730117'
    PRINT '   - 63001731222'
    PRINT ''
    PRINT 'Example fix:'
    PRINT 'UPDATE Suppliers SET BankAccountNumber = ''63001730117'' WHERE SupplierID = 1'
END
ELSE
BEGIN
    PRINT '✓ No suppliers using your business account'
    PRINT ''
    PRINT 'Verify supplier accounts are correct beneficiary accounts'
END

PRINT '=============================================='
GO
