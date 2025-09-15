-- GL Master Setup Script (Azure SQL)
-- Runs full setup in correct order. Safe to re-run.
-- Timestamp: 11-Sep-2025 21:01 SAST

/* ===================== Pre-Clean (optional) ===================== */
-- If earlier runs created empty stub procedures, drop them so ALTER below will succeed
IF OBJECT_ID('dbo.sp_CreateJournalEntry','P') IS NOT NULL DROP PROCEDURE dbo.sp_CreateJournalEntry;
IF OBJECT_ID('dbo.sp_AddJournalDetail','P') IS NOT NULL DROP PROCEDURE dbo.sp_AddJournalDetail;
IF OBJECT_ID('dbo.sp_PostJournal','P') IS NOT NULL DROP PROCEDURE dbo.sp_PostJournal;

IF OBJECT_ID('dbo.sp_AP_Post_SupplierInvoice','P') IS NOT NULL DROP PROCEDURE dbo.sp_AP_Post_SupplierInvoice;
IF OBJECT_ID('dbo.sp_AP_Post_SupplierCredit','P') IS NOT NULL DROP PROCEDURE dbo.sp_AP_Post_SupplierCredit;
IF OBJECT_ID('dbo.sp_AP_Post_SupplierPayment','P') IS NOT NULL DROP PROCEDURE dbo.sp_AP_Post_SupplierPayment;

IF OBJECT_ID('dbo.sp_AR_Post_CustomerInvoice','P') IS NOT NULL DROP PROCEDURE dbo.sp_AR_Post_CustomerInvoice;
IF OBJECT_ID('dbo.sp_AR_Post_CustomerCredit','P') IS NOT NULL DROP PROCEDURE dbo.sp_AR_Post_CustomerCredit;
IF OBJECT_ID('dbo.sp_AR_Post_CustomerReceipt','P') IS NOT NULL DROP PROCEDURE dbo.sp_AR_Post_CustomerReceipt;

IF OBJECT_ID('dbo.sp_Exp_Post_Bill','P') IS NOT NULL DROP PROCEDURE dbo.sp_Exp_Post_Bill;
IF OBJECT_ID('dbo.sp_Exp_Post_Payment','P') IS NOT NULL DROP PROCEDURE dbo.sp_Exp_Post_Payment;

IF OBJECT_ID('dbo.sp_Bank_Post_Charge','P') IS NOT NULL DROP PROCEDURE dbo.sp_Bank_Post_Charge;
IF OBJECT_ID('dbo.sp_Bank_Post_Transfer','P') IS NOT NULL DROP PROCEDURE dbo.sp_Bank_Post_Transfer;
GO

/* ===================== GL_Core_Tables.sql ===================== */
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Accounts' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.Accounts (
        AccountID        INT IDENTITY(1,1) PRIMARY KEY,
        AccountCode      VARCHAR(32) NOT NULL UNIQUE,
        AccountName      VARCHAR(128) NOT NULL,
        AccountType      VARCHAR(32) NOT NULL,
        ParentAccountID  INT NULL,
        IsActive         BIT NOT NULL DEFAULT(1)
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Journals' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.Journals (
        JournalID     INT IDENTITY(1,1) PRIMARY KEY,
        JournalDate   DATE NOT NULL,
        JournalNumber VARCHAR(50) NULL,
        Reference     VARCHAR(100) NULL,
        Description   VARCHAR(256) NULL,
        FiscalPeriodID INT NULL,
        BranchID      INT NULL,
        CreatedBy     INT NULL,
        CreatedAt     DATETIME NOT NULL DEFAULT(GETUTCDATE()),
        PostedBy      INT NULL,
        PostedAt      DATETIME NULL,
        PostedFlag    BIT NOT NULL DEFAULT(0)
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'JournalLines' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE dbo.JournalLines (
        JournalLineID INT IDENTITY(1,1) PRIMARY KEY,
        JournalID     INT NOT NULL,
        LineNumber    INT NOT NULL,
        AccountID     INT NOT NULL,
        Debit         DECIMAL(18,2) NOT NULL DEFAULT(0),
        Credit        DECIMAL(18,2) NOT NULL DEFAULT(0),
        LineDescription VARCHAR(256) NULL,
        Reference1    VARCHAR(100) NULL,
        Reference2    VARCHAR(100) NULL,
        CostCenterID  INT NULL,
        ProjectID     INT NULL,
        ClearedFlag   BIT NOT NULL DEFAULT(0),
        StatementRef  VARCHAR(100) NULL,
        CONSTRAINT FK_JournalLines_Journals FOREIGN KEY (JournalID) REFERENCES dbo.Journals(JournalID),
        CONSTRAINT FK_JournalLines_Accounts FOREIGN KEY (AccountID) REFERENCES dbo.Accounts(AccountID)
    );
    CREATE UNIQUE INDEX IX_JournalLines_UQ ON dbo.JournalLines(JournalID, LineNumber);
END
GO

IF OBJECT_ID('dbo.SystemAccounts','U') IS NULL
BEGIN
    CREATE TABLE dbo.SystemAccounts (
        SysKey    VARCHAR(64) NOT NULL PRIMARY KEY,
        AccountID INT NULL
    );
END
GO

/* ===================== GL_SystemAccounts_Seed.sql (fixed) ===================== */
;WITH Keys(SysKey) AS (
    SELECT 'AP_CONTROL' UNION ALL
    SELECT 'AR_CONTROL' UNION ALL
    SELECT 'INVENTORY' UNION ALL
    SELECT 'GRNI' UNION ALL
    SELECT 'PURCHASE_RETURNS' UNION ALL
    SELECT 'SALES' UNION ALL
    SELECT 'SALES_RETURNS' UNION ALL
    SELECT 'COS' UNION ALL
    SELECT 'VAT_INPUT' UNION ALL
    SELECT 'VAT_OUTPUT' UNION ALL
    SELECT 'BANK_DEFAULT' UNION ALL
    SELECT 'BANK_CHARGES' UNION ALL
    SELECT 'ROUNDING'
)
MERGE dbo.SystemAccounts AS tgt
USING Keys AS src
ON tgt.SysKey = src.SysKey
WHEN NOT MATCHED BY TARGET THEN
    INSERT (SysKey, AccountID) VALUES (src.SysKey, NULL)
-- do not remove extra keys
;
GO

/* ===================== GL_Core_SPs.sql ===================== */
IF OBJECT_ID('dbo.sp_CreateJournalEntry','P') IS NULL
    EXEC ('CREATE PROCEDURE dbo.sp_CreateJournalEntry AS RETURN 0');
GO
ALTER PROCEDURE dbo.sp_CreateJournalEntry
    @JournalDate     DATE,
    @Reference       VARCHAR(100) = NULL,
    @Description     VARCHAR(256) = NULL,
    @FiscalPeriodID  INT = NULL,
    @CreatedBy       INT = NULL,
    @BranchID        INT = NULL,
    @JournalID       INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Journals (JournalDate, JournalNumber, Reference, Description, FiscalPeriodID, BranchID, CreatedBy, CreatedAt, PostedBy, PostedAt, PostedFlag)
    VALUES (@JournalDate, NULL, @Reference, @Description, @FiscalPeriodID, @BranchID, @CreatedBy, SYSUTCDATETIME(), NULL, NULL, 0);
    SET @JournalID = CAST(SCOPE_IDENTITY() AS INT);
END
GO

IF OBJECT_ID('dbo.sp_AddJournalDetail','P') IS NULL
    EXEC ('CREATE PROCEDURE dbo.sp_AddJournalDetail AS RETURN 0');
GO
ALTER PROCEDURE dbo.sp_AddJournalDetail
    @JournalID     INT,
    @AccountID     INT,
    @Debit         DECIMAL(18,2),
    @Credit        DECIMAL(18,2),
    @Description   VARCHAR(256) = NULL,
    @Reference1    VARCHAR(100) = NULL,
    @Reference2    VARCHAR(100) = NULL,
    @CostCenterID  INT = NULL,
    @ProjectID     INT = NULL,
    @LineNumber    INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NextLine INT = 1;
    SELECT @NextLine = ISNULL(MAX(LineNumber),0) + 1 FROM dbo.JournalLines WHERE JournalID = @JournalID;
    INSERT INTO dbo.JournalLines (JournalID, LineNumber, AccountID, Debit, Credit, LineDescription, Reference1, Reference2, CostCenterID, ProjectID, ClearedFlag, StatementRef)
    VALUES (@JournalID, @NextLine, @AccountID, @Debit, @Credit, @Description, @Reference1, @Reference2, @CostCenterID, @ProjectID, 0, NULL);
    SET @LineNumber = @NextLine;
END
GO

IF OBJECT_ID('dbo.sp_PostJournal','P') IS NULL
    EXEC ('CREATE PROCEDURE dbo.sp_PostJournal AS RETURN 0');
GO
ALTER PROCEDURE dbo.sp_PostJournal
    @JournalID INT,
    @PostedBy  INT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Journals
    SET PostedFlag = 1,
        PostedBy = @PostedBy,
        PostedAt = SYSUTCDATETIME()
    WHERE JournalID = @JournalID;
END
GO

/* ===================== GL_Posting_Procedures.sql (fixed) ===================== */
IF OBJECT_ID('dbo.ufn_GetSystemAccountId','FN') IS NULL
    EXEC('CREATE FUNCTION dbo.ufn_GetSystemAccountId(@k varchar(64)) RETURNS INT AS BEGIN RETURN 0 END');
GO
ALTER FUNCTION dbo.ufn_GetSystemAccountId(@k varchar(64))
RETURNS INT
AS
BEGIN
    DECLARE @id INT = 0;
    SELECT TOP 1 @id = ISNULL(AccountID,0) FROM dbo.SystemAccounts WHERE SysKey = @k;
    RETURN ISNULL(@id,0);
END
GO

-- AP Supplier Invoice
IF OBJECT_ID('dbo.sp_AP_Post_SupplierInvoice','P') IS NULL
    EXEC ('CREATE PROCEDURE dbo.sp_AP_Post_SupplierInvoice AS RETURN 0');
GO
ALTER PROCEDURE dbo.sp_AP_Post_SupplierInvoice
    @InvoiceID   INT,
    @SupplierID  INT,
    @JournalDate DATE,
    @Amount      DECIMAL(18,2),
    @UseGRNI     BIT = 0,
    @Reference   VARCHAR(100) = NULL,
    @Description VARCHAR(256) = NULL,
    @CreatedBy   INT = NULL,
    @BranchID    INT = NULL,
    @JournalID   INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @AP INT = dbo.ufn_GetSystemAccountId('AP_CONTROL');
    DECLARE @INV INT = dbo.ufn_GetSystemAccountId('INVENTORY');
    DECLARE @GRNI INT = dbo.ufn_GetSystemAccountId('GRNI');
    IF ISNULL(@AP,0) = 0 OR (ISNULL(@INV,0) = 0 AND ISNULL(@GRNI,0) = 0)
        RAISERROR('SystemAccounts mapping missing for AP/INVENTORY/GRNI', 16, 1);

    DECLARE @Header INT; DECLARE @Line INT;
    EXEC dbo.sp_CreateJournalEntry @JournalDate, @Reference, @Description, NULL, @CreatedBy, @BranchID, @JournalID=@Header OUTPUT;

    DECLARE @AssetAcct INT = CASE WHEN @UseGRNI = 1 AND @GRNI > 0 THEN @GRNI ELSE @INV END;
    DECLARE @Desc1 VARCHAR(256) = 'AP Invoice #' + CAST(@InvoiceID AS VARCHAR(50));
    EXEC dbo.sp_AddJournalDetail @Header, @AssetAcct, @Amount, 0, @Desc1, NULL, NULL, NULL, NULL, @Line OUTPUT;
    EXEC dbo.sp_AddJournalDetail @Header, @AP,        0, @Amount, @Desc1, NULL, NULL, NULL, NULL, @Line OUTPUT;

    SET @JournalID = @Header;
END
GO

-- AP Supplier Credit
IF OBJECT_ID('dbo.sp_AP_Post_SupplierCredit','P') IS NULL
    EXEC ('CREATE PROCEDURE dbo.sp_AP_Post_SupplierCredit AS RETURN 0');
GO
ALTER PROCEDURE dbo.sp_AP_Post_SupplierCredit
    @CreditNoteID INT,
    @SupplierID   INT,
    @JournalDate  DATE,
    @Amount       DECIMAL(18,2),
    @UsePurchaseReturns BIT = 1,
    @Reference    VARCHAR(100) = NULL,
    @Description  VARCHAR(256) = NULL,
    @CreatedBy    INT = NULL,
    @BranchID     INT = NULL,
    @JournalID    INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @AP INT = dbo.ufn_GetSystemAccountId('AP_CONTROL');
    DECLARE @INV INT = dbo.ufn_GetSystemAccountId('INVENTORY');
    DECLARE @PR INT = dbo.ufn_GetSystemAccountId('PURCHASE_RETURNS');
    IF ISNULL(@AP,0) = 0 OR (ISNULL(@PR,0) = 0 AND ISNULL(@INV,0) = 0)
        RAISERROR('SystemAccounts mapping missing for AP/PURCHASE_RETURNS/INVENTORY', 16, 1);

    DECLARE @Header INT; DECLARE @Line INT;
    EXEC dbo.sp_CreateJournalEntry @JournalDate, @Reference, @Description, NULL, @CreatedBy, @BranchID, @JournalID=@Header OUTPUT;

    DECLARE @Desc2 VARCHAR(256) = 'AP Credit #' + CAST(@CreditNoteID AS VARCHAR(50));
    DECLARE @CrAcct INT = CASE WHEN @UsePurchaseReturns=1 AND @PR>0 THEN @PR ELSE @INV END;
    EXEC dbo.sp_AddJournalDetail @Header, @AP,  @Amount, 0, @Desc2, NULL, NULL, NULL, NULL, @Line OUTPUT;
    EXEC dbo.sp_AddJournalDetail @Header, @CrAcct, 0, @Amount, @Desc2, NULL, NULL, NULL, NULL, @Line OUTPUT;

    SET @JournalID = @Header;
END
GO

-- AP Supplier Payment
IF OBJECT_ID('dbo.sp_AP_Post_SupplierPayment','P') IS NULL
    EXEC ('CREATE PROCEDURE dbo.sp_AP_Post_SupplierPayment AS RETURN 0');
GO
ALTER PROCEDURE dbo.sp_AP_Post_SupplierPayment
    @PaymentID   INT,
    @SupplierID  INT,
    @JournalDate DATE,
    @Amount      DECIMAL(18,2),
    @Reference   VARCHAR(100) = NULL,
    @Description VARCHAR(256) = NULL,
    @CreatedBy   INT = NULL,
    @BranchID    INT = NULL,
    @JournalID   INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @AP INT = dbo.ufn_GetSystemAccountId('AP_CONTROL');
    DECLARE @BANK INT = dbo.ufn_GetSystemAccountId('BANK_DEFAULT');
    IF ISNULL(@AP,0)=0 OR ISNULL(@BANK,0)=0 RAISERROR('SystemAccounts mapping missing for AP/BANK_DEFAULT', 16, 1);

    DECLARE @Header INT; DECLARE @Line INT;
    EXEC dbo.sp_CreateJournalEntry @JournalDate, @Reference, @Description, NULL, @CreatedBy, @BranchID, @JournalID=@Header OUTPUT;
    DECLARE @Desc3 VARCHAR(256) = 'AP Payment #' + CAST(@PaymentID AS VARCHAR(50));
    EXEC dbo.sp_AddJournalDetail @Header, @AP,   @Amount, 0, @Desc3, NULL, NULL, NULL, NULL, @Line OUTPUT;
    EXEC dbo.sp_AddJournalDetail @Header, @BANK, 0, @Amount, @Desc3, NULL, NULL, NULL, NULL, @Line OUTPUT;
    SET @JournalID = @Header;
END
GO

-- AR Customer Invoice
IF OBJECT_ID('dbo.sp_AR_Post_CustomerInvoice','P') IS NULL
    EXEC ('CREATE PROCEDURE dbo.sp_AR_Post_CustomerInvoice AS RETURN 0');
GO
ALTER PROCEDURE dbo.sp_AR_Post_CustomerInvoice
    @InvoiceID    INT,
    @CustomerID   INT,
    @JournalDate  DATE,
    @NetAmount    DECIMAL(18,2),
    @VATAmount    DECIMAL(18,2) = 0,
    @COGSAmount   DECIMAL(18,2) = 0,
    @Reference    VARCHAR(100) = NULL,
    @Description  VARCHAR(256) = NULL,
    @CreatedBy    INT = NULL,
    @BranchID     INT = NULL,
    @JournalID    INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @AR INT = dbo.ufn_GetSystemAccountId('AR_CONTROL');
    DECLARE @SALES INT = dbo.ufn_GetSystemAccountId('SALES');
    DECLARE @VAT_OUT INT = dbo.ufn_GetSystemAccountId('VAT_OUTPUT');
    DECLARE @COS INT = dbo.ufn_GetSystemAccountId('COS');
    DECLARE @INV INT = dbo.ufn_GetSystemAccountId('INVENTORY');
    IF ISNULL(@AR,0)=0 OR ISNULL(@SALES,0)=0 OR (ISNULL(@VATAmount,0)<>0 AND ISNULL(@VAT_OUT,0)=0)
        RAISERROR('SystemAccounts mapping missing for AR/SALES/VAT_OUTPUT', 16, 1);
    IF ISNULL(@COGSAmount,0)<>0 AND (ISNULL(@COS,0)=0 OR ISNULL(@INV,0)=0)
        RAISERROR('SystemAccounts mapping missing for COS/INVENTORY', 16, 1);

    DECLARE @Header INT; DECLARE @Line INT; DECLARE @Gross DECIMAL(18,2) = ISNULL(@NetAmount,0)+ISNULL(@VATAmount,0);
    EXEC dbo.sp_CreateJournalEntry @JournalDate, @Reference, @Description, NULL, @CreatedBy, @BranchID, @JournalID=@Header OUTPUT;

    DECLARE @Desc4 VARCHAR(256) = 'AR Invoice #' + CAST(@InvoiceID AS VARCHAR(50));
    EXEC dbo.sp_AddJournalDetail @Header, @AR,    @Gross, 0, @Desc4, NULL, NULL, NULL, NULL, @Line OUTPUT;
    EXEC dbo.sp_AddJournalDetail @Header, @SALES, 0, @NetAmount, @Desc4, NULL, NULL, NULL, NULL, @Line OUTPUT;
    IF ISNULL(@VATAmount,0)<>0
        EXEC dbo.sp_AddJournalDetail @Header, @VAT_OUT, 0, @VATAmount, @Desc4, NULL, NULL, NULL, NULL, @Line OUTPUT;

    IF ISNULL(@COGSAmount,0)<>0
    BEGIN
        DECLARE @Desc5 VARCHAR(256) = 'COGS for INV #' + CAST(@InvoiceID AS VARCHAR(50));
        EXEC dbo.sp_AddJournalDetail @Header, @COS,  @COGSAmount, 0, @Desc5, NULL, NULL, NULL, NULL, @Line OUTPUT;
        EXEC dbo.sp_AddJournalDetail @Header, @INV,  0, @COGSAmount, @Desc5, NULL, NULL, NULL, NULL, @Line OUTPUT;
    END

    SET @JournalID = @Header;
END
GO

-- AR Customer Credit
IF OBJECT_ID('dbo.sp_AR_Post_CustomerCredit','P') IS NULL
    EXEC ('CREATE PROCEDURE dbo.sp_AR_Post_CustomerCredit AS RETURN 0');
GO
ALTER PROCEDURE dbo.sp_AR_Post_CustomerCredit
    @CreditNoteID INT,
    @CustomerID   INT,
    @JournalDate  DATE,
    @NetAmount    DECIMAL(18,2),
    @VATAmount    DECIMAL(18,2) = 0,
    @COGSReturn   DECIMAL(18,2) = 0,
    @Reference    VARCHAR(100) = NULL,
    @Description  VARCHAR(256) = NULL,
    @CreatedBy    INT = NULL,
    @BranchID     INT = NULL,
    @JournalID    INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @AR INT = dbo.ufn_GetSystemAccountId('AR_CONTROL');
    DECLARE @SALES_RET INT = dbo.ufn_GetSystemAccountId('SALES_RETURNS');
    DECLARE @VAT_OUT INT = dbo.ufn_GetSystemAccountId('VAT_OUTPUT');
    DECLARE @COS INT = dbo.ufn_GetSystemAccountId('COS');
    DECLARE @INV INT = dbo.ufn_GetSystemAccountId('INVENTORY');
    IF ISNULL(@AR,0)=0 OR ISNULL(@SALES_RET,0)=0 OR (ISNULL(@VATAmount,0)<>0 AND ISNULL(@VAT_OUT,0)=0)
        RAISERROR('SystemAccounts mapping missing for AR/SALES_RETURNS/VAT_OUTPUT', 16, 1);

    DECLARE @Header INT; DECLARE @Line INT; DECLARE @Gross DECIMAL(18,2) = ISNULL(@NetAmount,0)+ISNULL(@VATAmount,0);
    EXEC dbo.sp_CreateJournalEntry @JournalDate, @Reference, @Description, NULL, @CreatedBy, @BranchID, @JournalID=@Header OUTPUT;

    DECLARE @Desc6 VARCHAR(256) = 'AR Credit #' + CAST(@CreditNoteID AS VARCHAR(50));
    EXEC dbo.sp_AddJournalDetail @Header, @SALES_RET, @NetAmount, 0, @Desc6, NULL, NULL, NULL, NULL, @Line OUTPUT;
    IF ISNULL(@VATAmount,0)<>0
        EXEC dbo.sp_AddJournalDetail @Header, @VAT_OUT, @VATAmount, 0, @Desc6, NULL, NULL, NULL, NULL, @Line OUTPUT;
    EXEC dbo.sp_AddJournalDetail @Header, @AR, 0, @Gross, @Desc6, NULL, NULL, NULL, NULL, @Line OUTPUT;

    IF ISNULL(@COGSReturn,0)<>0
    BEGIN
        DECLARE @Desc7 VARCHAR(256) = 'Return for CN #' + CAST(@CreditNoteID AS VARCHAR(50));
        EXEC dbo.sp_AddJournalDetail @Header, @INV,  @COGSReturn, 0, @Desc7, NULL, NULL, NULL, NULL, @Line OUTPUT;
        EXEC dbo.sp_AddJournalDetail @Header, @COS,  0, @COGSReturn, @Desc7, NULL, NULL, NULL, NULL, @Line OUTPUT;
    END

    SET @JournalID = @Header;
END
GO

-- AR Customer Receipt
IF OBJECT_ID('dbo.sp_AR_Post_CustomerReceipt','P') IS NULL
    EXEC ('CREATE PROCEDURE dbo.sp_AR_Post_CustomerReceipt AS RETURN 0');
GO
ALTER PROCEDURE dbo.sp_AR_Post_CustomerReceipt
    @ReceiptID   INT,
    @CustomerID  INT,
    @JournalDate DATE,
    @Amount      DECIMAL(18,2),
    @Reference   VARCHAR(100) = NULL,
    @Description VARCHAR(256) = NULL,
    @CreatedBy   INT = NULL,
    @BranchID    INT = NULL,
    @JournalID   INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @AR INT = dbo.ufn_GetSystemAccountId('AR_CONTROL');
    DECLARE @BANK INT = dbo.ufn_GetSystemAccountId('BANK_DEFAULT');
    IF ISNULL(@AR,0)=0 OR ISNULL(@BANK,0)=0 RAISERROR('SystemAccounts mapping missing for AR/BANK_DEFAULT', 16, 1);

    DECLARE @Header INT; DECLARE @Line INT;
    EXEC dbo.sp_CreateJournalEntry @JournalDate, @Reference, @Description, NULL, @CreatedBy, @BranchID, @JournalID=@Header OUTPUT;
    DECLARE @Desc8 VARCHAR(256) = 'AR Receipt #' + CAST(@ReceiptID AS VARCHAR(50));
    EXEC dbo.sp_AddJournalDetail @Header, @BANK, @Amount, 0, @Desc8, NULL, NULL, NULL, NULL, @Line OUTPUT;
    EXEC dbo.sp_AddJournalDetail @Header, @AR,   0, @Amount, @Desc8, NULL, NULL, NULL, NULL, @Line OUTPUT;
    SET @JournalID = @Header;
END
GO

-- Expense Bill
IF OBJECT_ID('dbo.sp_Exp_Post_Bill','P') IS NULL
    EXEC ('CREATE PROCEDURE dbo.sp_Exp_Post_Bill AS RETURN 0');
GO
ALTER PROCEDURE dbo.sp_Exp_Post_Bill
    @ExpenseID    INT,
    @JournalDate  DATE,
    @ExpenseAccountID INT,
    @NetAmount    DECIMAL(18,2),
    @VATAmount    DECIMAL(18,2) = 0,
    @ViaAP        BIT = 1,
    @Reference    VARCHAR(100) = NULL,
    @Description  VARCHAR(256) = NULL,
    @CreatedBy    INT = NULL,
    @BranchID     INT = NULL,
    @JournalID    INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @AP INT = dbo.ufn_GetSystemAccountId('AP_CONTROL');
    DECLARE @BANK INT = dbo.ufn_GetSystemAccountId('BANK_DEFAULT');
    DECLARE @VAT_IN INT = dbo.ufn_GetSystemAccountId('VAT_INPUT');
    IF (@ViaAP=1 AND ISNULL(@AP,0)=0) OR (@ViaAP=0 AND ISNULL(@BANK,0)=0)
        RAISERROR('SystemAccounts mapping missing for AP/BANK_DEFAULT', 16, 1);

    DECLARE @Header INT; DECLARE @Line INT; DECLARE @Gross DECIMAL(18,2) = ISNULL(@NetAmount,0)+ISNULL(@VATAmount,0);
    EXEC dbo.sp_CreateJournalEntry @JournalDate, @Reference, @Description, NULL, @CreatedBy, @BranchID, @JournalID=@Header OUTPUT;

    DECLARE @Desc9 VARCHAR(256) = 'Expense Bill #' + CAST(@ExpenseID AS VARCHAR(50));
    DECLARE @CredAcct INT = CASE WHEN @ViaAP=1 THEN @AP ELSE @BANK END;
    EXEC dbo.sp_AddJournalDetail @Header, @ExpenseAccountID, @NetAmount, 0, @Desc9, NULL, NULL, NULL, NULL, @Line OUTPUT;
    IF ISNULL(@VATAmount,0)<>0 AND ISNULL(@VAT_IN,0)<>0
        EXEC dbo.sp_AddJournalDetail @Header, @VAT_IN, @VATAmount, 0, @Desc9, NULL, NULL, NULL, NULL, @Line OUTPUT;
    EXEC dbo.sp_AddJournalDetail @Header, @CredAcct, 0, @Gross, @Desc9, NULL, NULL, NULL, NULL, @Line OUTPUT;

    SET @JournalID = @Header;
END
GO

-- Expense Payment
IF OBJECT_ID('dbo.sp_Exp_Post_Payment','P') IS NULL
    EXEC ('CREATE PROCEDURE dbo.sp_Exp_Post_Payment AS RETURN 0');
GO
ALTER PROCEDURE dbo.sp_Exp_Post_Payment
    @PaymentID   INT,
    @JournalDate DATE,
    @Amount      DECIMAL(18,2),
    @Reference   VARCHAR(100) = NULL,
    @Description VARCHAR(256) = NULL,
    @CreatedBy   INT = NULL,
    @BranchID    INT = NULL,
    @JournalID   INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @AP INT = dbo.ufn_GetSystemAccountId('AP_CONTROL');
    DECLARE @BANK INT = dbo.ufn_GetSystemAccountId('BANK_DEFAULT');
    IF ISNULL(@AP,0)=0 OR ISNULL(@BANK,0)=0 RAISERROR('SystemAccounts mapping missing for AP/BANK_DEFAULT', 16, 1);

    DECLARE @Header INT; DECLARE @Line INT;
    EXEC dbo.sp_CreateJournalEntry @JournalDate, @Reference, @Description, NULL, @CreatedBy, @BranchID, @JournalID=@Header OUTPUT;
    DECLARE @Desc10 VARCHAR(256) = 'Expense Payment #' + CAST(@PaymentID AS VARCHAR(50));
    EXEC dbo.sp_AddJournalDetail @Header, @AP,   @Amount, 0, @Desc10, NULL, NULL, NULL, NULL, @Line OUTPUT;
    EXEC dbo.sp_AddJournalDetail @Header, @BANK, 0, @Amount, @Desc10, NULL, NULL, NULL, NULL, @Line OUTPUT;
    SET @JournalID = @Header;
END
GO

-- Bank Charge
IF OBJECT_ID('dbo.sp_Bank_Post_Charge','P') IS NULL
    EXEC ('CREATE PROCEDURE dbo.sp_Bank_Post_Charge AS RETURN 0');
GO
ALTER PROCEDURE dbo.sp_Bank_Post_Charge
    @ChargeID    INT,
    @JournalDate DATE,
    @Amount      DECIMAL(18,2),
    @Reference   VARCHAR(100) = NULL,
    @Description VARCHAR(256) = NULL,
    @CreatedBy   INT = NULL,
    @BranchID    INT = NULL,
    @JournalID   INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @BANK INT = dbo.ufn_GetSystemAccountId('BANK_DEFAULT');
    DECLARE @CHG INT = dbo.ufn_GetSystemAccountId('BANK_CHARGES');
    IF ISNULL(@BANK,0)=0 OR ISNULL(@CHG,0)=0 RAISERROR('SystemAccounts mapping missing for BANK_DEFAULT/BANK_CHARGES', 16, 1);

    DECLARE @Header INT; DECLARE @Line INT;
    EXEC dbo.sp_CreateJournalEntry @JournalDate, @Reference, @Description, NULL, @CreatedBy, @BranchID, @JournalID=@Header OUTPUT;
    DECLARE @Desc11 VARCHAR(256) = 'Bank Charge #' + CAST(@ChargeID AS VARCHAR(50));
    EXEC dbo.sp_AddJournalDetail @Header, @CHG,  @Amount, 0, @Desc11, NULL, NULL, NULL, NULL, @Line OUTPUT;
    EXEC dbo.sp_AddJournalDetail @Header, @BANK, 0, @Amount, @Desc11, NULL, NULL, NULL, NULL, @Line OUTPUT;
    SET @JournalID = @Header;
END
GO

-- Bank Transfer
IF OBJECT_ID('dbo.sp_Bank_Post_Transfer','P') IS NULL
    EXEC ('CREATE PROCEDURE dbo.sp_Bank_Post_Transfer AS RETURN 0');
GO
ALTER PROCEDURE dbo.sp_Bank_Post_Transfer
    @TransferID      INT,
    @JournalDate     DATE,
    @Amount          DECIMAL(18,2),
    @FromBankAccountID INT,
    @ToBankAccountID   INT,
    @Reference       VARCHAR(100) = NULL,
    @Description     VARCHAR(256) = NULL,
    @CreatedBy       INT = NULL,
    @BranchID        INT = NULL,
    @JournalID       INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    IF ISNULL(@FromBankAccountID,0)=0 OR ISNULL(@ToBankAccountID,0)=0
        RAISERROR('Provide FromBankAccountID and ToBankAccountID (GL AccountIDs)', 16, 1);

    DECLARE @Header INT; DECLARE @Line INT;
    EXEC dbo.sp_CreateJournalEntry @JournalDate, @Reference, @Description, NULL, @CreatedBy, @BranchID, @JournalID=@Header OUTPUT;
    DECLARE @Desc12 VARCHAR(256) = 'Bank Transfer #' + CAST(@TransferID AS VARCHAR(50));
    EXEC dbo.sp_AddJournalDetail @Header, @ToBankAccountID,   @Amount, 0, @Desc12, NULL, NULL, NULL, NULL, @Line OUTPUT;
    EXEC dbo.sp_AddJournalDetail @Header, @FromBankAccountID, 0, @Amount, @Desc12, NULL, NULL, NULL, NULL, @Line OUTPUT;
    SET @JournalID = @Header;
END
GO

/* ===================== GL_Core_Views.sql ===================== */
IF OBJECT_ID('dbo.v_JournalLines_ByJournal','V') IS NOT NULL DROP VIEW dbo.v_JournalLines_ByJournal;
GO
CREATE VIEW dbo.v_JournalLines_ByJournal AS
SELECT j.JournalID, j.JournalDate, j.Reference, j.Description, j.PostedFlag,
       jl.LineNumber, jl.AccountID, jl.Debit, jl.Credit, jl.LineDescription, jl.Reference1, jl.Reference2
FROM dbo.Journals j
JOIN dbo.JournalLines jl ON jl.JournalID = j.JournalID;
GO

IF OBJECT_ID('dbo.v_JournalLines_ByAccountWithRunning','V') IS NOT NULL DROP VIEW dbo.v_JournalLines_ByAccountWithRunning;
GO
CREATE VIEW dbo.v_JournalLines_ByAccountWithRunning AS
SELECT jl.AccountID, j.JournalDate, j.JournalID, jl.LineNumber, jl.Debit, jl.Credit,
       SUM(jl.Debit - jl.Credit) OVER (PARTITION BY jl.AccountID ORDER BY j.JournalDate, j.JournalID, jl.LineNumber ROWS UNBOUNDED PRECEDING) AS RunningBalance,
       jl.LineDescription, j.Reference, j.Description
FROM dbo.JournalLines jl
JOIN dbo.Journals j ON j.JournalID = jl.JournalID;
GO

IF OBJECT_ID('dbo.v_TrialBalance','V') IS NOT NULL DROP VIEW dbo.v_TrialBalance;
GO
CREATE VIEW dbo.v_TrialBalance AS
SELECT a.AccountID, a.AccountCode, a.AccountName,
       SUM(jl.Debit) AS TotalDebit, SUM(jl.Credit) AS TotalCredit, SUM(jl.Debit - jl.Credit) AS Balance
FROM dbo.Accounts a
LEFT JOIN dbo.JournalLines jl ON jl.AccountID = a.AccountID
LEFT JOIN dbo.Journals j ON j.JournalID = jl.JournalID
GROUP BY a.AccountID, a.AccountCode, a.AccountName;
GO

IF OBJECT_ID('dbo.v_IncomeStatement','V') IS NOT NULL DROP VIEW dbo.v_IncomeStatement;
GO
CREATE VIEW dbo.v_IncomeStatement AS
SELECT a.AccountID, a.AccountCode, a.AccountName, a.AccountType,
       SUM(ISNULL(jl.Debit,0)) AS TotalDebit, SUM(ISNULL(jl.Credit,0)) AS TotalCredit,
       SUM(ISNULL(jl.Debit,0) - ISNULL(jl.Credit,0)) AS Balance
FROM dbo.Accounts a
LEFT JOIN dbo.JournalLines jl ON jl.AccountID = a.AccountID
LEFT JOIN dbo.Journals j ON j.JournalID = jl.JournalID
WHERE a.AccountType IN ('Revenue','Expense')
GROUP BY a.AccountID, a.AccountCode, a.AccountName, a.AccountType;
GO

IF OBJECT_ID('dbo.v_BalanceSheet','V') IS NOT NULL DROP VIEW dbo.v_BalanceSheet;
GO
CREATE VIEW dbo.v_BalanceSheet AS
SELECT a.AccountID, a.AccountCode, a.AccountName, a.AccountType,
       SUM(ISNULL(jl.Debit,0)) AS TotalDebit, SUM(ISNULL(jl.Credit,0)) AS TotalCredit,
       SUM(ISNULL(jl.Debit,0) - ISNULL(jl.Credit,0)) AS Balance
FROM dbo.Accounts a
LEFT JOIN dbo.JournalLines jl ON jl.AccountID = a.AccountID
LEFT JOIN dbo.Journals j ON j.JournalID = jl.JournalID
WHERE a.AccountType IN ('Asset','Liability','Equity')
GROUP BY a.AccountID, a.AccountCode, a.AccountName, a.AccountType;
GO

IF OBJECT_ID('dbo.v_AR_AgeAnalysis','V') IS NOT NULL DROP VIEW dbo.v_AR_AgeAnalysis;
GO
CREATE VIEW dbo.v_AR_AgeAnalysis AS
WITH Base AS (
    SELECT a.AccountID, a.AccountCode, a.AccountName, j.JournalDate, (jl.Debit - jl.Credit) AS Amount
    FROM dbo.Accounts a
    JOIN dbo.JournalLines jl ON jl.AccountID = a.AccountID
    JOIN dbo.Journals j ON j.JournalID = jl.JournalID
    WHERE a.AccountType = 'Asset'
)
SELECT AccountID, AccountCode, AccountName,
       SUM(CASE WHEN DATEDIFF(day, JournalDate, CAST(SYSUTCDATETIME() AS date)) <= 30 THEN Amount ELSE 0 END) AS Bucket_0_30,
       SUM(CASE WHEN DATEDIFF(day, JournalDate, CAST(SYSUTCDATETIME() AS date)) BETWEEN 31 AND 60 THEN Amount ELSE 0 END) AS Bucket_31_60,
       SUM(CASE WHEN DATEDIFF(day, JournalDate, CAST(SYSUTCDATETIME() AS date)) BETWEEN 61 AND 90 THEN Amount ELSE 0 END) AS Bucket_61_90,
       SUM(CASE WHEN DATEDIFF(day, JournalDate, CAST(SYSUTCDATETIME() AS date)) > 90 THEN Amount ELSE 0 END) AS Bucket_90_plus,
       SUM(Amount) AS Total
FROM Base
GROUP BY AccountID, AccountCode, AccountName;
GO

IF OBJECT_ID('dbo.v_AP_AgeAnalysis','V') IS NOT NULL DROP VIEW dbo.v_AP_AgeAnalysis;
GO
CREATE VIEW dbo.v_AP_AgeAnalysis AS
WITH Base AS (
    SELECT a.AccountID, a.AccountCode, a.AccountName, j.JournalDate, (jl.Credit - jl.Debit) AS Amount
    FROM dbo.Accounts a
    JOIN dbo.JournalLines jl ON jl.AccountID = a.AccountID
    JOIN dbo.Journals j ON j.JournalID = jl.JournalID
    WHERE a.AccountType = 'Liability'
)
SELECT AccountID, AccountCode, AccountName,
       SUM(CASE WHEN DATEDIFF(day, JournalDate, CAST(SYSUTCDATETIME() AS date)) <= 30 THEN Amount ELSE 0 END) AS Bucket_0_30,
       SUM(CASE WHEN DATEDIFF(day, JournalDate, CAST(SYSUTCDATETIME() AS date)) BETWEEN 31 AND 60 THEN Amount ELSE 0 END) AS Bucket_31_60,
       SUM(CASE WHEN DATEDIFF(day, JournalDate, CAST(SYSUTCDATETIME() AS date)) BETWEEN 61 AND 90 THEN Amount ELSE 0 END) AS Bucket_61_90,
       SUM(CASE WHEN DATEDIFF(day, JournalDate, CAST(SYSUTCDATETIME() AS date)) > 90 THEN Amount ELSE 0 END) AS Bucket_90_plus,
       SUM(Amount) AS Total
FROM Base
GROUP BY AccountID, AccountCode, AccountName;
GO

/* ===================== GL_Accounts_MinimalSeed.sql (optional) ===================== */
IF OBJECT_ID('dbo.Accounts','U') IS NULL
BEGIN
    RAISERROR('Accounts table missing. Run GL_Core_Tables first.', 16, 1);
END
ELSE
BEGIN
    MERGE dbo.Accounts AS tgt
    USING (VALUES
        ('1000','Inventory','Asset', NULL, 1),
        ('1001','GRNI Clearing','Asset', NULL, 1),
        ('1100','Bank - Default','Asset', NULL, 1),
        ('2000','Accounts Payable Control','Liability', NULL, 1),
        ('3000','Accounts Receivable Control','Asset', NULL, 1),
        ('4000','Sales','Revenue', NULL, 1),
        ('4001','Sales Returns','Revenue', NULL, 1),
        ('5000','Cost of Sales','Expense', NULL, 1),
        ('2100','VAT Input','Asset', NULL, 1),
        ('4100','VAT Output','Liability', NULL, 1),
        ('6100','Bank Charges','Expense', NULL, 1),
        ('6900','Rounding','Expense', NULL, 1)
    ) AS src(AccountCode, AccountName, AccountType, ParentAccountID, IsActive)
    ON tgt.AccountCode = src.AccountCode
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (AccountCode, AccountName, AccountType, ParentAccountID, IsActive)
        VALUES (src.AccountCode, src.AccountName, src.AccountType, src.ParentAccountID, src.IsActive);

    IF OBJECT_ID('dbo.SystemAccounts','U') IS NOT NULL
    BEGIN
        UPDATE sa SET AccountID = a.AccountID FROM dbo.SystemAccounts sa JOIN dbo.Accounts a ON a.AccountCode = '2000' WHERE sa.SysKey='AP_CONTROL' AND (sa.AccountID IS NULL OR sa.AccountID=0);
        UPDATE sa SET AccountID = a.AccountID FROM dbo.SystemAccounts sa JOIN dbo.Accounts a ON a.AccountCode = '3000' WHERE sa.SysKey='AR_CONTROL' AND (sa.AccountID IS NULL OR sa.AccountID=0);
        UPDATE sa SET AccountID = a.AccountID FROM dbo.SystemAccounts sa JOIN dbo.Accounts a ON a.AccountCode = '1000' WHERE sa.SysKey='INVENTORY' AND (sa.AccountID IS NULL OR sa.AccountID=0);
        UPDATE sa SET AccountID = a.AccountID FROM dbo.SystemAccounts sa JOIN dbo.Accounts a ON a.AccountCode = '1001' WHERE sa.SysKey='GRNI' AND (sa.AccountID IS NULL OR sa.AccountID=0);
        UPDATE sa SET AccountID = a.AccountID FROM dbo.SystemAccounts sa JOIN dbo.Accounts a ON a.AccountCode = '4000' WHERE sa.SysKey='SALES' AND (sa.AccountID IS NULL OR sa.AccountID=0);
        UPDATE sa SET AccountID = a.AccountID FROM dbo.SystemAccounts sa JOIN dbo.Accounts a ON a.AccountCode = '4001' WHERE sa.SysKey='SALES_RETURNS' AND (sa.AccountID IS NULL OR sa.AccountID=0);
        UPDATE sa SET AccountID = a.AccountID FROM dbo.SystemAccounts sa JOIN dbo.Accounts a ON a.AccountCode = '5000' WHERE sa.SysKey='COS' AND (sa.AccountID IS NULL OR sa.AccountID=0);
        UPDATE sa SET AccountID = a.AccountID FROM dbo.SystemAccounts sa JOIN dbo.Accounts a ON a.AccountCode = '2100' WHERE sa.SysKey='VAT_INPUT' AND (sa.AccountID IS NULL OR sa.AccountID=0);
        UPDATE sa SET AccountID = a.AccountID FROM dbo.SystemAccounts sa JOIN dbo.Accounts a ON a.AccountCode = '4100' WHERE sa.SysKey='VAT_OUTPUT' AND (sa.AccountID IS NULL OR sa.AccountID=0);
        UPDATE sa SET AccountID = a.AccountID FROM dbo.SystemAccounts sa JOIN dbo.Accounts a ON a.AccountCode = '1100' WHERE sa.SysKey='BANK_DEFAULT' AND (sa.AccountID IS NULL OR sa.AccountID=0);
        UPDATE sa SET AccountID = a.AccountID FROM dbo.SystemAccounts sa JOIN dbo.Accounts a ON a.AccountCode = '6100' WHERE sa.SysKey='BANK_CHARGES' AND (sa.AccountID IS NULL OR sa.AccountID=0);
        UPDATE sa SET AccountID = a.AccountID FROM dbo.SystemAccounts sa JOIN dbo.Accounts a ON a.AccountCode = '6900' WHERE sa.SysKey='ROUNDING' AND (sa.AccountID IS NULL OR sa.AccountID=0);
    END
END
GO

/* ===================== Quick Verification ===================== */
PRINT 'SystemAccounts mappings:';
SELECT * FROM dbo.SystemAccounts ORDER BY SysKey;
PRINT 'Top of Trial Balance:';
SELECT TOP 50 * FROM dbo.v_TrialBalance ORDER BY AccountCode;
GO

/* ===================== Optional Smoke Test ===================== */
-- To run smoke test, execute Database/GL_SmokeTest.sql separately or paste below after review.
