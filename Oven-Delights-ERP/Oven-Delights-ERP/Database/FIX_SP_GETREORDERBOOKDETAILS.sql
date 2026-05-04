-- Fix or create sp_GetReOrderBookDetails to use Demo_Retail_Product

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_GetReOrderBookDetails')
BEGIN
    DROP PROCEDURE sp_GetReOrderBookDetails;
    PRINT 'Dropped existing sp_GetReOrderBookDetails';
END
GO

CREATE PROCEDURE sp_GetReOrderBookDetails
    @ReOrderBookID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Set BOM status to Not Requested (InternalOrderHeader columns not matching)
    DECLARE @BOMStatus NVARCHAR(20) = 'Not Requested';
    DECLARE @BOMRequestedDate DATETIME = NULL;
    DECLARE @BOMFulfilledDate DATETIME = NULL;
    
    -- Return header info
    SELECT 
        rb.ReOrderBookID,
        rb.ReOrderNumber,
        rb.Status,
        rb.OrderDate,
        rb.CreatedDate,
        rb.PostedDate,
        rb.CompletedDate,
        rb.Notes,
        rb.IsUrgent,
        u.FirstName + ' ' + u.LastName AS BakerName,
        COUNT(DISTINCT rbl.ProductID) AS TotalProducts,
        SUM(rbl.QuantityOrdered) AS TotalQuantity,
        @BOMStatus AS BOMStatus,
        @BOMRequestedDate AS BOMRequestedDate,
        @BOMFulfilledDate AS BOMFulfilledDate
    FROM ReOrderBooks rb
    LEFT JOIN Users u ON rb.ManufacturerUserID = u.UserID
    LEFT JOIN ReOrderBookLines rbl ON rb.ReOrderBookID = rbl.ReOrderBookID
    WHERE rb.ReOrderBookID = @ReOrderBookID
    GROUP BY rb.ReOrderBookID, rb.ReOrderNumber, rb.Status, rb.OrderDate, rb.CreatedDate, rb.PostedDate, rb.CompletedDate,
             rb.Notes, rb.IsUrgent, u.FirstName, u.LastName;
    
    -- Return product lines
    SELECT 
        rbl.ReOrderLineID,
        rbl.LineNumber,
        rbl.ProductID,
        p.Name AS ProductName,
        ISNULL(p.Code, p.SKU) AS SKU,
        rbl.QuantityOrdered,
        ISNULL(rbl.QuantityCompleted, 0) AS QuantityCompleted,
        rbl.CompletedDate,
        CASE 
            WHEN ISNULL(rbl.QuantityCompleted, 0) >= rbl.QuantityOrdered THEN 'Completed'
            WHEN ISNULL(rbl.QuantityCompleted, 0) > 0 THEN 'InProgress'
            ELSE 'Pending'
        END AS LineStatus
    FROM ReOrderBookLines rbl
    INNER JOIN Demo_Retail_Product p ON rbl.ProductID = p.ProductID
    WHERE rbl.ReOrderBookID = @ReOrderBookID
    ORDER BY rbl.LineNumber;
END
GO

PRINT 'Created sp_GetReOrderBookDetails successfully';
GO
