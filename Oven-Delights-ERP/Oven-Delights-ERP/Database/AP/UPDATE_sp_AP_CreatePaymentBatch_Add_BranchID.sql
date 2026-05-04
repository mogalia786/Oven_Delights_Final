-- =============================================
-- Update sp_AP_CreatePaymentBatch to support BranchID
-- =============================================

SET NOCOUNT ON;
GO

PRINT 'Updating sp_AP_CreatePaymentBatch to add BranchID parameter...';
GO

CREATE OR ALTER PROCEDURE sp_AP_CreatePaymentBatch
    @InvoiceIDs NVARCHAR(MAX), -- Comma-separated list
    @CreatedBy NVARCHAR(100),
    @BranchID INT = NULL,
    @BatchID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Generate batch number
        DECLARE @BatchNumber NVARCHAR(50) = 'APB' + FORMAT(GETDATE(), 'yyyyMMddHHmmss')
        
        -- Get BranchID from first invoice if not provided
        IF @BranchID IS NULL AND @InvoiceIDs IS NOT NULL AND @InvoiceIDs <> ''
        BEGIN
            SELECT TOP 1 @BranchID = BranchID
            FROM AP_Invoices
            WHERE InvoiceID IN (SELECT value FROM STRING_SPLIT(@InvoiceIDs, ','))
        END
        
        -- Calculate totals
        DECLARE @TotalAmount DECIMAL(18,2) = 0
        DECLARE @TotalInvoices INT = 0
        
        IF @InvoiceIDs IS NOT NULL AND @InvoiceIDs <> ''
        BEGIN
            SELECT 
                @TotalAmount = ISNULL(SUM(TotalAmount), 0),
                @TotalInvoices = COUNT(*)
            FROM AP_Invoices
            WHERE InvoiceID IN (SELECT value FROM STRING_SPLIT(@InvoiceIDs, ','))
                AND Status = 'Pending'
        END
        
        -- Create batch
        INSERT INTO AP_PaymentBatches (
            BatchNumber, BatchDate, TotalInvoices, TotalAmount, 
            BranchID, Status, CreatedBy, CreatedDate
        )
        VALUES (
            @BatchNumber, GETDATE(), @TotalInvoices, @TotalAmount,
            @BranchID, 'Pending', @CreatedBy, GETDATE()
        )
        
        SET @BatchID = SCOPE_IDENTITY()
        
        -- Add batch items only if invoices provided
        IF @InvoiceIDs IS NOT NULL AND @InvoiceIDs <> ''
        BEGIN
            INSERT INTO AP_PaymentBatchItems (BatchID, InvoiceID, Amount, CreatedDate)
            SELECT 
                @BatchID,
                InvoiceID,
                TotalAmount,
                GETDATE()
            FROM AP_Invoices
            WHERE InvoiceID IN (SELECT value FROM STRING_SPLIT(@InvoiceIDs, ','))
                AND Status = 'Pending'
        END
        
        COMMIT TRANSACTION;
        
        SELECT @BatchID AS BatchID, @BatchNumber AS BatchNumber
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT 'sp_AP_CreatePaymentBatch updated successfully with BranchID support';
GO

PRINT '';
PRINT 'Script completed successfully!';
GO
