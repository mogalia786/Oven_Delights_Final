-- =============================================
-- sp_SyncSupplierInvoicesToAP
-- Syncs SupplierInvoices from Stockroom to AP_Invoices for batch payment processing
-- Also creates/updates AP_Beneficiaries from Suppliers table
-- =============================================

CREATE OR ALTER PROCEDURE sp_SyncSupplierInvoicesToAP
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @SyncCount INT = 0
    DECLARE @BeneficiaryCount INT = 0
    DECLARE @DefaultCategoryID INT
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Get or create default category for supplier invoices
        IF NOT EXISTS (SELECT 1 FROM AP_Categories WHERE CategoryName = 'Supplier Invoice')
        BEGIN
            INSERT INTO AP_Categories (CategoryName, Description, IsActive, CreatedDate)
            VALUES ('Supplier Invoice', 'Invoices from suppliers captured via GRV', 1, GETDATE())
        END
        
        SELECT @DefaultCategoryID = CategoryID 
        FROM AP_Categories 
        WHERE CategoryName = 'Supplier Invoice'
        
        -- Step 1: Sync Suppliers to AP_Beneficiaries
        -- Create beneficiaries for suppliers that don't exist yet
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
        FROM Suppliers s
        WHERE NOT EXISTS (
            SELECT 1 
            FROM AP_Beneficiaries b 
            WHERE b.BeneficiaryName = s.CompanyName
        )
        AND s.IsActive = 1
        
        SET @BeneficiaryCount = @@ROWCOUNT
        
        -- Step 2: Sync SupplierInvoices to AP_Invoices
        -- Use MERGE to handle both new and existing invoices
        -- Use ROW_NUMBER to handle duplicate invoice numbers (only sync first occurrence)
        MERGE AP_Invoices AS target
        USING (
            SELECT 
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
            FROM (
                SELECT 
                    si.InvoiceNumber,
                    si.InvoiceDate,
                    ISNULL(si.DueDate, DATEADD(DAY, 30, si.InvoiceDate)) AS DueDate,
                    b.BeneficiaryID,
                    @DefaultCategoryID AS CategoryID,
                    si.SubTotal AS Amount,
                    si.VATAmount AS TaxAmount,
                    CASE 
                        WHEN si.Status = 'Paid' THEN 'Paid'
                        WHEN ISNULL(si.DueDate, DATEADD(DAY, 30, si.InvoiceDate)) < GETDATE() THEN 'Overdue'
                        ELSE 'Pending'
                    END AS Status,
                    'Synced from Stockroom GRV' AS Description,
                    si.InvoiceNumber AS Reference,
                    ISNULL(si.CreatedBy, 0) AS CreatedBy,
                    ISNULL(si.CreatedDate, GETDATE()) AS CreatedDate,
                    ROW_NUMBER() OVER (PARTITION BY si.InvoiceNumber ORDER BY si.InvoiceDate DESC) AS RowNum
                FROM SupplierInvoices si
                INNER JOIN Suppliers s ON si.SupplierID = s.SupplierID
                INNER JOIN AP_Beneficiaries b ON b.BeneficiaryName = s.CompanyName
                WHERE si.Status IN ('Unpaid', 'PartiallyPaid')
            ) AS ranked
            WHERE RowNum = 1
        ) AS source
        ON target.InvoiceNumber = source.InvoiceNumber
        WHEN MATCHED THEN
            UPDATE SET
                target.InvoiceDate = source.InvoiceDate,
                target.DueDate = source.DueDate,
                target.Amount = source.Amount,
                target.TaxAmount = source.TaxAmount,
                target.Status = source.Status
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (InvoiceNumber, InvoiceDate, DueDate, BeneficiaryID, CategoryID, 
                    Amount, TaxAmount, Status, Description, Reference, CreatedBy, CreatedDate)
            VALUES (source.InvoiceNumber, source.InvoiceDate, source.DueDate, source.BeneficiaryID, 
                    source.CategoryID, source.Amount, source.TaxAmount, source.Status, 
                    source.Description, source.Reference, source.CreatedBy, source.CreatedDate);
        
        SET @SyncCount = @@ROWCOUNT
        
        COMMIT TRANSACTION
        
        -- Return summary
        SELECT 
            @BeneficiaryCount AS BeneficiariesCreated,
            @SyncCount AS InvoicesSynced,
            'Success' AS Status,
            'Supplier invoices synced to AP system successfully' AS Message
            
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END
GO

PRINT 'sp_SyncSupplierInvoicesToAP created successfully'
PRINT ''
PRINT 'USAGE:'
PRINT '  EXEC sp_SyncSupplierInvoicesToAP'
PRINT ''
PRINT 'This procedure will:'
PRINT '  1. Create AP_Beneficiaries from Suppliers table (if not exists)'
PRINT '  2. Sync unpaid SupplierInvoices to AP_Invoices table'
PRINT '  3. Skip invoices that are already synced (by InvoiceNumber + BeneficiaryID)'
PRINT '  4. Only sync unpaid/partially paid invoices'
PRINT ''
