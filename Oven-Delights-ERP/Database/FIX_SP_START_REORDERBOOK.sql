-- Fix sp_StartReOrderBook to use correct status (Pending instead of In Production)
CREATE OR ALTER PROCEDURE sp_StartReOrderBook
    @ReOrderBookID INT,
    @StartedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE ReOrderBooks
    SET Status = 'Pending',
        StartedDate = GETDATE(),
        StartedBy = @StartedBy
    WHERE ReOrderBookID = @ReOrderBookID
END
GO
