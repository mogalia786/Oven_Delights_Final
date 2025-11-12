-- =============================================
-- FIX GRN LINES TABLE FOR INVOICE CAPTURE
-- =============================================

-- Add missing columns to GRNLines table
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('GRNLines') AND name = 'ProductID')
BEGIN
    ALTER TABLE GRNLines ADD ProductID INT NULL;
    PRINT '✅ Added ProductID to GRNLines';
    
    -- If MaterialID exists, copy values to ProductID for existing records
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('GRNLines') AND name = 'MaterialID')
    BEGIN
        UPDATE GRNLines SET ProductID = MaterialID WHERE ProductID IS NULL;
        PRINT '✅ Copied existing MaterialID values to ProductID in GRNLines';
    END
END
GO

-- Add any other missing columns that might be needed
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('GRNLines') AND name = 'ProductType')
BEGIN
    ALTER TABLE GRNLines ADD ProductType NVARCHAR(50) NULL;
    PRINT '✅ Added ProductType to GRNLines';
END
GO

-- Make sure the foreign key to Products exists
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_GRNLines_Products')
BEGIN
    ALTER TABLE GRNLines
    ADD CONSTRAINT FK_GRNLines_Products FOREIGN KEY (ProductID) 
    REFERENCES Products(ProductID);
    PRINT '✅ Added foreign key constraint FK_GRNLines_Products';
END
GO

-- Update the stored procedure to use the correct column names
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_GRN_Create')
BEGIN
    DROP PROCEDURE sp_GRN_Create;
    PRINT 'Dropped old version of sp_GRN_Create';
END
GO

CREATE PROCEDURE sp_GRN_Create
    @SupplierID INT,
    @PurchaseOrderID INT,
    @BranchID INT,
    @GRNNumber NVARCHAR(50),
    @DeliveryNoteNumber NVARCHAR(100),
    @ReceivedDate DATETIME,
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @GRNID INT;
    
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Insert GRN header
        INSERT INTO GoodsReceivedNotes (
            SupplierID, 
            PurchaseOrderID, 
            BranchID, 
            GRNNumber, 
            DeliveryNoteNumber, 
            ReceivedDate, 
            Status, 
            CreatedDate, 
            CreatedBy
        )
        VALUES (
            @SupplierID,
            @PurchaseOrderID,
            @BranchID,
            @GRNNumber,
            @DeliveryNoteNumber,
            @ReceivedDate,
            'Completed',
            GETDATE(),
            @CreatedBy
        );
        
        SET @GRNID = SCOPE_IDENTITY();
        
        -- Update the PO status to 'Received' if all items are received
        UPDATE PurchaseOrders
        SET Status = 'Received',
            LastModifiedDate = GETDATE(),
            LastModifiedBy = @CreatedBy
        WHERE PurchaseOrderID = @PurchaseOrderID
        AND NOT EXISTS (
            SELECT 1 
            FROM PurchaseOrderLines pol
            WHERE pol.PurchaseOrderID = @PurchaseOrderID
            AND pol.ReceivedQuantity < pol.OrderedQuantity
        );
        
        COMMIT TRANSACTION;
        
        SELECT @GRNID AS GRNID;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

-- Update the SaveGoodsReceivedVoucher method to use the correct column names
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_GRN_SaveVoucher')
BEGIN
    DROP PROCEDURE sp_GRN_SaveVoucher;
    PRINT 'Dropped old version of sp_GRN_SaveVoucher';
END
GO

CREATE PROCEDURE sp_GRN_SaveVoucher
    @SupplierID INT,
    @POID INT,
    @DeliveryNote NVARCHAR(100),
    @ReceivedDate DATETIME,
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @GRNID INT;
    DECLARE @BranchID INT;
    DECLARE @GRNNumber NVARCHAR(50);
    
    -- Get branch ID from PO
    SELECT @BranchID = BranchID 
    FROM PurchaseOrders 
    WHERE PurchaseOrderID = @POID;
    
    -- Generate GRN number
    SET @GRNNumber = 'GRN' + CONVERT(VARCHAR(8), GETDATE(), 112) + 
                     RIGHT('0000' + CAST(ISNULL((SELECT COUNT(*) FROM GoodsReceivedNotes WHERE CONVERT(DATE, CreatedDate) = CONVERT(DATE, GETDATE())) + 1, 1) AS VARCHAR(4)), 4);
    
    -- Insert GRN header
    INSERT INTO GoodsReceivedNotes (
        SupplierID, 
        PurchaseOrderID, 
        BranchID, 
        GRNNumber, 
        DeliveryNoteNumber, 
        ReceivedDate, 
        Status, 
        CreatedDate, 
        CreatedBy
    )
    VALUES (
        @SupplierID,
        @POID,
        @BranchID,
        @GRNNumber,
        @DeliveryNote,
        @ReceivedDate,
        'Completed',
        GETDATE(),
        @CreatedBy
    );
    
    SET @GRNID = SCOPE_IDENTITY();
    
    -- Update PO status to 'Partially Received' or 'Fully Received'
    UPDATE po
    SET Status = CASE 
                    WHEN EXISTS (
                        SELECT 1 
                        FROM PurchaseOrderLines pol 
                        WHERE pol.PurchaseOrderID = po.PurchaseOrderID 
                        AND pol.ReceivedQuantity < pol.OrderedQuantity
                    ) THEN 'Partially Received'
                    ELSE 'Fully Received'
                END,
        LastModifiedDate = GETDATE(),
        LastModifiedBy = @CreatedBy
    FROM PurchaseOrders po
    WHERE po.PurchaseOrderID = @POID;
    
    -- Return the GRN ID
    SELECT @GRNID AS GRNID;
END;
GO

PRINT '✅ Created/Updated all GRN-related database objects';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ DATABASE SCHEMA UPDATED SUCCESSFULLY';
PRINT '═══════════════════════════════════════════════';
GO
