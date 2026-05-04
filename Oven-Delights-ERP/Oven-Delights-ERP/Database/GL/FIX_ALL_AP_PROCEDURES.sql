-- =============================================
-- FIX ALL ACCOUNTS PAYABLE PROCEDURES
-- Updates all GL procedures to use account 2100
-- =============================================

PRINT '========================================='
PRINT 'FIXING ALL AP PROCEDURES TO USE 2100'
PRINT '========================================='
PRINT ''

-- =============================================
-- 1. FIX sp_PO_PostInvoiceToGL
-- =============================================
PRINT 'Fixing sp_PO_PostInvoiceToGL...'

IF OBJECT_ID('sp_PO_PostInvoiceToGL', 'P') IS NOT NULL
    DROP PROCEDURE sp_PO_PostInvoiceToGL
GO

CREATE PROCEDURE sp_PO_PostInvoiceToGL
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
        
        -- Get account IDs - USE 2100 FOR AP
        SELECT @GRIRAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2050' AND IsActive = 1
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2100' AND IsActive = 1
        
        IF @GRIRAccountID IS NULL
            RAISERROR('GRIR account 2050 not found', 16, 1)
        IF @APAccountID IS NULL
            RAISERROR('Accounts Payable account 2100 not found', 16, 1)
        
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
        
        -- Credit: Accounts Payable (2100)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 2, @APAccountID, 0, @TotalAmount,
            'Accounts Payable', @InvoiceNumber, @SupplierName
        )
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, 'Invoice posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT '✓ sp_PO_PostInvoiceToGL fixed (uses 2100)'
PRINT ''

-- =============================================
-- 2. FIX sp_AP_PostAdhocInvoiceToGL
-- =============================================
PRINT 'Fixing sp_AP_PostAdhocInvoiceToGL...'

IF OBJECT_ID('sp_AP_PostAdhocInvoiceToGL', 'P') IS NOT NULL
    DROP PROCEDURE sp_AP_PostAdhocInvoiceToGL
GO

CREATE PROCEDURE sp_AP_PostAdhocInvoiceToGL
    @InvoiceID INT,
    @InvoiceNumber NVARCHAR(50),
    @InvoiceDate DATE,
    @SupplierName NVARCHAR(200),
    @BranchID INT,
    @ExpenseAccountCode NVARCHAR(20),
    @TotalAmount DECIMAL(18,2),
    @VATAmount DECIMAL(18,2),
    @CreatedBy NVARCHAR(100)
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
        
        -- Get account IDs - USE 2100 FOR AP
        SELECT @ExpenseAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = @ExpenseAccountCode AND IsActive = 1
        SELECT @VATInputAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2021' AND IsActive = 1
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2100' AND IsActive = 1
        
        IF @ExpenseAccountID IS NULL
            RAISERROR('Expense account not found', 16, 1)
        IF @VATInputAccountID IS NULL
            RAISERROR('VAT Input account 2021 not found', 16, 1)
        IF @APAccountID IS NULL
            RAISERROR('Accounts Payable account 2100 not found', 16, 1)
        
        -- Generate journal number
        SET @JournalNumber = 'APINV-' + @InvoiceNumber
        
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
            'Adhoc Invoice - ' + @SupplierName,
            NULL,
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Debit: Expense
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 1, @ExpenseAccountID, @TotalAmount - @VATAmount, 0,
            'Expense', @InvoiceNumber, @SupplierName
        )
        
        -- Debit: VAT Input
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
        
        -- Credit: Accounts Payable (2100)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 3, @APAccountID, 0, @TotalAmount,
            'Accounts Payable', @InvoiceNumber, @SupplierName
        )
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, 'Adhoc invoice posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT '✓ sp_AP_PostAdhocInvoiceToGL fixed (uses 2100)'
PRINT ''

-- =============================================
-- 3. FIX sp_AP_PostInvoiceAccrual
-- =============================================
PRINT 'Fixing sp_AP_PostInvoiceAccrual...'

IF OBJECT_ID('sp_AP_PostInvoiceAccrual', 'P') IS NOT NULL
    DROP PROCEDURE sp_AP_PostInvoiceAccrual
GO

CREATE PROCEDURE sp_AP_PostInvoiceAccrual
    @InvoiceID INT,
    @InvoiceNumber NVARCHAR(50),
    @InvoiceDate DATE,
    @SupplierName NVARCHAR(200),
    @BranchID INT,
    @ExpenseAccountCode NVARCHAR(20),
    @TotalAmount DECIMAL(18,2),
    @VATAmount DECIMAL(18,2),
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(20)
        DECLARE @ExpenseAccountID INT
        DECLARE @VATInputAccountID INT
        DECLARE @APAccountID INT
        
        -- Get account IDs - USE 2100 FOR AP
        SELECT @ExpenseAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = @ExpenseAccountCode AND IsActive = 1
        SELECT @VATInputAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2021' AND IsActive = 1
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2100' AND IsActive = 1
        
        IF @ExpenseAccountID IS NULL
            RAISERROR('Expense account %s not found', 16, 1, @ExpenseAccountCode)
        IF @VATInputAccountID IS NULL
            RAISERROR('VAT Input account 2021 not found', 16, 1)
        IF @APAccountID IS NULL
            RAISERROR('Accounts Payable account 2100 not found', 16, 1)
        
        -- Generate journal number
        SET @JournalNumber = 'APINV-' + FORMAT(@InvoiceID, '000000')
        
        -- Create journal header
        INSERT INTO Journals (JournalNumber, JournalDate, Description, BranchID, CreatedBy, CreatedAt)
        VALUES (@JournalNumber, @InvoiceDate, 'AP Invoice: ' + @SupplierName, @BranchID, @CreatedBy, GETDATE())
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Journal Entry: DR Expense
        INSERT INTO JournalDetails (JournalID, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, @ExpenseAccountID, @TotalAmount - @VATAmount, 0, 'Expense: ' + @InvoiceNumber)
        
        -- Journal Entry: DR VAT Input
        IF @VATAmount > 0
        BEGIN
            INSERT INTO JournalDetails (JournalID, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, @VATInputAccountID, @VATAmount, 0, 'VAT Input: ' + @InvoiceNumber)
        END
        
        -- Journal Entry: CR Accounts Payable (2100)
        INSERT INTO JournalDetails (JournalID, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, @APAccountID, 0, @TotalAmount, 'AP: ' + @SupplierName)
        
        COMMIT TRANSACTION
        
        SELECT @JournalID AS JournalID, 'Invoice accrual posted successfully' AS Message
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

PRINT '✓ sp_AP_PostInvoiceAccrual fixed (uses 2100)'
PRINT ''

-- =============================================
-- 4. FIX sp_BankStatement_CompletePayment
-- =============================================
PRINT 'Fixing sp_BankStatement_CompletePayment...'

IF OBJECT_ID('sp_BankStatement_CompletePayment', 'P') IS NOT NULL
    DROP PROCEDURE sp_BankStatement_CompletePayment
GO

CREATE PROCEDURE sp_BankStatement_CompletePayment
    @TransactionID INT,
    @Amount DECIMAL(18,2),
    @TransactionDate DATE,
    @Description NVARCHAR(500),
    @Reference NVARCHAR(100),
    @SupplierName NVARCHAR(200),
    @PostedBy INT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @BankAccountID INT
        DECLARE @APAccountID INT
        DECLARE @SupplierID INT
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(20)
        DECLARE @BranchID INT = 1
        
        -- Get account IDs - USE 2100 FOR AP
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2100' AND IsActive = 1
        
        IF @BankAccountID IS NULL
            RAISERROR('Bank account 1010 not found', 16, 1)
        IF @APAccountID IS NULL
            RAISERROR('Accounts Payable account 2100 not found', 16, 1)
        
        -- Get SupplierID from AP_StatementTransactions if mapped
        SELECT @SupplierID = SupplierID 
        FROM AP_StatementTransactions 
        WHERE TransactionID = @TransactionID
        
        -- If no SupplierID mapped, try to find by name
        IF @SupplierID IS NULL
        BEGIN
            SELECT @SupplierID = SupplierID 
            FROM Suppliers 
            WHERE CompanyName = @SupplierName AND IsActive = 1
        END
        
        -- Create journal entry
        SET @JournalNumber = 'BANK-' + FORMAT(@TransactionID, '000000')
        
        INSERT INTO Journals (JournalNumber, JournalDate, Description, BranchID, CreatedBy, CreatedAt)
        VALUES (@JournalNumber, @TransactionDate, 'Bank Payment: ' + @Description, @BranchID, @PostedBy, GETDATE())
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Journal Entry: DR Accounts Payable (2100) - clear liability
        INSERT INTO JournalDetails (JournalID, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, @APAccountID, @Amount, 0, @Description)
        
        -- Journal Entry: CR Bank - reduce asset
        INSERT INTO JournalDetails (JournalID, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, @BankAccountID, 0, @Amount, @Description)
        
        -- Post to GeneralLedger
        INSERT INTO GeneralLedger (AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate)
        VALUES (@APAccountID, @TransactionDate, @Description, @Amount, 0, @Reference, @PostedBy, GETDATE())
        
        INSERT INTO GeneralLedger (AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate)
        VALUES (@BankAccountID, @TransactionDate, @Description, 0, @Amount, @Reference, @PostedBy, GETDATE())
        
        -- Post to SupplierLedger if supplier identified
        IF @SupplierID IS NOT NULL
        BEGIN
            DECLARE @SupplierCode NVARCHAR(50)
            SELECT @SupplierCode = SupplierCode FROM Suppliers WHERE SupplierID = @SupplierID
            
            INSERT INTO SupplierLedger (
                SupplierID, SupplierCode, SupplierName, TransactionDate, 
                TransactionType, ReferenceNumber, Description, 
                DebitAmount, CreditAmount, RunningBalance, 
                BranchID, CreatedBy, CreatedDate
            )
            SELECT 
                @SupplierID,
                @SupplierCode,
                @SupplierName,
                @TransactionDate,
                'Payment',
                @Reference,
                @Description,
                @Amount,
                0,
                ISNULL((SELECT TOP 1 RunningBalance FROM SupplierLedger WHERE SupplierID = @SupplierID ORDER BY LedgerID DESC), 0) - @Amount,
                @BranchID,
                @PostedBy,
                GETDATE()
        END
        
        -- Mark transaction as reconciled
        UPDATE AP_StatementTransactions
        SET IsReconciled = 1,
            ReconciledDate = GETDATE(),
            ReconciledBy = @PostedBy
        WHERE TransactionID = @TransactionID
        
        COMMIT TRANSACTION
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

PRINT '✓ sp_BankStatement_CompletePayment fixed (uses 2100)'
PRINT ''

-- =============================================
-- 5. FIX sp_PO_MatchInvoiceToGRV (if exists)
-- =============================================
IF OBJECT_ID('sp_PO_MatchInvoiceToGRV', 'P') IS NOT NULL
BEGIN
    PRINT 'Fixing sp_PO_MatchInvoiceToGRV...'
    
    DROP PROCEDURE sp_PO_MatchInvoiceToGRV
    
    EXEC('
    CREATE PROCEDURE sp_PO_MatchInvoiceToGRV
        @InvoiceID INT,
        @InvoiceNumber NVARCHAR(50),
        @InvoiceDate DATE,
        @SupplierName NVARCHAR(200),
        @BranchID INT,
        @TotalAmount DECIMAL(18,2),
        @VATAmount DECIMAL(18,2),
        @CreatedBy INT
    AS
    BEGIN
        SET NOCOUNT ON
        
        BEGIN TRY
            BEGIN TRANSACTION
            
            DECLARE @JournalID INT
            DECLARE @JournalNumber NVARCHAR(20)
            DECLARE @GRIRAccountID INT
            DECLARE @VATInputAccountID INT
            DECLARE @APAccountID INT
            
            -- Get account IDs - USE 2100 FOR AP
            SELECT @GRIRAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = ''2050'' AND IsActive = 1
            SELECT @VATInputAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = ''2021'' AND IsActive = 1
            SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = ''2100'' AND IsActive = 1
            
            IF @GRIRAccountID IS NULL
                RAISERROR(''GRIR account 2050 not found'', 16, 1)
            IF @VATInputAccountID IS NULL
                RAISERROR(''VAT Input account 2021 not found'', 16, 1)
            IF @APAccountID IS NULL
                RAISERROR(''Accounts Payable account 2100 not found'', 16, 1)
            
            -- Generate journal number
            SET @JournalNumber = ''INV-'' + FORMAT(@InvoiceID, ''000000'')
            
            -- Create journal header
            INSERT INTO Journals (JournalNumber, JournalDate, Description, BranchID, CreatedBy, CreatedAt)
            VALUES (@JournalNumber, @InvoiceDate, ''Invoice Match: '' + @SupplierName, @BranchID, @CreatedBy, GETDATE())
            
            SET @JournalID = SCOPE_IDENTITY()
            
            -- Journal Entry: DR GRIR (clear pending goods)
            INSERT INTO JournalDetails (JournalID, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, @GRIRAccountID, @TotalAmount - @VATAmount, 0, ''GRIR Clearance: '' + @InvoiceNumber)
            
            -- Journal Entry: DR VAT Input
            IF @VATAmount > 0
            BEGIN
                INSERT INTO JournalDetails (JournalID, AccountID, Debit, Credit, Description)
                VALUES (@JournalID, @VATInputAccountID, @VATAmount, 0, ''VAT Input: '' + @InvoiceNumber)
            END
            
            -- Journal Entry: CR Accounts Payable (2100)
            INSERT INTO JournalDetails (JournalID, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, @APAccountID, 0, @TotalAmount, ''AP: '' + @SupplierName)
            
            COMMIT TRANSACTION
            
            SELECT @JournalID AS JournalID, ''Invoice matched successfully'' AS Message
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION
            
            DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
            RAISERROR(@ErrorMessage, 16, 1)
        END CATCH
    END
    ')
    
    PRINT '✓ sp_PO_MatchInvoiceToGRV fixed (uses 2100)'
    PRINT ''
END

PRINT ''
PRINT '========================================='
PRINT 'ALL AP PROCEDURES FIXED'
PRINT '========================================='
PRINT ''
PRINT 'All procedures now use account 2100 for Accounts Payable'
PRINT ''
PRINT 'Next steps:'
PRINT '  1. Update LedgerHierarchyForm.vb to use 2100'
PRINT '  2. Update bank transaction mapping rules to use 2100'
PRINT '  3. Test GRV → Invoice → Payment workflow'
PRINT ''
