-- =============================================
-- UPDATE sp_PostCreditTransactionsToLedgers
-- Add subsidiary ledger support for suppliers and customers
-- =============================================

IF OBJECT_ID('sp_PostCreditTransactionsToLedgers', 'P') IS NOT NULL
    DROP PROCEDURE sp_PostCreditTransactionsToLedgers;
GO

CREATE PROCEDURE sp_PostCreditTransactionsToLedgers
    @TransactionID INT,
    @PostedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Amount DECIMAL(18,2);
    DECLARE @CreditDebitIndicator NVARCHAR(10);
    DECLARE @Description NVARCHAR(500);
    DECLARE @TransactionDate DATE;
    DECLARE @Reference NVARCHAR(200);
    DECLARE @RelatedPartyName NVARCHAR(200);
    DECLARE @ContraAccount NVARCHAR(10);
    DECLARE @ContraDescription NVARCHAR(500);
    DECLARE @JournalEntryNumber NVARCHAR(50);
    DECLARE @SupplierLedger NVARCHAR(50);
    DECLARE @CustomerLedger NVARCHAR(50);
    DECLARE @InvoicePattern NVARCHAR(100);
    
    -- Get transaction details
    SELECT 
        @Amount = Amount,
        @CreditDebitIndicator = CreditDebitIndicator,
        @Description = Description,
        @TransactionDate = TransactionDate,
        @Reference = Reference,
        @RelatedPartyName = RelatedPartyName
    FROM AP_StatementTransactions
    WHERE TransactionID = @TransactionID;
    
    -- Only post Credit transactions (deposits)
    IF @CreditDebitIndicator IN ('Credit', 'CRDT', 'credit', 'C')
    BEGIN
        -- PRIORITY 1: Try to match to customer invoice (AR)
        -- Extract invoice number from description or reference
        SET @InvoicePattern = '%INV%';
        
        -- PRIORITY 1: Try to match by invoice number
        IF @Description LIKE @InvoicePattern OR @Reference LIKE @InvoicePattern
        BEGIN
            SELECT TOP 1 @CustomerLedger = coa.AccountCode + ' - ' + coa.AccountName
            FROM AR_Invoices ar
            INNER JOIN ChartOfAccounts coa ON ar.CustomerID = coa.CustomerID 
                AND coa.IsSubsidiaryLedger = 1
                AND coa.AccountType = 'Asset'
            WHERE (ar.InvoiceNumber LIKE '%' + REPLACE(REPLACE(@Description, 'INV-', ''), 'INV', '') + '%'
                   OR ar.InvoiceNumber LIKE '%' + REPLACE(REPLACE(@Reference, 'INV-', ''), 'INV', '') + '%')
                AND ar.PaymentStatus IN ('Pending', 'Partial')
                AND ABS(ar.TotalAmount - @Amount) < 5.00
            ORDER BY ar.InvoiceDate DESC;
            
            IF @CustomerLedger IS NOT NULL
            BEGIN
                SET @ContraAccount = LEFT(@CustomerLedger, CHARINDEX(' - ', @CustomerLedger) - 1);
                SET @ContraDescription = 'Customer Payment: ' + @Description;
                PRINT 'Matched to customer by invoice: ' + @CustomerLedger;
            END
        END
        
        -- PRIORITY 2: Try to match by customer name in description (skipped - no Customers table)
        -- Customer matching by name disabled until Customers table exists
        
        -- PRIORITY 2: Pattern-based mapping if no subsidiary ledger match
        IF @ContraAccount IS NULL
        BEGIN
            PRINT 'No subsidiary ledger match, trying pattern matching for: ' + @Description;
            
            -- Check for Cash Deposits and Bank Transfers FIRST (before FNB OB PMT)
            IF @Description LIKE '%DEPOSIT%' OR @Description LIKE '%TD TO%' OR @Description LIKE '%CASH DEPOSIT%' OR @Description LIKE '%ATM DEPOSIT%'
            BEGIN
                SET @ContraAccount = '1110'; -- Cash on Hand
                SET @ContraDescription = 'Cash Deposit/Transfer to Bank: ' + @Description;
                PRINT 'Matched to Cash on Hand (1110) for: ' + @Description;
            END
            -- Check for Interest Earned
            ELSE IF @Description LIKE '%INTEREST%' OR @Description LIKE '%INT EARNED%' OR @Description LIKE '%BANK INTEREST%'
            BEGIN
                SET @ContraAccount = '4300'; -- Interest Income
                SET @ContraDescription = 'Interest Earned: ' + @Description;
                PRINT 'Matched to Interest Income (4300)';
            END
            -- Check for EFT Payments (FNB OB PMT)
            ELSE IF @Reference LIKE '%FNB OB PMT%'
            BEGIN
                SET @ContraAccount = '1200'; -- Accounts Receivable (Control)
                SET @ContraDescription = 'EFT Payment from Customer: ' + @Description;
            END
            -- Check for Collections from Debtors (FNB OB COLL)
            ELSE IF @Reference LIKE '%FNB OB COLL%'
            BEGIN
                SET @ContraAccount = '1200'; -- Accounts Receivable (Control)
                SET @ContraDescription = 'Collection from Debtor: ' + @Description;
                PRINT 'Matched to Collection from Debtor (1200)';
            END
            -- Check for Sales/POS
            ELSE IF @Description LIKE '%SALES%' OR @Description LIKE '%POS%'
            BEGIN
                SET @ContraAccount = '4010'; -- Sales Revenue
                SET @ContraDescription = 'Sales Revenue: ' + @Description;
                PRINT 'Matched to Sales Revenue (4010)';
            END
            -- Default to Accounts Receivable Control
            ELSE
            BEGIN
                SET @ContraAccount = '1200'; -- Accounts Receivable (Control)
                SET @ContraDescription = 'Customer Receipt: ' + @Description;
                PRINT 'Defaulted to Accounts Receivable (1200)';
            END
        END
        
        -- Check if we have a valid contra account before posting
        IF @ContraAccount IS NULL
        BEGIN
            RAISERROR('No contra account determined for transaction. Description: %s, Reference: %s', 16, 1, @Description, @Reference);
            RETURN;
        END
        
        -- Generate unique Journal Entry Number
        SET @JournalEntryNumber = 'JE-' + CONVERT(VARCHAR(8), @TransactionDate, 112) + '-' + CAST(@TransactionID AS VARCHAR(10));
        
        BEGIN TRANSACTION;
        
        BEGIN TRY
            -- Post to Bank Ledger (Debit - increases bank balance)
            INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
            VALUES (@JournalEntryNumber, '1120', @TransactionDate, 'Bank Deposit: ' + @Description, @Amount, 0, @Reference, @PostedBy, GETDATE(), 0);
            
            -- Post to Contra Account (Credit - subsidiary ledger or control account)
            INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
            VALUES (@JournalEntryNumber, @ContraAccount, @TransactionDate, @ContraDescription, 0, @Amount, @Reference, @PostedBy, GETDATE(), 0);
            
            -- Mark transaction as reconciled/posted
            UPDATE AP_StatementTransactions
            SET IsReconciled = 1,
                ReconciledDate = GETDATE(),
                ReconciledBy = @PostedBy,
                MappedLedgerAccount = @ContraAccount
            WHERE TransactionID = @TransactionID;
            
            COMMIT TRANSACTION;
            
            PRINT 'Credit transaction posted to Bank (1120) and ' + @ContraAccount + ' successfully';
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
            
            DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
            RAISERROR(@ErrorMessage, 16, 1);
        END CATCH
    END
    ELSE
    BEGIN
        PRINT 'Transaction is not a Credit transaction - no ledger posting required';
    END
END
GO

PRINT 'Updated sp_PostCreditTransactionsToLedgers with subsidiary ledger support';
