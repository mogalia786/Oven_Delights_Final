-- =============================================
-- Update sp_AP_GetOutstandingInvoices to support BranchID filtering
-- =============================================

SET NOCOUNT ON;
GO

PRINT 'Updating sp_AP_GetOutstandingInvoices to add BranchID parameter...';
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
        b.AccountType,
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

PRINT 'sp_AP_GetOutstandingInvoices updated successfully with BranchID parameter';
GO

-- Test the procedure
PRINT '';
PRINT 'Testing procedure with BranchID = 6...';
GO

EXEC sp_AP_GetOutstandingInvoices @BranchID = 6;
GO

PRINT '';
PRINT 'Script completed successfully!';
GO
