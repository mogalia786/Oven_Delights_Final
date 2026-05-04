-- Create trigger to auto-update TotalQuantity when lines are added/changed
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
