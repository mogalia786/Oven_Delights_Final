-- Add ManufacturerName to BomTaskStatus and update backfill to populate it
IF COL_LENGTH('dbo.BomTaskStatus','ManufacturerName') IS NULL
BEGIN
    ALTER TABLE dbo.BomTaskStatus ADD ManufacturerName nvarchar(128) NULL;
END
GO

IF OBJECT_ID('dbo.sp_BomTaskStatus_Backfill','P') IS NOT NULL
BEGIN
    EXEC('ALTER PROCEDURE dbo.sp_BomTaskStatus_Backfill
    AS
    BEGIN
        SET NOCOUNT ON;
        ;WITH IO AS (
            SELECT IOH.InternalOrderID,
                   IOH.Notes,
                   CASE IOH.Status WHEN N''Open'' THEN N''Created'' WHEN N''Issued'' THEN N''Fulfilled'' WHEN N''Completed'' THEN N''Completed'' ELSE N''Created'' END AS TaskStatus
            FROM dbo.InternalOrderHeader IOH
        )
        MERGE dbo.BomTaskStatus AS tgt
        USING (
            SELECT i.InternalOrderID,
                   TRY_CAST(NULLIF(SUBSTRING(i.Notes, NULLIF(CHARINDEX(''ManufacturerUserID='', i.Notes), 0) + LEN(''ManufacturerUserID=''),
                                         CASE WHEN CHARINDEX('';'', i.Notes + '';'' , NULLIF(CHARINDEX(''ManufacturerUserID='', i.Notes), 0) + LEN(''ManufacturerUserID='')) = 0 THEN LEN(i.Notes) ELSE CHARINDEX('';'', i.Notes + '';'' , NULLIF(CHARINDEX(''ManufacturerUserID='', i.Notes), 0) + LEN(''ManufacturerUserID='')) - (NULLIF(CHARINDEX(''ManufacturerUserID='', i.Notes), 0) + LEN(''ManufacturerUserID='')) END), '''') AS int) AS ManufacturerUserID,
                   NULLIF(SUBSTRING(i.Notes, NULLIF(CHARINDEX(''ManufacturerName='', i.Notes), 0) + LEN(''ManufacturerName=''),
                                     CASE WHEN CHARINDEX('';'', i.Notes + '';'' , NULLIF(CHARINDEX(''ManufacturerName='', i.Notes), 0) + LEN(''ManufacturerName='')) = 0 THEN LEN(i.Notes) ELSE CHARINDEX('';'', i.Notes + '';'' , NULLIF(CHARINDEX(''ManufacturerName='', i.Notes), 0) + LEN(''ManufacturerName='')) - (NULLIF(CHARINDEX(''ManufacturerName='', i.Notes), 0) + LEN(''ManufacturerName='')) END), '''') AS ManufacturerName,
                   i.TaskStatus,
                   SYSUTCDATETIME() AS UpdatedAtUtc
            FROM IO i
        ) AS src
        ON tgt.InternalOrderID = src.InternalOrderID
        WHEN MATCHED THEN UPDATE SET tgt.ManufacturerUserID = src.ManufacturerUserID, tgt.ManufacturerName = src.ManufacturerName, tgt.Status = src.TaskStatus, tgt.UpdatedAtUtc = src.UpdatedAtUtc
        WHEN NOT MATCHED THEN INSERT (InternalOrderID, ManufacturerUserID, ManufacturerName, Status, UpdatedAtUtc)
             VALUES (src.InternalOrderID, src.ManufacturerUserID, src.ManufacturerName, src.TaskStatus, src.UpdatedAtUtc);
    END');
END
GO
