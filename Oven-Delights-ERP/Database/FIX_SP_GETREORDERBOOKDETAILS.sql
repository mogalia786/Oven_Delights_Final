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
    
    -- Return header info
    SELECT 
        rb.ReOrderBookID,
        rb.ReOrderNumber,
        rb.Status,
        rb.OrderDate,
        rb.Notes,
        rb.IsUrgent,
        u.FirstName + ' ' + u.LastName AS BakerName,
        COUNT(DISTINCT rbl.ProductID) AS TotalProducts,
        SUM(rbl.QuantityOrdered) AS TotalQuantity
    FROM ReOrderBooks rb
    LEFT JOIN Users u ON rb.ManufacturerUserID = u.UserID
    LEFT JOIN ReOrderBookLines rbl ON rb.ReOrderBookID = rbl.ReOrderBookID
    WHERE rb.ReOrderBookID = @ReOrderBookID
    GROUP BY rb.ReOrderBookID, rb.ReOrderNumber, rb.Status, rb.OrderDate, 
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
