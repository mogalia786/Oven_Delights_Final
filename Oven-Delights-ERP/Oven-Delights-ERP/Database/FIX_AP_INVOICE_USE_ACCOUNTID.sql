-- =============================================
-- Fix AP Invoice to use AccountID from ChartOfAccounts
-- instead of CategoryID from AP_Categories
-- =============================================

-- 1. Add AccountID column to AP_Invoices table if it doesn't exist
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'AP_Invoices' AND COLUMN_NAME = 'AccountID')
BEGIN
    ALTER TABLE AP_Invoices ADD AccountID INT NULL
    PRINT 'Added AccountID column to AP_Invoices'
END
ELSE
BEGIN
    PRINT 'AccountID column already exists in AP_Invoices'
END
GO

-- 2. Update existing invoices to set AccountID from CategoryID mapping
-- (This assumes AP_Categories has GLAccountCode that matches ChartOfAccounts.AccountCode)
UPDATE ai
SET ai.AccountID = coa.AccountID
FROM AP_Invoices ai
INNER JOIN AP_Categories cat ON ai.CategoryID = cat.CategoryID
INNER JOIN ChartOfAccounts coa ON cat.GLAccountCode = coa.AccountCode
WHERE ai.AccountID IS NULL
GO

-- 3. Recreate sp_AP_CreateInvoice to use AccountID instead of CategoryID
IF OBJECT_ID('sp_AP_CreateInvoice', 'P') IS NOT NULL
    DROP PROCEDURE sp_AP_CreateInvoice
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE sp_AP_CreateInvoice
    @InvoiceNumber NVARCHAR(50),
    @BeneficiaryID INT,
    @CategoryID INT,  -- Keep for backward compatibility, but use AccountID instead
    @InvoiceDate DATE,
    @DueDate DATE,
    @Amount DECIMAL(18,2),
    @TaxAmount DECIMAL(18,2) = 0,
    @Description NVARCHAR(500) = NULL,
    @Reference NVARCHAR(100) = NULL,
    @BranchID INT = 1,
    @CreatedBy NVARCHAR(100),
    @InvoiceID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Use CategoryID as AccountID (since we're now passing AccountID from ChartOfAccounts)
    DECLARE @ActualAccountID INT = @CategoryID

    INSERT INTO AP_Invoices (
        InvoiceNumber, BeneficiaryID, CategoryID, AccountID, InvoiceDate, DueDate,
        Amount, TaxAmount, Description, Reference, BranchID, Status, CreatedBy, CreatedDate
    )
    VALUES (
        @InvoiceNumber, @BeneficiaryID, @CategoryID, @ActualAccountID, @InvoiceDate, @DueDate,
        @Amount, @TaxAmount, @Description, @Reference, @BranchID, 'Pending', @CreatedBy, GETDATE()
    )

    SET @InvoiceID = SCOPE_IDENTITY()

    SELECT @InvoiceID AS InvoiceID
END
GO

PRINT 'sp_AP_CreateInvoice updated successfully'
GO
