-- =============================================
-- CHECK TABLE STRUCTURE AND ADD COLUMNS SAFELY
-- =============================================

-- First, check if the table exists
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PurchaseOrders')
BEGIN
    PRINT '❌ Error: PurchaseOrders table does not exist';
    RETURN;
END
ELSE
BEGIN
    PRINT '✅ PurchaseOrders table exists';
    
    -- List all columns in the table
    PRINT '\n📋 Current columns in PurchaseOrders table:';
    SELECT 
        COLUMN_NAME AS ColumnName,
        DATA_TYPE AS DataType,
        IS_NULLABLE AS IsNullable
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'PurchaseOrders'
    ORDER BY ORDINAL_POSITION;
    
    -- Check for any date-related columns that might be used for modification tracking
    PRINT '\n🔍 Checking for existing date columns that could be used for tracking modifications:';
    SELECT 
        COLUMN_NAME AS ColumnName,
        DATA_TYPE AS DataType
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'PurchaseOrders'
    AND DATA_TYPE IN ('datetime', 'datetime2', 'smalldatetime', 'date', 'datetimeoffset');
    
    -- Check for any user tracking columns
    PRINT '\n👤 Checking for existing user tracking columns:';
    SELECT 
        COLUMN_NAME AS ColumnName,
        DATA_TYPE AS DataType
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'PurchaseOrders'
    AND COLUMN_NAME LIKE '%user%' 
       OR COLUMN_NAME LIKE '%by%' 
       OR COLUMN_NAME LIKE '%modif%';
    
    -- Add the missing columns with proper error handling
    PRINT '\n🔄 Attempting to add missing columns...';
    
    -- Add LastModifiedDate if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM sys.columns 
                  WHERE object_id = OBJECT_ID('PurchaseOrders') 
                  AND name = 'LastModifiedDate')
    BEGIN
        BEGIN TRY
            ALTER TABLE PurchaseOrders ADD LastModifiedDate DATETIME NULL;
            PRINT '✅ Successfully added LastModifiedDate to PurchaseOrders';
            
            -- Set default value for existing records
            UPDATE PurchaseOrders SET LastModifiedDate = GETDATE() WHERE LastModifiedDate IS NULL;
            PRINT '   - Set default values for existing records';
        END TRY
        BEGIN CATCH
            PRINT '❌ Error adding LastModifiedDate: ' + ERROR_MESSAGE();
        END CATCH
    END
    ELSE
    BEGIN
        PRINT 'ℹ️ LastModifiedDate already exists in PurchaseOrders';
    END
    
    -- Add LastModifiedBy if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM sys.columns 
                  WHERE object_id = OBJECT_ID('PurchaseOrders') 
                  AND name = 'LastModifiedBy')
    BEGIN
        BEGIN TRY
            ALTER TABLE PurchaseOrders ADD LastModifiedBy INT NULL;
            PRINT '✅ Successfully added LastModifiedBy to PurchaseOrders';
        END TRY
        BEGIN CATCH
            PRINT '❌ Error adding LastModifiedBy: ' + ERROR_MESSAGE();
        END CATCH
    END
    ELSE
    BEGIN
        PRINT 'ℹ️ LastModifiedBy already exists in PurchaseOrders';
    END
    
    -- Create a simpler version of the stored procedure that doesn't depend on the new columns
    PRINT '\n🔄 Creating simplified stored procedures...';
    
    IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_GRN_Create')
    BEGIN
        DROP PROCEDURE sp_GRN_Create;
        PRINT 'Dropped old version of sp_GRN_Create';
    END
    
    PRINT 'Creating simplified sp_GRN_Create...';
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
            UPDATE po
            SET Status = CASE 
                            WHEN EXISTS (
                                SELECT 1 
                                FROM PurchaseOrderLines pol 
                                WHERE pol.PurchaseOrderID = po.PurchaseOrderID 
                                AND pol.ReceivedQuantity < pol.OrderedQuantity
                            ) THEN ''Partially Received''
                            ELSE ''Fully Received''
                        END
            FROM PurchaseOrders po
            WHERE po.PurchaseOrderID = @PurchaseOrderID;
            
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
    
    PRINT '✅ Created simplified sp_GRN_Create';
    
    PRINT '\n═══════════════════════════════════════════════';
    PRINT '✅ SCRIPT COMPLETED - PLEASE CHECK OUTPUT ABOVE';
    PRINT '═══════════════════════════════════════════════';
END
GO
