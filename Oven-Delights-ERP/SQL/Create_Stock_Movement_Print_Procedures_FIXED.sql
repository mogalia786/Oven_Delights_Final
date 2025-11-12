-- =============================================
-- STOCK MOVEMENT PRINT REPORTS (FIXED FOR ACTUAL TABLE)
-- Works with existing StockMovements table structure
-- =============================================

-- =============================================
-- 1. PRINT STOCK MOVEMENT REPORT (Full Detail)
-- =============================================
IF OBJECT_ID('sp_Print_StockMovementReport', 'P') IS NOT NULL
    DROP PROCEDURE sp_Print_StockMovementReport;
GO

CREATE PROCEDURE sp_Print_StockMovementReport
    @StartDate DATE,
    @EndDate DATE,
    @MaterialID INT = 0,
    @MovementType NVARCHAR(50) = NULL,
    @InventoryArea NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        sm.MovementID,
        sm.MovementDate,
        sm.MovementType,
        p.ProductName,
        p.SKU,
        sm.InventoryArea,
        sm.FromLocation,
        sm.ToLocation,
        sm.QuantityIn,
        sm.QuantityOut,
        sm.BalanceAfter,
        sm.UnitCost,
        sm.TotalValue,
        
        -- Reference Details
        sm.ReferenceType,
        sm.ReferenceID,
        sm.ReferenceNumber,
        
        -- Accountability
        sm.RequestedBy,
        sm.RequestedDate,
        sm.ApprovedBy,
        sm.ApprovedDate,
        sm.ReceivedBy,
        sm.ReceivedDate,
        
        -- Additional
        b.BranchName,
        sm.Notes,
        sm.CreatedBy,
        sm.CreatedDate
        
    FROM StockMovements sm
    INNER JOIN Products p ON sm.MaterialID = p.ProductID
    LEFT JOIN Branches b ON sm.BranchID = b.BranchID
    WHERE CONVERT(DATE, sm.MovementDate) BETWEEN @StartDate AND @EndDate
        AND (@MaterialID = 0 OR sm.MaterialID = @MaterialID)
        AND (@MovementType IS NULL OR sm.MovementType = @MovementType)
        AND (@InventoryArea IS NULL OR sm.InventoryArea = @InventoryArea)
    ORDER BY sm.MovementDate DESC, sm.MovementID DESC;
END;
GO

PRINT '✅ sp_Print_StockMovementReport created';

-- =============================================
-- 2. PRINT PO RECEIPT REPORT (Supplier to Stockroom)
-- =============================================
IF OBJECT_ID('sp_Print_POReceiptReport', 'P') IS NOT NULL
    DROP PROCEDURE sp_Print_POReceiptReport;
GO

CREATE PROCEDURE sp_Print_POReceiptReport
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        sm.MovementDate AS ReceiptDate,
        sm.ReferenceNumber AS PONumber,
        p.ProductName,
        p.SKU,
        sm.QuantityIn AS QuantityReceived,
        sm.UnitCost,
        sm.TotalValue,
        
        -- Accountability
        sm.RequestedBy AS OrderedBy,
        sm.RequestedDate AS OrderDate,
        sm.ReceivedBy AS ReceivedInStockroomBy,
        sm.ReceivedDate AS ReceivedDate,
        
        -- Location
        b.BranchName,
        sm.InventoryArea,
        sm.Notes,
        sm.BalanceAfter AS StockroomBalance
        
    FROM StockMovements sm
    INNER JOIN Products p ON sm.MaterialID = p.ProductID
    LEFT JOIN Branches b ON sm.BranchID = b.BranchID
    WHERE sm.MovementType = 'PO Receipt'
        AND CONVERT(DATE, sm.MovementDate) BETWEEN @StartDate AND @EndDate
    ORDER BY sm.MovementDate DESC, sm.ReferenceNumber;
END;
GO

PRINT '✅ sp_Print_POReceiptReport created';

-- =============================================
-- 3. PRINT MANUFACTURING REQUEST REPORT
-- =============================================
IF OBJECT_ID('sp_Print_ManufacturingRequestReport', 'P') IS NOT NULL
    DROP PROCEDURE sp_Print_ManufacturingRequestReport;
GO

CREATE PROCEDURE sp_Print_ManufacturingRequestReport
    @StartDate DATE,
    @EndDate DATE,
    @BranchID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        sm.MovementDate AS TransferDate,
        sm.ReferenceNumber AS BOMNumber,
        p.ProductName AS MaterialName,
        p.SKU,
        sm.QuantityOut AS QuantityTransferred,
        
        -- Accountability Chain
        sm.RequestedBy AS ManufacturerRequested,
        sm.RequestedDate AS RequestDate,
        sm.ApprovedBy AS StockroomApproved,
        sm.ApprovedDate AS ApprovalDate,
        sm.ReceivedBy AS ManufacturerReceived,
        sm.ReceivedDate AS ReceivedDate,
        
        -- Location
        b.BranchName,
        sm.FromLocation,
        sm.ToLocation,
        sm.Notes,
        sm.BalanceAfter AS StockroomBalance
        
    FROM StockMovements sm
    INNER JOIN Products p ON sm.MaterialID = p.ProductID
    LEFT JOIN Branches b ON sm.BranchID = b.BranchID
    WHERE sm.MovementType = 'Transfer to Manufacturing'
        AND CONVERT(DATE, sm.MovementDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR sm.BranchID = @BranchID)
    ORDER BY sm.MovementDate DESC, sm.ReferenceNumber;
END;
GO

PRINT '✅ sp_Print_ManufacturingRequestReport created';

-- =============================================
-- 4. PRINT PRODUCTION COMPLETION REPORT
-- =============================================
IF OBJECT_ID('sp_Print_ProductionCompletionReport', 'P') IS NOT NULL
    DROP PROCEDURE sp_Print_ProductionCompletionReport;
GO

CREATE PROCEDURE sp_Print_ProductionCompletionReport
    @StartDate DATE,
    @EndDate DATE,
    @BranchID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        sm.MovementDate AS CompletionDate,
        sm.ReferenceNumber AS BOMNumber,
        p.ProductName AS FinishedProduct,
        p.SKU,
        sm.QuantityIn AS QuantityProduced,
        sm.TotalValue AS ProductionCost,
        
        -- Accountability
        sm.RequestedBy AS ManufacturerCompleted,
        sm.RequestedDate AS CompletionDate,
        sm.ReceivedBy AS RetailReceived,
        sm.ReceivedDate AS ReceivedInRetailDate,
        
        -- Location
        b.BranchName,
        sm.FromLocation,
        sm.ToLocation,
        sm.InventoryArea,
        sm.Notes,
        sm.BalanceAfter AS RetailStock
        
    FROM StockMovements sm
    INNER JOIN Products p ON sm.MaterialID = p.ProductID
    LEFT JOIN Branches b ON sm.BranchID = b.BranchID
    WHERE sm.MovementType = 'Production Complete'
        AND CONVERT(DATE, sm.MovementDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR sm.BranchID = @BranchID)
    ORDER BY sm.MovementDate DESC, sm.ReferenceNumber;
END;
GO

PRINT '✅ sp_Print_ProductionCompletionReport created';

-- =============================================
-- 5. PRINT ACCOUNTABILITY SUMMARY
-- =============================================
IF OBJECT_ID('sp_Print_AccountabilitySummary', 'P') IS NOT NULL
    DROP PROCEDURE sp_Print_AccountabilitySummary;
GO

CREATE PROCEDURE sp_Print_AccountabilitySummary
    @StartDate DATE,
    @EndDate DATE,
    @UserName NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        COALESCE(sm.RequestedBy, sm.ApprovedBy, sm.ReceivedBy, sm.CreatedBy) AS UserName,
        
        -- Count by role
        COUNT(CASE WHEN sm.RequestedBy IS NOT NULL THEN 1 END) AS RequestedCount,
        COUNT(CASE WHEN sm.ApprovedBy IS NOT NULL THEN 1 END) AS ApprovedCount,
        COUNT(CASE WHEN sm.ReceivedBy IS NOT NULL THEN 1 END) AS ReceivedCount,
        
        -- Count by movement type
        COUNT(CASE WHEN sm.MovementType = 'PO Receipt' THEN 1 END) AS POReceipts,
        COUNT(CASE WHEN sm.MovementType = 'Transfer to Manufacturing' THEN 1 END) AS ManufacturingTransfers,
        COUNT(CASE WHEN sm.MovementType = 'Production Complete' THEN 1 END) AS ProductionCompletions,
        
        -- Date range
        MIN(sm.MovementDate) AS FirstActivity,
        MAX(sm.MovementDate) AS LastActivity
        
    FROM StockMovements sm
    WHERE CONVERT(DATE, sm.MovementDate) BETWEEN @StartDate AND @EndDate
        AND (@UserName IS NULL OR 
             sm.RequestedBy = @UserName OR 
             sm.ApprovedBy = @UserName OR 
             sm.ReceivedBy = @UserName OR 
             sm.CreatedBy = @UserName)
    GROUP BY COALESCE(sm.RequestedBy, sm.ApprovedBy, sm.ReceivedBy, sm.CreatedBy)
    ORDER BY LastActivity DESC;
END;
GO

PRINT '✅ sp_Print_AccountabilitySummary created';

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ STOCK MOVEMENT PRINT PROCEDURES CREATED!';
PRINT '   - sp_Print_StockMovementReport (Full Detail)';
PRINT '   - sp_Print_POReceiptReport (Supplier → Stockroom)';
PRINT '   - sp_Print_ManufacturingRequestReport (Stockroom → Manufacturing)';
PRINT '   - sp_Print_ProductionCompletionReport (Manufacturing → Retail)';
PRINT '   - sp_Print_AccountabilitySummary (Who Did What)';
PRINT '═══════════════════════════════════════════════';
