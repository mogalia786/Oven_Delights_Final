-- =============================================
-- EFT Payments Tracking Table
-- Purpose: Track EFT payments from POS until proof of payment is confirmed
-- Status: Pending (awaiting proof) -> Reflected (confirmed in bank account)
-- Bank ledger/journal only updated when status = 'Reflected'
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'POS_EFTPayments')
BEGIN
    CREATE TABLE POS_EFTPayments (
        EFTPaymentID INT IDENTITY(1,1) PRIMARY KEY,
        
        -- Payment Identification
        PaymentReference NVARCHAR(50) NOT NULL UNIQUE, -- INV-yyyyMMddHHmmss format
        TransactionType NVARCHAR(20) NOT NULL, -- 'Sale', 'CakeOrder', 'UserDefinedOrder'
        TransactionID INT NULL, -- Links to Sales.SaleID, POS_CustomOrders.OrderID, or POS_UserDefinedOrders.UserDefinedOrderID
        InvoiceNumber NVARCHAR(50) NULL,
        OrderNumber NVARCHAR(50) NULL,
        
        -- Branch and User Info
        BranchID INT NOT NULL,
        BranchName NVARCHAR(100) NULL,
        TillPointID INT NULL,
        CashierID INT NOT NULL,
        CashierName NVARCHAR(100) NULL,
        
        -- Payment Details
        Amount DECIMAL(18,2) NOT NULL,
        PaymentDate DATETIME NOT NULL DEFAULT GETDATE(),
        PaymentTime TIME NULL,
        
        -- Customer Information (for orders)
        CustomerName NVARCHAR(100) NULL,
        CustomerSurname NVARCHAR(100) NULL,
        CustomerCell NVARCHAR(20) NULL,
        
        -- EFT Status Tracking
        Status NVARCHAR(20) NOT NULL DEFAULT 'Pending', -- 'Pending', 'Reflected', 'Cancelled'
        ReflectedDate DATETIME NULL, -- Date when marked as Reflected
        ReflectedBy NVARCHAR(100) NULL, -- User who confirmed the payment
        ProofOfPaymentPath NVARCHAR(500) NULL, -- Optional: path to uploaded proof
        
        -- Bank Details (from EFT slip)
        BankName NVARCHAR(100) DEFAULT 'ABSA Bank',
        AccountNumber NVARCHAR(50) DEFAULT '4012345678',
        BranchCode NVARCHAR(20) DEFAULT '632005',
        
        -- Journal Entry Tracking
        JournalEntryID INT NULL, -- Links to JournalEntries when status = 'Reflected'
        LedgerUpdated BIT NOT NULL DEFAULT 0, -- Flag to track if ledger has been updated
        
        -- Notes and Audit
        Notes NVARCHAR(500) NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ModifiedDate DATETIME NULL,
        
        CONSTRAINT FK_EFTPayments_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
        CONSTRAINT FK_EFTPayments_Cashier FOREIGN KEY (CashierID) REFERENCES Users(UserID),
        CONSTRAINT CHK_EFTPayments_Status CHECK (Status IN ('Pending', 'Reflected', 'Cancelled'))
    )
    
    -- Indexes for performance
    CREATE INDEX IX_EFTPayments_Status ON POS_EFTPayments(Status)
    CREATE INDEX IX_EFTPayments_PaymentDate ON POS_EFTPayments(PaymentDate)
    CREATE INDEX IX_EFTPayments_BranchID ON POS_EFTPayments(BranchID)
    CREATE INDEX IX_EFTPayments_Reference ON POS_EFTPayments(PaymentReference)
    
    PRINT 'Table POS_EFTPayments created successfully'
END
ELSE
BEGIN
    PRINT 'Table POS_EFTPayments already exists'
END
GO

-- =============================================
-- Stored Procedure: Record EFT Payment from POS
-- =============================================
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_RecordEFTPayment')
    DROP PROCEDURE sp_RecordEFTPayment
GO

CREATE PROCEDURE sp_RecordEFTPayment
    @PaymentReference NVARCHAR(50),
    @TransactionType NVARCHAR(20),
    @TransactionID INT = NULL,
    @InvoiceNumber NVARCHAR(50) = NULL,
    @OrderNumber NVARCHAR(50) = NULL,
    @BranchID INT,
    @BranchName NVARCHAR(100) = NULL,
    @TillPointID INT = NULL,
    @CashierID INT,
    @CashierName NVARCHAR(100) = NULL,
    @Amount DECIMAL(18,2),
    @CustomerName NVARCHAR(100) = NULL,
    @CustomerSurname NVARCHAR(100) = NULL,
    @CustomerCell NVARCHAR(20) = NULL,
    @Notes NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON
    
    INSERT INTO POS_EFTPayments (
        PaymentReference, TransactionType, TransactionID, InvoiceNumber, OrderNumber,
        BranchID, BranchName, TillPointID, CashierID, CashierName,
        Amount, PaymentDate, PaymentTime,
        CustomerName, CustomerSurname, CustomerCell,
        Status, Notes
    )
    VALUES (
        @PaymentReference, @TransactionType, @TransactionID, @InvoiceNumber, @OrderNumber,
        @BranchID, @BranchName, @TillPointID, @CashierID, @CashierName,
        @Amount, GETDATE(), CONVERT(TIME, GETDATE()),
        @CustomerName, @CustomerSurname, @CustomerCell,
        'Pending', @Notes
    )
    
    SELECT SCOPE_IDENTITY() AS EFTPaymentID
END
GO

-- =============================================
-- Stored Procedure: Mark EFT Payment as Reflected
-- Updates bank ledger and journal entries
-- =============================================
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_MarkEFTPaymentReflected')
    DROP PROCEDURE sp_MarkEFTPaymentReflected
GO

CREATE PROCEDURE sp_MarkEFTPaymentReflected
    @EFTPaymentID INT,
    @ReflectedBy NVARCHAR(100),
    @ProofOfPaymentPath NVARCHAR(500) = NULL,
    @Notes NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRANSACTION
    
    BEGIN TRY
        DECLARE @Amount DECIMAL(18,2)
        DECLARE @BranchID INT
        DECLARE @PaymentReference NVARCHAR(50)
        DECLARE @TransactionType NVARCHAR(20)
        DECLARE @CurrentStatus NVARCHAR(20)
        DECLARE @InvoiceNumber NVARCHAR(50)
        
        -- Get payment details
        SELECT 
            @Amount = Amount,
            @BranchID = BranchID,
            @PaymentReference = PaymentReference,
            @TransactionType = TransactionType,
            @CurrentStatus = Status,
            @InvoiceNumber = InvoiceNumber
        FROM POS_EFTPayments
        WHERE EFTPaymentID = @EFTPaymentID
        
        -- Check if already reflected
        IF @CurrentStatus = 'Reflected'
        BEGIN
            RAISERROR('Payment already marked as Reflected', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END
        
        -- Update EFT payment status
        UPDATE POS_EFTPayments
        SET 
            Status = 'Reflected',
            ReflectedDate = GETDATE(),
            ReflectedBy = @ReflectedBy,
            ProofOfPaymentPath = @ProofOfPaymentPath,
            Notes = CASE WHEN @Notes IS NOT NULL THEN @Notes ELSE Notes END,
            ModifiedDate = GETDATE()
        WHERE EFTPaymentID = @EFTPaymentID
        
        -- Create journal entries for bank account
        -- DEBIT: Bank Account (money received)
        -- CREDIT: Debtors/Sales (depending on transaction type)
        
        DECLARE @BankLedgerID INT
        DECLARE @DebtorsLedgerID INT
        DECLARE @SalesRevenueLedgerID INT
        
        -- Get or create Bank ledger
        SELECT @BankLedgerID = LedgerID FROM Ledgers WHERE LedgerName = 'Bank' AND IsActive = 1
        IF @BankLedgerID IS NULL
        BEGIN
            INSERT INTO Ledgers (LedgerName, LedgerType, IsActive) VALUES ('Bank', 'Asset', 1)
            SET @BankLedgerID = SCOPE_IDENTITY()
        END
        
        -- Get or create Debtors ledger
        SELECT @DebtorsLedgerID = LedgerID FROM Ledgers WHERE LedgerName = 'Debtors' AND IsActive = 1
        IF @DebtorsLedgerID IS NULL
        BEGIN
            INSERT INTO Ledgers (LedgerName, LedgerType, IsActive) VALUES ('Debtors', 'Asset', 1)
            SET @DebtorsLedgerID = SCOPE_IDENTITY()
        END
        
        -- Get or create Sales Revenue ledger
        SELECT @SalesRevenueLedgerID = LedgerID FROM Ledgers WHERE LedgerName = 'Sales Revenue' AND IsActive = 1
        IF @SalesRevenueLedgerID IS NULL
        BEGIN
            INSERT INTO Ledgers (LedgerName, LedgerType, IsActive) VALUES ('Sales Revenue', 'Revenue', 1)
            SET @SalesRevenueLedgerID = SCOPE_IDENTITY()
        END
        
        -- Create journal entry: DEBIT Bank
        INSERT INTO GeneralJournal (
            TransactionDate, JournalType, Reference, LedgerID, 
            Debit, Credit, Description, BranchID, CreatedBy, CreatedDate
        )
        VALUES (
            GETDATE(), 'EFT Payment', @PaymentReference, @BankLedgerID,
            @Amount, 0, 'EFT Payment Reflected - ' + @InvoiceNumber, @BranchID, @ReflectedBy, GETDATE()
        )
        
        -- Create journal entry: CREDIT Debtors (for orders) or Sales Revenue (for direct sales)
        DECLARE @CreditLedgerID INT
        DECLARE @CreditDescription NVARCHAR(200)
        
        IF @TransactionType IN ('CakeOrder', 'UserDefinedOrder')
        BEGIN
            SET @CreditLedgerID = @DebtorsLedgerID
            SET @CreditDescription = 'EFT Payment Received - ' + @InvoiceNumber
        END
        ELSE
        BEGIN
            SET @CreditLedgerID = @SalesRevenueLedgerID
            SET @CreditDescription = 'EFT Sale Payment - ' + @InvoiceNumber
        END
        
        INSERT INTO GeneralJournal (
            TransactionDate, JournalType, Reference, LedgerID, 
            Debit, Credit, Description, BranchID, CreatedBy, CreatedDate
        )
        VALUES (
            GETDATE(), 'EFT Payment', @PaymentReference, @CreditLedgerID,
            0, @Amount, @CreditDescription, @BranchID, @ReflectedBy, GETDATE()
        )
        
        -- Mark ledger as updated
        UPDATE POS_EFTPayments
        SET LedgerUpdated = 1
        WHERE EFTPaymentID = @EFTPaymentID
        
        COMMIT TRANSACTION
        
        SELECT 'Success' AS Result, 'EFT Payment marked as Reflected and ledger updated' AS Message
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END
GO

-- =============================================
-- Stored Procedure: Get Pending EFT Payments
-- =============================================
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_GetPendingEFTPayments')
    DROP PROCEDURE sp_GetPendingEFTPayments
GO

CREATE PROCEDURE sp_GetPendingEFTPayments
    @BranchID INT = NULL, -- NULL = All branches
    @Status NVARCHAR(20) = 'Pending' -- 'Pending', 'Reflected', 'All'
AS
BEGIN
    SET NOCOUNT ON
    
    SELECT 
        EFTPaymentID,
        PaymentReference,
        TransactionType,
        TransactionID,
        InvoiceNumber,
        OrderNumber,
        BranchID,
        BranchName,
        TillPointID,
        CashierID,
        CashierName,
        Amount,
        PaymentDate,
        PaymentTime,
        CustomerName,
        CustomerSurname,
        CustomerCell,
        Status,
        ReflectedDate,
        ReflectedBy,
        ProofOfPaymentPath,
        BankName,
        AccountNumber,
        BranchCode,
        JournalEntryID,
        LedgerUpdated,
        Notes,
        CreatedDate,
        ModifiedDate,
        DATEDIFF(DAY, PaymentDate, GETDATE()) AS DaysOutstanding
    FROM POS_EFTPayments
    WHERE 
        (@BranchID IS NULL OR BranchID = @BranchID)
        AND (@Status = 'All' OR Status = @Status)
    ORDER BY PaymentDate DESC
END
GO

PRINT 'EFT Payments tracking system created successfully'
PRINT 'Tables: POS_EFTPayments'
PRINT 'Stored Procedures: sp_RecordEFTPayment, sp_MarkEFTPaymentReflected, sp_GetPendingEFTPayments'
