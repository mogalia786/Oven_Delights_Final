-- =============================================
-- Check Recently Captured Beneficiary Invoices
-- =============================================

PRINT '=============================================='
PRINT 'RECENT BENEFICIARY INVOICES'
PRINT '=============================================='
PRINT ''

PRINT 'Last 10 invoices captured:'
SELECT TOP 10
    i.InvoiceID,
    i.InvoiceNumber,
    i.InvoiceDate,
    i.DueDate,
    b.BeneficiaryName,
    c.CategoryName,
    i.TotalAmount,
    i.Status,
    i.CreatedDate,
    i.CreatedBy
FROM AP_Invoices i
INNER JOIN AP_Beneficiaries b ON i.BeneficiaryID = b.BeneficiaryID
LEFT JOIN AP_Categories c ON i.CategoryID = c.CategoryID
ORDER BY i.CreatedDate DESC
GO

PRINT ''
PRINT '=============================================='
PRINT 'Invoices that SHOULD appear in batch payment:'
EXEC sp_GetUnpaidInvoices @SupplierID = 0
GO

PRINT ''
PRINT '=============================================='
PRINT 'TROUBLESHOOTING:'
PRINT ''
PRINT 'If your invoice is in the first list but NOT in the second list:'
PRINT '1. Check Status - must be ''Pending'' or ''Overdue'''
PRINT '2. Check AmountDue - must be greater than 0'
PRINT '3. Check if already in a batch with status ''Completed'', ''Processing'', or ''Submitted'''
PRINT ''
PRINT 'Common issues:'
PRINT '- Status is ''Paid'' or ''Cancelled'' instead of ''Pending'''
PRINT '- Invoice was posted to GL but status not updated'
PRINT '- Already added to another batch'
PRINT '=============================================='
GO
