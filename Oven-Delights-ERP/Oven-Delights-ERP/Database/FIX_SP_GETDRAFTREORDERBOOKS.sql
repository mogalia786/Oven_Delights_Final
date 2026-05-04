-- Fix or create sp_GetDraftReOrderBooks to use Demo_Retail_Product

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_GetDraftReOrderBooks')
BEGIN
    DROP PROCEDURE sp_GetDraftReOrderBooks;
    PRINT 'Dropped existing sp_GetDraftReOrderBooks';
END
GO

CREATE PROCEDURE sp_GetDraftReOrderBooks
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Return ALL draft re-order books for the specified branch
    -- Used by Manufacturer to see all draft orders for their branch
    SELECT 
        rb.ReOrderBookID,
        rb.ReOrderNumber,
        rb.Status,
        rb.OrderDate,
        rb.RequiredDate,
        rb.IsUrgent,
        u.FirstName + ' ' + u.LastName AS ManufacturerName,
        COUNT(DISTINCT rbl.ProductID) AS TotalProducts,
        ISNULL(SUM(rbl.QuantityOrdered), 0) AS TotalQuantity
    FROM ReOrderBooks rb
    LEFT JOIN Users u ON rb.ManufacturerUserID = u.UserID
    LEFT JOIN ReOrderBookLines rbl ON rb.ReOrderBookID = rbl.ReOrderBookID
    WHERE rb.Status = 'Draft'
      AND rb.BranchID = @BranchID
    GROUP BY rb.ReOrderBookID, rb.ReOrderNumber, rb.Status, rb.OrderDate, 
             rb.RequiredDate, rb.IsUrgent, u.FirstName, u.LastName
    ORDER BY rb.OrderDate DESC;
END
GO

PRINT 'Created sp_GetDraftReOrderBooks successfully';
GO
