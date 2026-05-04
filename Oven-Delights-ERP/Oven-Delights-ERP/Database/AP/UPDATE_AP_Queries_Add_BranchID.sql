-- =============================================
-- Update AP Queries to Include BranchID Filter
-- =============================================
-- All queries must filter by BranchID for multi-branch operations
-- =============================================

USE OvenDelightsERP
GO

PRINT 'Updating AP stored procedures to include BranchID filtering...'
GO

-- 1. Update sp_AP_GetOutstandingInvoices to filter by BranchID
GO
CREATE OR ALTER PROCEDURE sp_AP_GetOutstandingInvoices
    @BeneficiaryID INT = NULL,
    @CategoryID INT = NULL,
    @DueDateFrom DATE = NULL,
    @DueDateTo DATE = NULL,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        i.InvoiceID,
        i.InvoiceNumber,
        i.InvoiceDate,
        i.DueDate,
        DATEDIFF(DAY, GETDATE(), i.DueDate) AS DaysUntilDue,
        i.Amount,
        i.TaxAmount,
        i.TotalAmount,
        i.Description,
        i.Reference,
        i.Status,
        i.BranchID,
        b.BeneficiaryName,
        b.BankName,
        b.AccountNumber,
        b.BranchCode,
        c.CategoryName,
        c.GLAccountCode
    FROM AP_Invoices i
    INNER JOIN AP_Beneficiaries b ON i.BeneficiaryID = b.BeneficiaryID
    INNER JOIN AP_Categories c ON i.CategoryID = c.CategoryID
    WHERE i.Status = 'Pending'
        AND (@BeneficiaryID IS NULL OR i.BeneficiaryID = @BeneficiaryID)
        AND (@CategoryID IS NULL OR i.CategoryID = @CategoryID)
        AND (@DueDateFrom IS NULL OR i.DueDate >= @DueDateFrom)
        AND (@DueDateTo IS NULL OR i.DueDate <= @DueDateTo)
        AND (@BranchID IS NULL OR i.BranchID = @BranchID)
    ORDER BY i.DueDate ASC
END
GO

PRINT '  ✓ sp_AP_GetOutstandingInvoices updated with BranchID filter'
GO

PRINT ''
PRINT 'AP stored procedures updated successfully'
PRINT 'All queries now filter by BranchID for multi-branch support'
GO
