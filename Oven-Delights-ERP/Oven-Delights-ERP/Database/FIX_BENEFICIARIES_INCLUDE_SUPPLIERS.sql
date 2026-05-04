-- =============================================
-- Fix sp_AP_GetBeneficiaries to include Suppliers
-- This allows suppliers created in Stockroom to appear in Invoice Capture
-- =============================================

PRINT 'Fixing sp_AP_GetBeneficiaries to include Suppliers...'

-- Drop existing stored procedure
IF OBJECT_ID('sp_AP_GetBeneficiaries', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE sp_AP_GetBeneficiaries
    PRINT 'Dropped existing sp_AP_GetBeneficiaries'
END
GO

-- Create updated stored procedure that includes both Beneficiaries and Suppliers
CREATE PROCEDURE sp_AP_GetBeneficiaries
    @IsActive BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Return combined list of Beneficiaries and Suppliers
    SELECT 
        BeneficiaryID,
        BeneficiaryName,
        BeneficiaryType,
        BankName,
        BranchCode,
        AccountNumber,
        AccountType,
        ContactPerson,
        Email,
        Phone,
        IsActive,
        'Beneficiary' AS Source
    FROM AP_Beneficiaries
    WHERE (@IsActive IS NULL OR IsActive = @IsActive)
    
    UNION ALL
    
    SELECT 
        SupplierID AS BeneficiaryID,
        CompanyName AS BeneficiaryName,
        'Supplier' AS BeneficiaryType,
        BankName,
        BranchCode,
        AccountNumber,
        BankAccountType AS AccountType,
        ContactPerson,
        Email,
        Phone,
        IsActive,
        'Supplier' AS Source
    FROM Suppliers
    WHERE (@IsActive IS NULL OR IsActive = @IsActive)
    
    ORDER BY BeneficiaryName;
END
GO

PRINT 'sp_AP_GetBeneficiaries updated successfully!'
PRINT 'Beneficiaries list now includes:'
PRINT '  - AP_Beneficiaries (created via Beneficiary Management)'
PRINT '  - Suppliers (created via Stockroom > Suppliers)'
PRINT ''
PRINT 'IMPORTANT: Invoice capture will now show both beneficiaries and suppliers'
PRINT 'The Source column indicates whether it came from Beneficiaries or Suppliers table'
GO

-- Verification query
PRINT ''
PRINT '========================================';
PRINT 'VERIFICATION - Sample Combined List';
PRINT '========================================';

EXEC sp_AP_GetBeneficiaries @IsActive = 1;

PRINT ''
PRINT 'Fix completed successfully!'
