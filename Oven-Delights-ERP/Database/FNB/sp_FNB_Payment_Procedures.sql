-- =============================================
-- FNB Payment Execution API - Stored Procedures
-- =============================================

SET NOCOUNT ON;
GO

-- =============================================
-- sp_FNB_CreatePaymentBatch
-- Creates a new payment batch record
-- =============================================
IF OBJECT_ID('dbo.sp_FNB_CreatePaymentBatch', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_FNB_CreatePaymentBatch;
GO

CREATE PROCEDURE dbo.sp_FNB_CreatePaymentBatch
    @MessageID NVARCHAR(50),
    @TotalNumberOfTransactions INT,
    @TotalControlSum DECIMAL(18,2),
    @RequestedExecutionDate DATE,
    @ServiceLevelCode NVARCHAR(10) = 'SDVA',
    @DebtorAccountNumber NVARCHAR(23),
    @BranchID INT,
    @CreatedBy INT,
    @APIRequestJSON NVARCHAR(MAX) = NULL,
    @BatchID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        INSERT INTO dbo.FNB_PaymentBatches (
            MessageID,
            TotalNumberOfTransactions,
            TotalControlSum,
            RequestedExecutionDate,
            ServiceLevelCode,
            DebtorAccountNumber,
            BranchID,
            CreatedBy,
            APIRequestJSON,
            BatchStatus
        )
        VALUES (
            @MessageID,
            @TotalNumberOfTransactions,
            @TotalControlSum,
            @RequestedExecutionDate,
            @ServiceLevelCode,
            @DebtorAccountNumber,
            @BranchID,
            @CreatedBy,
            @APIRequestJSON,
            'Pending'
        );
        
        SET @BatchID = SCOPE_IDENTITY();
        
        SELECT 'SUCCESS' AS Result, @BatchID AS BatchID;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Result, ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END
GO

-- =============================================
-- sp_FNB_AddPaymentTransaction
-- Adds a transaction to a payment batch
-- =============================================
IF OBJECT_ID('dbo.sp_FNB_AddPaymentTransaction', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_FNB_AddPaymentTransaction;
GO

CREATE PROCEDURE dbo.sp_FNB_AddPaymentTransaction
    @BatchID INT,
    @EndToEndID NVARCHAR(50),
    @Amount DECIMAL(18,2),
    @CreditorName NVARCHAR(100),
    @CreditorAccountNumber NVARCHAR(23),
    @CreditorAccountType NVARCHAR(10) = 'CACC',
    @CreditorBranchID NVARCHAR(10),
    @CreditorBIC NVARCHAR(20) = 'FIRNZAJJ',
    @RemittanceReference NVARCHAR(30),
    @ProofOfPaymentEmail NVARCHAR(100) = NULL,
    @SupplierID INT = NULL,
    @PurchaseInvoiceID INT = NULL,
    @ExpenseBillID INT = NULL,
    @PaymentType NVARCHAR(20) = 'Supplier',
    @PaymentTransactionID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Truncate remittance reference to 20 chars (FNB limitation)
        DECLARE @RemittanceReference20 NVARCHAR(20);
        SET @RemittanceReference20 = LEFT(@RemittanceReference, 20);
        
        INSERT INTO dbo.FNB_PaymentTransactions (
            BatchID,
            EndToEndID,
            Amount,
            CreditorName,
            CreditorAccountNumber,
            CreditorAccountType,
            CreditorBranchID,
            CreditorBIC,
            RemittanceReference,
            RemittanceReference20,
            ProofOfPaymentEmail,
            SupplierID,
            PurchaseInvoiceID,
            ExpenseBillID,
            PaymentType,
            TransactionStatus
        )
        VALUES (
            @BatchID,
            @EndToEndID,
            @Amount,
            @CreditorName,
            @CreditorAccountNumber,
            @CreditorAccountType,
            @CreditorBranchID,
            @CreditorBIC,
            @RemittanceReference,
            @RemittanceReference20,
            @ProofOfPaymentEmail,
            @SupplierID,
            @PurchaseInvoiceID,
            @ExpenseBillID,
            @PaymentType,
            'Pending'
        );
        
        SET @PaymentTransactionID = SCOPE_IDENTITY();
        
        SELECT 'SUCCESS' AS Result, @PaymentTransactionID AS PaymentTransactionID;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Result, ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END
GO

-- =============================================
-- sp_FNB_UpdateBatchStatus
-- Updates batch status after API submission or status check
-- =============================================
IF OBJECT_ID('dbo.sp_FNB_UpdateBatchStatus', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_FNB_UpdateBatchStatus;
GO

CREATE PROCEDURE dbo.sp_FNB_UpdateBatchStatus
    @BatchID INT,
    @InstructionID NVARCHAR(200) = NULL,
    @BatchStatus NVARCHAR(20),
    @RejectionReason NVARCHAR(MAX) = NULL,
    @APIResponseJSON NVARCHAR(MAX) = NULL,
    @CheckedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        DECLARE @OldStatus NVARCHAR(20);
        
        SELECT @OldStatus = BatchStatus
        FROM dbo.FNB_PaymentBatches
        WHERE BatchID = @BatchID;
        
        UPDATE dbo.FNB_PaymentBatches
        SET InstructionID = COALESCE(@InstructionID, InstructionID),
            BatchStatus = @BatchStatus,
            StatusCheckedDate = GETDATE(),
            RejectionReason = @RejectionReason,
            APIResponseJSON = COALESCE(@APIResponseJSON, APIResponseJSON),
            SubmittedDate = CASE WHEN @InstructionID IS NOT NULL AND SubmittedDate IS NULL THEN GETDATE() ELSE SubmittedDate END,
            CompletedDate = CASE WHEN @BatchStatus IN ('ACSC', 'RJCT') THEN GETDATE() ELSE CompletedDate END
        WHERE BatchID = @BatchID;
        
        -- Log status change
        INSERT INTO dbo.FNB_PaymentStatusLog (
            BatchID,
            PreviousStatus,
            NewStatus,
            StatusDetails,
            CheckedBy
        )
        VALUES (
            @BatchID,
            @OldStatus,
            @BatchStatus,
            @RejectionReason,
            @CheckedBy
        );
        
        SELECT 'SUCCESS' AS Result;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Result, ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END
GO

-- =============================================
-- sp_FNB_UpdateTransactionStatus
-- Updates individual transaction status
-- =============================================
IF OBJECT_ID('dbo.sp_FNB_UpdateTransactionStatus', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_FNB_UpdateTransactionStatus;
GO

CREATE PROCEDURE dbo.sp_FNB_UpdateTransactionStatus
    @PaymentTransactionID INT,
    @TransactionStatus NVARCHAR(20),
    @RejectionReasonCode NVARCHAR(10) = NULL,
    @RejectionReasonText NVARCHAR(500) = NULL,
    @CheckedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        DECLARE @OldStatus NVARCHAR(20);
        
        SELECT @OldStatus = TransactionStatus
        FROM dbo.FNB_PaymentTransactions
        WHERE PaymentTransactionID = @PaymentTransactionID;
        
        UPDATE dbo.FNB_PaymentTransactions
        SET TransactionStatus = @TransactionStatus,
            StatusCheckedDate = GETDATE(),
            RejectionReasonCode = @RejectionReasonCode,
            RejectionReasonText = @RejectionReasonText,
            ProcessedDate = CASE WHEN @TransactionStatus IN ('ACCC', 'RJCT') THEN GETDATE() ELSE ProcessedDate END
        WHERE PaymentTransactionID = @PaymentTransactionID;
        
        -- Log status change
        INSERT INTO dbo.FNB_PaymentStatusLog (
            PaymentTransactionID,
            PreviousStatus,
            NewStatus,
            StatusDetails,
            CheckedBy
        )
        VALUES (
            @PaymentTransactionID,
            @OldStatus,
            @TransactionStatus,
            COALESCE(@RejectionReasonText, ''),
            @CheckedBy
        );
        
        SELECT 'SUCCESS' AS Result;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Result, ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END
GO

-- =============================================
-- sp_FNB_GetPendingBatches
-- Retrieves batches pending status check
-- =============================================
IF OBJECT_ID('dbo.sp_FNB_GetPendingBatches', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_FNB_GetPendingBatches;
GO

CREATE PROCEDURE dbo.sp_FNB_GetPendingBatches
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        BatchID,
        MessageID,
        InstructionID,
        BatchStatus,
        TotalNumberOfTransactions,
        TotalControlSum,
        RequestedExecutionDate,
        SubmittedDate,
        StatusCheckedDate
    FROM dbo.FNB_PaymentBatches
    WHERE BatchStatus IN ('ACCP', 'PDNG', 'Pending')
      AND InstructionID IS NOT NULL
    ORDER BY SubmittedDate DESC;
END
GO

-- =============================================
-- sp_FNB_GetBatchTransactions
-- Retrieves all transactions for a batch
-- =============================================
IF OBJECT_ID('dbo.sp_FNB_GetBatchTransactions', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_FNB_GetBatchTransactions;
GO

CREATE PROCEDURE dbo.sp_FNB_GetBatchTransactions
    @BatchID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        pt.PaymentTransactionID,
        pt.EndToEndID,
        pt.Amount,
        pt.CreditorName,
        pt.CreditorAccountNumber,
        pt.TransactionStatus,
        pt.RejectionReasonCode,
        pt.RejectionReasonText,
        pt.SupplierID,
        s.CompanyName AS SupplierName,
        pt.PaymentType,
        pt.IsPosted,
        pt.JournalID,
        pt.CreatedDate,
        pt.ProcessedDate
    FROM dbo.FNB_PaymentTransactions pt
    LEFT JOIN dbo.Suppliers s ON pt.SupplierID = s.SupplierID
    WHERE pt.BatchID = @BatchID
    ORDER BY pt.PaymentTransactionID;
END
GO

-- =============================================
-- sp_FNB_GetPaymentHistory
-- Retrieves payment history with filters
-- =============================================
IF OBJECT_ID('dbo.sp_FNB_GetPaymentHistory', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_FNB_GetPaymentHistory;
GO

CREATE PROCEDURE dbo.sp_FNB_GetPaymentHistory
    @FromDate DATE = NULL,
    @ToDate DATE = NULL,
    @BatchStatus NVARCHAR(20) = NULL,
    @SupplierID INT = NULL,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        pb.BatchID,
        pb.MessageID,
        pb.InstructionID,
        pb.BatchStatus,
        pb.TotalNumberOfTransactions,
        pb.TotalControlSum,
        pb.RequestedExecutionDate,
        pb.ServiceLevelCode,
        pb.DebtorAccountNumber,
        pb.CreatedDate,
        pb.SubmittedDate,
        pb.CompletedDate,
        pb.RejectionReason,
        b.BranchName,
        u.Username AS CreatedByUser,
        (SELECT COUNT(*) FROM dbo.FNB_PaymentTransactions WHERE BatchID = pb.BatchID AND TransactionStatus = 'ACCC') AS SuccessfulCount,
        (SELECT COUNT(*) FROM dbo.FNB_PaymentTransactions WHERE BatchID = pb.BatchID AND TransactionStatus = 'RJCT') AS RejectedCount
    FROM dbo.FNB_PaymentBatches pb
    LEFT JOIN dbo.Branches b ON pb.BranchID = b.BranchID
    LEFT JOIN dbo.Users u ON pb.CreatedBy = u.UserID
    WHERE (@FromDate IS NULL OR pb.CreatedDate >= @FromDate)
      AND (@ToDate IS NULL OR pb.CreatedDate <= DATEADD(DAY, 1, @ToDate))
      AND (@BatchStatus IS NULL OR pb.BatchStatus = @BatchStatus)
      AND (@BranchID IS NULL OR pb.BranchID = @BranchID)
      AND (@SupplierID IS NULL OR EXISTS (
          SELECT 1 FROM dbo.FNB_PaymentTransactions 
          WHERE BatchID = pb.BatchID AND SupplierID = @SupplierID
      ))
    ORDER BY pb.CreatedDate DESC;
END
GO

-- =============================================
-- sp_FNB_GetTransactionDetails
-- Retrieves detailed transaction information
-- =============================================
IF OBJECT_ID('dbo.sp_FNB_GetTransactionDetails', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_FNB_GetTransactionDetails;
GO

CREATE PROCEDURE dbo.sp_FNB_GetTransactionDetails
    @PaymentTransactionID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        pt.*,
        pb.MessageID,
        pb.InstructionID,
        pb.BatchStatus,
        pb.RequestedExecutionDate,
        pb.DebtorAccountNumber,
        s.CompanyName AS SupplierName,
        s.Email AS SupplierEmail,
        s.Phone AS SupplierPhone
    FROM dbo.FNB_PaymentTransactions pt
    INNER JOIN dbo.FNB_PaymentBatches pb ON pt.BatchID = pb.BatchID
    LEFT JOIN dbo.Suppliers s ON pt.SupplierID = s.SupplierID
    WHERE pt.PaymentTransactionID = @PaymentTransactionID;
    
    -- Get status history
    SELECT 
        LogID,
        StatusCheckDateTime,
        PreviousStatus,
        NewStatus,
        StatusDetails,
        u.Username AS CheckedByUser
    FROM dbo.FNB_PaymentStatusLog psl
    LEFT JOIN dbo.Users u ON psl.CheckedBy = u.UserID
    WHERE PaymentTransactionID = @PaymentTransactionID
    ORDER BY StatusCheckDateTime DESC;
END
GO

-- =============================================
-- sp_FNB_MarkTransactionPosted
-- Marks transaction as posted to journals
-- =============================================
IF OBJECT_ID('dbo.sp_FNB_MarkTransactionPosted', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_FNB_MarkTransactionPosted;
GO

CREATE PROCEDURE dbo.sp_FNB_MarkTransactionPosted
    @PaymentTransactionID INT,
    @JournalID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        UPDATE dbo.FNB_PaymentTransactions
        SET IsPosted = 1,
            PostedDate = GETDATE(),
            JournalID = @JournalID
        WHERE PaymentTransactionID = @PaymentTransactionID;
        
        SELECT 'SUCCESS' AS Result;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Result, ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END
GO

-- =============================================
-- sp_FNB_GetAPICredentials
-- Retrieves active API credentials for environment
-- =============================================
IF OBJECT_ID('dbo.sp_FNB_GetAPICredentials', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_FNB_GetAPICredentials;
GO

CREATE PROCEDURE dbo.sp_FNB_GetAPICredentials
    @Environment NVARCHAR(20) = 'Sandbox'
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP 1
        CredentialID,
        Environment,
        ClientID,
        ClientSecret,
        BaseURL,
        TokenURL,
        DebtorAccountNumber,
        DebtorBranchID,
        IsActive,
        IsSandbox
    FROM dbo.FNB_APICredentials
    WHERE Environment = @Environment
      AND IsActive = 1
    ORDER BY CredentialID DESC;
END
GO

PRINT '';
PRINT '==============================================';
PRINT 'FNB Payment stored procedures created successfully';
PRINT '==============================================';
GO
