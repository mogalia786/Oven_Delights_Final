-- =============================================
-- CREATE sp_PostDebitTransactionsToLedgers
-- Post debit transactions with supplier subsidiary ledger support
-- =============================================

IF OBJECT_ID('sp_PostDebitTransactionsToLedgers', 'P') IS NOT NULL
    DROP PROCEDURE sp_PostDebitTransactionsToLedgers;
GO

CREATE PROCEDURE sp_PostDebitTransactionsToLedgers
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
    DECLARE @DashPos INT;
    
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
    
    -- Only post Debit transactions (payments)
    IF @CreditDebitIndicator IN ('Debit', 'DBIT', 'debit', 'D')
    BEGIN
        -- PRIORITY 1: Try to match to supplier invoice (AP)
        DECLARE @InvoicePattern NVARCHAR(100);
        SET @InvoicePattern = '%INV%';
        
        -- PRIORITY 1: Try to match by invoice number
        IF @Description LIKE @InvoicePattern OR @Reference LIKE @InvoicePattern
        BEGIN
            SELECT TOP 1 @SupplierLedger = coa.AccountCode + ' - ' + coa.AccountName
            FROM AP_Invoices ap
            INNER JOIN ChartOfAccounts coa ON ap.BeneficiaryID = coa.SupplierID 
                AND coa.IsSubsidiaryLedger = 1
                AND coa.AccountType = 'Liability'
            WHERE (ap.InvoiceNumber LIKE '%' + REPLACE(REPLACE(@Description, 'INV-', ''), 'INV', '') + '%'
                   OR ap.InvoiceNumber LIKE '%' + REPLACE(REPLACE(@Reference, 'INV-', ''), 'INV', '') + '%'
                   OR ap.Reference LIKE '%' + REPLACE(REPLACE(@Description, 'INV-', ''), 'INV', '') + '%'
                   OR ap.Reference LIKE '%' + REPLACE(REPLACE(@Reference, 'INV-', ''), 'INV', '') + '%')
                AND ap.Status IN ('Pending', 'Overdue')
                AND ABS(ap.TotalAmount - @Amount) < 5.00
            ORDER BY ap.InvoiceDate DESC;
            
            IF @SupplierLedger IS NOT NULL
            BEGIN
                SET @DashPos = CHARINDEX(' - ', @SupplierLedger);
                IF @DashPos > 0
                    SET @ContraAccount = LEFT(@SupplierLedger, @DashPos - 1);
                ELSE
                    SET @ContraAccount = @SupplierLedger;
                SET @ContraDescription = 'Supplier Payment: ' + @Description;
                PRINT 'Matched to supplier by invoice: ' + @SupplierLedger;
            END
        END
        
        -- PRIORITY 2: Try to match by beneficiary name in description
        IF @SupplierLedger IS NULL
        BEGIN
            SELECT TOP 1 @SupplierLedger = coa.AccountCode + ' - ' + coa.AccountName
            FROM ChartOfAccounts coa
            INNER JOIN AP_Beneficiaries b ON coa.SupplierID = b.BeneficiaryID
            WHERE coa.IsSubsidiaryLedger = 1
                AND coa.AccountType = 'Liability'
                AND coa.IsActive = 1
                AND (
                    @Description LIKE '%' + b.BeneficiaryName + '%'
                    OR @Description LIKE '%' + LEFT(coa.AccountName, CHARINDEX(':', coa.AccountName) - 1) + '%'
                    OR @Reference LIKE '%' + b.BeneficiaryName + '%'
                )
            ORDER BY LEN(b.BeneficiaryName) DESC;
            
            IF @SupplierLedger IS NOT NULL
            BEGIN
                SET @DashPos = CHARINDEX(' - ', @SupplierLedger);
                IF @DashPos > 0
                    SET @ContraAccount = LEFT(@SupplierLedger, @DashPos - 1);
                ELSE
                    SET @ContraAccount = @SupplierLedger;
                SET @ContraDescription = 'Supplier Payment: ' + @Description;
                PRINT 'Matched to supplier by name: ' + @SupplierLedger;
            END
        END
        
        -- PRIORITY 2: Pattern-based mapping if no subsidiary ledger match
        IF @ContraAccount IS NULL
        BEGIN
            -- Bank Charges
            IF @Description LIKE '%BANK CHARGES%' OR @Description LIKE '%BANK FEE%' OR @Description LIKE '%SERVICE FEE%'
            BEGIN
                SET @ContraAccount = '6080'; -- Bank Charges & Fees
                SET @ContraDescription = 'Bank Charges: ' + @Description;
            END
            -- Rent
            ELSE IF @Description LIKE '%RENT%' OR @Description LIKE '%LEASE%'
            BEGIN
                SET @ContraAccount = '6010'; -- Rent Expense
                SET @ContraDescription = 'Rent Payment: ' + @Description;
            END
            -- Electricity
            ELSE IF @Description LIKE '%ELECTRICITY%' OR @Description LIKE '%ESKOM%' OR @Description LIKE '%CITY POWER%'
            BEGIN
                SET @ContraAccount = '6020'; -- Utilities - Electricity
                SET @ContraDescription = 'Electricity Payment: ' + @Description;
            END
            -- Water
            ELSE IF @Description LIKE '%WATER%' OR @Description LIKE '%MUNICIPAL%'
            BEGIN
                SET @ContraAccount = '6021'; -- Utilities - Water
                SET @ContraDescription = 'Water Payment: ' + @Description;
            END
            -- Telephone & Internet
            ELSE IF @Description LIKE '%TELEPHONE%' OR @Description LIKE '%INTERNET%' OR @Description LIKE '%VODACOM%' 
                OR @Description LIKE '%MTN%' OR @Description LIKE '%TELKOM%' OR @Description LIKE '%CELL C%'
            BEGIN
                SET @ContraAccount = '6023'; -- Telephone & Internet
                SET @ContraDescription = 'Telephone/Internet Payment: ' + @Description;
            END
            -- Salaries
            ELSE IF @Description LIKE '%SALARY%' OR @Description LIKE '%WAGES%' OR @Description LIKE '%PAYROLL%'
            BEGIN
                SET @ContraAccount = '6030'; -- Salaries & Wages
                SET @ContraDescription = 'Salary Payment: ' + @Description;
            END
            -- Office Supplies
            ELSE IF @Description LIKE '%STATIONERY%' OR @Description LIKE '%OFFICE SUPPLIES%'
            BEGIN
                SET @ContraAccount = '6050'; -- Office Supplies
                SET @ContraDescription = 'Office Supplies: ' + @Description;
            END
            -- Insurance
            ELSE IF @Description LIKE '%INSURANCE%' OR @Description LIKE '%PREMIUM%'
            BEGIN
                SET @ContraAccount = '6060'; -- Insurance Expense
                SET @ContraDescription = 'Insurance Payment: ' + @Description;
            END
            -- Repairs & Maintenance
            ELSE IF @Description LIKE '%REPAIRS%' OR @Description LIKE '%MAINTENANCE%'
            BEGIN
                SET @ContraAccount = '6090'; -- Repairs & Maintenance
                SET @ContraDescription = 'Repairs/Maintenance: ' + @Description;
            END
            -- Fuel
            ELSE IF @Description LIKE '%FUEL%' OR @Description LIKE '%PETROL%' OR @Description LIKE '%DIESEL%'
                OR @Description LIKE '%ENGEN%' OR @Description LIKE '%SHELL%' OR @Description LIKE '%BP%' OR @Description LIKE '%SASOL%'
            BEGIN
                SET @ContraAccount = '6100'; -- Vehicle Fuel
                SET @ContraDescription = 'Fuel Purchase: ' + @Description;
            END
            -- Interest Paid
            ELSE IF @Description LIKE '%INTEREST%' OR @Description LIKE '%LOAN%'
            BEGIN
                SET @ContraAccount = '7010'; -- Interest Expense
                SET @ContraDescription = 'Interest Payment: ' + @Description;
            END
            -- VAT/Tax
            ELSE IF @Description LIKE '%VAT%' OR @Description LIKE '%SARS%' OR @Description LIKE '%TAX%'
            BEGIN
                SET @ContraAccount = '2030'; -- VAT Payable
                SET @ContraDescription = 'VAT/Tax Payment: ' + @Description;
            END
            -- Supplier payments (FNB OB PMT)
            ELSE IF @Reference LIKE '%FNB OB PMT%' OR @Description LIKE '%SUPPLIER%'
            BEGIN
                SET @ContraAccount = '2100'; -- Accounts Payable (Control)
                SET @ContraDescription = 'Supplier Payment: ' + @Description;
            END
            -- Default to Accounts Payable Control
            ELSE
            BEGIN
                SET @ContraAccount = '2100'; -- Accounts Payable (Control)
                SET @ContraDescription = 'Payment: ' + @Description;
            END
        END
        
        SET @JournalEntryNumber = 'JE-' + CONVERT(VARCHAR(8), @TransactionDate, 112) + '-' + CAST(@TransactionID AS VARCHAR(10));
        
        BEGIN TRANSACTION;
        
        BEGIN TRY
            -- Post to Expense/Supplier Account (Debit - increases expense or reduces liability)
            INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
            VALUES (@JournalEntryNumber, @ContraAccount, @TransactionDate, @ContraDescription, @Amount, 0, @Reference, @PostedBy, GETDATE(), 0);
            
            -- Post to Bank Ledger (Credit - decreases bank balance)
            INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
            VALUES (@JournalEntryNumber, '1120', @TransactionDate, 'Bank Payment: ' + @Description, 0, @Amount, @Reference, @PostedBy, GETDATE(), 0);
            
            -- Mark transaction as reconciled/posted
            UPDATE AP_StatementTransactions
            SET IsReconciled = 1,
                ReconciledDate = GETDATE(),
                ReconciledBy = @PostedBy,
                MappedLedgerAccount = @ContraAccount
            WHERE TransactionID = @TransactionID;
            
            COMMIT TRANSACTION;
            
            PRINT 'Debit transaction posted to ' + @ContraAccount + ' and Bank (1120) successfully';
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
        PRINT 'Transaction is not a Debit transaction - no ledger posting required';
    END
END
GO

PRINT 'Created sp_PostDebitTransactionsToLedgers with supplier subsidiary ledger support';
