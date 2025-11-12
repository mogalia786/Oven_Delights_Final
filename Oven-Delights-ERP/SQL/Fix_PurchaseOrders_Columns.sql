-- =============================================
-- ADD MISSING COLUMNS TO PURCHASE ORDERS TABLE
-- =============================================

-- Add LastModifiedDate if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns 
               WHERE object_id = OBJECT_ID('PurchaseOrders') 
               AND name = 'LastModifiedDate')
BEGIN
    ALTER TABLE PurchaseOrders ADD LastModifiedDate DATETIME NULL;
    UPDATE PurchaseOrders SET LastModifiedDate = GETDATE() WHERE LastModifiedDate IS NULL;
    PRINT '✅ Added LastModifiedDate to PurchaseOrders';
END

-- Add LastModifiedBy if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns 
               WHERE object_id = OBJECT_ID('PurchaseOrders') 
               AND name = 'LastModifiedBy')
BEGIN
    ALTER TABLE PurchaseOrders ADD LastModifiedBy INT NULL;
    PRINT '✅ Added LastModifiedBy to PurchaseOrders';
END

-- Update the stored procedures to use the correct column names
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
        IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('PurchaseOrders') AND name = 'LastModifiedDate')
        BEGIN
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
        END
        ELSE
        BEGIN
            -- Fallback if columns don't exist
            UPDATE PurchaseOrders
            SET Status = 'Received'
            WHERE PurchaseOrderID = @PurchaseOrderID
            AND NOT EXISTS (
                SELECT 1 
                FROM PurchaseOrderLines pol
                WHERE pol.PurchaseOrderID = @PurchaseOrderID
                AND pol.ReceivedQuantity < pol.OrderedQuantity
            );
        END
        
        COMMIT TRANSACTION;
        
        SELECT @GRNID AS GRNID;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

-- Update the SaveGoodsReceivedVoucher stored procedure
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
    IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('PurchaseOrders') AND name = 'LastModifiedDate')
    BEGIN
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
    END
    ELSE
    BEGIN
        -- Fallback if columns don't exist
        UPDATE po
        SET Status = CASE 
                        WHEN EXISTS (
                            SELECT 1 
                            FROM PurchaseOrderLines pol 
                            WHERE pol.PurchaseOrderID = po.PurchaseOrderID 
                            AND pol.ReceivedQuantity < pol.OrderedQuantity
                        ) THEN 'Partially Received'
                        ELSE 'Fully Received'
                    END
        FROM PurchaseOrders po
        WHERE po.PurchaseOrderID = @POID;
    END
    
    -- Return the GRN ID
    SELECT @GRNID AS GRNID;
END;
GO

PRINT '✅ Added missing columns to PurchaseOrders and updated stored procedures';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ DATABASE SCHEMA UPDATED SUCCESSFULLY';
PRINT '═══════════════════════════════════════════════';
GO
