-- =============================================
-- Inter-Branch Transfer GL Integration
-- =============================================

-- =============================================
-- sp_IBT_PostReceiptToGL - Post IBT Receipt at Receiving Branch
-- =============================================
CREATE OR ALTER PROCEDURE sp_IBT_PostReceiptToGL
    @TransferID INT,
    @TransferNumber NVARCHAR(50),
    @ReceiptDate DATE,
    @FromBranchID INT,
    @ToBranchID INT,
    @TotalValue DECIMAL(18,2),
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @InventoryAccountID INT
        DECLARE @InterBranchCreditorsAccountID INT
        
        -- Get account IDs
        SELECT @InventoryAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1220' AND IsActive = 1
        SELECT @InterBranchCreditorsAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1610' AND IsActive = 1
        
        -- Validate accounts exist
        IF @InventoryAccountID IS NULL
            RAISERROR('Inventory account 1220 not found or inactive', 16, 1)
            
        IF @InterBranchCreditorsAccountID IS NULL
            RAISERROR('Inter-Branch Creditors account 1610 not found or inactive', 16, 1)
        
        -- Generate journal number
        SET @JournalNumber = 'IBT-R-' + @TransferNumber
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @ToBranchID,
            @ReceiptDate,
            @TransferNumber,
            'Inventory Received from Branch ' + CAST(@FromBranchID AS NVARCHAR(10)),
            dbo.fn_GetCurrentFiscalPeriodID(@ReceiptDate),
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Debit: Inventory (Goods received)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 1, @InventoryAccountID, @TotalValue, 0,
            'Goods Received', @TransferNumber, 'From Branch ' + CAST(@FromBranchID AS NVARCHAR(10))
        )
        
        -- Credit: Inter-Branch Creditors (Owe sending branch)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 2, @InterBranchCreditorsAccountID, 0, @TotalValue,
            'Inter-Branch Payable', @TransferNumber, 'To Branch ' + CAST(@FromBranchID AS NVARCHAR(10))
        )
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, 'IBT receipt posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- =============================================
-- sp_IBT_PostSettlementToGL - Post Inter-Branch Settlement Payment
-- =============================================
CREATE OR ALTER PROCEDURE sp_IBT_PostSettlementToGL
    @SettlementID INT,
    @SettlementNumber NVARCHAR(50),
    @SettlementDate DATE,
    @FromBranchID INT, -- Paying branch
    @ToBranchID INT,   -- Receiving branch
    @Amount DECIMAL(18,2),
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID_Paying INT
        DECLARE @JournalID_Receiving INT
        DECLARE @JournalNumber_Paying NVARCHAR(50)
        DECLARE @JournalNumber_Receiving NVARCHAR(50)
        DECLARE @BankAccountID INT
        DECLARE @InterBranchDebtorsAccountID INT
        DECLARE @InterBranchCreditorsAccountID INT
        
        -- Get account IDs
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @InterBranchDebtorsAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1600' AND IsActive = 1
        SELECT @InterBranchCreditorsAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1610' AND IsActive = 1
        
        -- Validate accounts exist
        IF @BankAccountID IS NULL
            RAISERROR('Bank account 1010 not found or inactive', 16, 1)
            
        IF @InterBranchDebtorsAccountID IS NULL
            RAISERROR('Inter-Branch Debtors account 1600 not found or inactive', 16, 1)
            
        IF @InterBranchCreditorsAccountID IS NULL
            RAISERROR('Inter-Branch Creditors account 1610 not found or inactive', 16, 1)
        
        -- ========================================
        -- PAYING BRANCH JOURNAL (FromBranchID)
        -- ========================================
        SET @JournalNumber_Paying = 'IBT-P-' + @SettlementNumber
        
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber_Paying,
            @FromBranchID,
            @SettlementDate,
            @SettlementNumber,
            'IBT Payment to Branch ' + CAST(@ToBranchID AS NVARCHAR(10)),
            dbo.fn_GetCurrentFiscalPeriodID(@SettlementDate),
            1,
            @CreatedBy
        )
        
        SET @JournalID_Paying = SCOPE_IDENTITY()
        
        -- Debit: Inter-Branch Creditors (Clear payable)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID_Paying, 1, @InterBranchCreditorsAccountID, @Amount, 0,
            'Clear Inter-Branch Payable', @SettlementNumber, 'To Branch ' + CAST(@ToBranchID AS NVARCHAR(10))
        )
        
        -- Credit: Bank Account (Payment made)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID_Paying, 2, @BankAccountID, 0, @Amount,
            'Bank Payment', @SettlementNumber, 'To Branch ' + CAST(@ToBranchID AS NVARCHAR(10))
        )
        
        -- ========================================
        -- RECEIVING BRANCH JOURNAL (ToBranchID)
        -- ========================================
        SET @JournalNumber_Receiving = 'IBT-S-' + @SettlementNumber
        
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber_Receiving,
            @ToBranchID,
            @SettlementDate,
            @SettlementNumber,
            'IBT Payment from Branch ' + CAST(@FromBranchID AS NVARCHAR(10)),
            dbo.fn_GetCurrentFiscalPeriodID(@SettlementDate),
            1,
            @CreatedBy
        )
        
        SET @JournalID_Receiving = SCOPE_IDENTITY()
        
        -- Debit: Bank Account (Payment received)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID_Receiving, 1, @BankAccountID, @Amount, 0,
            'Bank Receipt', @SettlementNumber, 'From Branch ' + CAST(@FromBranchID AS NVARCHAR(10))
        )
        
        -- Credit: Inter-Branch Debtors (Clear receivable)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID_Receiving, 2, @InterBranchDebtorsAccountID, 0, @Amount,
            'Clear Inter-Branch Receivable', @SettlementNumber, 'From Branch ' + CAST(@FromBranchID AS NVARCHAR(10))
        )
        
        COMMIT TRANSACTION;
        
        SELECT 
            @JournalID_Paying AS JournalID_Paying, 
            @JournalID_Receiving AS JournalID_Receiving,
            'IBT settlement posted to GL successfully for both branches' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT 'IBT GL Integration procedures created successfully'
GO
