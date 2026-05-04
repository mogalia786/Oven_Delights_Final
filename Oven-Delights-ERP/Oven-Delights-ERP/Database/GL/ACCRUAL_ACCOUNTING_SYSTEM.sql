-- =============================================
-- ACCRUAL ACCOUNTING SYSTEM
-- Bank Statement Completes Double-Entry
-- =============================================

/*
ACCOUNTING PRINCIPLE:
--------------------
1. Operational transactions create ACCRUAL entries (single-side of double-entry)
   - Invoice received → DR Expense / CR Accounts Payable
   - GRV received → DR Inventory / CR GRIR
   - Customer invoice → DR Accounts Receivable / CR Sales
   - Bank account is NOT touched

2. Bank statement COMPLETES the double-entry
   - Payment out → DR Accounts Payable / CR Bank
   - Receipt in → DR Bank / CR Accounts Receivable
   - This clears the liability/asset and updates bank

EXAMPLE: Electricity Invoice & Payment
---------------------------------------
Step 1: Invoice received (no payment yet)
   DR Electricity Expense (6020)  R1,000
   CR Accounts Payable (2010)     R1,000
   (Single entry - liability created, bank NOT touched)

Step 2: Make payment (initiate EFT)
   (No GL entry - waiting for bank confirmation)

Step 3: Bank statement shows payment
   DR Accounts Payable (2010)     R1,000
   CR Bank (1010)                 R1,000
   (Completes double-entry - liability cleared, bank reduced)

EXAMPLE: Purchase Order & Payment
----------------------------------
Step 1: GRV received (goods in, no payment yet)
   DR Inventory (1220)            R5,000
   CR GRIR (2050)                 R5,000
   (Goods received, invoice pending)

Step 2: Supplier invoice matched to GRV
   DR GRIR (2050)                 R5,000
   DR VAT Input (2021)            R750
   CR Accounts Payable (2010)     R5,750
   (Invoice recorded, payment pending, bank NOT touched)

Step 3: Bank statement shows payment
   DR Accounts Payable (2010)     R5,750
   CR Bank (1010)                 R5,750
   (Completes double-entry - liability cleared, bank reduced)

EXCEPTION: POS SALES (Immediate Settlement)
--------------------------------------------
POS sales are settled immediately (cash/card), so they post complete double-entry:
   DR Cash/Bank (1030/1010)       R100
   CR Sales (4010)                R100
   (Immediate settlement - no accrual needed)

Bank statement reconciliation MATCHES this entry (doesn't create new one)
*/

PRINT '========================================='
PRINT 'ACCRUAL ACCOUNTING SYSTEM'
PRINT 'Bank Statement Completes Double-Entry'
PRINT '========================================='
PRINT ''

-- =============================================
-- STEP 1: CREATE ACCRUAL POSTING PROCEDURES
-- =============================================

-- =============================================
-- 1A. POST SUPPLIER INVOICE (ACCRUAL)
-- =============================================
PRINT 'Creating accrual posting procedures...'
PRINT ''

IF OBJECT_ID('sp_AP_PostInvoiceAccrual', 'P') IS NOT NULL
    DROP PROCEDURE sp_AP_PostInvoiceAccrual
GO

CREATE PROCEDURE sp_AP_PostInvoiceAccrual
    @InvoiceID INT,
    @InvoiceNumber NVARCHAR(50),
    @InvoiceDate DATE,
    @SupplierName NVARCHAR(200),
    @BranchID INT,
    @ExpenseAccountCode NVARCHAR(20),  -- e.g., '6020' for Electricity, '6010' for Rent
    @SubtotalAmount DECIMAL(18,2),     -- Excl VAT
    @VATAmount DECIMAL(18,2),          -- VAT amount
    @TotalAmount DECIMAL(18,2),        -- Incl VAT
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
        SELECT @VATInputAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2021' AND IsActive = 1
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2010' AND IsActive = 1
        
        IF @ExpenseAccountID IS NULL
            RAISERROR('Expense account %s not found', 16, 1, @ExpenseAccountCode)
        IF @VATInputAccountID IS NULL
            RAISERROR('VAT Input account 2021 not found', 16, 1)
        IF @APAccountID IS NULL
            RAISERROR('Accounts Payable account 2010 not found', 16, 1)
        
        SET @JournalNumber = 'AP-' + @InvoiceNumber
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber, @BranchID, @InvoiceDate, @InvoiceNumber,
            'Invoice - ' + @SupplierName,
            dbo.fn_GetCurrentFiscalPeriodID(@InvoiceDate),
            1, @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- DEBIT: Expense Account (e.g., Electricity)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 1, @ExpenseAccountID, @SubtotalAmount, 0, 'Expense - ' + @SupplierName)
        
        -- DEBIT: VAT Input
        IF @VATAmount > 0
        BEGIN
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, 2, @VATInputAccountID, @VATAmount, 0, 'VAT Input')
        END
        
        -- CREDIT: Accounts Payable (Liability created - payment pending)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 3, @APAccountID, 0, @TotalAmount, 'Amount owed to ' + @SupplierName)
        
        COMMIT TRANSACTION;
        
        PRINT 'Invoice accrual posted: ' + @InvoiceNumber + ' - Liability created, bank NOT touched'
        SELECT @JournalID AS JournalID, 'Invoice accrual posted - awaiting bank confirmation' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT '✓ Created sp_AP_PostInvoiceAccrual'
GO

-- =============================================
-- 1B. POST GRV (ACCRUAL - GRIR METHOD)
-- =============================================

IF OBJECT_ID('sp_PO_PostGRVAccrual', 'P') IS NOT NULL
    DROP PROCEDURE sp_PO_PostGRVAccrual
GO

CREATE PROCEDURE sp_PO_PostGRVAccrual
    @GRVID INT,
    @GRVNumber NVARCHAR(50),
    @GRVDate DATE,
    @SupplierName NVARCHAR(200),
    @BranchID INT,
    @TotalCost DECIMAL(18,2),  -- Cost of goods received
    @CreatedBy INT
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
        
        IF @InventoryAccountID IS NULL
            RAISERROR('Inventory account 1220 not found', 16, 1)
        IF @GRIRAccountID IS NULL
            RAISERROR('GRIR account 2050 not found', 16, 1)
        
        SET @JournalNumber = 'GRV-' + @GRVNumber
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber, @BranchID, @GRVDate, @GRVNumber,
            'GRV - ' + @SupplierName,
            dbo.fn_GetCurrentFiscalPeriodID(@GRVDate),
            1, @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- DEBIT: Inventory (Goods received)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 1, @InventoryAccountID, @TotalCost, 0, 'Goods received from ' + @SupplierName)
        
        -- CREDIT: GRIR (Goods Received Invoice Pending - liability created)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 2, @GRIRAccountID, 0, @TotalCost, 'Invoice pending - ' + @SupplierName)
        
        COMMIT TRANSACTION;
        
        PRINT 'GRV accrual posted: ' + @GRVNumber + ' - Inventory increased, invoice pending, bank NOT touched'
        SELECT @JournalID AS JournalID, 'GRV posted - awaiting invoice and bank confirmation' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT '✓ Created sp_PO_PostGRVAccrual'
GO

-- =============================================
-- 1C. MATCH INVOICE TO GRV (CLEAR GRIR, CREATE AP)
-- =============================================

IF OBJECT_ID('sp_PO_MatchInvoiceToGRV', 'P') IS NOT NULL
    DROP PROCEDURE sp_PO_MatchInvoiceToGRV
GO

CREATE PROCEDURE sp_PO_MatchInvoiceToGRV
    @InvoiceID INT,
    @InvoiceNumber NVARCHAR(50),
    @InvoiceDate DATE,
    @SupplierName NVARCHAR(200),
    @BranchID INT,
    @SubtotalAmount DECIMAL(18,2),  -- Excl VAT (should match GRV cost)
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
        
        IF @GRIRAccountID IS NULL
            RAISERROR('GRIR account 2050 not found', 16, 1)
        IF @VATInputAccountID IS NULL
            RAISERROR('VAT Input account 2021 not found', 16, 1)
        IF @APAccountID IS NULL
            RAISERROR('Accounts Payable account 2010 not found', 16, 1)
        
        SET @JournalNumber = 'INV-' + @InvoiceNumber
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber, @BranchID, @InvoiceDate, @InvoiceNumber,
            'Invoice Matched - ' + @SupplierName,
            dbo.fn_GetCurrentFiscalPeriodID(@InvoiceDate),
            1, @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- DEBIT: GRIR (Clear pending invoice liability)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 1, @GRIRAccountID, @SubtotalAmount, 0, 'Clear GRIR - Invoice received')
        
        -- DEBIT: VAT Input
        IF @VATAmount > 0
        BEGIN
            INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
            VALUES (@JournalID, 2, @VATInputAccountID, @VATAmount, 0, 'VAT Input')
        END
        
        -- CREDIT: Accounts Payable (Transfer to AP - payment pending)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 3, @APAccountID, 0, @TotalAmount, 'Amount owed to ' + @SupplierName)
        
        COMMIT TRANSACTION;
        
        PRINT 'Invoice matched: ' + @InvoiceNumber + ' - GRIR cleared, AP created, bank NOT touched'
        SELECT @JournalID AS JournalID, 'Invoice matched - awaiting bank confirmation' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT '✓ Created sp_PO_MatchInvoiceToGRV'
GO

-- =============================================
-- STEP 2: BANK STATEMENT COMPLETES DOUBLE-ENTRY
-- =============================================
PRINT ''
PRINT 'Creating bank reconciliation procedures...'
PRINT ''

IF OBJECT_ID('sp_BankStatement_CompletePayment', 'P') IS NOT NULL
    DROP PROCEDURE sp_BankStatement_CompletePayment
GO

CREATE PROCEDURE sp_BankStatement_CompletePayment
    @TransactionID INT,
    @Amount DECIMAL(18,2),
    @TransactionDate DATE,
    @Description NVARCHAR(500),
    @Reference NVARCHAR(200),
    @SupplierName NVARCHAR(200) = NULL,  -- Matched supplier
    @PostedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @BankAccountID INT
        DECLARE @APAccountID INT
        
        -- Get account IDs
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2010' AND IsActive = 1
        
        IF @BankAccountID IS NULL
            RAISERROR('Bank account 1010 not found', 16, 1)
        IF @APAccountID IS NULL
            RAISERROR('Accounts Payable account 2010 not found', 16, 1)
        
        SET @JournalNumber = 'BANK-PAY-' + CAST(@TransactionID AS VARCHAR)
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber, 1, @TransactionDate, @Reference,
            'Bank Payment - ' + ISNULL(@SupplierName, @Description),
            dbo.fn_GetCurrentFiscalPeriodID(@TransactionDate),
            1, @PostedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- DEBIT: Accounts Payable (Clear liability)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 1, @APAccountID, @Amount, 0, 'Payment to ' + ISNULL(@SupplierName, 'Supplier'))
        
        -- CREDIT: Bank (Money out - COMPLETES DOUBLE-ENTRY)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 2, @BankAccountID, 0, @Amount, 'Bank payment confirmed')
        
        -- Mark bank transaction as reconciled
        UPDATE AP_StatementTransactions
        SET IsReconciled = 1,
            ReconciledDate = GETDATE(),
            ReconciledBy = @PostedBy,
            MatchedGLEntryID = @JournalID
        WHERE TransactionID = @TransactionID
        
        COMMIT TRANSACTION;
        
        PRINT 'Payment completed: ' + @Description + ' - AP cleared, Bank reduced (DOUBLE-ENTRY COMPLETE)'
        SELECT @JournalID AS JournalID, 'Payment posted - double-entry completed' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT '✓ Created sp_BankStatement_CompletePayment'
GO

-- =============================================
-- BANK STATEMENT COMPLETES RECEIPT
-- =============================================

IF OBJECT_ID('sp_BankStatement_CompleteReceipt', 'P') IS NOT NULL
    DROP PROCEDURE sp_BankStatement_CompleteReceipt
GO

CREATE PROCEDURE sp_BankStatement_CompleteReceipt
    @TransactionID INT,
    @Amount DECIMAL(18,2),
    @TransactionDate DATE,
    @Description NVARCHAR(500),
    @Reference NVARCHAR(200),
    @CustomerName NVARCHAR(200) = NULL,  -- Matched customer
    @PostedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @BankAccountID INT
        DECLARE @ARAccountID INT
        
        -- Get account IDs
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @ARAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1200' AND IsActive = 1
        
        IF @BankAccountID IS NULL
            RAISERROR('Bank account 1010 not found', 16, 1)
        IF @ARAccountID IS NULL
            RAISERROR('Accounts Receivable account 1200 not found', 16, 1)
        
        SET @JournalNumber = 'BANK-REC-' + CAST(@TransactionID AS VARCHAR)
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber, 1, @TransactionDate, @Reference,
            'Bank Receipt - ' + ISNULL(@CustomerName, @Description),
            dbo.fn_GetCurrentFiscalPeriodID(@TransactionDate),
            1, @PostedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- DEBIT: Bank (Money in - COMPLETES DOUBLE-ENTRY)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 1, @BankAccountID, @Amount, 0, 'Bank receipt confirmed')
        
        -- CREDIT: Accounts Receivable (Clear asset)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 2, @ARAccountID, 0, @Amount, 'Receipt from ' + ISNULL(@CustomerName, 'Customer'))
        
        -- Mark bank transaction as reconciled
        UPDATE AP_StatementTransactions
        SET IsReconciled = 1,
            ReconciledDate = GETDATE(),
            ReconciledBy = @PostedBy,
            MatchedGLEntryID = @JournalID
        WHERE TransactionID = @TransactionID
        
        COMMIT TRANSACTION;
        
        PRINT 'Receipt completed: ' + @Description + ' - Bank increased, AR cleared (DOUBLE-ENTRY COMPLETE)'
        SELECT @JournalID AS JournalID, 'Receipt posted - double-entry completed' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT '✓ Created sp_BankStatement_CompleteReceipt'
GO

PRINT ''
PRINT '========================================='
PRINT 'ACCRUAL ACCOUNTING SYSTEM COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'PROCEDURES CREATED:'
PRINT '-------------------'
PRINT '1. sp_AP_PostInvoiceAccrual - Post invoice (DR Expense / CR AP)'
PRINT '2. sp_PO_PostGRVAccrual - Post GRV (DR Inventory / CR GRIR)'
PRINT '3. sp_PO_MatchInvoiceToGRV - Match invoice (DR GRIR+VAT / CR AP)'
PRINT '4. sp_BankStatement_CompletePayment - Complete payment (DR AP / CR Bank)'
PRINT '5. sp_BankStatement_CompleteReceipt - Complete receipt (DR Bank / CR AR)'
PRINT ''
PRINT 'WORKFLOW EXAMPLE: Electricity Invoice'
PRINT '--------------------------------------'
PRINT 'Step 1: Invoice received'
PRINT '  EXEC sp_AP_PostInvoiceAccrual @ExpenseAccountCode = ''6020'''
PRINT '  Result: DR Electricity (6020) / CR AP (2010) - Bank NOT touched'
PRINT ''
PRINT 'Step 2: Payment initiated (no GL entry)'
PRINT ''
PRINT 'Step 3: Bank statement shows payment'
PRINT '  EXEC sp_BankStatement_CompletePayment @TransactionID = 123'
PRINT '  Result: DR AP (2010) / CR Bank (1010) - DOUBLE-ENTRY COMPLETE'
PRINT ''
PRINT 'EXCEPTION: POS Sales (immediate settlement)'
PRINT '  POS sales post complete double-entry immediately'
PRINT '  Bank reconciliation MATCHES existing entry (no new entry)'
PRINT ''
GO
