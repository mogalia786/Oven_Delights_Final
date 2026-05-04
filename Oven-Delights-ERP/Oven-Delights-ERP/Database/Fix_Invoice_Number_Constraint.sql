-- =============================================
-- Fix Invoice Number Unique Constraint
-- Change from global unique to unique per beneficiary
-- =============================================

USE [OvenDelightsERP]
GO

PRINT 'Fixing Invoice Number Unique Constraint...'

-- Drop the existing global unique constraint if it exists
IF EXISTS (
    SELECT 1 
    FROM sys.indexes 
    WHERE name = 'UQ_AP_Invoices_InvoiceNumber' 
    AND object_id = OBJECT_ID('AP_Invoices')
)
BEGIN
    ALTER TABLE AP_Invoices
    DROP CONSTRAINT UQ_AP_Invoices_InvoiceNumber
    
    PRINT '✓ Dropped global unique constraint on InvoiceNumber'
END

-- Add unique constraint on InvoiceNumber per BeneficiaryID
IF NOT EXISTS (
    SELECT 1 
    FROM sys.indexes 
    WHERE name = 'UQ_AP_Invoices_InvoiceNumber_Beneficiary' 
    AND object_id = OBJECT_ID('AP_Invoices')
)
BEGIN
    CREATE UNIQUE INDEX UQ_AP_Invoices_InvoiceNumber_Beneficiary 
    ON AP_Invoices(InvoiceNumber, BeneficiaryID)
    WHERE InvoiceNumber IS NOT NULL AND BeneficiaryID IS NOT NULL
    
    PRINT '✓ Added unique constraint on (InvoiceNumber, BeneficiaryID)'
    PRINT '  Invoice numbers are now unique per beneficiary/supplier'
END

PRINT 'Invoice number constraint fix completed successfully!'
GO
