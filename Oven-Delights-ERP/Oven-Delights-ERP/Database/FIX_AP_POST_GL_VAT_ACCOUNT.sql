-- =============================================
-- Fix sp_AP_PostAdhocInvoiceToGL to handle missing VAT Input account
-- Make VAT posting optional when VATAmount = 0
-- =============================================

IF OBJECT_ID('sp_AP_PostAdhocInvoiceToGL', 'P') IS NOT NULL
    DROP PROCEDURE sp_AP_PostAdhocInvoiceToGL
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE sp_AP_PostAdhocInvoiceToGL
    @InvoiceID INT,
    @InvoiceNumber NVARCHAR(50),
    @InvoiceDate DATE,
    @SupplierName NVARCHAR(200),
    @BranchID INT,
    @SubtotalAmount DECIMAL(18,2),
    @VATAmount DECIMAL(18,2),
    @TotalAmount DECIMAL(18,2),
    @ExpenseAccountCode NVARCHAR(20),
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @ExpenseAccountID INT
        DECLARE @VATInputAccountID INT
        DECLARE @APAccountID INT

        -- Get account IDs
        SELECT @ExpenseAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = @ExpenseAccountCode AND IsActive = 1
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2100' AND IsActive = 1

        -- Only get VAT account if VAT amount > 0
        IF @VATAmount > 0
        BEGIN
            SELECT @VATInputAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2200' AND IsActive = 1
            
            IF @VATInputAccountID IS NULL
                RAISERROR('VAT account 2200 not found or inactive', 16, 1)
        END

        -- Validate required accounts exist
        IF @ExpenseAccountID IS NULL
            RAISERROR('Expense account %s not found or inactive', 16, 1, @ExpenseAccountCode)

        IF @APAccountID IS NULL
            RAISERROR('Accounts Payable account 2100 not found or inactive', 16, 1)

        -- Generate journal number
        SET @JournalNumber = 'AP-' + @InvoiceNumber

        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @InvoiceDate,
            @InvoiceNumber,
            'ADHOC Invoice - ' + @SupplierName,
            dbo.fn_GetCurrentFiscalPeriodID(@InvoiceDate),
            1,
            @CreatedBy
        )

        SET @JournalID = SCOPE_IDENTITY()

        -- Debit: Expense Account (Subtotal excluding VAT)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 1, @ExpenseAccountID, @SubtotalAmount, 0,
            'Expense', @InvoiceNumber, @SupplierName
        )

        -- Debit: VAT Input (only if VAT amount > 0)
        IF @VATAmount > 0
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, 2, @VATInputAccountID, @VATAmount, 0,
                'VAT Input', @InvoiceNumber, @SupplierName
            )
        END

        -- Credit: Accounts Payable 2100 (Total including VAT)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 3, @APAccountID, 0, @TotalAmount,
            'Accounts Payable', @InvoiceNumber, @SupplierName
        )

        COMMIT TRANSACTION;

        SELECT @JournalID AS JournalID, 'ADHOC invoice posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 0 AS JournalID, 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT 'sp_AP_PostAdhocInvoiceToGL updated successfully'
GO

-- Now post the existing invoice 518
EXEC sp_AP_PostAdhocInvoiceToGL 
    @InvoiceID=518, 
    @InvoiceNumber='INV-NAI-001', 
    @InvoiceDate='2026-03-14', 
    @SupplierName='Mr Naidoo', 
    @BranchID=1, 
    @SubtotalAmount=5000.00, 
    @VATAmount=0.00, 
    @TotalAmount=5000.00, 
    @ExpenseAccountCode='5220', 
    @CreatedBy=1
GO
