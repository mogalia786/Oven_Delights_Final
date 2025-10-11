-- GRV System Reporting Stored Procedures
-- Comprehensive reporting for GRV management and analysis

SET NOCOUNT ON;

-- Drop existing procedures
IF OBJECT_ID('dbo.sp_GRV_Summary_Report','P') IS NOT NULL DROP PROCEDURE dbo.sp_GRV_Summary_Report;
IF OBJECT_ID('dbo.sp_GRV_Variance_Report','P') IS NOT NULL DROP PROCEDURE dbo.sp_GRV_Variance_Report;
IF OBJECT_ID('dbo.sp_GRV_Outstanding_Report','P') IS NOT NULL DROP PROCEDURE dbo.sp_GRV_Outstanding_Report;
IF OBJECT_ID('dbo.sp_CreditNote_Summary_Report','P') IS NOT NULL DROP PROCEDURE dbo.sp_CreditNote_Summary_Report;
IF OBJECT_ID('dbo.sp_GRV_Supplier_Performance','P') IS NOT NULL DROP PROCEDURE dbo.sp_GRV_Supplier_Performance;
GO

-- GRV Summary Report
CREATE PROCEDURE dbo.sp_GRV_Summary_Report
    @DateFrom DATE = NULL,
    @DateTo DATE = NULL,
    @SupplierID INT = NULL,
    @BranchID INT = NULL,
    @Status NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Default date range if not provided
    IF @DateFrom IS NULL SET @DateFrom = DATEADD(MONTH, -1, GETDATE());
    IF @DateTo IS NULL SET @DateTo = GETDATE();
    
    SELECT 
        grv.GRVID,
        grv.GRVNumber,
        grv.ReceivedDate,
        grv.Status,
        s.SupplierName,
        b.BranchName,
        po.PONumber,
        grv.DeliveryNoteNumber,
        grv.SubTotal,
        grv.VATAmount,
        grv.TotalAmount,
        u.FirstName + ' ' + u.LastName AS ReceivedBy,
        
        -- Line item counts
        (SELECT COUNT(*) FROM GRVLines gl WHERE gl.GRVID = grv.GRVID) AS LineItemCount,
        
        -- Quality summary
        (SELECT COUNT(*) FROM GRVLines gl WHERE gl.GRVID = grv.GRVID AND gl.QualityStatus = 'Passed') AS PassedItems,
        (SELECT COUNT(*) FROM GRVLines gl WHERE gl.GRVID = grv.GRVID AND gl.QualityStatus = 'Failed') AS FailedItems,
        (SELECT COUNT(*) FROM GRVLines gl WHERE gl.GRVID = grv.GRVID AND gl.QualityStatus = 'Partial') AS PartialItems,
        
        -- Matching status
        CASE 
            WHEN EXISTS (SELECT 1 FROM GRVInvoiceMatching gim WHERE gim.GRVID = grv.GRVID) THEN 'Matched'
            ELSE 'Unmatched'
        END AS MatchingStatus,
        
        -- Credit notes
        ISNULL((SELECT COUNT(*) FROM CreditNotes cn WHERE cn.GRVID = grv.GRVID), 0) AS CreditNoteCount,
        ISNULL((SELECT SUM(cn.TotalAmount) FROM CreditNotes cn WHERE cn.GRVID = grv.GRVID), 0) AS TotalCreditAmount
        
    FROM GoodsReceivedVouchers grv
    LEFT JOIN Suppliers s ON grv.SupplierID = s.SupplierID
    LEFT JOIN Branches b ON grv.BranchID = b.BranchID
    LEFT JOIN PurchaseOrders po ON grv.PurchaseOrderID = po.PurchaseOrderID
    LEFT JOIN Users u ON grv.ReceivedBy = u.UserID
    
    WHERE grv.ReceivedDate BETWEEN @DateFrom AND @DateTo
    AND (@SupplierID IS NULL OR grv.SupplierID = @SupplierID)
    AND (@BranchID IS NULL OR grv.BranchID = @BranchID)
    AND (@Status IS NULL OR grv.Status = @Status)
    
    ORDER BY grv.ReceivedDate DESC, grv.GRVNumber;
END
GO

-- GRV Variance Report
CREATE PROCEDURE dbo.sp_GRV_Variance_Report
    @DateFrom DATE = NULL,
    @DateTo DATE = NULL,
    @SupplierID INT = NULL,
    @MinVarianceAmount DECIMAL(18,2) = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Default date range if not provided
    IF @DateFrom IS NULL SET @DateFrom = DATEADD(MONTH, -1, GETDATE());
    IF @DateTo IS NULL SET @DateTo = GETDATE();
    
    SELECT 
        grv.GRVNumber,
        grv.ReceivedDate,
        s.SupplierName,
        po.PONumber,
        i.InvoiceNumber,
        gim.MatchedQuantity,
        gim.MatchedAmount,
        gim.VarianceQuantity,
        gim.VarianceAmount,
        gim.MatchingStatus,
        gim.VarianceReason,
        
        -- Item details
        COALESCE(rm.MaterialName, p.Name, sp.Name) AS ItemName,
        COALESCE(rm.MaterialCode, p.SKU, sp.Code) AS ItemCode,
        
        -- GRV vs Invoice comparison
        gl.AcceptedQuantity AS GRVQuantity,
        il.Quantity AS InvoiceQuantity,
        gl.UnitCost AS GRVUnitCost,
        il.UnitPrice AS InvoiceUnitPrice,
        
        -- Calculated variances
        (il.Quantity - gl.AcceptedQuantity) AS QuantityDifference,
        (il.UnitPrice - gl.UnitCost) AS PriceDifference,
        ((il.Quantity * il.UnitPrice) - (gl.AcceptedQuantity * gl.UnitCost)) AS TotalDifference
        
    FROM GRVInvoiceMatching gim
    INNER JOIN GoodsReceivedVouchers grv ON gim.GRVID = grv.GRVID
    INNER JOIN Suppliers s ON grv.SupplierID = s.SupplierID
    INNER JOIN PurchaseOrders po ON grv.PurchaseOrderID = po.PurchaseOrderID
    INNER JOIN Invoices i ON gim.InvoiceID = i.InvoiceID
    LEFT JOIN GRVLines gl ON gim.GRVLineID = gl.GRVLineID
    LEFT JOIN InvoiceLines il ON gim.InvoiceLineID = il.InvoiceLineID
    LEFT JOIN RawMaterials rm ON gl.MaterialID = rm.MaterialID
    LEFT JOIN Products p ON gl.ProductID = p.ProductID
    LEFT JOIN Stockroom_Product sp ON gl.ProductID = sp.ProductID
    
    WHERE grv.ReceivedDate BETWEEN @DateFrom AND @DateTo
    AND (@SupplierID IS NULL OR grv.SupplierID = @SupplierID)
    AND (ABS(gim.VarianceAmount) >= @MinVarianceAmount OR gim.MatchingStatus = 'Variance')
    
    ORDER BY ABS(gim.VarianceAmount) DESC, grv.ReceivedDate DESC;
END
GO

-- Outstanding GRVs Report
CREATE PROCEDURE dbo.sp_GRV_Outstanding_Report
    @BranchID INT = NULL,
    @SupplierID INT = NULL,
    @DaysOld INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CutoffDate DATE = DATEADD(DAY, -@DaysOld, GETDATE());
    
    SELECT 
        grv.GRVNumber,
        grv.ReceivedDate,
        DATEDIFF(DAY, grv.ReceivedDate, GETDATE()) AS DaysOld,
        grv.Status,
        s.SupplierName,
        b.BranchName,
        po.PONumber,
        grv.TotalAmount,
        
        -- Outstanding actions
        CASE 
            WHEN grv.Status = 'Draft' THEN 'Complete receiving process'
            WHEN grv.Status = 'Received' AND NOT EXISTS (SELECT 1 FROM GRVInvoiceMatching gim WHERE gim.GRVID = grv.GRVID) THEN 'Match to invoice'
            WHEN grv.Status = 'Matched' AND EXISTS (SELECT 1 FROM GRVInvoiceMatching gim WHERE gim.GRVID = grv.GRVID AND gim.MatchingStatus = 'Variance') THEN 'Resolve variances'
            ELSE 'Review status'
        END AS RequiredAction,
        
        -- Quality issues
        (SELECT COUNT(*) FROM GRVLines gl WHERE gl.GRVID = grv.GRVID AND gl.QualityStatus = 'Failed') AS QualityIssues,
        
        -- Variance summary
        ISNULL((SELECT SUM(ABS(gim.VarianceAmount)) FROM GRVInvoiceMatching gim WHERE gim.GRVID = grv.GRVID), 0) AS TotalVarianceAmount
        
    FROM GoodsReceivedVouchers grv
    LEFT JOIN Suppliers s ON grv.SupplierID = s.SupplierID
    LEFT JOIN Branches b ON grv.BranchID = b.BranchID
    LEFT JOIN PurchaseOrders po ON grv.PurchaseOrderID = po.PurchaseOrderID
    
    WHERE grv.Status NOT IN ('Closed', 'Cancelled')
    AND grv.ReceivedDate <= @CutoffDate
    AND (@BranchID IS NULL OR grv.BranchID = @BranchID)
    AND (@SupplierID IS NULL OR grv.SupplierID = @SupplierID)
    
    ORDER BY DATEDIFF(DAY, grv.ReceivedDate, GETDATE()) DESC, grv.TotalAmount DESC;
END
GO

-- Credit Note Summary Report
CREATE PROCEDURE dbo.sp_CreditNote_Summary_Report
    @DateFrom DATE = NULL,
    @DateTo DATE = NULL,
    @SupplierID INT = NULL,
    @Status NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Default date range if not provided
    IF @DateFrom IS NULL SET @DateFrom = DATEADD(MONTH, -1, GETDATE());
    IF @DateTo IS NULL SET @DateTo = GETDATE();
    
    SELECT 
        cn.CreditNoteNumber,
        cn.CreditDate,
        cn.RequestedDate,
        cn.Status,
        cn.CreditType,
        cn.CreditReason,
        s.SupplierName,
        b.BranchName,
        grv.GRVNumber,
        cn.SubTotal,
        cn.VATAmount,
        cn.TotalAmount,
        
        -- Approval details
        cn.ApprovedDate,
        CASE WHEN cn.ApprovedBy IS NOT NULL THEN au.FirstName + ' ' + au.LastName ELSE NULL END AS ApprovedBy,
        cn.ProcessedDate,
        
        -- Line item summary
        (SELECT COUNT(*) FROM CreditNoteLines cnl WHERE cnl.CreditNoteID = cn.CreditNoteID) AS LineItemCount,
        
        -- Aging
        CASE 
            WHEN cn.Status = 'Requested' THEN DATEDIFF(DAY, cn.RequestedDate, GETDATE())
            WHEN cn.Status = 'Approved' THEN DATEDIFF(DAY, cn.ApprovedDate, GETDATE())
            ELSE 0
        END AS DaysInStatus
        
    FROM CreditNotes cn
    LEFT JOIN Suppliers s ON cn.SupplierID = s.SupplierID
    LEFT JOIN Branches b ON cn.BranchID = b.BranchID
    LEFT JOIN GoodsReceivedVouchers grv ON cn.GRVID = grv.GRVID
    LEFT JOIN Users au ON cn.ApprovedBy = au.UserID
    
    WHERE cn.CreditDate BETWEEN @DateFrom AND @DateTo
    AND (@SupplierID IS NULL OR cn.SupplierID = @SupplierID)
    AND (@Status IS NULL OR cn.Status = @Status)
    
    ORDER BY cn.CreditDate DESC, cn.CreditNoteNumber;
END
GO

-- Supplier Performance Report
CREATE PROCEDURE dbo.sp_GRV_Supplier_Performance
    @DateFrom DATE = NULL,
    @DateTo DATE = NULL,
    @SupplierID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Default date range if not provided
    IF @DateFrom IS NULL SET @DateFrom = DATEADD(MONTH, -3, GETDATE());
    IF @DateTo IS NULL SET @DateTo = GETDATE();
    
    SELECT 
        s.SupplierID,
        s.SupplierName,
        
        -- GRV Statistics
        COUNT(DISTINCT grv.GRVID) AS TotalGRVs,
        SUM(grv.TotalAmount) AS TotalGRVValue,
        AVG(grv.TotalAmount) AS AverageGRVValue,
        
        -- Quality Performance
        SUM(CASE WHEN gl.QualityStatus = 'Passed' THEN 1 ELSE 0 END) AS PassedItems,
        SUM(CASE WHEN gl.QualityStatus = 'Failed' THEN 1 ELSE 0 END) AS FailedItems,
        SUM(CASE WHEN gl.QualityStatus = 'Partial' THEN 1 ELSE 0 END) AS PartialItems,
        COUNT(gl.GRVLineID) AS TotalItems,
        
        -- Quality Percentages
        CASE WHEN COUNT(gl.GRVLineID) > 0 
             THEN CAST(SUM(CASE WHEN gl.QualityStatus = 'Passed' THEN 1 ELSE 0 END) * 100.0 / COUNT(gl.GRVLineID) AS DECIMAL(5,2))
             ELSE 0 END AS QualityPassRate,
        
        -- Variance Performance
        COUNT(DISTINCT gim.MatchingID) AS MatchedItems,
        SUM(CASE WHEN gim.MatchingStatus = 'Variance' THEN 1 ELSE 0 END) AS VarianceItems,
        SUM(ABS(ISNULL(gim.VarianceAmount, 0))) AS TotalVarianceAmount,
        
        -- Credit Notes
        COUNT(DISTINCT cn.CreditNoteID) AS CreditNoteCount,
        SUM(ISNULL(cn.TotalAmount, 0)) AS TotalCreditAmount,
        
        -- Delivery Performance
        AVG(CASE WHEN grv.DeliveryDate IS NOT NULL AND po.RequiredDate IS NOT NULL 
                 THEN DATEDIFF(DAY, po.RequiredDate, grv.DeliveryDate) 
                 ELSE NULL END) AS AverageDeliveryDelay,
        
        -- Overall Score (0-100)
        CASE WHEN COUNT(gl.GRVLineID) > 0 THEN
            CAST((
                (SUM(CASE WHEN gl.QualityStatus = 'Passed' THEN 1 ELSE 0 END) * 40.0 / COUNT(gl.GRVLineID)) +
                (CASE WHEN COUNT(DISTINCT gim.MatchingID) > 0 
                      THEN (COUNT(DISTINCT gim.MatchingID) - SUM(CASE WHEN gim.MatchingStatus = 'Variance' THEN 1 ELSE 0 END)) * 30.0 / COUNT(DISTINCT gim.MatchingID)
                      ELSE 30 END) +
                (CASE WHEN COUNT(DISTINCT grv.GRVID) > 0 
                      THEN (COUNT(DISTINCT grv.GRVID) - COUNT(DISTINCT cn.CreditNoteID)) * 30.0 / COUNT(DISTINCT grv.GRVID)
                      ELSE 30 END)
            ) AS DECIMAL(5,2))
        ELSE 0 END AS PerformanceScore
        
    FROM Suppliers s
    LEFT JOIN GoodsReceivedVouchers grv ON s.SupplierID = grv.SupplierID
    LEFT JOIN GRVLines gl ON grv.GRVID = gl.GRVID
    LEFT JOIN GRVInvoiceMatching gim ON gl.GRVLineID = gim.GRVLineID
    LEFT JOIN CreditNotes cn ON grv.GRVID = cn.GRVID
    LEFT JOIN PurchaseOrders po ON grv.PurchaseOrderID = po.PurchaseOrderID
    
    WHERE (@DateFrom IS NULL OR grv.ReceivedDate >= @DateFrom)
    AND (@DateTo IS NULL OR grv.ReceivedDate <= @DateTo)
    AND (@SupplierID IS NULL OR s.SupplierID = @SupplierID)
    AND grv.GRVID IS NOT NULL  -- Only suppliers with GRVs in date range
    
    GROUP BY s.SupplierID, s.SupplierName
    
    ORDER BY PerformanceScore DESC, TotalGRVValue DESC;
END
GO

PRINT 'GRV Reporting stored procedures created successfully';
