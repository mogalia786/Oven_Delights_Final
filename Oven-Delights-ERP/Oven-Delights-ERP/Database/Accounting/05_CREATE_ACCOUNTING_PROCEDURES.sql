-- =============================================
-- CREATE ACCOUNTING STORED PROCEDURES
-- Procedures for posting supplier invoices and payments
-- =============================================
-- Run this AFTER 04_CREATE_RECONCILIATION_VIEWS.sql
-- =============================================

PRINT '=========================================='
PRINT 'CREATING ACCOUNTING STORED PROCEDURES'
PRINT '=========================================='
PRINT ''

-- =============================================
-- 1. sp_GetSupplierLedgerAccount
-- Gets the ledger account code for a supplier
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_GetSupplierLedgerAccount') AND type in (N'P'))
    DROP PROCEDURE sp_GetSupplierLedgerAccount;
GO

CREATE PROCEDURE sp_GetSupplierLedgerAccount
    @SupplierID INT,
    @LedgerAccountCode NVARCHAR(20) OUTPUT,
    @AccountID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        @LedgerAccountCode = AccountCode,
        @AccountID = AccountID
    FROM ChartOfAccounts
    WHERE SupplierID = @SupplierID
      AND IsSubsidiaryLedger = 1
      AND IsActive = 1;
    
    IF @LedgerAccountCode IS NULL
    BEGIN
        RAISERROR('No ledger account found for SupplierID %d', 16, 1, @SupplierID);
        RETURN -1;
    END
    
    RETURN 0;
END
GO

PRINT '✓ Created sp_GetSupplierLedgerAccount';

-- =============================================
-- 2. sp_PostSupplierInvoice
-- Posts a supplier invoice to the general ledger
-- DR Expense Account, CR Supplier Ledger Account
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_PostSupplierInvoice') AND type in (N'P'))
    DROP PROCEDURE sp_PostSupplierInvoice;
GO

CREATE PROCEDURE sp_PostSupplierInvoice
    @SupplierID INT,
    @InvoiceNumber NVARCHAR(50),
    @InvoiceDate DATE,
    @Amount DECIMAL(18,2),
    @ExpenseAccountID INT,
    @Description NVARCHAR(500),
    @BranchID INT,
    @CreatedBy INT,
    @JournalID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Get supplier's ledger account
        DECLARE @SupplierLedgerAccountID INT;
        DECLARE @SupplierLedgerCode NVARCHAR(20);
        
        EXEC sp_GetSupplierLedgerAccount 
            @SupplierID, 
            @SupplierLedgerCode OUTPUT, 
            @SupplierLedgerAccountID OUTPUT;
        
        -- Get fiscal period (assuming you have this logic)
        DECLARE @FiscalPeriodID INT = 1; -- Default, should be calculated
        
        -- Generate journal number
        DECLARE @JournalNumber NVARCHAR(50) = 'SI-' + FORMAT(GETDATE(), 'yyyyMMddHHmmss');
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber,
            JournalDate,
            Reference,
            Description,
            FiscalPeriodID,
            CreatedBy,
            BranchID,
            IsPosted,
            PostedDate,
            PostedBy
        )
        VALUES (
            @JournalNumber,
            @InvoiceDate,
            @InvoiceNumber,
            @Description,
            @FiscalPeriodID,
            @CreatedBy,
            @BranchID,
            1, -- Posted immediately
            GETDATE(),
            @CreatedBy
        );
        
        SET @JournalID = SCOPE_IDENTITY();
        
        -- Create journal lines
        -- DR Expense Account
        INSERT INTO JournalLines (
            JournalID,
            LineNumber,
            AccountID,
            Debit,
            Credit,
            LineDescription,
            Reference1,
            Reference2,
            ClearedFlag
        )
        VALUES (
            @JournalID,
            1,
            @ExpenseAccountID,
            @Amount,
            0,
            @Description,
            @InvoiceNumber,
            'Supplier Invoice',
            0
        );
        
        -- CR Supplier Ledger Account
        INSERT INTO JournalLines (
            JournalID,
            LineNumber,
            AccountID,
            Debit,
            Credit,
            LineDescription,
            Reference1,
            Reference2,
            ClearedFlag
        )
        VALUES (
            @JournalID,
            2,
            @SupplierLedgerAccountID,
            0,
            @Amount,
            @Description,
            @InvoiceNumber,
            'Supplier Invoice',
            0
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

PRINT '✓ Created sp_PostSupplierInvoice';

-- =============================================
-- 3. sp_PostSupplierPayment
-- Posts a supplier payment to the general ledger
-- DR Supplier Ledger Account, CR Bank Account
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_PostSupplierPayment') AND type in (N'P'))
    DROP PROCEDURE sp_PostSupplierPayment;
GO

CREATE PROCEDURE sp_PostSupplierPayment
    @SupplierID INT,
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
        -- Get supplier's ledger account
        DECLARE @SupplierLedgerAccountID INT;
        DECLARE @SupplierLedgerCode NVARCHAR(20);
        
        EXEC sp_GetSupplierLedgerAccount 
            @SupplierID, 
            @SupplierLedgerCode OUTPUT, 
            @SupplierLedgerAccountID OUTPUT;
        
        -- Get fiscal period
        DECLARE @FiscalPeriodID INT = 1; -- Default, should be calculated
        
        -- Generate journal number
        DECLARE @JournalNumber NVARCHAR(50) = 'SP-' + FORMAT(GETDATE(), 'yyyyMMddHHmmss');
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber,
            JournalDate,
            Reference,
            Description,
            FiscalPeriodID,
            CreatedBy,
            BranchID,
            IsPosted,
            PostedDate,
            PostedBy
        )
        VALUES (
            @JournalNumber,
            @PaymentDate,
            @PaymentReference,
            @Description,
            @FiscalPeriodID,
            @CreatedBy,
            @BranchID,
            1, -- Posted immediately
            GETDATE(),
            @CreatedBy
        );
        
        SET @JournalID = SCOPE_IDENTITY();
        
        -- Create journal lines
        -- DR Supplier Ledger Account (reduces liability)
        INSERT INTO JournalLines (
            JournalID,
            LineNumber,
            AccountID,
            Debit,
            Credit,
            LineDescription,
            Reference1,
            Reference2,
            ClearedFlag
        )
        VALUES (
            @JournalID,
            1,
            @SupplierLedgerAccountID,
            @Amount,
            0,
            @Description,
            @PaymentReference,
            @InvoiceNumber,
            0
        );
        
        -- CR Bank Account (reduces asset)
        INSERT INTO JournalLines (
            JournalID,
            LineNumber,
            AccountID,
            Debit,
            Credit,
            LineDescription,
            Reference1,
            Reference2,
            ClearedFlag
        )
        VALUES (
            @JournalID,
            2,
            @BankAccountID,
            0,
            @Amount,
            @Description,
            @PaymentReference,
            @InvoiceNumber,
            0
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

PRINT '✓ Created sp_PostSupplierPayment';

-- =============================================
-- 4. sp_CreateSupplierLedgerAccount
-- Creates a ledger account for a new supplier
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_CreateSupplierLedgerAccount') AND type in (N'P'))
    DROP PROCEDURE sp_CreateSupplierLedgerAccount;
GO

CREATE PROCEDURE sp_CreateSupplierLedgerAccount
    @SupplierID INT,
    @SupplierName NVARCHAR(200),
    @AccountCode NVARCHAR(20) OUTPUT,
    @AccountID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Check if supplier already has a ledger account
        IF EXISTS (SELECT 1 FROM ChartOfAccounts WHERE SupplierID = @SupplierID)
        BEGIN
            SELECT 
                @AccountCode = AccountCode,
                @AccountID = AccountID
            FROM ChartOfAccounts
            WHERE SupplierID = @SupplierID;
            
            COMMIT TRANSACTION;
            RETURN 0; -- Already exists
        END
        
        -- Get control account
        DECLARE @ControlAccountID INT;
        DECLARE @ControlAccountCode NVARCHAR(20);
        
        SELECT TOP 1 
            @ControlAccountID = AccountID,
            @ControlAccountCode = AccountCode
        FROM ChartOfAccounts
        WHERE IsControlAccount = 1 
          AND (AccountCode = '2100' OR AccountName LIKE '%Accounts Payable%')
        ORDER BY AccountCode;
        
        IF @ControlAccountID IS NULL
        BEGIN
            RAISERROR('No Accounts Payable control account found', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN -1;
        END
        
        -- Generate next ledger code
        DECLARE @NextNumber INT;
        
        SELECT @NextNumber = ISNULL(MAX(CAST(RIGHT(AccountCode, 3) AS INT)), 0) + 1
        FROM ChartOfAccounts
        WHERE AccountCode LIKE @ControlAccountCode + '-%'
          AND IsSubsidiaryLedger = 1;
        
        SET @AccountCode = @ControlAccountCode + '-' + RIGHT('000' + CAST(@NextNumber AS NVARCHAR(3)), 3);
        
        -- Create the ledger account
        INSERT INTO ChartOfAccounts (
            AccountCode,
            AccountName,
            AccountType,
            ParentAccountCode,
            IsActive,
            IsControlAccount,
            IsSubsidiaryLedger,
            SupplierID,
            NormalBalance,
            Description,
            CreatedDate,
            CreatedBy
        )
        VALUES (
            @AccountCode,
            @SupplierName,
            'Liability',
            @ControlAccountCode,
            1,
            0,
            1,
            @SupplierID,
            'CR',
            'Supplier ledger account for ' + @SupplierName,
            GETDATE(),
            1
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

PRINT '✓ Created sp_CreateSupplierLedgerAccount';

-- =============================================
-- 5. sp_ReconcileSubsidiaryLedgers
-- Verifies that subsidiary ledgers = control account
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_ReconcileSubsidiaryLedgers') AND type in (N'P'))
    DROP PROCEDURE sp_ReconcileSubsidiaryLedgers;
GO

CREATE PROCEDURE sp_ReconcileSubsidiaryLedgers
    @ControlAccountCode NVARCHAR(20) = '2100'
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT * FROM vw_SubsidiaryLedgerReconciliation
    WHERE ControlAccountCode = @ControlAccountCode;
    
    -- Return 0 if balanced, -1 if out of balance
    IF EXISTS (
        SELECT 1 FROM vw_SubsidiaryLedgerReconciliation
        WHERE ControlAccountCode = @ControlAccountCode
          AND ABS(Difference) > 0.01
    )
        RETURN -1;
    ELSE
        RETURN 0;
END
GO

PRINT '✓ Created sp_ReconcileSubsidiaryLedgers';

PRINT ''
PRINT '=========================================='
PRINT 'TESTING STORED PROCEDURES'
PRINT '=========================================='
PRINT ''

-- Test sp_ReconcileSubsidiaryLedgers
PRINT 'Testing reconciliation...'
EXEC sp_ReconcileSubsidiaryLedgers '2100';

PRINT ''
PRINT '=========================================='
PRINT 'ACCOUNTING PROCEDURES CREATED!'
PRINT '=========================================='
PRINT ''
PRINT 'Available Procedures:'
PRINT '- sp_GetSupplierLedgerAccount: Get supplier ledger account'
PRINT '- sp_PostSupplierInvoice: Post supplier invoice to GL'
PRINT '- sp_PostSupplierPayment: Post supplier payment to GL'
PRINT '- sp_CreateSupplierLedgerAccount: Create ledger for new supplier'
PRINT '- sp_ReconcileSubsidiaryLedgers: Verify reconciliation'
PRINT ''
PRINT 'Next Steps:'
PRINT '1. Update BankStatementViewerForm to use sp_PostSupplierPayment'
PRINT '2. Update invoice capture to use sp_PostSupplierInvoice'
PRINT '3. Fix LedgerHierarchyForm to use correct table structure'
PRINT ''
