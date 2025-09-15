-- Posting Procedures for AP, AR, Expenses, Bank (idempotent)
-- Azure SQL compatible
-- Timestamp: 10-Sep-2025 13:48 SAST

/* Helper: resolve System AccountID by key */
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

/* ========================= AP (Suppliers) ========================= */
-- AP Supplier Invoice: DR INVENTORY or GRNI; CR AP_CONTROL
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

    DECLARE @Header INT;
    EXEC dbo.sp_CreateJournalEntry @JournalDate, @Reference, @Description, NULL, @CreatedBy, @BranchID, @JournalID=@Header OUTPUT;

    DECLARE @Line INT;
    DECLARE @AssetAcct INT = CASE WHEN @UseGRNI = 1 AND @GRNI > 0 THEN @GRNI ELSE @INV END;
    DECLARE @Desc1 VARCHAR(256) = 'AP Invoice #' + CAST(@InvoiceID AS VARCHAR(50));
    EXEC dbo.sp_AddJournalDetail @Header, @AssetAcct, @Amount, 0, @Desc1, NULL, NULL, NULL, NULL, @Line OUTPUT;
    EXEC dbo.sp_AddJournalDetail @Header, @AP,        0, @Amount, @Desc1, NULL, NULL, NULL, NULL, @Line OUTPUT;

    SET @JournalID = @Header;
END
GO

-- AP Supplier Credit Note: DR AP_CONTROL; CR PURCHASE_RETURNS or INVENTORY
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

-- AP Supplier Payment: DR AP_CONTROL; CR BANK_DEFAULT
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

/* ========================= AR (Customers) ========================= */
-- AR Customer Invoice: DR AR; CR SALES (+VAT_OUTPUT); COGS: DR COS; CR INVENTORY
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

-- AR Customer Credit Note: reverse SALES/VAT; adjust Inventory if goods returned
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

-- AR Customer Receipt: DR BANK_DEFAULT; CR AR
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

/* ========================= Expenses ========================= */
-- Expense Bill: DR Expense (+VAT_INPUT); CR AP_CONTROL or CR BANK_DEFAULT
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

-- Expense Payment: DR AP_CONTROL; CR BANK_DEFAULT (when bills were via AP)
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

/* ========================= Bank ========================= */
-- Bank Charge: DR BANK_CHARGES; CR BANK_DEFAULT
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

-- Bank Transfer: DR ToBank; CR FromBank
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
