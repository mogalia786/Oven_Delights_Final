-- =============================================
-- Fix trg_SyncSupplierInvoiceToAP trigger
-- Add SET QUOTED_IDENTIFIER ON and SET ANSI_NULLS ON
-- =============================================

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

PRINT 'Fixing trg_SyncSupplierInvoiceToAP trigger...'

-- Drop trigger if exists
IF OBJECT_ID('trg_SyncSupplierInvoiceToAP', 'TR') IS NOT NULL
BEGIN
    DROP TRIGGER trg_SyncSupplierInvoiceToAP
    PRINT 'Dropped existing trigger'
END
GO

-- Recreate trigger with correct settings
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE TRIGGER trg_SyncSupplierInvoiceToAP
ON SupplierInvoices
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    SET QUOTED_IDENTIFIER ON;
    SET ANSI_NULLS ON;
    
    DECLARE @DefaultCategoryID INT
    
    -- Get or create default category
    IF NOT EXISTS (SELECT 1 FROM AP_Categories WHERE CategoryName = 'Supplier Invoice')
    BEGIN
        INSERT INTO AP_Categories (CategoryName, Description, IsActive, CreatedDate)
        VALUES ('Supplier Invoice', 'Invoices from suppliers captured via GRV', 1, GETDATE())
    END
    
    SELECT @DefaultCategoryID = CategoryID 
    FROM AP_Categories 
    WHERE CategoryName = 'Supplier Invoice'
    
    -- Ensure beneficiary exists for this supplier
    INSERT INTO AP_Beneficiaries (
        BeneficiaryName,
        BeneficiaryType,
        TaxNumber,
        Email,
        Phone,
        IsActive,
        CreatedDate
    )
    SELECT DISTINCT
        s.CompanyName,
        'Supplier',
        s.VATNumber,
        s.Email,
        s.Phone,
        s.IsActive,
        GETDATE()
    FROM inserted i
    INNER JOIN Suppliers s ON i.SupplierID = s.SupplierID
    WHERE NOT EXISTS (
        SELECT 1 
        FROM AP_Beneficiaries b 
        WHERE b.BeneficiaryName = s.CompanyName
    )
    
    -- Sync the new invoice to AP_Invoices
    INSERT INTO AP_Invoices (
        InvoiceNumber,
        InvoiceDate,
        DueDate,
        BeneficiaryID,
        CategoryID,
        Amount,
        TaxAmount,
        Status,
        Description,
        Reference,
        CreatedBy,
        CreatedDate
    )
    SELECT 
        i.InvoiceNumber,
        i.InvoiceDate,
        ISNULL(i.DueDate, DATEADD(DAY, 30, i.InvoiceDate)),
        b.BeneficiaryID,
        @DefaultCategoryID,
        i.SubTotal,
        i.VATAmount,
        CASE 
            WHEN i.Status = 'Paid' THEN 'Paid'
            WHEN ISNULL(i.DueDate, DATEADD(DAY, 30, i.InvoiceDate)) < GETDATE() THEN 'Overdue'
            ELSE 'Pending'
        END,
        'Auto-synced from Stockroom GRV',
        i.InvoiceNumber,
        ISNULL(i.CreatedBy, 0),
        ISNULL(i.CreatedDate, GETDATE())
    FROM inserted i
    INNER JOIN Suppliers s ON i.SupplierID = s.SupplierID
    INNER JOIN AP_Beneficiaries b ON b.BeneficiaryName = s.CompanyName
    WHERE NOT EXISTS (
        SELECT 1 
        FROM AP_Invoices ai 
        WHERE ai.InvoiceNumber = i.InvoiceNumber
          AND ai.BeneficiaryID = b.BeneficiaryID
    )
    AND i.Status IN ('Unpaid', 'PartiallyPaid')
END
GO

PRINT 'Trigger trg_SyncSupplierInvoiceToAP recreated successfully with QUOTED_IDENTIFIER ON'
PRINT 'Supplier invoice capture should now work without errors'
