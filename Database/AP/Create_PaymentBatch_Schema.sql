-- Payment Batch Schema (idempotent)
SET NOCOUNT ON;

IF OBJECT_ID('dbo.PaymentBatch','U') IS NULL
BEGIN
    CREATE TABLE dbo.PaymentBatch(
        BatchID INT IDENTITY(1,1) PRIMARY KEY,
        BranchID INT NOT NULL,
        BatchNumber NVARCHAR(30) NOT NULL,
        BankName NVARCHAR(60) NOT NULL,           -- FNB | Standard Bank | ABSA | Nedbank
        ExportFormat NVARCHAR(40) NOT NULL,       -- PAIN.001 | FNB_CSV | SBSA_CSV | ABSA_CSV | NEDBANK_CSV
        Status NVARCHAR(20) NOT NULL DEFAULT('Draft'), -- Draft|Exported|Posted|Cancelled
        CreatedBy INT NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        ExportedAt DATETIME2 NULL,
        PostedAt DATETIME2 NULL
    );
    CREATE UNIQUE INDEX UX_PaymentBatch_Branch_Number ON dbo.PaymentBatch(BranchID, BatchNumber);
END;

IF OBJECT_ID('dbo.PaymentBatchLine','U') IS NULL
BEGIN
    CREATE TABLE dbo.PaymentBatchLine(
        BatchLineID INT IDENTITY(1,1) PRIMARY KEY,
        BatchID INT NOT NULL,
        PayeeType NVARCHAR(20) NOT NULL,          -- Supplier|Expense|Misc
        PayeeID INT NULL,                         -- SupplierID or Payee master
        PayeeName NVARCHAR(150) NOT NULL,
        BankAccount NVARCHAR(32) NULL,
        BranchCode NVARCHAR(16) NULL,
        Amount DECIMAL(18,2) NOT NULL,
        MyReference NVARCHAR(30) NULL,
        BeneficiaryReference NVARCHAR(30) NULL,
        SourceTable NVARCHAR(50) NULL,            -- e.g. APInvoice, ExpenseBill
        SourceID INT NULL,
        IsPosted BIT NOT NULL DEFAULT(0),
        PostedJournalID INT NULL,
        CONSTRAINT FK_PaymentBatchLine_Batch FOREIGN KEY(BatchID) REFERENCES dbo.PaymentBatch(BatchID)
    );
    CREATE INDEX IX_PaymentBatchLine_Batch ON dbo.PaymentBatchLine(BatchID);
END;

PRINT 'Payment Batch schema ensured.';
