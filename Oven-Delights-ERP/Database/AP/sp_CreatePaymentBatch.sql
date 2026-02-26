-- =============================================
-- sp_CreatePaymentBatch - Create a new payment batch
-- =============================================
CREATE OR ALTER PROCEDURE sp_CreatePaymentBatch
    @PaymentDate DATE,
    @PaymentMethod NVARCHAR(50),
    @BankAccountID INT,
    @Notes NVARCHAR(MAX) = NULL,
    @CreatedBy NVARCHAR(100),
    @BatchNumber NVARCHAR(50) OUTPUT,
    @BatchID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Generate batch number
        DECLARE @NextNumber INT;
        SELECT @NextNumber = ISNULL(MAX(CAST(SUBSTRING(BatchNumber, 7, LEN(BatchNumber)) AS INT)), 0) + 1
        FROM PaymentBatches
        WHERE BatchNumber LIKE 'BATCH-%';
        
        SET @BatchNumber = 'BATCH-' + CAST(YEAR(GETDATE()) AS VARCHAR) + '-' + RIGHT('000' + CAST(@NextNumber AS VARCHAR), 3);
        
        -- Insert batch record (matching actual PaymentBatches table structure)
        INSERT INTO PaymentBatches (
            BatchNumber,
            BatchDate,
            TotalAmount,
            TotalPayments,
            Status,
            PaymentType,
            Notes,
            CreatedBy,
            CreatedDate
        )
        VALUES (
            @BatchNumber,
            @PaymentDate,
            0, -- Will be updated when items are added
            0, -- Will be updated when items are added
            'Draft',
            'Supplier', -- Default payment type
            @Notes,
            @CreatedBy,
            GETDATE()
        );
        
        SET @BatchID = SCOPE_IDENTITY();
        
        COMMIT TRANSACTION;
        
        SELECT 'SUCCESS' AS Result, @BatchID AS BatchID, @BatchNumber AS BatchNumber;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

PRINT 'sp_CreatePaymentBatch created successfully'
GO
