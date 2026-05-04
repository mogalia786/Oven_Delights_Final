-- Don't alter sp_CreateReOrderBook - it's working fine
-- Just create a trigger to update TotalQuantity when lines are added

CREATE OR ALTER TRIGGER trg_UpdateReOrderBookTotals
ON ReOrderBookLines
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Update totals for affected re-order books
    UPDATE rob
    SET rob.TotalProducts = ISNULL((
            SELECT COUNT(*)
            FROM ReOrderBookLines rol
            WHERE rol.ReOrderBookID = rob.ReOrderBookID
        ), 0),
        rob.TotalQuantity = ISNULL((
            SELECT SUM(rol.QuantityOrdered)
            FROM ReOrderBookLines rol
            WHERE rol.ReOrderBookID = rob.ReOrderBookID
        ), 0)
    FROM ReOrderBooks rob
    WHERE rob.ReOrderBookID IN (
        SELECT DISTINCT ReOrderBookID FROM inserted
        UNION
        SELECT DISTINCT ReOrderBookID FROM deleted
    )
END
GO

-- Fix sp_AddReOrderBookLine to update TotalQuantity
CREATE OR ALTER PROCEDURE sp_AddReOrderBookLine
    @ReOrderBookID INT,
    @ProductID INT,
    @QuantityOrdered DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Insert line
    INSERT INTO ReOrderBookLines (ReOrderBookID, ProductID, QuantityOrdered, LineStatus)
    SELECT @ReOrderBookID, @ProductID, @QuantityOrdered, 'Pending'
    
    -- Update totals
    UPDATE ReOrderBooks
    SET TotalProducts = (SELECT COUNT(*) FROM ReOrderBookLines WHERE ReOrderBookID = @ReOrderBookID),
        TotalQuantity = (SELECT SUM(QuantityOrdered) FROM ReOrderBookLines WHERE ReOrderBookID = @ReOrderBookID)
    WHERE ReOrderBookID = @ReOrderBookID
END
GO
