-- =============================================
-- Stored Procedure: sp_PostBankTransactionsToGL
-- Purpose: Post matched bank transactions to General Ledger
-- Features: Full validation, duplicate prevention, debit/credit balance check
-- CRITICAL: DO NOT BREAK EXISTING FEATURES - This is a NEW posting method
-- =============================================
-- NOTE: Connect to OvenDelightsERP database before executing
-- GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_PostBankTransactionsToGL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_PostBankTransactionsToGL]
GO

CREATE PROCEDURE [dbo].[sp_PostBankTransactionsToGL]
    @StatementLineID INT = NULL, -- Post specific line, or NULL for all matched
    @BankAccountID INT = NULL,
    @UserName NVARCHAR(100),
    @PostingDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ErrorMessage NVARCHAR(MAX)
    DECLARE @PostedCount INT = 0
    DECLARE @TotalDebits DECIMAL(18,2) = 0
    DECLARE @TotalCredits DECIMAL(18,2) = 0
    DECLARE @GLBatchID INT
    
    -- Use today if no posting date specified
    IF @PostingDate IS NULL
        SET @PostingDate = CAST(GETDATE() AS DATE)
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Create GL batch for this posting session
        INSERT INTO GLBatches (BatchNumber, BatchDate, Description, CreatedBy, CreatedDate)
        VALUES (
            'BANK-' + FORMAT(GETDATE(), 'yyyyMMdd-HHmmss') + '-' + CAST(DATEPART(MILLISECOND, GETDATE()) AS NVARCHAR),
            @PostingDate,
            'Bank statement reconciliation posting',
            @UserName,
            GETDATE()
        )
        SET @GLBatchID = SCOPE_IDENTITY()
        
        -- =============================================
        -- STEP 1: Post Supplier Payments
        -- =============================================
        DECLARE @SupplierTransactions TABLE (
            StatementLineID INT,
            InvoiceID INT,
            SupplierID INT,
            SupplierName NVARCHAR(200),
            InvoiceNumber NVARCHAR(50),
            Amount DECIMAL(18,2),
            BankAccountID INT,
            TransactionDate DATE
        )
        
        INSERT INTO @SupplierTransactions
        SELECT 
            bst.StatementLineID,
            si.InvoiceID,
            si.SupplierID,
            s.SupplierName,
            si.InvoiceNumber,
            bst.DebitAmount,
            bst.BankAccountID,
            bst.TransactionDate
        FROM BankStatementTransactions bst
        INNER JOIN SupplierInvoices si ON bst.MatchedReferenceID = si.InvoiceID
        INNER JOIN Suppliers s ON si.SupplierID = s.SupplierID
        WHERE bst.Status = 'Matched'
            AND bst.MatchedPaymentType = 'Supplier'
            AND bst.PostedToGL = 0
            AND (@StatementLineID IS NULL OR bst.StatementLineID = @StatementLineID)
            AND (@BankAccountID IS NULL OR bst.BankAccountID = @BankAccountID)
        
        -- Post supplier payment entries
        DECLARE @StmtLineID INT, @InvID INT, @SuppID INT, @SuppName NVARCHAR(200), @InvNum NVARCHAR(50)
        DECLARE @Amt DECIMAL(18,2), @BankAcctID INT, @TxnDate DATE
        DECLARE @PayablesAccountID INT, @BankGLAccountID INT
        
        -- Get standard Accounts Payable account (2100)
        SELECT @PayablesAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2100'
        
        DECLARE supplier_cursor CURSOR FOR
        SELECT StatementLineID, InvoiceID, SupplierID, SupplierName, InvoiceNumber, Amount, BankAccountID, TransactionDate
        FROM @SupplierTransactions
        
        OPEN supplier_cursor
        FETCH NEXT FROM supplier_cursor INTO @StmtLineID, @InvID, @SuppID, @SuppName, @InvNum, @Amt, @BankAcctID, @TxnDate
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Check for duplicate posting (transaction already posted)
            IF EXISTS (
                SELECT 1 FROM BankStatementTransactions 
                WHERE StatementLineID = @StmtLineID
                AND PostedToGL = 1
            )
            BEGIN
                SET @ErrorMessage = 'Statement line ' + CAST(@StmtLineID AS NVARCHAR) + ' has already been posted to GL'
                RAISERROR(@ErrorMessage, 16, 1)
                CLOSE supplier_cursor
                DEALLOCATE supplier_cursor
                ROLLBACK TRANSACTION
                RETURN
            END
            
            -- Get bank GL account
            SELECT @BankGLAccountID = GLAccountID FROM BankAccounts WHERE BankAccountID = @BankAcctID
            
            IF @BankGLAccountID IS NULL
            BEGIN
                SET @ErrorMessage = 'Bank account GL mapping not found for BankAccountID: ' + CAST(@BankAcctID AS NVARCHAR)
                RAISERROR(@ErrorMessage, 16, 1)
                CLOSE supplier_cursor
                DEALLOCATE supplier_cursor
                ROLLBACK TRANSACTION
                RETURN
            END
            
            -- CREDIT: Bank Account (Asset decreases - money leaving)
            INSERT INTO GeneralLedger (
                AccountID, TransactionDate, Description, 
                DebitAmount, CreditAmount, 
                ReferenceType, ReferenceID, 
                JournalEntryNumber, CreatedBy, CreatedDate
            )
            VALUES (
                @BankGLAccountID,
                @TxnDate,
                'Payment to ' + @SuppName + ' - Invoice ' + @InvNum,
                0,
                @Amt,
                'BankStatement',
                @StmtLineID,
                'BANK-' + CAST(@GLBatchID AS NVARCHAR),
                @UserName,
                GETDATE()
            )
            
            SET @TotalCredits = @TotalCredits + @Amt
            
            -- DEBIT: Accounts Payable - Supplier (Liability decreases)
            INSERT INTO GeneralLedger (
                AccountID, TransactionDate, Description,
                DebitAmount, CreditAmount,
                ReferenceType, ReferenceID,
                JournalEntryNumber, CreatedBy, CreatedDate
            )
            VALUES (
                @PayablesAccountID,
                @TxnDate,
                'Payment to ' + @SuppName + ' - Invoice ' + @InvNum,
                @Amt,
                0,
                'BankStatement',
                @StmtLineID,
                'BANK-' + CAST(@GLBatchID AS NVARCHAR),
                @UserName,
                GETDATE()
            )
            
            SET @TotalDebits = @TotalDebits + @Amt
            
            -- Update bank statement transaction
            UPDATE BankStatementTransactions
            SET PostedToGL = 1,
                PostedBy = @UserName,
                PostedDate = GETDATE(),
                GLBatchID = @GLBatchID,
                Status = 'Posted'
            WHERE StatementLineID = @StmtLineID
            
            -- Update supplier invoice
            UPDATE SupplierInvoices
            SET Status = 'Paid',
                PaidDate = @TxnDate
            WHERE InvoiceID = @InvID
            
            SET @PostedCount = @PostedCount + 1
            
            FETCH NEXT FROM supplier_cursor INTO @StmtLineID, @InvID, @SuppID, @SuppName, @InvNum, @Amt, @BankAcctID, @TxnDate
        END
        
        CLOSE supplier_cursor
        DEALLOCATE supplier_cursor
        
        -- =============================================
        -- STEP 2: Post Beneficiary Payments
        -- =============================================
        DECLARE @BeneficiaryTransactions TABLE (
            StatementLineID INT,
            PaymentID INT,
            BeneficiaryName NVARCHAR(200),
            Category NVARCHAR(100),
            Description NVARCHAR(500),
            Amount DECIMAL(18,2),
            BankAccountID INT,
            TransactionDate DATE
        )
        
        INSERT INTO @BeneficiaryTransactions
        SELECT 
            bst.StatementLineID,
            bp.PaymentID,
            b.BeneficiaryName,
            b.Category,
            bp.Description,
            bst.DebitAmount,
            bst.BankAccountID,
            bst.TransactionDate
        FROM BankStatementTransactions bst
        INNER JOIN BeneficiaryPayments bp ON bst.MatchedReferenceID = bp.PaymentID
        INNER JOIN Beneficiaries b ON bp.BeneficiaryID = b.BeneficiaryID
        WHERE bst.Status = 'Matched'
            AND bst.MatchedPaymentType = 'Beneficiary'
            AND bst.PostedToGL = 0
            AND (@StatementLineID IS NULL OR bst.StatementLineID = @StatementLineID)
            AND (@BankAccountID IS NULL OR bst.BankAccountID = @BankAccountID)
        
        -- Post beneficiary payment entries
        DECLARE @PayID INT, @BenName NVARCHAR(200), @Cat NVARCHAR(100), @Desc NVARCHAR(500), @ExpAcctID INT
        
        DECLARE beneficiary_cursor CURSOR FOR
        SELECT StatementLineID, PaymentID, BeneficiaryName, Category, Description, Amount, BankAccountID, TransactionDate
        FROM @BeneficiaryTransactions
        
        OPEN beneficiary_cursor
        FETCH NEXT FROM beneficiary_cursor INTO @StmtLineID, @PayID, @BenName, @Cat, @Desc, @Amt, @BankAcctID, @TxnDate
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Check for duplicate posting (transaction already posted)
            IF EXISTS (
                SELECT 1 FROM BankStatementTransactions 
                WHERE StatementLineID = @StmtLineID
                AND PostedToGL = 1
            )
            BEGIN
                SET @ErrorMessage = 'Statement line ' + CAST(@StmtLineID AS NVARCHAR) + ' has already been posted to GL'
                RAISERROR(@ErrorMessage, 16, 1)
                CLOSE beneficiary_cursor
                DEALLOCATE beneficiary_cursor
                ROLLBACK TRANSACTION
                RETURN
            END
            
            -- Get bank GL account
            SELECT @BankGLAccountID = GLAccountID FROM BankAccounts WHERE BankAccountID = @BankAcctID
            
            IF @BankGLAccountID IS NULL
            BEGIN
                SET @ErrorMessage = 'Bank account GL mapping not found for BankAccountID: ' + CAST(@BankAcctID AS NVARCHAR)
                RAISERROR(@ErrorMessage, 16, 1)
                CLOSE beneficiary_cursor
                DEALLOCATE beneficiary_cursor
                ROLLBACK TRANSACTION
                RETURN
            END
            
            -- Get expense account based on category (map to Chart of Accounts)
            -- Default to General Expenses (5000) if category not found
            SELECT @ExpAcctID = AccountID 
            FROM ChartOfAccounts 
            WHERE AccountName LIKE '%' + @Cat + '%' AND AccountType = 'Expense'
            
            IF @ExpAcctID IS NULL
                SELECT @ExpAcctID = AccountID FROM ChartOfAccounts WHERE AccountCode = '5000' -- General Expenses
            
            -- CREDIT: Bank Account (Asset decreases - money leaving)
            INSERT INTO GeneralLedger (
                AccountID, TransactionDate, Description,
                DebitAmount, CreditAmount,
                ReferenceType, ReferenceID,
                JournalEntryNumber, CreatedBy, CreatedDate
            )
            VALUES (
                @BankGLAccountID,
                @TxnDate,
                'Payment to ' + @BenName + ' - ' + @Cat + ' - ' + ISNULL(@Desc, ''),
                0,
                @Amt,
                'BankStatement',
                @StmtLineID,
                'BANK-' + CAST(@GLBatchID AS NVARCHAR),
                @UserName,
                GETDATE()
            )
            
            SET @TotalCredits = @TotalCredits + @Amt
            
            -- DEBIT: Expense Account (Expense increases)
            INSERT INTO GeneralLedger (
                AccountID, TransactionDate, Description,
                DebitAmount, CreditAmount,
                ReferenceType, ReferenceID,
                JournalEntryNumber, CreatedBy, CreatedDate
            )
            VALUES (
                @ExpAcctID,
                @TxnDate,
                @BenName + ' - ' + @Cat + ' - ' + ISNULL(@Desc, ''),
                @Amt,
                0,
                'BankStatement',
                @StmtLineID,
                'BANK-' + CAST(@GLBatchID AS NVARCHAR),
                @UserName,
                GETDATE()
            )
            
            SET @TotalDebits = @TotalDebits + @Amt
            
            -- Update bank statement transaction
            UPDATE BankStatementTransactions
            SET PostedToGL = 1,
                PostedBy = @UserName,
                PostedDate = GETDATE(),
                GLBatchID = @GLBatchID,
                Status = 'Posted'
            WHERE StatementLineID = @StmtLineID
            
            -- Update beneficiary payment
            UPDATE BeneficiaryPayments
            SET Status = 'Paid',
                PaidDate = @TxnDate
            WHERE PaymentID = @PayID
            
            SET @PostedCount = @PostedCount + 1
            
            FETCH NEXT FROM beneficiary_cursor INTO @StmtLineID, @PayID, @BenName, @Cat, @Desc, @Amt, @BankAcctID, @TxnDate
        END
        
        CLOSE beneficiary_cursor
        DEALLOCATE beneficiary_cursor
        
        -- =============================================
        -- CRITICAL VALIDATION: Debits MUST equal Credits
        -- =============================================
        IF ABS(@TotalDebits - @TotalCredits) > 0.01
        BEGIN
            SET @ErrorMessage = 'VALIDATION FAILED: Debits (' + CAST(@TotalDebits AS NVARCHAR) + 
                              ') do not equal Credits (' + CAST(@TotalCredits AS NVARCHAR) + ')'
            RAISERROR(@ErrorMessage, 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END
        
        -- Update GL batch totals
        UPDATE GLBatches
        SET TotalDebits = @TotalDebits,
            TotalCredits = @TotalCredits,
            Status = 'Posted'
        WHERE BatchID = @GLBatchID
        
        COMMIT TRANSACTION
        
        -- Return summary
        SELECT 
            @PostedCount AS TransactionsPosted,
            @TotalDebits AS TotalDebits,
            @TotalCredits AS TotalCredits,
            @GLBatchID AS GLBatchID,
            'SUCCESS: All entries balanced and posted' AS Message
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        SET @ErrorMessage = ERROR_MESSAGE()
        
        -- Return error details
        SELECT 
            0 AS TransactionsPosted,
            @ErrorMessage AS ErrorMessage,
            'FAILED' AS Status
        
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

PRINT 'sp_PostBankTransactionsToGL created successfully'
GO
