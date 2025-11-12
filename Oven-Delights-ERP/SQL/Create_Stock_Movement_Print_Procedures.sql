-- =============================================
-- STOCK MOVEMENT PRINT REPORTS
-- Full Accountability Tracking
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
        sm.QuantityIn,
        sm.QuantityOut,
        sm.[Balance/After] AS BalanceAfter,
        sm.UnitCost,
        sm.TotalValue,
        
        -- Reference Details
        sm.ReferenceType,
        sm.ReferenceID,
        sm.ReferenceNumber,
        
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
    @EndDate DATE,
    @SupplierID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        sm.MovementDate AS ReceiptDate,
        sm.ReferenceNumber AS PONumber,
        p.ProductName,
        p.SKU,
        sm.Quantity AS QuantityReceived,
        sm.UnitOfMeasure,
        sm.CostPerUnit,
        sm.TotalCost,
        
        -- Accountability
        sm.RequestedBy AS OrderedBy,
        sm.RequestedDate AS OrderDate,
        sm.ReceivedBy AS ReceivedInStockroomBy,
        sm.ReceivedDate AS ReceivedDate,
        
        -- Location
        b.BranchName,
        sm.Notes,
        
        -- Current Stockroom Level
        (SELECT SUM(Quantity) FROM StockroomStock WHERE ProductID = p.ProductID AND BranchID = sm.BranchID) AS CurrentStockroomStock
        
    FROM StockMovements sm
    INNER JOIN Products p ON sm.ProductID = p.ProductID
    LEFT JOIN Branches b ON sm.BranchID = b.BranchID
    WHERE sm.MovementType = 'PO Receipt'
        AND sm.FromLocation = 'Supplier'
        AND sm.ToLocation = 'Stockroom'
        AND CONVERT(DATE, sm.MovementDate) BETWEEN @StartDate AND @EndDate
    ORDER BY sm.MovementDate DESC, sm.ReferenceNumber;
END;
GO

PRINT '✅ sp_Print_POReceiptReport created';

-- =============================================
-- 3. PRINT MANUFACTURING REQUEST REPORT (Stockroom to Manufacturing)
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
        sm.Quantity AS QuantityTransferred,
        sm.UnitOfMeasure,
        
        -- Accountability Chain
        sm.RequestedBy AS ManufacturerRequested,
        sm.RequestedDate AS RequestDate,
        sm.ApprovedBy AS StockroomApproved,
        sm.ApprovedDate AS ApprovalDate,
        sm.ReceivedBy AS ManufacturerReceived,
        sm.ReceivedDate AS ReceivedDate,
        
        -- Location
        b.BranchName,
        sm.Notes,
        
        -- Current Levels
        (SELECT SUM(Quantity) FROM StockroomStock WHERE ProductID = p.ProductID AND BranchID = sm.BranchID) AS StockroomBalance,
        (SELECT SUM(Quantity) FROM ManufacturingStock WHERE ProductID = p.ProductID AND BranchID = sm.BranchID AND Status = 'In Progress') AS ManufacturingBalance
        
    FROM StockMovements sm
    INNER JOIN Products p ON sm.ProductID = p.ProductID
    LEFT JOIN Branches b ON sm.BranchID = b.BranchID
    WHERE sm.MovementType = 'Transfer to Manufacturing'
        AND sm.FromLocation = 'Stockroom'
        AND sm.ToLocation = 'Manufacturing'
        AND CONVERT(DATE, sm.MovementDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR sm.BranchID = @BranchID)
    ORDER BY sm.MovementDate DESC, sm.ReferenceNumber;
END;
GO

PRINT '✅ sp_Print_ManufacturingRequestReport created';

-- =============================================
-- 4. PRINT PRODUCTION COMPLETION REPORT (Manufacturing to Retail)
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
        sm.Quantity AS QuantityProduced,
        sm.UnitOfMeasure,
        sm.TotalCost AS ProductionCost,
        
        -- Accountability
        sm.RequestedBy AS ManufacturerCompleted,
        sm.RequestedDate AS CompletionDate,
        sm.ReceivedBy AS RetailReceived,
        sm.ReceivedDate AS ReceivedInRetailDate,
        
        -- Location
        b.BranchName,
        sm.Notes,
        
        -- Current Retail Stock
        (SELECT SUM(Quantity) FROM RetailStock WHERE ProductID = p.ProductID AND BranchID = sm.BranchID AND StockType = 'Internal') AS CurrentRetailStock
        
    FROM StockMovements sm
    INNER JOIN Products p ON sm.ProductID = p.ProductID
    LEFT JOIN Branches b ON sm.BranchID = b.BranchID
    WHERE sm.MovementType = 'Production Complete'
        AND sm.FromLocation = 'Manufacturing'
        AND sm.ToLocation = 'Retail'
        AND CONVERT(DATE, sm.MovementDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR sm.BranchID = @BranchID)
    ORDER BY sm.MovementDate DESC, sm.ReferenceNumber;
END;
GO

PRINT '✅ sp_Print_ProductionCompletionReport created';

-- =============================================
-- 5. PRINT TRANSFER REQUEST REPORT (With Full Workflow)
-- =============================================
IF OBJECT_ID('sp_Print_TransferRequestReport', 'P') IS NOT NULL
    DROP PROCEDURE sp_Print_TransferRequestReport;
GO

CREATE PROCEDURE sp_Print_TransferRequestReport
    @StartDate DATE,
    @EndDate DATE,
    @Status NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        str.RequestNumber,
        str.RequestDate,
        p.ProductName,
        p.SKU,
        str.FromLocation,
        str.ToLocation,
        fb.BranchName AS FromBranch,
        tb.BranchName AS ToBranch,
        
        -- Quantities
        str.RequestedQuantity,
        str.ApprovedQuantity,
        str.TransferredQuantity,
        str.UnitOfMeasure,
        
        -- Status & Priority
        str.Status,
        str.Priority,
        str.Purpose,
        
        -- Accountability Chain
        str.RequestedBy,
        str.RequestedDate,
        str.ApprovedBy,
        str.ApprovedDate,
        str.ProcessedBy,
        str.ProcessedDate,
        str.ReceivedBy,
        str.ReceivedDate,
        
        -- Notes
        str.Notes
        
    FROM StockTransferRequests str
    INNER JOIN Products p ON str.ProductID = p.ProductID
    LEFT JOIN Branches fb ON str.FromBranchID = fb.BranchID
    LEFT JOIN Branches tb ON str.ToBranchID = tb.BranchID
    WHERE CONVERT(DATE, str.RequestDate) BETWEEN @StartDate AND @EndDate
        AND (@Status IS NULL OR str.Status = @Status)
    ORDER BY 
        CASE str.Priority
            WHEN 'Urgent' THEN 1
            WHEN 'High' THEN 2
            WHEN 'Normal' THEN 3
            WHEN 'Low' THEN 4
        END,
        str.RequestDate DESC;
END;
GO

PRINT '✅ sp_Print_TransferRequestReport created';

-- =============================================
-- 6. PRINT ACCOUNTABILITY SUMMARY (Who Did What)
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
    
    -- Summary of all actions by user
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
PRINT '   - sp_Print_TransferRequestReport (Transfer Workflow)';
PRINT '   - sp_Print_AccountabilitySummary (Who Did What)';
PRINT '═══════════════════════════════════════════════';
