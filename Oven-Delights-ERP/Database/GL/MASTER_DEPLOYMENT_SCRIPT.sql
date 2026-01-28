-- =============================================
-- MASTER GL INTEGRATION DEPLOYMENT SCRIPT
-- Runs all phases in sequence
-- =============================================

SET NOCOUNT ON
GO

PRINT ''
PRINT '========================================='
PRINT '   MASTER GL INTEGRATION DEPLOYMENT'
PRINT '========================================='
PRINT ''
PRINT 'This script will deploy complete GL integration'
PRINT 'across all ERP modules with proper double-entry accounting.'
PRINT ''
PRINT 'Phases:'
PRINT '1. Create missing GL accounts'
PRINT '2. Fix AP procedures (Account 2030)'
PRINT '3. Create EFT clearing procedures'
PRINT '4. Create inventory GL procedures'
PRINT '5. Create reporting procedures'
PRINT ''
PRINT 'Starting deployment...'
PRINT ''
PRINT '========================================='
PRINT ''

-- =============================================
-- PHASE 1: CREATE MISSING GL ACCOUNTS
-- =============================================

PRINT 'PHASE 1: Creating Missing GL Accounts'
PRINT '======================================'
PRINT ''

-- 1050 - Debtors (Uncleared EFT)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1050')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('1050', 'Debtors - Uncleared EFT', 'Asset', 1)
    PRINT '✓ Created 1050 - Debtors (Uncleared EFT)'
END
ELSE
    PRINT '✓ 1050 - Debtors (Uncleared EFT) already exists'

-- 2030 - Accounts Payable (Trade Creditors)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2030')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('2030', 'Accounts Payable - Trade Creditors', 'Liability', 1)
    PRINT '✓ Created 2030 - Accounts Payable (Trade Creditors)'
END
ELSE
    PRINT '✓ 2030 - Accounts Payable already exists'

-- 5020 - Direct Labor
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5020')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('5020', 'Direct Labor', 'Expense', 1)
    PRINT '✓ Created 5020 - Direct Labor'
END
ELSE
    PRINT '✓ 5020 - Direct Labor already exists'

-- 6010 - Rent Expense
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6010')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('6010', 'Rent Expense', 'Expense', 1)
    PRINT '✓ Created 6010 - Rent Expense'
END
ELSE
    PRINT '✓ 6010 - Rent Expense already exists'

-- 6020 - Utilities Expense
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6020')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('6020', 'Utilities Expense', 'Expense', 1)
    PRINT '✓ Created 6020 - Utilities Expense'
END
ELSE
    PRINT '✓ 6020 - Utilities Expense already exists'

-- 6030 - Telephone & Internet
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6030')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('6030', 'Telephone & Internet', 'Expense', 1)
    PRINT '✓ Created 6030 - Telephone & Internet'
END
ELSE
    PRINT '✓ 6030 - Telephone & Internet already exists'

-- 6040 - Office Supplies
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6040')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('6040', 'Office Supplies', 'Expense', 1)
    PRINT '✓ Created 6040 - Office Supplies'
END
ELSE
    PRINT '✓ 6040 - Office Supplies already exists'

-- 6050 - Inventory Variance
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6050')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('6050', 'Inventory Variance', 'Expense', 1)
    PRINT '✓ Created 6050 - Inventory Variance'
END
ELSE
    PRINT '✓ 6050 - Inventory Variance already exists'

-- 6060 - Wastage Expense
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6060')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('6060', 'Wastage Expense', 'Expense', 1)
    PRINT '✓ Created 6060 - Wastage Expense'
END
ELSE
    PRINT '✓ 6060 - Wastage Expense already exists'

-- 6070 - Manufacturing Overhead
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6070')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('6070', 'Manufacturing Overhead', 'Expense', 1)
    PRINT '✓ Created 6070 - Manufacturing Overhead'
END
ELSE
    PRINT '✓ 6070 - Manufacturing Overhead already exists'

PRINT ''
PRINT 'Phase 1 Complete: All GL accounts created'
PRINT ''

-- =============================================
-- PHASE 2: FIX AP PROCEDURES (USE ACCOUNT 2030)
-- =============================================

PRINT 'PHASE 2: Fixing AP Procedures'
PRINT '=============================='
PRINT ''

-- Drop old procedures
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_AP_PostAdhocInvoiceToGL' AND type = 'P')
    DROP PROCEDURE sp_AP_PostAdhocInvoiceToGL
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_AP_PostSinglePaymentToGL' AND type = 'P')
    DROP PROCEDURE sp_AP_PostSinglePaymentToGL
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_AP_PostBatchPaymentToGL' AND type = 'P')
    DROP PROCEDURE sp_AP_PostBatchPaymentToGL
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_AP_PostCreditNoteToGL' AND type = 'P')
    DROP PROCEDURE sp_AP_PostCreditNoteToGL

PRINT '✓ Dropped old AP procedures'
GO

-- Recreate with Account 2030
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
        DECLARE @JournalID INT, @JournalNumber NVARCHAR(50)
        DECLARE @ExpenseAccountID INT, @VATInputAccountID INT, @APAccountID INT
        
        SELECT @ExpenseAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = @ExpenseAccountCode AND IsActive = 1
        SELECT @VATInputAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2021' AND IsActive = 1
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2030' AND IsActive = 1
        
        IF @ExpenseAccountID IS NULL RAISERROR('Expense account not found', 16, 1)
        IF @VATInputAccountID IS NULL RAISERROR('VAT Input account not found', 16, 1)
        IF @APAccountID IS NULL RAISERROR('Accounts Payable account 2030 not found', 16, 1)
        
        SET @JournalNumber = 'AP-' + @InvoiceNumber
        
        INSERT INTO JournalHeaders (JournalNumber, BranchID, JournalDate, Reference, Description, FiscalPeriodID, IsPosted, CreatedBy)
        VALUES (@JournalNumber, @BranchID, @InvoiceDate, @InvoiceNumber, 'ADHOC Invoice - ' + @SupplierName, dbo.fn_GetCurrentFiscalPeriodID(@InvoiceDate), 1, @CreatedBy)
        SET @JournalID = SCOPE_IDENTITY()
        
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
        VALUES (@JournalID, 1, @ExpenseAccountID, @SubtotalAmount, 0, 'Expense', @InvoiceNumber, @SupplierName)
        
        IF @VATAmount > 0
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
            VALUES (@JournalID, 2, @VATInputAccountID, @VATAmount, 0, 'VAT Input', @InvoiceNumber, @SupplierName)
        
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
        VALUES (@JournalID, 3, @APAccountID, 0, @TotalAmount, 'Accounts Payable', @InvoiceNumber, @SupplierName)
        
        COMMIT TRANSACTION;
        SELECT @JournalID AS JournalID, 'Invoice posted to GL (Account 2030)' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 0 AS JournalID, 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT '✓ Created sp_AP_PostAdhocInvoiceToGL (using 2030)'
GO

CREATE PROCEDURE sp_AP_PostSinglePaymentToGL
    @InvoiceID INT,
    @PaymentNumber NVARCHAR(50),
    @PaymentDate DATE,
    @SupplierName NVARCHAR(200),
    @Amount DECIMAL(18,2),
    @PaymentMethod NVARCHAR(20),
    @BranchID INT,
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @JournalID INT, @JournalNumber NVARCHAR(50)
        DECLARE @APAccountID INT, @BankAccountID INT, @CashAccountID INT
        
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2030' AND IsActive = 1
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @CashAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1030' AND IsActive = 1
        
        IF @APAccountID IS NULL RAISERROR('Accounts Payable account 2030 not found', 16, 1)
        
        SET @JournalNumber = 'PAY-' + @PaymentNumber
        
        INSERT INTO JournalHeaders (JournalNumber, BranchID, JournalDate, Reference, Description, FiscalPeriodID, IsPosted, CreatedBy)
        VALUES (@JournalNumber, @BranchID, @PaymentDate, @PaymentNumber, 'Payment - ' + @SupplierName, dbo.fn_GetCurrentFiscalPeriodID(@PaymentDate), 1, @CreatedBy)
        SET @JournalID = SCOPE_IDENTITY()
        
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
        VALUES (@JournalID, 1, @APAccountID, @Amount, 0, 'Payment to Supplier', @PaymentNumber, @SupplierName)
        
        IF @PaymentMethod IN ('EFT', 'Cheque')
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
            VALUES (@JournalID, 2, @BankAccountID, 0, @Amount, 'Bank Payment - ' + @PaymentMethod, @PaymentNumber, @SupplierName)
        ELSE IF @PaymentMethod = 'Cash'
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
            VALUES (@JournalID, 2, @CashAccountID, 0, @Amount, 'Cash Payment', @PaymentNumber, @SupplierName)
        
        COMMIT TRANSACTION;
        SELECT @JournalID AS JournalID, 'Payment posted to GL (Account 2030)' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 0 AS JournalID, 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT '✓ Created sp_AP_PostSinglePaymentToGL (using 2030)'
GO

CREATE PROCEDURE sp_AP_PostBatchPaymentToGL
    @BatchID INT,
    @PaymentDate DATE,
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @APAccountID INT, @BankAccountID INT
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2030' AND IsActive = 1
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        
        IF @APAccountID IS NULL RAISERROR('Accounts Payable account 2030 not found', 16, 1)
        IF @BankAccountID IS NULL RAISERROR('Bank account not found', 16, 1)
        
        DECLARE @InvoiceID INT, @InvoiceNumber NVARCHAR(50), @SupplierName NVARCHAR(200)
        DECLARE @Amount DECIMAL(18,2), @BranchID INT, @JournalID INT, @JournalNumber NVARCHAR(50)
        
        DECLARE invoice_cursor CURSOR FOR
        SELECT i.InvoiceID, i.InvoiceNumber, b.BeneficiaryName, pbi.Amount, i.BranchID
        FROM AP_PaymentBatchItems pbi
        INNER JOIN AP_Invoices i ON pbi.InvoiceID = i.InvoiceID
        INNER JOIN AP_Beneficiaries b ON i.BeneficiaryID = b.BeneficiaryID
        WHERE pbi.BatchID = @BatchID
        
        OPEN invoice_cursor
        FETCH NEXT FROM invoice_cursor INTO @InvoiceID, @InvoiceNumber, @SupplierName, @Amount, @BranchID
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @JournalNumber = 'BP-' + @InvoiceNumber
            
            INSERT INTO JournalHeaders (JournalNumber, BranchID, JournalDate, Reference, Description, FiscalPeriodID, IsPosted, CreatedBy)
            VALUES (@JournalNumber, @BranchID, @PaymentDate, @InvoiceNumber, 'Batch Payment - ' + @SupplierName, dbo.fn_GetCurrentFiscalPeriodID(@PaymentDate), 1, @CreatedBy)
            SET @JournalID = SCOPE_IDENTITY()
            
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
            VALUES (@JournalID, 1, @APAccountID, @Amount, 0, 'Batch Payment', @InvoiceNumber, @SupplierName)
            
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
            VALUES (@JournalID, 2, @BankAccountID, 0, @Amount, 'Bank Payment - EFT', @InvoiceNumber, @SupplierName)
            
            UPDATE AP_Invoices SET Status = 'Paid', PaymentDate = @PaymentDate, ModifiedDate = GETDATE() WHERE InvoiceID = @InvoiceID
            
            FETCH NEXT FROM invoice_cursor INTO @InvoiceID, @InvoiceNumber, @SupplierName, @Amount, @BranchID
        END
        
        CLOSE invoice_cursor
        DEALLOCATE invoice_cursor
        
        COMMIT TRANSACTION;
        SELECT 'Batch payment posted to GL (Account 2030)' AS Message
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('global', 'invoice_cursor') >= 0
        BEGIN
            CLOSE invoice_cursor
            DEALLOCATE invoice_cursor
        END
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT '✓ Created sp_AP_PostBatchPaymentToGL (using 2030)'
GO

CREATE PROCEDURE sp_AP_PostCreditNoteToGL
    @CreditNoteID INT,
    @CreditNoteNumber NVARCHAR(50),
    @CreditNoteDate DATE,
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
        DECLARE @JournalID INT, @JournalNumber NVARCHAR(50)
        DECLARE @ExpenseAccountID INT, @VATInputAccountID INT, @APAccountID INT
        
        SELECT @ExpenseAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = @ExpenseAccountCode AND IsActive = 1
        SELECT @VATInputAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2021' AND IsActive = 1
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2030' AND IsActive = 1
        
        IF @ExpenseAccountID IS NULL RAISERROR('Expense account not found', 16, 1)
        IF @VATInputAccountID IS NULL RAISERROR('VAT Input account not found', 16, 1)
        IF @APAccountID IS NULL RAISERROR('Accounts Payable account 2030 not found', 16, 1)
        
        SET @JournalNumber = 'CN-' + @CreditNoteNumber
        
        INSERT INTO JournalHeaders (JournalNumber, BranchID, JournalDate, Reference, Description, FiscalPeriodID, IsPosted, CreatedBy)
        VALUES (@JournalNumber, @BranchID, @CreditNoteDate, @CreditNoteNumber, 'Credit Note - ' + @SupplierName, dbo.fn_GetCurrentFiscalPeriodID(@CreditNoteDate), 1, @CreatedBy)
        SET @JournalID = SCOPE_IDENTITY()
        
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
        VALUES (@JournalID, 1, @APAccountID, @TotalAmount, 0, 'Credit Note - Reduce AP', @CreditNoteNumber, @SupplierName)
        
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
        VALUES (@JournalID, 2, @ExpenseAccountID, 0, @SubtotalAmount, 'Expense Reversal', @CreditNoteNumber, @SupplierName)
        
        IF @VATAmount > 0
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description, Reference1, Reference2)
            VALUES (@JournalID, 3, @VATInputAccountID, 0, @VATAmount, 'VAT Input Reversal', @CreditNoteNumber, @SupplierName)
        
        COMMIT TRANSACTION;
        SELECT @JournalID AS JournalID, 'Credit note posted to GL (Account 2030)' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 0 AS JournalID, 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT '✓ Created sp_AP_PostCreditNoteToGL (using 2030)'
PRINT ''
PRINT 'Phase 2 Complete: AP procedures fixed'
PRINT ''

-- Continue in next message due to length...
PRINT ''
PRINT '========================================='
PRINT 'DEPLOYMENT SCRIPT COMPLETE - PART 1'
PRINT '========================================='
PRINT ''
PRINT 'Run MASTER_DEPLOYMENT_SCRIPT_PART2.sql to continue...'
PRINT ''
