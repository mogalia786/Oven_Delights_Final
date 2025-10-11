-- sp_IBT_Create: Create Inter-Branch Transfer from Request
SET NOCOUNT ON;
GO
IF OBJECT_ID('dbo.sp_IBT_Create','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.sp_IBT_Create AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.sp_IBT_Create
    @RequestID INT,
    @CreatedBy INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FromBranchID INT, @ToBranchID INT;
    SELECT @FromBranchID = FromBranchID, @ToBranchID = ToBranchID
    FROM dbo.InterBranchTransferRequestHeader WHERE RequestID=@RequestID;

    IF @FromBranchID IS NULL OR @ToBranchID IS NULL
    BEGIN
        RAISERROR('Invalid RequestID', 16, 1);
        RETURN;
    END

    INSERT INTO dbo.InterBranchTransferHeader(RequestID, FromBranchID, ToBranchID, Status, CreatedBy)
    VALUES(@RequestID, @FromBranchID, @ToBranchID, 'Draft', @CreatedBy);

    DECLARE @TransferID INT = SCOPE_IDENTITY();

    INSERT INTO dbo.InterBranchTransferLine(TransferID, ProductID, VariantID, Quantity)
    SELECT @TransferID, l.ProductID, l.VariantID, l.Quantity
    FROM dbo.InterBranchTransferRequestLine l
    WHERE l.RequestID = @RequestID;

    SELECT @TransferID AS TransferID;
END;
