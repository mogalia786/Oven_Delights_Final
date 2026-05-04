-- =============================================
-- FIX PURCHASE ORDERS COLUMNS - V2
-- =============================================

-- First, check if we can add the columns
BEGIN TRY
    -- Add LastModifiedDate if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns 
                  WHERE object_id = OBJECT_ID('PurchaseOrders') 
                  AND name = 'LastModifiedDate')
    BEGIN
        ALTER TABLE PurchaseOrders ADD LastModifiedDate DATETIME NULL;
        PRINT '✅ Added LastModifiedDate to PurchaseOrders';
        
        -- Set default value for existing records
        UPDATE PurchaseOrders SET LastModifiedDate = GETDATE() WHERE LastModifiedDate IS NULL;
        PRINT '✅ Set default values for LastModifiedDate';
    END
    ELSE
    BEGIN
        PRINT 'ℹ️ LastModifiedDate already exists in PurchaseOrders';
    END
    
    -- Add LastModifiedBy if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns 
                  WHERE object_id = OBJECT_ID('PurchaseOrders') 
                  AND name = 'LastModifiedBy')
    BEGIN
        ALTER TABLE PurchaseOrders ADD LastModifiedBy INT NULL;
        PRINT '✅ Added LastModifiedBy to PurchaseOrders';
    END
    ELSE
    BEGIN
        PRINT 'ℹ️ LastModifiedBy already exists in PurchaseOrders';
    END
    
    -- Now update the stored procedures with proper error handling
    IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_GRN_Create')
    BEGIN
        DROP PROCEDURE sp_GRN_Create;
        PRINT 'Dropped old version of sp_GRN_Create';
    END
    
    PRINT 'Creating sp_GRN_Create...';
    EXEC('CREATE PROCEDURE sp_GRN_Create
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
        DECLARE @SQL NVARCHAR(MAX);
        
        BEGIN TRY
            BEGIN TRANSACTION;
            
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
                ''Completed'',
                GETDATE(),
                @CreatedBy
            );
            
            SET @GRNID = SCOPE_IDENTITY();
            
            -- Update the PO status to ''Received'' if all items are received
            -- Use dynamic SQL to handle potential missing columns
            IF EXISTS (SELECT 1 FROM sys.columns 
                      WHERE object_id = OBJECT_ID(''PurchaseOrders'') 
                      AND name = ''LastModifiedDate'')
            BEGIN
                SET @SQL = ''
                UPDATE PurchaseOrders
                SET Status = ''''Received'''',
                    LastModifiedDate = GETDATE(),
                    LastModifiedBy = '' + CAST(@CreatedBy AS NVARCHAR(10)) + ''
                WHERE PurchaseOrderID = '' + CAST(@PurchaseOrderID AS NVARCHAR(10)) + ''
                AND NOT EXISTS (
                    SELECT 1 
                    FROM PurchaseOrderLines pol
                    WHERE pol.PurchaseOrderID = '' + CAST(@PurchaseOrderID AS NVARCHAR(10)) + ''
                    AND pol.ReceivedQuantity < pol.OrderedQuantity
                )'';
            END
            ELSE
            BEGIN
                SET @SQL = ''
                UPDATE PurchaseOrders
                SET Status = ''''Received''''
                WHERE PurchaseOrderID = '' + CAST(@PurchaseOrderID AS NVARCHAR(10)) + ''
                AND NOT EXISTS (
                    SELECT 1 
                    FROM PurchaseOrderLines pol
                    WHERE pol.PurchaseOrderID = '' + CAST(@PurchaseOrderID AS NVARCHAR(10)) + ''
                    AND pol.ReceivedQuantity < pol.OrderedQuantity
                )'';
            END
            
            EXEC sp_executesql @SQL;
            
            COMMIT TRANSACTION;
            
            SELECT @GRNID AS GRNID;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
                
            DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
            DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
            DECLARE @ErrorState INT = ERROR_STATE();
            
            RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
        END CATCH;
    END');
    
    PRINT '✅ Created sp_GRN_Create with dynamic SQL';
    
    -- Now update sp_GRN_SaveVoucher
    IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_GRN_SaveVoucher')
    BEGIN
        DROP PROCEDURE sp_GRN_SaveVoucher;
        PRINT 'Dropped old version of sp_GRN_SaveVoucher';
    END
    
    PRINT 'Creating sp_GRN_SaveVoucher...';
    EXEC('CREATE PROCEDURE sp_GRN_SaveVoucher
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
        DECLARE @SQL NVARCHAR(MAX);
        
        BEGIN TRY
            BEGIN TRANSACTION;
            
            -- Get branch ID from PO
            SELECT @BranchID = BranchID 
            FROM PurchaseOrders 
            WHERE PurchaseOrderID = @POID;
            
            -- Generate GRN number
            SET @GRNNumber = ''''GRN'''' + CONVERT(VARCHAR(8), GETDATE(), 112) + 
                             RIGHT(''''0000'''' + CAST(ISNULL((SELECT COUNT(*) FROM GoodsReceivedNotes WHERE CONVERT(DATE, CreatedDate) = CONVERT(DATE, GETDATE())) + 1, 1) AS VARCHAR(4)), 4);
            
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
                ''''Completed'''',
                GETDATE(),
                @CreatedBy
            );
            
            SET @GRNID = SCOPE_IDENTITY();
            
            -- Update PO status to ''''Partially Received'''' or ''''Fully Received''''
            -- Use dynamic SQL to handle potential missing columns
            IF EXISTS (SELECT 1 FROM sys.columns 
                      WHERE object_id = OBJECT_ID(''''PurchaseOrders'''') 
                      AND name = ''''LastModifiedDate'''')
            BEGIN
                SET @SQL = ''''
                UPDATE po
                SET Status = CASE 
                                WHEN EXISTS (
                                    SELECT 1 
                                    FROM PurchaseOrderLines pol 
                                    WHERE pol.PurchaseOrderID = po.PurchaseOrderID 
                                    AND pol.ReceivedQuantity < pol.OrderedQuantity
                                ) THEN ''''Partially Received''''
                                ELSE ''''Fully Received''''
                            END,
                    LastModifiedDate = GETDATE(),
                    LastModifiedBy = '''' + CAST(@CreatedBy AS NVARCHAR(10)) + ''''
                FROM PurchaseOrders po
                WHERE po.PurchaseOrderID = '''' + CAST(@POID AS NVARCHAR(10)) + ''''
                ''''; 
            END
            ELSE
            BEGIN
                SET @SQL = ''''
                UPDATE po
                SET Status = CASE 
                                WHEN EXISTS (
                                    SELECT 1 
                                    FROM PurchaseOrderLines pol 
                                    WHERE pol.PurchaseOrderID = po.PurchaseOrderID 
                                    AND pol.ReceivedQuantity < pol.OrderedQuantity
                                ) THEN ''''Partially Received''''
                                ELSE ''''Fully Received''''
                            END
                FROM PurchaseOrders po
                WHERE po.PurchaseOrderID = '''' + CAST(@POID AS NVARCHAR(10)) + ''''
                ''''; 
            END
            
            EXEC sp_executesql @SQL;
            
            COMMIT TRANSACTION;
            
            -- Return the GRN ID
            SELECT @GRNID AS GRNID;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
                
            DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
            DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
            DECLARE @ErrorState INT = ERROR_STATE();
            
            RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
        END CATCH;
    END');
    
    PRINT '✅ Created sp_GRN_SaveVoucher with dynamic SQL';
    
    PRINT '═══════════════════════════════════════════════';
    PRINT '✅ DATABASE SCHEMA UPDATED SUCCESSFULLY';
    PRINT '═══════════════════════════════════════════════';
    
END TRY
BEGIN CATCH
    DECLARE @ErrorMsg NVARCHAR(4000) = 'Error: ' + ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();
    
    PRINT '❌ ERROR: ' + @ErrorMsg;
    PRINT 'Error Severity: ' + CAST(@ErrorSeverity AS NVARCHAR(10));
    PRINT 'Error State: ' + CAST(@ErrorState AS NVARCHAR(10));
    
    -- Try to continue with the rest of the script even if there's an error
    IF @@TRANCOUNT > 0
        ROLLBACK;
END CATCH;
GO
