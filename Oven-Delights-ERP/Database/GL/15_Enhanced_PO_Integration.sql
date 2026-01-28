-- =============================================
-- Enhanced Purchase Order GL Integration with VAT Input
-- =============================================

-- =============================================
-- sp_PO_PostInvoiceToGL_Enhanced - Post Supplier Invoice with VAT Input Split
-- =============================================
CREATE OR ALTER PROCEDURE sp_PO_PostInvoiceToGL
    @InvoiceID INT,
    @InvoiceNumber NVARCHAR(50),
    @InvoiceDate DATE,
    @SupplierName NVARCHAR(200),
    @BranchID INT,
    @SubtotalAmount DECIMAL(18,2),
    @VATAmount DECIMAL(18,2),
    @TotalAmount DECIMAL(18,2),
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @GRIRAccountID INT
        DECLARE @VATInputAccountID INT
        DECLARE @APAccountID INT
        
        -- Get account IDs
        SELECT @GRIRAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2050' AND IsActive = 1
        SELECT @VATInputAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2021' AND IsActive = 1
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2010' AND IsActive = 1
        
        -- Validate accounts exist
        IF @GRIRAccountID IS NULL
            RAISERROR('GRIR account 2050 not found or inactive', 16, 1)
            
        IF @VATInputAccountID IS NULL
            RAISERROR('VAT Input account 2021 not found or inactive', 16, 1)
            
        IF @APAccountID IS NULL
            RAISERROR('Accounts Payable account 2010 not found or inactive', 16, 1)
        
        -- Generate journal number
        SET @JournalNumber = 'INV-' + @InvoiceNumber
        
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
            'Supplier Invoice - ' + @SupplierName,
            dbo.fn_GetCurrentFiscalPeriodID(@InvoiceDate),
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Debit: GRIR (Clear pending - goods value excluding VAT)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 1, @GRIRAccountID, @SubtotalAmount, 0,
            'GRIR Clearance', @InvoiceNumber, @SupplierName
        )
        
        -- Debit: VAT Input (VAT claimable from SARS)
        IF @VATAmount > 0
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, 2, @VATInputAccountID, @VATAmount, 0,
                'VAT Input - Claimable', @InvoiceNumber, @SupplierName
            )
        END
        
        -- Credit: Accounts Payable (Total including VAT)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 3, @APAccountID, 0, @TotalAmount,
            'Accounts Payable', @InvoiceNumber, @SupplierName
        )
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, 'Supplier invoice posted to GL successfully with VAT split' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT 'Enhanced PO Integration with VAT Input created successfully'
GO
