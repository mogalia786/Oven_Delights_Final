/*
Purpose: Centralize manufacturing pending BOMs (issued by Stockroom, not yet completed)
This view mirrors the Stockroom dashboard "pending to MFG" query pattern and exposes BranchID
via IOH.ToLocationID -> InventoryLocations.BranchID, plus manufacturer fields for grouping.
*/
IF OBJECT_ID('dbo.v_MfgPendingFromStockroom', 'V') IS NOT NULL
    DROP VIEW dbo.v_MfgPendingFromStockroom;
GO
CREATE VIEW dbo.v_MfgPendingFromStockroom
AS
SELECT
    IOH.InternalOrderID,
    IOH.InternalOrderNo,
    IOH.RequestedDate,
    ISNULL(IOH.Notes, N'') AS Notes,
    COALESCE(u.FirstName + N' ' + u.LastName, N'-') AS RequestedByName,
    bts.Status AS EffStatus,
    ISNULL(bts.ManufacturerUserID, 0) AS ManufacturerUserID,
    ISNULL(bts.ManufacturerName, N'Unassigned') AS ManufacturerName,
    locTo.BranchID
FROM dbo.InternalOrderHeader IOH
JOIN dbo.BomTaskStatus bts
  ON bts.InternalOrderID = IOH.InternalOrderID
JOIN dbo.InventoryLocations locTo
  ON locTo.LocationID = IOH.ToLocationID
LEFT JOIN dbo.Users u
  ON u.UserID = IOH.RequestedBy
WHERE bts.Status = N'Pending';
GO

-- Helpful indexes (optional): ensure lookups by InternalOrderID and BranchID are fast
-- CREATE INDEX IX_BomTaskStatus_InternalOrderID_Status ON dbo.BomTaskStatus(InternalOrderID, Status) INCLUDE(ManufacturerUserID, ManufacturerName);
-- CREATE INDEX IX_InventoryLocations_LocationID ON dbo.InventoryLocations(LocationID) INCLUDE(BranchID);
