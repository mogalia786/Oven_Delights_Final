-- Add RunningBalance column to AP_StatementTransactions if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'RunningBalance')
BEGIN
    ALTER TABLE AP_StatementTransactions ADD RunningBalance DECIMAL(18,2) NULL;
    PRINT 'Added RunningBalance column to AP_StatementTransactions';
END
GO

-- Create stored procedure to calculate running balances
IF OBJECT_ID('sp_CalculateStatementRunningBalances', 'P') IS NOT NULL
    DROP PROCEDURE sp_CalculateStatementRunningBalances;
GO

CREATE PROCEDURE sp_CalculateStatementRunningBalances
    @AccountNumber NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @OpeningBalance DECIMAL(18,2) = 0;
    DECLARE @OpeningIndicator NVARCHAR(10) = 'Debit';
    
    -- Get opening balance
    SELECT TOP 1 
        @OpeningBalance = Amount,
        @OpeningIndicator = CreditDebitIndicator
    FROM AP_StatementBalances
    WHERE AccountNumber = @AccountNumber
      AND BalanceType = 'OPBD'
    ORDER BY BalanceDate DESC;
    
    -- Convert opening balance to signed value (Credit = positive, Debit = negative)
    IF @OpeningIndicator = 'Debit'
        SET @OpeningBalance = -@OpeningBalance;
    
    -- Calculate running balance for each transaction
    DECLARE @TransactionID INT;
    DECLARE @Amount DECIMAL(18,2);
    DECLARE @Indicator NVARCHAR(10);
    DECLARE @RunningBal DECIMAL(18,2) = @OpeningBalance;
    
    DECLARE cur CURSOR FOR
        SELECT TransactionID, Amount, CreditDebitIndicator
        FROM AP_StatementTransactions
        WHERE AccountNumber = @AccountNumber
        ORDER BY TransactionDate ASC, TransactionID ASC;
    
    OPEN cur;
    FETCH NEXT FROM cur INTO @TransactionID, @Amount, @Indicator;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Credit increases balance, Debit decreases balance
        IF @Indicator = 'Credit'
            SET @RunningBal = @RunningBal + @Amount;
        ELSE
            SET @RunningBal = @RunningBal - @Amount;
        
        -- Update running balance
        UPDATE AP_StatementTransactions
        SET RunningBalance = @RunningBal
        WHERE TransactionID = @TransactionID;
        
        FETCH NEXT FROM cur INTO @TransactionID, @Amount, @Indicator;
    END
    
    CLOSE cur;
    DEALLOCATE cur;
    
    PRINT 'Running balances calculated successfully';
END
GO

-- Create stored procedure to post credit transactions to ledgers
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
    -- Check for both 'Credit' and 'CRDT' as FNB API may use different formats
    IF @CreditDebitIndicator IN ('Credit', 'CRDT', 'credit', 'C')
    BEGIN
        -- Intelligent mapping based on Reference field patterns
        -- Check for Interest Earned
        IF @Description LIKE '%INTEREST%' OR @Description LIKE '%INT EARNED%' OR @Description LIKE '%BANK INTEREST%'
        BEGIN
            SET @ContraAccount = '4100'; -- Interest Income
            SET @ContraDescription = 'Interest Earned: ' + @Description;
        END
        -- Check for EFT Payments (FNB OB PMT)
        ELSE IF @Reference LIKE '%FNB OB PMT%'
        BEGIN
            SET @ContraAccount = '1200'; -- Accounts Receivable
            SET @ContraDescription = 'EFT Payment from Customer: ' + @Description;
        END
        -- Check for Collections from Debtors (FNB OB COLL)
        ELSE IF @Reference LIKE '%FNB OB COLL%'
        BEGIN
            SET @ContraAccount = '1200'; -- Accounts Receivable
            SET @ContraDescription = 'Collection from Debtor: ' + @Description;
        END
        -- Check for Bank Transfers (FNB OB TRF)
        ELSE IF @Reference LIKE '%FNB OB TRF%'
        BEGIN
            SET @ContraAccount = '1050'; -- Undeposited Funds / Inter-account transfer
            SET @ContraDescription = 'Bank Transfer: ' + @Description;
        END
        -- Check for Cash Deposits
        ELSE IF @Description LIKE '%DEPOSIT%' OR @Description LIKE '%CASH%' OR @Description LIKE '%ATM%' OR @Description LIKE '%BRANCH%'
        BEGIN
            SET @ContraAccount = '1000'; -- Cash on Hand
            SET @ContraDescription = 'Cash Deposit to Bank: ' + @Description;
        END
        -- Default to Undeposited Funds
        ELSE
        BEGIN
            SET @ContraAccount = '1050'; -- Undeposited Funds
            SET @ContraDescription = 'Bank Deposit: ' + @Description;
        END
        
        -- Generate unique Journal Entry Number (format: JE-YYYYMMDD-TransactionID)
        SET @JournalEntryNumber = 'JE-' + CONVERT(VARCHAR(8), @TransactionDate, 112) + '-' + CAST(@TransactionID AS VARCHAR(10));
        
        BEGIN TRANSACTION;
        
        BEGIN TRY
            -- Post to Bank Ledger (Debit - increases bank balance)
            INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
            VALUES (@JournalEntryNumber, '1120', @TransactionDate, 'Bank Deposit: ' + @Description, @Amount, 0, @Reference, @PostedBy, GETDATE(), 0);
            
            -- Post to Contra Account (Credit - based on intelligent mapping)
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
            
            PRINT 'Credit transaction posted to Bank (1120) and ' + @ContraAccount + ' ledgers successfully';
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

PRINT 'Bank statement procedures created successfully';
