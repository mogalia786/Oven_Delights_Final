-- Optional — Backward compatibility shim for legacy references
CREATE OR ALTER VIEW dbo.PurchaseOrderItems AS
SELECT
    pol.PurchaseOrderLineID AS ID,
    pol.PurchaseOrderID AS OrderID,
    pol.MaterialID,
    pol.LineNumber,
    pol.OrderedQuantity AS QuantityOrdered,
    pol.ReceivedQuantity AS QuantityReceived,
    pol.UnitOfMeasure,
    pol.UnitPrice,
    pol.DiscountPercentage,
    pol.LineTotal,
    pol.Status,
    pol.RequiredDate,
    pol.Notes,
    pol.CreatedDate,
    pol.CreatedBy,
    pol.ModifiedDate,
    pol.ModifiedBy
FROM dbo.PurchaseOrderLines pol;
