-- Fix sp_StartReOrderBook to use correct status
CREATE OR ALTER PROCEDURE sp_StartReOrderBook
    @ReOrderBookID INT,
    @StartedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE ReOrderBooks
    SET Status = 'In Production',
        StartedDate = GETDATE(),
        StartedBy = @StartedBy
    WHERE ReOrderBookID = @ReOrderBookID
END
GO
