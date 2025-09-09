/*
Trigger: tr_BomTaskStatus_Pending_OnIssue
Goal: When Stockroom fulfills/issues an Internal Order (IOH.Status becomes 'Fulfilled'),
      ensure a corresponding BomTaskStatus row exists with Status='Pending'.
Notes:
- Manufacturer fields may be NULL at this point; UI can update them later.
- This complements app logic in InternalOrdersForm.OnFulfill(), acting as a safety net.
*/
IF OBJECT_ID('dbo.tr_BomTaskStatus_Pending_OnIssue', 'TR') IS NOT NULL
    DROP TRIGGER dbo.tr_BomTaskStatus_Pending_OnIssue;
GO
CREATE TRIGGER dbo.tr_BomTaskStatus_Pending_OnIssue
ON dbo.InternalOrderHeader
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT UPDATE(Status) RETURN;

    ;WITH toIssue AS (
        SELECT i.InternalOrderID
        FROM inserted i
        WHERE i.Status = N'Fulfilled' -- Stockroom marks issued IO as 'Fulfilled' (Fulfill stage)
    )
    MERGE dbo.BomTaskStatus AS tgt
    USING toIssue AS src
      ON tgt.InternalOrderID = src.InternalOrderID
    WHEN MATCHED THEN
        UPDATE SET tgt.Status = N'Pending',
                   tgt.UpdatedAtUtc = SYSUTCDATETIME()
    WHEN NOT MATCHED THEN
        INSERT (InternalOrderID, Status, UpdatedAtUtc)
        VALUES (src.InternalOrderID, N'Pending', SYSUTCDATETIME());
END
GO

-- Optional supporting index (uncomment if needed)
-- CREATE INDEX IX_BomTaskStatus_InternalOrderID ON dbo.BomTaskStatus(InternalOrderID) INCLUDE(Status, UpdatedAtUtc);
