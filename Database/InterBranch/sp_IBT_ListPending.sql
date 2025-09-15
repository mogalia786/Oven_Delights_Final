-- sp_IBT_ListPending: List pending requests for a given ToBranchID
SET NOCOUNT ON;
GO
IF OBJECT_ID('dbo.sp_IBT_ListPending','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.sp_IBT_ListPending AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.sp_IBT_ListPending
    @ToBranchID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT h.RequestID, h.FromBranchID, h.ToBranchID, h.RequestDate, h.Status,
           l.RequestLineID, l.ProductID, l.VariantID, l.Quantity
    FROM dbo.InterBranchTransferRequestHeader h
    INNER JOIN dbo.InterBranchTransferRequestLine l ON h.RequestID = l.RequestID
    WHERE h.Status = 'Pending' AND h.ToBranchID = @ToBranchID
    ORDER BY h.RequestDate DESC;
END;
