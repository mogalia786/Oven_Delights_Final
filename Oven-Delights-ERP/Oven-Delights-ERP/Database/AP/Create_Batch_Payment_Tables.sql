-- =============================================
-- Create Batch Payment Infrastructure
-- Links AP_Invoices to FNB_PaymentBatches
-- =============================================

-- Table to track which invoices are in which FNB batch
IF OBJECT_ID('dbo.AP_InvoiceBatchMapping', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.AP_InvoiceBatchMapping (
        MappingID INT IDENTITY(1,1) PRIMARY KEY,
        InvoiceID INT NOT NULL,
        FNB_BatchID INT NOT NULL,
        FNB_TransactionID INT NULL,
        AmountPaid DECIMAL(18,2) NOT NULL,
        AddedDate DATETIME DEFAULT GETDATE(),
        AddedBy INT NOT NULL,
        INDEX IX_InvoiceID (InvoiceID),
        INDEX IX_FNB_BatchID (FNB_BatchID)
    )
    PRINT 'Created table: AP_InvoiceBatchMapping'
END
ELSE
    PRINT 'Table already exists: AP_InvoiceBatchMapping'
GO

-- Stored procedure to add invoice to FNB batch
CREATE OR ALTER PROCEDURE sp_AddInvoiceToFNBBatch
    @FNB_BatchID INT,
    @InvoiceID INT,
    @AmountToPay DECIMAL(18,2),
    @AddedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if invoice already in this batch
    IF EXISTS (SELECT 1 FROM AP_InvoiceBatchMapping WHERE InvoiceID = @InvoiceID AND FNB_BatchID = @FNB_BatchID)
    BEGIN
        RAISERROR('Invoice already in this batch', 16, 1)
        RETURN
    END
    
    -- Add mapping
    INSERT INTO AP_InvoiceBatchMapping (InvoiceID, FNB_BatchID, AmountPaid, AddedBy)
    VALUES (@InvoiceID, @FNB_BatchID, @AmountToPay, @AddedBy)
    
    SELECT SCOPE_IDENTITY() AS MappingID
END
GO

PRINT 'Created stored procedure: sp_AddInvoiceToFNBBatch'
GO
