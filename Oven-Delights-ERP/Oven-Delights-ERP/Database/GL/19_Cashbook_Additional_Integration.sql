-- =============================================
-- Additional Cashbook GL Integration
-- =============================================

-- =============================================
-- sp_CB_PostPettyCashTopUpToGL - Post Petty Cash Top-Up to GL
-- =============================================
CREATE OR ALTER PROCEDURE sp_CB_PostPettyCashTopUpToGL
    @TopUpID INT,
    @TopUpNumber NVARCHAR(50),
    @TopUpDate DATE,
    @Amount DECIMAL(18,2),
    @BranchID INT,
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @PettyCashAccountID INT
        DECLARE @BankAccountID INT
        
        -- Get account IDs
        SELECT @PettyCashAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1025' AND IsActive = 1
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        
        -- Validate accounts exist
        IF @PettyCashAccountID IS NULL
            RAISERROR('Petty Cash account 1025 not found or inactive', 16, 1)
            
        IF @BankAccountID IS NULL
            RAISERROR('Bank account 1010 not found or inactive', 16, 1)
        
        -- Generate journal number
        SET @JournalNumber = 'PCT-' + @TopUpNumber
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @TopUpDate,
            @TopUpNumber,
            'Petty Cash Top-Up',
            dbo.fn_GetCurrentFiscalPeriodID(@TopUpDate),
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Debit: Petty Cash (Increase float)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1
        )
        VALUES (
            @JournalID, 1, @PettyCashAccountID, @Amount, 0,
            'Petty Cash Replenishment', @TopUpNumber
        )
        
        -- Credit: Bank Account (Withdrawal from bank)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1
        )
        VALUES (
            @JournalID, 2, @BankAccountID, 0, @Amount,
            'Bank Withdrawal for Petty Cash', @TopUpNumber
        )
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, 'Petty cash top-up posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT 'Additional Cashbook GL Integration procedure created successfully'
GO
