-- =============================================
-- Add Bank Account Fields to Suppliers Table
-- For FNB Payment Execution API Integration
-- =============================================

SET NOCOUNT ON;
GO

-- Add BankAccountNumber
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'BankAccountNumber')
BEGIN
    ALTER TABLE Suppliers ADD BankAccountNumber NVARCHAR(23) NULL;
    PRINT 'Added BankAccountNumber column to Suppliers table';
END
ELSE
BEGIN
    PRINT 'BankAccountNumber column already exists';
END
GO

-- Add BankAccountType
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'BankAccountType')
BEGIN
    ALTER TABLE Suppliers ADD BankAccountType NVARCHAR(10) NULL DEFAULT 'CACC';
    PRINT 'Added BankAccountType column to Suppliers table';
END
ELSE
BEGIN
    PRINT 'BankAccountType column already exists';
END
GO

-- Add BankBranchCode
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'BankBranchCode')
BEGIN
    ALTER TABLE Suppliers ADD BankBranchCode NVARCHAR(10) NULL;
    PRINT 'Added BankBranchCode column to Suppliers table';
END
ELSE
BEGIN
    PRINT 'BankBranchCode column already exists';
END
GO

-- Add BankName
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'BankName')
BEGIN
    ALTER TABLE Suppliers ADD BankName NVARCHAR(50) NULL;
    PRINT 'Added BankName column to Suppliers table';
END
ELSE
BEGIN
    PRINT 'BankName column already exists';
END
GO

-- Add BankBIC (SWIFT Code)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'BankBIC')
BEGIN
    ALTER TABLE Suppliers ADD BankBIC NVARCHAR(20) NULL;
    PRINT 'Added BankBIC column to Suppliers table';
END
ELSE
BEGIN
    PRINT 'BankBIC column already exists';
END
GO

-- Add ProofOfPaymentEmail
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Suppliers' AND COLUMN_NAME = 'ProofOfPaymentEmail')
BEGIN
    ALTER TABLE Suppliers ADD ProofOfPaymentEmail NVARCHAR(100) NULL;
    PRINT 'Added ProofOfPaymentEmail column to Suppliers table';
END
ELSE
BEGIN
    PRINT 'ProofOfPaymentEmail column already exists';
END
GO

-- =============================================
-- Insert/Update Test Suppliers with Sandbox Bank Details
-- FOR TESTING ONLY - MARKED AS SANDBOX
-- =============================================

-- Test Supplier 1: Uses Beneficiary Account 1
IF NOT EXISTS (SELECT 1 FROM Suppliers WHERE CompanyName = 'TEST SUPPLIER 1 - SANDBOX')
BEGIN
    INSERT INTO Suppliers (
        SupplierCode,
        CompanyName,
        ContactPerson,
        Email,
        Phone,
        BankAccountNumber,
        BankAccountType,
        BankBranchCode,
        BankName,
        BankBIC,
        ProofOfPaymentEmail,
        IsActive,
        CreatedBy,
        CreatedDate
    )
    VALUES (
        'TEST-SAND-001',
        'TEST SUPPLIER 1 - SANDBOX',
        'Test Contact 1',
        'test1@sandbox.fnb.co.za',
        '0111234567',
        '63001730117',                    -- Sandbox Beneficiary Account 1
        'CACC',
        '250655',
        'FNB',
        'FIRNZAJJ',
        'test1@sandbox.fnb.co.za',
        1,
        1,                                -- System user
        GETDATE()
    );
    PRINT 'Inserted TEST SUPPLIER 1 - SANDBOX';
END
ELSE
BEGIN
    UPDATE Suppliers
    SET BankAccountNumber = '63001730117',
        BankAccountType = 'CACC',
        BankBranchCode = '250655',
        BankName = 'FNB',
        BankBIC = 'FIRNZAJJ',
        ProofOfPaymentEmail = 'test1@sandbox.fnb.co.za'
    WHERE CompanyName = 'TEST SUPPLIER 1 - SANDBOX';
    PRINT 'Updated TEST SUPPLIER 1 - SANDBOX bank details';
END
GO

-- Test Supplier 2: Uses Beneficiary Account 2
IF NOT EXISTS (SELECT 1 FROM Suppliers WHERE CompanyName = 'TEST SUPPLIER 2 - SANDBOX')
BEGIN
    INSERT INTO Suppliers (
        SupplierCode,
        CompanyName,
        ContactPerson,
        Email,
        Phone,
        BankAccountNumber,
        BankAccountType,
        BankBranchCode,
        BankName,
        BankBIC,
        ProofOfPaymentEmail,
        IsActive,
        CreatedBy,
        CreatedDate
    )
    VALUES (
        'TEST-SAND-002',
        'TEST SUPPLIER 2 - SANDBOX',
        'Test Contact 2',
        'test2@sandbox.fnb.co.za',
        '0117654321',
        '63001731222',                    -- Sandbox Beneficiary Account 2
        'CACC',
        '250655',
        'FNB',
        'FIRNZAJJ',
        'test2@sandbox.fnb.co.za',
        1,
        1,                                -- System user
        GETDATE()
    );
    PRINT 'Inserted TEST SUPPLIER 2 - SANDBOX';
END
ELSE
BEGIN
    UPDATE Suppliers
    SET BankAccountNumber = '63001731222',
        BankAccountType = 'CACC',
        BankBranchCode = '250655',
        BankName = 'FNB',
        BankBIC = 'FIRNZAJJ',
        ProofOfPaymentEmail = 'test2@sandbox.fnb.co.za'
    WHERE CompanyName = 'TEST SUPPLIER 2 - SANDBOX';
    PRINT 'Updated TEST SUPPLIER 2 - SANDBOX bank details';
END
GO

-- =============================================
-- Update existing suppliers to use sandbox accounts for testing
-- (Optional - only if you want to test with existing suppliers)
-- =============================================

-- Example: Update first 2 active suppliers with sandbox accounts
-- UNCOMMENT BELOW IF YOU WANT TO TEST WITH EXISTING SUPPLIERS


DECLARE @Supplier1ID INT, @Supplier2ID INT;

SELECT TOP 1 @Supplier1ID = SupplierID 
FROM Suppliers 
WHERE IsActive = 1 
  AND CompanyName NOT LIKE '%SANDBOX%'
  AND SupplierID NOT IN (SELECT TOP 1 SupplierID FROM Suppliers WHERE BankAccountNumber = '63001730117')
ORDER BY SupplierID;

SELECT TOP 1 @Supplier2ID = SupplierID 
FROM Suppliers 
WHERE IsActive = 1 
  AND CompanyName NOT LIKE '%SANDBOX%'
  AND SupplierID NOT IN (@Supplier1ID)
  AND SupplierID NOT IN (SELECT TOP 1 SupplierID FROM Suppliers WHERE BankAccountNumber = '63001731222')
ORDER BY SupplierID;

IF @Supplier1ID IS NOT NULL
BEGIN
    UPDATE Suppliers
    SET BankAccountNumber = '63001730117',
        BankAccountType = 'CACC',
        BankBranchCode = '250655',
        BankName = 'FNB - SANDBOX',
        BankBIC = 'FIRNZAJJ',
        ProofOfPaymentEmail = COALESCE(Email, 'test@sandbox.fnb.co.za')
    WHERE SupplierID = @Supplier1ID;
    
    PRINT 'Updated Supplier ' + CAST(@Supplier1ID AS NVARCHAR) + ' with sandbox account 1';
END

IF @Supplier2ID IS NOT NULL
BEGIN
    UPDATE Suppliers
    SET BankAccountNumber = '63001731222',
        BankAccountType = 'CACC',
        BankBranchCode = '250655',
        BankName = 'FNB - SANDBOX',
        BankBIC = 'FIRNZAJJ',
        ProofOfPaymentEmail = COALESCE(Email, 'test@sandbox.fnb.co.za')
    WHERE SupplierID = @Supplier2ID;
    
    PRINT 'Updated Supplier ' + CAST(@Supplier2ID AS NVARCHAR) + ' with sandbox account 2';
END


PRINT '';
PRINT '==============================================';
PRINT 'Suppliers table updated with bank account fields';
PRINT 'Sandbox test suppliers created';
PRINT '*** REMEMBER: These are SANDBOX accounts for testing only ***';
PRINT '*** Replace with real supplier bank details for production ***';
PRINT '==============================================';
GO
