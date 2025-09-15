-- GL Smoke Test: posts sample AP, AR, Expense, Bank transactions and queries views
-- Azure SQL compatible
-- Timestamp: 10-Sep-2025 13:59 SAST

SET NOCOUNT ON;

PRINT '=== Verify prerequisites ===';
SELECT TOP 100 * FROM dbo.SystemAccounts ORDER BY SysKey;

DECLARE @Today date = CAST(SYSUTCDATETIME() AS date);
DECLARE @JID int;

PRINT '=== AP: Supplier Invoice ===';
EXEC dbo.sp_AP_Post_SupplierInvoice @InvoiceID=10001, @SupplierID=1, @JournalDate=@Today, @Amount=500.00,
    @UseGRNI=1, @Reference='AP Smoke', @Description='AP Supplier Invoice (Smoke)', @CreatedBy=1, @BranchID=0, @JournalID=@JID OUTPUT;
SELECT JournalID=@JID;
EXEC dbo.sp_PostJournal @JournalID=@JID, @PostedBy=1;

PRINT '=== AP: Supplier Payment ===';
EXEC dbo.sp_AP_Post_SupplierPayment @PaymentID=50001, @SupplierID=1, @JournalDate=@Today, @Amount=200.00,
    @Reference='AP Pay Smoke', @Description='AP Payment (Smoke)', @CreatedBy=1, @BranchID=0, @JournalID=@JID OUTPUT;
SELECT JournalID=@JID;
EXEC dbo.sp_PostJournal @JournalID=@JID, @PostedBy=1;

PRINT '=== AR: Customer Invoice (with VAT & COGS) ===';
EXEC dbo.sp_AR_Post_CustomerInvoice @InvoiceID=20001, @CustomerID=1, @JournalDate=@Today, @NetAmount=1000.00,
    @VATAmount=150.00, @COGSAmount=600.00, @Reference='AR Smoke', @Description='AR Invoice (Smoke)', @CreatedBy=1, @BranchID=0, @JournalID=@JID OUTPUT;
SELECT JournalID=@JID;
EXEC dbo.sp_PostJournal @JournalID=@JID, @PostedBy=1;

PRINT '=== AR: Customer Receipt ===';
EXEC dbo.sp_AR_Post_CustomerReceipt @ReceiptID=70001, @CustomerID=1, @JournalDate=@Today, @Amount=500.00,
    @Reference='AR Rcpt Smoke', @Description='AR Receipt (Smoke)', @CreatedBy=1, @BranchID=0, @JournalID=@JID OUTPUT;
SELECT JournalID=@JID;
EXEC dbo.sp_PostJournal @JournalID=@JID, @PostedBy=1;

PRINT '=== Expense: Bill via AP (with VAT) ===';
-- Use expense account 6100 (Bank Charges) as placeholder
DECLARE @ExpenseAcctId int = (SELECT TOP 1 AccountID FROM dbo.Accounts WHERE AccountCode='6100');
EXEC dbo.sp_Exp_Post_Bill @ExpenseID=30001, @JournalDate=@Today, @ExpenseAccountID=@ExpenseAcctId,
    @NetAmount=250.00, @VATAmount=37.50, @ViaAP=1, @Reference='EXP Smoke', @Description='Expense Bill (Smoke)',
    @CreatedBy=1, @BranchID=0, @JournalID=@JID OUTPUT;
SELECT JournalID=@JID;
EXEC dbo.sp_PostJournal @JournalID=@JID, @PostedBy=1;

PRINT '=== Bank: Charge ===';
EXEC dbo.sp_Bank_Post_Charge @ChargeID=90001, @JournalDate=@Today, @Amount=25.00,
    @Reference='BANK Chg Smoke', @Description='Bank Charge (Smoke)', @CreatedBy=1, @BranchID=0, @JournalID=@JID OUTPUT;
SELECT JournalID=@JID;
EXEC dbo.sp_PostJournal @JournalID=@JID, @PostedBy=1;

PRINT '=== Reports: TB and samples ===';
SELECT TOP 50 * FROM dbo.v_TrialBalance ORDER BY AccountCode;
SELECT TOP 50 * FROM dbo.v_JournalLines_ByJournal ORDER BY JournalID, LineNumber;
SELECT TOP 50 * FROM dbo.v_JournalLines_ByAccountWithRunning ORDER BY AccountID, JournalDate, JournalID, LineNumber;
