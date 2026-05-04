-- =============================================
-- Purchase Order GL Integration Procedures
-- =============================================

-- =============================================
-- sp_PO_PostGRVToGL - Post Goods Receipt to GL (GRIR Method)
-- =============================================
CREATE OR ALTER PROCEDURE sp_PO_PostGRVToGL
    @GRVID INT,
    @GRVNumber NVARCHAR(50),
    @GRVDate DATE,
    @SupplierName NVARCHAR(200),
    @BranchID INT,
    @TotalAmount DECIMAL(18,2),
    @CreatedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @InventoryAccountID INT
        DECLARE @GRIRAccountID INT
        
        -- Get account IDs
        SELECT @InventoryAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1220' AND IsActive = 1
        SELECT @GRIRAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2050' AND IsActive = 1
        
        -- Generate journal number
        SET @JournalNumber = 'GRV-' + @GRVNumber
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @GRVDate,
            @GRVNumber,
            'GRV - ' + @SupplierName,
            NULL,
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
            @JournalID, 1, @InventoryAccountID, @TotalAmount, 0,
            'Goods Received', @GRVNumber, @SupplierName
        )
        
        -- Credit: GRIR (Invoice pending)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 2, @GRIRAccountID, 0, @TotalAmount,
            'GRIR - Invoice Pending', @GRVNumber, @SupplierName
        )
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, 'GRV posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- =============================================
-- sp_PO_PostInvoiceToGL - Post Supplier Invoice to GL
-- =============================================
CREATE OR ALTER PROCEDURE sp_PO_PostInvoiceToGL
    @InvoiceID INT,
    @InvoiceNumber NVARCHAR(50),
    @InvoiceDate DATE,
    @SupplierName NVARCHAR(200),
    @BranchID INT,
    @TotalAmount DECIMAL(18,2),
    @CreatedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @GRIRAccountID INT
        DECLARE @APAccountID INT
        
        -- Get account IDs
        SELECT @GRIRAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2050' AND IsActive = 1
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2010' AND IsActive = 1
        
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
            NULL,
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Debit: GRIR (Clear pending)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 1, @GRIRAccountID, @TotalAmount, 0,
            'GRIR Clearance', @InvoiceNumber, @SupplierName
        )
        
        -- Credit: Accounts Payable
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 2, @APAccountID, 0, @TotalAmount,
            'Accounts Payable', @InvoiceNumber, @SupplierName
        )
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, 'Supplier invoice posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT 'Purchase Order Integration procedures created successfully'
GO
