-- =============================================
-- sp_GetUnpaidInvoices - Get all unpaid invoices for batch payment processing
-- =============================================
CREATE OR ALTER PROCEDURE sp_GetUnpaidInvoices
    @SupplierID INT = NULL,
    @DueDateFrom DATE = NULL,
    @DueDateTo DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        i.InvoiceID,
        i.InvoiceNumber,
        i.InvoiceDate,
        i.DueDate,
        b.BeneficiaryName AS SupplierName,
        c.CategoryName,
        i.TotalAmount,
        ISNULL(
            (SELECT SUM(m.AmountPaid) 
             FROM AP_InvoiceBatchMapping m
             INNER JOIN FNB_PaymentBatches pb ON m.FNB_BatchID = pb.BatchID
             WHERE m.InvoiceID = i.InvoiceID
               AND pb.BatchStatus IN ('Pending', 'ACCP', 'ACSC', 'PDNG')),
            0
        ) AS AmountPaid,
        i.TotalAmount - ISNULL(
            (SELECT SUM(m.AmountPaid) 
             FROM AP_InvoiceBatchMapping m
             INNER JOIN FNB_PaymentBatches pb ON m.FNB_BatchID = pb.BatchID
             WHERE m.InvoiceID = i.InvoiceID
               AND pb.BatchStatus IN ('Pending', 'ACCP', 'ACSC', 'PDNG')),
            0
        ) AS AmountDue,
        i.Status,
        i.Description,
        i.Reference,
        b.BankName,
        b.BranchCode,
        b.AccountNumber,
        b.AccountType,
        b.AccountHolderName
    FROM AP_Invoices i
    INNER JOIN AP_Beneficiaries b ON i.BeneficiaryID = b.BeneficiaryID
    INNER JOIN AP_Categories c ON i.CategoryID = c.CategoryID
    WHERE i.Status IN ('Pending', 'Overdue')
      AND (@SupplierID IS NULL OR @SupplierID = 0 OR i.BeneficiaryID = @SupplierID)
      AND (@DueDateFrom IS NULL OR i.DueDate >= @DueDateFrom)
      AND (@DueDateTo IS NULL OR i.DueDate <= @DueDateTo)
      AND (i.TotalAmount - ISNULL(
            (SELECT SUM(m.AmountPaid) 
             FROM AP_InvoiceBatchMapping m
             INNER JOIN FNB_PaymentBatches pb ON m.FNB_BatchID = pb.BatchID
             WHERE m.InvoiceID = i.InvoiceID
               AND pb.BatchStatus IN ('Pending', 'ACCP', 'ACSC', 'PDNG')),
            0
        )) > 0
    ORDER BY i.DueDate ASC, i.InvoiceDate ASC
END
GO

PRINT 'sp_GetUnpaidInvoices created successfully'
