-- =============================================
-- CREATE ALL POSTING PROCEDURES
-- Stored procedures for posting ALL types of journal entries:
-- - Customer invoices/payments (AR)
-- - Rent income (tenants)
-- - Rent expense (landlords)
-- - Interest income
-- - Utility expenses
-- - General journal entries
-- =============================================
-- Run this AFTER 07_UPDATE_RECONCILIATION_VIEWS_ALL.sql
-- =============================================

PRINT '=========================================='
PRINT 'CREATING ALL POSTING PROCEDURES'
PRINT '=========================================='
PRINT ''

-- =============================================
-- 1. sp_GetCustomerLedgerAccount
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_GetCustomerLedgerAccount') AND type in (N'P'))
    DROP PROCEDURE sp_GetCustomerLedgerAccount;
GO

CREATE PROCEDURE sp_GetCustomerLedgerAccount
    @CustomerID INT,
    @LedgerAccountCode NVARCHAR(20) OUTPUT,
    @AccountID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        @LedgerAccountCode = AccountCode,
        @AccountID = AccountID
    FROM ChartOfAccounts
    WHERE CustomerID = @CustomerID
      AND IsSubsidiaryLedger = 1
      AND IsActive = 1;
    
    IF @LedgerAccountCode IS NULL
    BEGIN
        RAISERROR('No ledger account found for CustomerID %d', 16, 1, @CustomerID);
        RETURN -1;
    END
    
    RETURN 0;
END
GO

PRINT '✓ Created sp_GetCustomerLedgerAccount';

-- =============================================
-- 2. sp_PostCustomerInvoice
-- Posts customer invoice (Accounts Receivable)
-- DR Customer Ledger, CR Revenue Account
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_PostCustomerInvoice') AND type in (N'P'))
    DROP PROCEDURE sp_PostCustomerInvoice;
GO

CREATE PROCEDURE sp_PostCustomerInvoice
    @CustomerID INT,
    @InvoiceNumber NVARCHAR(50),
    @InvoiceDate DATE,
    @Amount DECIMAL(18,2),
    @RevenueAccountID INT,
    @Description NVARCHAR(500),
    @BranchID INT,
    @CreatedBy INT,
    @JournalID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @CustomerLedgerAccountID INT;
        DECLARE @CustomerLedgerCode NVARCHAR(20);
        
        EXEC sp_GetCustomerLedgerAccount 
            @CustomerID, 
            @CustomerLedgerCode OUTPUT, 
            @CustomerLedgerAccountID OUTPUT;
        
        DECLARE @FiscalPeriodID INT = 1;
        DECLARE @JournalNumber NVARCHAR(50) = 'CI-' + FORMAT(GETDATE(), 'yyyyMMddHHmmss');
        
        INSERT INTO JournalHeaders (
            JournalNumber, JournalDate, Reference, Description, FiscalPeriodID,
            CreatedBy, BranchID, IsPosted, PostedDate, PostedBy
        )
        VALUES (
            @JournalNumber, @InvoiceDate, @InvoiceNumber, @Description, @FiscalPeriodID,
            @CreatedBy, @BranchID, 1, GETDATE(), @CreatedBy
        );
        
        SET @JournalID = SCOPE_IDENTITY();
        
        -- DR Customer Ledger (increases receivable)
        INSERT INTO JournalLines (
            JournalID, LineNumber, AccountID, Debit, Credit,
            LineDescription, Reference1, Reference2, ClearedFlag
        )
        VALUES (
            @JournalID, 1, @CustomerLedgerAccountID, @Amount, 0,
            @Description, @InvoiceNumber, 'Customer Invoice', 0
        );
        
        -- CR Revenue Account
        INSERT INTO JournalLines (
            JournalID, LineNumber, AccountID, Debit, Credit,
            LineDescription, Reference1, Reference2, ClearedFlag
        )
        VALUES (
            @JournalID, 2, @RevenueAccountID, 0, @Amount,
            @Description, @InvoiceNumber, 'Customer Invoice', 0
        );
        
        COMMIT TRANSACTION;
        RETURN 0;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN -1;
    END CATCH
END
GO

PRINT '✓ Created sp_PostCustomerInvoice';

-- =============================================
-- 3. sp_PostCustomerPayment
-- Posts customer payment (Accounts Receivable)
-- DR Bank Account, CR Customer Ledger
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_PostCustomerPayment') AND type in (N'P'))
    DROP PROCEDURE sp_PostCustomerPayment;
GO

CREATE PROCEDURE sp_PostCustomerPayment
    @CustomerID INT,
    @PaymentReference NVARCHAR(50),
    @PaymentDate DATE,
    @Amount DECIMAL(18,2),
    @BankAccountID INT,
    @Description NVARCHAR(500),
    @BranchID INT,
    @CreatedBy INT,
    @InvoiceNumber NVARCHAR(50) = NULL,
    @JournalID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @CustomerLedgerAccountID INT;
        DECLARE @CustomerLedgerCode NVARCHAR(20);
        
        EXEC sp_GetCustomerLedgerAccount 
            @CustomerID, 
            @CustomerLedgerCode OUTPUT, 
            @CustomerLedgerAccountID OUTPUT;
        
        DECLARE @FiscalPeriodID INT = 1;
        DECLARE @JournalNumber NVARCHAR(50) = 'CP-' + FORMAT(GETDATE(), 'yyyyMMddHHmmss');
        
        INSERT INTO JournalHeaders (
            JournalNumber, JournalDate, Reference, Description, FiscalPeriodID,
            CreatedBy, BranchID, IsPosted, PostedDate, PostedBy
        )
        VALUES (
            @JournalNumber, @PaymentDate, @PaymentReference, @Description, @FiscalPeriodID,
            @CreatedBy, @BranchID, 1, GETDATE(), @CreatedBy
        );
        
        SET @JournalID = SCOPE_IDENTITY();
        
        -- DR Bank Account (increases cash)
        INSERT INTO JournalLines (
            JournalID, LineNumber, AccountID, Debit, Credit,
            LineDescription, Reference1, Reference2, ClearedFlag
        )
        VALUES (
            @JournalID, 1, @BankAccountID, @Amount, 0,
            @Description, @PaymentReference, @InvoiceNumber, 0
        );
        
        -- CR Customer Ledger (reduces receivable)
        INSERT INTO JournalLines (
            JournalID, LineNumber, AccountID, Debit, Credit,
            LineDescription, Reference1, Reference2, ClearedFlag
        )
        VALUES (
            @JournalID, 2, @CustomerLedgerAccountID, 0, @Amount,
            @Description, @PaymentReference, @InvoiceNumber, 0
        );
        
        COMMIT TRANSACTION;
        RETURN 0;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN -1;
    END CATCH
END
GO

PRINT '✓ Created sp_PostCustomerPayment';

-- =============================================
-- 4. sp_PostRentIncome
-- Posts rent income from tenant
-- DR Bank/Cash Account, CR Rent Income Ledger (specific tenant)
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_PostRentIncome') AND type in (N'P'))
    DROP PROCEDURE sp_PostRentIncome;
GO

CREATE PROCEDURE sp_PostRentIncome
    @TenantLedgerAccountID INT,
    @PaymentReference NVARCHAR(50),
    @PaymentDate DATE,
    @Amount DECIMAL(18,2),
    @BankAccountID INT,
    @Description NVARCHAR(500),
    @BranchID INT,
    @CreatedBy INT,
    @JournalID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @FiscalPeriodID INT = 1;
        DECLARE @JournalNumber NVARCHAR(50) = 'RI-' + FORMAT(GETDATE(), 'yyyyMMddHHmmss');
        
        INSERT INTO JournalHeaders (
            JournalNumber, JournalDate, Reference, Description, FiscalPeriodID,
            CreatedBy, BranchID, IsPosted, PostedDate, PostedBy
        )
        VALUES (
            @JournalNumber, @PaymentDate, @PaymentReference, @Description, @FiscalPeriodID,
            @CreatedBy, @BranchID, 1, GETDATE(), @CreatedBy
        );
        
        SET @JournalID = SCOPE_IDENTITY();
        
        -- DR Bank Account (increases cash)
        INSERT INTO JournalLines (
            JournalID, LineNumber, AccountID, Debit, Credit,
            LineDescription, Reference1, Reference2, ClearedFlag
        )
        VALUES (
            @JournalID, 1, @BankAccountID, @Amount, 0,
            @Description, @PaymentReference, 'Rent Income', 0
        );
        
        -- CR Rent Income Ledger (specific tenant)
        INSERT INTO JournalLines (
            JournalID, LineNumber, AccountID, Debit, Credit,
            LineDescription, Reference1, Reference2, ClearedFlag
        )
        VALUES (
            @JournalID, 2, @TenantLedgerAccountID, 0, @Amount,
            @Description, @PaymentReference, 'Rent Income', 0
        );
        
        COMMIT TRANSACTION;
        RETURN 0;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN -1;
    END CATCH
END
GO

PRINT '✓ Created sp_PostRentIncome';

-- =============================================
-- 5. sp_PostRentExpense
-- Posts rent expense to landlord
-- DR Rent Expense Ledger (specific landlord), CR Bank Account
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_PostRentExpense') AND type in (N'P'))
    DROP PROCEDURE sp_PostRentExpense;
GO

CREATE PROCEDURE sp_PostRentExpense
    @LandlordLedgerAccountID INT,
    @PaymentReference NVARCHAR(50),
    @PaymentDate DATE,
    @Amount DECIMAL(18,2),
    @BankAccountID INT,
    @Description NVARCHAR(500),
    @BranchID INT,
    @CreatedBy INT,
    @JournalID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @FiscalPeriodID INT = 1;
        DECLARE @JournalNumber NVARCHAR(50) = 'RE-' + FORMAT(GETDATE(), 'yyyyMMddHHmmss');
        
        INSERT INTO JournalHeaders (
            JournalNumber, JournalDate, Reference, Description, FiscalPeriodID,
            CreatedBy, BranchID, IsPosted, PostedDate, PostedBy
        )
        VALUES (
            @JournalNumber, @PaymentDate, @PaymentReference, @Description, @FiscalPeriodID,
            @CreatedBy, @BranchID, 1, GETDATE(), @CreatedBy
        );
        
        SET @JournalID = SCOPE_IDENTITY();
        
        -- DR Rent Expense Ledger (specific landlord)
        INSERT INTO JournalLines (
            JournalID, LineNumber, AccountID, Debit, Credit,
            LineDescription, Reference1, Reference2, ClearedFlag
        )
        VALUES (
            @JournalID, 1, @LandlordLedgerAccountID, @Amount, 0,
            @Description, @PaymentReference, 'Rent Expense', 0
        );
        
        -- CR Bank Account (reduces cash)
        INSERT INTO JournalLines (
            JournalID, LineNumber, AccountID, Debit, Credit,
            LineDescription, Reference1, Reference2, ClearedFlag
        )
        VALUES (
            @JournalID, 2, @BankAccountID, 0, @Amount,
            @Description, @PaymentReference, 'Rent Expense', 0
        );
        
        COMMIT TRANSACTION;
        RETURN 0;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN -1;
    END CATCH
END
GO

PRINT '✓ Created sp_PostRentExpense';

-- =============================================
-- 6. sp_PostGeneralJournalEntry
-- Posts a general journal entry with multiple lines
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_PostGeneralJournalEntry') AND type in (N'P'))
    DROP PROCEDURE sp_PostGeneralJournalEntry;
GO

CREATE PROCEDURE sp_PostGeneralJournalEntry
    @JournalDate DATE,
    @Reference NVARCHAR(50),
    @Description NVARCHAR(500),
    @BranchID INT,
    @CreatedBy INT,
    @JournalID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @FiscalPeriodID INT = 1;
        DECLARE @JournalNumber NVARCHAR(50) = 'GJ-' + FORMAT(GETDATE(), 'yyyyMMddHHmmss');
        
        INSERT INTO JournalHeaders (
            JournalNumber, JournalDate, Reference, Description, FiscalPeriodID,
            CreatedBy, BranchID, IsPosted, PostedDate, PostedBy
        )
        VALUES (
            @JournalNumber, @JournalDate, @Reference, @Description, @FiscalPeriodID,
            @CreatedBy, @BranchID, 1, GETDATE(), @CreatedBy
        );
        
        SET @JournalID = SCOPE_IDENTITY();
        
        COMMIT TRANSACTION;
        RETURN 0;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN -1;
    END CATCH
END
GO

PRINT '✓ Created sp_PostGeneralJournalEntry';

-- =============================================
-- 7. sp_AddJournalLine
-- Adds a line to an existing journal entry
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_AddJournalLine') AND type in (N'P'))
    DROP PROCEDURE sp_AddJournalLine;
GO

CREATE PROCEDURE sp_AddJournalLine
    @JournalID INT,
    @AccountID INT,
    @Debit DECIMAL(18,2),
    @Credit DECIMAL(18,2),
    @LineDescription NVARCHAR(500),
    @Reference1 NVARCHAR(100) = NULL,
    @Reference2 NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @LineNumber INT;
    
    SELECT @LineNumber = ISNULL(MAX(LineNumber), 0) + 1
    FROM JournalLines
    WHERE JournalID = @JournalID;
    
    INSERT INTO JournalLines (
        JournalID, LineNumber, AccountID, Debit, Credit,
        LineDescription, Reference1, Reference2, ClearedFlag
    )
    VALUES (
        @JournalID, @LineNumber, @AccountID, @Debit, @Credit,
        @LineDescription, @Reference1, @Reference2, 0
    );
    
    RETURN 0;
END
GO

PRINT '✓ Created sp_AddJournalLine';

-- =============================================
-- 8. sp_CreateCustomerLedgerAccount
-- Creates ledger account for new customer
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_CreateCustomerLedgerAccount') AND type in (N'P'))
    DROP PROCEDURE sp_CreateCustomerLedgerAccount;
GO

CREATE PROCEDURE sp_CreateCustomerLedgerAccount
    @CustomerID INT,
    @CustomerName NVARCHAR(200),
    @AccountCode NVARCHAR(20) OUTPUT,
    @AccountID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM ChartOfAccounts WHERE CustomerID = @CustomerID)
        BEGIN
            SELECT 
                @AccountCode = AccountCode,
                @AccountID = AccountID
            FROM ChartOfAccounts
            WHERE CustomerID = @CustomerID;
            
            COMMIT TRANSACTION;
            RETURN 0;
        END
        
        DECLARE @ControlAccountID INT;
        DECLARE @ControlAccountCode NVARCHAR(20);
        
        SELECT TOP 1 
            @ControlAccountID = AccountID,
            @ControlAccountCode = AccountCode
        FROM ChartOfAccounts
        WHERE IsControlAccount = 1 
          AND (AccountCode LIKE '1%' AND (AccountName LIKE '%Receivable%' OR AccountName LIKE '%Debtor%'))
        ORDER BY AccountCode;
        
        IF @ControlAccountID IS NULL
        BEGIN
            RAISERROR('No Accounts Receivable control account found', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN -1;
        END
        
        DECLARE @NextNumber INT;
        
        SELECT @NextNumber = ISNULL(MAX(CAST(RIGHT(AccountCode, 3) AS INT)), 0) + 1
        FROM ChartOfAccounts
        WHERE AccountCode LIKE @ControlAccountCode + '-%'
          AND IsSubsidiaryLedger = 1;
        
        SET @AccountCode = @ControlAccountCode + '-' + RIGHT('000' + CAST(@NextNumber AS NVARCHAR(3)), 3);
        
        INSERT INTO ChartOfAccounts (
            AccountCode, AccountName, AccountType, ParentAccountCode, IsActive,
            IsControlAccount, IsSubsidiaryLedger, CustomerID,
            NormalBalance, Description, CreatedDate, CreatedBy
        )
        VALUES (
            @AccountCode, @CustomerName, 'Asset', @ControlAccountCode, 1,
            0, 1, @CustomerID,
            'DR', 'Customer ledger account for ' + @CustomerName, GETDATE(), 1
        );
        
        SET @AccountID = SCOPE_IDENTITY();
        
        COMMIT TRANSACTION;
        RETURN 0;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
        RETURN -1;
    END CATCH
END
GO

PRINT '✓ Created sp_CreateCustomerLedgerAccount';

PRINT ''
PRINT '=========================================='
PRINT 'ALL POSTING PROCEDURES CREATED!'
PRINT '=========================================='
PRINT ''
PRINT 'Available Procedures:'
PRINT ''
PRINT 'SUPPLIERS (Accounts Payable):'
PRINT '- sp_GetSupplierLedgerAccount'
PRINT '- sp_PostSupplierInvoice'
PRINT '- sp_PostSupplierPayment'
PRINT '- sp_CreateSupplierLedgerAccount'
PRINT ''
PRINT 'CUSTOMERS (Accounts Receivable):'
PRINT '- sp_GetCustomerLedgerAccount'
PRINT '- sp_PostCustomerInvoice'
PRINT '- sp_PostCustomerPayment'
PRINT '- sp_CreateCustomerLedgerAccount'
PRINT ''
PRINT 'RENT (Income & Expense):'
PRINT '- sp_PostRentIncome (from tenants)'
PRINT '- sp_PostRentExpense (to landlords)'
PRINT ''
PRINT 'GENERAL:'
PRINT '- sp_PostGeneralJournalEntry'
PRINT '- sp_AddJournalLine'
PRINT '- sp_ReconcileSubsidiaryLedgers'
PRINT ''
PRINT 'Next Steps:'
PRINT '1. Test posting procedures with sample data'
PRINT '2. Update application code to use new procedures'
PRINT '3. Train users on new functionality'
PRINT ''
