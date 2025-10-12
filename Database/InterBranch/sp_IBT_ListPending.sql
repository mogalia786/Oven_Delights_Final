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
    SELECT h.RequestID, 
           fb.BranchName AS FromBranch, 
           tb.BranchName AS ToBranch, 
           h.RequestDate, 
           h.Status,
           l.RequestLineID, 
           COALESCE(p.Name, sp.ProductName, rm.MaterialName, 'Unknown Product') AS ProductName,
           l.Quantity,
           COALESCE(u.FirstName + ' ' + u.LastName, 'Unknown User') AS RequestedBy
    FROM dbo.InterBranchTransferRequestHeader h
    INNER JOIN dbo.InterBranchTransferRequestLine l ON h.RequestID = l.RequestID
    LEFT JOIN dbo.Branches fb ON h.FromBranchID = fb.BranchID
    LEFT JOIN dbo.Branches tb ON h.ToBranchID = tb.BranchID
    LEFT JOIN dbo.Users u ON h.RequestedBy = u.UserID
    LEFT JOIN dbo.Retail_Product p ON l.ProductID = p.ProductID
    LEFT JOIN dbo.Stockroom_Product sp ON l.ProductID = sp.ProductID
    LEFT JOIN dbo.RawMaterials rm ON l.ProductID = rm.MaterialID
    WHERE h.Status = 'Pending' AND h.ToBranchID = @ToBranchID
    ORDER BY h.RequestDate DESC;
END;
