-- =============================================
-- Stored Procedure: sp_AutoMatchBankTransactions
-- Purpose: Automatically match bank statement transactions to pending payments
-- Features: Reference number matching, amount validation, duplicate prevention
-- =============================================
-- NOTE: Connect to OvenDelightsERP database before executing
-- GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_AutoMatchBankTransactions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_AutoMatchBankTransactions]
GO

CREATE PROCEDURE [dbo].[sp_AutoMatchBankTransactions]
    @BankAccountID INT = NULL,
    @StatementLineID INT = NULL, -- Match specific line, or NULL for all unmatched
    @UserName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @MatchedCount INT = 0
    DECLARE @ErrorMessage NVARCHAR(MAX)
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- =============================================
        -- STEP 1: Match Supplier Invoice Payments
        -- =============================================
        UPDATE bst
        SET 
            Status = 'Matched',
            MatchedPaymentRef = si.PaymentReference,
            MatchedPaymentType = 'Supplier',
            MatchedReferenceID = si.InvoiceID,
            MatchedBy = @UserName,
            MatchedDate = GETDATE()
        FROM BankStatementTransactions bst
        INNER JOIN SupplierInvoices si ON (
            -- Match by payment reference in description
            bst.Description LIKE '%' + si.PaymentReference + '%'
            -- Amount matches (within 1 cent tolerance)
            AND ABS(bst.DebitAmount - si.TotalAmount) < 0.01
            -- Transaction is a debit (outgoing payment)
            AND bst.DebitAmount > 0
            -- Invoice is awaiting bank confirmation
            AND si.Status IN ('Sent to Bank', 'Approved')
        )
        WHERE bst.Status = 'Unmatched'
            AND bst.PostedToGL = 0
            AND (@BankAccountID IS NULL OR bst.BankAccountID = @BankAccountID)
            AND (@StatementLineID IS NULL OR bst.StatementLineID = @StatementLineID)
        
        SET @MatchedCount = @MatchedCount + @@ROWCOUNT
        
        -- Update supplier invoice status
        UPDATE si
        SET 
            Status = 'Matched',
            BankStatementLineID = bst.StatementLineID
        FROM SupplierInvoices si
        INNER JOIN BankStatementTransactions bst ON si.PaymentReference = bst.MatchedPaymentRef
        WHERE bst.Status = 'Matched' 
            AND bst.MatchedPaymentType = 'Supplier'
            AND si.Status IN ('Sent to Bank', 'Approved')
        
        -- =============================================
        -- STEP 2: Match Beneficiary Payments
        -- =============================================
        UPDATE bst
        SET 
            Status = 'Matched',
            MatchedPaymentRef = bp.PaymentReference,
            MatchedPaymentType = 'Beneficiary',
            MatchedReferenceID = bp.PaymentID,
            MatchedBy = @UserName,
            MatchedDate = GETDATE()
        FROM BankStatementTransactions bst
        INNER JOIN BeneficiaryPayments bp ON (
            -- Match by payment reference in description
            bst.Description LIKE '%' + bp.PaymentReference + '%'
            -- Amount matches (within 1 cent tolerance)
            AND ABS(bst.DebitAmount - bp.Amount) < 0.01
            -- Transaction is a debit (outgoing payment)
            AND bst.DebitAmount > 0
            -- Payment is awaiting bank confirmation
            AND bp.Status IN ('Sent to Bank', 'Approved')
        )
        WHERE bst.Status = 'Unmatched'
            AND bst.PostedToGL = 0
            AND (@BankAccountID IS NULL OR bst.BankAccountID = @BankAccountID)
            AND (@StatementLineID IS NULL OR bst.StatementLineID = @StatementLineID)
        
        SET @MatchedCount = @MatchedCount + @@ROWCOUNT
        
        -- Update beneficiary payment status
        UPDATE bp
        SET 
            Status = 'Matched',
            BankStatementLineID = bst.StatementLineID
        FROM BeneficiaryPayments bp
        INNER JOIN BankStatementTransactions bst ON bp.PaymentReference = bst.MatchedPaymentRef
        WHERE bst.Status = 'Matched' 
            AND bst.MatchedPaymentType = 'Beneficiary'
            AND bp.Status IN ('Sent to Bank', 'Approved')
        
        -- =============================================
        -- STEP 3: Match Customer Deposits (Credits)
        -- =============================================
        -- Match incoming payments from customers
        UPDATE bst
        SET 
            Status = 'Matched',
            MatchedPaymentType = 'Customer',
            MatchedBy = @UserName,
            MatchedDate = GETDATE(),
            Notes = 'Customer deposit - requires manual allocation'
        FROM BankStatementTransactions bst
        WHERE bst.Status = 'Unmatched'
            AND bst.CreditAmount > 0 -- Incoming payment
            AND bst.PostedToGL = 0
            AND (@BankAccountID IS NULL OR bst.BankAccountID = @BankAccountID)
            AND (@StatementLineID IS NULL OR bst.StatementLineID = @StatementLineID)
            -- Only if description contains customer reference patterns
            AND (
                bst.Description LIKE '%CUST-%'
                OR bst.Description LIKE '%ORD-%'
                OR bst.Description LIKE '%INV-%'
            )
        
        SET @MatchedCount = @MatchedCount + @@ROWCOUNT
        
        COMMIT TRANSACTION
        
        -- Return summary
        SELECT 
            @MatchedCount AS TotalMatched,
            (SELECT COUNT(*) FROM BankStatementTransactions WHERE Status = 'Matched' AND MatchedPaymentType = 'Supplier') AS SupplierPayments,
            (SELECT COUNT(*) FROM BankStatementTransactions WHERE Status = 'Matched' AND MatchedPaymentType = 'Beneficiary') AS BeneficiaryPayments,
            (SELECT COUNT(*) FROM BankStatementTransactions WHERE Status = 'Matched' AND MatchedPaymentType = 'Customer') AS CustomerDeposits,
            (SELECT COUNT(*) FROM BankStatementTransactions WHERE Status = 'Unmatched') AS StillUnmatched
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        SET @ErrorMessage = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

PRINT 'sp_AutoMatchBankTransactions created successfully'
GO
