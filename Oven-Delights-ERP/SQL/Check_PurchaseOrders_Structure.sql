-- =============================================
-- CHECK PURCHASEORDERS TABLE STRUCTURE
-- =============================================

-- Check if PurchaseOrders table exists
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
        c.name AS ColumnName,
        t.name AS DataType,
        c.max_length,
        c.precision,
        c.scale,
        c.is_nullable,
        c.is_identity
    FROM 
        sys.columns c
    INNER JOIN 
        sys.types t ON c.user_type_id = t.user_type_id
    WHERE 
        c.object_id = OBJECT_ID('PurchaseOrders')
    ORDER BY 
        c.column_id;
    
    -- Check for any date-related columns
    PRINT '\n📅 Date-related columns in PurchaseOrders table:';
    SELECT 
        c.name AS ColumnName,
        t.name AS DataType
    FROM 
        sys.columns c
    INNER JOIN 
        sys.types t ON c.user_type_id = t.user_type_id
    WHERE 
        c.object_id = OBJECT_ID('PurchaseOrders')
        AND t.name IN ('datetime', 'datetime2', 'smalldatetime', 'date', 'datetimeoffset');
    
    -- Check for any user tracking columns
    PRINT '\n👤 User tracking columns in PurchaseOrders table:';
    SELECT 
        c.name AS ColumnName,
        t.name AS DataType
    FROM 
        sys.columns c
    INNER JOIN 
        sys.types t ON c.user_type_id = t.user_type_id
    WHERE 
        c.object_id = OBJECT_ID('PurchaseOrders')
        AND (c.name LIKE '%user%' OR c.name LIKE '%by%' OR c.name LIKE '%modif%');
END
GO

-- Check if we can create a simple procedure
PRINT '\n🔧 Testing procedure creation...';

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Test_PO_Update')
    DROP PROCEDURE sp_Test_PO_Update;
GO

CREATE PROCEDURE sp_Test_PO_Update
    @POID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Try to update the PO status without any date/user tracking
    UPDATE PurchaseOrders
    SET Status = 'TestStatus'
    WHERE PurchaseOrderID = @POID;
    
    PRINT '✅ Successfully updated PO ' + CAST(@POID AS VARCHAR(10));
END
GO

PRINT '\n✅ Test procedure created successfully';
PRINT 'Run this to test it: EXEC sp_Test_PO_Update @POID = 1;';
PRINT '\n═══════════════════════════════════════════════';
PRINT '✅ SCRIPT COMPLETED - PLEASE SHARE THE OUTPUT';
PRINT '═══════════════════════════════════════════════';
GO
