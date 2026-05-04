-- =============================================
-- Add Unique Constraint to AP_Invoices.InvoiceNumber
-- Prevents duplicate invoice numbers
-- =============================================

-- Check for existing duplicates first
PRINT '=============================================='
PRINT 'Checking for duplicate invoice numbers...'
PRINT ''

SELECT InvoiceNumber, COUNT(*) AS DuplicateCount
FROM AP_Invoices
GROUP BY InvoiceNumber
HAVING COUNT(*) > 1

IF @@ROWCOUNT > 0
BEGIN
    PRINT ''
    PRINT '✗ WARNING: Duplicate invoice numbers found!'
    PRINT 'Please resolve duplicates before adding unique constraint.'
    PRINT 'You can update duplicate invoice numbers by appending a suffix:'
    PRINT 'UPDATE AP_Invoices SET InvoiceNumber = InvoiceNumber + ''-2'' WHERE InvoiceID = [ID]'
END
ELSE
BEGIN
    PRINT '✓ No duplicate invoice numbers found'
    PRINT ''
    
    -- Add unique constraint if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 
        FROM sys.indexes 
        WHERE name = 'UQ_AP_Invoices_InvoiceNumber' 
        AND object_id = OBJECT_ID('AP_Invoices')
    )
    BEGIN
        ALTER TABLE AP_Invoices
        ADD CONSTRAINT UQ_AP_Invoices_InvoiceNumber UNIQUE (InvoiceNumber)
        
        PRINT '✓ Added unique constraint on InvoiceNumber'
    END
    ELSE
    BEGIN
        PRINT '✓ Unique constraint already exists'
    END
END

PRINT '=============================================='
GO
