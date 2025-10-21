-- Create table to track BOM task status per InternalOrder and Manufacturer
-- Status flow: Created -> Fulfilled -> Completed
IF OBJECT_ID('dbo.BomTaskStatus','U') IS NULL
BEGIN
    CREATE TABLE dbo.BomTaskStatus (
        InternalOrderID      int           NOT NULL,
        ManufacturerUserID   int           NULL,
        Status               nvarchar(20)  NOT NULL, -- Created, Fulfilled, Completed
        UpdatedAtUtc         datetime2(3)  NOT NULL CONSTRAINT DF_BomTaskStatus_UpdatedAtUtc DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_BomTaskStatus PRIMARY KEY CLUSTERED (InternalOrderID)
    );

    CREATE INDEX IX_BomTaskStatus_Status ON dbo.BomTaskStatus (Status);
    CREATE INDEX IX_BomTaskStatus_Manufacturer ON dbo.BomTaskStatus (ManufacturerUserID);
END
GO

-- Optional: backfill helper (idempotent) - maps IOH.Status to task status
-- Open -> Created, Issued -> Fulfilled, Completed -> Completed
IF OBJECT_ID('dbo.sp_BomTaskStatus_Backfill','P') IS NULL
EXEC('CREATE PROCEDURE dbo.sp_BomTaskStatus_Backfill AS BEGIN SET NOCOUNT ON; END');
GO
ALTER PROCEDURE dbo.sp_BomTaskStatus_Backfill
AS
BEGIN
    SET NOCOUNT ON;
    ;WITH IO AS (
        SELECT IOH.InternalOrderID,
               IOH.Notes,
               CASE IOH.Status WHEN N'Open' THEN N'Created' WHEN N'Issued' THEN N'Fulfilled' WHEN N'Completed' THEN N'Completed' ELSE N'Created' END AS TaskStatus
        FROM dbo.InternalOrderHeader IOH
    )
    MERGE dbo.BomTaskStatus AS tgt
    USING (
        SELECT i.InternalOrderID,
               TRY_CAST(NULLIF(SUBSTRING(i.Notes, NULLIF(CHARINDEX('ManufacturerUserID=', i.Notes), 0) + LEN('ManufacturerUserID='),
                                 CASE WHEN CHARINDEX(';', i.Notes + ';' , NULLIF(CHARINDEX('ManufacturerUserID=', i.Notes), 0) + LEN('ManufacturerUserID=')) = 0 THEN LEN(i.Notes) ELSE CHARINDEX(';', i.Notes + ';' , NULLIF(CHARINDEX('ManufacturerUserID=', i.Notes), 0) + LEN('ManufacturerUserID=')) - (NULLIF(CHARINDEX('ManufacturerUserID=', i.Notes), 0) + LEN('ManufacturerUserID=')) END), '') AS int) AS ManufacturerUserID,
               i.TaskStatus,
               SYSUTCDATETIME() AS UpdatedAtUtc
        FROM IO i
    ) AS src
    ON tgt.InternalOrderID = src.InternalOrderID
    WHEN MATCHED THEN UPDATE SET tgt.ManufacturerUserID = src.ManufacturerUserID, tgt.Status = src.TaskStatus, tgt.UpdatedAtUtc = src.UpdatedAtUtc
    WHEN NOT MATCHED THEN INSERT (InternalOrderID, ManufacturerUserID, Status, UpdatedAtUtc)
         VALUES (src.InternalOrderID, src.ManufacturerUserID, src.TaskStatus, src.UpdatedAtUtc);
END
GO
