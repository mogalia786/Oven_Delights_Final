-- =============================================
-- Stored Procedure: sp_GeneratePaymentReference
-- Purpose: Generate unique payment reference numbers
-- Format: SUP-YYYY-NNNNNN or BEN-YYYY-NNNNNN
-- =============================================
-- NOTE: Connect to OvenDelightsERP database before executing
-- GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GeneratePaymentReference]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_GeneratePaymentReference]
GO

CREATE PROCEDURE [dbo].[sp_GeneratePaymentReference]
    @PaymentType NVARCHAR(20), -- 'Supplier' or 'Beneficiary'
    @PaymentReference NVARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Year NVARCHAR(4) = CAST(YEAR(GETDATE()) AS NVARCHAR(4))
    DECLARE @Prefix NVARCHAR(10)
    DECLARE @NextNumber INT
    DECLARE @RefNumber NVARCHAR(10)
    
    -- Determine prefix
    IF @PaymentType = 'Supplier'
        SET @Prefix = 'SUP'
    ELSE IF @PaymentType = 'Beneficiary'
        SET @Prefix = 'BEN'
    ELSE
    BEGIN
        RAISERROR('Invalid payment type. Must be Supplier or Beneficiary', 16, 1)
        RETURN
    END
    
    -- Get next sequential number for this year and type
    IF @PaymentType = 'Supplier'
    BEGIN
        SELECT @NextNumber = ISNULL(MAX(
            CAST(RIGHT(PaymentReference, 6) AS INT)
        ), 0) + 1
        FROM SupplierInvoices
        WHERE PaymentReference LIKE @Prefix + '-' + @Year + '-%'
    END
    ELSE
    BEGIN
        SELECT @NextNumber = ISNULL(MAX(
            CAST(RIGHT(PaymentReference, 6) AS INT)
        ), 0) + 1
        FROM BeneficiaryPayments
        WHERE PaymentReference LIKE @Prefix + '-' + @Year + '-%'
    END
    
    -- Format: SUP-2026-000001 or BEN-2026-000001
    SET @RefNumber = RIGHT('000000' + CAST(@NextNumber AS NVARCHAR), 6)
    SET @PaymentReference = @Prefix + '-' + @Year + '-' + @RefNumber
    
END
GO

PRINT 'sp_GeneratePaymentReference created successfully'
GO
