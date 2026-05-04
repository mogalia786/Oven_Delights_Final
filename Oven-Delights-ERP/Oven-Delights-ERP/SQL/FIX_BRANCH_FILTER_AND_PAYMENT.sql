-- =============================================
-- FIX 1: Filter bakers by branch in re-order book
-- FIX 2: Fix duplicate key error in batch payments
-- =============================================

PRINT '🔧 Fixing branch filter and batch payment issues...';
PRINT '';

-- =============================================
-- FIX 1: Check current baker loading query
-- =============================================
PRINT '1️⃣ Checking how bakers are loaded...';
PRINT '';
PRINT 'Current query in ReOrderBookManagerForm.vb line 62:';
PRINT 'SELECT UserID, FirstName + '' '' + LastName AS FullName';
PRINT 'FROM Users';
PRINT 'WHERE RoleID IN (SELECT RoleID FROM Roles WHERE RoleName = ''Manufacturer'')';
PRINT '  AND IsActive = 1';
PRINT 'ORDER BY FirstName';
PRINT '';
PRINT '❌ PROBLEM: No branch filter!';
PRINT '';
PRINT '✅ SOLUTION: Add branch filter in the VB code';
PRINT '   Change line 62 to include: AND BranchID = @BranchID';
PRINT '';

-- =============================================
-- FIX 2: Check SupplierPayments table for unique constraint
-- =============================================
PRINT '2️⃣ Checking SupplierPayments unique constraint...';
PRINT '';

-- Check if table exists
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'SupplierPayments')
BEGIN
    PRINT '✅ SupplierPayments table exists';
    PRINT '';
    
    -- Check unique constraints
    PRINT 'Unique constraints on SupplierPayments:';
    SELECT 
        i.name AS ConstraintName,
        COL_NAME(ic.object_id, ic.column_id) AS ColumnName,
        i.is_unique,
        i.type_desc
    FROM sys.indexes i
    INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
    WHERE i.object_id = OBJECT_ID('SupplierPayments')
      AND i.is_unique = 1
    ORDER BY i.name, ic.key_ordinal;
    
    PRINT '';
    PRINT '📋 The error occurs when trying to insert duplicate:';
    PRINT '   - Same SupplierID';
    PRINT '   - Same BatchID (or PaymentReference)';
    PRINT '   - In the same batch';
    PRINT '';
    
    -- Check recent payments
    PRINT 'Recent SupplierPayments (last 10):';
    SELECT TOP 10
        PaymentID,
        SupplierID,
        PaymentDate,
        Amount,
        PaymentReference,
        BatchID,
        CreatedDate
    FROM SupplierPayments
    ORDER BY PaymentID DESC;
    
END
ELSE
BEGIN
    PRINT '❌ SupplierPayments table does not exist!';
END

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '📋 FIXES REQUIRED:';
PRINT '';
PRINT '1. BRANCH FILTER:';
PRINT '   File: Forms\Manufacturing\ReOrderBookManagerForm.vb';
PRINT '   Line: 62';
PRINT '   Change:';
PRINT '   FROM: WHERE RoleID IN (...) AND IsActive = 1';
PRINT '   TO:   WHERE RoleID IN (...) AND IsActive = 1 AND BranchID = @BranchID';
PRINT '';
PRINT '2. BATCH PAYMENT:';
PRINT '   The stored procedure is trying to insert duplicate payments.';
PRINT '   Need to check sp_ProcessBatchPayment or similar procedure.';
PRINT '';
PRINT '🔍 Next: Run CHECK_BATCH_PAYMENT_PROCEDURE.sql to find the issue';
PRINT '═══════════════════════════════════════════════';
