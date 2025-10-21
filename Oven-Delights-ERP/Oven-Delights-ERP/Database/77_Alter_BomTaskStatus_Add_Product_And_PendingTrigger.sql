-- Add ProductID column if missing
IF COL_LENGTH('dbo.BomTaskStatus','ProductID') IS NULL
BEGIN
    ALTER TABLE dbo.BomTaskStatus ADD ProductID int NULL;
END
GO

-- Create trigger to set Pending on BOM (InternalOrderHeader) creation
IF OBJECT_ID('dbo.trg_IOH_Insert_BomTaskStatus_Pending','TR') IS NOT NULL
    DROP TRIGGER dbo.trg_IOH_Insert_BomTaskStatus_Pending;
GO
CREATE TRIGGER dbo.trg_IOH_Insert_BomTaskStatus_Pending
ON dbo.InternalOrderHeader
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH src AS (
        SELECT i.InternalOrderID,
               -- Parse ManufacturerUserID from Notes token ManufacturerUserID=
               TRY_CAST(NULLIF(SUBSTRING(i.Notes, NULLIF(CHARINDEX('ManufacturerUserID=', i.Notes), 0) + LEN('ManufacturerUserID='),
                                 CASE WHEN CHARINDEX(';', i.Notes + ';' , NULLIF(CHARINDEX('ManufacturerUserID=', i.Notes), 0) + LEN('ManufacturerUserID=')) = 0 THEN LEN(i.Notes)
                                      ELSE CHARINDEX(';', i.Notes + ';' , NULLIF(CHARINDEX('ManufacturerUserID=', i.Notes), 0) + LEN('ManufacturerUserID='))
                                           - (NULLIF(CHARINDEX('ManufacturerUserID=', i.Notes), 0) + LEN('ManufacturerUserID=')) END), '') AS int) AS ManufacturerUserID,
               -- Parse ManufacturerName from Notes token ManufacturerName=
               NULLIF(SUBSTRING(i.Notes, NULLIF(CHARINDEX('ManufacturerName=', i.Notes), 0) + LEN('ManufacturerName='),
                                 CASE WHEN CHARINDEX(';', i.Notes + ';' , NULLIF(CHARINDEX('ManufacturerName=', i.Notes), 0) + LEN('ManufacturerName=')) = 0 THEN LEN(i.Notes)
                                      ELSE CHARINDEX(';', i.Notes + ';' , NULLIF(CHARINDEX('ManufacturerName=', i.Notes), 0) + LEN('ManufacturerName='))
                                           - (NULLIF(CHARINDEX('ManufacturerName=', i.Notes), 0) + LEN('ManufacturerName=')) END), '') AS ManufacturerName,
               -- First product from lines, if any
               (
                   SELECT TOP (1) l.ProductID
                   FROM dbo.InternalOrderLines l
                   WHERE l.InternalOrderID = i.InternalOrderID
                   ORDER BY l.LineNumber
               ) AS ProductID,
               N'Pending' AS Status,
               SYSUTCDATETIME() AS UpdatedAtUtc
        FROM inserted i
    )
    MERGE dbo.BomTaskStatus AS tgt
    USING src
      ON tgt.InternalOrderID = src.InternalOrderID
    WHEN MATCHED THEN UPDATE SET
         tgt.ManufacturerUserID = src.ManufacturerUserID,
         tgt.ManufacturerName   = src.ManufacturerName,
         tgt.ProductID          = src.ProductID,
         tgt.Status             = src.Status,
         tgt.UpdatedAtUtc       = src.UpdatedAtUtc
    WHEN NOT MATCHED THEN INSERT (InternalOrderID, ManufacturerUserID, ManufacturerName, ProductID, Status, UpdatedAtUtc)
         VALUES (src.InternalOrderID, src.ManufacturerUserID, src.ManufacturerName, src.ProductID, src.Status, src.UpdatedAtUtc);
END
GO
